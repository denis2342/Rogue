;/*
; * fix_stick:
; *  Set up a new stick
; */

_fix_stick:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVE.L	A2,-(A7)
	BSR.B	_ws_setdam
	ADDQ.W	#4,A7
	MOVEq	#$0005,D0
	JSR	_rnd
	ADDQ.W	#3,D0
	MOVE.W	D0,$0026(A2)		;every stick has 3-7 charges

	MOVE.W	$0020(A2),D0
	BEQ.B	L00304	;staff of light

	SUBQ.w	#1,D0
	BEQ.B	L00303	;staff of striking
L00306:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L00303:
	MOVE.W	#$0064,$0022(A2)	; +100 hit
	MOVE.W	#$0003,$0024(A2)	; +3 damage
	BRA.B	L00306

L00304:
	MOVEq	#$000A,D0
	JSR	_rnd
	ADD.W	#$000A,D0
	MOVE.W	D0,$0026(A2)	;10-19 charges
	BRA.B	L00306

_ws_setdam:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	$0008(A5),A2
	PEA	L0030A(PC)	;"staff"
	MOVE.W	$0020(A2),D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$521C(A4),A6	;_ws_type
	MOVE.L	$00(A6,D3.w),-(A7)
	JSR	_strcmp
	ADDQ.W	#8,A7
	TST.W	D0
	BNE.B	1$

	LEA	L0030B(PC),A6	;"2d3"
	BRA.B	2$

1$	LEA	L0030C(PC),A6	;"1d1"

2$	CMPI.W	#WS_STRIKING,$0020(A2)
	BNE.B	3$

	LEA	L0030D(PC),A6	;"2d8"

3$	MOVE.L	A6,$0016(A2)	;wield damage

	LEA	L0030E(PC),A6	;"1d1"
	MOVE.L	A6,$001A(A2)	;throw damage

	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L0030A:	dc.b	"staff",0
L0030B:	dc.b	"2d3",0
L0030C:	dc.b	"1d1",0
L0030D:	dc.b	"2d8",0
L0030E:	dc.b	"1d1",0

;/*
; * do_zap:
; *  Perform a zap with a wand
; */

_do_zap:
	LINK	A5,#-$0038
	MOVEM.L	D4-D7/A2/A3,-(A7)

	TST.L	$0008(A5)
	BNE.B	L00310

	MOVE.W	#$002F,-(A7)	;'/' wand/staff type
	PEA	L00347(PC)	;"zap with"
	JSR	_get_item
	ADDQ.W	#6,A7
	MOVE.L	D0,$0008(A5)
;	TST.L	D0
	BNE.B	L00310
L0030F:
	MOVEM.L	(A7)+,D4-D7/A2/A3
	UNLK	A5
	RTS

L00310:
	MOVEA.L	$0008(A5),A6
	MOVE.W	$0020(A6),-$0006(A5)
	CMPI.W	#$002F,$000A(A6)	;'/'
	BEQ.B	L00311

	PEA	L00348(PC)	;"you can't zap with that!"
	JSR	_msg
	ADDQ.W	#4,A7
	CLR.B	_after-BASE(A4)	;_after
	BRA.B	L0030F
L00311:
	MOVEA.L	$0008(A5),A6
	TST.W	$0026(A6)
	BNE.B	L00312

	PEA	L00349(PC)	;"nothing happens"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L0030F
L00312:
	MOVE.W	-$0006(A5),D0
;	EXT.L	D0
	BRA.W	L00343

; light

L00313:
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;check player C_ISBLIND
	BEQ.B	L00314

	PEA	L0034A(PC)	;"you feel a warm glow around you"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L00316
L00314:
	ST	-$66CB(A4)	;_ws_know
	MOVEA.L	-$52A0(A4),A6	;_player + 42 (proom)
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3	;check for room ISDARK
	BEQ.B	L00315

	PEA	L0034B(PC)	;"the corridor glows and then fades"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L00316
L00315:
	PEA	L0034C(PC)	;"the room is lit by a shimmering blue light"
	JSR	_msg
	ADDQ.W	#4,A7
L00316:
	MOVEA.L	-$52A0(A4),A6	;_player + 42 (proom)
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3	;check for room ISDARK
	BNE.B	L00317

	MOVEA.L	-$52A0(A4),A6	;_player + 42 (proom)
	ANDI.W	#$FFFE,$000E(A6)	;clear room ISDARK
	PEA	-$52C0(A4)	;_player + 10
	JSR	_enter_room
	ADDQ.W	#4,A7
L00317:
	BRA.W	L00345

; drain life

L00318:
	CMPI.W	#$0002,-$52A8(A4)	;_player + 34 (hp)
	BGE.B	L00319

	PEA	L0034D(PC)	;"you are too weak to use it"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L0030F
L00319:
	JSR	_drain(PC)
	BRA.W	L00345

; polymorph, teleport to, teleport away and cancellation

