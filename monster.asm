;/*
; * randmonster:
; *  Pick a monster to show up.  The lower the level,
; *  the meaner the monster.
; */

_randmonster:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2,-(A7)

	TST.B	$0009(A5)	;wandering sets one here
	BEQ.B	L00A0F

	MOVEA.L	-$6992(A4),A2	;normal monster list
	BRA.B	L00A10
L00A0F:
	MOVEA.L	_lvl_monster_ptr-BASE(A4),A2	;wandering monster list
L00A10:
	MOVEq	#$0005,D0
	JSR	_rnd
	MOVE.W	D0,-(A7)

	MOVEq	#6,D0
	JSR	_rnd

	MOVE.W	(A7)+,D4
	ADD.W	D0,D4		;0-4 + 0-5
	ADD.W	_level-BASE(A4),D4	;_level
	SUBQ.W	#5,D4
	CMP.W	#$0001,D4
	BGE.B	L00A11

	MOVEq	#$0005,D0
	JSR	_rnd

	MOVE.W	D0,D4
	ADDQ.W	#1,D4
L00A11:
	CMP.W	#26,D4
	BLE.B	L00A12

; dragon has only 20% chance to appear

	MOVEq	#$0005,D0
	JSR	_rnd
	moveq	#22,D4
	ADD.W	D0,D4
L00A12:
	SUBQ.W	#1,D4
	MOVE.B	$00(A2,D4.W),D0
;	EXT.W	D0
	CMP.b	#$20,D0		;' '
	BEQ.B	L00A10

	EXT.W	D0
	MOVEM.L	(A7)+,D4/A2
	UNLK	A5
	RTS

;/*
; * new_monster:
; *  Pick a new monster and add it to the list
; */

_new_monster:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVE.B	#$01,$0008(A2)
	MOVE.W	_level-BASE(A4),D4	;dungeon _level
	SUB.W	#26,D4
;	CMP.W	#$0000,D4
	BGE.B	1$

	MOVEQ	#$00,D4

1$	MOVE.L	A2,-(A7)
	PEA	_mlist-BASE(A4)	;_mlist
	JSR	__attach
	ADDQ.W	#8,A7

	MOVE.B	$000D(A5),$000F(A2)	; monster type ABC...
	MOVE.B	$000D(A5),$0010(A2)	; xerox puts his disguise type here
	MOVEA.L	A2,A6
	ADDA.L	#$0000000A,A6
	MOVEA.L	$000E(A5),A1
	MOVE.L	(A1)+,(A6)+
	MOVE.B	#$22,$0011(A2)	;'"'

	MOVE.L	$000E(A5),-(A7)
	JSR	_roomin
	ADDQ.W	#4,A7

	MOVE.L	D0,$002A(A2)	;room
	MOVE.B	$000F(A2),D3
	EXT.W	D3
	SUB.W	#$0041,D3	;'A'
	MULU.W	#26,D3
	LEA	_monsters-BASE(A4),A3	;_monsters
	ADDA.L	D3,A3
	MOVE.W	$000E(A3),D3	; number for xd8 HP
	ADD.W	D4,D3
	MOVE.W	D3,$001E(A2)	;rank

	MOVE.W	#$0008,-(A7)	;xd8
	MOVE.W	D3,-(A7)
	JSR	_roll
	ADDQ.W	#4,A7
	MOVE.W	D0,$0022(A2)	;hp
	MOVE.W	D0,$0028(A2)	;max hp
	MOVE.W	$0010(A3),D3	; AC (lower is better)
	SUB.W	D4,D3
	MOVE.W	D3,$0020(A2)	;base armor class
	MOVE.L	$0014(A3),$0024(A2)	;pointer to "1d8" or "1d8/1d8/3d10"
	MOVE.W	$0008(A3),$0018(A2)	;all monster have strength of 10
	MOVE.W	D4,D3
	MULU.W	#10,D3
	EXT.L	D3
	MOVE.L	D3,-(A7)

	MOVE.L	A2,-(A7)
	JSR	_exp_add(PC)
	ADDQ.W	#4,A7
	EXT.L	D0

	MOVE.L	(A7)+,D3
	ADD.L	D0,D3
	ADD.L	$000A(A3),D3		;add monsters EXP value
	MOVE.L	D3,$001A(A2)		;experience
	MOVE.W	$0006(A3),$0016(A2)	;copy the flags (mean,greedy...)
	MOVE.B	#$01,$000E(A2)
	CLR.L	$002E(A2)	;start with empty pack

	TST.L	_cur_ring_1-BASE(A4)	;_cur_ring_1
	BEQ.B	L00A14

	MOVEA.L	_cur_ring_1-BASE(A4),A6	;_cur_ring_1
	CMPI.W	#R_AGGR,$0020(A6)	;aggravate monster
	BEQ.B	L00A15
