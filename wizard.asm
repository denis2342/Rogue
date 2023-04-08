;/*
; * whatis:
; *  What a certain object is
; */

_whatis:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	$0008(A5),A2	;item to identify
	MOVE.L	A2,D3
	BNE.B	L007B6

	TST.L	_player+46-BASE(A4)	;_player + 46 (pack)
	BNE.B	L007B5

	PEA	L007C2(PC)	;"You don't have anything in your pack to identify"
	JSR	_msg
	ADDQ.W	#4,A7
L007B4:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L007B5:
	MOVE.L	A2,D3
	BNE.B	L007B6

	CLR.W	-(A7)
	PEA	L007C3(PC)	;"identify"
	JSR	_get_item
	ADDQ.W	#6,A7
	MOVEA.L	D0,A2
	TST.L	D0
	BNE.B	L007B6

	PEA	L007C4(PC)	;"You must identify something"
	JSR	_msg
	ADDQ.W	#4,A7
	PEA	L007C5(PC)	;" "
	JSR	_msg
	ADDQ.W	#4,A7
	CLR.W	_mpos-BASE(A4)	;_mpos
	BRA.B	L007B5

L007B6:
	MOVE.L	A2,-(A7)
	JSR	_typeof
	ADDQ.W	#4,A7
;	EXT.L	D0
	BRA.W	L007BE

; scrolls

L007B9:
	MOVE.W	$0020(A2),D3
	LEA	_s_know-BASE(A4),A6	;_s_know
	ST	$00(A6,D3.W)
;	MOVE.W	$0020(A2),D3
	MULU.W	#21,D3
	LEA	_s_guess-BASE(A4),A6	;_s_guess
	CLR.B	$00(A6,D3.L)
	BRA.W	L007BF

; potions

L007BA:
	MOVE.W	$0020(A2),D3
	LEA	_p_know-BASE(A4),A6	;_p_know
	ST	$00(A6,D3.W)
;	MOVE.W	$0020(A2),D3
	MULU.W	#21,D3
	LEA	_p_guess-BASE(A4),A6	;_p_guess
	CLR.B	$00(A6,D3.L)
	BRA.W	L007BF

; wands/staffs

L007BB:
	MOVE.W	$0020(A2),D3
	LEA	_ws_know-BASE(A4),A6	;_ws_know
	ST	$00(A6,D3.W)
	ORI.W	#O_ISKNOW,$0028(A2)
;	MOVE.W	$0020(A2),D3
	MULU.W	#21,D3
	LEA	_ws_guess-BASE(A4),A6	;_ws_guess
	CLR.B	$00(A6,D3.L)
	BRA.B	L007BF

; armor types and weapon types

L007BC:
	ORI.W	#O_ISKNOW,$0028(A2)
	BRA.B	L007BF

; rings

L007BD:
	MOVE.W	$0020(A2),D3
	LEA	_r_know-BASE(A4),A6	;_r_know
	ST	$00(A6,D3.W)
	ORI.W	#O_ISKNOW,$0028(A2)
	MOVE.W	$0020(A2),D3
	MULU.W	#21,D3
	LEA	_r_guess-BASE(A4),A6	;_r_guess
	CLR.B	$00(A6,D3.L)
	BRA.B	L007BF
L007BE:
	SUB.w	#$0021,D0	;'!' potion
	BEQ.B	L007BA
	SUB.w	#$000E,D0	;'/' wand/staff
	BEQ.B	L007BB
	SUB.w	#$000E,D0	;'=' ring
	BEQ.B	L007BD
	SUBQ.w	#2,D0		;'?' scroll
	BEQ.W	L007B9
	SUB.w	#$0022,D0	;'a' armor type
	BEQ.B	L007BC
	SUB.w	#$000C,D0	;'m' weapon type
	BEQ.B	L007BC
L007BF:
	TST.B	$002A(A2)	;has item special feature?
	BEQ.B	L007C0

	ORI.W	#O_SPECKNOWN,$0028(A2)	;set O_SPECKNOWN
L007C0:
	TST.W	$000C(A5)
	BEQ.B	L007C1

	MOVE.W	#$007E,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_nameof
	ADDQ.W	#6,A7

	MOVE.L	D0,-(A7)
	JSR	_msg
	ADDQ.W	#4,A7
