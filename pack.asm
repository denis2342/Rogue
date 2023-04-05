;/*
; * leave_pack:
; *  take an item out of the pack
; */

_unpack:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	$0008(A5),A6
	CMPI.W	#$0001,$001E(A6)	;one item?
	BLE.W	L0029E

	TST.W	$000C(A5)	;number of items to unpack
	BEQ.B	L00299

	JSR	_new_item
	MOVEA.L	D0,A2
	TST.L	D0
	BEQ.B	L00297

	MOVEA.L	A2,A6
	MOVEA.L	$0008(A5),A1

	MOVEQ	#$0B,D3
L00295:
	MOVE.L	(A1)+,(A6)+	;we make a copy of the object to split it up
	DBF	D3,L00295
	MOVE.W	(A1)+,(A6)+

	; bugfix, clear old pack_string so it will not be double freed
	clr.l	$0010(A2)

	MOVE.W	#$0001,$001E(A2)	;new object has one item
	MOVEA.L	$0008(A5),A6
	SUBQ.W	#1,$001E(A6)		;old object has one item less

	MOVE.W	#$0001,-(A7)
	MOVE.L	A6,-(A7)
	BSR.B	_pack_name	;update old object because it has one item less
	ADDQ.W	#6,A7

	MOVEA.L	$0008(A5),A6
	TST.W	$002C(A6)	;check for group
	BNE.B	L00296

	SUBQ.W	#1,-$60AA(A4)	;_inpack
L00296:
	MOVE.L	A2,D0
L00297:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L00299:
	MOVEA.L	$0008(A5),A6
	moveq	#1,d3

	TST.W	$001E(A6)	;zero means one item
	BEQ.B	1$

	TST.W	$002C(A6)	;is it in a group?
	BNE.B	1$

	MOVE.W	$001E(A6),D3	;get number of items

1$	SUB.W	D3,-$60AA(A4)	;_inpack
	BRA.B	L0029F
L0029E:
	SUBQ.W	#1,-$60AA(A4)	;_inpack
L0029F:
	MOVE.L	$0008(A5),-(A7)
	PEA	-$529C(A4)	;_player + 46 (pack)
	JSR	__detach
	ADDQ.W	#8,A7

	CLR.W	-(A7)		;zero means just clearing the name
	MOVE.L	$0008(A5),-(A7)
	BSR.B	_pack_name
	ADDQ.W	#6,A7

	MOVEA.L	$0008(A5),A6
	CMPI.W	#$002C,$000A(A6)	;did we unpack the amulet?
	BNE.B	L002A0

	CLR.B	-$66BD(A4)	;_amulet
L002A0:
	MOVE.L	$0008(A5),D0
	BRA.B	L00297

_pack_name:
	LINK	A5,#-$0000
	MOVEM.L	A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	TST.L	$0010(A2)
	BEQ.B	L002A1

	MOVE.L	$0010(A2),-(A7)
	JSR	_free
	ADDQ.W	#4,A7

	CLR.L	$0010(A2)
L002A1:
	TST.W	$000C(A5)	;zero here means we just delete the entry
	BEQ.B	L002A2

	MOVE.W	#$FFFF,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_nameof
	ADDQ.W	#6,A7

	MOVEA.L	D0,A0
	MOVE.L	A0,-(A7)
	JSR	_strlenquick

	ADDQ.W	#1,D0
	MOVE.W	D0,-(A7)
	JSR	_newmem
	ADDQ.W	#2,A7

	MOVE.L	D0,-(A7)
	JSR	_strcpy
	ADDQ.W	#8,A7
	MOVE.L	D0,$0010(A2)
L002A2:
	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

;/*
; * pack_char:
; *  Return the next unused pack character.
; */

_pack_obj:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2,-(A7)

	MOVEA.L	-$529C(A4),A2	;_player + 46 (pack)
	MOVEQ	#$61,D4	;'a'
	BRA.B	L002A6

