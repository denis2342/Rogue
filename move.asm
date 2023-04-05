;/*
; * do_run:
; *  Start the hero running
; */

_do_run:
;	LINK	A5,#-$0000
	ST	_running-BASE(A4)	;_running
	CLR.B	_after-BASE(A4)	;_after
	MOVE.B	$0005(A7),_runch-BASE(A4)	;_runch
;	UNLK	A5
	RTS

;/*
; * do_move:
; *  Check to see that a move is legal.  If it is handle the
; * consequences (fighting, picking up, etc.)
; */

_do_move:
	LINK	A5,#-$0000
	MOVEM.L	D4-D7,-(A7)

	CLR.B	_firstmove-BASE(A4)	;_firstmove
	TST.B	-$66AD(A4)	;_bailout
	BEQ.B	L00091

	CLR.B	-$66AD(A4)	;_bailout
	PEA	L000C3(PC)	;"the crack widens ... "
	JSR	_msg
	ADDQ.W	#4,A7

	PEA	L000C4(PC)
	JSR	_descend(PC)
	ADDQ.W	#4,A7
L00090:
	MOVEM.L	(A7)+,D4-D7
	UNLK	A5
	RTS

L00091:
	TST.W	-$60AE(A4)	;_no_move
	BEQ.B	L00092

	SUBQ.W	#1,-$60AE(A4)	;_no_move
	PEA	L000C5(PC)	;"you are still stuck in the bear trap"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L00090
L00092:
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISHUH,D3	;C_ISHUH
	BEQ.B	L00093

	MOVEq	#$0005,D0
	JSR	_rnd
	TST.W	D0
	BEQ.B	L00093

	PEA	_nh-BASE(A4)	;_nh
	PEA	_player-BASE(A4)	;_player + 0
	JSR	_rndmove(PC)
	ADDQ.W	#8,A7
	BRA.B	L00094
L00093:
	MOVE.W	-$52BE(A4),D3	;_player + 12
	ADD.W	$0008(A5),D3
	MOVE.W	D3,_nh2-BASE(A4)	;_nh + 2
	MOVE.W	-$52C0(A4),D3	;_player + 10
	ADD.W	$000A(A5),D3
	MOVE.W	D3,_nh-BASE(A4)	;_nh
L00094:
	MOVE.W	_nh-BASE(A4),-(A7)	;_nh
	MOVE.W	_nh2-BASE(A4),-(A7)	;_nh + 2
	JSR	_offmap
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.W	L0009B

	PEA	_nh-BASE(A4)	;_nh
	PEA	-$52C0(A4)	;_player + 10
	JSR	_diag_ok
	ADDQ.W	#8,A7
	TST.W	D0
	BNE.B	L00095

	CLR.B	_after-BASE(A4)	;_after
	CLR.B	_running-BASE(A4)	;_running
	BRA.W	L00090
L00095:
	TST.B	_running-BASE(A4)	;_running
	BEQ.B	L00096

	PEA	_nh-BASE(A4)	;_nh
	PEA	-$52C0(A4)	;_player + 10
	JSR	__ce
	ADDQ.W	#8,A7
	TST.W	D0
	BEQ.B	L00096

	CLR.B	_running-BASE(A4)	;_running
	CLR.B	_after-BASE(A4)	;_after
L00096:
	MOVE.W	_nh-BASE(A4),d0	;_nh
	MOVE.W	_nh2-BASE(A4),d1	;_nh + 2
	JSR	_INDEXquick

	MOVEA.L	__flags-BASE(A4),A6	;__flags
	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	MOVE.W	D3,D5
	MOVE.W	_nh-BASE(A4),-(A7)	;_nh
	MOVE.W	_nh2-BASE(A4),-(A7)	;_nh + 2
	JSR	_winat
	ADDQ.W	#4,A7
	MOVE.B	D0,D4

	JSR	_INDEXplayer

	MOVEA.L	__level-BASE(A4),A6	;__level
	CMP.B	#$2B,$00(A6,D0.W)	;'+' DOOR
	BNE.B	L00097

	CMP.B	#$2E,D4		;'.' FLOOR
	BNE.B	L00097

	CLR.B	_running-BASE(A4)	;_running
