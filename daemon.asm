_dm_null:
;	LINK	A5,#-$0000
;	UNLK	A5
	RTS

;/*
; * d_slot:
; *  Find an empty slot in the daemon/fuse list
; */

_d_slot:
;	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	LEA	-$544A(A4),A2
	LEA	-$53D2(A4),A6
L00594:
	TST.W	(A2)
	BEQ.B	L00596

	ADDQ.L	#6,A2
	CMPA.L	A6,A2
	BCS.B	L00594

	MOVEQ	#$00,D0
L00595:
	MOVEA.L	(A7)+,A2
;	UNLK	A5
	RTS

L00596:
	MOVE.L	A2,D0
	BRA.B	L00595

;/*
; * find_slot:
; *  Find a particular slot in the table
; */

_find_slot:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	LEA	-$544A(A4),A2
	LEA	-$53D2(A4),A6

	MOVE.W	$0008(A5),D3	;looking for this

L00597:
	CMP.W	(A2),D3
	BEQ.B	L00599

	ADDQ.L	#6,A2
	CMPA.L	A6,A2
	BCS.B	L00597

	MOVEQ	#$00,D0
L00598:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L00599:
	MOVE.L	A2,D0
	BRA.B	L00598

;/*
; * start_daemon:
; *  Start a daemon, takes a function.
; */

_daemon:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	BSR.B	_d_slot
	MOVEA.L	D0,A2
	MOVE.L	$0008(A5),-(A7)
	JSR	_cvt_f_i(PC)
	ADDQ.W	#4,A7
	MOVE.W	D0,(A2)
	MOVE.W	$000C(A5),$0002(A2)
	MOVE.W	#$FFFB,$0004(A2)

	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

;/*
; * do_daemons:
; *  Run all the daemons that are active with the current flag,
; *  passing the argument to the function.
; */

_do_daemons:
;	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	LEA	-$544A(A4),A6
	MOVEA.L	A6,A2
L0059A:
	TST.W	(A2)
	BEQ.B	L0059C

	CMPI.W	#$FFFB,$0004(A2)
	BEQ.B	L0059B

	SUBQ.W	#1,$0004(A2)
;	CMPI.W	#$0000,$0004(A2)
	BGT.B	L0059C
L0059B:
	MOVE.W	$0002(A2),-(A7)
	MOVE.W	(A2),D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$700E(A4),A6		;_dm_null, start of deamon callbacks
	MOVEA.L	$00(A6,D3.w),A1
	JSR	(A1)
	ADDQ.W	#2,A7
	CMPI.W	#$FFFB,$0004(A2)
	BEQ.B	L0059C

	CLR.W	(A2)
L0059C:
	ADDQ.L	#6,A2
	LEA	-$53D2(A4),A6
	CMPA.L	A6,A2
	BCS.B	L0059A

	MOVEA.L	(A7)+,A2
;	UNLK	A5
	RTS

;/*
; * fuse:
; *  Start a fuse to go off in a certain number of turns
; */

_fuse:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	JSR	_d_slot(PC)
	MOVEA.L	D0,A2
	MOVE.L	$0008(A5),-(A7)
	BSR.B	_cvt_f_i
	ADDQ.W	#4,A7
	MOVE.W	D0,(A2)
	MOVE.W	$000C(A5),$0002(A2)
	MOVE.W	$000E(A5),$0004(A2)

	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

;/*
; * lengthen:
; *  Increase the time until a fuse goes off
; */

_lengthen:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVE.L	$0008(A5),-(A7)
	BSR.B	_cvt_f_i
	ADDQ.W	#4,A7
	MOVE.W	D0,-(A7)
	JSR	_find_slot(PC)
	ADDQ.W	#2,A7
	MOVEA.L	D0,A2
	TST.L	D0
	BEQ.B	1$

	MOVE.W	$000C(A5),D3
	ADD.W	D3,$0004(A2)
1$
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS


;/*
; * extinguish:
; *  Put out a fuse
; */

_extinguish:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVE.L	$0008(A5),-(A7)
	BSR.B	_cvt_f_i
	ADDQ.W	#4,A7

	MOVE.W	D0,-(A7)
	JSR	_find_slot(PC)
	ADDQ.W	#2,A7

	MOVEA.L	D0,A2
	TST.L	D0
	BEQ.B	1$

	CLR.W	(A2)

1$	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

_cvt_f_i:
	LINK	A5,#-$0000
	MOVEM.L	A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	LEA	-$700E(A4),A6
	MOVEA.L	A6,A3
	BRA.B	L005A4
L005A1:
	MOVEA.L	(A3),A6
	CMPA.L	A2,A6
	BNE.B	L005A3

	MOVE.L	A3,D0
	LEA	-$700E(A4),A6
	SUB.L	A6,D0
	LSR.L	#2,D0
L005A2:
	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

L005A3:
	ADDQ.L	#4,A3
L005A4:
	TST.L	(A3)
	BNE.B	L005A1

	PEA	L005A5(PC)	;"A new kind of fuse was experienced."
	JSR	_db_print
	ADDQ.W	#4,A7
	MOVEQ	#$00,D0
	BRA.B	L005A2
L005A5:
	dc.b	"A new kind of fuse was experienced.",0

_dm_xfer:
;	LINK	A5,#-$0000
	MOVE.W	#$0078,-(A7)
	PEA	-$544A(A4)
	JSR	_xfer
	ADDQ.W	#6,A7
;	UNLK	A5
	RTS