L002A3:
	CMP.B	$0009(A5),D4
	BEQ.B	L002A5

	MOVEA.L	(A2),A2		;get next item from pack
	ADDQ.B	#1,D4
L002A6:
	MOVE.L	A2,D3		;null check for item
	BNE.B	L002A3

	MOVEA.L	$000A(A5),A6
	MOVE.B	D4,(A6)
	MOVEQ	#$00,D0
	BRA.B	L002A4

L002A5:
	MOVE.L	A2,D0
L002A4:
	MOVEM.L	(A7)+,D4/A2
	UNLK	A5
	RTS

;/*
; * add_pack:
; *  Pick up an object and add it to the pack.  If the argument is
; *  non-null use it as the linked_list pointer instead of gettting
; *  it off the ground.
; */

_add_pack:
	LINK	A5,#-$0000
	MOVEM.L	D4-D7/A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVE.L	A2,D3
	BNE.B	L002A9

	MOVEQ	#$01,D6

	MOVE.W	-$52C0(A4),-(A7)	;_player + 10
	MOVE.W	-$52BE(A4),-(A7)	;_player + 12
	JSR	_find_obj
	ADDQ.W	#4,A7

	MOVEA.L	D0,A2
	TST.L	D0
	BNE.B	L002AA
L002A7:
	MOVEM.L	(A7)+,D4-D7/A2/A3
	UNLK	A5
	RTS

L002A9:
	MOVEQ	#$00,D6
L002AA:
	MOVEA.L	-$52A0(A4),A6	;_player + 42 (proom)
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3	;ISGONE?

	BEQ.B	L002AB
	MOVEQ	#$23,D3		;'#' PASSAGE
	BRA.B	L002AC
L002AB:
	MOVEQ	#$2E,D3		;'.' FLOOR
L002AC:
	MOVE.B	D3,D7
	TST.W	$002C(A2)	;is it in a group?
	BEQ.B	L002B1

	MOVEA.L	-$529C(A4),A3	;_player + 46 (pack)
	BRA.B	L002B0
L002AD:
	MOVE.W	$002C(A3),D3
	CMP.W	$002C(A2),D3	;compare groups
	BNE.B	L002AF

	MOVE.W	$001E(A2),D3	;how many items was it
	ADD.W	D3,$001E(A3)
	TST.B	D6
	BEQ.B	L002AE

	MOVE.L	A2,-(A7)
	PEA	-$6CB0(A4)	;_lvl_obj
	JSR	__detach
	ADDQ.W	#8,A7

	MOVE.B	D7,D2
	MOVE.W	-$52C0(A4),d1	;_player + 10
	MOVE.W	-$52BE(A4),d0	;_player + 12
	JSR	_mvaddchquick

	JSR	_INDEXplayer

	MOVEA.L	__level-BASE(A4),A6	;__level
	MOVE.B	D7,$00(A6,D0.W)
L002AE:
	MOVE.L	A2,-(A7)
	JSR	_discard
	ADDQ.W	#4,A7
	MOVEA.L	A3,A2
	BRA.W	L002C6
L002AF:
	MOVEA.L	(A3),A3		;get next item from player pack
L002B0:
	MOVE.L	A3,D3		;and repeat the check if there is one
	BNE.B	L002AD

L002B1:
	CMPI.W	#22,-$60AA(A4)	;_inpack, max items in inventory
	BLT.B	L002B2

	PEA	L002CC(PC)	;"you can't carry anything else"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L002A7
