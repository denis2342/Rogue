;/*
; * read_scroll:
; *  Read a scroll from the pack and do the appropriate thing
; */

_read_scroll:
	LINK	A5,#-$0006
	MOVEM.L	D4-D7/A2/A3,-(A7)
	MOVEA.L	$0008(A5),A2
	CLR.B	-$0001(A5)
	MOVE.L	A2,D3
	BNE.B	L001A5
	MOVE.W	#$003F,-(A7)	;'?' scroll type
	PEA	L001E7(PC)	;"read"
	JSR	_get_item
	ADDQ.W	#6,A7
	MOVEA.L	D0,A2
L001A5:
	MOVE.L	A2,D3
	BNE.B	L001A7
L001A6:
	MOVEM.L	(A7)+,D4-D7/A2/A3
	UNLK	A5
	RTS

L001A7:
	CMPI.W	#$003F,$000A(A2)	;'?' is it a scroll?
	BEQ.B	L001A8

	PEA	L001E8(PC)	;"there is nothing on it to read"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L001A6
L001A8:
	CMPI.W	#S_WILDMAGIC,$0020(A2)	;for scrolls of wild magic, wisdom does not apply
	BEQ.B	L001AA

	MOVE.L	A2,-(A7)
	JSR	_check_wisdom
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L001A9
	BRA.B	L001A6
L001A9:
	PEA	L001EA(PC)	;"as you read the scroll, it vanishes"
	PEA	L001E9(PC)	;"the scroll vanishes"
	JSR	_ifterse(PC)
	ADDQ.W	#8,A7

	CMPA.L	-$5298(A4),A2	;scroll is _cur_weapon?
	BNE.B	L001AA

	CLR.L	-$5298(A4)	;clear _cur_weapon
L001AA:
	MOVE.W	$0020(A2),D0
;	EXT.L	D0
	BRA.W	L001E4

; monster confusion scroll

L001AB:
	ORI.W	#C_CANHUH,-$52B4(A4)	;set C_CANHUH,_player + 22 (flags)
	PEA	L001EB(PC)	;"your hands begin to glow red"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L001E6

; enchant armor scroll

L001AC:
	TST.L	-$5294(A4)	;_cur_armor
	BEQ.B	L001AD
	MOVEA.L	-$5294(A4),A6	;_cur_armor
	SUBQ.W	#1,$0026(A6)
;	MOVEA.L	-$5294(A4),A6	;_cur_armor
	ANDI.W	#~O_ISCURSED,$0028(A6)	;clear O_ISCURSED bit
	MOVE.W	#$0001,-(A7)
	MOVE.L	-$5294(A4),-(A7)	;_cur_armor
	JSR	_pack_name
	ADDQ.W	#6,A7
	PEA	L001ED(PC)	;"your armor glows faintly for a moment"
	PEA	L001EC(PC)	;"your armor glows faintly"
	JSR	_ifterse(PC)
	ADDQ.W	#8,A7
L001AD:
	BRA.W	L001E6

; hold monster scroll

L001AE:
	MOVE.W	-$52C0(A4),D5	;_player + 10
	SUBQ.W	#3,D5
	BRA.B	L001B4
L001AF:
	CMP.W	#$0000,D5
	BLT.B	L001B3
	CMP.W	#$003C,D5
	BGE.B	L001B3
	MOVE.W	-$52BE(A4),D4	;_player + 12
	SUBQ.W	#3,D4
	BRA.B	L001B2
L001B0:
	CMP.W	#$0000,D4
	BLE.B	L001B1
	CMP.W	-$60BC(A4),D4	;_maxrow
	BGE.B	L001B1

	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_moatquick

	MOVEA.L	D0,A3
	TST.L	D0
	BEQ.B	L001B1
	ANDI.W	#~C_ISRUN,$0016(A3)	;clear C_ISRUN
	ORI.W	#C_ISHELD,$0016(A3)	;set C_ISHELD
