;/*
; * adjustments to hit probabilities due to strength
; */

_str_plus:

	lea	str_hit_list,a0
	bra	str_common

;/*
; * adjustments to damage done due to strength
; */

_add_dam:

	lea	str_dam_list,a0
	bra	str_common

str_common:
	MOVE.W	$0004(A7),D3
	CMP.W	#$0008,D3
	BCC.B	2$

	MOVE.L	D3,D0
	SUBQ.W	#7,D0
1$
	RTS

2$	MOVEQ	#$00,D0

3$	CMP.b	(a0)+,D3
	BLT.B	1$
	ADDQ.W	#1,D0
	bra	3$

str_hit_list: dc.b	17,19,21,31,0
str_dam_list: dc.b	16,17,18,20,22,31,0

;/*
; * fight:
; *  The player attacks the monster.
; */

_fight:
	LINK	A5,#-$0002
	MOVEM.L	D4/D5/A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVEA.L	$000E(A5),A3

	MOVE.W	(A2),d1
	MOVE.W	$0002(A2),d0
	JSR	_moatquick

	MOVE.L	D0,D4
;	TST.L	D0
	BNE.B	L00935
	MOVEQ	#$00,D0
L00934:
	MOVEM.L	(A7)+,D4/D5/A2/A3
	UNLK	A5
	RTS

L00935:
	CLR.W	-$60A0(A4)	;_quiet
	CLR.W	_count-BASE(A4)	;_count

	MOVE.L	A2,-(A7)
	JSR	_start_run	;attacked monster wakes up and will run to you
	ADDQ.W	#4,A7

	MOVEA.L	D4,A6
	MOVE.B	$000F(A6),D3
	CMP.B	#$58,D3		;'X' xeroc
	BNE.B	L00937

	MOVE.B	$0010(A6),D3
	CMP.B	#$58,D3		;'X' xeroc
	BEQ.B	L00937

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BNE.B	L00937

	MOVE.B	#$58,$0010(A6)	;'X' xeroc
	MOVE.B	#$58,$000D(A5)	;'X' xeroc
	TST.B	$0013(A5)
	BEQ.B	L00936

	MOVEQ	#$00,D0
	BRA.B	L00934
L00936:
	PEA	L00944(PC)	;"wait! That's a Xeroc!"
	JSR	_msg
	ADDQ.W	#4,A7
L00937:
	MOVE.B	$000D(A5),D3
	EXT.W	D3
	SUB.W	#$0041,D3	;'A'
	MULU.W	#26,D3
	LEA	_monsters-BASE(A4),A6	;_monsters
	MOVE.L	$00(A6,D3.L),D5

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BEQ.B	L00938

	MOVE.L	-$69BE(A4),D5	;_it
L00938:
	MOVEQ	#$00,D3
	MOVE.B	$0013(A5),D3
	MOVE.W	D3,-(A7)
	MOVE.L	A3,-(A7)
	MOVE.L	D4,-(A7)
	PEA	_player-BASE(A4)	;_player + 0
	JSR	_roll_em(PC)
	LEA	$000E(A7),A7
	TST.W	D0		;did we hit?
	BNE.B	L00939

	MOVE.L	A3,D3
	BEQ.W	L00940

	CMPI.W	#$0021,$000A(A3)	;'!' potion
	BNE.W	L00940
L00939:
	CLR.B	-$0001(A5)
	TST.B	$0013(A5)
	BEQ.B	L0093A

	PEA	L00946(PC)	;"hit"
	PEA	L00945(PC)	;"hits"
	MOVE.L	D5,-(A7)
	MOVE.L	A3,-(A7)
	JSR	_thunk(PC)
	LEA	$0010(A7),A7
	BRA.B	L0093B
L0093A:
	MOVE.L	D5,-(A7)
	CLR.L	-(A7)
	JSR	_hit(PC)
	ADDQ.W	#8,A7
L0093B:
	CMPI.W	#$0021,$000A(A3)	;'!' potions
	BNE.B	L0093C

	MOVE.L	D4,-(A7)
	MOVE.L	A3,-(A7)
	JSR	_th_effect(PC)
	ADDQ.W	#8,A7
	TST.B	$0013(A5)
	BNE.B	L0093C

	MOVE.W	#$0001,-(A7)
	MOVE.L	A3,-(A7)
	JSR	_unpack
	ADDQ.W	#6,A7

	MOVE.L	D0,-(A7)
	JSR	_discard
	ADDQ.W	#4,A7
	CLR.L	_cur_weapon-BASE(A4)	;_cur_weapon
L0093C:
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_CANHUH,D3	;C_CANHUH
	BEQ.B	L0093D

	MOVE.B	#$01,-$0001(A5)
	MOVEA.L	D4,A6
	ORI.W	#C_ISHUH,$0016(A6)	;C_ISHUH
	ANDI.W	#~C_CANHUH,-$52B4(A4)	;clear C_CANHUH,_player + 22 (flags)
	PEA	L00947(PC)	;"your hands stop glowing red"
	JSR	_msg
	ADDQ.W	#4,A7
L0093D:
	MOVEA.L	D4,A6
	CMPI.W	#$0000,$0022(A6)	;more than 0 hp left?
	BGT.B	L0093E

	MOVE.W	#$0001,-(A7)
	MOVE.L	D4,-(A7)
	JSR	_killed(PC)
	ADDQ.W	#6,A7
	BRA.B	L0093F
L0093E:
	TST.B	-$0001(A5)
	BEQ.B	L0093F

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BNE.B	L0093F
	MOVE.L	D5,-(A7)
	PEA	L00948(PC)	;"the %s appears confused"
	JSR	_msg
	ADDQ.W	#8,A7
L0093F:
	MOVEQ	#$01,D0
	BRA.W	L00934
L00940:
	TST.B	$0013(A5)
	BEQ.B	L00941

	PEA	L0094A(PC)	;"missed"
	PEA	L00949(PC)	;"misses"
	MOVE.L	D5,-(A7)
	MOVE.L	A3,-(A7)
	JSR	_thunk(PC)
	LEA	$0010(A7),A7
	BRA.B	L00942
L00941:
	MOVE.L	D5,-(A7)
	CLR.L	-(A7)
	JSR	_miss(PC)
	ADDQ.W	#8,A7
L00942:
	MOVEA.L	D4,A6
	cmp.b	#$53,$000F(A6)	;'S' slime
	BNE.B	L00943

	MOVEq	#100,D0
	JSR	_rnd
	CMP.W	#25,D0		;25% chance that the slime splits
	BLE.B	L00943

	MOVE.L	D4,-(A7)
	JSR	_slime_split
	ADDQ.W	#4,A7