L00A14:
	TST.L	_cur_ring_2-BASE(A4)	;_cur_ring_2
	BEQ.B	L00A16

	MOVEA.L	_cur_ring_2-BASE(A4),A6	;_cur_ring_2
	CMPI.W	#R_AGGR,$0020(A6)	;aggravate monster
	BNE.B	L00A16
L00A15:
	MOVE.L	$000E(A5),-(A7)
	JSR	_start_run
	ADDQ.W	#4,A7
L00A16:
	MOVE.B	$000D(A5),D3
	CMP.b	#$46,D3		; 'F' flytrap
	BNE.B	1$

	LEA	_f_damage-BASE(A4),A6	;_f_damage
	MOVE.L	A6,$0024(A2)

1$	CMP.b	#$58,D3		; 'X' xerox
	BNE.W	L00A26

	MOVEQ	#$08,D3
	CMPI.W	#25,_level-BASE(A4)	;_level
	BLE.B	L00A18

	ADDQ.w	#$01,D3		;disguise as amulet only from level 25 onwards
L00A18:
	MOVE.W	D3,D0
	JSR	_rnd
;	EXT.L	D0
	BRA.B	L00A24
L00A1A:
	MOVE.B	#$2A,$0010(A2)	;'*' gold
	BRA.B	L00A26
L00A1B:
	MOVE.B	#$21,$0010(A2)	;'!' potion
	BRA.B	L00A26
L00A1C:
	MOVE.B	#$3F,$0010(A2)	;'?' scroll
	BRA.B	L00A26
L00A1D:
	MOVE.B	#$25,$0010(A2)	;'%' exit
	BRA.B	L00A26
L00A1E:
	MOVEq	#$000A,D0
	JSR	_rnd
	ADD.W	#$006D,D0	;m weapon type
	MOVE.B	D0,$0010(A2)
	BRA.B	L00A26
L00A1F:
	MOVEq	#$0008,D0
	JSR	_rnd
	ADD.W	#$0061,D0	;a armor type
	MOVE.B	D0,$0010(A2)
	BRA.B	L00A26
L00A20:
	MOVE.B	#$3D,$0010(A2)	;'=' ring
	BRA.B	L00A26
L00A21:
	MOVE.B	#$2F,$0010(A2)	;'/' wand/staff
	BRA.B	L00A26
L00A22:
	MOVE.B	#$2C,$0010(A2)	;',' amulet of yendor
	BRA.B	L00A26
L00A23:
	dc.w	L00A1A-L00A25	; * gold
	dc.w	L00A1B-L00A25	; ! potion
	dc.w	L00A1C-L00A25	; ? scroll
	dc.w	L00A1D-L00A25	; % exit
	dc.w	L00A1E-L00A25	; mnopqrstuv weapon
	dc.w	L00A1F-L00A25	; abcdefgh armor
	dc.w	L00A20-L00A25	; = ring
	dc.w	L00A21-L00A25	; / wand/staff
	dc.w	L00A22-L00A25	; , amulet of yendor
L00A24:
	CMP.w	#$0009,D0
	BCC.B	L00A26
	ASL.w	#1,D0
	MOVE.W	L00A23(PC,D0.W),D0
