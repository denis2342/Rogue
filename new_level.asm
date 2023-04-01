;/*
; * new_level:
; *  Dig and draw a new level
; */

_new_level:
	LINK	A5,#-$0004
	MOVEM.L	D4-D6/A2/A3,-(A7)
	JSR	_NewRank(PC)
	ANDI.W	#~C_ISHELD,-$52B4(A4)	;clear C_ISHELD ($80) _player + 22 (flags)
	CLR.B	-$66FA(A4)	;_no_more_fears
	MOVE.W	-$60B4(A4),D3	;_level
	CMP.W	-$60BA(A4),D3	;_ntraps
	BLE.B	L00183

	MOVE.W	-$60B4(A4),-$60BA(A4)	;_level,_ntraps
L00183:
	MOVEq	#$0020,d1
	MOVE.W	#1760,d0
	MOVE.L	-$519C(A4),a0	;__level
	JSR	_memset

	MOVEq	#F_REAL,d1	;what you see is what you get
	MOVE.W	#1760,d0
	MOVE.L	-$5198(A4),a0	;__flags
	JSR	_memset

	MOVEA.L	-$6CAC(A4),A2	;_mlist
	BRA.B	L00185
L00184:
	PEA	$002E(A2)
	JSR	__free_list(PC)
	ADDQ.W	#4,A7
	MOVEA.L	(A2),A2
L00185:
	MOVE.L	A2,D3
	BNE.B	L00184

	PEA	-$6CAC(A4)	;_mlist
	JSR	__free_list(PC)
	ADDQ.W	#4,A7

	JSR	_f_restor

	PEA	-$6CB0(A4)	;_lvl_obj
	JSR	__free_list(PC)
	ADDQ.W	#4,A7

	JSR	_do_rooms
	ST	-$66FB(A4)	;_new_stats
	JSR	_clear
	JSR	_status
	JSR	_do_passages(PC)
	ADDQ.W	#1,-$60A6(A4)	;_no_food
	JSR	_put_things(PC)
	PEA	-$0004(A5)
	JSR	_blank_spot
	ADDQ.W	#4,A7
	MOVE.W	D0,D6
	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	#$25,$00(A6,D6.W)	;'%' STAIRS

	MOVEq	#10,D0
	JSR	_rnd
	CMP.W	-$60B4(A4),D0	;_level
	BGE.B	L00188

	MOVE.W	-$60B4(A4),D0	;_level
	EXT.L	D0
	DIVS.W	#$0004,D0
	JSR	_rnd
	ADDQ.W	#1,D0
	MOVE.W	D0,-$60B8(A4)	;_dnum
	CMPI.W	#10,D0		;_dnum
	BLE.B	L00186

	MOVE.W	#$000A,-$60B8(A4)	;_dnum
L00186:
	MOVE.W	-$60B8(A4),D5	;_dnum
L00187:
	MOVE.W	D5,D3
	SUBQ.W	#1,D5
	TST.W	D3
	BEQ.B	L00188

	PEA	-$0004(A5)
	JSR	_blank_spot
	ADDQ.W	#4,A7

	MOVE.W	D0,D6
	MOVE.W	D6,D3
	EXT.L	D3
	MOVEA.L	D3,A3
	ADDA.L	-$5198(A4),A3	;__flags
	ANDI.B	#~F_REAL,(A3)	;clear F_REAL

	MOVEq	#$0006,D0
	JSR	_rnd

	OR.B	D0,(A3)
	BRA.B	L00187