L00943:
	MOVEQ	#$00,D0
	BRA.W	L00934

L00944:	dc.b	"wait! That's a Xeroc!",0
L00945:	dc.b	"hits",0
L00946:	dc.b	"hit",0
L00947:	dc.b	"your hands stop glowing red",0
L00948:	dc.b	"the %s appears confused",0
L00949:	dc.b	"misses",0
L0094A:	dc.b	"missed",0,0

;/*
; * attack:
; *  The monster attacks the player
; */

_attack:
	LINK	A5,#-$0004
	MOVEM.L	D4/D5/A2/A3,-(A7)

	CLR.B	_running-BASE(A4)	;_running
	CLR.W	-$60A0(A4)	;_quiet
	CLR.W	_count-BASE(A4)	;_count

	MOVEA.L	$0008(A5),A6
	CMP.B	#$58,$000F(A6)	;'X' xerox
	BNE.B	1$

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BNE.B	1$

	MOVE.B	#$58,$0010(A6)	;'X' xerox

1$	MOVE.B	$000F(A6),D3
	EXT.W	D3
	SUB.W	#$0041,D3	;'A'
	MULU.W	#26,D3
	LEA	_monsters-BASE(A4),A6	;_monsters
	MOVEA.L	$00(A6,D3.L),A2
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BEQ.B	L0094C
	MOVEA.L	-$69BE(A4),A2	;_it
L0094C:
	CLR.L	-(A7)
	CLR.L	-(A7)
	PEA	_player-BASE(A4)	;_player + 0
	MOVE.L	$0008(A5),-(A7)
	JSR	_roll_em(PC)
	LEA	$0010(A7),A7
	TST.W	D0
	BEQ.W	L00974

	CLR.L	-(A7)
	MOVE.L	A2,-(A7)
	JSR	_hit(PC)
	ADDQ.W	#8,A7
	CMPI.W	#$0000,-$52A8(A4)	;_player + 34 (hp)
	BGT.B	L0094D

	MOVEA.L	$0008(A5),A6
	MOVE.B	$000F(A6),D3
;	EXT.W	D3
	MOVE.W	D3,-(A7)
	JSR	_death
	ADDQ.W	#2,A7
L0094D:
	MOVEA.L	$0008(A5),A6
	MOVE.W	$0016(A6),D3
	AND.W	#C_ISCANC,D3	;C_ISCANC
	BNE.W	L00973

;	MOVEA.L	$0008(A5),A6
	MOVE.B	$000F(A6),D0
	EXT.W	D0
;	EXT.L	D0
	BRA.W	L00972

; aquator

L0094E:
	TST.L	_cur_armor-BASE(A4)	;_cur_armor
	BEQ.B	L00952

	MOVEA.L	_cur_armor-BASE(A4),A6	;_cur_armor
	CMPI.W	#$0009,$0026(A6)	;dont go lower than 2 (11-9)
	BGE.B	L00952

	CMP.W	#A_LEATHER,$0020(A6)
	BEQ.B	L00952

	TST.L	_cur_ring_1-BASE(A4)	;_cur_ring_1
	BEQ.B	L0094F

	MOVEA.L	_cur_ring_1-BASE(A4),A6	;_cur_ring_1
	CMPI.W	#R_SUSTARM,$0020(A6)
	BEQ.B	L00950
L0094F:
	TST.L	_cur_ring_2-BASE(A4)	;_cur_ring_2
	BEQ.B	L00951

	MOVEA.L	_cur_ring_2-BASE(A4),A6	;_cur_ring_2
	CMPI.W	#R_SUSTARM,$0020(A6)
	BNE.B	L00951
L00950:
	PEA	L00977(PC)	;"the rust vanishes instantly"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L00952
L00951:
	PEA	L00978(PC)	;"your armor weakens, oh my!"
	JSR	_msg
	ADDQ.W	#4,A7
	MOVEA.L	_cur_armor-BASE(A4),A6	;_cur_armor
	ADDQ.W	#1,$0026(A6)	;lower is better
	MOVE.W	#$0001,-(A7)
	MOVE.L	_cur_armor-BASE(A4),-(A7)	;_cur_armor
	JSR	_pack_name
	ADDQ.W	#6,A7
L00952:
	BRA.W	L00973

; ice monster

L00953:
	CMPI.W	#$0001,_no_command-BASE(A4)	;_no_command
	BLE.B	L00954

	SUBQ.W	#1,_no_command-BASE(A4)	;_no_command
L00954:
	BRA.W	L00973

; rattlesnake

L00955:
	CLR.W	-(A7)
	JSR	_save(PC)
	ADDQ.W	#2,A7
	TST.W	D0
	BNE.B	L00959

	TST.L	_cur_ring_1-BASE(A4)	;_cur_ring_1
	BEQ.B	L00956

	MOVEA.L	_cur_ring_1-BASE(A4),A6	;_cur_ring_1
	CMPI.W	#R_SUSTSTR,$0020(A6)
	BEQ.B	L00958
L00956:
	TST.L	_cur_ring_2-BASE(A4)	;_cur_ring_2
	BEQ.B	L00957

	MOVEA.L	_cur_ring_2-BASE(A4),A6	;_cur_ring_2
	CMPI.W	#R_SUSTSTR,$0020(A6)
	BEQ.B	L00958
L00957:
	MOVE.W	#$FFFF,-(A7)
	JSR	_chg_str
	ADDQ.W	#2,A7

	LEA	L0097A(PC),a0	;" and now feel weaker"
	JSR	_noterse

	MOVE.L	D0,-(A7)
	PEA	L00979(PC)	;"you feel a bite in your leg%s"
	JSR	_msg
	ADDQ.W	#8,A7

	BRA.B	L00959
L00958:
	PEA	L0097B(PC)	;"a bite momentarily weakens you"
	JSR	_msg
	ADDQ.W	#4,A7
L00959:
	BRA.W	L00973

; vampire/wraith

L0095A:
	MOVEq	#100,D0
	JSR	_rnd
	MOVEA.L	$0008(A5),A6
	MOVE.B	$000F(A6),D3
;	EXT.W	D3
	CMP.b	#$57,D3		;'W' wraith
	BNE.B	L0095B

	MOVEQ	#15,D3		;15% chance
	BRA.B	L0095C
L0095B:
	MOVEQ	#30,D3		;vampire has %30 chance