L002B2:
	CMPI.W	#$003F,$000A(A2)	;'?' scroll
	BNE.B	L002B4

	CMPI.W	#S_SCAREM,$0020(A2)	;scroll of scare monster
	BNE.B	L002B4

	MOVE.W	$0028(A2),D3		;load object flags
	AND.W	#O_SCAREUSED,D3	;unused?
	BEQ.B	L002B3

	MOVE.L	A2,-(A7)
	PEA	-$6CB0(A4)	;_lvl_obj
	JSR	__detach
	ADDQ.W	#8,A7

	MOVE.B	D7,D2
	MOVE.W	-$52C0(A4),d1	;_player + 10
	MOVE.W	-$52BE(A4),d0	;_player + 12
	JSR	_mvaddchquick

	JSR	_INDEXplayer

	MOVEA.L	__level-BASE(A4),A6	;__level
	MOVE.B	D7,$00(A6,D0.W)

	LEA	L002CE(PC),a0	;" as you pick it up"
	JSR	_noterse

	MOVE.L	D0,-(A7)
	PEA	L002CD(PC)	;"the scroll turns to dust%s."
	JSR	_msg
	ADDQ.W	#8,A7

	BRA.W	L002A7
L002B3:
	ORI.W	#O_SCAREUSED,$0028(A2)	;set scare bit used
L002B4:
	ADDQ.W	#1,-$60AA(A4)	;_inpack++
	TST.B	D6
	BEQ.B	L002B5

	MOVE.L	A2,-(A7)
	PEA	-$6CB0(A4)	;_lvl_obj
	JSR	__detach
	ADDQ.W	#8,A7

	MOVE.B	D7,D2
	MOVE.W	-$52C0(A4),d1	;_player + 10
	MOVE.W	-$52BE(A4),d0	;_player + 12
	JSR	_mvaddchquick

	JSR	_INDEXplayer

	MOVEA.L	__level-BASE(A4),A6	;__level
	MOVE.B	D7,$00(A6,D0.W)
L002B5:
	MOVEQ	#$00,D5
	MOVEA.L	-$529C(A4),A3	;_player + 46 (pack)

	MOVE.L	A2,-(A7)
	JSR	_typeof
	ADDQ.W	#4,A7
	move.b	D0,D7		;keep the type of the item we are looking for in D7

	BRA.B	L002B7
L002B6:
	MOVE.L	A3,-(A7)
	JSR	_typeof
	ADDQ.W	#4,A7

	CMP.B	D7,D0		;both items of the same type?
	BEQ.B	L002B8

	MOVEA.L	(A3),A3		;if not load the next item in pack
L002B7:
	MOVE.L	A3,D3		;and if there is one repeat the check
	BNE.B	L002B6
L002B8:
	MOVE.L	A3,D3		;did we find something?
	BNE.B	L002BC

	MOVEA.L	-$529C(A4),A3	;_player + 46 (pack)
	BRA.B	L002BA
L002B9:
	CMPI.W	#$003A,$000A(A3)	;':' food
	BNE.B	L002BE

	MOVE.L	A3,D4		;if we had food rembember the pointer to it
	MOVEA.L	(A3),A3		;and get the next item in pack
L002BA:
	MOVE.L	A3,D3
	BNE.B	L002B9
	BRA.B	L002BE		;we maybe have the last match in D4
L002BC:
	MOVE.L	A2,-(A7)
	JSR	_typeof
	ADDQ.W	#4,A7

	MOVE.B	D0,D7
L002BCb:
	MOVE.L	A3,-(A7)
	JSR	_typeof
	ADDQ.W	#4,A7

	CMP.B	D7,D0		;compare the types
	BNE.B	L002BE

	MOVE.W	$0020(A3),D3	;compare the subtypes
	CMP.W	$0020(A2),D3
	BNE.B	L002BD

	MOVEQ	#$01,D5
	BRA.B	L002BE
L002BD:
	MOVE.L	A3,D4		;found a match, remember it
	MOVEA.L	(A3),A3
	MOVE.L	A3,D3
	BEQ.B	L002BE
	BRA.B	L002BCb
L002BE:
	MOVE.L	A3,D3		;is there another item in the pack?
	BNE.B	L002C1

	TST.L	-$529C(A4)	;_player + 46 (pack)
	BNE.B	L002BF

	MOVE.L	A2,-$529C(A4)	;_player + 46 (pack)
	BRA.B	L002C6
