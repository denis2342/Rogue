;/*
; * do_passages:
; *  Draw all the passages on a level.
; */

_do_passages:
	LINK	A5,#-$000A
	MOVEM.L	D4/D5,-(A7)

	LEA	_do_passages_tmp(A4),A6
	MOVE.L	A6,-$0006(A5)
L00440:
	MOVEQ	#$00,D5
L00441:
	MOVE.W	D5,D3
	EXT.L	D3
	MOVEA.L	D3,A6
	ADDA.L	-$0006(A5),A6
	CLR.B	$0009(A6)
	ADDQ.W	#1,D5
	CMP.W	#$0009,D5
	BLT.B	L00441

	MOVEA.L	-$0006(A5),A6
	CLR.B	$0012(A6)
	ADDI.L	#$00000014,-$0006(A5)
	LEA	_do_passages_tmp_end(A4),A6
	MOVEA.L	-$0006(A5),A1
	CMPA.L	A6,A1
	BCS.B	L00440

	MOVE.W	#$0001,-$0002(A5)
	MOVEq	#$0009,D0
	JSR	_rnd
	MULU.W	#$0014,D0
	LEA	_do_passages_tmp(A4),A6
	ADD.L	A6,D0
	MOVE.L	D0,-$0006(A5)
	MOVEA.L	-$0006(A5),A6
	MOVE.B	#$01,$0012(A6)
L00442:
	MOVEQ	#$00,D5
	MOVEQ	#$00,D4
L00443:
	MOVEA.L	-$0006(A5),A6
	TST.B	$00(A6,D4.W)
	BEQ.B	L00444

	MOVE.W	D4,D3
	MULU.W	#$0014,D3
	LEA	_in_dist+26(A4),A6
	TST.B	$00(A6,D3.L)
	BNE.B	L00444

	ADDQ.W	#1,D5
	MOVE.W	D5,D0
	JSR	_rnd
	TST.W	D0
	BNE.B	L00444

	MOVE.W	D4,D3
	MULU.W	#$0014,D3
	LEA	_do_passages_tmp(A4),A6
	ADD.L	A6,D3
	MOVE.L	D3,-$000A(A5)
L00444:
	ADDQ.W	#1,D4
	CMP.W	#$0009,D4
	BLT.B	L00443

	TST.W	D5
	BNE.B	L00446
L00445:
	MOVEq	#$0009,D0
	JSR	_rnd
	MULU.W	#$0014,D0
	LEA	_do_passages_tmp(A4),A6
	ADD.L	A6,D0
	MOVE.L	D0,-$0006(A5)
	MOVEA.L	-$0006(A5),A6
	TST.B	$0012(A6)
	BEQ.B	L00445

	BRA.B	L00447
L00446:
	MOVEA.L	-$000A(A5),A6
	MOVE.B	#$01,$0012(A6)

	LEA	_do_passages_tmp(A4),A6
	MOVE.L	-$0006(A5),D4
	SUB.L	A6,D4

	MOVEQ	#$14,d0
	divu	D0,d4

;	LEA	_do_passages_tmp(A4),A6
	MOVE.L	-$000A(A5),D5
	SUB.L	A6,D5

;	MOVEQ	#$14,d0
	divu	D0,d5

	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_conn(PC)
	ADDQ.W	#4,A7

	MOVE.W	D5,D3
	EXT.L	D3
	MOVEA.L	D3,A6
	ADDA.L	-$0006(A5),A6
	MOVE.B	#$01,$0009(A6)
	MOVE.W	D4,D3
	EXT.L	D3
	MOVEA.L	D3,A6
	ADDA.L	-$000A(A5),A6
	MOVE.B	#$01,$0009(A6)
	ADDQ.W	#1,-$0002(A5)
L00447:
	CMPI.W	#$0009,-$0002(A5)
	BLT.W	L00442

	MOVEq	#$0005,D0
	JSR	_rnd
	MOVE.W	D0,-$0002(A5)
	BRA.W	L0044C
L00448:
	MOVEq	#$0009,D0
	JSR	_rnd
	MULU.W	#$0014,D0
	LEA	_do_passages_tmp(A4),A6
	ADD.L	A6,D0
	MOVE.L	D0,-$0006(A5)
	MOVEQ	#$00,D5
	MOVEQ	#$00,D4
L00449:
	MOVEA.L	-$0006(A5),A6
	TST.B	$00(A6,D4.W)
	BEQ.B	L0044A

	MOVE.W	D4,D3
	EXT.L	D3
	MOVEA.L	D3,A6
	ADDA.L	-$0006(A5),A6
	TST.B	$0009(A6)
	BNE.B	L0044A

	ADDQ.W	#1,D5
	MOVE.W	D5,D0
	JSR	_rnd
	TST.W	D0
	BNE.B	L0044A

	MOVE.W	D4,D3
	MULU.W	#$0014,D3
	LEA	_do_passages_tmp(A4),A6
	ADD.L	A6,D3
	MOVE.L	D3,-$000A(A5)