L0095C:
	CMP.W	D3,D0
	BGE.W	L00964

	MOVEA.L	$0008(A5),A6
	MOVE.B	$000F(A6),D3
;	EXT.W	D3
	CMP.b	#$57,D3		;'W' wraith
	BNE.B	L00960

; wraith drains experience/level

	TST.L	-$52B0(A4)	;_player + 26 (EXP)
	BNE.B	L0095D

	MOVE.W	#$0057,-(A7)	;'W' killed by a wraith
	JSR	_death
	ADDQ.W	#2,A7
L0095D:
	SUBQ.W	#1,-$52AC(A4)	;_player + 30 (rank)
;	TST.W	-$52AC(A4)	;_player + 30 (rank)
	BNE.B	L0095E

	CLR.L	-$52B0(A4)	;_player + 26 (EXP)
	MOVE.W	#$0001,-$52AC(A4)	;_player + 30 (rank)
	BRA.B	L0095F
L0095E:
	MOVE.W	-$52AC(A4),D3	;_player + 30 (rank)
	SUBQ.W	#1,D3
;	EXT.L	D3
	ASL.w	#2,D3
	MOVEA.L	_e_levels-BASE(A4),A6	;_e_levels
	MOVE.L	$00(A6,D3.w),D2
	ADDQ.L	#1,D2
	MOVE.L	D2,-$52B0(A4)	;_player + 26 (EXP)
L0095F:
	MOVE.W	#$000A,-(A7)	;1d10
	MOVE.W	#$0001,-(A7)
	JSR	_roll
	ADDQ.W	#4,A7
	MOVE.W	D0,D4
	BRA.B	L00961

; vampire drains life

L00960:
	MOVE.W	#$0005,-(A7)	;1d5
	MOVE.W	#$0001,-(A7)
	JSR	_roll
	ADDQ.W	#4,A7
	MOVE.W	D0,D4
L00961:
	SUB.W	D4,-$52A8(A4)	;_player + 34 (hp)
	SUB.W	D4,-$52A2(A4)	;_player + 40 (max hp)
	CMPI.W	#$0001,-$52A8(A4)	;_player + 34 (hp)
	BGE.B	L00962

	MOVE.W	#$0001,-$52A8(A4)	;_player + 34 (hp)
L00962:
	CMPI.W	#$0001,-$52A2(A4)	;_player + 40 (max hp)
	BGE.B	L00963

	MOVEA.L	$0008(A5),A6
	MOVE.B	$000F(A6),D3
;	EXT.W	D3
	MOVE.W	D3,-(A7)
	JSR	_death
	ADDQ.W	#2,A7
L00963:
	PEA	L0097C(PC)	;"you suddenly feel weaker"
	JSR	_msg
	ADDQ.W	#4,A7
L00964:
	BRA.W	L00973

; venus flytrap

L00965:
	ORI.W	#C_ISHELD,-$52B4(A4)	;C_ISHELD,_player + 22 (flags)
	ADDQ.W	#1,-$60A2(A4)	;_fung_hit
	MOVE.W	-$60A2(A4),-(A7)	;_fung_hit
	PEA	L0097D(PC)	;"%dd1"
	MOVEA.L	$0008(A5),A6
	MOVE.L	$0024(A6),-(A7)
	JSR	_sprintf
	LEA	$000A(A7),A7
	BRA.W	L00973

; leprechaun

L00966:
	move.w	_purse-BASE(A4),D4	;_purse

	bsr	goldcalc
	sub.w	D0,D4

	MOVE.W	#VS_MAGIC,-(A7)
	JSR	_save(PC)
	ADDQ.W	#2,A7
	TST.W	D0
	BNE.B	L00967

	bsr	goldcalc
	sub.w	D0,D4
	bsr	goldcalc
	sub.w	D0,D4
	bsr	goldcalc
	sub.w	D0,D4
	bsr	goldcalc
	sub.w	D0,D4

L00967:
;	tst.W	_purse-BASE(A4)	;_purse
;	BGE.B	L00968
;	CLR.W	_purse-BASE(A4)	;_purse

	tst.w	D4
	bge	L00968
	clr.l	D4

L00968:
	CLR.L	-(A7)
	MOVE.L	$0008(A5),-(A7)
	MOVEA.L	$0008(A5),A6
	PEA	$000A(A6)
	JSR	_remove(PC)	;removes monster from screen
	LEA	$000C(A7),A7

	MOVE.W	_purse-BASE(A4),D3	;_purse
	CMP.w	D3,D4
	BEQ.B	L00969

	move.w	D4,_purse-BASE(A4)
	PEA	L0097E(PC)	;"your purse feels lighter"
	JSR	_msg
	ADDQ.W	#4,A7
L00969:
	BRA.W	L00973

; nymph

L0096A:
	LEA	L0097F(PC),A6	;"she stole %s!"
	MOVE.L	A6,-$0004(A5)
	MOVEQ	#$00,D4
	MOVEQ	#$00,D5
	MOVEA.L	-$529C(A4),A3	;_player + 46 (pack)
	BRA.B	L0096D
