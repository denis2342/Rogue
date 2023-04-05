;/*
; * quaff:
; *  Quaff a potion from the pack
; */

_quaff:
	LINK	A5,#-$0004
	MOVEM.L	A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVE.L	A2,D3
	BNE.B	L00484

	MOVE.W	#$0021,-(A7)	;'!' potion type
	PEA	L004AE(PC)
	JSR	_get_item
	ADDQ.W	#6,A7

	MOVEA.L	D0,A2
	TST.L	D0
	BNE.B	L00484
L00483:
	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

L00484:
	CMPI.W	#$0021,$000A(A2)	;'!' potion
	BEQ.B	L00485

	PEA	L004AF(PC)	;"yuk! Why would you want to drink that?"
	JSR	_msg
	ADDQ.W	#4,A7

	BRA.B	L00483
L00485:
	MOVE.L	A2,-(A7)
	JSR	_check_wisdom
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00486

	BRA.B	L00483
L00486:
	CMPA.L	_cur_weapon-BASE(A4),A2	;_cur_weapon
	BNE.B	L00487

	CLR.L	_cur_weapon-BASE(A4)	;_cur_weapon
L00487:
	MOVE.W	$0020(A2),D0
;	EXT.L	D0
	BRA.W	L004AB

; potion of confusion

L00488:
	ST	_p_know-BASE(A4)	;_p_know + 0 (potion of confusion)
	JSR	_p_confuse(PC)
	PEA	L004B0(PC)	;"wait, what's going on? Huh? What? Who?"
	JSR	_msg
	ADDQ.W	#4,A7

	BRA.W	L004AD

; potion of poison

L00489:
	LEA	L004B1(PC),A6	;"you feel %s sick."
	MOVE.L	A6,-$0004(A5)
	ST	-$66E5(A4)	;_p_know + 2 (potion of poison)

	MOVE.L	_cur_ring_1-BASE(A4),D0	;_cur_ring_1
	BEQ.B	L0048A

	MOVEA.L	D0,A6		;_cur_ring_1
	CMPI.W	#R_SUSTSTR,$0020(A6)
	BEQ.B	L0048C
L0048A:
	MOVE.L	_cur_ring_2-BASE(A4),D0	;_cur_ring_2
	BEQ.B	L0048B

	MOVEA.L	D0,A6		;_cur_ring_2
	CMPI.W	#R_SUSTSTR,$0020(A6)
	BEQ.B	L0048C
L0048B:
	MOVEq	#$0003,D0
	JSR	_rnd
;	ADDQ.W	#1,D0
;	NEG.W	D0
	subq.w	#3,d0
	MOVE.W	D0,-(A7)	;subtract 1-3 strength points
	JSR	_chg_str
	ADDQ.W	#2,A7
	PEA	L004B2(PC)	;"very"
	MOVE.L	-$0004(A5),-(A7)
	JSR	_msg
	ADDQ.W	#8,A7

	BRA.B	L0048D
L0048C:
	PEA	L004B3(PC)	;"momentarily"
	MOVE.L	-$0004(A5),-(A7)
	JSR	_msg
	ADDQ.W	#8,A7
L0048D:
	BRA.W	L004AD

; potion of healing

L0048E:
	ST	-$66E2(A4)	;_p_know + 5 (potion of healing)
	MOVE.W	#$0004,-(A7)	;xd4
	MOVE.W	-$52AC(A4),-(A7)	;_player + 30 (rank)
	JSR	_roll
	ADDQ.W	#4,A7

	ADD.W	D0,-$52A8(A4)	;_player + 34 (hp)
	MOVE.W	-$52A8(A4),D3	;_player + 34 (hp)
	CMP.W	-$52A2(A4),D3	;_player + 40 (max hp)
	BLE.B	L0048F

	ADDQ.W	#1,-$52A2(A4)	;_player + 40 (max hp)
	MOVE.W	-$52A2(A4),-$52A8(A4)	;_player + 34 (hp),_player + 40 (max hp)