L00097:
	MOVE.W	D5,D3
	AND.W	#F_REAL,D3
	BNE.B	L00098

	CMP.B	#$2E,D4		;'.' FLOOR
	BNE.B	L00098

	MOVE.W	_nh-BASE(A4),d0	;_nh
	MOVE.W	_nh2-BASE(A4),d1	;_nh + 2
	JSR	_INDEXquick

	MOVEA.L	__level-BASE(A4),A6	;__level
	MOVE.W	D5,D3
	AND.W	#F_TMASK,D3
	ADD.W	#$000E,D3
	MOVE.B	D3,D4
	MOVE.B	D3,$00(A6,D0.W)

	MOVE.W	_nh-BASE(A4),d0	;_nh
	MOVE.W	_nh2-BASE(A4),d1	;_nh + 2
	JSR	_INDEXquick

	MOVEA.L	__flags-BASE(A4),A6	;__flags
	ORI.B	#F_REAL,$00(A6,D0.W)
	BRA.B	L00099
L00098:
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISHELD,D3	;C_ISHELD
	BEQ.B	L00099

	CMP.B	#$46,D4		;'F' venus flytrap
	BEQ.B	L00099

	PEA	L000C6(PC)	;"you are being held"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L00090
L00099:
	TST.W	_fall_level-BASE(A4)	;_fall_level
	BEQ.B	L0009A

	SUBQ.W	#1,_fall_level-BASE(A4)	;_fall_level
	PEA	L000C7(PC)	;"Wild magic pulls you through the floor"
	JSR	_descend(PC)
	ADDQ.W	#4,A7
	CLR.B	_running-BASE(A4)	;_running
	BRA.W	L00090
L0009A:
	MOVE.W	D4,D0
	JSR	_typech

;	EXT.L	D0
	BRA.W	L000C1
L0009B:
	TST.B	_running-BASE(A4)	;_running
	BEQ.W	L000B1

	MOVEA.L	-$52A0(A4),A6	;_player + 42 (proom)
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3	;ISGONE?
	BEQ.W	L000B1

	MOVE.W	$000E(A6),D3
	AND.W	#$0004,D3	;ISMAZE?
	BNE.W	L000B1

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BNE.W	L000B1

	MOVE.B	_runch-BASE(A4),D0	;_runch
	EXT.W	D0
;	EXT.L	D0
	BRA.W	L000AF
L0009C:
	CMPI.W	#$0001,-$52BE(A4)	;_player + 12
	BLE.B	L0009E

	JSR	_INDEXplayer
	SUBQ.W	#1,D0

	MOVEA.L	__flags-BASE(A4),A6	;__flags
;	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	AND.W	#F_SEEN,D3	;F_SEEN have seen this spot before
	BNE.B	L0009D

	JSR	_INDEXplayer
	SUBQ.W	#1,D0

	MOVEA.L	__level-BASE(A4),A6	;__level
	CMP.B	#$2B,$00(A6,D0.W)	;'+'
	BNE.B	L0009E
L0009D:
	MOVEq	#$0001,D3
	BRA.B	L0009F
L0009E:
	CLR.W	D3
L0009F:
	MOVE.B	D3,D6
	MOVE.W	_maxrow-BASE(A4),D3	;_maxrow
	SUBQ.W	#1,D3
	MOVE.W	-$52BE(A4),D2	;_player + 12
	CMP.W	D3,D2
	BGE.B	L000A1

	JSR	_INDEXplayer
	ADDQ.W	#1,D0

	MOVEA.L	__flags-BASE(A4),A6	;__flags
;	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	AND.W	#F_SEEN,D3	;F_SEEN have seen this spot before
	BNE.B	L000A0

	JSR	_INDEXplayer
	ADDQ.W	#1,D0

	MOVEA.L	__level-BASE(A4),A6	;__level
	CMP.B	#$2B,$00(A6,D0.W)	;'+'
	BNE.B	L000A1
