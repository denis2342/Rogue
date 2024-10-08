;/*
; * conn:
; *  Draw a corridor from a room in a certain direction.
; */

_conn:
	LINK	A5,#-$0026
	MOVEM.L	D4/D5,-(A7)
	MOVE.W	$0008(A5),D3
	CMP.W	$000A(A5),D3
	BGE.B	L00420

	MOVE.W	$0008(A5),D5
	MOVE.W	$0008(A5),D3
	ADDQ.W	#1,D3
	CMP.W	$000A(A5),D3
	BNE.B	L0041E

	MOVE.W	#$0072,-$0012(A5)
	BRA.B	L0041F
L0041E:
	MOVE.W	#$0064,-$0012(A5)
L0041F:
	BRA.B	L00422
L00420:
	MOVE.W	$000A(A5),D5
	MOVE.W	$000A(A5),D3
	ADDQ.W	#1,D3
	CMP.W	$0008(A5),D3
	BNE.B	L00421

	MOVE.W	#$0072,-$0012(A5)
	BRA.B	L00422
L00421:
	MOVE.W	#$0064,-$0012(A5)
L00422:
	MOVE.W	D5,D3
	MULU.W	#$0042,D3
	LEA	_rooms(A4),A6	;_rooms
	ADD.L	A6,D3
	MOVE.L	D3,-$0004(A5)
	CMPI.W	#$0064,-$0012(A5)
	BNE.W	L0042C

	MOVE.W	D5,D4
	ADDQ.W	#3,D4
	MOVE.W	D4,D3
	MULS.W	#66,D3
	LEA	_rooms(A4),A6	;_rooms
	ADD.L	A6,D3
	MOVE.L	D3,-$0008(A5)
	CLR.W	-$0016(A5)
	MOVE.W	#$0001,-$0014(A5)
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3
	BEQ.B	L00423

	MOVEA.L	-$0004(A5),A6
	MOVE.W	$000E(A6),D3
	AND.W	#$0004,D3
	BEQ.B	L00425
L00423:
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$0002(A6),D3
	ADD.W	$0006(A6),D3
	SUBQ.W	#1,D3
	MOVE.W	D3,-$0020(A5)
L00424:
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$0004(A6),D0
	SUBQ.W	#2,D0
	JSR	_rnd
	MOVEA.L	-$0004(A5),A6
	ADD.W	(A6),D0
	ADDQ.W	#1,D0
	MOVE.W	D0,-$0022(A5)

	MOVE.W	-$0022(A5),d0
	MOVE.W	-$0020(A5),d1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level
	CMP.B	#$20,$00(A6,D0.W)	;' ' SPACE
	BEQ.B	L00424

	BRA.B	L00426
L00425:
	MOVEA.L	-$0004(A5),A6
	MOVE.W	(A6),-$0022(A5)
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$0002(A6),-$0020(A5)
L00426:
	MOVEA.L	-$0008(A5),A6
	MOVE.W	$0002(A6),-$0024(A5)
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3
	BEQ.B	L00427

	MOVE.W	$000E(A6),D3
	AND.W	#$0004,D3
	BEQ.B	L00428
L00427:
	MOVEA.L	-$0008(A5),A6
	MOVE.W	$0004(A6),D0
	SUBQ.W	#2,D0
	JSR	_rnd
	MOVEA.L	-$0008(A5),A6
	ADD.W	(A6),D0
	ADDQ.W	#1,D0
	MOVE.W	D0,-$0026(A5)

	MOVE.W	-$0026(A5),d0
	MOVE.W	-$0024(A5),d1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level
	CMP.B	#$20,$00(A6,D0.W)	;' ' SPACE
	BEQ.B	L00427
	BRA.B	L00429
L00428:
	MOVEA.L	-$0008(A5),A6
	MOVE.W	(A6),-$0026(A5)
L00429:
	MOVE.W	-$0020(A5),D0
	SUB.W	-$0024(A5),D0
	JSR	__abs(PC)

	SUBQ.W	#1,D0
	MOVE.W	D0,-$000A(A5)
	CLR.W	-$001C(A5)
	MOVE.W	-$0022(A5),D3
	CMP.W	-$0026(A5),D3
	BGE.B	L0042A

	MOVE.W	#$0001,-$001E(A5)
	BRA.B	L0042B