L0044A:
	ADDQ.W	#1,D4
	CMP.W	#$0009,D4
	BLT.B	L00449

	TST.W	D5
	BEQ.B	L0044B

	LEA	_do_passages_tmp(A4),A6
	MOVE.L	-$0006(A5),D4
	SUB.L	A6,D4

	MOVEQ	#$14,d0
	divu	D0,d4

;	LEA	_do_passages_tmp(A4),A6
	MOVE.L	-$000A(A5),D5
	SUB.L	A6,D5

;	MOVEQ	#$14,d0
	divu	D0,d5

	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_conn(PC)
	ADDQ.W	#4,A7
	MOVE.W	D5,D3
	EXT.L	D3
	MOVEA.L	D3,A6
	ADDA.L	-$0006(A5),A6
	MOVE.B	#$01,$0009(A6)
	MOVE.W	D4,D3
	EXT.L	D3
	MOVEA.L	D3,A6
	ADDA.L	-$000A(A5),A6
	MOVE.B	#$01,$0009(A6)
L0044B:
	SUBQ.W	#1,-$0002(A5)
L0044C:
	CMPI.W	#$0000,-$0002(A5)
	BGT.W	L00448
	JSR	_passnum(PC)

	MOVEM.L	(A7)+,D4/D5
	UNLK	A5
	RTS

;/*
; * door:
; *  Add a door or possibly a secret door.  Also enters the door in
; *  the exits array of the room.
; */

_door:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5,-(A7)
	MOVEA.L	$000C(A5),A6

	MOVE.W	(A6)+,d0
	MOVE.W	(A6),d1
	JSR	_INDEXquick
	MOVE.W	D0,D4

	MOVEq	#10,D0
	JSR	_rnd
	ADDQ.W	#1,D0
	CMP.W	_level(A4),D0	;_level
	BGE.B	L00450

	MOVEq	#5,D0
	JSR	_rnd
	TST.W	D0
	BNE.B	L00450

	; 20% chance for a secret door

	MOVEA.L	__level(A4),A6	;__level
	MOVEA.L	$000C(A5),A1
	MOVEA.L	$0008(A5),A0

	MOVE.W	$0002(A1),D3
	CMP.W	$0002(A0),D3
	BEQ.B	L0044D

	MOVE.W	$0002(A0),D3
	ADD.W	$0006(A0),D3
	SUBQ.W	#1,D3
	CMP.W	$0002(A1),D3
	BNE.B	L0044E
L0044D:
	MOVEQ	#$2D,D3		;'-'
	BRA.B	L0044F
L0044E:
	MOVEQ	#$7C,D3		;'|'
L0044F:
	MOVE.B	D3,$00(A6,D4.W)
	MOVEA.L	__flags(A4),A6	;__flags
	ANDI.B	#~F_REAL,$00(A6,D4.W)	;clear F_REAL
	BRA.B	L00451
L00450:
	MOVEA.L	__level(A4),A6	;__level
	MOVE.B	#$2B,$00(A6,D4.W)	;'+'
L00451:
	MOVEA.L	$0008(A5),A6
	MOVEA.L	$000C(A5),A1

	MOVE.W	$0010(A6),D3
	ADDQ.W	#1,$0010(A6)

	ASL.L	#2,D3

	MOVE.W	(A1)+,$12(A6,D3.w)
	MOVE.W	(A1),$14(A6,D3.w)

	MOVEM.L	(A7)+,D4/D5
	UNLK	A5
	RTS

;/*
; * add_pass:
; *  Add the passages to the current window (wizard command)
; */

_add_pass:
	LINK	A5,#-$0000
	MOVEM.L	D4-D5,-(A7)

	MOVEQ	#$01,D4
	BRA.B	L00456
L00452:
	MOVEQ	#$00,D5
L00453:
	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level

	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3

	CMP.W	#$002B,D3	;'+'
	BEQ.B	L00454

	CMP.W	#$0023,D3	;'#'
	BNE.B	L00455
L00454:
	MOVE.W	D3,d2
	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_mvaddchquick

L00455:
	ADDQ.W	#1,D5
	CMP.W	#$003C,D5	;'<'
	BLT.B	L00453

	ADDQ.W	#1,D4
L00456:
	CMP.W	_maxrow(A4),D4	;_maxrow
	BLT.B	L00452

	MOVEM.L	(A7)+,D4-D5
	UNLK	A5
	RTS

;/*
; * passnum:
; *  Assign a number to each passageway
; */

_passnum:
;	LINK	A5,#-$0000
	MOVEM.L	D4/A2,-(A7)

	CLR.W	_numpass_tmp(A4)
	CLR.B	_numpass_tmp+2(A4)
	LEA	_passages(A4),A2	;_passages
	LEA	_passages_end(A4),A6	;_SV_END