L000A0:
	MOVEq	#$0001,D3
	BRA.B	L000A2
L000A1:
	CLR.W	D3
L000A2:
	MOVE.B	D6,D2
	EOR.B	D3,D2
	BEQ.W	L000B1

	TST.B	D6
	BEQ.B	L000A3

	MOVE.B	#$6B,_runch-BASE(A4)	;'k', _runch
	MOVE.W	#$FFFF,$0008(A5)
	BRA.B	L000A4
L000A3:
	MOVE.B	#$6A,_runch-BASE(A4)	;'j',_runch
	MOVE.W	#$0001,$0008(A5)
L000A4:
	CLR.W	$000A(A5)
	BRA.W	L00093
L000A5:
	CMPI.W	#$0001,-$52C0(A4)	;_player + 10
	BLE.B	L000A7

	MOVE.W	-$52C0(A4),D0	;_player + 10
	SUBQ.W	#1,D0
	MOVE.W	-$52BE(A4),d1	;_player + 12
	JSR	_INDEXquick

	MOVEA.L	__flags-BASE(A4),A6	;__flags
	MOVE.B	$00(A6,D0.W),D3
	AND.B	#F_SEEN,D3	;F_SEEN have seen this spot before
	BNE.B	L000A6

;	MOVE.W	-$52C0(A4),D0	;_player + 10
;	SUBQ.W	#1,D0
;	MOVE.W	-$52BE(A4),d1	;_player + 12
;	JSR	_INDEXquick

	MOVEA.L	__level-BASE(A4),A6	;__level
	CMP.B	#$2B,$00(A6,D0.W)	;'+'
	BNE.B	L000A7
L000A6:
	MOVEq	#$0001,D3
	BRA.B	L000A8
L000A7:
	CLR.W	D3
L000A8:
	MOVE.B	D3,D6
	CMPI.W	#$003A,-$52C0(A4)	;':',_player + 10
	BGE.B	L000AA

	MOVE.W	-$52C0(A4),D0	;_player + 10
	ADDQ.W	#1,D0
	MOVE.W	-$52BE(A4),d1	;_player + 12
	JSR	_INDEXquick

	MOVEA.L	__flags-BASE(A4),A6	;__flags
;	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	AND.W	#F_SEEN,D3	;F_SEEN have seen this spot before
	BNE.B	L000A9

;	MOVE.W	-$52C0(A4),D0	;_player + 10
;	ADDQ.W	#1,D0
;	MOVE.W	-$52BE(A4),d1	;_player + 12
;	JSR	_INDEXquick

	MOVEA.L	__level-BASE(A4),A6	;__level
	CMP.B	#$002B,$00(A6,D0.W)
	BNE.B	L000AA
L000A9:
	MOVEq	#$0001,D3
	BRA.B	L000AB
L000AA:
	CLR.W	D3
L000AB:
	MOVE.B	D6,D2
	EOR.B	D3,D2
	BEQ.B	L000B1

	TST.B	D6
	BEQ.B	L000AC

	MOVE.B	#$68,_runch-BASE(A4)	;'h',_runch
	MOVE.W	#$FFFF,$000A(A5)
	BRA.B	L000AD
L000AC:
	MOVE.B	#$6C,_runch-BASE(A4)	;'l',_runch
	MOVE.W	#$0001,$000A(A5)
L000AD:
	CLR.W	$0008(A5)
	BRA.W	L00093
L000AE:
	dc.w	L0009C-L000B0	;h
	dc.w	L000B1-L000B0	;i
	dc.w	L000A5-L000B0	;j
	dc.w	L000A5-L000B0	;k
	dc.w	L0009C-L000B0	;l
L000AF:
	SUB.W	#$0068,D0
	CMP.W	#$0005,D0
	BCC.B	L000B1

	ASL.W	#1,D0
	MOVE.W	L000AE(PC,D0.W),D0
L000B0:	JMP	L000B0(PC,D0.W)
L000B1:
	CLR.B	_running-BASE(A4)	;_running
	CLR.B	_after-BASE(A4)	;_after
	BRA.W	L00090