L002BF:
	MOVEA.L	D4,A6
	MOVE.L	A2,(A6)
	MOVE.L	D4,$0004(A2)
	CLR.L	(A2)
	BRA.B	L002C6
L002C1:
	TST.B	D5
	BEQ.B	L002C3
	CMPI.W	#$0021,$000A(A2)	;'!' potion
	BEQ.B	L002C2
	CMPI.W	#$003F,$000A(A2)	;'?' scroll
	BEQ.B	L002C2
	CMPI.W	#$003A,$000A(A2)	;':' food
	BEQ.B	L002C2
	CMPI.W	#$002A,$000A(A2)	;'*' gold
	BNE.B	L002C3
L002C2:
	ADDQ.W	#1,$001E(A3)	;one item

	MOVE.L	A2,-(A7)
	JSR	_discard
	ADDQ.W	#4,A7
	MOVEA.L	A3,A2
	BRA.B	L002C6

L002C3:
	MOVE.L	$0004(A3),$0004(A2)
;	TST.L	$0004(A3)
	BEQ.B	L002C4

	MOVEA.L	$0004(A2),A6
	MOVE.L	A2,(A6)
	BRA.B	L002C5
L002C4:
	MOVE.L	A2,-$529C(A4)	;_player + 46 (pack)
L002C5:
	MOVE.L	A3,(A2)
	MOVE.L	A2,$0004(A3)
L002C6:
	MOVEA.L	_mlist-BASE(A4),A3	;_mlist
	BRA.B	L002C9
L002C7:
	MOVEA.L	A2,A6
	ADDA.L	#$0000000C,A6
	CMPA.L	$0012(A3),A6
	BNE.B	L002C8

	LEA	-$52C0(A4),A6	;_player + 10
	MOVE.L	A6,$0012(A3)
L002C8:
	MOVEA.L	(A3),A3
L002C9:
	MOVE.L	A3,D3
	BNE.B	L002C7

	CMPI.W	#$002C,$000A(A2)	;',' amulet of yendor
	BNE.B	L002CA

	ST	-$66BD(A4)	;_amulet
	ST	-$66BC(A4)	;_saw_amulet
L002CA:
	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_pack_name(PC)
	ADDQ.W	#6,A7

	TST.B	$000D(A5)
	BNE.B	L002CB

	MOVE.L	A2,-(A7)
	JSR	_pack_char(PC)
	ADDQ.W	#4,A7

	MOVE.W	D0,-(A7)
	MOVE.W	#$005E,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_nameof
	ADDQ.W	#6,A7

	MOVE.L	D0,-(A7)
	PEA	L002CF(PC)	;"You now have %s(%c)."
	JSR	_msg
	LEA	$000A(A7),A7
L002CB:
	BRA.W	L002A7

L002CC:	dc.b	"you can't carry anything else",0
L002CD:	dc.b	"the scroll turns to dust%s.",0
L002CE:	dc.b	" as you pick it up",0
L002CF:	dc.b	"You now have %s(%c).",0

;/*
; * inventory:
; *  List what is in the pack.  Return TRUE if there is something of
; *  the given type.
; */

_inventory:
	LINK	A5,#-$0056
	MOVEM.L	D4-D7,-(A7)

	MOVE.W	$000C(A5),D4
	MOVEQ	#$00,D6
	JSR	_clr_sel_chr
	MOVEQ	#$61,D5		;'a'
	BRA.W	L002D6
L002D0:
	MOVE.L	$0008(A5),-(A7)
	JSR	_typeof
	ADDQ.W	#4,A7
	MOVE.W	D0,D7
	TST.W	D4
	BEQ.B	L002D2

	CMP.W	D7,D4
	BEQ.B	L002D2

	CMP.W	#$FFFF,D4	; -1
	BNE.B	L002D1

	CMP.W	#$003F,D7	; '?' scroll
	BEQ.B	L002D2
	CMP.W	#$0021,D7	; '!' potion
	BEQ.B	L002D2
	CMP.W	#$003D,D7	; '=' ring
	BEQ.B	L002D2
	CMP.W	#$002F,D7	; '/' stick
	BEQ.B	L002D2