1$
	CLR.W	$0010(A2)
	ADDA.L	#$00000042,A2
	CMPA.L	A6,A2
	BCS.B	1$

	LEA	_rooms(A4),A2	;_rooms
L00458:
	MOVEQ	#$00,D4
	BRA.B	L0045A
L00459:
	ADDQ.B	#1,_numpass_tmp+2(A4)
	MOVE.W	D4,D3
	ASL.w	#2,D3
	MOVE.W	$0012(A2,D3.w),-(A7)
	MOVE.W	$0014(A2,D3.w),-(A7)
	BSR.B	_numpass
	ADDQ.W	#4,A7
	ADDQ.W	#1,D4
L0045A:
	CMP.W	$0010(A2),D4
	BLT.B	L00459

	ADDA.L	#66,A2
	LEA	_rooms_end(A4),A6	;_passages
	CMPA.L	A6,A2
	BCS.B	L00458

	MOVEM.L	(A7)+,D4/A2
;	UNLK	A5
	RTS

;/*
; * numpass:
; *  Number a passageway square and its brethren
; */

_numpass:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2/A3,-(A7)

	MOVE.W	$000A(A5),-(A7)
	MOVE.W	$0008(A5),-(A7)
	JSR	_offmap
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L0045C
L0045B:
	MOVEM.L	(A7)+,D4/A2/A3
	UNLK	A5
	RTS

L0045C:
	MOVE.W	$000A(A5),d0
	MOVE.W	$0008(A5),d1
	JSR	_INDEXquick

;	EXT.L	D0
	MOVEA.w	D0,A2
	ADDA.L	__flags(A4),A2	;__flags
	MOVEQ	#$00,D3
	MOVE.B	(A2),D3
	AND.W	#F_PNUM,D3
	BNE.B	L0045B

	TST.B	_numpass_tmp+2(A4)
	BEQ.B	L0045E

	ADDQ.W	#1,_numpass_tmp(A4)
	CLR.B	_numpass_tmp+2(A4)
L0045E:
	MOVE.W	$000A(A5),d0
	MOVE.W	$0008(A5),d1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level
	MOVE.B	$00(A6,D0.W),D4

	MOVE.B	D4,D3
	CMP.B	#$2B,D3		;'+' DOOR
	BEQ.B	L0045F

	MOVE.B	(A2),D3
	AND.B	#F_REAL,D3	;F_REAL
	BNE.B	L00460

	MOVE.B	D4,D3
	CMP.B	#$2E,D3		;'.' FLOOR
	BEQ.B	L00460
L0045F:
	MOVE.W	_numpass_tmp(A4),D3
	MULU.W	#66,D3
	LEA	_passages(A4),A6	;_passages
	MOVEA.L	D3,A3
	ADDA.L	A6,A3
	MOVE.W	$0010(A3),D3
	EXT.L	D3
	ASL.L	#2,D3
	MOVEA.L	D3,A6
	ADDA.L	A3,A6
	MOVE.W	$0008(A5),$0014(A6)
	MOVE.W	$000A(A5),$0012(A6)
	ADDQ.W	#1,$0010(A3)
	BRA.B	L00461
L00460:
	MOVE.B	(A2),D3
	AND.B	#F_SEEN,D3	;F_SEEN
	BEQ.B	L0045B
L00461:
	MOVE.B	_numpass_tmp+1(A4),D3
	OR.B	D3,(A2)

	MOVE.W	$000A(A5),-(A7)
	MOVE.W	$0008(A5),D3
	ADDQ.W	#1,D3
	MOVE.W	D3,-(A7)
	JSR	_numpass(PC)
	ADDQ.W	#4,A7

	MOVE.W	$000A(A5),-(A7)
	MOVE.W	$0008(A5),D3
	SUBQ.W	#1,D3
	MOVE.W	D3,-(A7)
	JSR	_numpass(PC)
	ADDQ.W	#4,A7

	MOVE.W	$000A(A5),D3
	ADDQ.W	#1,D3
	MOVE.W	D3,-(A7)
	MOVE.W	$0008(A5),-(A7)
	JSR	_numpass(PC)
	ADDQ.W	#4,A7

	MOVE.W	$000A(A5),D3
	SUBQ.W	#1,D3
	MOVE.W	D3,-(A7)
	MOVE.W	$0008(A5),-(A7)
	JSR	_numpass(PC)
	ADDQ.W	#4,A7

	BRA.W	L0045B

_psplat:
	MOVE.W	$0006(A7),d0
	MOVE.W	$0004(A7),d1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level
	MOVE.B	#$23,$00(A6,D0.W)	;'#' PASSAGE

	MOVEA.L	__flags(A4),A6	;__flags
	ORI.B	#F_SEEN,$00(A6,D0.W)	;set F_SEEN

	RTS

__abs:
	TST.W	D0
	BGE.B	1$
	NEG.W	D0
1$	RTS