L0042A:
	MOVE.W	#$FFFF,-$001E(A5)
L0042B:
	MOVE.W	-$0022(A5),D0
	SUB.W	-$0026(A5),D0
	JSR	__abs(PC)

	MOVE.W	D0,-$000E(A5)
	BRA.W	L00436
L0042C:
	CMPI.W	#$0072,-$0012(A5)	;'r'
	BNE.W	L00436

	MOVE.W	D5,D4
	ADDQ.W	#1,D4
	MOVE.W	D4,D3
	MULU.W	#66,D3
	LEA	_rooms(A4),A6	;_rooms
	ADD.L	A6,D3
	MOVE.L	D3,-$0008(A5)
	MOVE.W	#$0001,-$0016(A5)
	CLR.W	-$0014(A5)
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3
	BEQ.B	L0042D

	MOVEA.L	-$0004(A5),A6
	MOVE.W	$000E(A6),D3
	AND.W	#$0004,D3
	BEQ.B	L0042F
L0042D:
	MOVEA.L	-$0004(A5),A6
	MOVE.W	(A6),D3
	ADD.W	$0004(A6),D3
	SUBQ.W	#1,D3
	MOVE.W	D3,-$0022(A5)
L0042E:
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$0006(A6),D0
	SUBQ.W	#2,D0
	JSR	_rnd
	MOVEA.L	-$0004(A5),A6
	ADD.W	$0002(A6),D0
	ADDQ.W	#1,D0
	MOVE.W	D0,-$0020(A5)

	MOVE.W	-$0022(A5),d0
	MOVE.W	-$0020(A5),d1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level
	CMP.B	#$20,$00(A6,D0.W)	;' ' SPACE
	BEQ.B	L0042E

	BRA.B	L00430
L0042F:
	MOVEA.L	-$0004(A5),A6
	MOVE.W	(A6),-$0022(A5)
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$0002(A6),-$0020(A5)
L00430:
	MOVEA.L	-$0008(A5),A6
	MOVE.W	(A6),-$0026(A5)
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3
	BEQ.B	L00431

	MOVE.W	$000E(A6),D3
	AND.W	#$0004,D3
	BEQ.B	L00432
L00431:
	MOVEA.L	-$0008(A5),A6
	MOVE.W	$0006(A6),D0
	SUBQ.W	#2,D0
	JSR	_rnd
	MOVEA.L	-$0008(A5),A6
	ADD.W	$0002(A6),D0
	ADDQ.W	#1,D0
	MOVE.W	D0,-$0024(A5)

	MOVE.W	-$0026(A5),d0
	MOVE.W	-$0024(A5),d1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level
	CMP.B	#$20,$00(A6,D0.W)	;' ' SPACE
	BEQ.B	L00431

	BRA.B	L00433
L00432:
	MOVEA.L	-$0008(A5),A6
	MOVE.W	$0002(A6),-$0024(A5)
L00433:
	MOVE.W	-$0022(A5),D0
	SUB.W	-$0026(A5),D0
	JSR	__abs(PC)

	SUBQ.W	#1,D0
	MOVE.W	D0,-$000A(A5)
	MOVE.W	-$0020(A5),D3
	CMP.W	-$0024(A5),D3
	BGE.B	L00434

	MOVE.W	#$0001,-$001C(A5)
	BRA.B	L00435
L00434:
	MOVE.W	#$FFFF,-$001C(A5)
L00435:
	CLR.W	-$001E(A5)
	MOVE.W	-$0020(A5),D0
	SUB.W	-$0024(A5),D0
	JSR	__abs(PC)

	MOVE.W	D0,-$000E(A5)
L00436:
	MOVE.W	-$000A(A5),D0
	SUBQ.W	#1,D0
	JSR	_rnd
	ADDQ.W	#1,D0
	MOVE.W	D0,-$000C(A5)
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3
	BNE.B	L00437

	PEA	-$0022(A5)
	MOVE.L	-$0004(A5),-(A7)
	JSR	_door(PC)
	ADDQ.W	#8,A7
	BRA.B	L00438
L00437:
	MOVE.W	-$0022(A5),-(A7)
	MOVE.W	-$0020(A5),-(A7)
	JSR	_psplat(PC)
	ADDQ.W	#4,A7