L0031A:
	MOVE.W	-$52BE(A4),D4	;_player + 12
	MOVE.W	-$52C0(A4),D5	;_player + 10
L0031B:
	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_winat
	ADDQ.W	#4,A7

	MOVE.W	D0,-(A7)
	JSR	_step_ok
	ADDQ.W	#2,A7
	TST.W	D0
	BEQ.B	L0031C

	ADD.W	-$608A(A4),D4	;_delta + 2
	ADD.W	-$608C(A4),D5	;_delta + 0
	BRA.B	L0031B
L0031C:
	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_moatquick

	MOVE.L	D0,-$0004(A5)
;	TST.L	D0
	BEQ.W	L0032B

	MOVEA.L	-$0004(A5),A6
	MOVE.B	$000F(A6),D6
	MOVE.B	D6,-$0007(A5)
	CMP.b	#$46,D6		;'F'
	BNE.B	L0031D

	ANDI.W	#~C_ISHELD,-$52B4(A4)	;clear C_ISHELD ($80) for _player + 22 (flags)
L0031D:
	CMPI.W	#WS_POLYMORPH,-$0006(A5)	;5 = polymorph
	BNE.W	L00322

	MOVEA.L	-$0004(A5),A6
	MOVE.L	$002E(A6),-$000C(A5)
	MOVE.L	-$0004(A5),-(A7)
	PEA	_mlist-BASE(A4)	;_mlist
	JSR	__detach
	ADDQ.W	#8,A7
	MOVE.L	-$0004(A5),-(A7)
	JSR	_see_monst
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L0031E

	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick

	MOVEA.L	__level-BASE(A4),A6	;__level

	MOVE.B	$00(A6,D0.W),D2
	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_mvaddchquick

L0031E:
	MOVEA.L	-$0004(A5),A6
	MOVE.B	$0011(A6),D7
	MOVE.W	D4,-$608A(A4)	;_delta + 2
	MOVE.W	D5,-$608C(A4)	;_delta + 0
	PEA	-$608C(A4)	;_delta + 0

	MOVEq	#26,D0
	JSR	_rnd
	moveq	#$41,D6	;'A'
	ADD.B	D0,D6
	MOVE.W	D6,-(A7)
	MOVE.L	-$0004(A5),-(A7)
	JSR	_new_monster
	LEA	$000A(A7),A7
	MOVE.L	-$0004(A5),-(A7)
	JSR	_see_monst
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L0031F

	MOVE.B	D6,D2
	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_mvaddchquick

L0031F:
	MOVEA.L	-$0004(A5),A6
	MOVE.B	D7,$0011(A6)
	MOVE.L	-$000C(A5),$002E(A6)

	CMP.B	-$0007(A5),D6
	BEQ.B	L00320

	MOVEq	#$0001,D3
	BRA.B	L00321
L00320:
	CLR.W	D3
L00321:
	OR.B	D3,-$66C6(A4)
	BRA.W	L0032A
L00322:
	CMPI.W	#WS_CANCEL,-$0006(A5)	;is it a cancellation wand/staff?
	BNE.B	L00323

	MOVEA.L	-$0004(A5),A6
	ORI.W	#C_ISCANC,$0016(A6)	;C_ISCANC
	ANDI.W	#$FBEF,$0016(A6)	;clear C_ISINVIS|C_CANHUH
	MOVE.B	$000F(A6),$0010(A6)	;make the xerox visible
	BRA.W	L0032A
L00323:
	MOVE.L	-$0004(A5),-(A7)
	JSR	_see_monst
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00324

	MOVEA.L	-$0004(A5),A6

	MOVE.B	$0011(A6),D2
	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_mvaddchquick

L00324:
	CMPI.W	#WS_TELAWAY,-$0006(A5)	;is it a teleport away wand/staff?
	BNE.B	L00326

	MOVEA.L	-$0004(A5),A6
	MOVE.B	#$22,$0011(A6)	;'"'
	PEA	$000A(A6)
	JSR	_blank_spot
	ADDQ.W	#4,A7
	MOVE.L	-$0004(A5),-(A7)
	JSR	_see_monst
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00325

	MOVEA.L	-$0004(A5),A6

	MOVE.B	$0010(A6),D2
	MOVE.W	$000A(A6),d1
	MOVE.W	$000C(A6),d0
	JSR	_mvaddchquick

L00325:
	BRA.B	L00327
L00326:
	MOVEA.L	-$0004(A5),A6
	MOVE.W	-$52BE(A4),D3	;_player + 12
	ADD.W	-$608A(A4),D3	;_delta + 2
	MOVE.W	D3,$000C(A6)
	MOVE.W	-$52C0(A4),D3	;_player + 10
	ADD.W	-$608C(A4),D3	;_delta + 0
	MOVE.W	D3,$000A(A6)
L00327:
	MOVEA.L	-$0004(A5),A6