L007C1:
	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_pack_name
	ADDQ.W	#6,A7

	MOVE.W	$000A(A2),d6

	; for rings and wands/staff we want to check if there
	; are more items who need an update

	CMP.B	#'/',d6		; wand/staff type
	beq	1$

	CMP.B	#'=',d6		; ring type
	bne	L007B4

1$	bsr	_pack_update

	BRA.W	L007B4

L007C2:	dc.b	"You don't have anything in your pack to identify",0
L007C3:	dc.b	"identify",0
L007C4:	dc.b	"You must identify something",0
L007C5:	dc.b	" ",0

_pack_update:
	move.l	a3,-(a7)
	MOVE.L	_player+46-BASE(A4),a3	;_player + 46 (pack)

;	MOVE.W	$0A(A2),d6	;item type we want to update
	move.w	$20(A2),d5	;subtype

	bra	2$

1$	cmp.l	A2,A3		;don't update twice!
	beq	3$

	cmp.w	$0A(A3),d6	;item type from list same as item type we want to update?
	bne	3$

	cmp.w	$20(a3),d5	;is it even the same subtype?
	bne	3$

	MOVE.W	#$0001,-(A7)
	MOVE.L	A3,-(A7)
	JSR	_pack_name	;update name of item
	ADDQ.W	#6,A7

3$	move.l	(a3),a3		;get next pointer in pack

2$	move.l	a3,d7		;something there?
	bne	1$

	move.l	(a7)+,a3
	rts

;/*
; * create_obj:
; *  wizard command for getting anything he wants
; */

_create_obj:
	LINK	A5,#-$0008

	JSR	_new_item
	MOVE.L	D0,-$0004(A5)
;	TST.L	D0
	BNE.B	L007C7

	PEA	L007ED(PC)	;"can't create anything now"
	JSR	_msg
	ADDQ.W	#4,A7
L007C6:
	UNLK	A5
	RTS

L007C7:
	TST.B	_again-BASE(A4)	;_again
	BNE.B	1$

	PEA	L007EE(PC)	;"type of item: "
	JSR	_msg
	ADDQ.W	#4,A7
	JSR	_readchar
	MOVE.W	D0,create_object_tmp+4-BASE(A4)
1$
	MOVE.W	create_object_tmp+4-BASE(A4),D0

	MOVEA.L	-$0004(A5),A6

	SUB.w	#$0021,D0	; '!' potion
	BEQ.B	L007C9
	SUBQ.w	#8,D0		; ')' weapon
	BEQ.B	L007CD
	SUBQ.w	#1,D0		; '*' gold
	BEQ.B	L007D0b
	SUBQ.w	#2,D0		; ',' amulet of yendor
	BEQ.B	L007CF
	SUBQ.w	#3,D0		; '/' stick
	BEQ.B	L007C9
	SUB.w	#$000E,D0	; '=' ring
	BEQ.B	L007C9
	SUBQ.w	#2,D0		; '?' scroll
	BEQ.B	L007C9
	SUB.w	#$001E,D0	; ']' armor
	BEQ.B	L007CE
;	BRA.B	L007C9		; ':' food

	MOVE.W  #$003A,$000A(A6)	;':' food
	BRA.B	L007D2

L007CD:
	MOVE.W	#$006D,$000A(A6)	; 'm' weapon
	BRA.B	L007D2
L007CE:
	MOVE.W	#$0061,$000A(A6)	; 'a' armor
	BRA.B	L007D2
L007CF:
	MOVE.W	#$002C,$000A(A6)	; ',' amulet of yendor
	BRA	L007EC
L007D0b:
	MOVE.W	#$002A,$000A(A6)	; '*' gold
	BRA	L007EB

L007C9:
	MOVE.W	create_object_tmp+4-BASE(A4),$000A(A6)	; potion, stick, ring, scroll
;	BRA.B	L007D2

L007D2:
	CLR.W	_mpos-BASE(A4)	;_mpos
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$000A(A6),-(A7)
	PEA	L007EF(PC)	;"which %c do you want? (0-f)"
	JSR	_msg
	ADDQ.W	#6,A7
	TST.B	_again-BASE(A4)	;_again
	BEQ.B	L007D3

	MOVE.B	create_object_tmp+3-BASE(A4),create_object_tmp-BASE(A4)
	BRA.B	L007D4
L007D3:
	JSR	_readchar
	MOVE.B	D0,create_object_tmp-BASE(A4)
	MOVEQ	#$00,D3
	MOVE.B	D0,D3
	MOVE.W	D3,create_object_tmp+2-BASE(A4)