L00438:
	MOVEA.L	-$0008(A5),A6
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3
	BNE.B	L00439

	PEA	-$0026(A5)
	MOVE.L	-$0008(A5),-(A7)
	JSR	_door(PC)
	ADDQ.W	#8,A7
	BRA.B	L0043A
L00439:
	MOVE.W	-$0026(A5),-(A7)
	MOVE.W	-$0024(A5),-(A7)
	JSR	_psplat(PC)
	ADDQ.W	#4,A7
L0043A:
	MOVE.W	-$0022(A5),-$001A(A5)
	MOVE.W	-$0020(A5),-$0018(A5)
L0043B:
	TST.W	-$000A(A5)
	BEQ.B	L0043E

	MOVE.W	-$0016(A5),D3
	ADD.W	D3,-$001A(A5)
	MOVE.W	-$0014(A5),D3
	ADD.W	D3,-$0018(A5)
	MOVE.W	-$000A(A5),D3
	CMP.W	-$000C(A5),D3
	BNE.B	L0043D
L0043C:
	MOVE.W	-$000E(A5),D3
	SUBQ.W	#1,-$000E(A5)
	TST.W	D3
	BEQ.B	L0043D

	MOVE.W	-$001A(A5),-(A7)
	MOVE.W	-$0018(A5),-(A7)
	JSR	_psplat(PC)
	ADDQ.W	#4,A7
	MOVE.W	-$001E(A5),D3
	ADD.W	D3,-$001A(A5)
	MOVE.W	-$001C(A5),D3
	ADD.W	D3,-$0018(A5)
	BRA.B	L0043C
L0043D:
	MOVE.W	-$001A(A5),-(A7)
	MOVE.W	-$0018(A5),-(A7)
	JSR	_psplat(PC)
	ADDQ.W	#4,A7
	SUBQ.W	#1,-$000A(A5)
	BRA.B	L0043B
L0043E:
	MOVE.W	-$0016(A5),D3
	ADD.W	D3,-$001A(A5)
	MOVE.W	-$0014(A5),D3
	ADD.W	D3,-$0018(A5)
	PEA	-$0026(A5)
	PEA	-$001A(A5)
	JSR	__ce
	ADDQ.W	#8,A7
	TST.W	D0
	BNE.B	L0043F

	MOVE.W	-$0016(A5),D3
	SUB.W	D3,-$0026(A5)
	MOVE.W	-$0014(A5),D3
	SUB.W	D3,-$0024(A5)
	MOVE.W	-$0026(A5),-(A7)
	MOVE.W	-$0024(A5),-(A7)
	JSR	_psplat(PC)
	ADDQ.W	#4,A7
L0043F:
	MOVEM.L	(A7)+,D4/D5
	UNLK	A5
	RTS


;/*
; * do_rooms:
; *  Create rooms and corridors with a connectivity graph
; */

_do_rooms:
	LINK	A5,#-$001C
	MOVEM.L	D4/D5/A2,-(A7)

	MOVE.W	_maxrow(A4),D3	;_maxrow
	ADDQ.W	#1,D3
	MOVE.W	D3,-$0016(A5)
	MOVE.W	_level(A4),-$0014(A5)	;_level
	MOVE.W	#$0014,-$000E(A5)
	MOVE.W	-$0016(A5),D3
	EXT.L	D3
	DIVS.W	#$0003,D3
	MOVE.W	D3,-$000C(A5)
	LEA	_rooms(A4),A6	;_rooms
	MOVE.L	A6,-$0004(A5)
L00901:
	MOVEA.L	-$0004(A5),A6
	CLR.W	$000E(A6)
	CLR.W	$0010(A6)
	CLR.W	$000C(A6)
	ADDI.L	#$00000042,-$0004(A5)
	LEA	_rooms_end(A4),A6	;_rooms_end
	MOVEA.L	-$0004(A5),A1
	CMPA.L	A6,A1
	BCS.B	L00901

	MOVEq	#$0004,D0
	JSR	_rnd
	MOVE.W	D0,D4
	BRA.B	L00903