L001B1:
	ADDQ.W	#1,D4
L001B2:
	MOVE.W	-$52BE(A4),D3	;_player + 12
	ADDQ.W	#3,D3
	CMP.W	D3,D4
	BLE.B	L001B0
L001B3:
	ADDQ.W	#1,D5
L001B4:
	MOVE.W	-$52C0(A4),D3	;_player + 10
	ADDQ.W	#3,D3
	CMP.W	D3,D5
	BLE.B	L001AF
	BRA.W	L001E6

; sleep scroll

L001B5:
	ST	-$66F3(A4)	;_s_know + 3 "sleep"

	MOVEq	#$0005,D0
	JSR	_spread

	MOVE.W	D0,D0
	JSR	_rnd
	ADDQ.W	#4,D0

	ADD.W	D0,-$60AC(A4)	;_no_command

	ANDI.W	#~C_ISRUN,-$52B4(A4)	;clear C_ISRUN, _player + 22 (flags)
	PEA	L001EE(PC)	;"you fall asleep"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L001E6

; create monster scroll

L001B6:
	PEA	-$0006(A5)
	MOVE.W	-$52C0(A4),-(A7)	;_player + 10
	MOVE.W	-$52BE(A4),-(A7)	;_player + 12
	JSR	_plop_monster(PC)
	ADDQ.W	#8,A7
	TST.W	D0
	BEQ.B	L001B7

	JSR	_new_item
	MOVEA.L	D0,A3
	TST.L	D0
	BEQ.B	L001B7

	PEA	-$0006(A5)
	CLR.L	-(A7)
	JSR	_randmonster
	ADDQ.W	#4,A7
	MOVE.W	D0,-(A7)
	MOVE.L	A3,-(A7)
	JSR	_new_monster
	LEA	$000A(A7),A7
	BRA.B	L001B8
L001B7:
	PEA	L001F0(PC)	;"you hear a faint cry of anguish in the distance"
	PEA	L001EF(PC)	;"you hear a faint cry of anguish"
	JSR	_ifterse(PC)
	ADDQ.W	#8,A7
L001B8:
	BRA.W	L001E6

; identify scroll

L001B9:
	ST	-$66F1(A4)	;_s_know + 5 "identify"
	PEA	L001F1(PC)	;"this scroll is an identify scroll"
	JSR	_msg
	ADDQ.W	#4,A7
	TST.B	-$66AA(A4)	;_menu_style
	BEQ.B	L001BA

	PEA	L001F2(PC)	;" More "
	JSR	_more(PC)
	ADDQ.W	#4,A7
L001BA:
	MOVE.W	#$0001,-(A7)
	CLR.L	-(A7)
	JSR	_whatis
	ADDQ.W	#6,A7
	BRA.W	L001E6

; magic mapping scroll

L001BB:
	ST	-$66F5(A4)	;_s_know + 1 "magic mapping"
	PEA	L001F3(PC)	;"oh, now this scroll has a map on it"
	JSR	_msg
	ADDQ.W	#4,A7
	MOVEQ	#$01,D4
	BRA.W	L001C6
L001BC:
	MOVEQ	#$00,D5
L001BD:
	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick

	MOVE.W	D0,D7
	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	$00(A6,D7.W),D6
	MOVEQ	#$00,D0
	MOVE.B	D6,D0
	BRA.B	L001C2
L001BE:
	MOVEA.L	-$5198(A4),A6	;__flags
	MOVE.B	$00(A6,D7.W),D3
	AND.W	#F_REAL,D3
	BNE.B	L001BF

	MOVEA.L	-$519C(A4),A6	;__level
	MOVEQ	#$2B,D6		;'+' DOOR
	MOVE.B	D6,$00(A6,D7.W)
	MOVEA.L	-$5198(A4),A6	;__flags
	ANDI.B	#~F_REAL,$00(A6,D7.W)
