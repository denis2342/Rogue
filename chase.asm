;/*
; * runners:
; *  Make all the running monsters move.
; */

_runners:
;	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	_mlist(A4),A2	;_mlist
	BRA.W	L0023B
L00234:
	MOVE.W	$0016(A2),D3
	AND.W	#C_ISHELD,D3	;C_ISHELD
	BNE.W	L0023A

	MOVE.W	$0016(A2),D3
	AND.W	#C_ISRUN,D3	;C_ISRUN
	BEQ.W	L0023A

	MOVE.W	$0016(A2),D3
	AND.W	#C_ISSLOW,D3	;C_ISSLOW
	BNE.B	L00235

	cmp.b	#$53,$000F(A2)	;'S' slime
	BNE.B	L00236

	MOVE.W	$000A(A2),-(A7)
	MOVE.W	$000C(A2),-(A7)
	MOVE.W	_player+10(A4),-(A7)	;_player + 10
	MOVE.W	_player+12(A4),-(A7)	;_player + 12
	JSR	_DISTANCE
	ADDQ.W	#8,A7

	CMP.W	#$0003,D0
	BLE.B	L00236
L00235:
	TST.B	$000E(A2)
	BEQ.B	L00237
L00236:
	MOVE.L	A2,-(A7)
	BSR.B	_do_chase
	ADDQ.W	#4,A7
L00237:
	MOVE.W	$0016(A2),D3
	AND.W	#C_ISHASTE,D3	;C_ISHASTE
	BEQ.B	L00238

	MOVE.L	A2,-(A7)
	BSR.B	_do_chase
	ADDQ.W	#4,A7
L00238:
	MOVE.W	$0016(A2),D3	;creature flags
	AND.W	#C_ISFLY,D3	;C_ISFLY
	BEQ.B	L00239

	MOVE.W	$000A(A2),-(A7)
	MOVE.W	$000C(A2),-(A7)
	MOVE.W	_player+10(A4),-(A7)	;_player + 10
	MOVE.W	_player+12(A4),-(A7)	;_player + 12
	JSR	_DISTANCE
	ADDQ.W	#8,A7

	CMP.W	#$0003,D0
	BLE.B	L00239

	MOVE.L	A2,-(A7)
	BSR.B	_do_chase
	ADDQ.W	#4,A7
L00239:
	EORI.B	#$01,$000E(A2)
L0023A:
	MOVEA.L	(A2),A2
L0023B:
	MOVE.L	A2,D3
	BNE.W	L00234

	MOVE.L	(A7)+,A2
;	UNLK	A5
	RTS

;/*
; * do_chase:
; *  Make one thing chase another.
; */

_do_chase:
	LINK	A5,#-$000A
	MOVEM.L	D4-D7/A2/A3,-(A7)

	MOVE.W	#$7FFF,D6
	MOVEA.L	$0008(A5),A6
	MOVE.L	$002A(A6),D4	;creature room
	MOVE.W	$0016(A6),D3	;creature flags
	AND.W	#C_ISGREED,D3	;C_ISGREED
	BEQ.B	L0023C

	MOVEA.L	D4,A6
	TST.W	$000C(A6)
	BNE.B	L0023C

	MOVEA.L	$0008(A5),A6
	LEA	_player+10(A4),A1	;_player + 10
	MOVE.L	A1,$0012(A6)
L0023C:
	MOVE.L	_player+42(A4),D5	;_player + 42 (proom)
	MOVEA.L	$0008(A5),A6
	LEA	_player+10(A4),A1	;_player + 10
	MOVEA.L	$0012(A6),A0
	CMPA.L	A1,A0
	BEQ.B	L0023D

	MOVE.L	$0012(A6),-(A7)
	JSR	_roomin(PC)
	ADDQ.W	#4,A7
	MOVE.L	D0,D5
L0023D:
	TST.L	D5
	BNE.B	L0023F
L0023E:
	MOVEM.L	(A7)+,D4-D7/A2/A3
	UNLK	A5
	RTS

L0023F:
	MOVEA.L	$0008(A5),A6

	MOVE.W	$000A(A6),d0
	MOVE.W	$000C(A6),d1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level
	cmp.b	#$2B,$00(A6,D0.W)	;'+' door
	BNE.B	L00240

	MOVEq	#$0001,D3
	BRA.B	L00241