L00902:
	JSR	_rnd_room
	MOVE.W	D0,D5
	MULU.W	#$0042,D0
	LEA	_rooms(A4),A6	;_rooms
	ADD.L	A6,D0
	MOVE.L	D0,-$0004(A5)
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$000E(A6),D3
	AND.W	#$0004,D3
	BNE.B	L00902

;	MOVEA.L	-$0004(A5),A6
	ORI.W	#$0002,$000E(A6)
	CMP.W	#$0002,D5
	BLE.B	L00903

	CMP.W	#$0006,D5
	BGE.B	L00903

	CMPI.W	#$000A,_level(A4)	;_level
	BLE.B	L00903

	MOVEq	#$0008,D0
	JSR	_rnd
	MOVE.W	_level(A4),D3	;_level
	SUB.W	#$0009,D3
	CMP.W	D3,D0
	BGE.B	L00903

	MOVEA.L	-$0004(A5),A6
	ORI.W	#$0004,$000E(A6)
L00903:
	DBRA	D4,L00902

	MOVEQ	#$00,D4
	LEA	_rooms(A4),A6	;_rooms
	MOVE.L	A6,-$0004(A5)
	BRA.W	L00913
L00905:
	MOVE.W	D4,D3
	EXT.L	D3
	DIVU.W	#$0003,D3
	move.l	d3,d0
	SWAP	D3
	MULU.W	-$000E(A5),D3
	ADDQ.W	#1,D3
	MOVE.W	D3,-$000A(A5)

	MULU.W	-$000C(A5),D0
	MOVE.W	D0,-$0008(A5)
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$000E(A6),D0
	AND.W	#$0002,D0
	BEQ.W	L00908

;	MOVEA.L	-$0004(A5),A6
	MOVE.W	$000E(A6),D3
	AND.W	#$0004,D3
	BEQ.B	L00906

;	MOVEA.L	-$0004(A5),A6
	MOVE.W	-$000A(A5),(A6)
;	MOVEA.L	-$0004(A5),A6
	MOVE.W	-$0008(A5),$0002(A6)
	MOVE.L	-$0004(A5),-(A7)
	JSR	_draw_maze(PC)
	ADDQ.W	#4,A7
	BRA.B	L00907
L00906:
	MOVE.W	-$000E(A5),D3
	SUBQ.W	#2,D3

	MOVE.W	D3,D0
	JSR	_rnd
	ADD.W	-$000A(A5),D0

	MOVEA.L	-$0004(A5),A6
	ADDQ.W	#1,D0
	MOVE.W	D0,(A6)
	MOVE.L	A6,-(A7)
	MOVE.W	-$000C(A5),D3
	SUBQ.W	#2,D3

	MOVE.W	D3,D0
	JSR	_rnd
	ADD.W	-$0008(A5),D0
	MOVEA.L	(A7)+,A6
	ADDQ.W	#1,D0
	MOVE.W	D0,$0002(A6)
	MOVEA.L	-$0004(A5),A6
	MOVE.W	#$FFC4,$0004(A6)
	MOVE.W	-$0016(A5),D3
	NEG.W	D3
	MOVE.W	D3,$0004(A6)
	MOVEA.L	-$0004(A5),A6
	CMPI.W	#$0000,$0002(A6)
	BLE.B	L00906

	MOVE.W	-$0016(A5),D3
	SUBQ.W	#1,D3
	MOVE.W	$0002(A6),D2
	CMP.W	D3,D2
	BGE.B	L00906
L00907:
	BRA.W	L00912
L00908:
	MOVEq	#$000A,D0
	JSR	_rnd
	MOVE.W	_level(A4),D3	;_level
	SUBQ.W	#1,D3
	CMP.W	D3,D0
	BGE.B	L00909

	MOVEA.L	-$0004(A5),A6
	ORI.W	#$0001,$000E(A6)