L001BF:
	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_moatquick

	MOVEA.L	D0,A3
	TST.L	D0
	BEQ.B	L001C3

	CMP.B	#$20,$0011(A3)	; SPACE
	BNE.B	L001C3

	MOVE.B	D6,$0011(A3)
	BRA.B	L001C3
L001C2:
	SUB.w	#$0023,D0	;'#'
	BEQ.B	L001BF
	SUBQ.w	#2,D0		;'%'
	BEQ.B	L001BF
	SUBQ.w	#6,D0		;'+'
	BEQ.B	L001BF
	SUBQ.w	#2,D0		;'-'
	BEQ.B	L001BE
	SUB.w	#$000F,D0	;'<'
	BEQ.B	L001BE
	SUBQ.w	#2,D0		;'>'
	BEQ.B	L001BE
	SUB.w	#$003D,D0	;'{'
	BEQ.B	L001BE
	SUBQ.w	#1,D0		;'|'
	BEQ.B	L001BE
	SUBQ.w	#1,D0		;'}'
	BEQ.B	L001BE

	MOVEQ	#$20,D6		;' '
	BRA.B	L001C3
L001C3:
	CMP.B	#$2B,D6		;'+'
	BNE.B	L001C4

	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_movequick

	JSR	_inch(PC)
	CMP.W	#$002B,D0	;'+'
	BEQ.B	L001C4
	JSR	_standout
L001C4:
	CMP.B	#$20,D6		;' '
	BEQ.B	L001C5

	MOVE.W	D6,d2
	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_mvaddchquick

L001C5:
	JSR	_standend
	ADDQ.W	#1,D5
	CMP.W	#$003C,D5	;'<'
	BLT.W	L001BD

	ADDQ.W	#1,D4
L001C6:
	CMP.W	-$60BC(A4),D4	;_maxrow
	BLT.W	L001BC

	BRA.W	L001E6

; wild magic scroll

L001C7:
	PEA	L001F4(PC)	;"This is a scroll of wild magic"
	JSR	_msg
	ADDQ.W	#4,A7

	ST	-$66EF(A4)	;_s_know + 7 "wild magic"