;	MOVE.B	$000F(A6),D3
;	EXT.W	D3
;	CMP.W	#$0046,D3	;'F'
	cmp.b	#$46,$000F(A6)
	BNE.B	L00328

	ANDI.W	#~C_ISHELD,-$52B4(A4)	;clear C_ISHELD ($80) for _player + 22 (flags)
L00328:
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$000C(A6),D3
	CMP.W	D4,D3
	BNE.B	1$

	MOVE.W	$000A(A6),D3
	CMP.W	D5,D3
	BEQ.B	L0032A
1$
	MOVE.L	A6,-(A7)
	MOVE.W	$000A(A6),-(A7)
	MOVE.W	$000C(A6),-(A7)
	JSR	_mvinch(PC)
	ADDQ.W	#4,A7
	MOVEA.L	(A7)+,A6
	MOVE.B	D0,$0011(A6)
L0032A:
	MOVEA.L	-$0004(A5),A6
	LEA	-$52C0(A4),A1	;_player + 10
	MOVE.L	A1,$0012(A6)
	ORI.W	#C_ISRUN,$0016(A6)	;C_ISRUN
L0032B:
	BRA.W	L00345

; magic missile

L0032C:
	ST	-$66C5(A4)		;set _ws_know + 6
	MOVE.W	#$000A,-$0018(A5)	;subtype of weapon 10
	MOVE.W	#$0077,-$002E(A5)	;'w' wand type
	LEA	L0034E(PC),A6		;"1d8"
	MOVE.L	A6,-$001E(A5)		;throw damage
	MOVE.W	#$03E8,-$0016(A5)	;hplus 1000
	MOVE.W	#$0001,-$0014(A5)	;dplus 1
	MOVE.W	#O_ISMISL,-$0010(A5)	;flags of object

	TST.L	_cur_weapon-BASE(A4)	;_cur_weapon
	BEQ.B	L0032D

	MOVEA.L	_cur_weapon-BASE(A4),A6	;_cur_weapon
	MOVE.B	$0021(A6),-$0024(A5)	;baseweapon
L0032D:
	LEA	L0034F(PC),A6	;"missile"
	MOVE.L	A6,-$6F34(A4)
	MOVE.W	-$608C(A4),-(A7)	;_delta + 0
	MOVE.W	-$608A(A4),-(A7)	;_delta + 2
	PEA	-$0038(A5)
	JSR	_do_motion(PC)
	ADDQ.W	#8,A7

	MOVE.W	-$002C(A5),d1
	MOVE.W	-$002A(A5),d0
	JSR	_moatquick

	MOVE.L	D0,-$0004(A5)
;	TST.L	D0
	BEQ.B	L0032E

	MOVE.L	-$0004(A5),-(A7)
	MOVE.W	#VS_MAGIC,-(A7)
	JSR	_save_throw
	ADDQ.W	#6,A7
	TST.W	D0
	BNE.B	L0032E

	PEA	-$0038(A5)
	MOVE.W	-$002C(A5),-(A7)
	MOVE.W	-$002A(A5),-(A7)
	JSR	_hit_monster(PC)
	ADDQ.W	#8,A7
	BRA.B	L0032F
L0032E:
	PEA	L00350(PC)	;"the missile vanishes with a puff of smoke"
	JSR	_msg
	ADDQ.W	#4,A7
L0032F:
	BRA.W	L00345

; striking

L00330:
	MOVE.W	-$52BE(A4),D3	;_player + 12
	ADD.W	D3,-$608A(A4)	;_delta + 2
	MOVE.W	-$52C0(A4),D3	;_player + 10
	ADD.W	D3,-$608C(A4)	;_delta + 0

	MOVE.W	-$608C(A4),d1	;_delta + 0
	MOVE.W	-$608A(A4),d0	;_delta + 2
	JSR	_moatquick

	MOVE.L	D0,-$0004(A5)
;	TST.L	D0
	BEQ.B	L00333

	MOVEq	#$0014,D0
	JSR	_rnd

	MOVEA.L	$0008(A5),A6

	TST.W	D0
	BNE.B	L00331

	LEA	L00351(PC),A1	;"3d8"
	MOVE.L	A1,$0016(A6)
	MOVE.W	#$0009,$0024(A6)	;+9 damage
	BRA.B	L00332
L00331:
	LEA	L00352(PC),A1	;"2d8"
	MOVE.L	A1,$0016(A6)
	MOVE.W	#$0004,$0024(A6)	;+4 hit
L00332:
	CLR.L	-(A7)
	MOVE.L	$0008(A5),-(A7)
	MOVEA.L	-$0004(A5),A6
	MOVE.B	$000F(A6),D3
	EXT.W	D3
	MOVE.W	D3,-(A7)
	PEA	-$608C(A4)	;_delta + 0
	JSR	_fight
	LEA	$000E(A7),A7
L00333:
	BRA.W	L00345