L00909:
	MOVE.W	-$000E(A5),D3
	SUBQ.W	#4,D3
	MOVE.W	D3,D0
	JSR	_rnd
	ADDQ.W	#4,D0
	MOVEA.L	-$0004(A5),A6
	MOVE.W	D0,$0004(A6)

	MOVE.W	-$000C(A5),D3
	SUBQ.W	#4,D3
	MOVE.W	D3,D0
	JSR	_rnd
	ADDQ.W	#4,D0
	MOVEA.L	-$0004(A5),A6
	MOVE.W	D0,$0006(A6)

	MOVE.W	-$000E(A5),D3
	SUB.W	$0004(A6),D3
	MOVE.W	D3,D0
	JSR	_rnd
	ADD.W	-$000A(A5),D0
	MOVEA.L	-$0004(A5),A6
	MOVE.W	D0,(A6)

	MOVE.W	-$000C(A5),D3
	SUB.W	$0006(A6),D3
	MOVE.W	D3,D0
	JSR	_rnd
	ADD.W	-$0008(A5),D0
	MOVEA.L	-$0004(A5),A6
	MOVE.W	D0,$0002(A6)

	TST.W	$0002(A6)
	BEQ.W	L00909

	MOVE.L	A6,-(A7)
	JSR	_draw_room(PC)
	ADDQ.W	#4,A7

	MOVEq	#$0002,D0
	JSR	_rnd
	TST.W	D0
	BNE.W	L0090D

	TST.B	_saw_amulet(A4)	;_saw_amulet
	BEQ.B	L0090A

	MOVE.W	_level(A4),D3	;_level
	CMP.W	_max_level(A4),D3	;_max_level
	BLT.W	L0090D
L0090A:
	JSR	_new_item
	MOVE.L	D0,-$001A(A5)
;	TST.L	D0
	BEQ.W	L0090D

	MOVE.W	_level(A4),D0	;_level
	MULU.W	#$000A,D0
	ADD.W	#$0032,D0
	JSR	_rnd

	MOVEA.L	-$001A(A5),A6
	MOVEA.L	-$0004(A5),A1

	ADDQ.W	#2,D0
	MOVE.W	D0,$000C(A1)
	MOVE.W	D0,$0026(A6)
L0090B:
	MOVEA.L	-$0004(A5),A6
	PEA	$0008(A6)
	MOVE.L	A6,-(A7)
	JSR	_rnd_pos(PC)
	ADDQ.W	#8,A7
	MOVEA.L	-$0004(A5),A6

	MOVE.W	$0008(A6),d0
	MOVE.W	$000A(A6),d1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level
	MOVE.B	$00(A6,D0.W),-$001B(A5)
	MOVE.B	-$001B(A5),D3
	CMP.b	#'.',D3		;FLOOR
	BEQ.B	L0090C

;	MOVE.B	-$001B(A5),D3
	CMP.b	#'#',D3		;PASSAGE
	BEQ.B	L0090C
	BRA.B	L0090B
L0090C:
	MOVEA.L	-$001A(A5),A6
	ADDA.L	#$0000000C,A6
	MOVEA.L	-$0004(A5),A1
	ADDQ.L	#8,A1
	MOVE.L	(A1)+,(A6)+
	MOVEA.L	-$001A(A5),A6
	MOVE.W	#$0020,$0028(A6)
	MOVE.W	#$0001,$002C(A6)
	MOVE.W	#$002A,$000A(A6)

	MOVE.L	-$001A(A5),-(A7)
	PEA	_lvl_obj(A4)	;_lvl_obj
	JSR	__attach
	ADDQ.W	#8,A7
	MOVEA.L	-$0004(A5),A6

	MOVE.W	$0008(A6),d0
	MOVE.W	$000A(A6),d1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level
	MOVE.B	#'*',$00(A6,D0.W)
L0090D:
	MOVEq	#$0064,D0
	JSR	_rnd
	MOVEA.L	-$0004(A5),A6
	CMPI.W	#$0000,$000C(A6)
	BLE.B	L0090E

	MOVEQ	#$50,D3
	BRA.B	L0090F
L0090E:
	MOVEQ	#$19,D3
L0090F:
	CMP.W	D3,D0
	BGE.B	L00912

	JSR	_new_item
	MOVEA.L	D0,A2
	TST.L	D0
	BEQ.B	L00912
L00910:
	PEA	-$0012(A5)
	MOVE.L	-$0004(A5),-(A7)
	JSR	_rnd_pos(PC)
	ADDQ.W	#8,A7

	MOVE.W	-$0012(A5),-(A7)
	MOVE.W	-$0010(A5),-(A7)
	JSR	_winat
	ADDQ.W	#4,A7

	CMP.B	#$2E,D0		;'.' FLOOR
	BEQ.B	L00911

	CMP.B	#$23,D0		;'#' PASSAGE
	BNE.B	L00910
