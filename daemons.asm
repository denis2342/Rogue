;/*
; * doctor:
; *  A healing daemon that restores hit points after rest
; */

_doctor:
;	LINK	A5,#-$0000
	MOVEM.L	D4/D5,-(A7)

	MOVE.W	-$52AC(A4),D4	;_player + 30 (rank)
	MOVE.W	-$52A8(A4),D5	;_player + 34 (hp)
	ADDQ.W	#1,-$60A0(A4)	;_quiet
	CMP.W	#$0008,D4
	BGE.B	L00640

	MOVE.W	D4,D3
	ASL.W	#1,D3
	ADD.W	-$60A0(A4),D3	;_quiet
	CMP.W	#$0014,D3
	BLE.B	L0063F

	ADDQ.W	#1,-$52A8(A4)	;_player + 34 (hp)
L0063F:
	BRA.B	L00641

L00640:	CMPI.W	#$0003,-$60A0(A4)	;_quiet
	BLT.B	L00641

	MOVE.W	D4,D3
	SUBQ.W	#7,D3
	MOVE.W	D3,D0
	JSR	_rnd
	ADDQ.W	#1,D0
	ADD.W	D0,-$52A8(A4)	;_player + 34 (hp)

L00641:	MOVE.L	_cur_ring_1-BASE(A4),D3	;_cur_ring_1
	BEQ.B	L00642

	MOVEA.L	D3,A6
	CMPI.W	#R_REGEN,$0020(A6)	; 9 = ring of regeneration
	BNE.B	L00642

	ADDQ.W	#1,-$52A8(A4)	;_player + 34 (hp)

L00642:	MOVE.L	_cur_ring_2-BASE(A4),D3	;_cur_ring_2
	BEQ.B	L00643

	MOVEA.L	D3,A6
	CMPI.W	#R_REGEN,$0020(A6)	; 9 = ring of regeneration
	BNE.B	L00643

	ADDQ.W	#1,-$52A8(A4)	;_player + 34 (hp)

L00643:	CMP.W	-$52A8(A4),D5	;_player + 34 (hp)
	BEQ.B	L00645

	MOVE.W	-$52A8(A4),D3	;_player + 34 (hp)
	CMP.W	-$52A2(A4),D3	;_player + 40 (max hp)
	BLE.B	L00644

	MOVE.W	-$52A2(A4),-$52A8(A4)	;_player + 40 (max hp),_player + 34 (hp)
L00644:
	CLR.W	-$60A0(A4)	;_quiet
L00645:
	MOVEM.L	(A7)+,D4/D5
;	UNLK	A5
	RTS

;/*
; * Swander:
; *  Called when it is time to start rolling for wandering monsters
; */

_swander:
;	LINK	A5,#-$0000
	CLR.W	-(A7)
	PEA	_rollwand(PC)
	JSR	_daemon(PC)
	ADDQ.W	#6,A7
;	UNLK	A5
	RTS

;/*
; * rollwand:
; *  Called to roll to see if a wandering monster starts up
; */

_rollwand:
;	LINK	A5,#-$0000
	ADDQ.W	#1,_between-BASE(A4)	;_between
	MOVEq	#$0003,D0
	JSR	_rnd
	ADDQ.W	#3,D0
	MOVE.W	_between-BASE(A4),D3	;_between
	CMP.W	D0,D3
	BLT.B	L00647

	MOVE.W	#$0006,-(A7)	;1d6
	MOVE.W	#$0001,-(A7)
	JSR	_roll
	ADDQ.W	#4,A7
	CMP.W	#$0004,D0
	BNE.B	L00646

	JSR	_wanderer(PC)
	PEA	_rollwand(PC)
	JSR	_extinguish(PC)
	ADDQ.W	#4,A7

	MOVEq	#100,D0
	JSR	_spread

	MOVE.W	D0,-(A7)
	CLR.W	-(A7)
	PEA	_swander(PC)
	JSR	_fuse(PC)
	ADDQ.W	#8,A7
L00646:
	CLR.W	_between-BASE(A4)	;_between
L00647:
;	UNLK	A5
	RTS

;/*
; * unconfuse:
; *  Release the poor player from his confusion
; */

_unconfuse:
;	LINK	A5,#-$0000
	ANDI.W	#~C_ISHUH,-$52B4(A4)	;clear ISHUH,_player + 22 (flags)
	PEA	L00648(PC)	;"you feel less confused now"
	JSR	_msg
	ADDQ.W	#4,A7
;	UNLK	A5
	RTS

L00648:	dc.b	"you feel less confused now",0,0

;/*
; * unsee:
; *  Turn off the ability to see invisible
; */

_unsee:
;	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)
	MOVEA.L	_mlist-BASE(A4),A2	;_mlist
	BRA.B	3$

1$	MOVE.W	$0016(A2),D3
	AND.W	#C_ISINVIS,D3	;C_ISINVIS
	BEQ.B	2$

	MOVE.L	A2,-(A7)
	JSR	_see_monst
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	2$