; haste monster, slow monster

L00334:
	MOVE.W	-$52BE(A4),D4	;_player + 12
	MOVE.W	-$52C0(A4),D5	;_player + 10
L00335:
	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_winat
	ADDQ.W	#4,A7
	MOVE.W	D0,-(A7)
	JSR	_step_ok
	ADDQ.W	#2,A7
	TST.W	D0
	BEQ.B	L00336

	ADD.W	-$608A(A4),D4	;_delta + 2
	ADD.W	-$608C(A4),D5	;_delta + 0
	BRA.B	L00335
L00336:
	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_moatquick

	MOVE.L	D0,-$0004(A5)
;	TST.L	D0
	BEQ.B	L0033D

	CMPI.W	#$0007,-$0006(A5)	;7 = haste monster
	BNE.B	L00339

	MOVEA.L	-$0004(A5),A6
	MOVE.W	$0016(A6),D3
	AND.W	#C_ISSLOW,D3	;check for C_ISSLOW
	BEQ.B	1$

	ANDI.W	#~C_ISSLOW,$0016(A6)	;clear C_ISSLOW
	BRA.B	L0033C
1$
	ORI.W	#C_ISHASTE,$0016(A6)	;set C_ISHASTE
	BRA.B	L0033C
L00339:
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$0016(A6),D3
	AND.W	#C_ISHASTE,D3	;check C_ISHASTE
	BEQ.B	1$

	ANDI.W	#~C_ISHASTE,$0016(A6)	;clear C_ISHASTE
	BRA.B	2$
1$
	ORI.W	#C_ISSLOW,$0016(A6)	;set C_ISSLOW
2$
	MOVE.B	#$01,$000E(A6)
L0033C:
	MOVE.W	D4,-$608A(A4)	;_delta + 2
	MOVE.W	D5,-$608C(A4)	;_delta + 0
	PEA	-$608C(A4)	;_delta + 0
	JSR	_start_run
	ADDQ.W	#4,A7
L0033D:
	BRA.B	L00345

; lightning, fire and cold

L0033E:
	CMPI.W	#$0002,-$0006(A5)
	BNE.B	L0033F

	LEA	L00353(PC),A2	;"bolt"
	BRA.B	L00341
L0033F:
	CMPI.W	#$0003,-$0006(A5)
	BNE.B	L00340

	LEA	L00354(PC),A2	;"flame"
	BRA.B	L00341
L00340:
	LEA	L00355(PC),A2	;"ice"
L00341:
	MOVE.L	A2,-(A7)
	PEA	-$608C(A4)	;_delta + 0
	PEA	-$52C0(A4)	;_player + 10
	JSR	_fire_bolt(PC)
	LEA	$000C(A7),A7
	MOVE.W	-$0006(A5),D3
	LEA	-$66CB(A4),A6	;_ws_know
	ST	$00(A6,D3.W)
	BRA.B	L00345
L00342:
	dc.w	L00313-L00344	;light
	dc.w	L00330-L00344	;striking
	dc.w	L0033E-L00344	;lightning bolt
	dc.w	L0033E-L00344	;fire flame
	dc.w	L0033E-L00344	;cold ice
	dc.w	L0031A-L00344	;polymorph
	dc.w	L0032C-L00344	;magic missile
	dc.w	L00334-L00344	;haste monster
	dc.w	L00334-L00344	;slow monster
	dc.w	L00318-L00344	;drain life
	dc.w	L00345-L00344	;nothing
	dc.w	L0031A-L00344	;teleport to
	dc.w	L0031A-L00344	;teleport away
	dc.w	L0031A-L00344	;cancellation
L00343:
	CMP.w	#$000E,D0
	BCC.B	L00345
	ASL.w	#1,D0
	MOVE.W	L00342(PC,D0.W),D0
L00344:	JMP	L00344(PC,D0.W)

; nothing

L00345:
	MOVEA.L	$0008(A5),A6
	SUBQ.W	#1,$0026(A6)
	CMPI.W	#$0000,$0026(A6)
	BGE.B	L00346
	CLR.W	$0026(A6)
L00346:
	MOVE.W	#$0001,-(A7)
	MOVE.L	$0008(A5),-(A7)
	JSR	_pack_name
	ADDQ.W	#6,A7
	BRA.W	L0030F

L00347:	dc.b	"zap with",0
L00348:	dc.b	"you can't zap with that!",0
L00349:	dc.b	"nothing happens",0
L0034A:	dc.b	"you feel a warm glow around you",0
L0034B:	dc.b	"the corridor glows and then fades",0
L0034C:	dc.b	"the room is lit by a shimmering blue light",0
L0034D:	dc.b	"you are too weak to use it",0
L0034E:	dc.b	"1d8",0
L0034F:	dc.b	"missile",0
L00350:	dc.b	"the missile vanishes with a puff of smoke",0
L00351:	dc.b	"3d8",0
L00352:	dc.b	"2d8",0
L00353:	dc.b	"bolt",0
L00354:	dc.b	"flame",0
L00355:	dc.b	"ice",0,0