L000B2:
	CLR.B	_running-BASE(A4)	;_running

	JSR	_INDEXplayer

	MOVEA.L	__flags-BASE(A4),A6	;__flags
	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	AND.W	#F_SEEN,D3	;F_SEEN have seen this spot before
	BEQ.B	L000B3

	PEA	_nh-BASE(A4)	;_nh
	JSR	_enter_room
	ADDQ.W	#4,A7
L000B3:
	BRA.W	L000BC
L000B4:
	PEA	_nh-BASE(A4)	;_nh
	JSR	_be_trapped(PC)
	ADDQ.W	#4,A7
	MOVE.B	D0,D4
;	TST.W	D3
	BEQ.B	L000B5

	CMP.B	#$04,D0
	BNE.B	L000BC
L000B5:
	BRA.W	L00090
L000B7:
	MOVE.W	D5,D3
	AND.W	#F_REAL,D3
	BNE.B	L000BC

	PEA	-$52C0(A4)	;_player + 10
	JSR	_be_trapped(PC)
	ADDQ.W	#4,A7
L000B8:
	BRA.B	L000BC
L000B9:
	CLR.B	_running-BASE(A4)	;_running
	MOVE.W	D4,d0
	JSR	_isupper

	TST.W	D0
	BNE.B	L000BA

	MOVE.W	_nh-BASE(A4),d1	;_nh
	MOVE.W	_nh2-BASE(A4),d0	;_nh +2
	JSR	_moatquick

	TST.L	D0
	BEQ.B	L000BB
L000BA:
	CLR.L	-(A7)
	MOVE.L	_cur_weapon-BASE(A4),-(A7)	;_cur_weapon
	MOVEQ	#$00,D3
	MOVE.B	D4,D3
	MOVE.W	D3,-(A7)
	PEA	_nh-BASE(A4)	;_nh
	JSR	_fight
	LEA	$000E(A7),A7
	BRA.W	L00090
L000BB:
	CLR.B	_running-BASE(A4)	;_running
	CMP.B	#$25,D4
	BEQ.B	L000BC

	MOVE.B	D4,_take-BASE(A4)	;_take
L000BC:
	JSR	_INDEXplayer

	MOVEA.L	__level-BASE(A4),A6	;__level

	MOVE.B	$00(A6,D0.W),D2
	MOVE.W	-$52C0(A4),d1	;_player + 10
	MOVE.W	-$52BE(A4),d0	;_player + 12
	JSR	_mvaddchquick

	MOVE.W	D5,D3
	AND.W	#F_SEEN,D3
	BEQ.B	L000BE

	MOVE.W	-$6090(A4),d0
	MOVE.W	-$608E(A4),d1
	JSR	_INDEXquick

	MOVEA.L	__level-BASE(A4),A6	;__level
	CMP.B	#$2B,$00(A6,D0.W)
	BEQ.B	L000BD

;	MOVE.W	-$6090(A4),d0
;	MOVE.W	-$608E(A4),d1
;	JSR	_INDEXquick

	MOVEA.L	__flags-BASE(A4),A6	;__flags
	MOVE.B	$00(A6,D0.W),D3
	AND.B	#F_DROPPED,D3	;F_DROPPED object was dropped here
	BEQ.B	L000BE
L000BD:
	PEA	_nh-BASE(A4)	;_nh
	JSR	_leave_room
	ADDQ.W	#4,A7
L000BE:
	MOVE.W	D5,D3
	AND.W	#F_DROPPED,D3
	BEQ.B	L000BF

	MOVE.W	-$6090(A4),d0
	MOVE.W	-$608E(A4),d1
	JSR	_INDEXquick

	MOVEA.L	__flags-BASE(A4),A6	;__flags
	MOVE.B	$00(A6,D0.W),D3
	AND.B	#F_DROPPED,D3		;F_DROPPED object was dropped here
	BNE.B	L000BF

	PEA	_nh-BASE(A4)	;_nh
	JSR	_enter_room
	ADDQ.W	#4,A7