L00A25:	JMP	L00A25(PC,D0.W)
L00A26:
	MOVEM.L	(A7)+,D4/A2/A3
	UNLK	A5
	RTS

_f_restor:
;	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)
	CLR.W	-$60A2(A4)	;_fung_hit
	LEA	-$6C26(A4),A2	;venus flytrap struct
	MOVE.L	$0014(A2),-(A7)	;"%%%d0"
	PEA	_f_damage-BASE(A4)	;_f_damage
	JSR	_strcpy
	ADDQ.W	#8,A7
	MOVEA.L	(A7)+,A2
;	UNLK	A5
	RTS

;/*
; * expadd:
; *  Experience to add for this monster's level/hit points
; */

_exp_add:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2,-(A7)
	MOVEA.L	$0008(A5),A2

	MOVE.W	$001E(A2),D0	;creature level

	MOVE.W	$0028(A2),D4	;maxhp
	EXT.L	D4

	CMPI.W	#$0001,D0	;lvl
	BNE.B	L00A27

	LSR.L	#3,D4		;divide by 8 if level is one
	BRA.B	L00A28
L00A27:
	DIVU.W	#6,D4		;divide by 6 otherwise
L00A28:
	CMPI.W	#9,D0		;lvl
	BLE.B	L00A29

	MULU.W	#20,D4		;from level 10 and more
	BRA.B	L00A2A
L00A29:
	CMPI.W	#6,D0		;lvl
	BLE.B	L00A2A

	MULU.W	#4,D4		;from level 6 to 9
L00A2A:
	MOVE.W	D4,D0

	MOVEM.L	(A7)+,D4/A2
	UNLK	A5
	RTS

;/*
; * wanderer:
; *  Create a new wandering monster and aim it at the player
; */

_wanderer:
	LINK	A5,#-$0004
	MOVEM.L	D4/A2/A3,-(A7)

	TST.B	_no_more_fears-BASE(A4)	;_no_more_fears
	BNE.B	L00A2B

	JSR	_new_item
	MOVEA.L	D0,A3
	TST.L	D0
	BNE.B	L00A2C
L00A2B:
	MOVEM.L	(A7)+,D4/A2/A3
	UNLK	A5
	RTS

L00A2C:
	JSR	_rnd_room
	MOVE.W	D0,D4
	MOVE.W	D4,D3
	MULU.W	#$0042,D3
	LEA	_rooms-BASE(A4),A6	;_rooms
	MOVEA.L	D3,A2
	ADDA.L	A6,A2
	CMPA.L	-$52A0(A4),A2	;_player + 42 (proom)
	BEQ.B	L00A2D
	PEA	-$0004(A5)
	MOVE.L	A2,-(A7)
	JSR	_rnd_pos
	ADDQ.W	#8,A7
L00A2D:
	CMPA.L	-$52A0(A4),A2	;_player + 42 (proom)
	BEQ.B	L00A2C
	MOVE.W	-$0004(A5),-(A7)
	MOVE.W	-$0002(A5),-(A7)
	JSR	_winat
	ADDQ.W	#4,A7
	MOVE.W	D0,-(A7)
	JSR	_step_ok
	ADDQ.W	#2,A7
	TST.W	D0
	BEQ.B	L00A2C
	PEA	-$0004(A5)
	MOVE.W	#$0001,-(A7)
	JSR	_randmonster(PC)
	ADDQ.W	#2,A7
	MOVE.W	D0,-(A7)
	MOVE.L	A3,-(A7)
	JSR	_new_monster(PC)
	LEA	$000A(A7),A7
	TST.B	_wizard-BASE(A4)	;_wizard
	BEQ.B	L00A2E

	MOVE.B	$000F(A3),D3
	EXT.W	D3
	SUB.W	#$0041,D3	;'A'
	MULU.W	#26,D3
	LEA	_monsters-BASE(A4),A6	;_monsters
	MOVE.L	$00(A6,D3.L),-(A7)
	PEA	L00A2F(PC)	;"started a wandering %s"
	JSR	_msg
	ADDQ.W	#8,A7