;/*
; * drain:
; *  Do drain hit points from player shtick
; */

_drain:
	LINK	A5,#-$00A4
	MOVEM.L	D4/D5/A2/A3,-(A7)
	MOVEQ	#$00,D4

	JSR	_INDEXplayer

	MOVEA.L	__level-BASE(A4),A6	;__level
	CMP.b	#$2B,$00(A6,D0.W)	;'+'?
	BNE.B	L00356

;	JSR	_INDEXplayer

	MOVEA.L	__flags-BASE(A4),A6	;__flags
	MOVE.B	$00(A6,D0.W),D3
	AND.W	#F_PNUM,D3	;passage number mask
	MULU.W	#66,D3
	LEA	_passages-BASE(A4),A6	;_passages
	MOVEA.L	D3,A2
	ADDA.L	A6,A2
	BRA.B	L00357
L00356:
	SUBA.L	A2,A2
L00357:
	MOVEA.L	-$52A0(A4),A6	;_player + 42 (proom)
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3
	MOVE.B	D3,D5
	LEA	-$00A4(A5),A6
	MOVEA.L	A6,A3
	MOVE.L	_mlist-BASE(A4),-$0004(A5)	;_mlist
	BRA.W	L0035B
L00358:
	MOVEA.L	-$0004(A5),A6
	MOVEA.L	$002A(A6),A1
	CMPA.L	-$52A0(A4),A1	;_player + 42 (proom)
	BEQ.B	L00359

	MOVEA.L	-$0004(A5),A6
	MOVEA.L	$002A(A6),A1
	CMPA.L	A2,A1
	BEQ.B	L00359

	TST.B	D5
	BEQ.B	L0035A

	MOVEA.L	-$0004(A5),A6
	MOVE.W	$000A(A6),d0
	MOVE.W	$000C(A6),d1
	JSR	_INDEXquick

	MOVEA.L	__level-BASE(A4),A6	;__level
	CMP.b	#$2B,$00(A6,D0.W)	;'+'?
	BNE.B	L0035A

;	MOVEA.L	-$0004(A5),A6
;	MOVE.W	$000A(A6),d0
;	MOVE.W	$000C(A6),d1
;	JSR	_INDEXquick

	MOVEA.L	__flags-BASE(A4),A6	;__flags
	MOVE.B	$00(A6,D0.W),D3
	AND.W	#F_PNUM,D3	;passage number mask
	MULU.W	#66,D3
	LEA	_passages-BASE(A4),A6	;_passages
	ADD.L	A6,D3
	CMP.L	-$52A0(A4),D3	;_player + 42 (proom)
	BNE.B	L0035A
L00359:
	MOVEA.L	A3,A6
	ADDQ.L	#4,A3
	MOVE.L	-$0004(A5),(A6)
L0035A:
	MOVEA.L	-$0004(A5),A6
	MOVE.L	(A6),-$0004(A5)
L0035B:
	TST.L	-$0004(A5)
	BNE.W	L00358

	MOVE.L	A3,D3
	LEA	-$00A4(A5),A6
	SUB.L	A6,D3
	LSR.L	#2,D3
	MOVE.W	D3,D4
;	TST.W	D3
	BNE.B	L0035D

	PEA	L00362(PC)	;"you have a tingling feeling"
	JSR	_msg
	ADDQ.W	#4,A7
L0035C:
	MOVEM.L	(A7)+,D4/D5/A2/A3
	UNLK	A5
	RTS

L0035D:
	CLR.L	(A3)
	MOVE.W	-$52A8(A4),D3	;_player + 34 (hp)
	ASR.W	#1,D3		;hp cut in half
	MOVE.W	D3,-$52A8(A4)	;_player + 34 (hp)
;	MOVE.W	-$52A8(A4),D3	;_player + 34 (hp)
	EXT.L	D3
	DIVS.W	D4,D3
	MOVE.W	D3,D4
	ADDQ.W	#1,D4
	LEA	-$00A4(A5),A6
	MOVEA.L	A6,A3
	BRA.B	L00361
L0035E:
	MOVE.L	(A3),-$0004(A5)
	MOVEA.L	-$0004(A5),A6
	SUB.W	D4,$0022(A6)
	CMPI.W	#$0000,$0022(A6)
	BGT.B	L0035F

	MOVE.L	-$0004(A5),-(A7)
	JSR	_see_monst
	ADDQ.W	#4,A7
	MOVE.W	D0,-(A7)
	MOVE.L	-$0004(A5),-(A7)
	JSR	_killed
	ADDQ.W	#6,A7
	BRA.B	L00360
L0035F:
	MOVEA.L	-$0004(A5),A6
	PEA	$000A(A6)
	JSR	_start_run
	ADDQ.W	#4,A7