; special case for wild magic scrolls, because it is maybe not consumed

	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_pack_name	;updates the items name in the pack
	ADDQ.W	#6,A7

	MOVE.W	-$52A8(A4),D3	;_player + 34 (hp)
	LSR.W	#1,D3		;divide the players health in half
	SUB.W	D3,-$52A8(A4)	;_player + 34 (hp)

	MOVE.W	#-1,-(A7)	;subtract one strength point

	JSR	_chg_str
	ADDQ.W	#2,A7
	JSR	_status
	PEA	L001F5(PC)	;"You sense something uncontrollable about this object."
	JSR	_warning(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L001C9

	MOVEq	#100,D0		;10% chance you can't control it
	JSR	_rnd
	CMP.W	#10,D0
	BGE	L001A6

	PEA	L001F6(PC)	;"The wild magic is too strong for you to control ..."
	JSR	_msg
	ADDQ.W	#4,A7
L001C9:
	MOVE.L	A2,-(A7)
	JSR	_wild_magic(PC)	; lets see what we've got
	ADDQ.W	#4,A7
	BRA.W	L001E6

; teleportation scroll

L001CA:
	MOVE.L	-$52A0(A4),-$0006(A5)	;_player + 42 (proom)
	JSR	_teleport
	MOVEA.L	-$0006(A5),A6
	CMPA.L	-$52A0(A4),A6	;_player + 42 (proom)
	BEQ	L001E6

	MOVE.B	#$01,-$66EE(A4)
	BRA.W	L001E6

; enchant weapon

L001CC:
	TST.L	-$5298(A4)	;_cur_weapon
	BEQ.B	L001CD

	MOVE.L	-$5298(A4),-(A7)	;_cur_weapon
	JSR	_typeof
	ADDQ.W	#4,A7
	CMP.W	#$006D,D0	;'m' weapon type
	BNE.B	L001CD

	JSR	_s_enchant(PC)
	MOVEA.L	-$5298(A4),A6	;_cur_weapon
	MOVE.W	$0020(A6),D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$6F5C(A4),A6	;_w_names
	MOVE.L	$00(A6,D3.w),-(A7)
	PEA	L001F8(PC)	;"your %s glows blue for a moment"
	JSR	_msg
	ADDQ.W	#8,A7
	BRA.W	L001E6
L001CD:
	PEA	L001F7(PC)	;"you feel a strange sense of loss"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L001E6

; scare monster scroll

L001D0:
	TST.B	-$66B2(A4)	;_terse
	BNE.B	L001D1
	TST.B	-$66AB(A4)	;_expert
	BEQ.B	L001D2
L001D1:
	LEA	L001F9(PC),A6	; $0
	MOVE.L	A6,D3
	BRA.B	L001D3
L001D2:
	MOVE.L	-$77B4(A4),D3	;_in_dist
L001D3:
	MOVE.L	D3,-(A7)
	MOVE.L	-$77B8(A4),-(A7)	;_laugh
	JSR	_msg
	ADDQ.W	#8,A7
	BRA.W	L001E6

; remove curse scroll

L001D4:
	JSR	_s_remove(PC)
	LEA	L001FB(PC),a0	;"you feel as if "
	JSR	_noterse

	MOVE.L	D0,-(A7)
	PEA	L001FA(PC)	;"%ssomebody is watching over you"
	JSR	_msg
	ADDQ.W	#8,A7
	BRA.W	L001E6

; aggravate monster

L001D5:
	JSR	_aggravate
	PEA	L001FD(PC)	;"you hear a high pitched humming noise"
	PEA	L001FC(PC)	;"you hear a humming noise"
	JSR	_ifterse(PC)
	ADDQ.W	#8,A7
	BRA.W	L001E6

; blank paper scroll

L001D6:
	PEA	L001FE(PC)	;"this scroll seems to be blank"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L001E6

; vorpalize weapon scroll

L001D7:
	TST.L	-$5298(A4)	;_cur_weapon
	BEQ.B	L001D8

	MOVE.L	-$5298(A4),-(A7)	;_cur_weapon
	JSR	_typeof
	ADDQ.W	#4,A7
	CMP.W	#$006D,D0	;'m' weapon type
	BEQ.B	L001DC
L001D8:
	TST.B	-$66B2(A4)	;_terse
	BNE.B	L001D9
	TST.B	-$66AB(A4)	;_expert
	BEQ.B	L001DA
L001D9:
	LEA	L001F9(PC),A6	; $0
	MOVE.L	A6,D3
	BRA.B	L001DB

L001DA:
	MOVE.L	-$77B4(A4),D3	;_in_dist
L001DB:
	MOVE.L	D3,-(A7)
	MOVE.L	-$77B8(A4),-(A7)	;_laugh "you hear maniacal laughter%s."
	JSR	_msg
	ADDQ.W	#8,A7
	BRA.W	L001E1

; vorpalize weapon

L001DC:
	MOVEA.L	-$5298(A4),A6	;_cur_weapon
	TST.B	$002A(A6)	;already vorpalized
	BEQ.B	L001DD

	MOVE.W	$0020(A6),D3
	ASL.w	#2,D3
	LEA	-$6F5C(A4),A6	;_w_names
	MOVE.L	$00(A6,D3.w),-(A7)
	PEA	L00200(PC)	;"your %s vanishes in a puff of smoke"
	JSR	_msg
	ADDQ.W	#8,A7
	CLR.L	-(A7)
	MOVE.L	-$5298(A4),-(A7)	;_cur_weapon
	JSR	_unpack
	ADDQ.W	#8,A7
	MOVE.L	-$5298(A4),-(A7)	;_cur_weapon
	JSR	_discard
	ADDQ.W	#4,A7
	CLR.L	-$5298(A4)	;_cur_weapon
	BRA.B	L001E1
L001DD:
	JSR	_pick_mons
	MOVEA.L	-$5298(A4),A6	;_cur_weapon
	MOVE.B	D0,$002A(A6)	;set the monster which we can slay now
	ADDQ.W	#1,$0022(A6)	;hplus + 1
	ADDQ.W	#1,$0024(A6)	;dplus + 1
	MOVE.W	#$0001,$0026(A6)	;number of charges
	TST.B	-$66B2(A4)	;_terse
	BNE.B	L001DE

	TST.B	-$66AB(A4)	;_expert
	BEQ.B	L001DF
L001DE:
	LEA	L001F9(PC),A6
	MOVE.L	A6,D3
	BRA.B	L001E0
L001DF:
	MOVE.L	-$69C6(A4),D3	;_intense
L001E0:
	MOVE.L	D3,-(A7)
	MOVEA.L	-$5298(A4),A6	;_cur_weapon
	MOVE.W	$0020(A6),D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$6F5C(A4),A6	;_w_names
	MOVE.L	$00(A6,D3.w),-(A7)
	MOVE.L	-$69C2(A4),-(A7)	;_flash
	JSR	_msg
	LEA	$000C(A7),A7
	MOVE.W	#$0001,-(A7)
	MOVE.L	-$5298(A4),-(A7)	;_cur_weapon
	JSR	_pack_name
	ADDQ.W	#6,A7
L001E1:
	BRA.B	L001E6

L001E2:
	PEA	L00202(PC)	;"what a puzzling scroll!"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L001A6
L001E3:
	dc.w	L001AB-L001E5	;monster confusion
	dc.w	L001BB-L001E5	;magic mapping
	dc.w	L001AE-L001E5	;hold monster
	dc.w	L001B5-L001E5	;sleep
	dc.w	L001AC-L001E5	;enchant armor
	dc.w	L001B9-L001E5	;identify
	dc.w	L001D0-L001E5	;scare monster
	dc.w	L001C7-L001E5	;wild magic
	dc.w	L001CA-L001E5	;teleportation
	dc.w	L001CC-L001E5	;enchant weapon
	dc.w	L001B6-L001E5	;create monster
	dc.w	L001D4-L001E5	;remove curse
	dc.w	L001D5-L001E5	;aggravate monster
	dc.w	L001D6-L001E5	;blank paper
	dc.w	L001D7-L001E5	;vorpalize weapon
L001E4:
	CMP.W	#$000F,D0
	BCC.B	L001E2
	ASL.W	#1,D0
	MOVE.W	L001E3(PC,D0.W),D0
L001E5:	JMP	L001E5(PC,D0.W)

L001E6:
	MOVE.W	#$0001,-(A7)
	JSR	_look
	ADDQ.W	#2,A7
	JSR	_status

	MOVE.W	$0020(A2),D3
	MULU.W	#21,D3
	LEA	-$656A(A4),A6	;_s_guess
	ADD.L	A6,D3
	MOVE.L	D3,-(A7)

	MOVE.W	$0020(A2),D3
	LEA	-$66F6(A4),A6	;_s_know
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
	BRA.W	L001A6

L001E7:	dc.b	"read",0
L001E8:	dc.b	"there is nothing on it to read",0
L001E9:	dc.b	"the scroll vanishes",0
L001EA:	dc.b	"as you read the scroll, it vanishes",0
L001EB:	dc.b	"your hands begin to glow red",0
L001EC:	dc.b	"your armor glows faintly",0
L001ED:	dc.b	"your armor glows faintly for a moment",0
L001EE:	dc.b	"you fall asleep",0
L001EF:	dc.b	"you hear a faint cry of anguish",0
L001F0:	dc.b	"you hear a faint cry of anguish in the distance",0
L001F1:	dc.b	"this scroll is an identify scroll",0
L001F2:	dc.b	" More ",0
L001F3:	dc.b	"oh, now this scroll has a map on it",0
L001F4:	dc.b	"This is a scroll of wild magic",0
L001F5:	dc.b	"You sense something uncontrollable about this object.",0
L001F6:	dc.b	"The wild magic is too strong for you to control ...",0
L001F7:	dc.b	"you feel a strange sense of loss",0
L001F8:	dc.b	"your %s glows blue for a moment",0
L001F9:	dc.b	$00
L001FA:	dc.b	"%ssomebody is watching over you",0
L001FB:	dc.b	"you feel as if ",0
L001FC:	dc.b	"you hear a humming noise",0
L001FD:	dc.b	"you hear a high pitched humming noise",0
L001FE:	dc.b	"this scroll seems to be blank",0
L00200:	dc.b	"your %s vanishes in a puff of smoke",0
L00202:	dc.b	"what a puzzling scroll!",0,0

_wild_magic:
	LINK	A5,#-$0004
	MOVEM.L	D4/D5/A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2

	MOVEq	#$0006,D0	;6 possible actions can happen
	JSR	_rnd
;	EXT.L	D0
	BRA.W	L00214

; thunderclaps, removes all monster from the level, also there will be no new ones in this level

L00203:
	MOVEA.L	-$6CAC(A4),A3	;_mlist
	BRA.B	L00205
L00204:
	MOVE.L	(A3),D4
	MOVE.W	#$0001,-(A7)
	MOVE.L	A3,-(A7)
	PEA	$000A(A3)
	JSR	_remove
	LEA	$000A(A7),A7
	MOVEA.L	D4,A3
L00205:
	MOVE.L	A3,D3		;get monster from list
	BNE.B	L00204

	PEA	L00217(PC)	;"You hear a series of loud thunderclaps rolling through the passages"
	JSR	_msg
	ADDQ.W	#4,A7
	ST	-$66FA(A4)	;_no_more_fears
	BRA.W	L00216

; overwhelmed

L00206:
	JSR	_p_confuse(PC)
	JSR	_p_blind(PC)
	JSR	_aggravate
	PEA	L00218(PC)	;"You are overwhelmed by the force of wild magic"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L00216

; pack glows yellow, identifies everything in the pack

L00207:
	MOVEA.L	-$529C(A4),A3	;_player + 46 (pack)
	BRA.B	L00209
L00208:
	CLR.L	-(A7)
	MOVE.L	A3,-(A7)
	JSR	_whatis
	ADDQ.W	#8,A7
	MOVEA.L	(A3),A3
L00209:
	MOVE.L	A3,D3
	BNE.B	L00208

	PEA	L00219(PC)	;"Your pack glows yellow for a moment"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L00216

; falls 2-6 level

L0020A:
	MOVEq	#$0003,D0
	JSR	_rnd
	ADDQ.W	#4,D0
	MOVE.W	D0,-$6096(A4)	;_fall_level
	BRA.W	L00216

; surrounded by a blue glow

L0020B:
	JSR	_s_remove(PC)	;removes the curses of the used weapon/armor and rings

	TST.L	-$5298(A4)	;_cur_weapon
	BEQ.B	L0020C

	MOVEA.L	-$5298(A4),A6	;_cur_weapon
	CMPI.W	#$006D,$000A(A6)	;m weapon type
	BNE.B	L0020C

	; double enchant currently wielded weapon

	JSR	_s_enchant(PC)
	JSR	_s_enchant(PC)
L0020C:
	TST.L	-$5294(A4)	;_cur_armor
	BEQ.B	L0020D

	; increase armor class by two points

	MOVEA.L	-$5294(A4),A6	;_cur_armor
	SUBQ.W	#2,$0026(A6)
	MOVE.W	#$0001,-(A7)
	MOVE.L	-$5294(A4),-(A7)	;_cur_armor
	JSR	_pack_name
	ADDQ.W	#6,A7
L0020D:
	PEA	L0021A(PC)	;"You are surrounded by a blue glow"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L00216

; pack feels lighter

L0020E:
	PEA	L0021B(PC)	;"There is a fluttering behind you and suddenly your pack feels lighter."
	JSR	_msg
	ADDQ.W	#4,A7
	MOVEA.L	-$529C(A4),A3	;_player + 46 (pack)
	BRA.W	L00212
L0020F:
	MOVE.L	(A3),D4
	CMPA.L	A2,A3
	BEQ.W	L00211

	MOVE.L	A3,-(A7)
	JSR	__is_current
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.W	L00211
L00210:
	PEA	-$0004(A5)
	JSR	_blank_spot
	ADDQ.W	#4,A7

	MOVE.W	D0,D5
	MOVEA.L	-$5198(A4),A6	;__flags
	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D5.W),D3
	AND.W	#F_REAL,D3
	BEQ.B	L00210

	MOVE.W	-$0004(A5),d1
	MOVE.W	-$0002(A5),d0
	JSR	_moatquick

	TST.L	D0
	BNE.B	L00210

	MOVE.W	#$0001,-(A7)
	MOVE.L	A3,-(A7)
	JSR	_unpack
	ADDQ.W	#6,A7

	MOVEA.L	D0,A3
	MOVE.L	A3,-(A7)
	PEA	-$6CB0(A4)	;_lvl_obj
	JSR	__attach
	ADDQ.W	#8,A7

	MOVEA.L	A3,A6
	ADDA.L	#$0000000C,A6
	LEA	-$0004(A5),A1
	MOVE.L	(A1)+,(A6)+
	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	$000B(A3),$00(A6,D5.W)
	MOVE.W	-$0004(A5),-(A7)
	MOVE.W	-$0002(A5),-(A7)
	JSR	_cansee
	ADDQ.W	#4,A7

	TST.W	D0
	BEQ.B	L00211

	MOVEA.L	-$519C(A4),A6	;__level

	MOVE.B	$00(A6,D5.W),D2
	MOVE.W	-$0004(A5),d1
	MOVE.W	-$0002(A5),d0
	JSR	_mvaddchquick

