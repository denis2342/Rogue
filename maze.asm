_draw_maze:
	LINK	A5,#-$019C
	MOVEM.L	D4/D5,-(A7)

	LEA	-$00C8(A5),A6
	MOVE.L	A6,maze_tmp+14(A4)
	LEA	-$0190(A5),A6
	MOVE.L	A6,maze_tmp2(A4)
	CLR.W	maze_tmp+12(A4)
	CLR.W	maze_tmp+10(A4)
	MOVEA.L	$0008(A5),A6
	MOVE.W	$0002(A6),maze_tmp+6(A4)
;	TST.W	maze_tmp+6(A4)
	BNE.B	L00799

	MOVEA.L	$0008(A5),A6
	ADDQ.W	#1,$0002(A6)
	MOVE.W	$0002(A6),maze_tmp+6(A4)
L00799:
	MOVEA.L	$0008(A5),A6
	MOVE.W	(A6),D5
	MOVE.W	maze_tmp+6(A4),D4
	MOVE.W	D5,maze_tmp+8(A4)
	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_splat(PC)
	ADDQ.W	#4,A7
	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_new_frontier(PC)
	ADDQ.W	#4,A7
L0079A:
	TST.W	maze_tmp(A4)
	BEQ.B	L0079B

	JSR	_con_frnt(PC)
	MOVE.W	maze_tmp+4(A4),-(A7)
	MOVE.W	maze_tmp+2(A4),-(A7)
	JSR	_new_frontier(PC)
	ADDQ.W	#4,A7
	BRA.B	L0079A
L0079B:
	MOVEA.L	$0008(A5),A6
	MOVE.W	maze_tmp+10(A4),D3
	SUB.W	(A6),D3
	ADDQ.W	#1,D3
	MOVE.W	D3,$0004(A6)
	MOVE.W	maze_tmp+12(A4),D3
	SUB.W	$0002(A6),D3
	ADDQ.W	#1,D3
	MOVE.W	D3,$0006(A6)
L0079C:
	PEA	-$0196(A5)
	MOVE.L	$0008(A5),-(A7)
	JSR	_rnd_pos
	ADDQ.W	#8,A7
	CLR.W	-$0192(A5)
	LEA	_hero_damage+4(A4),A6
	MOVE.L	A6,-$019A(A5)
	MOVE.W	#$0001,-$019C(A5)
	BRA.B	L0079F
L0079D:
	MOVEA.L	-$019A(A5),A6
	MOVE.W	$0002(A6),D4
	ADD.W	-$0194(A5),D4
	MOVE.W	(A6),D5
	ADD.W	-$0196(A5),D5
	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_offmap
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.B	L0079E

	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level
	CMP.B	#$23,$00(A6,D0.W)
	BNE.B	L0079E

	MOVE.W	-$019C(A5),D3
	ADD.W	D3,-$0192(A5)
L0079E:
	ASL.W	-$019C(A5)
	ADDQ.L	#4,-$019A(A5)
L0079F:
	LEA	_lvl_monster_ptr(A4),A6
	MOVEA.L	-$019A(A5),A1
	CMPA.L	A6,A1
	BCS.B	L0079D

	MOVE.W	-$0196(A5),d0
	MOVE.W	-$0194(A5),d1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level
	CMP.B	#$23,$00(A6,D0.W)
	BEQ.W	L0079C

	MOVE.W	-$0192(A5),D3
	EXT.L	D3
	DIVS.W	#$0005,D3
	SWAP	D3
	TST.W	D3
	BNE.W	L0079C

	MOVE.W	-$0196(A5),-(A7)
	MOVE.W	-$0194(A5),-(A7)
	JSR	_splat(PC)
	ADDQ.W	#4,A7

	MOVEM.L	(A7)+,D4/D5
	UNLK	A5
	RTS

_new_frontier:
	LINK	A5,#-$0000

	MOVE.W	$000A(A5),-(A7)
	MOVE.W	$0008(A5),D3
	SUBQ.W	#2,D3
	MOVE.W	D3,-(A7)
	BSR.B	_add_frnt
	ADDQ.W	#4,A7

	MOVE.W	$000A(A5),-(A7)
	MOVE.W	$0008(A5),D3
	ADDQ.W	#2,D3
	MOVE.W	D3,-(A7)
	BSR.B	_add_frnt
	ADDQ.W	#4,A7

	MOVE.W	$000A(A5),D3
	SUBQ.W	#2,D3
	MOVE.W	D3,-(A7)
	MOVE.W	$0008(A5),-(A7)
	BSR.B	_add_frnt
	ADDQ.W	#4,A7

	MOVE.W	$000A(A5),D3
	ADDQ.W	#2,D3
	MOVE.W	D3,-(A7)
	MOVE.W	$0008(A5),-(A7)
	BSR.B	_add_frnt
	ADDQ.W	#4,A7

	UNLK	A5
	RTS