L00360:
	ADDQ.L	#4,A3
L00361:
	TST.L	(A3)
	BNE.B	L0035E

	BRA.B	L0035C

L00362:	dc.b	"you have a tingling feeling",0

;/*
; * fire_bolt:
; *  Fire a bolt in a given direction from a specific starting place
; */

_fire_bolt:
	LINK	A5,#-$0084
	MOVEM.L	D4-D7/A2/A3,-(A7)

	PEA	L0038B(PC)	;"frost"
	MOVE.L	$0010(A5),-(A7)
	JSR	_strcmp
	ADDQ.W	#8,A7
	TST.W	D0
	BNE.B	L00363

	MOVEq	#$0001,D3
	BRA.B	L00364
L00363:
	CLR.W	D3
L00364:
	MOVE.B	D3,-$0083(A5)
	ADD.W	#$0077,D3	;'w' wand type
	MOVE.W	D3,-$0078(A5)
	MOVE.W	#$000A,-$0062(A5)	;subtype 10
	LEA	L0038C(PC),A6		;"6d6"
	MOVE.L	A6,-$0068(A5)		;throw damage
	MOVE.L	A6,-$006C(A5)		;wield damage
	MOVE.W	#$001E,-$0060(A5)	;hplus 24
	CLR.W	-$005E(A5)		;dplus 0
	MOVE.L	$0010(A5),-$6F34(A4)
	MOVE.B	-$0077(A5),D4
	LEA	-$0008(A5),A6
	MOVEA.L	$0008(A5),A1
	MOVE.L	(A1)+,(A6)+
	LEA	-$52C0(A4),A6	;_player + 10
	MOVEA.L	$0008(A5),A1
	CMPA.L	A6,A1
	BEQ.B	L00365

	MOVEq	#$0001,D3
	BRA.B	L00366
L00365:
	CLR.W	D3
L00366:
	MOVE.B	D3,D6
	MOVEQ	#$00,D7
	CLR.B	-$0001(A5)
	SUBA.L	A3,A3
	BRA.W	L00386
L00367:
	MOVEA.L	$000C(A5),A6
	MOVE.W	$0002(A6),D3
	ADD.W	D3,-$0006(A5)
	MOVEA.L	$000C(A5),A6
	MOVE.W	(A6),D3
	ADD.W	D3,-$0008(A5)
	MOVE.W	-$0008(A5),-(A7)
	MOVE.W	-$0006(A5),-(A7)
	JSR	_winat
	ADDQ.W	#4,A7

	MOVE.B	D0,D5
	MOVE.W	A3,D3
	MULU.W	#$0006,D3
	LEA	-$0050(A5),A6
	ADDA.L	D3,A6
	LEA	-$0008(A5),A1
	MOVE.L	(A1),(A6)
	LEA	-$004C(A5),A6
	MOVE.L	D3,-(A7)
	MOVE.L	A6,-(A7)
	MOVE.W	-$0008(A5),-(A7)
	MOVE.W	-$0006(A5),-(A7)
	JSR	_mvinch(PC)
	ADDQ.W	#4,A7

	MOVEA.L	(A7)+,A6
	MOVE.L	(A7)+,D3
	MOVE.B	D0,$00(A6,D3.L)
	CMP.B	D4,D0
	BNE.B	L00368

	MOVE.W	A3,D3
	MULU.W	#$0006,D3
	LEA	-$004C(A5),A6
	CLR.B	$00(A6,D3.L)
L00368:
	MOVEQ	#$00,D0
	MOVE.B	D5,D0
	BRA.W	L00384
L00369:
	TST.B	-$0001(A5)
	BNE.B	L0036C

	TST.B	D6
	BNE.B	L0036A

	MOVEq	#$0001,D3
	BRA.B	L0036B
L0036A:
	CLR.W	D3
L0036B:
	MOVE.B	D3,D6
L0036C:
	CLR.B	-$0001(A5)
	MOVEA.L	$000C(A5),A6
	NEG.W	$0002(A6)
;	MOVEA.L	$000C(A5),A6
	NEG.W	(A6)
	SUBQ.W	#1,A3
	MOVE.L	$0010(A5),-(A7)
	PEA	L0038D(PC)	"the %s bounces"
	JSR	_msg
	ADDQ.W	#8,A7
	BRA.W	L00385
L0036D:
	TST.B	D6
	BNE.W	L00378

	MOVE.W	-$0008(A5),d1
	MOVE.W	-$0006(A5),d0
	JSR	_moatquick

	MOVEA.L	D0,A2
	TST.L	D0
	BEQ.W	L00378

	MOVEQ	#$01,D6
	TST.B	-$0001(A5)
	BNE.B	L0036E

	MOVEq	#$0001,D3
	BRA.B	L0036F
L0036E:
	CLR.W	D3
