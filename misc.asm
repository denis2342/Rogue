;/*
; * look:
; *  A quick glance all around the player
; */

_look:
	LINK	A5,#-$0018
	MOVEM.L	D4-D7/A2/A3,-(A7)

	CLR.W	-$000A(A5)
	ST	-$48B7(A4)		;_looking
	MOVE.L	-$52A0(A4),-$0004(A5)	;_player + 42 (proom)

	JSR	_INDEXplayer

	MOVEA.W	D0,A2
	MOVE.W	A2,D3
	MOVEA.L	-$5198(A4),A6	;__flags
	MOVE.B	$00(A6,D3.W),-$000B(A5)
	MOVE.W	A2,D3
	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	$00(A6,D3.W),D7

	PEA	-$52C0(A4)	;_player + 10
	PEA	-$6090(A4)
	JSR	__ce(PC)
	ADDQ.W	#8,A7

	TST.W	D0
	BNE.W	L00823

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BNE.W	L00822

	MOVE.W	-$6090(A4),D4
	SUBQ.W	#1,D4
	BRA.W	L00821
L00818:
	MOVE.W	-$608E(A4),D5
	SUBQ.W	#1,D5
	BRA.W	L00820
L00819:
	CMP.W	-$52BE(A4),D5	;_player + 12
	BNE.B	L0081A

	CMP.W	-$52C0(A4),D4	;_player + 10
	BEQ.W	L0081F