L00911:
	PEA	-$0012(A5)
	CLR.L	-(A7)
	JSR	_randmonster
	ADDQ.W	#4,A7

	MOVE.W	D0,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_new_monster
	LEA	$000A(A7),A7
	MOVE.L	A2,-(A7)
	JSR	_give_pack
	ADDQ.W	#4,A7
L00912:
	ADDI.L	#$00000042,-$0004(A5)
	ADDQ.W	#1,D4
L00913:
	CMP.W	#$0009,D4	;make 9 rooms
	BLT.W	L00905

	MOVEM.L	(A7)+,D4/D5/A2
	UNLK	A5
	RTS

;/*
; * draw_room:
; *  Draw a box around a room and lay down the floor for normal
; *  rooms; for maze rooms, draw maze.
; */

_draw_room:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5,-(A7)
	MOVEA.L	$0008(A5),A6
	MOVE.W	(A6),-(A7)
	MOVE.L	$0008(A5),-(A7)
	JSR	_vert(PC)
	ADDQ.W	#6,A7

	MOVEA.L	$0008(A5),A6
	MOVE.W	(A6),D3
	ADD.W	$0004(A6),D3
	SUBQ.W	#1,D3
	MOVE.W	D3,-(A7)
	MOVE.L	$0008(A5),-(A7)
	JSR	_vert(PC)
	ADDQ.W	#6,A7

	MOVEA.L	$0008(A5),A6
	MOVE.W	$0002(A6),-(A7)
	MOVE.L	$0008(A5),-(A7)
	JSR	_horiz(PC)
	ADDQ.W	#6,A7

	MOVEA.L	$0008(A5),A6
	MOVE.W	$0002(A6),D3
	ADD.W	$0006(A6),D3
	SUBQ.W	#1,D3
	MOVE.W	D3,-(A7)
	MOVE.L	$0008(A5),-(A7)
	JSR	_horiz(PC)

	ADDQ.W	#6,A7
	MOVEA.L	$0008(A5),A6

	MOVE.W	(A6),d0
	MOVE.W	$0002(A6),d1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level
	MOVE.B	#'<',$00(A6,D0.W)
	MOVEA.L	$0008(A5),A6

	MOVE.W	(A6),D0
	ADD.W	$0004(A6),D0
	SUBQ.W	#1,D0
	MOVE.W	$0002(A6),d1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level
	MOVE.B	#'>',$00(A6,D0.W)
	MOVEA.L	$0008(A5),A6

	MOVE.W	(A6),d0
	MOVE.W	$0002(A6),D1
	ADD.W	$0006(A6),D1
	SUBQ.W	#1,D1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level
	MOVE.B	#'{',$00(A6,D0.W)
	MOVEA.L	$0008(A5),A6

	MOVE.W	(A6)+,D0
	MOVE.W	(A6)+,D1
	ADD.W	(A6)+,D0
	ADD.W	(A6)+,D1
	SUBQ.W	#1,D0
	SUBQ.W	#1,D1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level
	MOVE.B	#'}',$00(A6,D0.W)
	MOVEA.L	$0008(A5),A6
	MOVE.W	$0002(A6),D4
	ADDQ.W	#1,D4
	BRA.B	L00917
L00914:
	MOVEA.L	$0008(A5),A6
	MOVE.W	(A6),D5
	ADDQ.W	#1,D5
	BRA.B	L00916
L00915:
	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level
	MOVE.B	#'.',$00(A6,D0.W)
	ADDQ.W	#1,D5
L00916:
	MOVEA.L	$0008(A5),A6
	MOVE.W	(A6),D3
	ADD.W	$0004(A6),D3
	SUBQ.W	#1,D3
	CMP.W	D3,D5
	BLT.B	L00915

	ADDQ.W	#1,D4
L00917:
	MOVEA.L	$0008(A5),A6
	MOVE.W	$0002(A6),D3
	ADD.W	$0006(A6),D3
	SUBQ.W	#1,D3
	CMP.W	D3,D4
	BLT.B	L00914

	MOVEM.L	(A7)+,D4/D5
	UNLK	A5
	RTS