L00240:
	CLR.W	D3
L00241:
	MOVE.B	D3,-$0002(A5)
L00242:
	CMP.L	D5,D4
	BEQ.W	L00247

	MOVEA.L	D4,A6
	MOVE.W	$000E(A6),D3
	AND.W	#$0004,D3
	BNE.W	L00247

	MOVEQ	#$00,D7
	BRA.B	L00245
L00243:
	MOVE.W	D7,D3
	EXT.L	D3
	ASL.L	#2,D3
	MOVEA.L	D3,A6
	ADDA.L	D4,A6
	MOVE.W	$0012(A6),-(A7)
	MOVE.W	$0014(A6),-(A7)
	MOVEA.L	$0008(A5),A6
	MOVEA.L	$0012(A6),A1
	MOVE.W	(A1),-(A7)
	MOVE.W	$0002(A1),-(A7)
	JSR	_DISTANCE
	ADDQ.W	#8,A7
	MOVE.W	D0,-$0004(A5)
	CMP.W	D6,D0
	BGE.B	L00244

	LEA	-$0008(A5),A6
	MOVE.W	D7,D3
	EXT.L	D3
	ASL.L	#2,D3
	MOVEA.L	D3,A1
	ADDA.L	D4,A1
	ADDA.L	#$00000012,A1
	MOVE.L	(A1)+,(A6)+
	MOVE.W	-$0004(A5),D6
L00244:
	ADDQ.W	#1,D7
L00245:
	MOVEA.L	D4,A6
	CMP.W	$0010(A6),D7
	BLT.B	L00243

	TST.B	-$0002(A5)
	BEQ.B	L00246

	MOVEA.L	$0008(A5),A6
	MOVE.W	$000A(A6),d0
	MOVE.W	$000C(A6),d1
	JSR	_INDEXquick

	MOVEA.L	__flags(A4),A6	;__flags
	MOVE.B	$00(A6,D0.W),D3
	AND.W	#F_PNUM,D3	;get the room number
	MULU.W	#66,D3
	LEA	_passages(A4),A6	;_passages
	MOVE.L	D3,D4
	ADD.L	A6,D4
	CLR.B	-$0002(A5)
	BRA.W	L00242
L00246:
	BRA.W	L00250
L00247:
	LEA	-$0008(A5),A6
	MOVEA.L	$0008(A5),A1
	MOVEA.L	$0012(A1),A0
	MOVE.L	(A0)+,(A6)+

	MOVEA.L	$0008(A5),A6
	MOVE.B	$000F(A6),D3
	CMP.b	#$44,D3		;'D' dragon
	BEQ.B	L00248

	CMP.b	#$49,D3		;'I' ice monster
	BNE.W	L00250
L00248:
	MOVEA.L	$0008(A5),A6

	MOVE.W	$000A(A6),D3
	CMP.W	_player+10(A4),D3	;_player + 10
	BEQ.B	L0024D

	MOVE.W	$000C(A6),D3
	CMP.W	_player+12(A4),D3	;_player + 12
	BEQ.B	L0024D

	SUB.W	_player+12(A4),D3	;_player + 12
	BGE.B	L0024A

	NEG.W	D3
L0024A:
	MOVEA.L	$0008(A5),A6
	MOVE.W	$000A(A6),D2
	SUB.W	_player+10(A4),D2	;_player + 10
	BGE.B	L0024B

	NEG.W	D2
	BRA.B	L0024C
L0024B:
	MOVEA.L	$0008(A5),A6
	MOVE.W	$000A(A6),D2
	SUB.W	_player+10(A4),D2	;_player + 10
L0024C:
	CMP.W	D2,D3
	BNE.W	L00250