L0081A:
	MOVE.W	D4,-(A7)
	MOVE.W	D5,-(A7)
	JSR	_offmap(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.W	L0081F

	MOVE.W	D4,-(A7)
	MOVE.W	D5,-(A7)
	PEA	-$6090(A4)
	JSR	_near_to(PC)
	ADDQ.W	#8,A7

	TST.W	D0
	BEQ.B	L0081B

	MOVE.W	D4,-(A7)
	MOVE.W	D5,-(A7)
	PEA	-$52C0(A4)	;_player + 10
	JSR	_near_to(PC)
	ADDQ.W	#8,A7

	TST.W	D0
	BNE.W	L0081F
L0081B:
	MOVE.W	D4,-(A7)
	MOVE.W	D5,-(A7)
	JSR	_mvinch(PC)
	ADDQ.W	#4,A7
	MOVE.B	D0,D6
	CMP.B	#$2E,D0		;'.'
	BNE.B	L0081D

	MOVE.L	-$48C0(A4),-(A7)	;_oldrp
	JSR	_is_dark(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L0081C

	MOVEA.L	-$48C0(A4),A6	;_oldrp
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3
	BNE.B	L0081C

	MOVE.W	#$0020,-(A7)	;' '
	JSR	_addch
	ADDQ.W	#2,A7
L0081C:
	BRA.B	L0081F
L0081D:
	MOVE.W	D4,d0
	MOVE.W	D5,d1
	JSR	_INDEXquick

	EXT.L	D0
	ADD.L	-$5198(A4),D0	;__flags
	MOVE.L	D0,-$0010(A5)
	MOVEA.L	D0,A6
;	MOVEQ	#$00,D3
	MOVE.B	(A6),D3
	AND.W	#F_DROPPED,D3
	BNE.B	1$

	MOVE.B	(A6),D3
	AND.B	#$40,D3
	BEQ.B	L0081F
1$
	CMP.B	#$23,D6		;'#' PASSAGE
	BEQ.B	L0081F

	CMP.B	#$25,D6		;'%' STAIRS
	BEQ.B	L0081F

	MOVE.B	(A6),D3
	AND.B	#$0F,D3
	MOVE.B	-$000B(A5),D2
	AND.B	#$0F,D2
	CMP.B	D2,D3
	BNE.B	L0081F

	MOVE.W	#$0023,-(A7)	;'#' PASSAGE
	JSR	_addch
	ADDQ.W	#2,A7
L0081F:
	ADDQ.W	#1,D5
L00820:
	MOVE.W	-$608E(A4),D3
	ADDQ.W	#1,D3
	CMP.W	D3,D5
	BLE.W	L00819

	ADDQ.W	#1,D4
L00821:
	MOVE.W	-$6090(A4),D3
	ADDQ.W	#1,D3
	CMP.W	D3,D4
	BLE.W	L00818
L00822:
	LEA	-$6090(A4),A6
	LEA	-$52C0(A4),A1	;_player + 10
	MOVE.L	(A1)+,(A6)+
	MOVE.L	-$0004(A5),-$48C0(A4)	;_oldrp
L00823:
	MOVE.W	-$52BE(A4),D3	;_player + 12
	ADDQ.W	#1,D3
	MOVE.W	D3,-$0006(A5)
	MOVE.W	-$52C0(A4),D3	;_player + 10
	ADDQ.W	#1,D3
	MOVE.W	D3,-$0008(A5)
	MOVE.W	-$52C0(A4),D3	;_player + 10
	SUBQ.W	#1,D3
	MOVE.W	D3,-$0014(A5)
	MOVE.W	-$52BE(A4),D3	;_player + 12
	SUBQ.W	#1,D3
	MOVE.W	D3,-$0012(A5)
	TST.B	-$66BB(A4)	;_door_stop
	BEQ.B	L00824
	TST.B	-$66B8(A4)	;_firstmove
	BNE.B	L00824
	TST.B	-$66B6(A4)	;_running
	BEQ.B	L00824
	MOVE.W	-$52BE(A4),D3	;_player + 12
	ADD.W	-$52C0(A4),D3	;_player + 10
	MOVE.W	D3,-$0016(A5)
	MOVE.W	-$52BE(A4),D3	;_player + 12
	SUB.W	-$52C0(A4),D3	;_player + 10
	MOVE.W	D3,-$0018(A5)
L00824:
	MOVEq	#$0040,d2	;'@' PLAYER
	MOVE.W	-$52C0(A4),d1	;_player + 10
	MOVE.W	-$52BE(A4),d0	;_player + 12
	JSR	_mvaddchquick

	MOVE.W	-$0012(A5),D5
	BRA.W	L00849
L00825:
	CMP.W	#$0000,D5
	BLE.W	L00848

	CMP.W	-$60BC(A4),D5	;_maxrow
	BGE.W	L00848

	MOVE.W	-$0014(A5),D4
	BRA.W	L00847
L00826:
	CMP.W	#$0000,D4
	BLE.W	L00846
	CMP.W	#$003C,D4	;'<' room corner
	BGE.W	L00846
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BNE.B	L00828
	CMP.W	-$52BE(A4),D5	;_player + 12
	BNE.B	L00827
	CMP.W	-$52C0(A4),D4	;_player + 10
	BEQ.W	L00846
L00827:
	BRA.B	L00829
L00828:
	CMP.W	-$52BE(A4),D5	;_player + 12
	BNE.W	L00846
	CMP.W	-$52C0(A4),D4	;_player + 10
	BNE.W	L00846
L00829:
	MOVE.W	D4,d0
	MOVE.W	D5,d1
	JSR	_INDEXquick

	MOVEA.W	D0,A2
	MOVE.W	A2,D3
	EXT.L	D3
	ADD.L	-$5198(A4),D3	;__flags
	MOVE.L	D3,-$0010(A5)
	MOVE.W	A2,D3
	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	$00(A6,D3.W),D6
	MOVEQ	#$00,D3
	MOVE.B	D7,D3
	CMP.W	#$002B,D3	;'+' DOOR
	BEQ.B	L0082C

	CMP.B	#$2B,D6		;'+' DOOR
	BEQ.B	L0082C

	MOVE.B	-$000B(A5),D3
	AND.B	#$40,D3
	MOVEA.L	-$0010(A5),A6
	MOVE.B	(A6),D2
	AND.B	#$40,D2
	CMP.B	D2,D3
	BEQ.B	L0082B

	MOVE.B	-$000B(A5),D3
	AND.B	#$20,D3
	BNE.B	L0082A

	MOVE.B	(A6),D3
	AND.B	#$20,D3
	BEQ.W	L00846
L0082A:
	BRA.B	L0082C
L0082B:
	MOVEA.L	-$0010(A5),A6
	MOVE.B	(A6),D3
	AND.W	#$0040,D3
	BEQ.B	L0082C

	MOVE.B	(A6),D3
	AND.B	#$0F,D3
	MOVE.B	-$000B(A5),D2
	AND.B	#$0F,D2
	CMP.B	D2,D3
	BNE.W	L00846
L0082C:
	MOVE.W	D4,d1
	MOVE.W	D5,d0
	JSR	_moatquick

	MOVEA.L	D0,A3
	TST.L	D0
	BEQ.B	L00832

	MOVE.W	$0016(A3),D3
	AND.W	#C_ISINVIS,D3	;C_ISINVIS
	BEQ.B	L0082E

	; bugfix: test if we actually can see the invisible

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_CANSEE,D3	;C_CANSEE
	BNE	L0082E

	TST.B	-$66BB(A4)	;_door_stop
	BEQ.B	L0082D

	TST.B	-$66B8(A4)	;_firstmove
	BNE.B	L0082D

	CLR.B	-$66B6(A4)	;_running
L0082D:
	BRA.B	L00832
L0082E:
	TST.B	$0009(A5)
	BEQ.B	L0082F

	MOVE.W	D4,-(A7)
	MOVE.W	D5,-(A7)
	JSR	_wake_monster
	ADDQ.W	#4,A7
L0082F:
	CMP.B	#$20,$0011(A3)
	BNE.B	L00830

	MOVE.L	-$0004(A5),-(A7)
	JSR	_is_dark(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.B	L00831

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BNE.B	L00831
L00830:
	MOVE.W	A2,D3
	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	$00(A6,D3.W),$0011(A3)
L00831:
	MOVE.L	A3,-(A7)
	JSR	_see_monst
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00832

	MOVE.B	$0010(A3),D6
L00832:
	MOVE.W	D4,d1
	MOVE.W	D5,d0
	JSR	_movequick

	MOVEQ	#$00,D3
	MOVE.B	D6,D3
	MOVE.W	D3,-(A7)
	JSR	_addch
	ADDQ.W	#2,A7

	JSR	_standend

	TST.B	-$66BB(A4)	;_door_stop
	BEQ.W	L00846

	TST.B	-$66B8(A4)	;_firstmove
	BNE.W	L00846

	TST.B	-$66B6(A4)	;_running
	BEQ.W	L00846

	MOVE.B	-$66A8(A4),D0	;_runch
	EXT.W	D0
;	EXT.L	D0
	BRA.B	L0083B
L00833:
	CMP.W	-$0008(A5),D4
	BEQ.W	L00846
	BRA.W	L0083C
L00834:
	CMP.W	-$0012(A5),D5
	BEQ.W	L00846
	BRA.W	L0083C
L00835:
	CMP.W	-$0006(A5),D5
	BEQ.W	L00846
	BRA.B	L0083C
L00836:
	CMP.W	-$0014(A5),D4
	BEQ.W	L00846
	BRA.B	L0083C
L00837:
	MOVE.W	D5,D3
	ADD.W	D4,D3
	SUB.W	-$0016(A5),D3
	CMP.W	#$0001,D3
	BGE.W	L00846
	BRA.B	L0083C
L00838:
	MOVE.W	D5,D3
	SUB.W	D4,D3
	SUB.W	-$0018(A5),D3
	CMP.W	#$0001,D3
	BGE.W	L00846
	BRA.B	L0083C
L00839:
	MOVE.W	D5,D3
	ADD.W	D4,D3
	SUB.W	-$0016(A5),D3
	CMP.W	#$FFFF,D3
	BLE.W	L00846
	BRA.B	L0083C
L0083A:
	MOVE.W	D5,D3
	SUB.W	D4,D3
	SUB.W	-$0018(A5),D3
	CMP.W	#$FFFF,D3
	BLE.W	L00846
	BRA.B	L0083C
L0083B:
	SUB.w	#$0062,D0	;'b'
	BEQ.B	L0083A
	SUBQ.w	#6,D0		;'h'
	BEQ.B	L00833
	SUBQ.w	#2,D0		;'j'
	BEQ.B	L00834
	SUBQ.w	#1,D0		;'k'
	BEQ.B	L00835
	SUBQ.w	#1,D0		;'l'
	BEQ.B	L00836
	SUBQ.w	#2,D0		;'n'
	BEQ.B	L00839
	SUBQ.w	#7,D0		;'u'
	BEQ.B	L00838
	SUBQ.w	#4,D0		;'y'
	BEQ.B	L00837
L0083C:
	MOVEQ	#$00,D0
	MOVE.B	D6,D0
	BRA.B	L00845
L0083D:
	CMP.W	-$52C0(A4),D4	;_player + 10
	BEQ.B	L0083E
	CMP.W	-$52BE(A4),D5	;_player + 12
	BNE.B	L0083F
L0083E:
	CLR.B	-$66B6(A4)	;_running
L0083F:
	BRA.B	L00846
L00840:
	CMP.W	-$52C0(A4),D4	;_player + 10
	BEQ.B	L00841
	CMP.W	-$52BE(A4),D5	;_player + 12
	BNE.B	L00846
L00841:
	ADDQ.W	#1,-$000A(A5)
	BRA.B	L00846
L00844:
	CLR.B	-$66B6(A4)	;_running
	BRA.B	L00846
L00845:
	SUB.w	#$0020,D0	;' '	SPACE
	BEQ.B	L00846
	SUBQ.w	#3,D0		;'#'	PASSAGE
	BEQ.B	L00840
	SUBQ.w	#8,D0		;'+'	DOOR
	BEQ.B	L0083D
	SUBQ.w	#2,D0		;'-'	WALL
	BEQ.B	L00846
	SUBQ.w	#1,D0		;'.'	FLOOR
	BEQ.B	L00846
	SUB.w	#$000E,D0	;'<'	DOWN
	BEQ.B	L00846
	SUBQ.w	#2,D0		;'>'	UP
	BEQ.B	L00846
	SUB.w	#$003D,D0	;'{'	top left room corner
	BEQ.B	L00846
	SUBQ.w	#1,D0		;'|'	WALL
	BEQ.B	L00846
	SUBQ.w	#1,D0		;'}'	top right room corner
	BEQ.B	L00846
	BRA.B	L00844
L00846:
	ADDQ.W	#1,D4
L00847:
	CMP.W	-$0008(A5),D4
	BLE.W	L00826
L00848:
	ADDQ.W	#1,D5
L00849:
	CMP.W	-$0006(A5),D5
	BLE.W	L00825

	TST.B	-$66BB(A4)	;_door_stop
	BEQ.B	L0084A

	TST.B	-$66B8(A4)	;_firstmove
	BNE.B	L0084A

	CMPI.W	#$0001,-$000A(A5)
	BLE.B	L0084A

	CLR.B	-$66B6(A4)	;_running
L0084A:
	MOVEq	#$0040,d2	;'@' PLAYER
	MOVE.W	-$52C0(A4),d1	;_player + 10
	MOVE.W	-$52BE(A4),d0	;_player + 12
	JSR	_mvaddchquick

	TST.B	-$66B4(A4)	;_was_trapped
	BEQ.B	L0084B

	JSR	_beep(PC)
	CLR.B	-$66B4(A4)	;_was_trapped
L0084B:
	CLR.B	-$48B7(A4)	;_looking

	MOVEM.L	(A7)+,D4-D7/A2/A3
	UNLK	A5
	RTS

;/*
; * find_obj:
; *  Find the unclaimed object at y, x
; */

_find_obj:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5/A2,-(A7)

	MOVE.W	$0008(A5),D4
	MOVE.W	$000A(A5),D5

	MOVEA.L	-$6CB0(A4),A2	;_lvl_obj
	BRA.B	L0084F
L0084C:
	CMP.W	$000E(A2),D4
	BNE.B	L0084E

	CMP.W	$000C(A2),D5
	BNE.B	L0084E

	MOVE.L	A2,D0
L0084D:
	MOVEM.L	(A7)+,D4/D5/A2
	UNLK	A5
	RTS

L0084E:
	MOVEA.L	(A2),A2		;get next object
L0084F:
	MOVE.L	A2,D3		;null check
	BNE.B	L0084C

	MOVEQ	#$00,D0
	BRA.B	L0084D

;/*
; * eat:
; *  She wants to eat something, so let her try
; */

_eat:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVE.L	A2,D3
	BNE.B	L00851

	MOVE.W	#$003A,-(A7)	;':' food type
	PEA	L0085C(PC)	;"eat"
	JSR	_get_item
	ADDQ.W	#6,A7

	MOVEA.L	D0,A2
	TST.L	D0
	BNE.B	L00851
L00850:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L00851:
	CMPI.W	#$003A,$000A(A2)	;':' food
	BEQ.B	L00852

	PEA	L0085D(PC)	;"ugh, you would get ill if you ate that"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L00850
L00852:
	MOVE.W	#$0001,-(A7)	;one item
	MOVE.L	A2,-(A7)
	JSR	_unpack
	ADDQ.W	#6,A7

	MOVEA.L	D0,A2		;could we remove the item from the pack?
	TST.L	D0
	BNE.B	L00853

	JSR	_stuck(PC)
	BRA.B	L00850
L00853:
	CMPI.W	#$0000,-$609E(A4)	;_food_left
	BGE.B	L00854

	CLR.W	-$609E(A4)	;_food_left
L00854:
	CMPI.W	#1980,-$609E(A4)	;_food_left
	BLE.B	L00855

	MOVEq	#$0005,D0
	JSR	_rnd
	ADDQ.W	#2,D0
	ADD.W	D0,-$60AC(A4)	;_no_command
L00855:
	MOVE.W	#1300,D0
	JSR	_spread

	MOVE.W	D0,-(A7)

	MOVE.W	#400,D0
	JSR	_rnd

	MOVE.W	(A7)+,D3
	ADD.W	D0,D3
	SUB.W	#200,D3
	ADD.W	D3,-$609E(A4)	;_food_left
	CMPI.W	#2000,-$609E(A4)	;_food_left
	BLE.B	L00856

	MOVE.W	#2000,-$609E(A4)	;_food_left
L00856:
	TST.W	-$609A(A4)	;_hungry_state
	BEQ.B	L00857
	CLR.W	-$609A(A4)	;_hungry_state
	JSR	_NewRank(PC)
L00857:
	CMPI.W	#$0001,$0020(A2)
	BNE.B	L00858

	PEA	-$6713(A4)	;_fruit "Mango"
	PEA	L0085E(PC)	;"my, that was a yummy %s"
	JSR	_msg
	ADDQ.W	#8,A7
	BRA.B	L0085A
L00858:
	MOVEq	#100,D0
	JSR	_rnd
	CMP.W	#70,D0
	BLE.B	L00859

	ADDQ.L	#1,-$52B0(A4)	;_player + 26 (EXP)

	PEA	L0085F(PC)	;"yuk, this food tastes awful"
	JSR	_msg
	ADDQ.W	#4,A7
	JSR	_check_level(PC)
	BRA.B	L0085A
L00859:
	PEA	L00860(PC)	;"yum, that tasted good"
	JSR	_msg
	ADDQ.W	#4,A7
L0085A:
	TST.W	-$60AC(A4)	;_no_command
	BEQ.B	L0085B

	PEA	L00861(PC)	;"You feel bloated and fall asleep"
	JSR	_msg
	ADDQ.W	#4,A7
L0085B:
	MOVE.L	A2,-(A7)
	JSR	_discard
	ADDQ.W	#4,A7
	BRA.W	L00850

L0085C:	dc.b	"eat",0
L0085D:	dc.b	"ugh, you would get ill if you ate that",0
L0085E:	dc.b	"my, that was a yummy %s",0
L0085F:	dc.b	"yuk, this food tastes awful",0
L00860:	dc.b	"yum, that tasted good",0
L00861:	dc.b	"You feel bloated and fall asleep",0

;/*
; * check_level:
; *  Check to see if the guy has gone up a level.
; */

_check_level:
;	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)

	MOVEQ	#$01,D4
	MOVEA.L	-$51AC(A4),A6	;_e_levels
	MOVE.L	-$52B0(A4),D3
	BRA.B	L00983
L00982:
	CMP.L	D3,D2	;_player + 26 (EXP)
	BGT.B	L00984

	ADDQ.W	#1,D4
L00983:
	MOVE.L	(A6)+,D2
	BNE.B	L00982
L00984:
	MOVE.W	-$52AC(A4),D0	;_player + 30 (rank)
	MOVE.W	D4,-$52AC(A4)	;_player + 30 (rank)
	CMP.W	D0,D4		;compare old with new
	BLE.B	L00986

	MOVE.W	#$000A,-(A7)	;10
	MOVE.W	D4,D3
	SUB.W	D0,D3		;difference in level (mostly one)
	MOVE.W	D3,-(A7)
	JSR	_roll		;so mostly it is 1d10
	ADDQ.W	#4,A7

	ADD.W	D0,-$52A2(A4)	;_player + 40 (max hp)
	ADD.W	D0,-$52A8(A4)	;_player + 34 (hp)
	MOVE.W	-$52A8(A4),D3	;_player + 34 (hp)
	CMP.W	-$52A2(A4),D3	;_player + 40 (max hp)
	BLE.B	L00985

	MOVE.W	-$52A2(A4),-$52A8(A4)	;_player + 40 (max hp),_player + 34 (hp)
L00985:
	MOVE.W	D4,D3
	SUBQ.W	#1,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$6D28(A4),A6	;_he_man
	MOVE.L	$00(A6,D3.w),-(A7)
	PEA	L00987(PC)	;'and achieve the rank of "%s"'
	JSR	_msg
	ADDQ.W	#8,A7
	MOVE.W	D4,D3
	SUBQ.W	#1,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$6D28(A4),A6	;_he_man
	MOVE.L	$00(A6,D3.w),-(A7)
	JSR	_NewRank(PC)
	ADDQ.W	#4,A7
L00986:
	MOVE.L	(A7)+,D4
;	UNLK	A5
	RTS

L00987:	dc.b	'and achieve the rank of "%s"',0,0

;/*
; * chg_str:
; *  used to modify the players strength.  It keeps track of the
; *  highest it has been, just in case
; */

_chg_str:
	LINK	A5,#-$0002

	MOVE.W	$0008(A5),D0
	BEQ.B	L00862

	MOVE.W	D0,-(A7)
	PEA	-$52B2(A4)	;_player + 24 (strength)
	BSR.B	_add_str
	ADDQ.W	#6,A7

	MOVE.W	-$52B2(A4),-$0002(A5)	;_player + 24 (strength)

	MOVE.L	-$5190(A4),D0	;_cur_ring_1
	bsr	L00864

	MOVE.L	-$518C(A4),D0	;_cur_ring_2
	bsr	L00864

	MOVE.W	-$0002(A5),D3
	CMP.W	-$6CC2(A4),D3	;_max_stats + 0 (max strength)
	BLS.B	L00862

	MOVE.W	-$0002(A5),-$6CC2(A4)	;_max_stats + 0 (max strength)
L00862:
	UNLK	A5
	RTS

L00864:
	tst.l	d0
	BEQ.B	1$

	MOVEA.L	D0,A6
	CMPI.W	#R_ADDSTR,$0020(A6)
	BNE.B	1$

	MOVE.W	$0026(A6),D3
	NEG.W	D3
	MOVE.W	D3,-(A7)
	PEA	-$0002(A5)
	BSR.B	_add_str
	ADDQ.W	#6,A7
1$	rts

;/*
; * add_str:
; *  Perform the actual add, checking upper and lower bound limits
; */

_add_str:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	$0008(A5),A2
	move.w	(a2),d3

	add.W	$000C(A5),D3

	CMPI.W	#3,d3
	BCC.B	1$
	MOVEq	#3,d3
	BRA.B	2$

1$	CMPI.W	#31,d3
	BLS.B	2$
	MOVEq	#31,d3

2$	move.w	d3,(a2)
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

;/*
; * add_haste:
; *  Add a haste to the player
; */

_add_haste:
	LINK	A5,#-$0000
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISHASTE,D3	; check C_ISHASTE bit
	BEQ.B	L0086A

	MOVEq	#$0008,D0
	JSR	_rnd
	ADD.W	D0,-$60AC(A4)	;_no_command

	ANDI.W	#~C_ISRUN,-$52B4(A4)	;clear C_ISRUN, _player + 22 (flags)

	PEA	_nohaste(PC)
	JSR	_extinguish(PC)
	ADDQ.W	#4,A7

	ANDI.W	#~C_ISHASTE,-$52B4(A4)	;clear C_ISHASTE,_player + 22 (flags)

	PEA	L0086C(PC)	;"you faint from exhaustion"
	JSR	_msg
	ADDQ.W	#4,A7

	MOVEQ	#$00,D0
L00869:
	UNLK	A5
	RTS

L0086A:
	ORI.W	#C_ISHASTE,-$52B4(A4)	;C_ISHASTE,_player + 22 (flags)
	TST.B	$0009(A5)
	BEQ.B	L0086B

	MOVEq	#$0028,D0
	JSR	_rnd

	ADD.W	#$000A,D0

	MOVE.W	D0,-(A7)
	CLR.W	-(A7)
	PEA	_nohaste(PC)
	JSR	_fuse(PC)
	ADDQ.W	#8,A7
L0086B:
	MOVEQ	#$01,D0
	BRA.B	L00869

L0086C:	dc.b	"you faint from exhaustion",0

;/*
; * aggravate:
; *  Aggravate all the monsters on this level
; */

_aggravate:
;	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	-$6CAC(A4),A2	;_mlist
	BRA.B	L0086E
L0086D:
	PEA	$000A(A2)
	JSR	_start_run	;set the monster on fire
	ADDQ.W	#4,A7
	MOVEA.L	(A2),A2		;get next monster
L0086E:
	MOVE.L	A2,D3		;check if there is one
	BNE.B	L0086D

	MOVEA.L	(A7)+,A2
;	UNLK	A5
	RTS

;/*
; * vowelstr:
; *      For printfs: if string starts with a vowel, return "n" for an
; *  "an".
; */

_vowelstr:
	MOVEA.L	$0004(A7),A6
	MOVE.B	(A6),D0
	EXT.W	D0

	SUB.w	#$0041,D0	;'A'
	BEQ.B	L0086F
	SUBQ.w	#4,D0		;'E'
	BEQ.B	L0086F
	SUBQ.w	#4,D0		;'I'
	BEQ.B	L0086F
	SUBQ.w	#6,D0		;'O'
	BEQ.B	L0086F
	SUBQ.w	#6,D0		;'U'
	BEQ.B	L0086F
	SUB.w	#$000C,D0	;'a'
	BEQ.B	L0086F
	SUBQ.w	#4,D0		;'e'
	BEQ.B	L0086F
	SUBQ.w	#4,D0		;'i'
	BEQ.B	L0086F
	SUBQ.w	#6,D0		;'o'
	BEQ.B	L0086F
	SUBQ.w	#6,D0		;'u'
	BEQ.B	L0086F

	LEA	L00874(PC),A6
	BRA.B	L00870

L0086F:
	LEA	L00873(PC),A6
L00870:
	MOVE.L	A6,D0

	RTS

L00873:	dc.b	"n",0
L00874:	dc.b	0,0

;/*
; * is_current:
; *  See if the object is one of the currently used items
; */

__is_current:
	MOVEQ	#$00,D0

	MOVE.L	$0004(A7),D3
	BEQ.B	2$

	CMP.L	-$5294(A4),D3	;_cur_armor
	BEQ.B	1$
	CMP.L	-$5298(A4),D3	;_cur_weapon
	BEQ.B	1$
	CMP.L	-$5190(A4),D3	;_cur_ring_1
	BEQ.B	1$
	CMP.L	-$518C(A4),D3	;_cur_ring_2
	BNE.B	2$

1$	MOVEQ	#$01,D0
2$	RTS

_is_current:
;	LINK	A5,#-$0000
	MOVE.L	$0004(A7),-(A7)
	BSR.B	__is_current
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L0087A

	PEA	L0087B(PC)	;"That's already in use"
	JSR	_msg
	ADDQ.W	#4,A7
	MOVEQ	#$01,D0
L00879:
;	UNLK	A5
L0087A:
	RTS

L0087B:	dc.b	"That's already in use",0

;/*
; * get_dir:
; *      Set up the direction co_ordinate for use in varios "prefix"
; *  commands
; */

_get_dir:
;	LINK	A5,#-$0002
	MOVEM.L	D4/A2,-(A7)

	TST.B	-$66F7(A4)	;_again
	BEQ.B	L0087D

	MOVEQ	#$01,D0
L0087C:
	MOVEM.L	(A7)+,D4/A2
;	UNLK	A5
	RTS

L0087D:
	PEA	L00882(PC)	;"which direction? "
	JSR	_msg
	ADDQ.W	#4,A7
L0087E:
	JSR	_readchar
	MOVE.W	D0,D4
	CMP.W	#$001B,D0	;escape
	BNE.B	L0087F

	PEA	L00883(PC)	;"",0
	JSR	_msg
	ADDQ.W	#4,A7
	MOVEQ	#$00,D0
	BRA.B	L0087C
L0087F:
	PEA	-$608C(A4)	;_delta + 0
	MOVE.W	D4,-(A7)
	BSR.B	_find_dir
	ADDQ.W	#6,A7
	TST.W	D0
	BEQ.B	L0087E

	PEA	L00884(PC)	;"",0
	JSR	_msg
	ADDQ.W	#4,A7
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISHUH,D3	;C_ISHUH
	BEQ.B	L00881

	MOVEq	#$0005,D0
	JSR	_rnd
	TST.W	D0
	BNE.B	L00881
L00880:
	MOVEq	#$0003,D0
	JSR	_rnd
	SUBQ.W	#1,D0
	MOVE.W	D0,-$608A(A4)	;_delta + 2

	MOVEq	#$0003,D0
	JSR	_rnd
	SUBQ.W	#1,D0
	MOVE.W	D0,-$608C(A4)	;_delta + 0

	TST.W	-$608A(A4)	;_delta + 2
	BNE.B	L00881

	TST.W	-$608C(A4)	;_delta + 0
	BEQ.B	L00880
L00881:
	MOVEQ	#$01,D0
	BRA.W	L0087C

L00882:	dc.b	"which direction? ",0
L00883:	dc.b	$00
L00884:	dc.b	$00

_find_dir:
	LINK	A5,#-$0002

	MOVE.B	#$01,-$0001(A5)
	MOVEQ	#$00,D0
	MOVE.B	$0009(A5),D0
	MOVEA.L	$000A(A5),A6
	BRA.W	L0088E
L00885:
	MOVE.W	#$FFFF,(A6)+
	CLR.W	(A6)
	BRA.W	L0088F
L00886:
	CLR.W	(A6)+
	MOVE.W	#$0001,(A6)
	BRA.W	L0088F
L00887:
	CLR.W	(A6)+
	MOVE.W	#$FFFF,(A6)
	BRA.W	L0088F
L00888:
	MOVE.W	#$0001,(A6)+
	CLR.W	(A6)
	BRA.W	L0088F
L00889:
	MOVE.W	#$FFFF,(A6)+
	MOVE.W	#$FFFF,(A6)
	BRA.W	L0088F
L0088A:
	MOVE.W	#$0001,(A6)+
	MOVE.W	#$FFFF,(A6)
	BRA.W	L0088F
L0088B:
	MOVE.W	#$FFFF,(A6)+
	MOVE.W	#$0001,(A6)
	BRA.B	L0088F
L0088C:
	MOVE.W	#$0001,(A6)+
	MOVE.W	#$0001,(A6)
	BRA.B	L0088F
L0088E:
	bclr	#5,d0	;easy way to make all uppercase

	SUB.w	#$0042,D0	;'B'
	BEQ.B	L0088B
	SUBQ.w	#6,D0		;'H'
	BEQ.W	L00885
	SUBQ.w	#2,D0		;'J'
	BEQ.W	L00886
	SUBQ.w	#1,D0		;'K'
	BEQ.W	L00887
	SUBQ.w	#1,D0		;'L'
	BEQ.W	L00888
	SUBQ.w	#2,D0		;'N'
	BEQ.B	L0088C
	SUBQ.w	#7,D0		;'U'
	BEQ.B	L0088A
	SUBQ.w	#4,D0		;'Y'
	BEQ.W	L00889

	CLR.B	-$0001(A5)
L0088F:
	MOVEQ	#$00,D0
	MOVE.B	-$0001(A5),D0
	UNLK	A5
	RTS

;/*
; * sign:
; *  Return the sign of the number
; */

_sign:
	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)
	MOVE.W	$0008(A5),D4
;	CMP.W	#$0000,D4
	BGE.B	L00891
	MOVEQ	#-$01,D0
L00890:
	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

L00891:
	CMP.W	#$0000,D4
	BLE.B	L00892

	MOVEq	#$0001,D0
	BRA.B	L00890
L00892:
	CLR.W	D0
	BRA.B	L00890

;/*
; * spread:
; *  Give a spread around a given number (+/- 10%)
; */

_spread:
	MOVE.L	D4,-(A7)

	MOVE.W	D0,D4
	MOVE.W	D4,D0
	EXT.L	D0
	DIVU.W	#$0005,D0
	JSR	_rnd
	MOVE.W	D4,D3
	EXT.L	D3
	DIVU.W	#$000A,D3
	SUB.W	D3,D4
	ADD.W	D4,D0

	MOVE.L	(A7)+,D4
	RTS

;/*
; * call_it:
; *  Call an object something after use.
; */

_call_it:
	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)
	MOVE.B	$0009(A5),D4
	TST.B	D4
	BEQ.B	L00894
	MOVEA.L	$000A(A5),A6
	TST.B	(A6)
	BEQ.B	L00894
	MOVEA.L	$000A(A5),A6
	CLR.B	(A6)
	BRA.B	L00896