;	MOVEQ	#$00,D3
;	MOVE.B	$0011(A2),D3
;	CMP.W	#$0022,D3	;'"'
	cmp.b	#$22,$0011(A2)
	BEQ.B	2$

	MOVE.B	$0011(A2),D2
	MOVE.W	$000A(A2),d1
	MOVE.W	$000C(A2),d0
	JSR	_mvaddchquick

2$	MOVEA.L	(A2),A2

3$	MOVE.L	A2,D3
	BNE.B	1$

	ANDI.W	#~C_CANSEE,-$52B4(A4)	;clear CANSEE, _player + 22 (flags)

	MOVEA.L	(A7)+,A2
;	UNLK	A5
	RTS

;/*
; * sight:
; *  He gets his sight back
; */

_sight:
;	LINK	A5,#-$0000
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BEQ.B	L0064D

	PEA	_sight(PC)
	JSR	_extinguish(PC)
	ADDQ.W	#4,A7
	ANDI.W	#~C_ISBLIND,-$52B4(A4)	;clear C_ISBLIND, _player + 22 (flags)
	MOVEA.L	-$52A0(A4),A6	;_player + 42 (proom)
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3
	BNE.B	L0064C

	PEA	-$52C0(A4)	;_player + 10
	JSR	_enter_room
	ADDQ.W	#4,A7
L0064C:
	PEA	L0064E(PC)	;"the veil of darkness lifts"
	JSR	_msg
	ADDQ.W	#4,A7
L0064D:
;	UNLK	A5
	RTS

L0064E:	dc.b	"the veil of darkness lifts",0,0

;/*
; * nohaste:
; *  End the hasting
; */

_nohaste:
;	LINK	A5,#-$0000
	ANDI.W	#~C_ISHASTE,-$52B4(A4)	;clear C_ISHASTE,_player + 22 (flags)

	PEA	L0064F(PC)	;"you feel yourself slowing down"
	JSR	_msg
	ADDQ.W	#4,A7
;	UNLK	A5
	RTS

L0064F:	dc.b	"you feel yourself slowing down",0,0

;/*
; * stomach:
; *  Digest the hero's food
; */

_stomach:
;	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)

	MOVE.W	_food_left-BASE(A4),D4	;_food_left
	BGT.B	L00653

	SUBQ.W	#1,_food_left-BASE(A4)	;_food_left
	CMP.W	#$FCAE,D4	;-352
	BGE.B	L00650

	MOVE.W	#$0073,-(A7)	;'s' starvation
	JSR	_death
	ADDQ.W	#2,A7
L00650:
	TST.W	_no_command-BASE(A4)	;_no_command
	BNE	L00656

	MOVEq	#$0005,D0	;20% chance
	JSR	_rnd
	TST.W	D0
	BNE	L00656

	MOVEq	#$0008,D0
	JSR	_rnd
	ADDQ.W	#4,D0
	ADD.W	D0,_no_command-BASE(A4)	;_no_command
	ANDI.W	#~C_ISRUN,-$52B4(A4)	;clear C_ISRUN, _player + 22 (flags)
	CLR.B	_running-BASE(A4)	;_running
	CLR.W	_count-BASE(A4)	;_count
	MOVE.W	#$0003,_hungry_state-BASE(A4)	;_hungry_state

	LEA	L00658(PC),a0	;"you feel very weak. "
	JSR	_noterse

	MOVE.L	D0,-(A7)
	PEA	L00657(PC)	;"%syou faint from lack of food"
	JSR	_msg
	ADDQ.W	#8,A7
	JSR	_NewRank(PC)
	BRA.B	L00656
L00653:
	CLR.W	-(A7)
	JSR	_ring_eat(PC)
	ADDQ.W	#2,A7

	MOVE.W	D0,-(A7)

	MOVE.W	#$0001,-(A7)
	JSR	_ring_eat(PC)
	ADDQ.W	#2,A7

	MOVE.W	(A7)+,D3
	ADD.W	D0,D3
	ADDQ.W	#1,D3

	TST.B	_terse-BASE(A4)	;_terse
	BEQ.B	1$

	MULU.W	#$0002,D3

1$	SUB.W	D3,_food_left-BASE(A4)	;_food_left

	CMPI.W	#150,_food_left-BASE(A4)	;_food_left
	BGE.B	2$

	CMP.W	#150,D4
	BLT.B	2$

	MOVE.W	#$0002,_hungry_state-BASE(A4)	;_hungry_state
	JSR	_NewRank(PC)
	PEA	L00659(PC)	;"you are starting to feel weak"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L00656

2$	CMPI.W	#300,_food_left-BASE(A4)	;_food_left
	BGE.B	L00656

	CMP.W	#300,D4
	BLT.B	L00656

	MOVE.W	#$0001,_hungry_state-BASE(A4)	;_hungry_state
	JSR	_NewRank(PC)
	PEA	L0065A(PC)	;"you are starting to get hungry"
	JSR	_msg
	ADDQ.W	#4,A7
L00656:
	MOVE.L	(A7)+,D4
;	UNLK	A5
	RTS