L00188:
	PEA	-$52C0(A4)	;_player + 10
	JSR	_blank_spot
	ADDQ.W	#4,A7

	MOVE.W	D0,D6
	MOVEA.L	-$5198(A4),A6	;__flags
	MOVE.B	$00(A6,D6.W),D3
	AND.B	#F_REAL,D3	;F_REAL
	BEQ.B	L00188

	MOVE.W	-$52C0(A4),d1	;_player + 10
	MOVE.W	-$52BE(A4),d0	;_player + 12
	JSR	_moatquick

	TST.L	D0
	BNE.B	L00188

	CLR.W	-$60B0(A4)	;_mpos
	PEA	-$52C0(A4)	;_player + 10
	JSR	_enter_room
	ADDQ.W	#4,A7

	MOVEq	#$0040,d2	;'@' PLAYER
	MOVE.W	-$52C0(A4),d1	;hero.y
	MOVE.W	-$52BE(A4),d0	;hero.x
	JSR	_mvaddchquick

	LEA	-$6090(A4),A6
	LEA	-$52C0(A4),A1	;_player + 10
	MOVE.L	(A1)+,(A6)+
	MOVE.L	-$52A0(A4),-$48C0(A4)	;_player + 42 (proom),_oldrp
	JSR	_InitGadgets

	MOVEM.L	(A7)+,D4-D6/A2/A3
	UNLK	A5
	RTS

;/*
; * rnd_room:
; *  Pick a room that is really there
; */

_rnd_room:
1$	MOVEq	#$0009,D0
	JSR	_rnd
	MOVE.W	D0,D3
	MULU.W	#66,D3
	LEA	-$607A(A4),A6	;_rooms + 14 (r_flags)

	MOVE.W	$00(A6,D3.L),D2
	AND.W	#$0002,D2	;ISGONE?
	BEQ.B	2$

	MOVE.W	$00(A6,D3.L),D2
	AND.W	#$0004,D2	;ISMAZE?
	BEQ.B	1$
2$	RTS

;/*
; * put_things:
; *  Put potions and scrolls on this level
; */

_put_things:
	LINK	A5,#-$0004
	MOVEM.L	D4/D5/A2,-(A7)

	MOVEQ	#$00,D4
	TST.B	-$66BC(A4)	;_saw_amulet
	BEQ.B	L0018B

	MOVE.W	-$60B4(A4),D3	;_level
	CMP.W	-$60BA(A4),D3	;_ntraps
	BGE.B	L0018B

	MOVEQ	#$08,D4
	BRA.W	L0018F
L0018B:
	CMPI.W	#26,-$60B4(A4)	;_level
	BLT.W	L0018E

	TST.B	-$66BC(A4)	;_saw_amulet
	BNE.W	L0018E

	JSR	_new_item
	MOVEA.L	D0,A2
	TST.L	D0
	BEQ.W	L0018E

	MOVE.L	A2,-(A7)
	PEA	-$6CB0(A4)	;_lvl_obj
	JSR	__attach
	ADDQ.W	#8,A7
	CLR.W	$0024(A2)
	CLR.W	$0022(A2)
	MOVE.L	-$69AE(A4),$001A(A2)	;_no_damage
	MOVE.L	$001A(A2),$0016(A2)
	MOVE.W	#$000B,$0026(A2)
	MOVE.W	#$002C,$000A(A2)
L0018C:
	JSR	_rnd_room(PC)
	MOVE.W	D0,D5
	PEA	-$0004(A5)
	MOVE.W	D5,D3
	MULU.W	#66,D3
	LEA	-$6088(A4),A6	;_rooms
	ADD.L	A6,D3
	MOVE.L	D3,-(A7)
	JSR	_rnd_pos
	ADDQ.W	#8,A7

	MOVE.W	-$0004(A5),-(A7)
	MOVE.W	-$0002(A5),-(A7)
	JSR	_winat
	ADDQ.W	#4,A7

	CMP.W	#$002E,D0	;'.' FLOOR
	BEQ.B	L0018D

	MOVE.W	-$0004(A5),-(A7)
	MOVE.W	-$0002(A5),-(A7)
	JSR	_winat
	ADDQ.W	#4,A7
	CMP.W	#$0023,D0
	BNE.B	L0018C