L00894:
	TST.B	D4
	BNE.B	L00896
	MOVEA.L	$000A(A5),A6
	MOVE.B	(A6),D3
	EXT.W	D3
;	TST.W	D3
	BNE.B	L00896

	LEA	L00898(PC),a0	;"what do you want to "
	JSR	_noterse

	MOVE.L	D0,-(A7)
	PEA	L00897(PC)	;"%scall it? "
	JSR	_msg
	ADDQ.W	#8,A7
	MOVE.W	#$0014,-(A7)
	MOVE.L	-$5258(A4),-(A7)	;_prbuf
	JSR	_getinfo
	ADDQ.W	#6,A7
	MOVEA.L	-$5258(A4),A6	;_prbuf
	MOVE.B	(A6),D3
;	EXT.W	D3
	CMP.b	#$1B,D3		;escape
	BEQ.B	L00895
	MOVE.L	-$5258(A4),-(A7)	;_prbuf
	MOVE.L	$000A(A5),-(A7)
	JSR	_strcpy
	ADDQ.W	#8,A7
L00895:
	PEA	L00899(PC)
	JSR	_msg
	ADDQ.W	#4,A7
L00896:
	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

L00897:	dc.b	"%scall it? ",0
L00898:	dc.b	"what do you want to ",0
L00899:	dc.b	0