L00211:
	MOVEA.L	D4,A3
L00212:
	MOVE.L	A3,D3
	BNE.W	L0020F
	BRA.B	L00216
L00213:
	dc.w	L00203-L00215	;+ "You hear a series of loud thunderclaps rolling through the passages"
	dc.w	L00206-L00215	;- "You are overwhelmed by the force of wild magic"
	dc.w	L00207-L00215	;+ "Your pack glows yellow for a moment"
	dc.w	L0020A-L00215	;-- falls a random number (2-6) of levels
	dc.w	L0020B-L00215	;++ "You are surrounded by a blue glow"
	dc.w	L0020E-L00215	;- "There is a fluttering behind you and suddenly your pack feels lighter."
L00214:
	CMP.w	#$0006,D0
	BCC.B	L00216

	ASL.w	#1,D0
	MOVE.W	L00213(PC,D0.W),D0
L00215:	JMP	L00215(PC,D0.W)
L00216:
	MOVEM.L	(A7)+,D4/D5/A2/A3
	UNLK	A5
	RTS

L00217:	dc.b	"You hear a series of loud thunderclaps rolling through the passages",0
L00218:	dc.b	"You are overwhelmed by the force of wild magic",0
L00219:	dc.b	"Your pack glows yellow for a moment",0
L0021A:	dc.b	"You are surrounded by a blue glow",0
L0021B:	dc.b	"There is a fluttering behind you and suddenly your pack feels lighter.",0