L000BF:
	LEA	-$52C0(A4),A6	;_player + 10
	LEA	_nh-BASE(A4),A1	;_nh
	MOVE.L	(A1)+,(A6)+
	BRA.B	L00090
L000C1:
	SUB.w	#$000E,D0
	BEQ.W	L000B4
	SUB.w	#$0012,D0
	BEQ.W	L0009B
	SUBQ.w	#3,D0
	BEQ.W	L000BC
	SUBQ.w	#8,D0
	BEQ.W	L000B2
	SUBQ.w	#2,D0
	BEQ.W	L0009B
	SUBQ.w	#1,D0
	BEQ.W	L000B7
	SUB.w	#$000E,D0
	BEQ.W	L0009B
	SUBQ.w	#2,D0
	BEQ.W	L0009B
	SUB.w	#$003D,D0
	BEQ.W	L0009B
	SUBQ.w	#1,D0
	BEQ.W	L0009B
	SUBQ.w	#1,D0
	BEQ.W	L0009B
	BRA.W	L000B9

L000C3:	dc.b	"the crack widens ... ",0
L000C4:	dc.b	$00
L000C5:	dc.b	"you are still stuck in the bear trap",0
L000C6:	dc.b	"you are being held",0
L000C7:	dc.b	"Wild magic pulls you through the floor",0

;/*
; * door_open:
; *  Called to illuminate a room.  If it is dark, remove anything
; *  that might move.
; */

_door_open:
	LINK	A5,#-$0000
	MOVEM.L	D4-D6/A2,-(A7)

	MOVEA.L	$0008(A5),A6
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3
	BNE.W	L000CD

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BNE.W	L000CD

;	MOVEA.L	$0008(A5),A6
	MOVE.W	$0002(A6),D4
	BRA	L000CC
L000C8:
	MOVEA.L	$0008(A5),A6
	MOVE.W	(A6),D5
	BRA.B	L000CB
L000C9:
	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_winat
	ADDQ.W	#4,A7

	JSR	_isupper

	TST.W	D0
	BEQ.B	L000CA

	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_wake_monster
	ADDQ.W	#4,A7
	MOVEA.L	D0,A2
	CMP.B	#$20,$0011(A2)
	BNE.B	L000CA

	MOVE.L	$0008(A5),-(A7)
	JSR	_is_dark
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.B	L000CA

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BNE.B	L000CA

	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick

	MOVEA.L	__level-BASE(A4),A6	;__level
	MOVE.B	$00(A6,D0.W),$0011(A2)
L000CA:
	ADDQ.W	#1,D5
L000CB:
	MOVEA.L	$0008(A5),A6
	MOVE.W	(A6),D3
	ADD.W	$0004(A6),D3
	CMP.W	D3,D5
	BLT.B	L000C9

	ADDQ.W	#1,D4
L000CC:
	MOVEA.L	$0008(A5),A6
	MOVE.W	$0002(A6),D3
	ADD.W	$0006(A6),D3
	CMP.W	D3,D4
	BLT.W	L000C8
L000CD:
	MOVEM.L	(A7)+,D4-D6/A2
	UNLK	A5
	RTS

;/*
; * be_trapped:
; *  The guy stepped on a trap.... Make him pay.
; */

_be_trapped:
	LINK	A5,#-$0004
	MOVEM.L	D4/D5/A2,-(A7)
	MOVEA.L	$0008(A5),A2
	CLR.B	_running-BASE(A4)	;_running
	CLR.W	_count-BASE(A4)	;_count

	MOVE.W	(A2),d0
	MOVE.W	$0002(A2),d1
	JSR	_INDEXquick

	MOVE.W	D0,D5
	MOVEA.L	__flags-BASE(A4),A6	;__flags
	MOVE.B	$00(A6,D5.W),D3
	AND.B	#F_TMASK,D3	;trap number mask
	MOVE.B	D3,D4
	MOVEA.L	__level-BASE(A4),A6	;__level
	MOVE.B	D4,D3
	ADD.B	#$0E,D3
	MOVE.B	D3,$00(A6,D5.W)
	MOVE.B	#$01,_was_trapped-BASE(A4)	;_was_trapped
	MOVEQ	#$00,D0
	MOVE.B	D4,D0
	BRA.W	L000E0