L002D1:
	CMP.W	#$006D,D4	; 'm' weapon type
	BNE.B	L002D5
	CMP.W	#$0021,D7	; '!' potion
	BNE.B	L002D5
L002D2:
	ADDQ.W	#1,D6
	MOVEQ	#$00,D3
	MOVE.B	D5,D3
	MOVE.W	D3,-(A7)
	PEA	L002DA(PC)	;"%c)   %%s"
	PEA	-$0050(A5)
	JSR	_sprintf
	LEA	$000A(A7),A7

	MOVEA.L	$0008(A5),A6
	MOVE.L	$0010(A6),-(A7)		;print pack_name
	PEA	-$0050(A5)
	MOVE.L	$000E(A5),-(A7)
	JSR	_add_line
	LEA	$000C(A7),A7

	MOVE.W	D0,-$0056(A5)
	CMPI.W	#$0020,-$0056(A5)
	BEQ.B	L002D4

	CLR.W	-$54BC(A4)	;former function _end_add() inlined
	CLR.B	-$54BA(A4)
	JSR	_wmap

	MOVE.W	-$0056(A5),D0
L002D3:
	MOVEM.L	(A7)+,D4-D7
	UNLK	A5
	RTS

L002D4:
	PEA	-$0054(A5)
	PEA	-$0052(A5)
	JSR	_getrc
	ADDQ.W	#8,A7

	MOVEq	#$0002,d1
	MOVE.W	-$0052(A5),d0
	JSR	_movequick

	MOVEA.L	$0008(A5),A6
	MOVE.W	$000A(A6),-(A7)
	JSR	__graphch(PC)
	ADDQ.W	#2,A7
L002D5:
	ADDQ.B	#1,D5
	MOVEA.L	$0008(A5),A6
	MOVE.L	(A6),$0008(A5)
L002D6:
	TST.L	$0008(A5)
	BNE.W	L002D0

	TST.W	D6
	BNE.B	L002D9

	TST.W	D4
	BNE.B	L002D7

	LEA	L002DB(PC),A6	;"you are empty handed"
	MOVE.L	A6,D3
	BRA.B	L002D8
L002D7:
	LEA	L002DC(PC),A6	;"you don't have anything appropriate"
	MOVE.L	A6,D3
L002D8:
	MOVE.L	D3,-(A7)
	JSR	_msg
	ADDQ.W	#4,A7
	MOVEQ	#$00,D0
	BRA.B	L002D3
L002D9:
	MOVE.L	$000E(A5),-(A7)
	JSR	_end_line
	ADDQ.W	#4,A7
	BRA.B	L002D3

L002DA:	dc.b	"%c)   %%s",0
L002DB:	dc.b	"you are empty handed",0
L002DC:	dc.b	"you don't have anything appropriate",0,0

;/*
; * pick_up:
; *  Add something to characters pack.
; */

_pick_up:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	CMP.b	#$2A,$0009(A5)	;'*' gold
	BNE.B	L002DF

	MOVE.W	-$52C0(A4),-(A7)	;_player + 10
	MOVE.W	-$52BE(A4),-(A7)	;_player + 12
	JSR	_find_obj
	ADDQ.W	#4,A7
	MOVEA.L	D0,A2
	TST.L	D0
	BEQ.B	L002DD

	MOVE.W	$0026(A2),-(A7)
	JSR	_money(PC)
	ADDQ.W	#2,A7

	MOVE.L	A2,-(A7)
	PEA	-$6CB0(A4)	;_lvl_obj
	JSR	__detach
	ADDQ.W	#8,A7

	MOVE.L	A2,-(A7)
	JSR	_discard
	ADDQ.W	#4,A7

	MOVEA.L	-$52A0(A4),A6	;_player + 42 (proom)
	CLR.W	$000C(A6)
	BRA.B	L002DD