L0048F:
	JSR	_sight(PC)
	PEA	L004B4(PC)	;"you begin to feel better"
	JSR	_msg
	ADDQ.W	#4,A7

	BRA.W	L004AD

; potion of gain strength

L00490:
	ST	-$66E4(A4)	;_p_know + 3 (potion of gain strength)
	MOVE.W	#$0001,-(A7)	; plus one strength point
	JSR	_chg_str
	ADDQ.W	#2,A7
	PEA	L004B5(PC)	;"you feel stronger. What bulging muscles!"
	JSR	_msg
	ADDQ.W	#4,A7

	BRA.W	L004AD

; potion of night vision

L00491:
	MOVE.W	#300,D0
	JSR	_spread

	MOVE.W	D0,-(A7)

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISFOUND,D3	;C_ISFOUND
	BEQ.B	L00492

	PEA	_lose_vision(PC)
	JSR	_lengthen(PC)
	ADDQ.W	#6,A7
	BRA.B	L00493
L00492:
	CLR.W	-(A7)
	PEA	_lose_vision(PC)
	JSR	_fuse(PC)
	ADDQ.W	#8,A7
L00493:
	JSR	_sight(PC)
	PEA	L004B6(PC)	;"Your vision is clouded for a moment.  Now it seems very bright in here."
	JSR	_msg
	ADDQ.W	#4,A7

	ORI.W	#C_ISFOUND,-$52B4(A4)	;_player + 22 (flags)
	PEA	-$52C0(A4)	;_player + 10
	JSR	_leave_room
	ADDQ.W	#4,A7

	PEA	-$52C0(A4)	;_player + 10
	JSR	_enter_room
	ADDQ.W	#4,A7
	BRA.W	L004AD

; potion of discernment

L00494:
	MOVEq	#100,D0
	JSR	_spread

	MOVE.W	D0,-(A7)

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_WISDOM,D3
	BEQ.B	1$

	PEA	_foolish(PC)
	JSR	_lengthen(PC)
	ADDQ.W	#6,A7
	BRA.B	2$
1$
	ORI.W	#C_WISDOM,-$52B4(A4)	;WISDOM, _player + 22 (flags)

	CLR.W	-(A7)
	PEA	_foolish(PC)
	JSR	_fuse(PC)
	ADDQ.W	#8,A7
2$
	PEA	L004B7(PC)	;"You feel light headed for a moment, then it passes."
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L004AD

; potion of paralysis

L00497:
	ST	-$66E6(A4)	;_p_know + 1 (potion of paralysis)

	MOVEq	#$0002,D0
	JSR	_spread

	MOVE.W	D0,_no_command-BASE(A4)	;_no_command
	ANDI.W	#~C_ISRUN,-$52B4(A4)	;clear C_ISRUN, _player + 22 (flags)
	PEA	L004B8(PC)	;"you can't move"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L004AD

; potion of see invisible

L00498:
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_CANSEE,D3	;C_CANSEE
	BNE.B	1$

	MOVE.W	#300,D0
	JSR	_spread

	MOVE.W	D0,-(A7)
	CLR.W	-(A7)
	PEA	_unsee(PC)
	JSR	_fuse(PC)
	ADDQ.W	#8,A7

	CLR.L	-(A7)
	JSR	_look
	ADDQ.W	#4,A7
	JSR	_invis_on(PC)
1$
	JSR	_sight(PC)
	PEA	-$6713(A4)
	PEA	L004B9(PC)	;"this potion tastes like %s juice"
	JSR	_msg
	ADDQ.W	#8,A7
	BRA.W	L004AD

; potion of raise level

L0049A:
	ST	-$66DF(A4)	;_p_know + 8 (potion of raise level)
	MOVE.W	-$52AC(A4),D3	;_player + 30 (rank)
	SUBQ.W	#1,D3