; removes the curse of the wielded weapon, worn armor and used rings

_s_remove:
;	LINK	A5,#-$0000

	TST.L	-$5294(A4)	;_cur_armor
	BEQ.B	L0021C
	MOVEA.L	-$5294(A4),A6	;_cur_armor
	ANDI.W	#~O_ISCURSED,$0028(A6)	;clear ISCURSED bit
L0021C:
	TST.L	-$5298(A4)	;_cur_weapon
	BEQ.B	L0021D
	MOVEA.L	-$5298(A4),A6	;_cur_weapon
	ANDI.W	#~O_ISCURSED,$0028(A6)
L0021D:
	TST.L	-$5190(A4)	;_cur_ring_1
	BEQ.B	L0021E
	MOVEA.L	-$5190(A4),A6	;_cur_ring_1
	ANDI.W	#~O_ISCURSED,$0028(A6)
L0021E:
	TST.L	-$518C(A4)	;_cur_ring_2
	BEQ.B	L0021F
	MOVEA.L	-$518C(A4),A6	;_cur_ring_2
	ANDI.W	#~O_ISCURSED,$0028(A6)
L0021F:
;	UNLK	A5
	RTS

_s_enchant:
;	LINK	A5,#-$0000
	MOVEA.L	-$5298(A4),A6	;_cur_weapon

	ANDI.W	#~O_ISCURSED,$0028(A6)	;clear O_ISCURSED bit
	MOVEq	#$0002,D0
	JSR	_rnd
	MOVEA.L	-$5298(A4),A6	;_cur_weapon
	TST.W	D0
	BNE.B	L00220

	ADDQ.W	#1,$0022(A6)
	BRA.B	L00221