L000CE:
	PEA	L000E3(PC)	;"you fell into a trap!"
	JSR	_descend(PC)
	ADDQ.W	#4,A7
	BRA.W	L000E2
L000CF:
	MOVEq	#$0003,D0
	JSR	_spread

	ADD.W	D0,-$60AE(A4)	;_no_move
	PEA	L000E4(PC)	;"you are caught in a bear trap"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L000E2
L000D0:
	MOVEq	#$0005,D0
	JSR	_spread

	ADD.W	D0,_no_command-BASE(A4)	;_no_command
	ANDI.W	#~C_ISRUN,-$52B4(A4)	;clear C_ISRUN, _player + 22 (flags)

	LEA	L000E6(PC),a0	;"strange white "
	JSR	_noterse

	MOVE.L	D0,-(A7)
	PEA	L000E5(PC)	;"a %smist envelops you and you fall asleep"
	JSR	_msg
	ADDQ.W	#8,A7
	BRA.W	L000E2
L000D1:
	MOVE.W	#$0001,-(A7)	;arrow is hplus = 1
	MOVE.W	-$52AA(A4),-(A7)	;_player + 32 AC
	MOVE.W	-$52AC(A4),D3	;_player + 30 (rank)
	SUBQ.W	#1,D3
	MOVE.W	D3,-(A7)
	JSR	_swing
	ADDQ.W	#6,A7
	TST.W	D0
	BEQ.B	L000D4

	MOVE.W	#$0006,-(A7)	;1d6
	MOVE.W	#$0001,-(A7)
	JSR	_roll
	ADDQ.W	#4,A7
	SUB.W	D0,-$52A8(A4)	;_player + 34 (hp)
;	CMPI.W	#$0000,-$52A8(A4)	;_player + 34 (hp)
	BGT.B	L000D2

	PEA	L000E7(PC)	;"an arrow killed you"
	JSR	_msg
	ADDQ.W	#4,A7
	MOVE.W	#$0061,-(A7)	;'a' arrow
	JSR	_death
	ADDQ.W	#2,A7
	BRA.B	L000D6
L000D2:
	PEA	L000E8(PC)	;"oh no! An arrow shot you"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L000D6
L000D4:
	JSR	_new_item
	MOVE.L	D0,-$0004(A5)
;	TST.L	D0
	BEQ.B	L000D5

	MOVEA.L	D0,A6
	MOVE.W	#W_ARROW,$0020(A6)	;W_ARROW subtype
	MOVE.L	A6,-(A7)
	JSR	_init_weapon
	ADDQ.W	#4,A7
	MOVEA.L	-$0004(A5),A6
	MOVE.W	#$0001,$001E(A6)	;one arrow
	ADDA.L	#$0000000C,A6
	LEA	-$52C0(A4),A1	;_player + 10
	MOVE.L	(A1)+,(A6)+
	CLR.L	-(A7)
	MOVE.L	-$0004(A5),-(A7)
	JSR	_fall
	ADDQ.W	#8,A7
L000D5:
	PEA	L000E9(PC)	;"an arrow shoots past you"
	JSR	_msg
	ADDQ.W	#4,A7
L000D6:
	BRA.W	L000E2
L000D7:
	JSR	_teleport

	MOVEq	#$0012,d2
	MOVE.W	(A2),d1
	MOVE.W	$0002(A2),d0
	JSR	_mvaddchquick

	ADDQ.B	#1,_was_trapped-BASE(A4)	;_was_trapped
	BRA.W	L000E2