;/*
; * vert:
; *  Draw a vertical line
; */

_vert:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5/A2,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVE.W	$000C(A5),D4
	MOVE.W	$0002(A2),D5
	ADDQ.W	#1,D5
	BRA.B	L00919
L00918:
	MOVE.W	D4,d0
	MOVE.W	D5,d1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level
	MOVE.B	#'|',$00(A6,D0.W)
	ADDQ.W	#1,D5
L00919:
	MOVE.W	$0006(A2),D3
	ADD.W	$0002(A2),D3
	SUBQ.W	#1,D3
	CMP.W	D3,D5
	BLE.B	L00918

	MOVEM.L	(A7)+,D4/D5/A2
	UNLK	A5
	RTS

;/*
; * horiz:
; *  Draw a horizontal line
; */

_horiz:
	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)

	MOVEA.L	$0008(A5),A6
	MOVE.W	(A6),D4
	BRA.B	L0091B
L0091A:
	MOVE.W	D4,d0
	MOVE.W	$000C(A5),d1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level
	MOVE.B	#'-',$00(A6,D0.W)
	ADDQ.W	#1,D4
L0091B:
	MOVEA.L	$0008(A5),A6
	MOVE.W	(A6),D3
	ADD.W	$0004(A6),D3
	SUBQ.W	#1,D3
	CMP.W	D3,D4
	BLE.B	L0091A

	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

;/*
; * rnd_pos:
; *  Pick a random spot in a room
; */

_rnd_pos:
	LINK	A5,#-$0000
	MOVEM.L	A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVEA.L	$000C(A5),A3

	MOVE.W	$0004(A2),D0
	SUBQ.W	#2,D0

	JSR	_rnd
	ADD.W	(A2),D0
	ADDQ.W	#1,D0
	MOVE.W	D0,(A3)+
	MOVE.W	$0006(A2),D0
	SUBQ.W	#2,D0

	JSR	_rnd
	ADD.W	$0002(A2),D0
	ADDQ.W	#1,D0
	MOVE.W	D0,(A3)

	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

;/*
; * enter_room:
; *  Code that is executed whenver you appear in a room
; */

_enter_room:
	LINK	A5,#-$0000
	MOVEM.L	D4-D6/A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVE.L	A2,-(A7)
	JSR	_roomin
	ADDQ.W	#4,A7
	MOVE.L	D0,_player+42(A4)	;_player + 42 (proom)
	MOVEA.L	D0,A3
	TST.B	_bailout(A4)	;_bailout
	BNE.B	L0091C

	MOVE.W	$000E(A3),D3
	AND.W	#$0002,D3	;ISGONE
	BEQ.B	L0091D

	MOVE.W	$000E(A3),D3
	AND.W	#$0004,D3	;ISMAZE
	BNE.B	L0091D
L0091C:
	MOVEM.L	(A7)+,D4-D6/A2/A3
	UNLK	A5
	RTS