L0024D:
	MOVE.W	_player+10(A4),-(A7)	;_player + 10
	MOVE.W	_player+12(A4),-(A7)	;_player + 12
	MOVEA.L	$0008(A5),A6
	MOVE.W	$000A(A6),-(A7)
	MOVE.W	$000C(A6),-(A7)
	JSR	_DISTANCE
	ADDQ.W	#8,A7
	MOVE.W	D0,-$0004(A5)
	CMP.W	#$0002,D0
	BLE.W	L00250

	CMPI.W	#$0024,D0
	BGT.W	L00250

	MOVEA.L	$0008(A5),A6
	MOVE.W	$0016(A6),D3
	AND.W	#C_ISCANC,D3	;C_ISCANC
	BNE.B	L00250

	MOVEq	#$0005,D0
	JSR	_rnd
	TST.W	D0		; 20% chance to get flame/frost
	BNE.B	L00250

	CLR.B	_running(A4)	;_running
	MOVEA.L	$0008(A5),A6
	MOVE.W	_player+12(A4),D3	;_player + 12
	SUB.W	$000C(A6),D3
	MOVE.W	D3,-(A7)
	JSR	_sign
	ADDQ.W	#2,A7

	MOVE.W	D0,_delta+2(A4)	;_delta + 2
	MOVEA.L	$0008(A5),A6
	MOVE.W	_player+10(A4),D3	;_player + 10
	SUB.W	$000A(A6),D3
	MOVE.W	D3,-(A7)
	JSR	_sign
	ADDQ.W	#2,A7

	MOVE.W	D0,_delta+0(A4)	;_delta + 0
	MOVEA.L	$0008(A5),A6
	CMP.b	#$44,$000F(A6)	;'D' dragon
	BNE.B	1$

	PEA	L00263(PC)	;"flame"
	BRA.B	2$
1$
	PEA	L00264(PC)	;"frost"
2$
	PEA	_delta+0(A4)	;_delta + 0
	PEA	$000A(A6)
	JSR	_fire_bolt(PC)
	LEA	$000C(A7),A7
	BRA.W	L0023E
L00250:
	PEA	-$0008(A5)
	MOVE.L	$0008(A5),-(A7)
	JSR	_chase(PC)
	ADDQ.W	#8,A7
	PEA	_player+10(A4)	;_player + 10
	PEA	_ch_ret(A4)
	JSR	__ce
	ADDQ.W	#8,A7
	TST.W	D0
	BEQ.B	L00251

	MOVE.L	$0008(A5),-(A7)
	JSR	_attack
	ADDQ.W	#4,A7
	BRA.W	L0023E
L00251:
	MOVEA.L	$0008(A5),A6
	MOVE.L	$0012(A6),-(A7)
	PEA	_ch_ret(A4)
	JSR	__ce
	ADDQ.W	#8,A7
	TST.W	D0
	BEQ.W	L00258

	MOVEA.L	_lvl_obj(A4),A2	;_lvl_obj
	BRA.W	L00257
L00252:
	MOVEA.L	$0008(A5),A6
	MOVEA.L	A2,A1
	ADDA.L	#$0000000C,A1
	MOVEA.L	$0012(A6),A0
	CMPA.L	A1,A0
	BNE.W	L00256

	MOVE.L	A2,-(A7)
	PEA	_lvl_obj(A4)	;_lvl_obj
	JSR	__detach
	ADDQ.W	#8,A7
	MOVE.L	A2,-(A7)
	MOVEA.L	$0008(A5),A6
	PEA	$002E(A6)
	JSR	__attach
	ADDQ.W	#8,A7

	MOVE.W	$000C(A2),d0
	MOVE.W	$000E(A2),d1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level
	MOVEA.L	$0008(A5),A1
	MOVEA.L	$002A(A1),A0
	MOVE.W	$000E(A0),D3
	AND.W	#$0002,D3
	BEQ.B	L00253

	MOVEQ	#$23,D3		;'#'
	BRA.B	L00254
L00253:
	MOVEQ	#$2E,D3		;'.'