;	EXT.L	D3
	ASL.w	#2,D3
	MOVEA.L	_e_levels-BASE(A4),A6	;_e_levels
	TST.L	$00(A6,D3.w)
	BEQ.B	1$

	PEA	L004BA(PC)	;"you suddenly feel much more skillful"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	2$
1$
	PEA	L004BB(PC)	;"you suddenly feel much less skillful"
	JSR	_msg
	ADDQ.W	#4,A7
2$
	JSR	_raise_level
	BRA.W	L004AD

; potion of extra healing

L0049D:
	ST	-$66DE(A4)	;_p_know + 9 (potion of extra healing)
	MOVE.W	-$52A8(A4),D3	;_player + 34 (hp)
	CMP.W	-$52A2(A4),D3	;_player + 40 (max hp)
	BNE.B	1$

	ADDQ.W	#1,-$52A2(A4)	;_player + 40 (max hp)
1$
	MOVE.W	-$52A2(A4),-$52A8(A4)	;_player + 40 (max hp),_player + 34 (hp)
	JSR	_sight(PC)
	PEA	L004BC(PC)	;"you begin to feel much better"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L004AD

; potion of haste self

L0049F:
	ST	-$66DD(A4)	;_p_know + 10 (potion of haste self)
	MOVE.W	#$0001,-(A7)
	JSR	_add_haste(PC)
	ADDQ.W	#2,A7
	TST.W	D0
	BEQ.B	1$

	PEA	L004BD(PC)	;"you feel yourself moving much faster"
	JSR	_msg
	ADDQ.W	#4,A7
1$
	BRA.W	L004AD

; restore strength

L004A1:
	MOVE.L	_cur_ring_1-BASE(A4),D0	;_cur_ring_1
	BEQ.B	L004A2

	MOVEA.L	D0,A6		;_cur_ring_1
	CMPI.W	#R_ADDSTR,$0020(A6)
	BNE.B	L004A2

	MOVE.W	$0026(A6),D3
	NEG.W	D3
	MOVE.W	D3,-(A7)
	PEA	-$52B2(A4)	;_player + 24 (strength)
	JSR	_add_str(PC)
	ADDQ.W	#6,A7
L004A2:
	MOVE.L	_cur_ring_2-BASE(A4),D0	;_cur_ring_2
	BEQ.B	L004A3

	MOVEA.L	D0,A6		;_cur_ring_2
	CMPI.W	#R_ADDSTR,$0020(A6)
	BNE.B	L004A3

	MOVE.W	$0026(A6),D3
	NEG.W	D3
	MOVE.W	D3,-(A7)
	PEA	-$52B2(A4)	;_player + 24 (strength)
	JSR	_add_str(PC)
	ADDQ.W	#6,A7
L004A3:
	MOVE.W	-$52B2(A4),D3	;_player + 24 (strength)
	CMP.W	-$6CC2(A4),D3	;_max_stats + 0 (max strength)
	BCC.B	L004A4

	MOVE.W	-$6CC2(A4),-$52B2(A4)	;_max_stats + 0 (max strength),_player + 24 (strength)
L004A4:
	MOVE.L	_cur_ring_1-BASE(A4),D0	;_cur_ring_1
	BEQ.B	L004A5

	MOVEA.L	D0,A6		;_cur_ring_1
	CMPI.W	#R_ADDSTR,$0020(A6)
	BNE.B	L004A5

	MOVE.W	$0026(A6),-(A7)
	PEA	-$52B2(A4)	;_player + 24 (strength)
	JSR	_add_str(PC)
	ADDQ.W	#6,A7
L004A5:
	MOVE.L	_cur_ring_2-BASE(A4),D0	;_cur_ring_2
	BEQ.B	L004A6

	MOVEA.L	D0,A6		;_cur_ring_2
	CMPI.W	#R_ADDSTR,$0020(A6)
	BNE.B	L004A6

	MOVE.W	$0026(A6),-(A7)
	PEA	-$52B2(A4)	;_player + 24 (strength)
	JSR	_add_str(PC)
	ADDQ.W	#6,A7