L000D8:
	MOVE.W	#$0001,-(A7)	;hplus = 1
	MOVE.W	-$52AA(A4),-(A7)	;_player + 32 AC
	MOVE.W	-$52AC(A4),D3	;_player + 30 (rank)
	ADDQ.W	#1,D3
	MOVE.W	D3,-(A7)
	JSR	_swing
	ADDQ.W	#6,A7
	TST.W	D0
	BEQ.B	L000DD

	MOVE.W	#$0004,-(A7)	;1d4
	MOVE.W	#$0001,-(A7)
	JSR	_roll
	ADDQ.W	#4,A7
	SUB.W	D0,-$52A8(A4)	;_player + 34 (hp)
	CMPI.W	#$0000,-$52A8(A4)	;_player + 34 (hp)
	BGT.B	L000D9

	PEA	L000EA(PC)	;"a poisoned dart killed you"
	JSR	_msg
	ADDQ.W	#4,A7
	MOVE.W	#$0064,-(A7)	;'d' dart
	JSR	_death
	ADDQ.W	#2,A7
L000D9:
	MOVE.L	_cur_ring_1-BASE(A4),D0	;_cur_ring_1
	BEQ.B	L000DA
	MOVEA.L	D0,A6		;_cur_ring_1
	CMPI.W	#R_SUSTSTR,$0020(A6)	;ring of sustain strength
	BEQ.B	L000DC
L000DA:
	MOVE.L	_cur_ring_2-BASE(A4),D0	;_cur_ring_2
	BEQ.B	L000DB
	MOVEA.L	D0,A6		;_cur_ring_2
	CMPI.W	#R_SUSTSTR,$0020(A6)	;ring of sustain strength
	BEQ.B	L000DC
L000DB:
	CLR.W	-(A7)
	JSR	_save
	ADDQ.W	#2,A7
	TST.W	D0
	BNE.B	L000DC
	MOVE.W	#$FFFF,-(A7)	; subtract one strength point
	JSR	_chg_str
	ADDQ.W	#2,A7
L000DC:
	PEA	L000EB(PC)	;"a dart just hit you in the shoulder"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L000E2
L000DD:
	PEA	L000EC(PC)	;"a dart whizzes by your ear and vanishes"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L000E2
L000DF:
	dc.w	L000CE-L000E1	;door
	dc.w	L000D1-L000E1	;arrow
	dc.w	L000D0-L000E1	;sleep
	dc.w	L000CF-L000E1	;bear
	dc.w	L000D7-L000E1	;teleport
	dc.w	L000D8-L000E1	;dart
L000E0:
	CMP.w	#$0006,D0
	BCC.B	L000E2
	ASL.w	#1,D0
	MOVE.W	L000DF(PC,D0.W),D0
L000E1:	JMP	L000E1(PC,D0.W)
L000E2:
	JSR	_flush_type
	MOVEQ	#$00,D0
	MOVE.B	D4,D0

	MOVEM.L	(A7)+,D4/D5/A2
	UNLK	A5
	RTS

L000E3:	dc.b	"you fell into a trap!",0
L000E4:	dc.b	"you are caught in a bear trap",0
L000E5:	dc.b	"a %smist envelops you and you fall asleep",0
L000E6:	dc.b	"strange white ",0
L000E7:	dc.b	"an arrow killed you",0
L000E8:	dc.b	"oh no! An arrow shot you",0
L000E9:	dc.b	"an arrow shoots past you",0
L000EA:	dc.b	"a poisoned dart killed you",0
L000EB:	dc.b	"a dart just hit you in the shoulder",0
L000EC:	dc.b	"a dart whizzes by your ear and vanishes",0

_descend:
	LINK	A5,#-$0000

	ADDQ.W	#1,_level-BASE(A4)	;_level
	MOVEA.L	$0008(A5),A6
	TST.B	(A6)
	BNE.B	L000ED

	PEA	L000EF(PC)	;" "
	JSR	_msg
	ADDQ.W	#4,A7