L002DF:
	CLR.L	-(A7)
	CLR.L	-(A7)
	JSR	_add_pack(PC)
	ADDQ.W	#8,A7
L002DD:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

;/*
; * get_item:
; *  Pick something out of a pack for a purpose
; */

_get_item:
	LINK	A5,#-$0004
	MOVEM.L	D4/A2,-(A7)
	CLR.W	-$0004(A5)
	CMP.B	#$02,-$66AA(A4)	;_menu_style
	BNE.B	L002E1

	PEA	L002F2(PC)	;"eat"
	MOVE.L	$0008(A5),-(A7)
	JSR	_strcmp
	ADDQ.W	#8,A7
	TST.W	D0
	BEQ.B	L002E1

	PEA	L002F3(PC)	;"drop"
	MOVE.L	$0008(A5),-(A7)
	JSR	_strcmp
	ADDQ.W	#8,A7
	TST.W	D0
	BNE.B	L002E2
L002E1:
	CMP.B	#$01,-$66AA(A4)	;_menu_style
	BEQ.B	L002E2

	TST.B	-$66B1(A4)	;_com_from_menu
	BEQ.B	L002E3
L002E2:
	MOVE.W	#$0001,-$0004(A5)
L002E3:
	MOVE.B	-$66F7(A4),-$0002(A5)	;_again
	TST.L	-$529C(A4)	;_player + 46 (pack)
	BNE.B	L002E4

	PEA	L002F4(PC)	;"you aren't carrying anything"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L002F1
L002E4:
	MOVE.B	-$54DC(A4),D4
L002E5:
	TST.B	-$0002(A5)
	BEQ.B	L002E6

	PEA	-$0001(A5)
	MOVEQ	#$00,D3
	MOVE.B	D4,D3
	MOVE.W	D3,-(A7)
	JSR	_pack_obj(PC)
	ADDQ.W	#6,A7
	CMP.L	-$77B0(A4),D0
	BEQ.B	L002E9
L002E6:
	TST.W	-$0004(A5)
	BEQ.B	L002E7

	MOVEQ	#$2A,D4		;'*'
	BRA.B	L002E9
L002E7:
	TST.B	_terse-BASE(A4)	;_terse
	BNE.B	L002E8

	TST.B	_expert-BASE(A4)	;_expert
	BNE.B	L002E8

	PEA	L002F5(PC)	;"which object do you want to "
	JSR	_addmsg
	ADDQ.W	#4,A7
L002E8:
	MOVE.L	$0008(A5),-(A7)
	PEA	L002F6(PC)	;"%s? (* for list): "
	JSR	_msg
	ADDQ.W	#8,A7
	MOVE.B	#$01,-$66B0(A4)	;_want_click
	JSR	_readchar
	MOVE.B	D0,D4
	CLR.B	-$66B0(A4)	;_want_click
L002E9:
	CLR.W	_mpos-BASE(A4)	;_mpos
	CLR.B	-$0002(A5)
	CLR.W	-$0004(A5)
	CMP.B	#$2A,D4		;'*'
	BNE.B	L002EC

	MOVE.L	$0008(A5),-(A7)
	MOVE.W	$000C(A5),-(A7)
	MOVE.L	-$529C(A4),-(A7)	;_player + 46 (pack)
	JSR	_inventory(PC)
	LEA	$000A(A7),A7
	MOVE.B	D0,D4
	TST.B	D0
	BNE.B	L002EB

	CLR.B	_after-BASE(A4)	;_after
	MOVEQ	#$00,D0
L002EA:
	MOVEM.L	(A7)+,D4/A2
	UNLK	A5
	RTS

L002EB:
	CMP.B	#$20,D4		;' '
	BEQ.B	L002F0

	MOVE.B	D4,-$54DC(A4)
L002EC:
	CMP.B	#$1B,D4		;escape
	BNE.B	L002ED

	CLR.B	_after-BASE(A4)	;_after
	PEA	L002F7(PC)
	JSR	_msg
	ADDQ.W	#4,A7
	MOVEQ	#$00,D0
	BRA.B	L002EA