L00220:
	ADDQ.W	#1,$0024(A6)
L00221:
	MOVE.W	#$0001,-(A7)
	MOVE.L	A6,-(A7)	;_cur_weapon
	JSR	_pack_name
	ADDQ.W	#6,A7

;	UNLK	A5
	RTS

;/*
;* Create a monster:
;* First look in a circle around him, next try his room
;* otherwise give up
;*/

_plop_monster:
	LINK	A5,#-$0002
	MOVEM.L	D4/D5,-(A7)

	CLR.B	-$0001(A5)
	MOVE.W	$0008(A5),D4
	SUBQ.W	#1,D4
	BRA.W	L00233
L0022D:
	MOVE.W	$000A(A5),D5
	SUBQ.W	#1,D5
	BRA	L00232
L0022E:
	CMP.W	-$52BE(A4),D4	;_player + 12
	BNE.B	L0022F

	CMP.W	-$52C0(A4),D5	;_player + 10
	BEQ.B	L00231
L0022F:
	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_offmap
	ADDQ.W	#4,A7

	TST.W	D0
	BNE.B	L00231

	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_winat
	ADDQ.W	#4,A7

	MOVE.B	D0,-$0002(A5)
	MOVEQ	#$00,D3
	MOVE.B	D0,D3

	MOVE.W	D3,-(A7)
	JSR	_step_ok
	ADDQ.W	#2,A7

	TST.W	D0
	BEQ.B	L00231

	CMP.B	#$3F,-$0002(A5)	;'?' scroll
	BNE.B	L00230

	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_find_obj
	ADDQ.W	#4,A7

	MOVEA.L	D0,A6
	CMPI.W	#S_SCAREM,$0020(A6)	;is it a scroll of scare monster?
	BEQ.B	L00231
L00230:
	ADDQ.B	#1,-$0001(A5)
	MOVEQ	#$00,D0
	MOVE.B	-$0001(A5),D0
	JSR	_rnd
	TST.W	D0
	BNE.B	L00231

	MOVEA.L	$000C(A5),A6
	MOVE.W	D4,$0002(A6)
	MOVEA.L	$000C(A5),A6
	MOVE.W	D5,(A6)
L00231:
	ADDQ.W	#1,D5
L00232:
	MOVE.W	$000A(A5),D3
	ADDQ.W	#1,D3
	CMP.W	D3,D5
	BLE.W	L0022E

	ADDQ.W	#1,D4
L00233:
	MOVE.W	$0008(A5),D3
	ADDQ.W	#1,D3
	CMP.W	D3,D4
	BLE.W	L0022D

	MOVEQ	#$00,D0
	MOVE.B	-$0001(A5),D0

	MOVEM.L	(A7)+,D4/D5
	UNLK	A5
	RTS