L004A6:
	LEA	L004BF(PC),a0	;"hey, this tastes great.  It makes "
	JSR	_noterse

	MOVE.L	D0,-(A7)
	PEA	L004BE(PC)	;"%syou feel warm all over"
	JSR	_msg
	ADDQ.W	#8,A7
	BRA.B	L004AD

; potion of blindness

L004A7:
	ST	-$66DB(A4)	;_p_know + 12 (potion of blindness)
	JSR	_p_blind(PC)
	PEA	L004C0(PC)	;"a cloak of darkness falls around you"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L004AD

; potion of thurst quenching

L004A8:
	PEA	L004C1(PC)	;"this potion tastes extremely dull"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L004AD

; potion of unknown origin

L004A9:
	PEA	L004C2(PC)	;"what an odd tasting potion!"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L00483
L004AA:
	dc.w	L00488-L004AC	;potion of confusion
	dc.w	L00497-L004AC	;potion of paralysis
	dc.w	L00489-L004AC	;potion of poison
	dc.w	L00490-L004AC	;potion of gain strength
	dc.w	L00498-L004AC	;potion of see invisible
	dc.w	L0048E-L004AC	;potion of healing
	dc.w	L00491-L004AC	;potion of night vision
	dc.w	L00494-L004AC	;potion of discernment
	dc.w	L0049A-L004AC	;potion of raise level
	dc.w	L0049D-L004AC	;potion of extra healing
	dc.w	L0049F-L004AC	;potion of haste self
	dc.w	L004A1-L004AC	;potion of restore strength
	dc.w	L004A7-L004AC	;potion of blindness
	dc.w	L004A8-L004AC	;potion of thurst quenching
L004AB:
	CMP.w	#$000E,D0
	BCC.B	L004A9
	ASL.w	#1,D0
	MOVE.W	L004AA(PC,D0.W),D0
L004AC:	JMP	L004AC(PC,D0.W)
L004AD:
	JSR	_status

	MOVE.W	$0020(A2),D3
	MULU.W	#21,D3
	LEA	_p_guess-BASE(A4),A6	;_p_guess
	ADD.L	A6,D3
	MOVE.L	D3,-(A7)
	MOVE.W	$0020(A2),D3
	LEA	_p_know-BASE(A4),A6	;_p_know
	MOVEQ	#$00,D2
	MOVE.B	$00(A6,D3.W),D2
	MOVE.W	D2,-(A7)
	JSR	_call_it
	ADDQ.W	#6,A7

	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_pack_name
	ADDQ.W	#6,A7

	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_unpack
	ADDQ.W	#6,A7

	MOVE.L	D0,-(A7)
	JSR	_discard
	ADDQ.W	#4,A7
	BRA.W	L00483

L004AE:	dc.b	"quaff",0
L004AF:	dc.b	"yuk! Why would you want to drink that?",0
L004B0:	dc.b	"wait, what's going on? Huh? What? Who?",0
L004B1:	dc.b	"you feel %s sick.",0
L004B2:	dc.b	"very",0
L004B3:	dc.b	"momentarily",0
L004B4:	dc.b	"you begin to feel better",0
L004B5:	dc.b	"you feel stronger. What bulging muscles!",0
L004B6:	dc.b	"Your vision is clouded for a moment.  Now it seems very bright in here.",0
L004B7:	dc.b	"You feel light headed for a moment, then it passes.",0
L004B8:	dc.b	"you can't move",0
L004B9:	dc.b	"this potion tastes like %s juice",0
L004BA:	dc.b	"you suddenly feel much more skillful",0
L004BB:	dc.b	"you suddenly feel much less skillful",0
L004BC:	dc.b	"you begin to feel much better",0
L004BD:	dc.b	"you feel yourself moving much faster",0
L004BE:	dc.b	"%syou feel warm all over",0
L004BF:	dc.b	"hey, this tastes great.  It makes ",0
L004C0:	dc.b	"a cloak of darkness falls around you",0
L004C1:	dc.b	"this potion tastes extremely dull",0
L004C2:	dc.b	"what an odd tasting potion!",0,0