L0036F:
	MOVE.B	D3,-$0001(A5)
	CMP.B	#$22,$0011(A2)	;'"'
	BEQ.B	L00370

	MOVE.W	-$0008(A5),d0
	MOVE.W	-$0006(A5),d1
	JSR	_INDEXquick

	MOVEA.L	__level-BASE(A4),A6	;__level
	MOVE.B	$00(A6,D0.W),$0011(A2)
L00370:
	MOVE.L	A2,-(A7)
	MOVE.W	#VS_MAGIC,-(A7)
	JSR	_save_throw
	ADDQ.W	#6,A7
	TST.W	D0
	BEQ.B	L00371

	TST.B	-$0083(A5)	;is it a frost bolt?
	BEQ.W	L00374
L00371:
	LEA	-$0076(A5),A6
	LEA	-$0008(A5),A1
	MOVE.L	(A1)+,(A6)+
	MOVEQ	#$01,D7

	; the dragon is immune to the fire flame

	CMP.B	#$44,$000F(A2)	; D = dragon
	BNE.B	L00372

	PEA	L0038E(PC)	;"flame"
	MOVE.L	$0010(A5),-(A7)
	JSR	_strcmp
	ADDQ.W	#8,A7
	TST.W	D0
	BNE.B	L00372

	PEA	L0038F(PC)	;"the flame bounces off the dragon"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L00373
L00372:
	PEA	-$0082(A5)
	MOVE.W	-$0008(A5),-(A7)
	MOVE.W	-$0006(A5),-(A7)
	JSR	_hit_monster(PC)
	ADDQ.W	#8,A7

	MOVE.W	-$0008(A5),-(A7)
	MOVE.W	-$0006(A5),-(A7)
	JSR	_mvinch(PC)
	ADDQ.W	#4,A7

	MOVEQ	#$00,D3
	MOVE.B	D4,D3
	CMP.W	D3,D0
	BEQ.B	L00373

	MOVE.W	-$0008(A5),-(A7)
	MOVE.W	-$0006(A5),-(A7)
	JSR	_mvinch(PC)
	ADDQ.W	#4,A7

	MOVE.W	A3,D3
	MULU.W	#$0006,D3
	LEA	-$004C(A5),A6
	MOVE.B	D0,$00(A6,D3.L)
L00373:
	BRA.B	L00377
L00374:
	CMP.B	#$58,D5		;'X'
	BNE.B	L00375

	CMP.B	#$58,$0010(A2)	;'X'
	BNE.B	L00377
L00375:
	LEA	-$52C0(A4),A6	;_player + 10
	MOVEA.L	$0008(A5),A1
	CMPA.L	A6,A1
	BNE.B	L00376

	PEA	-$0008(A5)
	JSR	_start_run
	ADDQ.W	#4,A7
L00376:
	MOVEQ	#$00,D3
	MOVE.B	D5,D3
	SUB.W	#$0041,D3	;'A'
	MULU.W	#26,D3
	LEA	_monsters-BASE(A4),A6	;_monsters
	MOVE.L	$00(A6,D3.L),-(A7)
	MOVE.L	$0010(A5),-(A7)
	PEA	L00390(PC)	;"the %s whizzes past the %s"
	JSR	_msg
	LEA	$000C(A7),A7
L00377:
	BRA.W	L00381
L00378:
	TST.B	D6
	BEQ.W	L00381

	PEA	-$52C0(A4)	;_player + 10
	PEA	-$0008(A5)
	JSR	__ce
	ADDQ.W	#8,A7
	TST.W	D0
	BEQ.W	L00381

	MOVEQ	#$00,D6
	TST.B	-$0001(A5)
	BNE.B	L00379

	MOVEq	#$0001,D3
	BRA.B	L0037A
L00379:
	CLR.W	D3
L0037A:
	MOVE.B	D3,-$0001(A5)
	MOVE.W	#VS_MAGIC,-(A7)
	JSR	_save
	ADDQ.W	#2,A7
	TST.W	D0
	BNE.W	L00380

	TST.B	-$0083(A5)
	BEQ.B	L0037C

	LEA	L00392(PC),a0	;" from the Ice Monster"
	JSR	_noterse

	MOVE.L	D0,-(A7)
	PEA	L00391(PC)	;"You are frozen by a blast of frost%s."
	JSR	_msg
	ADDQ.W	#8,A7
	CMPI.W	#$0014,_no_command-BASE(A4)	;_no_command
	BGE.B	L0037B

	MOVEq	#$0007,D0
	JSR	_spread

	ADD.W	D0,_no_command-BASE(A4)	;_no_command
L0037B:
	BRA.B	L0037E
