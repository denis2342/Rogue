
lz4_frame_error:
;	illegal
	PEA	blub1(PC)	;"lz4_frame_error"
	JSR	_db_print
	ADDQ.W	#4,A7
	MOVEQ	#-$01,D0

	BRA	L00B1A

blub1:	dc.b	"lz4_frame_error",10,0,0

lz4_frame_depack:
	cmpi.l	#$04224d18,(a0)+	; LZ4 frame MagicNb
	bne.s	lz4_frame_error

	move.b	(a0),d0
	andi.b	#%11000001,d0		; check version, no depacked size, and no DictID
	cmpi.b	#%01000000,d0
	bne.s	lz4_frame_error

	btst	#3,(a0)	;skip 8 bytes if content-size bit is set
	beq	1$
	addq.l	#8,a0

1$	; read 32bits block size without movep (little endian)
	; even faster byte order reversal

	move.b	4(a0),d0	;0004
	swap	d0		;0400	4
	move.b	6(a0),d0	;0406
	lsl.l	#8,d0		;4060	8 + 16
	move.b	5(a0),d0	;4065
	swap	d0		;6540	4
	move.b	3(a0),d0	;6543

	lea	7(a0),a0	; skip LZ4 block header + packed data size

; input: a0.l : packed buffer
;		 a1.l : output buffer
;		 d0.l : LZ4 packed block size (in bytes)

lz4_depack:	lea	0(a0,d0.l),a2	; packed buffer end
		moveq	#0,d0
		moveq	#0,d2
		moveq	#15,d4

.tokenLoop:	move.b	(a0)+,d0	;read the token
		move.l	d0,d1
		lsr.b	#4,d1
		beq.s	.lenOffset	;have we literals to copy?

		bsr.s	.readLen

		subq.w	#1,d1

.litcopy:	move.b	(a0)+,(a1)+	; block could be > 64KiB
		dbra	d1,.litcopy

		; end test is always done just after literals
		cmpa.l	a0,a2
		ble.s	.readEnd

		and.b	d4,d0

.lenOffset:	move.b	(a0)+,d2	; read 16bits offset, little endian, unaligned
		move.b	(a0)+,-(a7)
		move.w	(a7)+,d1
		move.b	d2,d1
		movea.l	a1,a3
		sub.l	d1,a3		; d1 bits 31..16 are always 0 here

		move.w	d0,d1

		bsr.s	.readLen

		addq.l	#4-1,d1		;-1 because of dbra

.copy:		move.b	(a3)+,(a1)+	; block could be > 64KiB
		dbra	d1,.copy

		bra.s	.tokenLoop

.readLen:	cmp.b	d1,d4
		bne.s	.readEnd
.readLoop:	move.b	(a0)+,d2
		add.l	d2,d1		; final len could be > 64KiB
		not.b	d2
		beq.s	.readLoop
.readEnd:	rts

tmpbuf:		dc.l	0

_show_ilbm:
	LINK	A5,#-$0000
	MOVEM.L	D4-D7/a2-a3,-(A7)

	CLR.W	-(A7)
	MOVE.L	$0008(A5),-(A7)	;filename
	JSR	_AmigaOpen(PC)
	ADDQ.W	#6,A7
	MOVE.W	D0,D6		;filehandle
	BGE.B	L00B1B

	MOVE.L	$0008(A5),-(A7)	;filename
	PEA	L00B1D(PC)	;"Couldn't open %s"
	JSR	_db_print
	ADDQ.W	#8,A7
	MOVEQ	#-$01,D0
L00B1A
	move.l	tmpbuf,-(a7)
	jsr	_free
	ADDQ.W	#4,A7

	MOVEM.L	(A7)+,D4-D7/a2-a3
	UNLK	A5
	RTS