L0096B:
	CMPA.L	_cur_armor-BASE(A4),A3	;_cur_armor
	BEQ.B	L0096C
	CMPA.L	_cur_weapon-BASE(A4),A3	;_cur_weapon
	BEQ.B	L0096C
	CMPA.L	_cur_ring_1-BASE(A4),A3	;_cur_ring_1
	BEQ.B	L0096C
	CMPA.L	_cur_ring_2-BASE(A4),A3	;_cur_ring_2
	BEQ.B	L0096C

	MOVE.L	A3,-(A7)
	JSR	_is_magic(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L0096C

	ADDQ.W	#1,D5
	MOVE.W	D5,D0
	JSR	_rnd
	TST.W	D0
	BNE.B	L0096C

	MOVE.L	A3,D4
L0096C:
	MOVEA.L	(A3),A3
L0096D:
	MOVE.L	A3,D3
	BNE.B	L0096B
	TST.L	D4
	BEQ.W	L00970

	CLR.L	-(A7)
	MOVE.L	$0008(A5),-(A7)
	MOVEA.L	$0008(A5),A6
	PEA	$000A(A6)
	JSR	_remove(PC)
	LEA	$000C(A7),A7
	MOVEA.L	D4,A6
	CMPI.W	#$0001,$001E(A6)
	BLE.B	L0096F

	MOVEA.L	D4,A6
	TST.W	$002C(A6)
	BNE.B	L0096F

	MOVE.W	#$0001,-(A7)
	MOVE.L	D4,-(A7)
	JSR	_unpack
	ADDQ.W	#6,A7
	MOVE.L	D0,D4
;	TST.L	D0
	BEQ.B	L0096E

	MOVE.W	#$001E,-(A7)
	MOVE.L	D4,-(A7)
	JSR	_nameof
	ADDQ.W	#6,A7
	MOVE.L	D0,-(A7)
	MOVE.L	-$0004(A5),-(A7)
	JSR	_msg
	ADDQ.W	#8,A7
	MOVE.L	D4,-(A7)
	JSR	_discard
	ADDQ.W	#4,A7
L0096E:
	BRA.B	L00970
L0096F:
	CLR.L	-(A7)
	MOVE.L	D4,-(A7)
	JSR	_unpack
	ADDQ.W	#8,A7
	MOVE.W	#$001E,-(A7)
	MOVE.L	D4,-(A7)
	JSR	_nameof
	ADDQ.W	#6,A7
	MOVE.L	D0,-(A7)
	MOVE.L	-$0004(A5),-(A7)
	JSR	_msg
	ADDQ.W	#8,A7
	MOVE.L	D4,-(A7)
	JSR	_discard
	ADDQ.W	#4,A7
L00970:
	BRA.B	L00973
L00972:
	SUB.w	#$0041,D0	;'A' aquator, rusts armor
	BEQ.W	L0094E
	SUBQ.w	#5,D0		;'F' venus flytrap, traps the player
	BEQ.W	L00965
	SUBQ.w	#3,D0		;'I' ice monster, shoots frost bolts
	BEQ.W	L00953
	SUBQ.w	#3,D0		;'L' leprechaun, steals money
	BEQ.W	L00966
	SUBQ.w	#2,D0		;'N' nymph, steals an item not used
	BEQ.W	L0096A
	SUBQ.w	#4,D0		;'R' rattlesnake, weakens the player
	BEQ.W	L00955
	SUBQ.w	#4,D0		;'V' vampire, drains life
	BEQ.W	L0095A
	SUBQ.w	#1,D0		;'W' wraith, drains experience
	BEQ.W	L0095A
L00973:
	BRA.B	L00976
L00974:
	MOVEA.L	$0008(A5),A6
	MOVE.B	$000F(A6),D3

	CMP.B	#$49,D3		;'I' ice monster
	BEQ.B	L00976

	CMP.B	#$46,D3		;'F' venus flytrap
	BNE.B	L00975

	MOVE.W	-$60A2(A4),D3	;_fung_hit
	SUB.W	D3,-$52A8(A4)	;_player + 34 (hp)
	CMPI.W	#$0000,-$52A8(A4)	;_player + 34 (hp)
	BGT.B	L00975

;	MOVEA.L	$0008(A5),A6
	MOVE.B	$000F(A6),D3
;	EXT.W	D3
	MOVE.W	D3,-(A7)
	JSR	_death
	ADDQ.W	#2,A7
L00975:
	CLR.L	-(A7)
	MOVE.L	A2,-(A7)
	JSR	_miss(PC)
	ADDQ.W	#8,A7
L00976:
	JSR	_flush_type
	CLR.W	_count-BASE(A4)	;_count
	JSR	_status

	MOVEM.L	(A7)+,D4/D5/A2/A3
	UNLK	A5
	RTS

L00977:	dc.b	"the rust vanishes instantly",0
L00978:	dc.b	"your armor weakens, oh my!",0
L00979:	dc.b	"you feel a bite in your leg%s",0
L0097A:	dc.b	" and now feel weaker",0
L0097B:	dc.b	"a bite momentarily weakens you",0
L0097C:	dc.b	"you suddenly feel weaker",0
L0097D:	dc.b	"%dd1",0
L0097E:	dc.b	"your purse feels lighter",0
L0097F:	dc.b	"she stole %s!",0

;/*
; * swing:
; *  Returns true if the swing hits
; */

_swing:
	MOVEq	#20,D0
	JSR	_rnd

	MOVEQ	#20,D3
	SUB.W	$0004(A7),D3	;creature/player rank
	SUB.W	$0006(A7),D3	;armor
	ADD.W	$0008(A7),D0	;hplus
	CMP.W	D3,D0
	BLT.B	1$

	MOVEq	#$0001,D0
	BRA.B	2$

1$	CLR.W	D0		;zero means swing did miss

2$	RTS

;/*
; * roll_em:
; *  Roll several attacks
; */

_roll_em:
	LINK	A5,#-$000C
	MOVEM.L	D4-D7/A2/A3,-(A7)

	MOVEQ	#$00,D4
	MOVEA.L	$0008(A5),A2	;player
	ADDA.L	#$00000018,A2
	MOVEA.L	$000C(A5),A3	;monster
	ADDA.L	#$00000018,A3

	TST.L	$0010(A5)	;test for weapon
	BNE.B	1$

	MOVE.L	$000C(A2),-$0004(A5)
	MOVEQ	#$00,D6
	MOVEQ	#$00,D5
	BRA.W	L00994

1$	MOVEA.L	$0010(A5),A6
	MOVE.W	$0022(A6),D5	;hplus from weapon
	MOVE.W	$0024(A6),D6	;dplus from weapon

	MOVEA.L	$000C(A5),A6
	MOVE.B	$000F(A6),D3	;monster ID

	MOVEA.L	$0010(A5),A6
	MOVE.B	$002A(A6),D2
	CMP.B	D2,D3		;do we have a vorpalized monster slayer?
	BNE.B	L0098E

	MOVE.W	$0028(A6),D3
	AND.W	#O_SLAYERUSED,D3	;first time? then 100% chance
	BEQ.B	L00989

	MOVEq	#100,D0		;1% chance the monster slayer works
	JSR	_rnd
	CMP.W	#23,D0
	BNE.B	L0098D
L00989:
	MOVEA.L	$0010(A5),A6
	ORI.W	#O_SLAYERUSED,$0028(A6)	;mark as used

	TST.B	_terse-BASE(A4)	;_terse
	BNE.B	L0098A
	TST.B	_expert-BASE(A4)	;_expert
	BEQ.B	L0098B
L0098A:
	LEA	L0099F(PC),A6	; $0
	MOVE.L	A6,D3
	BRA.B	L0098C
L0098B:
	MOVE.L	-$69C6(A4),D3	;_intense
L0098C:
	MOVE.L	D3,-(A7)
	MOVEA.L	$0010(A5),A6
	MOVE.W	$0020(A6),D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	_w_names-BASE(A4),A6	;_w_names
	MOVE.L	$00(A6,D3.w),-(A7)
	MOVE.L	_flash-BASE(A4),-(A7)	;_flash
	JSR	_msg
	LEA	$000C(A7),A7

	ADD.W	#20,D5		;+20 hit
	ADD.W	#100,D6		;+100 damage
	BRA.B	L0098E
L0098D:
	ADDQ.W	#4,D5		;+4 hit
	ADDQ.W	#4,D6		;+4 damage
L0098E:
	MOVEA.L	$0010(A5),A6
	CMPA.L	_cur_weapon-BASE(A4),A6	;is the used weapon the _cur_weapon?
	BNE.B	L00992

	MOVE.L	_cur_ring_1-BASE(A4),D0	;get _cur_ring_1
	BEQ.B	L00990

	MOVEA.L	D0,A6		;get _cur_ring_1
	CMPI.W	#R_ADDDAM,$0020(A6)
	BNE.B	L0098F

	ADD.W	$0026(A6),D6	;add damage from ring
	BRA.B	L00990
L0098F:
	CMPI.W	#R_ADDHIT,$0020(A6)
	BNE.B	L00990

	ADD.W	$0026(A6),D5	;add hit from ring

L00990:
	MOVE.L	_cur_ring_2-BASE(A4),D0	;get _cur_ring_2
	BEQ.B	L00992

	MOVEA.L	D0,A6		;get _cur_ring_2
	CMPI.W	#R_ADDDAM,$0020(A6)
	BNE.B	L00991

	ADD.W	$0026(A6),D6	;add damage from ring
	BRA.B	L00992
L00991:
	CMPI.W	#R_ADDHIT,$0020(A6)
	BNE.B	L00992

	ADD.W	$0026(A6),D5	;add hit from ring
L00992:
	MOVEA.L	$0010(A5),A6
	MOVE.L	$0016(A6),-$0004(A5)	;get wield damage
	TST.B	$0015(A5)
	BEQ.B	L00993

;	MOVEA.L	$0010(A5),A6
	MOVE.W	$0028(A6),D3
	AND.W	#O_ISMISL,D3	;O_ISMISL
	BEQ.B	L00993

	TST.L	_cur_weapon-BASE(A4)	;check _cur_weapon
	BEQ.B	L00993

;	MOVEA.L	$0010(A5),A6
	MOVE.B	$0014(A6),D3	;get baseweapon
	EXT.W	D3

	MOVEA.L	_cur_weapon-BASE(A4),A6	;_cur_weapon
	CMP.W	$0020(A6),D3	;is it the corrct baseweapon?
	BNE.B	L00993

	MOVEA.L	$0010(A5),A6
	MOVE.L	$001A(A6),-$0004(A5)	;get throw damage

	MOVEA.L	_cur_weapon-BASE(A4),A6	;_cur_weapon
	ADD.W	$0022(A6),D5	;hplus
	ADD.W	$0024(A6),D6	;dplus
L00993:
	MOVEA.L	$0010(A5),A6
	CMPI.W	#$002F,$000A(A6)	;'/' wand
	BNE.B	L00994

	CMPI.W	#WS_STRIKING,$0020(A6)
	BNE.B	L00994

	SUBQ.W	#1,$0026(A6)		;consume one charge
;	CMPI.W	#$0000,$0026(A6)
	BGE.B	L00994

	MOVE.L	_no_damage-BASE(A4),$0016(A6)	;_no_damage
	MOVE.L	$0016(A6),-$0004(A5)

	CLR.W	$0024(A6)	;0 hit
	CLR.W	$0022(A6)	;0 damage

	CLR.W	$0026(A6)
L00994:
	MOVEA.L	$000C(A5),A6
	MOVE.W	$0016(A6),D3
	AND.W	#C_ISRUN,D3	;C_ISRUN
	BNE.B	L00995
	ADDQ.W	#4,D5		;hplus += 4
L00995:
	MOVE.W	$0008(A3),-$000A(A5)
	LEA	-$52B2(A4),A6	;_player + 24 (strength)
	CMPA.L	A6,A3
	BNE.B	L00998

	TST.L	_cur_armor-BASE(A4)	;_cur_armor
	BEQ.B	L00996

	MOVEA.L	_cur_armor-BASE(A4),A6	;_cur_armor
	MOVE.W	$0026(A6),-$000A(A5)
L00996:
	MOVE.L	_cur_ring_1-BASE(A4),D0	;_cur_ring_1
	BEQ.B	L00997

	MOVEA.L	D0,A6		;_cur_ring_1
	CMP.W	#R_PROTECT,$0020(A6)	;test for R_PROTECT
	BNE.B	L00997

	MOVE.W	$0026(A6),D3
	SUB.W	D3,-$000A(A5)	;add extra armor from ring 1
L00997:
	MOVE.L	_cur_ring_2-BASE(A4),D0	;_cur_ring_2
	BEQ.B	L00998

	MOVEA.L	D0,A6		;_cur_ring_2
	CMP.W	#R_PROTECT,$0020(A6)	;test for R_PROTECT
	BNE.B	L00998

	MOVE.W	$0026(A6),D3	;add extra armor from ring 2
	SUB.W	D3,-$000A(A5)
L00998:
	MOVE.L	-$0004(A5),-(A7)
	JSR	_atoi(PC)
	ADDQ.W	#4,A7

	MOVE.W	D0,-$0006(A5)	;ndice

	MOVE.W	#100,-(A7)
	MOVE.L	-$0004(A5),-(A7)
	JSR	_index
	ADDQ.W	#6,A7

	MOVE.L	D0,-$0004(A5)	;cp
;	TST.L	D0
	BEQ.W	L0099E

	ADDQ.L	#1,-$0004(A5)	;cp
	MOVE.L	-$0004(A5),-(A7)
	JSR	_atoi(PC)
	ADDQ.W	#4,A7

	MOVE.W	D0,-$0008(A5)	;nsides

	MOVE.W	(A2),-(A7)
	JSR	_str_plus(PC)
	ADDQ.W	#2,A7

	ADD.W	D5,D0			;hplus += str_hit
	MOVE.W	D0,-(A7)
	MOVE.W	-$000A(A5),-(A7)	;AC
	MOVE.W	$0006(A2),-(A7)		;rank
	JSR	_swing(PC)
	ADDQ.W	#6,A7
	TST.W	D0
	BEQ.B	L0099D

	MOVE.W	-$0008(A5),-(A7)
	MOVE.W	-$0006(A5),-(A7)
	JSR	_roll
	ADDQ.W	#4,A7

	MOVE.W	D0,-$000C(A5)		;get damage from strength
	MOVE.W	(A2),-(A7)
	JSR	_add_dam(PC)
	ADDQ.W	#2,A7

	MOVEM.L	D0/D4-D6/A0-A3,-(A7)	;DEBUG here
	move.w	$000A(A3),-(a7)
	moveq	#11,d1
	sub.w	-$000A(A5),d1
	move.w	d1,-(a7)		;def_arm
	move.w	d0,-(a7)		;add_dam
	move.w	d6,-(a7)		;dplus
	move.w	-$000c(A5),-(a7)	;proll
	move.w	-$0008(A5),-(a7)	;nsides
	move.w	-$0006(A5),-(a7)	;ndice
	pea	debugtext
	jsr	_db_print
	LEA	$0012(A7),A7
	MOVEM.L	(A7)+,D0/D4-D6/A0-A3

	ADD.W	D6,D0
	MOVE.W	D0,D7
	ADD.W	-$000C(A5),D7
	LEA	_player-BASE(A4),A6	;_player + 0
	CMPA.L	$000C(A5),A6	;same as creature who is fighting here?
	BNE.B	L00999

	CMPI.W	#$0001,_max_level-BASE(A4)	;_max_level
	BNE.B	L00999

	ADDQ.W	#1,D7		;divide damage by half, if level == 1
	EXT.L	D7
	DIVS.W	#$0002,D7
L00999:
	MOVEQ	#$00,D3
	CMP.W	D7,D3
	BLE.B	L0099B

;	MOVEQ	#$00,D3
	BRA.B	L0099C
L0099B:
	SUB.W	D7,$000A(A3)
L0099C:
	MOVEQ	#$01,D4		;did_hit = TRUE

L0099D:
	MOVE.W	#$002F,-(A7)	;'/'	;get next attack from creature/player
	MOVE.L	-$0004(A5),-(A7)
	JSR	_index
	ADDQ.W	#6,A7

	MOVE.L	D0,-$0004(A5)	;test cp for NULL
;	TST.L	D0
	BEQ.B	L0099E

	ADDQ.L	#1,-$0004(A5)	;cp++
	BRA.W	L00998
L0099E:
;	MOVEQ	#$00,D0
	MOVE.L	D4,D0		;return did_hit
	MOVEM.L	(A7)+,D4-D7/A2/A3
	UNLK	A5
	RTS

L0099F:
	dc.w	$0000

debugtext:	dc.b	"Damage for %dd%d came out %2d, dplus = %d, add_dam = %d, def_arm = %d, def_hp = %2d",10,0,0

;/*
; * prname:
; *  The print name of a combatant
; */

_prname:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVEA.L	_tbuf-BASE(A4),A6	;_tbuf
	CLR.B	(A6)
	MOVE.L	A2,D3
	BNE.B	L009A0

	MOVE.L	-$69BA(A4),-(A7)	;_you
	MOVE.L	_tbuf-BASE(A4),-(A7)	;_tbuf
	JSR	_strcpy
	ADDQ.W	#8,A7
	BRA.B	L009A2
L009A0:
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BEQ.B	L009A1

	MOVE.L	-$69BE(A4),-(A7)	;_it
	MOVE.L	_tbuf-BASE(A4),-(A7)	;_tbuf
	JSR	_strcpy
	ADDQ.W	#8,A7
	BRA.B	L009A2
L009A1:
	PEA	L009A4(PC)
	MOVE.L	_tbuf-BASE(A4),-(A7)	;_tbuf
	JSR	_strcpy
	ADDQ.W	#8,A7
	MOVE.L	A2,-(A7)
	MOVE.L	_tbuf-BASE(A4),-(A7)	;_tbuf
	JSR	_strcat
	ADDQ.W	#8,A7
L009A2:
	TST.B	$000D(A5)
	BEQ.B	L009A3

	MOVEA.L	_tbuf-BASE(A4),A6	;_tbuf
	MOVE.L	A6,-(A7)
	MOVE.B	(A6),D3
	MOVE.W	D3,-(A7)
	JSR	_toupper
	ADDQ.W	#2,A7
	MOVEA.L	(A7)+,A6
	MOVE.B	D0,(A6)
L009A3:
	MOVE.L	_tbuf-BASE(A4),D0	;_tbuf

	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L009A4:	dc.b	"the ",0,0

;/*
; * thunk:
; *  A missile hits a monster
; */

_thunk:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5/A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2	;missile
	MOVEA.L	$000C(A5),A3	;monster name
	MOVE.L	$0010(A5),D4	;words like 'hit'
	MOVE.L	$0014(A5),D5

	MOVE.L	A2,-(A7)
	JSR	_typeof
	ADDQ.W	#4,A7

	CMP.W	#$006D,D0	;'m' weapon type
	BNE.B	L009E9

	MOVE.L	D4,-(A7)
	MOVE.W	$0020(A2),D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	_w_names-BASE(A4),A6	;_w_names
	MOVE.L	$00(A6,D3.w),-(A7)
	PEA	L009ED(PC)	;"the %s %s "
	JSR	_addmsg
	LEA	$000C(A7),A7
	BRA.B	L009EA
L009E9:
	MOVE.L	D5,-(A7)
	PEA	L009EE(PC)	;"you %s "
	JSR	_addmsg
	ADDQ.W	#8,A7
L009EA:
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BEQ.B	L009EB

	MOVE.L	-$69BE(A4),-(A7)	;_it
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L009EC
L009EB:
	MOVE.L	A3,-(A7)
	PEA	L009EF(PC)	;"the %s"
	JSR	_msg
	ADDQ.W	#8,A7
L009EC:
	MOVEM.L	(A7)+,D4/D5/A2/A3
	UNLK	A5
	RTS

L009ED:	dc.b	"the %s %s ",0
L009EE:	dc.b	"you %s ",0
L009EF:	dc.b	"the %s",0

;/*
; * hit:
; *  Print a message to indicate a succesful hit
; */

_hit:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVEA.L	$000C(A5),A3

	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_prname(PC)
	ADDQ.W	#6,A7

	MOVE.L	D0,-(A7)
	JSR	_addmsg
	ADDQ.W	#4,A7

	TST.B	_terse-BASE(A4)	;_terse
	BNE.B	L009A5

	TST.B	_expert-BASE(A4)	;_expert
	BEQ.B	L009A6
L009A5:
	MOVEQ	#$01,D0
	BRA.B	L009A7
L009A6:
	MOVEq	#$0004,D0
	JSR	_rnd
L009A7:
	MOVE.L	A2,D3
	BEQ.B	L009B3

	addq.w	#4,d0
L009B3:
	ASL.w	#2,D0
	MOVE.L	L009B0(PC,D0.W),D4

	CLR.L	-(A7)
	MOVE.L	A3,-(A7)
	JSR	_prname(PC)
	ADDQ.W	#8,A7

	MOVE.L	D0,-(A7)
	MOVE.L	D4,-(A7)
	PEA	L009BA(PC)	;"%s %s "
	JSR	_msg
	LEA	$000C(A7),A7

	MOVEM.L	(A7)+,D4/A2/A3
	UNLK	A5
	RTS

L009B0:
	dc.l	L009B4	;"scored an excellent hit on"
	dc.l	L009B5	;"hit"
	dc.l	L009B6	;"have injured"
	dc.l	L009B8	;"swing and hit"

	dc.l	L009B4	;"scored an excellent hit on"
	dc.l	L009B5	;"hit"
	dc.l	L009B7	;"has injured"
	dc.l	L009B9	;"swings and hits"

L009B4:	dc.b	"scored an excellent hit on",0
L009B5:	dc.b	"hit",0
L009B6:	dc.b	"have injured",0
L009B7:	dc.b	"has injured",0
L009B8:	dc.b	"swing and hit",0
L009B9:	dc.b	"swings and hits",0
L009BA:	dc.b	" %s %s",0,0

;/*
; * miss:
; *  Print a message to indicate a poor swing
; */

_miss:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVEA.L	$000C(A5),A3
	MOVE.W	#$0001,-(A7)

	MOVE.L	A2,-(A7)
	JSR	_prname(PC)
	ADDQ.W	#6,A7

	MOVE.L	D0,-(A7)
	JSR	_addmsg
	ADDQ.W	#4,A7

	TST.B	_terse-BASE(A4)	;_terse
	BNE.B	L009BB

	TST.B	_expert-BASE(A4)	;_expert
	BEQ.B	L009BC
L009BB:
	MOVEQ	#$01,D0
	BRA.B	L009BD
L009BC:
	MOVEq	#$0004,D0
	JSR	_rnd
L009BD:
	MOVE.L	A2,D3
	BEQ.B	L009CD

	addq.w	#4,d0
L009CD:
	ASL.w	#2,D0
	MOVE.L	L009CA(PC,D0.W),D4

	CLR.L	-(A7)
	MOVE.L	A3,-(A7)
	JSR	_prname(PC)
	ADDQ.W	#8,A7

	MOVE.L	D0,-(A7)
	MOVE.L	D4,-(A7)
	PEA	L009D6(PC)	;" %s %s"
	JSR	_msg
	LEA	$000C(A7),A7

	MOVEM.L	(A7)+,D4/A2/A3
	UNLK	A5
	RTS

L009CA:
	dc.l	L009CE	;"swing and miss"
	dc.l	L009D0	;"miss"
	dc.l	L009D2	;"barely miss"
	dc.l	L009D4	;"don't hit"

	dc.l	L009CF	;"swings and misses"
	dc.l	L009D1	;"misses"
	dc.l	L009D3	;"barely misses"
	dc.l	L009D5	;"doesn't hit"

L009CE:	dc.b	"swing and miss",0
L009CF:	dc.b	"swings and misses",0
L009D0:	dc.b	"miss",0
L009D1:	dc.b	"misses",0
L009D2:	dc.b	"barely miss",0
L009D3:	dc.b	"barely misses",0
L009D4:	dc.b	"don't hit",0
L009D5:	dc.b	"doesn't hit",0
L009D6:	dc.b	" %s %s",0

_slime_split:
	LINK	A5,#-$0000

	MOVE.L	A2,-(A7)
	MOVE.L	$0008(A5),-(A7)
	JSR	_new_slime(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00222

	JSR	_new_item
	MOVEA.L	D0,A2
	TST.L	D0
	BNE.B	L00223
L00222:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L00223:
	PEA	L00225(PC)
	JSR	_msg
	ADDQ.W	#4,A7
	PEA	-$54E0(A4)
	MOVE.W	#$0053,-(A7)	;'S' slime
	MOVE.L	A2,-(A7)
	JSR	_new_monster
	LEA	$000A(A7),A7

	MOVE.W	-$54E0(A4),-(A7)
	MOVE.W	-$54DE(A4),-(A7)
	JSR	_cansee
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00224

	MOVE.W	-$54E0(A4),d0
	MOVE.W	-$54DE(A4),d1
	JSR	_INDEXquick

	MOVEA.L	__level-BASE(A4),A6	;__level
	MOVE.B	$00(A6,D0.W),$0011(A2)

	MOVEq	#$53,d2		;'S'
	MOVE.W	-$54E0(A4),d1
	MOVE.W	-$54DE(A4),d0
	JSR	_mvaddchquick

L00224:
	PEA	-$54E0(A4)
	JSR	_start_run
	ADDQ.W	#4,A7
	BRA.B	L00222

L00225:	dc.b	"The slime divides.  Ick!",0,0

_new_slime:
	LINK	A5,#-$0004
	MOVEM.L	D4-D7/A2,-(A7)

	SUBA.L	A2,A2
	MOVEA.L	$0008(A5),A6
	ORI.W	#$8000,$0016(A6)	;C_ISFLY
	PEA	-$0004(A5)

	MOVE.W	$000A(A6),D7
	MOVE.W	$000C(A6),D6
	MOVE.W	D7,-(A7)
	MOVE.W	D6,-(A7)
	JSR	_plop_monster
	ADDQ.W	#8,A7
	TST.W	D0
	BNE.B	L0022B

	MOVE.W	D6,D4
	SUBQ.W	#1,D4
	BRA.B	L0022A
L00226:
	MOVE.W	D7,D5
	SUBQ.W	#1,D5
	BRA.B	L00229
L00227:
	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_winat
	ADDQ.W	#4,A7
	CMP.W	#$0053,D0	;'S' slime
	BNE.B	L00228

	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_moatquick

	TST.L	D0
	BEQ.B	L00228

	MOVEA.L	D0,A6
	MOVE.W	$0016(A6),D3
	AND.W	#$8000,D3	;C_ISFLY
	BNE.B	L00228

	MOVE.L	D0,-(A7)
	BSR.B	_new_slime
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00228

	MOVE.W	D6,D4
	ADDQ.W	#2,D4
	MOVE.W	D7,D5
	ADDQ.W	#2,D5
L00228:
	ADDQ.W	#1,D5
L00229:
	MOVE.W	D7,D3
	ADDQ.W	#1,D3
	CMP.W	D3,D5
	BLE.B	L00227

	ADDQ.W	#1,D4
L0022A:
	MOVE.W	D6,D3
	ADDQ.W	#1,D3
	CMP.W	D3,D4
	BLE.B	L00226

	BRA.B	L0022C
L0022B:
	MOVEA.W	#$0001,A2
	LEA	-$54E0(A4),A6
	LEA	-$0004(A5),A1
	MOVE.L	(A1)+,(A6)+
L0022C:
	MOVEA.L	$0008(A5),A6
	ANDI.W	#$7FFF,$0016(A6)	;clear C_ISFLY
	MOVE.W	A2,D0

	MOVEM.L	(A7)+,D4-D7/A2
	UNLK	A5
	RTS

;/*
; * remove_mon:
; *  Remove a monster from the screen
; */

_remove:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	TST.L	$000C(A5)
	BNE.B	L009F1
L009F0:
	MOVEM.L	(A7)+,D4/A2/A3
	UNLK	A5
	RTS

L009F1:
	MOVEA.L	$000C(A5),A6
	MOVEA.L	$002E(A6),A3
	BRA.B	L009F5
L009F2:
	MOVE.L	(A3),D4
	MOVEA.L	A3,A6
	ADDA.L	#$0000000C,A6
	MOVEA.L	$000C(A5),A1
	ADDA.L	#$0000000A,A1
	MOVE.L	(A1)+,(A6)+
	MOVE.L	A3,-(A7)
	MOVEA.L	$000C(A5),A6
	PEA	$002E(A6)
	JSR	__detach
	ADDQ.W	#8,A7
	TST.B	$0011(A5)
	BEQ.B	L009F3

	CLR.L	-(A7)
	MOVE.L	A3,-(A7)
	JSR	_fall
	ADDQ.W	#8,A7
	BRA.B	L009F4
L009F3:
	MOVE.L	A3,-(A7)
	JSR	_discard
	ADDQ.W	#4,A7
L009F4:
	MOVEA.L	D4,A3
L009F5:
	MOVE.L	A3,D3
	BNE.B	L009F2

	MOVE.W	(A2),d0
	MOVE.W	$0002(A2),d1
	JSR	_INDEXquick

	MOVEA.L	__level-BASE(A4),A6	;__level
	CMP.b	#'#',$00(A6,D0.W)
	BNE.B	L009F6

;	JSR	_standout
L009F6:
	MOVEA.L	$000C(A5),A6
	CMP.b	#$2E,$0011(A6)	;'.' FLOOR
	BNE.B	L009F7

	MOVE.W	(A2),-(A7)
	MOVE.W	$0002(A2),-(A7)
	JSR	_cansee
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.B	L009F7

	MOVEq	#$0020,d2	;' ' SPACE
	MOVE.W	(A2),d1
	MOVE.W	$0002(A2),d0
	JSR	_mvaddchquick

	BRA.B	L009F8
L009F7:
	MOVEA.L	$000C(A5),A6
	CMP.b	#$22,$0011(A6)	;'"'
	BEQ.B	L009F8

	MOVE.B	$0011(A6),D2
	MOVE.W	(A2),d1
	MOVE.W	$0002(A2),d0
	JSR	_mvaddchquick

L009F8:
;	JSR	_standend
	MOVE.L	$000C(A5),-(A7)
	PEA	_mlist-BASE(A4)	;_mlist
	JSR	__detach
	ADDQ.W	#8,A7
	MOVE.L	$000C(A5),-(A7)
	JSR	_discard
	ADDQ.W	#4,A7
	BRA.W	L009F0

;/*
; * killed:
; *  Called to put a monster to death
; */

_killed:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	$0008(A5),A6
	MOVE.L	$001A(A6),D3
	ADD.L	D3,-$52B0(A4)	;_player + 26 (EXP)
	MOVEA.L	$0008(A5),A6
	MOVE.B	$000F(A6),D0
	EXT.W	D0

	SUB.w	#$0046,D0	;'F' Venus Flytrap
	BEQ.W	L00A02
	SUBQ.w	#6,D0		;'L' Leprechaun
	BEQ.W	L00A03
L00A08:
	MOVE.W	#$0001,-(A7)
	MOVE.L	$0008(A5),-(A7)
	MOVEA.L	$0008(A5),A6
	PEA	$000A(A6)
	JSR	_remove(PC)
	LEA	$000A(A7),A7
	TST.B	$000D(A5)
	BEQ.B	L00A0A

	PEA	L00A0B(PC)	;"you have defeated "
	JSR	_addmsg
	ADDQ.W	#4,A7
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BEQ.B	L00A09

	MOVE.L	-$69BE(A4),-(A7)	;_it
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L00A0A
L00A09:
	MOVEA.L	$0008(A5),A6
	MOVE.B	$000F(A6),D3
	EXT.W	D3
	SUB.W	#$0041,D3	;'A'
	MULU.W	#26,D3
	LEA	_monsters-BASE(A4),A6	;_monsters
	MOVE.L	$00(A6,D3.L),-(A7)
	PEA	L00A0C(PC)	;"the %s"
	JSR	_msg
	ADDQ.W	#8,A7
L00A0A:
	JSR	_check_level(PC)
L00A04:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

; killed a venus flytrap

L00A02:
	ANDI.W	#~C_ISHELD,-$52B4(A4)	;clear C_ISHELD, _player + 22 (flags)
	JSR	_f_restor
	BRA.W	L00A08

; killed a leprechaun

L00A03:
	JSR	_new_item
	MOVEA.L	D0,A2
	TST.L	D0
	BEQ.B	L00A04

L00A05:
	MOVE.W	#$002A,$000A(A2)	;'*' gold

	bsr	goldcalc
	move.W	D0,D4

	MOVE.W	#VS_MAGIC,-(A7)
	JSR	_save(PC)
	ADDQ.W	#2,A7
	TST.W	D0
	BEQ.B	L00A06

	bsr	goldcalc
	ADD.W	D0,D4
	bsr	goldcalc
	ADD.W	D0,D4
	bsr	goldcalc
	ADD.W	D0,D4
	bsr	goldcalc
	ADD.W	D0,D4
L00A06:
	move.w	D4,$0026(A2)

	MOVE.L	A2,-(A7)
	MOVEA.L	$0008(A5),A6
	PEA	$002E(A6)
	JSR	__attach
	ADDQ.W	#8,A7
	BRA.B	L00A08

L00A0B:	dc.b	"you have defeated ",0
L00A0C:	dc.b	"the %s",0