L00254:
	MOVE.B	D3,$00(A6,D0.W)
	MOVE.B	D3,-$0009(A5)
	MOVE.W	$000C(A2),-(A7)
	MOVE.W	$000E(A2),-(A7)
	JSR	_cansee(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00255

	MOVE.B	-$0009(A5),D2
	MOVE.W	$000C(A2),d1
	MOVE.W	$000E(A2),d0
	JSR	_mvaddchquick

L00255:
	MOVE.L	$0008(A5),-(A7)
	JSR	_find_dest(PC)
	ADDQ.W	#4,A7

	MOVEA.L	$0008(A5),A6
	MOVE.L	D0,$0012(A6)
	BRA.B	L00258
L00256:
	MOVEA.L	(A2),A2
L00257:
	MOVE.L	A2,D3
	BNE.W	L00252
L00258:
	MOVEA.L	$0008(A5),A6
	CMP.B	#$46,$000F(A6)	;'F' venus flytrap
	BEQ	L0023E

	MOVE.B	$0011(A6),D3
	CMP.B	#$22,D3		;'"'
	BEQ.W	L0025C

	CMP.B	#$20,D3		;' ' SPACE
	BNE.B	L0025A

	MOVE.W	$000A(A6),-(A7)
	MOVE.W	$000C(A6),-(A7)
	JSR	_cansee(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L0025A

	MOVEA.L	$0008(A5),A6
	MOVE.W	$000A(A6),d0
	MOVE.W	$000C(A6),d1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level

	CMP.B	#$2E,$00(A6,D0.W)	;'.' FLOOR
	BNE.B	L0025A

	MOVEA.L	$0008(A5),A6
	MOVEq	#$2E,d2		;'.' FLOOR
	MOVE.W	$000A(A6),d1
	MOVE.W	$000C(A6),d0
	JSR	_mvaddchquick

	BRA.B	L0025C
L0025A:
	MOVEA.L	$0008(A5),A6
	CMP.B	#$2E,$0011(A6)	;'.' FLOOR
	BNE.B	L0025B

	MOVE.W	$000A(A6),-(A7)
	MOVE.W	$000C(A6),-(A7)
	JSR	_cansee(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.B	L0025B

	MOVEA.L	$0008(A5),A6
	MOVEq	#$20,d2		;' ' SPACE
	MOVE.W	$000A(A6),d1
	MOVE.W	$000C(A6),d0
	JSR	_mvaddchquick

	BRA.B	L0025C
L0025B:
	MOVEA.L	$0008(A5),A6

	MOVE.B	$0011(A6),D2
	MOVE.W	$000A(A6),d1
	MOVE.W	$000C(A6),d0
	JSR	_mvaddchquick

L0025C:
	MOVEA.L	$0008(A5),A6
	MOVEA.L	$002A(A6),A3
	PEA	$000A(A6)
	PEA	_ch_ret(A4)
	JSR	__ce
	ADDQ.W	#8,A7
	TST.W	D0
	BNE.B	L0025F

	PEA	_ch_ret(A4)
	JSR	_roomin(PC)
	ADDQ.W	#4,A7

	MOVEA.L	$0008(A5),A6
	MOVE.L	D0,$002A(A6)	;proom
	BNE.B	1$

	MOVE.L	A3,$002A(A6)	;proom
	BRA.W	L0023E
1$
	MOVEA.L	$002A(A6),A1	;proom
	CMPA.L	A3,A1
	BEQ.B	L0025E

	MOVE.L	A6,-(A7)
	JSR	_find_dest(PC)
	ADDQ.W	#4,A7

	MOVEA.L	$0008(A5),A6
	MOVE.L	D0,$0012(A6)
L0025E:
	MOVEA.L	$0008(A5),A6
	ADDA.L	#$0000000A,A6
	LEA	_ch_ret(A4),A1
	MOVE.L	(A1)+,(A6)+
L0025F:
	MOVE.L	$0008(A5),-(A7)
	BSR.B	_see_monst
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00260

	MOVE.W	_ch_ret(A4),-(A7)
	MOVE.W	_ch_ret+2(A4),-(A7)
	JSR	_mvinch(PC)
	ADDQ.W	#4,A7

	MOVEA.L	$0008(A5),A6
	MOVE.B	D0,$0011(A6)

	MOVE.B	$0010(A6),D2
	MOVE.W	_ch_ret(A4),d1
	MOVE.W	_ch_ret+2(A4),d0
	JSR	_mvaddchquick

	BRA.B	L00261
L00260:
	MOVEA.L	$0008(A5),A6
	MOVE.B	#$22,$0011(A6)	;'"'
L00261:
	MOVEA.L	$0008(A5),A6
	CMP.B	#$2E,$0011(A6)	;'.'
	BNE.B	L00262

	MOVE.L	A3,-(A7)
	JSR	_is_dark
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00262

	MOVEA.L	$0008(A5),A6
	MOVE.B	#$20,$0011(A6)	;' '
L00262:
	BRA.W	L0023E

L00263:	dc.b	"flame",0
L00264:	dc.b	"frost",0

;/*
; * see_monst:
; *  Return TRUE if the hero can see the monster
; */

_see_monst:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVE.W	_player+22(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BEQ.B	L00266

L00268:
	MOVEQ	#$00,D0		;zero means can't see the monster
L00265:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L00266:
	MOVE.W	$0016(A2),D3
	AND.W	#C_ISINVIS,D3	;C_ISINVIS
	BEQ.B	L00267

	MOVE.W	_player+22(A4),D3	;_player + 22 (flags)
	AND.W	#C_CANSEE,D3	;C_CANSEE
	BEQ.B	L00268
L00267:
	MOVE.W	_player+10(A4),-(A7)	;_player + 10
	MOVE.W	_player+12(A4),-(A7)	;_player + 12
	MOVE.W	$000A(A2),-(A7)
	MOVE.W	$000C(A2),-(A7)
	JSR	_DISTANCE
	ADDQ.W	#8,A7
	CMP.W	#$0003,D0
	BLT.B	L00269

	; check if monster and player are in the same room

	MOVEA.L	$002A(A2),A6
	CMPA.L	_player+42(A4),A6	;_player + 42 (proom)
	BNE.B	L00268

	; is room a maze?

	MOVE.W	$000E(A6),D3
	AND.W	#$0004,D3	;ISMAZE
	BNE.B	L00268

	; is the room dark?

	MOVE.L	A6,-(A7)
	JSR	_is_dark
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.B	L00268
L00269:
	MOVEQ	#$01,D0
	BRA.B	L00265

;/*
; * runto:
; *  Set a monster running after the hero.
; */

_start_run:
	LINK	A5,#-$0000
	MOVE.L	A3,-(A7)

	MOVEA.L	$0008(A5),A0

	MOVE.W	(A0)+,d1
	MOVE.W	(A0),d0
	JSR	_moatquick

	TST.L	D0
	BEQ.B	1$

	MOVEA.L	D0,A3

	ORI.W	#C_ISRUN,$0016(A3)	;set C_ISRUN
	ANDI.W	#~C_ISHELD,$0016(A3)	;clear C_ISHELD
	MOVE.L	A3,-(A7)
	JSR	_find_dest(PC)
	ADDQ.W	#4,A7
	MOVE.L	D0,$0012(A3)
1$
	MOVE.L	(A7)+,A3
	UNLK	A5
	RTS

;/*
; * chase:
; *  Find the spot for the chaser(er) to move closer to the
; *  chasee(ee).  Returns TRUE if we want to keep on chasing later
; *  FALSE if we reach the goal.
; */

_chase:
	LINK	A5,#-$0010
	MOVEM.L	D4-D7/A2,-(A7)

	MOVE.W	#$0001,-$000C(A5)
	MOVE.L	$0008(A5),A6
	move.l	a6,d3
	ADD.L	#$0000000A,D3
	MOVE.L	D3,-$0008(A5)

	MOVE.W	$0016(A6),D3
	AND.W	#C_ISHUH,D3	;C_ISHUH
	BEQ.B	L0026B

	MOVEq	#$0005,D0
	JSR	_rnd
	TST.W	D0
	BNE.B	L0026D
L0026B:
	MOVEA.L	$0008(A5),A6
	MOVE.B	$000F(A6),D3
;	EXT.W	D3
	CMP.b	#$50,D3		;'P' phantom, 20% confused
	BNE.B	1$

	MOVEq	#$0005,D0
	JSR	_rnd
	TST.W	D0
	BEQ.B	L0026D
1$
	MOVEA.L	$0008(A5),A6
	MOVE.B	$000F(A6),D3
;	EXT.W	D3
	CMP.b	#$42,D3		;'B' bat, 50% confused
	BNE.B	L0026F

	MOVEq	#$0002,D0
	JSR	_rnd
	TST.W	D0
	BNE.B	L0026F
L0026D:
	PEA	_ch_ret(A4)
	MOVE.L	$0008(A5),-(A7)
	JSR	_rndmove(PC)
	ADDQ.W	#8,A7
	MOVEA.L	$000C(A5),A6
	MOVE.W	(A6),-(A7)
;	MOVEA.L	$000C(A5),A6
	MOVE.W	$0002(A6),-(A7)
	MOVE.W	_ch_ret(A4),-(A7)
	MOVE.W	_ch_ret+2(A4),-(A7)
	JSR	_DISTANCE
	ADDQ.W	#8,A7
	MOVE.W	D0,-$0002(A5)

	MOVEq	#30,D0
	JSR	_rnd
	CMP.W	#17,D0
	BNE.B	L0026E

	MOVEA.L	$0008(A5),A6
	ANDI.W	#~C_ISHUH,$0016(A6)	;clear C_ISHUH
L0026E:
	BRA.W	L0027B
L0026F:
	MOVEA.L	$000C(A5),A6
	MOVE.W	(A6),-(A7)
;	MOVEA.L	$000C(A5),A6
	MOVE.W	$0002(A6),-(A7)
	MOVEA.L	-$0008(A5),A6
	MOVE.W	(A6),-(A7)
;	MOVEA.L	-$0008(A5),A6
	MOVE.W	$0002(A6),-(A7)
	JSR	_DISTANCE
	ADDQ.W	#8,A7

	MOVE.W	D0,-$0002(A5)
	LEA	_ch_ret(A4),A6
	MOVEA.L	-$0008(A5),A1
	MOVE.L	(A1)+,(A6)+
	MOVEA.L	-$0008(A5),A6
	MOVE.W	$0002(A6),D6
	ADDQ.W	#1,D6
;	MOVEA.L	-$0008(A5),A6
	MOVE.W	(A6),D7
	ADDQ.W	#1,D7
;	MOVEA.L	-$0008(A5),A6
	MOVE.W	(A6),D4
	SUBQ.W	#1,D4
	BRA.W	L0027A
L00270:
	MOVEA.L	-$0008(A5),A6
	MOVE.W	$0002(A6),D5
	SUBQ.W	#1,D5
	BRA.W	L00279
L00271:
	MOVE.W	D4,-$0010(A5)
	MOVE.W	D5,-$000E(A5)
	MOVE.W	D4,-(A7)
	MOVE.W	D5,-(A7)
	JSR	_offmap
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.W	L00278

	PEA	-$0010(A5)
	MOVE.L	-$0008(A5),-(A7)
	JSR	_diag_ok(PC)
	ADDQ.W	#8,A7
	TST.W	D0
	BEQ.W	L00278

	MOVE.W	D4,-(A7)
	MOVE.W	D5,-(A7)
	JSR	_winat
	ADDQ.W	#4,A7

	MOVE.B	D0,-$0009(A5)
	MOVEQ	#$00,D3
	MOVE.B	D0,D3
	MOVE.W	D3,-(A7)
	JSR	_step_ok
	ADDQ.W	#2,A7

	TST.W	D0
	BEQ.W	L00278

;	MOVEQ	#$00,D3
	MOVE.B	-$0009(A5),D3
	CMP.b	#$3F,D3		;'?' scrolls
	BNE.B	L00276

	MOVEA.L	_lvl_obj(A4),A2	;_lvl_obj
	BRA.B	L00274
L00272:
	CMP.W	$000E(A2),D5
	BNE.B	L00273

	CMP.W	$000C(A2),D4
	BEQ.B	L00275
L00273:
	MOVEA.L	(A2),A2
L00274:
	MOVE.L	A2,D3
	BNE.B	L00272
L00275:
	MOVE.L	A2,D3
	BEQ.B	L00276

	CMPI.W	#S_SCAREM,$0020(A2)	; scroll of scare monster
	BEQ.B	L00278
L00276:
	MOVEA.L	$000C(A5),A6
	MOVE.W	(A6),-(A7)
;	MOVEA.L	$000C(A5),A6
	MOVE.W	$0002(A6),-(A7)
	MOVE.W	D4,-(A7)
	MOVE.W	D5,-(A7)
	JSR	_DISTANCE
	ADDQ.W	#8,A7

	MOVE.W	D0,-$0004(A5)
	MOVE.W	-$0004(A5),D3
	CMP.W	-$0002(A5),D3
	BGE.B	L00277

	MOVE.W	#$0001,-$000C(A5)
	LEA	_ch_ret(A4),A6
	LEA	-$0010(A5),A1
	MOVE.L	(A1)+,(A6)+
	MOVE.W	-$0004(A5),-$0002(A5)
	BRA.B	L00278
L00277:
	MOVE.W	-$0004(A5),D3
	CMP.W	-$0002(A5),D3
	BNE.B	L00278

	ADDQ.W	#1,-$000C(A5)
	MOVE.W	-$000C(A5),D0
	JSR	_rnd
	TST.W	D0
	BNE.B	L00278

	LEA	_ch_ret(A4),A6
	LEA	-$0010(A5),A1
	MOVE.L	(A1)+,(A6)+
	MOVE.W	-$0004(A5),-$0002(A5)
L00278:
	ADDQ.W	#1,D5
L00279:
	CMP.W	D6,D5
	BLE.W	L00271

	ADDQ.W	#1,D4
L0027A:
	CMP.W	D7,D4
	BLE.W	L00270
L0027B:
	MOVEM.L	(A7)+,D4-D7/A2
	UNLK	A5
	RTS

;/*
; * roomin:
; *  Find what room some coordinates are in. NULL means they aren't
; *  in any room.
; */

_roomin:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	LEA	_rooms(A4),A6	;_rooms
	MOVEA.L	A6,A3
L0027C:
	MOVE.W	(A3),D3
	ADD.W	$0004(A3),D3
	MOVE.W	(A2),D2
	CMP.W	D3,D2
	BGE.B	L0027E

	MOVE.W	(A3),D3
	CMP.W	(A2),D3
	BGT.B	L0027E

	MOVE.W	$0002(A3),D3
	ADD.W	$0006(A3),D3
	MOVE.W	$0002(A2),D2
	CMP.W	D3,D2
	BGE.B	L0027E

	MOVE.W	$0002(A3),D3
	CMP.W	$0002(A2),D3
	BGT.B	L0027E
	MOVE.L	A3,D0
L0027D:
	MOVEM.L	(A7)+,D4/A2/A3
	UNLK	A5
	RTS

L0027E:
	ADDA.L	#66,A3
	LEA	_rooms_last(A4),A6
	CMPA.L	A6,A3
	BLS.B	L0027C

	MOVE.W	(A2),d0
	MOVE.W	$0002(A2),d1
	JSR	_INDEXquick

	EXT.L	D0
	MOVE.L	D0,D4
	ADD.L	__flags(A4),D4	;__flags
	MOVEA.L	D4,A6
	MOVE.B	(A6),D3
	AND.W	#F_SEEN,D3	;F_SEEN
	BEQ.B	L0027F

;	MOVEA.L	D4,A6
;	MOVEQ	#$00,D0
	MOVE.B	(A6),D0
	AND.W	#F_PNUM,D0
	MULU.W	#66,D0
	LEA	_passages(A4),A6	;_passages
	ADD.L	A6,D0
	BRA.B	L0027D
L0027F:
	ADDQ.B	#1,_bailout(A4)	;_bailout
	MOVE.W	(A2),-(A7)
	MOVE.W	$0002(A2),-(A7)
	PEA	L00280(PC)	;"Roomin bailout, in some bizzare place %d,%d"
	JSR	_db_print
	ADDQ.W	#8,A7
	MOVEQ	#$00,D0
	BRA.B	L0027D

L00280:	dc.b	"Roomin bailout, in some bizzare place %d,%d",10,0,0

;/*
; * diag_ok:
; *  Check to see if the move is legal if it is diagonal
; */

_diag_ok:
	LINK	A5,#-$0000
	MOVEM.L	A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVEA.L	$000C(A5),A3
	MOVE.W	(A3),D3
	CMP.W	(A2),D3
	BEQ.B	L00281

	MOVE.W	$0002(A3),D3
	CMP.W	$0002(A2),D3
	BNE.B	L00283
L00281:
	MOVEQ	#$01,D0
L00282:
	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

L00283:
	MOVE.W	(A2),d0
	MOVE.W	$0002(A3),d1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level
	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	MOVE.W	D3,-(A7)

	JSR	_step_ok
	ADDQ.W	#2,A7

	TST.W	D0
	BEQ.B	L00282

	MOVE.W	(A3),d0
	MOVE.W	$0002(A2),d1
	JSR	_INDEXquick

	MOVEA.L	__level(A4),A6	;__level
	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	MOVE.W	D3,-(A7)

	JSR	_step_ok
	ADDQ.W	#2,A7
	BRA.B	L00282

;/*
; * cansee:
; *  Returns true if the hero can see a certain coordinate.
; */

_cansee:
	LINK	A5,#-$0004
	MOVEM.L	D4/D5/A2,-(A7)

	MOVE.W	$0008(A5),D4
	MOVE.W	$000A(A5),D5

	MOVEq	#C_ISBLIND,D3	;C_ISBLIND
	AND.W	_player+22(A4),D3	;_player + 22 (flags)
	BEQ.B	L00287

L00289:
	MOVEQ	#$00,D0
L00286:
	MOVEM.L	(A7)+,D4/D5/A2
	UNLK	A5
	RTS

L00287:
	MOVE.W	_player+10(A4),-(A7)	;_player + 10
	MOVE.W	_player+12(A4),-(A7)	;_player + 12
	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_DISTANCE
	ADDQ.W	#8,A7

	CMP.W	#$0003,D0
	BGE.B	L00288

	MOVEQ	#$01,D0
	BRA.B	L00286
L00288:
	MOVE.W	D4,-$0002(A5)
	MOVE.W	D5,-$0004(A5)

	PEA	-$0004(A5)
	JSR	_roomin(PC)
	ADDQ.W	#4,A7
	CMP.L	_player+42(A4),D0	;_player + 42 (proom)
	BNE.B	L00289

	MOVE.L	D0,-(A7)
	JSR	_is_dark
	ADDQ.W	#4,A7
	TST.W	D0
	SEQ	D0
	BRA.B	L00286

;/*
; * find_dest:
; *  find the proper destination for the monster
; */

_find_dest:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5/A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVE.B	$000F(A2),D3
	EXT.W	D3
	SUB.W	#$0041,D3	;'A'
	MULU.W	#26,D3
	LEA	_monsters(A4),A6	;_monsters
	TST.W	$04(A6,D3.L)
	BLE.B	L0028B		;does the monster carry?

	MOVEA.L	$002A(A2),A6
	CMPA.L	_player+42(A4),A6	;_player + 42 (proom)
	BEQ.B	L0028B

	MOVE.L	A2,-(A7)
	JSR	_see_monst(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L0028D
L0028B:
	LEA	_player+10(A4),A6	;_player + 10
	MOVE.L	A6,D0
L0028C:
	MOVEM.L	(A7)+,D4/D5/A2/A3
	UNLK	A5
	RTS

L0028D:
	MOVE.L	$002A(A2),D5
	MOVEA.L	_lvl_obj(A4),A3	;_lvl_obj
	BRA.B	L00294
L0028E:
	CMPI.W	#$003F,$000A(A3)	;'?' scroll
	BNE.B	L0028F

	CMPI.W	#S_SCAREM,$0020(A3)	;scroll of scare monster
	BEQ.B	L00293
L0028F:
	PEA	$000C(A3)
	JSR	_roomin(PC)
	ADDQ.W	#4,A7
	CMP.L	D5,D0
	BNE.B	L00293

	MOVEq	#100,D0
	JSR	_rnd
	CMP.W	D4,D0
	BGE.B	L00293

	MOVEA.L	_mlist(A4),A2	;_mlist
	BRA.B	L00291
L00290:
	MOVEA.L	A3,A6
	ADDA.L	#$0000000C,A6
	MOVEA.L	$0012(A2),A1
	CMPA.L	A6,A1
	BEQ.B	L00292

	MOVEA.L	(A2),A2
L00291:
	MOVE.L	A2,D3
	BNE.B	L00290
L00292:
	MOVE.L	A2,D3
	BNE.B	L00293

	MOVE.L	A3,D0
	ADD.L	#$0000000C,D0
	BRA.B	L0028C
L00293:
	MOVEA.L	(A3),A3
L00294:
	MOVE.L	A3,D3
	BNE.B	L0028E

	LEA	_player+10(A4),A6	;_player + 10
	MOVE.L	A6,D0
	BRA.B	L0028C