L00B1B:
	move.w	#45000,-(a7)
	JSR	_newmem
	ADDQ.W	#2,A7
	move.l	d0,d7

	MOVE.W	#45000,-(A7)
	move.l	d0,-(a7)
	MOVE.W	D6,-(A7)	;filehandle
	JSR	_read
	ADDQ.W	#8,A7

	MOVE.W	D6,-(A7)	;filehandle
	JSR	_close
	ADDQ.W	#2,A7

	move.l	#64064,-(a7)
	JSR	_lmalloc
	ADDQ.W	#4,A7
	move.l	d0,tmpbuf

	move.l	d0,a1
	move.l	d7,a0
	bsr	lz4_frame_depack

	move.l	d7,-(a7)
	jsr	_free
	ADDQ.W	#4,A7

	move.l	tmpbuf,a0
	bsr	reversetitle

	MOVE.l	#16000,D5	;load 16kb at once
	MOVEQ	#4-1,D4

	MOVEA.L	$000C(A5),A3	;screen
	MOVEA.L	$0032(A3),A3	;get the rastport
	MOVEA.L	$0004(A3),A3	;get the bitmap
	addq.l	#8,A3

	add.l	#64,tmpbuf
loop2$
	; we load the data directly into the bitmap planes

	MOVE.l	D5,d0	;length
	move.l	(a3)+,a1	;get the planes
	move.l	tmpbuf,a0

	MOVEA.L	$0004,A6
	jsr	_LVOCopyMemQuick(a6)
	add.l	d5,tmpbuf

	DBRA	D4,loop2$

	sub.l	#64064,tmpbuf

	MOVE.W	$0010(A5),-(A7)
	move.l	tmpbuf,-(a7)
	BSR	_fade_in
	ADDQ.W	#6,A7

	BRA.B	L00B1A

reversetitle:
	tst.b	_all_clear(A4)	;_all_clear
	beq	1$

	moveq	#16-1,d2	;turn the color for the title.screen
loop$	move.b	(a0),d1
	move.b	2(a0),(a0)
	move.b	d1,2(a0)
	addq.l	#4,a0
	dbra	d2,loop$

	clr.b	_all_clear(A4)	;_all_clear
1$	rts

L00B1D:	dc.b	"Couldn't open %s",10,0

_black_out:
;	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)

	MOVEQ	#16-1,D4

1$	CLR.L	d1	;r
	CLR.L	d2	;g
	CLR.L	d3	;b
	MOVE.W	D4,D0
	MOVEA.L	_StdScr(A4),A6	;_StdScr
	LEA	$002C(A6),a0
	MOVEA.L	_GfxBase(A4),A6	;_GfxBase
	JSR	_LVOSetRGB4(A6)

	DBRA	D4,1$

	MOVE.L	(A7)+,D4
;	UNLK	A5
	RTS

_setRGB4colors:
	MOVE.W	D0,D6
	ASL.w	#2,D6

	add.w	d6,a0

	MOVE.B	(A0)+,D1	;red
	MOVE.B	(A0)+,D2	;green
	MOVE.B	(A0),D3		;blue

	MOVEA.L	_StdScr(A4),A1	;_StdScr
	LEA	$002C(A1),a0

	MOVEA.L	_GfxBase(A4),A6	;_GfxBase
	JSR	_LVOSetRGB4(A6)

	rts

_fade_in:
	LINK	A5,#-$0040
	MOVEM.L	D4/D5,-(A7)

	TST.W	$000C(A5)
	BEQ.W	L00B24

	CLR.W	d1
	MOVEq	#64,d0
	LEA	-$0040(A5),a0
	JSR	_memset

	MOVEQ	#16-1,D4
L00B1F:
	MOVEQ	#16-1,D5
L00B20:
	move.w	d5,d0
	lea	-$0040(A5),a0
	bsr	_setRGB4colors

	MOVEA.L	$0008(A5),A1
	MOVE.W	D5,D3
	ASL.w	#2,D3
	LEA	-$0040(A5),A6

	moveq	#2,d1
2$	MOVE.B	$00(A6,D3.w),D2
	CMP.B	$00(A1,D3.w),D2
	BCC.B	1$

	ADDQ.B	#1,$00(A6,D3.w)

1$	addq	#1,d3
	dbra	d1,2$

	DBRA	D5,L00B20

	JSR	_tick_pause
	DBRA	D4,L00B1F

	BRA.B	L00B26

L00B24:	MOVEQ	#16-1,D5
1$	MOVEA.L	$0008(A5),A0
	move.w	d5,d0
	bsr	_setRGB4colors
	DBRA	D5,1$

L00B26:
	MOVEM.L	(A7)+,D4/D5
	UNLK	A5
	RTS