L007D4:
	MOVEA.L	-$0004(A5),A6
	MOVE.L	A6,-(A7)
	MOVE.B	create_object_tmp-BASE(A4),D0

	JSR	_isdigit(PC)

	MOVEA.L	(A7)+,A6

	TST.W	D0
	BEQ.B	L007D5

	MOVEQ	#$00,D3
	MOVE.B	create_object_tmp-BASE(A4),D3
	SUB.W	#$0030,D3	; - '0'
	MOVE.W	D3,$0020(A6)
	BRA.B	L007D6
L007D5:
	MOVEQ	#$00,D3
	MOVE.B	create_object_tmp-BASE(A4),D3
	SUB.W	#$0057,D3	; - 'a' + 10
	MOVE.W	D3,$0020(A6)
L007D6:
	MOVEA.L	-$0004(A5),A6
	CLR.W	$002C(A6)	;clear group
;	MOVEA.L	-$0004(A5),A6
	MOVE.W	#$0001,$001E(A6)	;one item
;	MOVEA.L	-$0004(A5),A6
	LEA	L007F0(PC),A1	;"0d0"
	MOVE.L	A1,$001A(A6)
	MOVE.L	$001A(A6),$0016(A6)
	CLR.W	_mpos-BASE(A4)	;_mpos
;	MOVEA.L	-$0004(A5),A6
	CMPI.W	#$006D,$000A(A6)	; 'm' weapon type
	BEQ.B	L007D7

;	MOVEA.L	-$0004(A5),A6
	CMPI.W	#$0061,$000A(A6)	; 'a' armor type
	BNE.W	L007DF
L007D7:
	TST.B	_again-BASE(A4)	;_again
	BNE.B	L007D8

	PEA	L007F1(PC)	;"blessing? (+,-,n)"
	JSR	_msg
	ADDQ.W	#4,A7
	JSR	_readchar
	MOVE.B	D0,create_object_tmp+1-BASE(A4)
	CLR.W	_mpos-BASE(A4)	;_mpos
L007D8:
	CMP.B	#$2D,create_object_tmp+1-BASE(A4)	; '-'
	BNE.B	L007D9

	MOVEA.L	-$0004(A5),A6
	ORI.W	#O_ISCURSED,$0028(A6)	; set curse bit
L007D9:
	MOVEA.L	-$0004(A5),A6
	CMPI.W	#$006D,$000A(A6)	; 'm' weapon
	BNE.B	L007DC

;	MOVEA.L	-$0004(A5),A6
	MOVE.L	A6,-(A7)
	JSR	_init_weapon
	ADDQ.W	#4,A7

	MOVEq	#$0003,D0
	JSR	_rnd
	ADDQ.W	#1,D0
	MOVEA.L	-$0004(A5),A6

	CMP.B	#$2D,create_object_tmp+1-BASE(A4)	; '-'
	BNE.B	1$

	SUB.W	D0,$0022(A6)
1$
	CMP.B	#$2B,create_object_tmp+1-BASE(A4)	; '+'
	BNE.B	L007DB

	ADD.W	D0,$0022(A6)
L007DB:
	BRA.B	L007DE
L007DC:
	MOVEA.L	-$0004(A5),A6
	moveq	#$61,D3		;a armor type
	ADD.W	$0020(A6),D3
	MOVE.W	D3,$000A(A6)
;	MOVEA.L	-$0004(A5),A6
	MOVE.W	$0020(A6),D3
;	EXT.L	D3
	ASL.w	#1,D3
	LEA	_a_class-BASE(A4),A1	;_a_class
	MOVE.W	$00(A1,D3.w),$0026(A6)

	MOVEq	#$0003,D0
	JSR	_rnd
	ADDQ.W	#1,D0
	MOVEA.L	-$0004(A5),A6

	CMP.B	#$2D,create_object_tmp+1-BASE(A4)	; -
	BNE.B	1$

	ADD.W	D0,$0026(A6)
1$
	CMP.B	#$2B,create_object_tmp+1-BASE(A4)	; +
	BNE.B	L007DE

	SUB.W	D0,$0026(A6)
L007DE:
	BRA.W	L007EC
L007DF:
	MOVEA.L	-$0004(A5),A6
	CMPI.W	#$003D,$000A(A6)	; '=' ring
	BNE.W	L007EA

;	MOVEA.L	-$0004(A5),A6
	MOVE.W	$0020(A6),D0
;	EXT.L	D0
	BRA.W	L007E7