L00A2E:
	PEA	$000A(A3)
	JSR	_start_run
	ADDQ.W	#4,A7
	BRA.W	L00A2B

L00A2F:	dc.b	"started a wandering %s",0,0

;/*
; * wake_monster:
; *  What to do when the hero steps next to a monster
; */

_wake_monster:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5/A2/A3,-(A7)

	MOVE.W	$000A(A5),d1
	MOVE.W	$0008(A5),d0
	JSR	_moatquick

	MOVEA.L	D0,A2
	TST.L	D0
	BNE.B	L00A31

	MOVE.L	A2,D0
L00A30:
	MOVEM.L	(A7)+,D4/D5/A2/A3
	UNLK	A5
	RTS

L00A31:
	MOVE.B	$000F(A2),D4
	MOVE.W	$0016(A2),D3
	AND.W	#C_ISRUN,D3	;C_ISRUN
	BNE.B	L00A34

	MOVEq	#$0003,D0	;33% chance that we do not wake it up
	JSR	_rnd
	TST.W	D0
	BEQ.B	L00A34

	MOVE.W	$0016(A2),D3
	AND.W	#C_ISMEAN,D3	;C_ISMEAN
	BEQ.B	L00A34

	MOVE.W	$0016(A2),D3
	AND.W	#C_ISHELD,D3	;C_ISHELD
	BNE.B	L00A34

	MOVE.L	_cur_ring_1-BASE(A4),D0	;_cur_ring_1
	BEQ.B	L00A32

	MOVEA.L	D0,A6		;_cur_ring_1
	CMPI.W	#R_STEALTH,$0020(A6)	; ring of stealth
	BEQ.B	L00A34
L00A32:
	MOVE.L	_cur_ring_2-BASE(A4),D0	;_cur_ring_2
	BEQ.B	L00A33

	MOVEA.L	D0,A6		;_cur_ring_2
	CMPI.W	#R_STEALTH,$0020(A6)	; ring of stealth
	BEQ.B	L00A34
L00A33:
	LEA	-$52C0(A4),A6	;_player + 10
	MOVE.L	A6,$0012(A2)
	ORI.W	#C_ISRUN,$0016(A2)	;C_ISRUN
L00A34:
	CMP.B	#$4D,D4		;'M' medusa
	BNE.W	L00A39

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;we are blind, so we can't see the medusas gaze
	BNE.W	L00A39

	MOVE.W	$0016(A2),D3
	AND.W	#C_ISFOUND,D3	;she saw us already
	BNE.W	L00A39

	MOVE.W	$0016(A2),D3
	AND.W	#C_ISCANC,D3	;her abilitiy is canceled
	BNE.W	L00A39

	MOVE.W	$0016(A2),D3
	AND.W	#C_ISRUN,D3	;shes coming at us
	BEQ.W	L00A39

	MOVEA.L	-$52A0(A4),A3	;_player + 42 (proom)
	MOVE.W	-$52C0(A4),-(A7)	;_player + 10
	MOVE.W	-$52BE(A4),-(A7)	;_player + 12
	MOVE.W	$000A(A5),-(A7)
	MOVE.W	$0008(A5),-(A7)
	JSR	_DISTANCE
	ADDQ.W	#8,A7
	MOVE.W	D0,D5
	MOVE.L	A3,D3
	BEQ.B	L00A35

	MOVE.L	A3,-(A7)
	JSR	_is_dark
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00A36
L00A35:
	CMP.W	#$0003,D5
	BGE	L00A39
L00A36:
	ORI.W	#C_ISFOUND,$0016(A2)	;C_ISFOUND
	MOVE.W	#VS_MAGIC,-(A7)
	JSR	_save
	ADDQ.W	#2,A7
	TST.W	D0
	BNE.B	L00A39

	MOVEq	#$0014,D0
	JSR	_rnd
	MOVE.W	D0,-(A7)

	MOVEq	#$0014,D0
	JSR	_spread

	MOVE.W	(A7)+,D3
	ADD.W	D0,D3
	MOVE.W	D3,-(A7)

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
2$
	ORI.W	#C_ISHUH,-$52B4(A4)	;set C_ISHUH,_player + 22 (flags)
	PEA	L00A3C(PC)	;"the medusa's gaze has confused you"
	JSR	_msg
	ADDQ.W	#4,A7