_add_frnt:
	LINK	A5,#-$0000

	MOVE.W	$000A(A5),-(A7)
	MOVE.W	$0008(A5),-(A7)
	JSR	_inrange(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L007A0

	MOVE.W	$000A(A5),d0
	MOVE.W	$0008(A5),d1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level
	CMP.B	#$20,$00(A6,D0.W)
	BNE.B	L007A0

;	MOVE.W	$000A(A5),d0
;	MOVE.W	$0008(A5),d1
;	JSR	_INDEXquick

;	MOVEA.L	__level(A4),A6	;__level
	MOVE.B	#$46,$00(A6,D0.W)
	MOVE.W	maze_tmp(A4),D3
	EXT.L	D3
	ASL.L	#1,D3
	MOVEA.L	maze_tmp+14(A4),A6
	MOVE.W	$0008(A5),$00(A6,D3.L)
	MOVE.W	maze_tmp(A4),D3
	ADDQ.W	#1,maze_tmp(A4)
	EXT.L	D3
	ASL.L	#1,D3
	MOVEA.L	maze_tmp2(A4),A6
	MOVE.W	$000A(A5),$00(A6,D3.L)
L007A0:
	UNLK	A5
	RTS

_con_frnt:
	LINK	A5,#-$000E
	MOVEM.L	D4-D7,-(A7)

	MOVEQ	#$00,D6
	MOVEQ	#$00,D7
	CLR.W	-$000A(A5)
	MOVE.W	maze_tmp(A4),D0
	JSR	_rnd
	MOVE.W	D0,D4

	MOVE.W	D4,D3
	EXT.L	D3
	ASL.L	#1,D3

	MOVEA.L	maze_tmp+14(A4),A6
	MOVE.W	$00(A6,D3.L),maze_tmp+2(A4)

	MOVEA.L	maze_tmp2(A4),A6
	MOVE.W	$00(A6,D3.L),maze_tmp+4(A4)

	MOVEA.L	maze_tmp+14(A4),A6
	MOVE.W	maze_tmp(A4),D2

	SUBQ.W	#1,D2
	EXT.L	D2
	ASL.L	#1,D2
	MOVE.W	$00(A6,D2.L),$00(A6,D3.L)

	MOVEA.L	maze_tmp2(A4),A6
	SUBQ.W	#1,maze_tmp(A4)
	MOVE.W	maze_tmp(A4),D2
	EXT.L	D2
	ASL.L	#1,D2
	MOVE.W	$00(A6,D2.L),$00(A6,D3.L)
	MOVE.W	maze_tmp+4(A4),-(A7)
	MOVE.W	maze_tmp+2(A4),D3
	SUBQ.W	#2,D3
	MOVE.W	D3,-(A7)
	JSR	_maze_at(PC)
	ADDQ.W	#4,A7
	CMP.W	#$0000,D0
	BLE.B	L007A1

	MOVE.W	-$000A(A5),D3
	ADDQ.W	#1,-$000A(A5)
	EXT.L	D3
	ASL.L	#1,D3
	LEA	-$0008(A5),A6
	CLR.W	$00(A6,D3.L)
L007A1:
	MOVE.W	maze_tmp+4(A4),-(A7)
	MOVE.W	maze_tmp+2(A4),D3
	ADDQ.W	#2,D3
	MOVE.W	D3,-(A7)
	JSR	_maze_at(PC)
	ADDQ.W	#4,A7
	CMP.W	#$0000,D0
	BLE.B	L007A2

	MOVE.W	-$000A(A5),D3
	ADDQ.W	#1,-$000A(A5)
	EXT.L	D3
	ASL.L	#1,D3
	LEA	-$0008(A5),A6
	MOVE.W	#$0001,$00(A6,D3.L)
L007A2:
	MOVE.W	maze_tmp+4(A4),D3
	SUBQ.W	#2,D3
	MOVE.W	D3,-(A7)
	MOVE.W	maze_tmp+2(A4),-(A7)
	JSR	_maze_at(PC)
	ADDQ.W	#4,A7
	CMP.W	#$0000,D0
	BLE.B	L007A3

	MOVE.W	-$000A(A5),D3
	ADDQ.W	#1,-$000A(A5)
	EXT.L	D3
	ASL.L	#1,D3
	LEA	-$0008(A5),A6
	MOVE.W	#$0002,$00(A6,D3.L)
L007A3:
	MOVE.W	maze_tmp+4(A4),D3
	ADDQ.W	#2,D3
	MOVE.W	D3,-(A7)
	MOVE.W	maze_tmp+2(A4),-(A7)
	JSR	_maze_at(PC)
	ADDQ.W	#4,A7
	CMP.W	#$0000,D0
	BLE.B	L007A4

	MOVE.W	-$000A(A5),D3
	ADDQ.W	#1,-$000A(A5)
	EXT.L	D3
	ASL.L	#1,D3
	LEA	-$0008(A5),A6
	MOVE.W	#$0003,$00(A6,D3.L)
L007A4:
	MOVE.W	-$000A(A5),D0
	JSR	_rnd
	EXT.L	D0
	ASL.L	#1,D0
	LEA	-$0008(A5),A6
	MOVE.W	$00(A6,D0.L),D5
	MOVE.W	maze_tmp+4(A4),-(A7)
	MOVE.W	maze_tmp+2(A4),-(A7)
	JSR	_splat(PC)
	ADDQ.W	#4,A7
	MOVE.W	D5,D0
	BRA.B	L007AA
L007A5:
	MOVEQ	#$01,D5
	MOVEQ	#-$01,D6
	BRA.B	L007AC
L007A6:
	MOVEQ	#$00,D5
	MOVEQ	#$01,D6
	BRA.B	L007AC
L007A7:
	MOVEQ	#$03,D5
	MOVEQ	#-$01,D7
	BRA.B	L007AC
L007A8:
	MOVEQ	#$02,D5
	MOVEQ	#$01,D7
	BRA.B	L007AC
L007A9:
	dc.w	L007A5-L007AB
	dc.w	L007A6-L007AB
	dc.w	L007A7-L007AB
	dc.w	L007A8-L007AB
L007AA:
	CMP.w	#$0004,D0
	BCC.B	L007AC
	ASL.w	#1,D0
	MOVE.W	L007A9(PC,D0.W),D0
L007AB:	JMP	L007AB(PC,D0.W)
L007AC:
	MOVE.W	maze_tmp+2(A4),D3
	ADD.W	D6,D3
	MOVE.W	D3,-$000C(A5)
	MOVE.W	maze_tmp+4(A4),D3
	ADD.W	D7,D3
	MOVE.W	D3,-$000E(A5)
	MOVE.W	-$000E(A5),-(A7)
	MOVE.W	-$000C(A5),-(A7)
	JSR	_inrange(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L007AD

	MOVE.W	-$000E(A5),-(A7)
	MOVE.W	-$000C(A5),-(A7)
	BSR.B	_splat
	ADDQ.W	#4,A7
L007AD:
	MOVEM.L	(A7)+,D4-D7
	UNLK	A5
	RTS

_maze_at:
	LINK	A5,#-$0000
	MOVE.W	$000A(A5),-(A7)
	MOVE.W	$0008(A5),-(A7)
	JSR	_inrange(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L007AF

	MOVE.W	$000A(A5),d0
	MOVE.W	$0008(A5),d1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level
;	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	CMP.B	#$23,D3
	BNE.B	L007AF
	MOVEQ	#$01,D0
L007AE:
	UNLK	A5
	RTS

L007AF:
	MOVEQ	#$00,D0
	BRA.B	L007AE
_splat:
	LINK	A5,#-$0000

	MOVE.W	$000A(A5),d0
	MOVE.W	$0008(A5),d1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level
	MOVE.B	#$23,$00(A6,D0.W)	;PASSAGE

;	MOVE.W	$000A(A5),d0
;	MOVE.W	$0008(A5),d1
;	JSR	_INDEXquick

	MOVEA.L	__flags(A4),A6	;__flags
	MOVE.B	#$30,$00(A6,D0.W)	;F_LOCKED|F_REAL?
	MOVE.W	$000A(A5),D3
	CMP.W	maze_tmp+10(A4),D3
	BLE.B	L007B0

	MOVE.W	$000A(A5),maze_tmp+10(A4)
L007B0:
	MOVE.W	$0008(A5),D3
	CMP.W	maze_tmp+12(A4),D3
	BLE.B	L007B1

	MOVE.W	$0008(A5),maze_tmp+12(A4)
L007B1:
	UNLK	A5
	RTS

_inrange:
	LINK	A5,#-$0000

	MOVE.W	$0008(A5),D3
	CMP.W	maze_tmp+6(A4),D3
	BLT.B	L007B2

	MOVE.W	_maxrow(A4),D3	;_maxrow
	ADDQ.W	#1,D3
	EXT.L	D3
	DIVU.W	#$0003,D3
	ADD.W	maze_tmp+6(A4),D3
	MOVE.W	$0008(A5),D2
	CMP.W	D3,D2
	BGE.B	L007B2

	MOVE.W	$000A(A5),D3
	CMP.W	maze_tmp+8(A4),D3
	BLT.B	L007B2

	moveq	#$14,d3
	ADD.W	maze_tmp+8(A4),D3
	MOVE.W	$000A(A5),D2
	CMP.W	D3,D2
	BGE.B	L007B2

	MOVEq	#$0001,D0
	BRA.B	L007B3
L007B2:
	CLR.W	D0
L007B3:
	UNLK	A5
	RTS