L002ED:
	PEA	-$0001(A5)
	MOVEQ	#$00,D3
	MOVE.B	D4,D3
	MOVE.W	D3,-(A7)
	JSR	_pack_obj(PC)
	ADDQ.W	#6,A7
	MOVEA.L	D0,A2
	TST.L	D0
	BNE.B	L002EE

	MOVEQ	#$00,D3
	MOVE.B	-$0001(A5),D3
	SUBQ.W	#1,D3
	MOVE.W	D3,-(A7)
	PEA	L002F9(PC)	;"please specify a letter between 'a' and '%c'"
	PEA	L002F8(PC)	;"range is 'a' to '%c'"
	JSR	_ifterse(PC)
	LEA	$000A(A7),A7
	BRA.B	L002F0
L002EE:
	PEA	L002FA(PC)	;"identify"
	MOVE.L	$0008(A5),-(A7)
	JSR	_strcmp
	ADDQ.W	#8,A7
	TST.W	D0
	BEQ.B	L002EF

	MOVE.B	D4,-$54DC(A4)
	MOVE.L	A2,-$77B0(A4)
L002EF:
	MOVE.L	A2,D0
	BRA.W	L002EA
L002F0:
	BRA.W	L002E5
L002F1:
	MOVEQ	#$00,D0
	BRA.W	L002EA

L002F2:	dc.b	"eat",0
L002F3:	dc.b	"drop",0
L002F4:	dc.b	"you aren't carrying anything",0
L002F5:	dc.b	"which object do you want to ",0
L002F6:	dc.b	"%s? (* for list): ",0
L002F7:	dc.b	$00
L002F8:	dc.b	"range is 'a' to '%c'",0
L002F9:	dc.b	"please specify a letter between 'a' and '%c'",0
L002FA:	dc.b	"identify",0

;/*
; * pack_char:
; *  Return the next unused pack character.
; */

_pack_char:
	MOVEA.L	$0004(A7),A1
	MOVEQ	#'a',D1
	MOVEA.L	-$529C(A4),A0	;_player + 46 (pack)
	BRA.B	L002FE
L002FB:
	CMPA.L	A1,A0
	BEQ.B	L002FD

	ADDQ.B	#1,D1
	MOVEA.L	(A0),A0		;get next pointer in pack
L002FE:
	MOVE.L	A0,D3		;got an item?
	BNE.B	L002FB

	MOVEQ	#$3F,D0		;return '?' if empty
L002FC:
	RTS

L002FD:	MOVE.L	D1,D0
	BRA.B	L002FC

;/*
; * money:
; *  Add or subtract gold from the pack
; */

_money:
	LINK	A5,#-$0000
	MOVE.L	D5,-(A7)

	MOVEA.L	-$52A0(A4),A6	;_player + 42 (room)
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3	;ISGONE
	BEQ.B	1$

	MOVEQ	#$23,D5		;'#' passage
	BRA.B	2$
1$
	MOVEQ	#$2E,D5		;'.' floor
2$
	MOVE.B	D5,D2
	MOVE.W	-$52C0(A4),d1	;_player + 10
	MOVE.W	-$52BE(A4),d0	;_player + 12
	JSR	_mvaddchquick

	JSR	_INDEXplayer

	MOVEA.L	__level-BASE(A4),A6	;__level
	MOVE.B	D5,$00(A6,D0.W)

	MOVE.W	$0008(A5),D3
	ADD.W	D3,_purse-BASE(A4)	;_purse
	CMP.W	#$0000,D3	;no gold?
	BLE.B	3$

	MOVE.W	D3,-(A7)
	PEA	L00302(PC)	;"you found %d gold pieces"
	JSR	_msg
	ADDQ.W	#6,A7
3$
	MOVE.L	(A7)+,D5
	UNLK	A5
	RTS

L00302:	dc.b	"you found %d gold pieces",0,0