L0018D:
	MOVE.W	-$0004(A5),d0
	MOVE.W	-$0002(A5),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	#$2C,$00(A6,D0.W)	;"," amulet of yendor
	MOVEA.L	A2,A6
	ADDA.L	#$0000000C,A6
	LEA	-$0004(A5),A1
	MOVE.L	(A1)+,(A6)+
L0018E:
	MOVEq	#$0014,D0
	JSR	_rnd
	TST.W	D0
	BNE.B	L0018F

	JSR	_treas_room(PC)
L0018F:
	BRA.W	L00194
L00190:
	CMPI.W	#$0053,-$60A8(A4)	;83 objects _total
	BGE.W	L00193

	MOVEq	#100,D0
	JSR	_rnd

	CMP.W	#35,D0
	BGE.W	L00193

	JSR	_new_thing
	MOVEA.L	D0,A2
	MOVE.L	A2,-(A7)
	PEA	-$6CB0(A4)	;_lvl_obj
	JSR	__attach
	ADDQ.W	#8,A7
L00191:
	JSR	_rnd_room(PC)
	MOVE.W	D0,D5
	PEA	-$0004(A5)
	MOVE.W	D5,D3
	MULU.W	#66,D3
	LEA	-$6088(A4),A6	;_rooms
	ADD.L	A6,D3
	MOVE.L	D3,-(A7)
	JSR	_rnd_pos
	ADDQ.W	#8,A7

	MOVE.W	-$0004(A5),d0
	MOVE.W	-$0002(A5),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	CMPI.B	#$002E,$00(A6,D0.W)	;'.' FLOOR
	BEQ.B	L00192
	CMPI.B	#$0023,$00(A6,D0.W)	;'#' PASSAGE
	BNE.B	L00191
L00192:
	MOVE.W	-$0004(A5),d0
	MOVE.W	-$0002(A5),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	$000B(A2),$00(A6,D0.W)
	MOVEA.L	A2,A6
	ADDA.L	#$0000000C,A6
	LEA	-$0004(A5),A1
	MOVE.L	(A1)+,(A6)+
L00193:
	ADDQ.W	#1,D4
L00194:
	CMP.W	#$0009,D4
	BLT.W	L00190

	MOVEM.L	(A7)+,D4/D5/A2
	UNLK	A5
	RTS

;/*
; * treas_room:
; *  Add a treasure room
; */

_treas_room:
	LINK	A5,#-$000C
	MOVEM.L	A2/A3,-(A7)

	JSR	_rnd_room(PC)
	MULU.W	#$0042,D0
	LEA	-$6088(A4),A6	;_rooms

	MOVEA.L	D0,A3
	ADDA.L	A6,A3
	MOVE.W	$0006(A3),D3
	SUBQ.W	#2,D3
	MOVE.W	$0004(A3),D2
	SUBQ.W	#2,D2
	MULU.W	D2,D3
	SUBQ.W	#2,D3
	MOVE.W	D3,-$0006(A5)
	CMPI.W	#$0008,-$0006(A5)
	BLE.B	L00195
	MOVE.W	#$0008,-$0006(A5)
L00195:
	MOVE.W	-$0006(A5),D0
	JSR	_rnd
	ADDQ.W	#2,D0
	MOVE.W	D0,-$0002(A5)
	MOVE.W	D0,-$0008(A5)
L00196:
	MOVE.W	-$0002(A5),D3
	SUBQ.W	#1,-$0002(A5)
	TST.W	D3
	BEQ.W	L00199

	CMPI.W	#$0053,-$60A8(A4)	;83 objects _total
	BGE.B	L00199
L00197:
	PEA	-$000C(A5)
	MOVE.L	A3,-(A7)
	JSR	_rnd_pos
	ADDQ.W	#8,A7

	MOVE.W	-$000C(A5),d0
	MOVE.W	-$000A(A5),d1
	JSR	_INDEXquick

	MOVE.W	D0,-$0004(A5)
	MOVE.W	-$0004(A5),D3
	MOVEA.L	-$519C(A4),A6	;__level

	MOVE.B	$00(A6,D3.W),D2
	CMP.B	#$2E,D2		;'.' FLOOR
	BEQ.B	L00198
	CMP.B	#$23,D2		;'#' PASSAGE
	BNE.B	L00197