L0091D:
	MOVE.L	A3,-(A7)
	JSR	_door_open
	ADDQ.W	#4,A7
	MOVE.L	A3,-(A7)
	JSR	_is_dark
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.W	L00925

	MOVE.W	_player+22(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BNE.W	L00925

	MOVE.W	$000E(A3),D3
	AND.W	#$0004,D3	;ISMAZE
	BNE.W	L00925

	MOVE.W	$0002(A3),D4
	BRA.W	L00924
L0091E:
	MOVE.W	(A3),d1
	MOVE.W	D4,d0
	JSR	_movequick

	MOVE.W	(A3),D5
	BRA.B	L00923
L0091F:
	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_moatquick

	MOVE.L	D0,D6
;	TST.L	D6
	BEQ.B	L00920

	MOVE.L	D6,-(A7)
	JSR	_see_monst
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.B	L00921
L00920:
	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level
	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	MOVE.W	D3,-(A7)
	JSR	_addch
	ADDQ.W	#2,A7
	BRA.B	L00922
L00921:
	MOVE.L	D6,-(A7)

	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level
	MOVEA.L	(A7)+,A1
	MOVE.B	$00(A6,D0.W),$0011(A1)
	MOVEA.L	D6,A6
	MOVEQ	#$00,D3
	MOVE.B	$0010(A6),D3
	MOVE.W	D3,-(A7)
	JSR	_addch
	ADDQ.W	#2,A7
L00922:
	ADDQ.W	#1,D5
L00923:
	MOVE.W	$0004(A3),D3
	ADD.W	(A3),D3
	CMP.W	D3,D5
	BLT.B	L0091F

	ADDQ.W	#1,D4
L00924:
	MOVE.W	$0006(A3),D3
	ADD.W	$0002(A3),D3
	CMP.W	D3,D4
	BLT.W	L0091E
L00925:
	BRA.W	L0091C

;/*
; * leave_room:
; *  Code for when we exit a room
; */

_leave_room:
	LINK	A5,#-$0000
	MOVEM.L	D4-D7/A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVEA.L	_player+42(A4),A3	;_player + 42 (proom)

	MOVE.W	(A2),d0
	MOVE.W	$0002(A2),d1
	JSR	_INDEXquick

	MOVEA.L	__flags(A4),A6	;__flags
;	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	AND.W	#F_PNUM,D3	;F_PNUM passage number mask
	MULU.W	#66,D3
	LEA	_passages(A4),A6	;_passages
	ADD.L	A6,D3
	MOVE.L	D3,_player+42(A4)	;_player + 42 (proom)

	MOVE.L	A3,-(A7)
	JSR	_is_dark
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00926

	MOVE.W	_player+22(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BNE.B	L00926

	MOVEQ	#$20,D3		;' '
	BRA.B	L00927
L00926:
	MOVEQ	#$2E,D3		;'.' FLOOR
L00927:
	MOVE.B	D3,D6
	MOVE.W	$000E(A3),D3
	AND.W	#$0004,D3	;ISMAZE
	BEQ.B	L00928

	MOVEQ	#$23,D6		;'#' PASSAGE
L00928:
	MOVE.W	$0002(A3),D4
	ADDQ.W	#1,D4
	BRA.W	L00933
L00929:
	MOVE.W	(A3),D5
	ADDQ.W	#1,D5
	BRA.W	L00932
L0092A:
	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_mvinch(PC)
	ADDQ.W	#4,A7
	MOVE.B	D0,D7
	JSR	_typech

;	EXT.L	D0
	BRA.B	L00930
L0092C:
	MOVE.B	D6,D3
	CMP.B	#$20,D3
	BNE.B	L0092D

	MOVE.W	#$0020,-(A7)
	JSR	_addch
	ADDQ.W	#2,A7
L0092D:
	BRA.B	L00931
L0092E:
	MOVE.B	D7,D0
	AND.W	#$007F,D0

	JSR	_isupper

	TST.W	D0
	BEQ.B	L0092F

	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_moatquick

	MOVEA.L	D0,A6
	MOVE.B	#$22,$0011(A6)
L0092F:
	MOVEQ	#$00,D3
	MOVE.B	D6,D3
	MOVE.W	D3,-(A7)
	JSR	_addch
	ADDQ.W	#2,A7
	BRA.B	L00931
L00930:
	SUB.w	#$000E,D0	;14
	BEQ.B	L00931
	SUB.w	#$0012,D0	;' ' SPACE
	BEQ.B	L00931
	SUBQ.w	#3,D0		;'#' PASSAGE
	BEQ.B	L00931
	SUBQ.w	#2,D0		;'%' EXIT
	BEQ.B	L00931
	SUB.w	#$0009,D0	;'.' FLOOR
	BEQ.B	L0092C
	BRA.B	L0092E
L00931:
	ADDQ.W	#1,D5
L00932:
	MOVE.W	$0004(A3),D3
	ADD.W	(A3),D3
	SUBQ.W	#1,D3
	CMP.W	D3,D5
	BLT.W	L0092A

	ADDQ.W	#1,D4
L00933:
	MOVE.W	$0006(A3),D3
	ADD.W	$0002(A3),D3
	SUBQ.W	#1,D3
	CMP.W	D3,D4
	BLT.W	L00929

	MOVE.L	A3,-(A7)
	JSR	_door_open
	ADDQ.W	#4,A7

	MOVEM.L	(A7)+,D4-D7/A2/A3
	UNLK	A5
	RTS