L0037C:
	MOVE.W	#$0006,-(A7)	;6d6
	MOVE.W	#$0006,-(A7)
	JSR	_roll
	ADDQ.W	#4,A7
	SUB.W	D0,-$52A8(A4)	;_player + 34 (hp)
	BGT.B	L0037E

	LEA	-$52C0(A4),A6	;_player + 10
	MOVEA.L	$0008(A5),A1
	CMPA.L	A6,A1
	BNE.B	L0037D

	MOVE.W	#$0062,-(A7)	;'b' bear trap
	JSR	_death
	ADDQ.W	#2,A7
	BRA.B	L0037E
L0037D:
	MOVEA.L	$0008(A5),A6
	MOVE.W	(A6)+,d1
	MOVE.W	(A6),d0
	JSR	_moatquick

	MOVEA.L	D0,A6
	MOVE.B	$000F(A6),D3
;	EXT.W	D3
	MOVE.W	D3,-(A7)
	JSR	_death
	ADDQ.W	#2,A7
L0037E:
	MOVEQ	#$01,D7
	TST.B	-$0083(A5)
	BNE.B	L0037F

	MOVE.L	$0010(A5),-(A7)
	PEA	L00393(PC)	;"you are hit by the %s"
	JSR	_msg
	ADDQ.W	#8,A7
L0037F:
	BRA.B	L00381
L00380:
	MOVE.L	$0010(A5),-(A7)
	PEA	L00394(PC)	;"the %s whizzes by you"
	JSR	_msg
	ADDQ.W	#8,A7
L00381:
;	TST.B	-$0083(A5)
;	BEQ.B	L00382

;	MOVE.W	#$000D,-(A7)
;	JSR	_set_attr(PC)
;	ADDQ.W	#2,A7

;	BRA.B	L00383
;L00382:
;	MOVE.W	#$0003,-(A7)
;	JSR	_set_attr(PC)
;	ADDQ.W	#2,A7
L00383:
	JSR	_tick_pause

	MOVE.B	D4,D2
	MOVE.W	-$0008(A5),d1
	MOVE.W	-$0006(A5),d0
	JSR	_mvaddchquick

	JSR	_standend
	BRA.B	L00385
L00384:
	SUB.w	#$0020,D0	;' ' SPACE
	BEQ.W	L00369
	SUB.w	#$000B,D0	;'+' DOOR
	BEQ.W	L00369
	SUBQ.w	#2,D0		;'-' vertical WALL
	BEQ.W	L00369
	SUB.w	#$000F,D0	;'<' top left corner
	BEQ.W	L00369
	SUBQ.w	#2,D0		;'>' top right corner
	BEQ.W	L00369
	SUB.w	#$003D,D0	;'{' bottom left corner
	BEQ.W	L00369
	SUBQ.w	#1,D0		;'|' horizontal WALL
	BEQ.W	L00369
	SUBQ.w	#1,D0		;'}' bottom right corner
	BEQ.W	L00369
	BRA.W	L0036D
L00385:
	ADDQ.W	#1,A3
L00386:
	CMPA.W	#$0006,A3
	BGE.B	L00387

	TST.B	D7
	BEQ.W	L00367
L00387:
	CLR.W	-$0004(A5)
	BRA.B	L0038A
L00388:
	JSR	_tick_pause

	MOVE.W	-$0004(A5),D3
	MULU.W	#$0006,D3
	LEA	-$004C(A5),A6

	MOVE.B	$00(A6,D3.L),D2
	BEQ.B	L00389

	LEA	-$0050(A5),A6
	MOVE.W	$00(A6,D3.L),d1
	MOVE.W	$02(A6,D3.L),d0
	JSR	_mvaddchquick

L00389:
	ADDQ.W	#1,-$0004(A5)
L0038A:
	MOVE.W	-$0004(A5),D3
	CMP.W	A3,D3
	BLT.B	L00388

	MOVEM.L	(A7)+,D4-D7/A2/A3
	UNLK	A5
	RTS

L0038B:	dc.b	"frost",0
L0038C:	dc.b	"6d6",0
L0038D:	dc.b	"the %s bounces",0
L0038E:	dc.b	"flame",0
L0038F:	dc.b	"the flame bounces off the dragon",0
L00390:	dc.b	"the %s whizzes past the %s",0
L00391:	dc.b	"You are frozen by a blast of frost%s.",0
L00392:	dc.b	" from the Ice Monster",0
L00393:	dc.b	"you are hit by the %s",0
L00394:	dc.b	"the %s whizzes by you",0,0

;/*
; * charge_str:
; *  Return an appropriate string for a wand charge
; */

_charge_str:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVE.W	$0028(A2),D3
	AND.W	#O_ISKNOW,D3
	BNE.B	L00395

	CLR.B	-$54DA(A4)
	BRA.B	L00396
L00395:
	MOVE.W	$0026(A2),-(A7)
	PEA	L00397(PC)	;" [%d charges]"
	PEA	-$54DA(A4)
	JSR	_sprintf
	LEA	$000A(A7),A7
L00396:
	LEA	-$54DA(A4),A6
	MOVE.L	A6,D0

	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L00397:	dc.b	" [%d charges]",0