L00198:
	JSR	_new_thing
	MOVEA.L	D0,A2
	MOVEA.L	A2,A6
	ADDA.L	#$0000000C,A6
	LEA	-$000C(A5),A1
	MOVE.L	(A1)+,(A6)+
	MOVE.L	A2,-(A7)
	PEA	-$6CB0(A4)	;_lvl_obj
	JSR	__attach
	ADDQ.W	#8,A7
	MOVE.W	-$0004(A5),D3
	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	$000B(A2),$00(A6,D3.W)
	BRA.W	L00196
L00199:
	MOVE.W	-$0006(A5),D0
	JSR	_rnd
	ADDQ.W	#2,D0
	MOVE.W	D0,-$0002(A5)
	MOVE.W	-$0008(A5),D3
	ADDQ.W	#2,D3
	CMP.W	D3,D0
	BGE.B	L0019A
	MOVE.W	-$0008(A5),D3
	ADDQ.W	#2,D3
	MOVE.W	D3,-$0002(A5)
L0019A:
	MOVE.W	$0006(A3),D3
	SUBQ.W	#2,D3
	MOVE.W	$0004(A3),D2
	SUBQ.W	#2,D2
	MULU.W	D2,D3
	MOVE.W	D3,-$0006(A5)
	MOVE.W	-$0002(A5),D3
	CMP.W	-$0006(A5),D3
	BLE.B	L0019B
	MOVE.W	-$0006(A5),-$0002(A5)
L0019B:
	ADDQ.W	#1,-$60B4(A4)	;_level
L0019C:
	MOVE.W	-$0002(A5),D3
	SUBQ.W	#1,-$0002(A5)
	TST.W	D3
	BEQ.W	L001A2
	CLR.W	-$0006(A5)
L0019D:
	PEA	-$000C(A5)
	MOVE.L	A3,-(A7)
	JSR	_rnd_pos
	ADDQ.W	#8,A7

	MOVE.W	-$000C(A5),d0
	MOVE.W	-$000A(A5),d1
	JSR	_INDEXquick

	MOVE.W	D0,-$0004(A5)
	MOVE.W	-$0004(A5),D3
	MOVEA.L	-$519C(A4),A6	;__level

	MOVE.B	$00(A6,D3.W),D2
	CMP.B	#$2E,D2		;'.' FLOOR
	BEQ.B	L0019E
	CMP.B	#$23,D2		;'#' PASSAGE
	BNE.B	L0019F
L0019E:
	MOVE.W	-$000C(A5),d1
	MOVE.W	-$000A(A5),d0
	JSR	_moatquick

	TST.L	D0
	BEQ.B	L001A0
L0019F:
	ADDQ.W	#1,-$0006(A5)
	CMPI.W	#$000A,-$0006(A5)
	BLT.B	L0019D
L001A0:
	CMPI.W	#$000A,-$0006(A5)
	BEQ.B	L001A1

	JSR	_new_item
	MOVEA.L	D0,A2
	TST.L	D0
	BEQ.B	L001A1

	PEA	-$000C(A5)
	CLR.L	-(A7)
	JSR	_randmonster
	ADDQ.W	#4,A7

	MOVE.W	D0,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_new_monster
	LEA	$000A(A7),A7

	ORI.W	#C_ISMEAN,$0016(A2)	;all monster here are mean

	MOVE.L	A2,-(A7)
	JSR	_give_pack
	ADDQ.W	#4,A7
L001A1:
	BRA.W	L0019C
L001A2:
	SUBQ.W	#1,-$60B4(A4)	;_level
	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

L001A3:	dc.b	"you hear maniacal laughter%s.",0
L001A4:	dc.b	" in the distance",0,0