;/*
; * is_magic:
; *  Returns true if an object radiates magic (the nymph wants to know!)
; */

_is_magic:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)
	MOVEA.L	$0008(A5),A2
	MOVE.L	A2,-(A7)
	JSR	_typeof
	ADDQ.W	#4,A7
;	EXT.L	D0
	BRA.B	L00A01
L009F9:
	MOVE.W	$0020(A2),D3
;	EXT.L	D3
	ASL.w	#1,D3
	LEA	_a_class-BASE(A4),A6	;_a_class
	MOVE.W	$00(A6,D3.w),D2
	CMP.W	$0026(A2),D2
	BEQ.B	L009FA

	MOVEq	#$0001,D0
	BRA.B	L009FB
L009FA:
	CLR.W	D0
L009FB:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L009FC:
	TST.W	$0022(A2)
	BNE.B	L009FD
	TST.W	$0024(A2)
	BEQ.B	L009FA
L009FD:
	MOVEq	#$0001,D0
	BRA.B	L009FB
L00A01:
	SUB.w	#$0021,D0	;'!' potions
	BEQ.B	L009FD
	SUB.w	#$000B,D0	;',' amulet of yendor
	BEQ.B	L009FD
	SUBQ.w	#3,D0		;'/' wands/staffs
	BEQ.B	L009FD
	SUB.w	#$000E,D0	;'=' rings
	BEQ.B	L009FD
	SUBQ.w	#2,D0		;'?' scrolls
	BEQ.B	L009FD
	SUB.w	#$0022,D0	;'a' armor type
	BEQ.B	L009F9
	SUB.w	#$000C,D0	;'m' weapon type
	BEQ.B	L009FC
	BRA.B	L009FA

;/*
; * invis_on:
; *  Turn on the ability to see invisible
; */

_invis_on:
;	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	ORI.W	#C_CANSEE,-$52B4(A4)	;_player + 22 (flags)

	MOVEA.L	_mlist-BASE(A4),A2	;_mlist
	BRA.B	3$

1$	MOVE.W	$0016(A2),D3
	AND.W	#C_ISINVIS,D3	;check if the monster is invisible
	BEQ.B	2$

	MOVE.L	A2,-(A7)
	JSR	_see_monst
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	2$

	MOVE.B	$0010(A2),D2
	MOVE.W	$000A(A2),d1
	MOVE.W	$000C(A2),d0
	JSR	_mvaddchquick

2$	MOVEA.L	(A2),A2		;get next monster in list

3$	MOVE.L	A2,D3
	BNE.B	1$

	MOVEA.L	(A7)+,A2
;	UNLK	A5
	RTS

_th_effect:
	LINK	A5,#-$0000
	MOVEM.L	A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVEA.L	$000C(A5),A3
	MOVE.W	$0020(A2),D0
;	EXT.L	D0
	BRA.W	L004CD

; potion of confusion and potion of blindness

L004C6:
	ORI.W	#C_ISHUH,$0016(A3)	;monster is confused
	MOVE.B	$000F(A3),D3
	EXT.W	D3
	SUB.W	#$0041,D3	;'A'
	MULU.W	#26,D3
	LEA	_monsters-BASE(A4),A6	;_monsters
	MOVE.L	$00(A6,D3.L),-(A7)
	PEA	L004D0(PC)	;"the %s appears confused"
	JSR	_msg
	ADDQ.W	#8,A7
	BRA.B	L004CF

; potion of paralysis

L004C7:
	ANDI.W	#~C_ISRUN,$0016(A3)	;clear C_ISRUN
	ORI.W	#C_ISHELD,$0016(A3)	;set C_ISHELD
	BRA.B	L004CF

; potion of (extra) healing heals the monster 0-7 points

