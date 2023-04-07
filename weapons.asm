
; weapon damage wielded and thrown

; mace
L005E8:	dc.b	"2d4",0	; 2-8 avg 5
L005E9:	dc.b	"1d3",0	; 1-3 avg 2

; broad sword
L005EA:	dc.b	"2d8",0	; 2-16 avg 9
L005EB:	dc.b	"1d2",0	; 1-2 avg 1.5

; short bow
L005EC:	dc.b	"1d1",0	; 1-1 avg 1
L005ED:	dc.b	"1d1",0	; 1-1 avg 1

; arrow
L005EE:	dc.b	"1d1",0	; 1-1 avg 1
L005EF:	dc.b	"2d3",0	; 2-6 avg 4

; dagger
L005F0:	dc.b	"1d6",0	; 1-6 avg 3.5
L005F1:	dc.b	"1d4",0	; 1-4 avg 2.5

; two handed sword
L005F2:	dc.b	"4d4",0	; 4-16 avg 10	;best wielded weapon
L005F3:	dc.b	"1d2",0	; 1-2 avg 1.5

; dart
L005F4:	dc.b	"1d1",0	; 1-1 avg 1
L005F5:	dc.b	"1d3",0	; 1-3 avg 2

; crossbow
L005F6:	dc.b	"1d1",0	; 1-1 avg 1
L005F7:	dc.b	"1d1",0	; 1-1 avg 1

; crossbow bolts
L005F8:	dc.b	"1d2",0	; 1-2 avg 1.5
L005F9:	dc.b	"2d5",0	; 2-10 avg 6	;best throw weapon

; flail
L005FA:	dc.b	"2d6",0	; 2-12 avg 7
L005FB:	dc.b	"1d6",0	; 1-6 avg 3.5

;/*
; * missile:
; *  Fire a missile in a given direction
; */

_missile:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVE.W	#$006D,-(A7)	;'m' weapon type
	PEA	L00603(PC)	;"throw"
	JSR	_get_item
	ADDQ.W	#6,A7

	MOVEA.L	D0,A2
	TST.L	D0
	BNE.B	L005FD