L007E0:
	TST.B	_again-BASE(A4)	;_again
	BNE.B	L007E1

	PEA	L007F1(PC)	;"blessing? (+,-,n)"
	JSR	_msg
	ADDQ.W	#4,A7
	JSR	_readchar
	MOVE.B	D0,create_object_tmp+1-BASE(A4)
	CLR.W	_mpos-BASE(A4)	;_mpos
L007E1:
	CMP.B	#$2D,create_object_tmp+1-BASE(A4)	; '-'
	BNE.B	L007E3

	MOVE.W	#-1,$0026(A6)
	BRA.B	L007E5
L007E3:
	MOVE.L	A6,-(A7)
	MOVEq	#$0002,D0
	JSR	_rnd
	ADDQ.W	#1,D0
	MOVEA.L	(A7)+,A6
	MOVE.W	D0,$0026(A6)
	BRA.B	L007E9
L007E5:
	MOVEA.L	-$0004(A5),A6
	ORI.W	#O_ISCURSED,$0028(A6)
	BRA.B	L007E9
L007E6:
	dc.w	L007E0-L007E8	;regeneration, can be good or bad
	dc.w	L007E0-L007E8	;add strength, can be good or bad
	dc.w	L007E9-L007E8	;always good
	dc.w	L007E9-L007E8	;always good
	dc.w	L007E9-L007E8	;always good
	dc.w	L007E9-L007E8	;always good
	dc.w	L007E5-L007E8	;aggravate monster, always cursed
	dc.w	L007E0-L007E8	;dexterity, can be good or bad
	dc.w	L007E0-L007E8	;add damage, can be good or bad
	dc.w	L007E9-L007E8	;always good
	dc.w	L007E9-L007E8	;always good
	dc.w	L007E5-L007E8	;teleportation, always cursed
L007E7:
	CMP.w	#$000C,D0
	BCC.B	L007E9
	ASL.w	#1,D0
	MOVE.W	L007E6(PC,D0.W),D0
L007E8:	JMP	L007E8(PC,D0.W)

L007E9:
	BRA.B	L007EC
L007EA:
	MOVEA.L	-$0004(A5),A6
	CMPI.W	#$002F,$000A(A6)	; '/'
	BNE.B	L007EB

	MOVE.L	-$0004(A5),-(A7)
	JSR	_fix_stick(PC)
	ADDQ.W	#4,A7
	BRA.B	L007EC
L007EB:
	MOVEA.L	-$0004(A5),A6
	CMPI.W	#$002A,$000A(A6)	; '*'
	BNE.B	L007EC

	CLR.W	_mpos-BASE(A4)	;_mpos
	PEA	L007F3(PC)	;"how much? "
	JSR	_msg
	ADDQ.W	#4,A7

	MOVEA.L	-$0004(A5),A6
	PEA	$0026(A6)
	JSR	_get_num(PC)
	ADDQ.W	#4,A7

	CLR.W	_mpos-BASE(A4)	;_mpos

	MOVEA.L	-$0004(A5),A6
	move.w	$0026(A6),-(a7)
	jsr	_money
	addq.l	#2,a7

	JSR	_status
	BRA.W	L007C6

L007EC:
	CLR.L	-(A7)
	MOVE.L	-$0004(A5),-(A7)
	JSR	_add_pack
	ADDQ.W	#8,A7
	BRA.W	L007C6

L007ED:	dc.b	"can't create anything now",0
L007EE:	dc.b	"type of item: ",0
L007EF:	dc.b	"which %c do you want? (0-f)",0
L007F0:	dc.b	"0d0",0
L007F1:	dc.b	"blessing? (+,-,n)",0
L007F3:	dc.b	"how much? ",0

;/*
; * teleport:
; *  Bamf the hero someplace else
; */

_teleport:
	LINK	A5,#-$0004
	MOVE.L	D4,-(A7)

	JSR	_INDEXplayer

	MOVEA.L	__level-BASE(A4),A6	;__level

	MOVE.B	$00(A6,D0.W),D2
	MOVE.W	_player+10-BASE(A4),d1	;_player + 10
	MOVE.W	_player+12-BASE(A4),d0	;_player + 12
	JSR	_mvaddchquick