L004C8:
	MOVEq	#$0008,D0
	JSR	_rnd
	ADD.W	D0,$0022(A3)

	MOVE.W	$0022(A3),D3
	CMP.W	$0028(A3),D3
	BLE.B	L004C9

	ADDQ.W	#1,$0028(A3)
	MOVE.W	$0028(A3),$0022(A3)
L004C9:
	BRA.B	L004CF

; potion of raise level

L004CA:
	ADDQ.W	#8,$0022(A3)	;hp + 8
	ADDQ.W	#8,$0028(A3)	;max hp + 8
	ADDQ.W	#1,$001E(A3)
	BRA.B	L004CF

; potion of haste self

L004CB:
	ORI.W	#C_ISHASTE,$0016(A3)	;set C_ISHASTE
	BRA.B	L004CF

L004CC:
	dc.w	L004C6-L004CE	;confusion
	dc.w	L004C7-L004CE	;paralysis
	dc.w	L004CF-L004CE	;poison
	dc.w	L004CF-L004CE	;gain strength
	dc.w	L004CF-L004CE	;see invisible
	dc.w	L004C8-L004CE	;healing
	dc.w	L004CF-L004CE	;night vision
	dc.w	L004CF-L004CE	;discernment
	dc.w	L004CA-L004CE	;raise level
	dc.w	L004C8-L004CE	;extra healing
	dc.w	L004CB-L004CE	;haste self
	dc.w	L004CF-L004CE	;restore strength
	dc.w	L004C6-L004CE	;blindness
L004CD:
	CMP.w	#$000D,D0
	BCC.B	L004CF
	ASL.w	#1,D0
	MOVE.W	L004CC(PC,D0.W),D0
L004CE:	JMP	L004CE(PC,D0.W)

L004CF:
	PEA	L004D1(PC)	;"the flask shatters."
	JSR	_msg
	ADDQ.W	#4,A7
	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

L004D0:	dc.b	"the %s appears confused",0
L004D1:	dc.b	"the flask shatters.",0

_p_confuse:
;	LINK	A5,#-$0000

	MOVEq	#$0008,D0
	JSR	_rnd
	MOVE.W	D0,-(A7)	;save rnd to stack

	MOVEq	#20,D0
	JSR	_spread

	ADD.W	D0,(A7)		;add spread to rnd on stack

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISHUH,D3	;C_ISHUH
	BEQ.B	1$

	PEA	_unconfuse(PC)
	JSR	_lengthen(PC)
	ADDQ.W	#6,A7
	BRA.B	2$

1$	CLR.W	-(A7)
	PEA	_unconfuse(PC)
	JSR	_fuse(PC)
	ADDQ.W	#8,A7

2$	ORI.W	#C_ISHUH,-$52B4(A4)	;C_ISHUH,_player + 22 (flags)
;	UNLK	A5
	RTS

_p_blind:
;	LINK	A5,#-$0000
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3
	BNE.B	L004D4

	ORI.W	#C_ISBLIND,-$52B4(A4)	;_player + 22 (flags)

	MOVE.W	#300,D0
	JSR	_spread

	MOVE.W	D0,-(A7)
	CLR.W	-(A7)
	PEA	_sight(PC)
	JSR	_fuse(PC)
	ADDQ.W	#8,A7
	CLR.L	-(A7)
	JSR	_look
	ADDQ.W	#4,A7
L004D4:
;	UNLK	A5
	RTS

;/*
; * raise_level:
; *  The guy just magically went up a level.
; */

_raise_level:
;	LINK	A5,#-$0000

	MOVE.W	-$52AC(A4),D3	;_player + 30 (rank)
	SUBQ.W	#1,D3
;	EXT.L	D3
	ASL.w	#2,D3
	MOVEA.L	_e_levels-BASE(A4),A6	;_e_levels
	MOVE.L	$00(A6,D3.w),D2
	ADDQ.L	#1,D2
	MOVE.L	D2,-$52B0(A4)	;_player + 26 (EXP)
	JSR	_check_level(PC)

;	UNLK	A5
	RTS