L000ED:
	JSR	_new_level
	PEA	L000F0(PC)	;""
	JSR	_msg
	ADDQ.W	#4,A7

	MOVE.L	$0008(A5),-(A7)
	JSR	_msg
	ADDQ.W	#4,A7

	MOVE.W	#VS_FALL,-(A7)
	JSR	_save
	ADDQ.W	#2,A7

	TST.W	D0
	BNE.B	L000EE

	PEA	L000F1(PC)	;"you are damaged by the fall"
	JSR	_msg
	ADDQ.W	#4,A7

	MOVE.W	#$0008,-(A7)	;1d8
	MOVE.W	#$0001,-(A7)
	JSR	_roll
	ADDQ.W	#4,A7

	SUB.W	D0,-$52A8(A4)	;_player + 34 (hp)
	CMPI.W	#$0000,-$52A8(A4)	;_player + 34 (hp)
	BGT.B	L000EE

	MOVE.W	#$0066,-(A7)	;'f' fall
	JSR	_death
	ADDQ.W	#2,A7
L000EE:
	UNLK	A5
	RTS

L000EF:	dc.b	" ",0
L000F0:	dc.b	$00
L000F1:	dc.b	"you are damaged by the fall",0,0

;/*
; * rndmove:
; *  Move in a random direction if the monster/person is confused
; */

_rndmove:
	LINK	A5,#-$0000
	MOVEM.L	D4-D6/A2,-(A7)

	MOVEq	#$0003,D0
	JSR	_rnd

	MOVEA.L	$0008(A5),A6
	ADD.W	$000C(A6),D0

	MOVEA.L	$000C(A5),A6
	SUBQ.W	#1,D0
	MOVE.W	D0,$0002(A6)
	MOVE.W	D0,D5

	MOVEq	#$0003,D0
	JSR	_rnd

	MOVEA.L	$0008(A5),A6
	ADD.W	$000A(A6),D0

	MOVEA.L	$000C(A5),A6
	SUBQ.W	#1,D0
	MOVE.W	D0,(A6)

	MOVE.W	D0,D4
	MOVEA.L	$0008(A5),A6
	CMP.W	$000C(A6),D5
	BNE.B	L000F3

;	MOVEA.L	$0008(A5),A6
	CMP.W	$000A(A6),D4
	BNE.B	L000F3
L000F2:
	MOVEM.L	(A7)+,D4-D6/A2
	UNLK	A5
	RTS

L000F3:
	CMP.W	#$0001,D5
	BLT.B	L000F9

	CMP.W	_maxrow-BASE(A4),D5	;_maxrow
	BGE.B	L000F9

	CMP.W	#$0000,D4
	BLT.B	L000F9

	CMP.W	#60,D4
	BGE.B	L000F9

	MOVE.L	$000C(A5),-(A7)
	MOVEA.L	$0008(A5),A6
	PEA	$000A(A6)
	JSR	_diag_ok
	ADDQ.W	#8,A7
	TST.W	D0
	BEQ.B	L000F9

	MOVE.W	D4,-(A7)
	MOVE.W	D5,-(A7)
	JSR	_winat
	ADDQ.W	#4,A7

	MOVEQ	#$00,D6
	MOVE.B	D0,D6
	MOVE.W	D6,-(A7)
	JSR	_step_ok
	ADDQ.W	#2,A7
	TST.W	D0
	BEQ.B	L000F9

	CMP.B	#$3F,D6
	BNE.B	L000F8

	MOVEA.L	_lvl_obj-BASE(A4),A2	;_lvl_obj
	BRA.B	L000F6
L000F4:
	CMP.W	$000E(A2),D5
	BNE.B	L000F5

	CMP.W	$000C(A2),D4
	BEQ.B	L000F7
L000F5:
	MOVEA.L	(A2),A2
L000F6:
	MOVE.L	A2,D3
	BNE.B	L000F4
L000F7:
	MOVE.L	A2,D3
	BEQ.B	L000F8

	CMPI.W	#$0006,$0020(A2)
	BEQ.B	L000F9
L000F8:
	BRA.W	L000F2
L000F9:
	MOVEA.L	$000C(A5),A6
	MOVEA.L	$0008(A5),A1
	ADDA.L	#$0000000A,A1
	MOVE.L	(A1)+,(A6)+
	BRA.W	L000F2