L007F4:
	JSR	_rnd_room
	MOVE.W	D0,D4
	PEA	-$0004(A5)
	MOVE.W	D4,D3
	MULU.W	#66,D3
	LEA	_rooms-BASE(A4),A6	;_rooms
	ADD.L	A6,D3
	MOVE.L	D3,-(A7)
	JSR	_rnd_pos
	ADDQ.W	#8,A7

	MOVE.W	-$0004(A5),-(A7)
	MOVE.W	-$0002(A5),-(A7)
	JSR	_winat
	ADDQ.W	#4,A7

	MOVE.W	D0,-(A7)
	JSR	_step_ok
	ADDQ.W	#2,A7

	TST.W	D0
	BEQ.B	L007F4

	MOVE.W	D4,D3
	MULU.W	#66,D3
	LEA	_rooms-BASE(A4),A6	;_rooms
	ADD.L	A6,D3
	CMP.L	_player+42-BASE(A4),D3	;_player + 42 (proom)
	BEQ.B	L007F5

	PEA	_player+10-BASE(A4)	;_player + 10
	JSR	_leave_room
	ADDQ.W	#4,A7

	LEA	_player+10-BASE(A4),A6	;_player + 10
	LEA	-$0004(A5),A1
	MOVE.L	(A1)+,(A6)+
	PEA	_player+10-BASE(A4)	;_player + 10
	JSR	_enter_room
	ADDQ.W	#4,A7

	BRA.B	L007F6
L007F5:
	LEA	_player+10-BASE(A4),A6	;_player + 10
	LEA	-$0004(A5),A1
	MOVE.L	(A1)+,(A6)+
	MOVE.W	#$0001,-(A7)
	JSR	_look
	ADDQ.W	#2,A7
L007F6:
	MOVEq	#$0040,d2	;'@' PLAYER
	MOVE.W	_player+10-BASE(A4),d1	;_player + 10
	MOVE.W	_player+12-BASE(A4),d0	;_player + 12
	JSR	_mvaddchquick

	MOVE.W	_player+22-BASE(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISHELD,D3	;C_ISHELD
	BEQ.B	L007F7

	ANDI.W	#~C_ISHELD,_player+22-BASE(A4)	;clear C_ISHELD,_player + 22 (flags)
	JSR	_f_restor
L007F7:
	CLR.W	_no_move-BASE(A4)	;_no_move
	CLR.W	_count-BASE(A4)	;_count
	CLR.B	_running-BASE(A4)	;_running
	JSR	_flush_type

	TST.B	_wizard-BASE(A4)	;_wizard
	BNE.B	L007FA

	MOVE.W	_player+22-BASE(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISHUH,D3	;C_ISHUH
	BEQ.B	L007F8

	MOVEq	#$0004,D0
	JSR	_rnd
	ADDQ.W	#2,D0
	MOVE.W	D0,-(A7)
	PEA	_unconfuse(PC)
	JSR	_lengthen(PC)
	ADDQ.W	#6,A7
	BRA.B	L007F9
L007F8:
	MOVEq	#$0004,D0
	JSR	_rnd
	ADDQ.W	#2,D0
	MOVE.W	D0,-(A7)
	CLR.W	-(A7)
	PEA	_unconfuse(PC)
	JSR	_fuse(PC)
	ADDQ.W	#8,A7
L007F9:
	ORI.W	#C_ISHUH,_player+22-BASE(A4)	;ISHUH,_player + 22 (flags)
L007FA:
	MOVE.W	D4,D0

	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

;/*
; * show_map:
; *  Print out the map for the wizard
; */

_show_map:
	LINK	A5,#-$0000
	MOVEM.L	D4-D6,-(A7)

	MOVEQ	#$01,D4
	BRA.B	L007FF
L007FB:
	MOVEQ	#$00,D5
L007FC:
	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick

	MOVEA.L	__flags-BASE(A4),A6	;__flags
	MOVE.B	$00(A6,D0.W),D6
	AND.W	#F_REAL,D6
	TST.W	D6
	BNE.B	L007FD

	JSR	_standout
L007FD:
	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick
	MOVEA.L	__level-BASE(A4),A6	;__level

	MOVE.B	$00(A6,D0.W),D2
	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_mvaddchquick

	TST.W	D6
	BNE.B	L007FE

	JSR	_standend
L007FE:
	ADDQ.W	#1,D5
	CMP.W	#$003C,D5
	BLT.B	L007FC

	ADDQ.W	#1,D4
L007FF:
	CMP.W	_maxrow-BASE(A4),D4	;_maxrow
	BLT.B	L007FB

	MOVEM.L	(A7)+,D4-D6
	UNLK	A5
	RTS