L005FC:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L005FD:
	MOVE.L	A2,-(A7)
	JSR	_can_drop(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L005FC

	MOVE.L	A2,-(A7)
	JSR	_is_current(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.B	L005FC

	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_unpack
	ADDQ.W	#6,A7

	MOVEA.L	D0,A2
	TST.L	D0
	BNE.B	L00600

	JSR	_stuck(PC)
	BRA.B	L005FC
L00600:
	MOVE.W	$000A(A5),-(A7)
	MOVE.W	$0008(A5),-(A7)
	MOVE.L	A2,-(A7)
	BSR.B	_do_motion
	ADDQ.W	#8,A7

	MOVE.W	$000C(A2),d1
	MOVE.W	$000E(A2),d0
	JSR	_moatquick

	TST.L	D0
	BEQ.B	L00601

	MOVE.L	A2,-(A7)
	MOVE.W	$000C(A2),-(A7)
	MOVE.W	$000E(A2),-(A7)
	JSR	_hit_monster(PC)
	ADDQ.W	#8,A7
	TST.W	D0
	BNE.B	L005FC
L00601:
	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_fall(PC)
	ADDQ.W	#6,A7
	BRA.B	L005FC

L00603:	dc.b	"throw",0

;/*
; * do_motion:
; *  Do the actual motion on the screen done by an object traveling
; *  across the room
; */

_do_motion:
	LINK	A5,#-$0000
	MOVEM.L	D4-D7,-(A7)

	MOVE.W	$000C(A5),D4
	MOVE.W	$000E(A5),D5
	MOVEQ	#$22,D6
	MOVEA.L	$0008(A5),A6
	ADDA.L	#$0000000C,A6
	LEA	-$52C0(A4),A1	;_player + 10
	MOVE.L	(A1)+,(A6)+
L00604:
	CMP.b	#$22,D6		;'"'
	BEQ.B	L00605

	PEA	-$52C0(A4)	;_player + 10
	MOVEA.L	$0008(A5),A6
	PEA	$000C(A6)
	JSR	__ce
	ADDQ.W	#8,A7

	TST.W	D0
	BNE.B	L00605

	MOVEA.L	$0008(A5),A6
	MOVE.W	$000C(A6),-(A7)
;	MOVEA.L	$0008(A5),A6
	MOVE.W	$000E(A6),-(A7)
	JSR	_cansee
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00605

	MOVE.B	D6,D2
	MOVEA.L	$0008(A5),A6
	MOVE.W	$000C(A6),d1
	MOVE.W	$000E(A6),d0
	JSR	_mvaddchquick

L00605:
	MOVEA.L	$0008(A5),A6
	ADD.W	D4,$000E(A6)
	ADD.W	D5,$000C(A6)
	MOVE.W	$000C(A6),-(A7)
	MOVE.W	$000E(A6),-(A7)
	JSR	_winat
	ADDQ.W	#4,A7

	MOVE.W	D0,D7
	MOVE.W	D0,-(A7)
	JSR	_step_ok
	ADDQ.W	#2,A7
	TST.W	D0
	BEQ.B	L0060A

	CMP.W	#$002B,D7	;'+'
	BEQ.B	L0060A

	MOVEA.L	$0008(A5),A6
	MOVE.W	$000C(A6),-(A7)
	MOVE.W	$000E(A6),-(A7)
	JSR	_cansee
	ADDQ.W	#4,A7

	TST.W	D0
	BEQ.B	L00606

	MOVEA.L	$0008(A5),A6
	MOVE.W	$000C(A6),d0
	MOVE.W	$000E(A6),d1
	JSR	_INDEXquick

	MOVEA.L	__level-BASE(A4),A6	;__level
	MOVE.B	$00(A6,D0.W),D6

	MOVEA.L	$0008(A5),A6
	MOVE.W	$000A(A6),d2
	MOVE.W	$000C(A6),d1
	MOVE.W	$000E(A6),d0
	JSR	_mvaddchquick

	JSR	_tick_pause
	BRA.B	L00609
L00606:
	MOVEQ	#$22,D6
L00609:
	BRA.W	L00604
L0060A:
	MOVEM.L	(A7)+,D4-D7
	UNLK	A5
	RTS

;/*
; * fall:
; *  Drop an item someplace around here.
; */

_fall:
	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)
	PEA	_fall_pos-BASE(A4)
	MOVE.L	$0008(A5),-(A7)
	JSR	_fallpos(PC)
	ADDQ.W	#8,A7
;	EXT.L	D0
	BRA.W	L00611
L0060B:
	MOVE.W	-$53D2(A4),d0
	MOVE.W	-$53D0(A4),d1
	JSR	_INDEXquick

	MOVE.W	D0,D4
	MOVEA.L	__level-BASE(A4),A6	;__level
	MOVEA.L	$0008(A5),A1
	MOVE.B	$000B(A1),$00(A6,D4.W)
	MOVEA.L	$0008(A5),A6
	ADDA.L	#$0000000C,A6
	LEA	_fall_pos-BASE(A4),A1
	MOVE.L	(A1)+,(A6)+
	MOVE.W	_fall_posx-BASE(A4),-(A7)
	MOVE.W	_fall_posy-BASE(A4),-(A7)
	JSR	_cansee
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.W	L0060E

	MOVEA.L	$0008(A5),A6

	MOVE.W	$000C(A6),d0
	MOVE.W	$000E(A6),d1
	JSR	_INDEXquick

	MOVEA.L	__flags-BASE(A4),A6	;__flags
;	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	AND.B	#F_SEEN,D3	;have seen this spot before
	BNE.B	L0060C

;	MOVEA.L	$0008(A5),A6
;	MOVE.W	$000C(A6),d0
;	MOVE.W	$000E(A6),d1
;	JSR	_INDEXquick

;	MOVEA.L	__flags-BASE(A4),A6	;__flags
;	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	AND.B	#F_DROPPED,D3	;object was dropped here
	BEQ.B	L0060D
L0060C:
	JSR	_standout
L0060D:
	MOVEA.L	$0008(A5),A6
	MOVE.W	$000A(A6),d2
	MOVE.W	_fall_posx-BASE(A4),d1
	MOVE.W	_fall_posy-BASE(A4),d0
	JSR	_mvaddchquick

	JSR	_standend

	MOVE.W	_fall_posx-BASE(A4),d1
	MOVE.W	_fall_posy-BASE(A4),d0
	JSR	_moatquick

	TST.L	D0
	BEQ.B	L0060E

	MOVEA.L	D0,A6
	MOVEA.L	$0008(A5),A1
	MOVE.B	$000B(A1),$0011(A6)
L0060E:
	MOVE.L	$0008(A5),-(A7)
	PEA	_lvl_obj-BASE(A4)	;_lvl_obj
	JSR	__attach
	ADDQ.W	#8,A7
L0060F:
	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

L00610:
	CLR.B	$000D(A5)
	BRA.B	L00612
L00611:
	SUBQ.w	#1,D0
	BEQ.W	L0060B
	SUBQ.w	#1,D0
	BEQ.B	L00610
L00612:
	TST.B	$000D(A5)
	BEQ.B	L00613

	LEA	L00615(PC),a0	;" as it hits the ground"
	JSR	_noterse

	MOVE.L	D0,-(A7)
	CLR.W	-(A7)
	MOVE.L	$0008(A5),-(A7)
	JSR	_nameof
	ADDQ.W	#6,A7
	MOVE.L	D0,-(A7)
	PEA	L00614(PC)	;"the %s vanishes%s."
	JSR	_msg
	LEA	$000C(A7),A7
L00613:
	MOVE.L	$0008(A5),-(A7)
	JSR	_discard
	ADDQ.W	#4,A7
	BRA.B	L0060F

L00614:	dc.b	"the %s vanishes%s.",0
L00615:	dc.b	" as it hits the ground",0

;/*
; * init_weapon:
; *  Set up the initial goodies for a weapon
; */

_init_weapon:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	$0008(A5),A2	;empty object we fill up now
	MOVE.W	$0020(A2),D0	;weapon index

	MOVEQ	#$6D,D3
	ADD.B	D0,D3		; 'm' 'weapon type
	MOVE.W	D3,$000A(A2)

	mulu.w	#12,d0

	LEA	_w_magic-BASE(A4),A6		;_w_magic
	MOVE.L	$00(A6,D0.w),$0016(A2)	;wield damage
	MOVE.L	$04(A6,D0.w),$001A(A2)	;throw damage
	MOVE.B	$08(A6,D0.w),$0014(A2)	;weapon needed for better throw
	MOVE.W	$0A(A6,D0.w),D3		;flags
	move.w	D3,$0028(A2)

	moveq	#0,d1		;set group
	moveq	#1,d0		;default number of items
	AND.W	#O_ISMANY,D3	;check for O_ISMANY
	BEQ.B	1$

	MOVEq	#$0008,D0	;random count of bolts, arrows, darts...
	JSR	_rnd
	ADDQ.W	#8,D0		; add 8 - 15

	MOVE.W	_group-BASE(A4),d1	;get group for item
	ADDQ.W	#1,_group-BASE(A4)	;_group++

1$	MOVE.W	d0,$001E(A2)	;one or the random number of items
	MOVE.W	d1,$002C(A2)	;set group for item

	MOVE.L	(A7)+,A2
	UNLK	A5
	RTS

;/*
; * hit_monster:
; *  Does the missile hit the monster?
; */

_hit_monster:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5/A2,-(A7)

	MOVE.W	$0008(A5),D4
	MOVE.W	$000A(A5),D5

	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_moatquick

	TST.L	D0
	BEQ.B	L00618

	MOVEA.L	D0,A2
	MOVE.W	D4,monster_posy-BASE(A4)
	MOVE.W	D5,monster_posx-BASE(A4)
	MOVE.W	#$0001,-(A7)
	MOVE.L	$000C(A5),-(A7)
	MOVE.B	$000F(A2),D3
	EXT.W	D3
	MOVE.W	D3,-(A7)
	PEA	monster_pos-BASE(A4)
	JSR	_fight
	LEA	$000C(A7),A7
L00618:
	MOVEM.L	(A7)+,D4/D5/A2
	UNLK	A5
	RTS

;/*
; * num:
; *  Figure out the plus number for armor/weapons
; */

_num:
	LINK	A5,#-$0000

	MOVE.W	$0008(A5),-(A7)
	BGE.B	1$

	PEA	L00620(PC)	;"",0
	BRA.B	2$
1$
	PEA	L00621(PC)	;"+"
2$
	PEA	L0061F(PC)	;"%s%d"
	PEA	_num_storage-BASE(A4)
	JSR	_sprintf
	LEA	$000E(A7),A7

	CMP.b	#$6D,$000D(A5)	; m weapon type
	BNE.B	L0061E

	MOVE.W	$000A(A5),-(A7)
	BGE.B	3$

	PEA	L00620(PC)	;"",0
	BRA.B	4$

3$	PEA	L00621(PC)	;"+"

4$	PEA	L00622(PC)	;",%s%d"
	LEA	_num_storage-BASE(A4),A0
	JSR	_strlenquick

	LEA	_num_storage-BASE(A4),A6
	ADD.W	D0,A6
	MOVE.L	A6,-(A7)
	JSR	_sprintf
	LEA	$000E(A7),A7
L0061E:
	LEA	_num_storage-BASE(A4),A6
	MOVE.L	A6,D0

	UNLK	A5
	RTS

L0061F:	dc.b	"%s%d",0
L00620:	dc.b	$00
L00621:	dc.b	"+",0
L00622:	dc.b	",%s%d",0

;/*
; * wield:
; */  Pull out a certain weapon

_wield:
	LINK	A5,#-$0000
	MOVEM.L	A2/A3,-(A7)
	MOVEA.L	$0008(A5),A2
	MOVEA.L	_cur_weapon-BASE(A4),A3		;_cur_weapon
	MOVE.L	A3,-(A7)		;_cur_weapon
	JSR	_can_drop(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.B	L00626
	MOVE.L	A3,_cur_weapon-BASE(A4)	;_cur_weapon
	MOVE.W	#$0001,-(A7)
	MOVE.L	A3,-(A7)	;_cur_weapon
	JSR	_pack_name
	ADDQ.W	#6,A7
L00625:
	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

L00626:
	MOVE.W	#$0001,-(A7)
	MOVE.L	A3,_cur_weapon-BASE(A4)	;_cur_weapon
	MOVE.L	A3,-(A7)
	JSR	_pack_name
	ADDQ.W	#6,A7
	MOVE.L	A2,D3
	BNE.B	L00628

	MOVE.W	#$006D,-(A7)	;'m' weapon type
	PEA	L0062B(PC)	;"wield"
	JSR	_get_item
	ADDQ.W	#6,A7
	MOVEA.L	D0,A2
	TST.L	D0
	BNE.B	L00628
L00627:
	CLR.B	_after-BASE(A4)	;_after
	BRA.B	L00625
L00628:
	MOVE.L	A2,-(A7)
	JSR	_typeof(PC)
	ADDQ.W	#4,A7
	CMP.W	#$0061,D0	; 'a' armor type
	BNE.B	L00629

	PEA	L0062C(PC)	;"you can't wield armor"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L00627
L00629:
	MOVE.L	A2,-(A7)
	JSR	_is_current(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.B	L00627

	MOVE.L	A2,-(A7)
	JSR	_check_wisdom
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.B	L00625

	MOVE.L	A2,_cur_weapon-BASE(A4)	;_cur_weapon
	MOVE.W	#$0001,-(A7)
	MOVE.L	A3,-(A7)
	JSR	_pack_name
	ADDQ.W	#6,A7
	MOVE.L	A2,-(A7)
	JSR	_pack_char(PC)
	ADDQ.W	#4,A7
	MOVE.W	D0,-(A7)
	MOVE.W	#$005E,-(A7)	;"^"
	MOVE.L	A2,-(A7)
	JSR	_nameof
	ADDQ.W	#6,A7
	MOVE.L	D0,-(A7)
	PEA	L0062D(PC)	;"you are now wielding %s (%c)"
	JSR	_msg
	LEA	$000A(A7),A7
	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_pack_name
	ADDQ.W	#6,A7
	BRA.W	L00625

L0062B:	dc.b	"wield",0
L0062C:	dc.b	"you can't wield armor",0
L0062D:	dc.b	"you are now wielding %s (%c)",0,0

;/*
; * fallpos:
; *  Pick a random position around the given (y, x) coordinates
; */

_fallpos:
	LINK	A5,#-$0004
	MOVEM.L	D4-D7/A2,-(A7)

	MOVEA.L	$000C(A5),A2
	MOVEQ	#$00,D6
	MOVEA.L	$0008(A5),A6
	MOVE.W	$000E(A6),D4
	SUBQ.W	#1,D4
	BRA.W	L00637
L0062E:
	MOVEA.L	$0008(A5),A6
	MOVE.W	$000C(A6),D5
	SUBQ.W	#1,D5
	BRA.W	L00636
L0062F:
	CMP.W	-$52BE(A4),D4	;_player + 12
	BNE.B	L00630

	CMP.W	-$52C0(A4),D5	;_player + 10
	BEQ.W	L00635
L00630:
	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_offmap
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.W	L00635

	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick

	MOVEA.L	__level-BASE(A4),A6	;__level
	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	MOVE.W	D3,D7
	CMP.W	#$002E,D3	;'.'
	BEQ.B	L00631

	CMP.W	#$0023,D7	;'#'
	BNE.B	L00633
L00631:
	ADDQ.W	#1,D6
	MOVE.W	D6,D0
	JSR	_rnd
	TST.W	D0
	BNE.B	L00632

	MOVE.W	D4,$0002(A2)
	MOVE.W	D5,(A2)
L00632:
	BRA.B	L00635
L00633:
	MOVE.W	D7,-(A7)
	JSR	_step_ok
	ADDQ.W	#2,A7
	TST.W	D0
	BEQ.B	L00635

	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_find_obj
	ADDQ.W	#4,A7
	MOVE.L	D0,-$0004(A5)
;	TST.L	D0
	BEQ.B	L00635

	MOVEA.L	-$0004(A5),A6
	MOVEA.L	$0008(A5),A1
	MOVE.W	$000A(A6),D3
	CMP.W	$000A(A1),D3
	BNE.B	L00635

;	MOVEA.L	-$0004(A5),A6
	TST.W	$002C(A6)
	BEQ.B	L00635

;	MOVEA.L	-$0004(A5),A6
;	MOVEA.L	$0008(A5),A1
	MOVE.W	$002C(A6),D3
	CMP.W	$002C(A1),D3
	BNE.B	L00635

;	MOVEA.L	-$0004(A5),A6
;	MOVEA.L	$0008(A5),A1
	MOVE.W	$001E(A1),D3
	ADD.W	D3,$001E(A6)
	MOVEQ	#$02,D0
L00634:
	MOVEM.L	(A7)+,D4-D7/A2
	UNLK	A5
	RTS

L00635:
	ADDQ.W	#1,D5
L00636:
	MOVEA.L	$0008(A5),A6
	MOVE.W	$000C(A6),D3
	ADDQ.W	#1,D3
	CMP.W	D3,D5
	BLE.W	L0062F

	ADDQ.W	#1,D4
L00637:
	MOVEA.L	$0008(A5),A6
	MOVE.W	$000E(A6),D3
	ADDQ.W	#1,D3
	CMP.W	D3,D4
	BLE.W	L0062E

	TST.W	D6
	BEQ.B	L00638

	MOVEq	#$0001,D0
	BRA.B	L00639
L00638:
	CLR.W	D0
L00639:
	BRA.B	L00634