L00A39:
	MOVE.W	$0016(A2),D3
	AND.W	#C_ISGREED,D3	;C_ISGREED
	BEQ.B	L00A3B

	MOVE.W	$0016(A2),D3
	AND.W	#C_ISRUN,D3	;C_ISRUN
	BNE.B	L00A3B

	ORI.W	#C_ISRUN,$0016(A2)	;C_ISRUN
	MOVEA.L	-$52A0(A4),A6	;_player + 42 (proom)
	TST.W	$000C(A6)
	BEQ.B	L00A3A

	MOVE.L	-$52A0(A4),D3	;_player + 42 (proom)
	ADDQ.L	#8,D3
	MOVE.L	D3,$0012(A2)
	BRA.B	L00A3B
L00A3A:
	LEA	-$52C0(A4),A6	;_player + 10
	MOVE.L	A6,$0012(A2)
L00A3B:
	MOVE.L	A2,D0
	BRA.W	L00A30

L00A3C:	dc.b	"the medusa's gaze has confused you",0,0

;/*
; * give_pack:
; *  Give a pack to a monster if it deserves one
; */

_give_pack:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	$0008(A5),A2
	CMPI.W	#$0053,_total-BASE(A4)	;83 objects _total
	BGE.B	L00A3D

	MOVEq	#100,D0
	JSR	_rnd
	MOVE.B	$000F(A2),D3
	EXT.W	D3
	SUB.W	#$0041,D3	;'A'
	MULU.W	#26,D3
	LEA	_monsters-BASE(A4),A6	;_monsters
	CMP.W	$04(A6,D3.L),D0	;compare with monster treasure chance
	BGE.B	L00A3D

	JSR	_new_thing
	MOVE.L	D0,-(A7)
	PEA	$002E(A2)
	JSR	__attach
	ADDQ.W	#8,A7
L00A3D:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

;/*
; * save_throw:
; *  See if a creature is save against something
; */

_save_throw:
	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)

	moveq	#14,D4
	ADD.W	$0008(A5),D4

	MOVEA.L	$000A(A5),A6	;creature/player
	MOVE.W	$001E(A6),D2	;rank of player/creature
	EXT.L	D2
	DIVS.W	#$0002,D2
	SUB.W	D2,D4

	MOVE.W	#20,-(A7)	;1d20
	MOVE.W	#1,-(A7)
	JSR	_roll
	ADDQ.W	#4,A7

	CMP.W	D4,D0
	BLT.B	L009D7

	MOVEq	#$0001,D0
	BRA.B	L009D8
L009D7:
	CLR.W	D0
L009D8:
	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

;/*
; * save:
; *  See if he is save against various nasty things
; */

_save:
	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)
	MOVE.W	$0008(A5),D4

	CMP.W	#VS_MAGIC,D4	;VS_MAGIC
	BNE.B	L009DA

	MOVE.L	_cur_ring_1-BASE(A4),D0	;_cur_ring_1
	BEQ.B	L009D9
	MOVEA.L	D0,A6		;_cur_ring_1
	CMP.W	#R_PROTECT,$0020(A6)
	BNE.B	L009D9
	SUB.W	$0026(A6),D4
L009D9:
	MOVE.L	_cur_ring_2-BASE(A4),D0	;_cur_ring_2
	BEQ.B	L009DA
	MOVEA.L	D0,A6		;_cur_ring_2
	CMP.W	#R_PROTECT,$0020(A6)
	BNE.B	L009DA
	SUB.W	$0026(A6),D4
L009DA:
	PEA	_player-BASE(A4)	;_player + 0
	MOVE.W	D4,-(A7)
	JSR	_save_throw(PC)
	ADDQ.W	#6,A7

	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS
