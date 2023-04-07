L00A47:	dc.b	"> Go Down Stairs",0
L00A48:	dc.b	"< Go Up Stairs",0
L00A49:	dc.b	"d Drop",0
L00A4A:	dc.b	"e Eat",0
L00A4B:	dc.b	"w Wield",0
L00A4C:	dc.b	"r Read",0
L00A4D:	dc.b	"q Quaff",0
L00A4E:	dc.b	"P Put on ring",0
L00A4F:	dc.b	"R Take ring off",0
L00A50:	dc.b	"W Put on armor",0
L00A51:	dc.b	"T Take armor off",0
L00A52:	dc.b	"t Throw",0
L00A53:	dc.b	"z Zap",0

L00A54:	dc.b	"><dewrqPRWTtz",0

L00A55:	dc.b	"About Rogue",0
L00A56:	dc.b	"Save",0
L00A57:	dc.b	"Restore",0
L00A58:	dc.b	"Quit",0

L00A59:	dc.b	"Disabled",0
L00A5A:	dc.b	"Enabled",0,0

L00A5B:	dc.b	"Off",0
L00A5C:	dc.b	"On",0

L00A5D:	dc.b	"Manual",0
L00A5E:	dc.b	"Automatic",0
L00A5F:	dc.b	"Selective",0,0

L00A60:	dc.b	"Fast Play",0
L00A61:	dc.b	"Inventory Style",0

L00A62:	dc.b	"Game",0
L00A63:	dc.b	"Options",0
L00A64:	dc.b	"Use",0
L00A65:	dc.b	"Command",0

_ctointui:
	MOVEA.L	$0008(A7),A6
	CLR.B	(A6)
	MOVE.B	#$01,$0001(A6)
	MOVE.B	#$01,$0002(A6)
	MOVE.W	$000C(A7),$0004(A6)
	CLR.W	$0006(A6)
	CLR.L	$0008(A6)
	MOVE.L	$0004(A7),$000C(A6)
	CLR.L	$0010(A6)

	MOVE.L	A6,D0
	RTS

_UseItems:
	LINK	A5,#-$001E
	TST.L	$0008(A5)
	BNE.B	L00A67

	MOVEQ	#$00,D0
L00A66:
	UNLK	A5
	RTS

L00A67:
	CLR.L	-$0008(A5)
	CLR.L	-$0004(A5)
	CLR.W	-$0016(A5)
	CLR.W	-$001C(A5)
	CLR.W	-$001A(A5)
	MOVE.L	$0008(A5),-$0010(A5)
	BRA.B	L00A6C
L00A68:
	MOVEA.L	-$0010(A5),A6
	MOVE.L	(A6),-(A7)
	JSR	_scrlen
	ADDQ.W	#4,A7

	MOVE.W	D0,-$0018(A5)
	CMP.W	-$0016(A5),D0
	BLE.B	L00A69

	MOVE.W	-$0018(A5),-$0016(A5)
L00A69:
	MOVEA.L	-$0010(A5),A6
	MOVE.W	$0004(A6),D3
;	EXT.L	D3
	AND.w	#$0004,D3
	BEQ.B	L00A6A

	MOVE.W	#$0001,-$001C(A5)
L00A6A:
	MOVEA.L	-$0010(A5),A6
	MOVE.W	$0004(A6),D3
;	EXT.L	D3
	AND.w	#$0001,D3
	BEQ.B	L00A6B

	MOVE.W	#$0001,-$001A(A5)
L00A6B:
	ADDI.L	#$00000010,-$0010(A5)
L00A6C:
	MOVEA.L	-$0010(A5),A6
	TST.L	(A6)
	BNE.B	L00A68

	moveq	#$13,D1		;19
	MULU.W	-$001A(A5),D1
	MOVE.W	D1,-$001A(A5)

	moveq	#$28,d3		;40
	MULU.W	-$001C(A5),D3
	MOVE.W	D3,-$001C(A5)

	ADD.W	D1,D3
	ADD.W	D3,-$0016(A5)

	CLR.W	-$001E(A5)
L00A6D:
	MOVEA.L	$0008(A5),A6
	TST.L	(A6)
	BEQ.W	L00A70

	MOVE.W	#$0022,-(A7)
	JSR	_malloc
	ADDQ.W	#2,A7

	MOVE.L	D0,-$000C(A5)
	TST.L	-$0004(A5)
	BEQ.B	L00A6E

	MOVEA.L	-$0004(A5),A6
	MOVE.L	-$000C(A5),(A6)
	BRA.B	L00A6F
L00A6E:
	MOVE.L	-$000C(A5),-$0008(A5)
L00A6F:
	MOVE.L	-$000C(A5),-$0004(A5)
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$000C(A5),$0004(A6)
;	MOVEA.L	-$0004(A5),A6
	MOVE.W	-$001E(A5),$0006(A6)
;	MOVEA.L	-$0004(A5),A6
	MOVE.W	-$0016(A5),$0008(A6)
;	MOVEA.L	-$0004(A5),A6
	MOVE.W	#$0008,$000A(A6)
;	MOVEA.L	-$0004(A5),A6
	MOVEA.L	$0008(A5),A1
	MOVE.W	$0004(A1),D3
	EXT.L	D3
	OR.L	#$00000052,D3
	MOVE.W	D3,$000C(A6)
;	MOVEA.L	-$0004(A5),A6
	MOVEA.L	$0008(A5),A1
	MOVE.L	$0008(A1),$000E(A6)
	MOVE.W	#$0014,-(A7)
	JSR	_malloc
	ADDQ.W	#2,A7
	MOVE.L	D0,-$0014(A5)
	MOVE.W	-$001A(A5),-(A7)
	MOVE.L	-$0014(A5),-(A7)
	MOVEA.L	$0008(A5),A6
	MOVE.L	(A6),-(A7)
	JSR	_ctointui(PC)
	LEA	$000A(A7),A7
	MOVEA.L	-$0004(A5),A6
	MOVE.L	-$0014(A5),$0012(A6)
;	MOVEA.L	-$0004(A5),A6
	CLR.L	$0016(A6)
;	MOVEA.L	-$0004(A5),A6
	MOVEA.L	$0008(A5),A1
	MOVE.B	$0006(A1),$001A(A6)
;	MOVEA.L	-$0004(A5),A6
	MOVE.L	A6,-(A7)
;	MOVEA.L	-$0004(A5),A6
	MOVE.W	$0008(A6),D3
	SUBQ.W	#1,D3
	SUB.W	-$001C(A5),D3
	MOVE.W	D3,-(A7)
	MOVEA.L	$0008(A5),A6
	MOVE.L	$000C(A6),-(A7)
	JSR	_UseItems(PC)
	ADDQ.W	#6,A7
	MOVEA.L	(A7)+,A6
	MOVE.L	D0,$001C(A6)
	MOVEA.L	-$0004(A5),A6
	CLR.W	$0020(A6)
	ADDQ.W	#8,-$001E(A5)
	ADDI.L	#$00000010,$0008(A5)
	BRA.W	L00A6D
L00A70:
	MOVEA.L	-$0004(A5),A6
	CLR.L	(A6)
	MOVE.L	-$0008(A5),D0
	BRA.W	L00A66

_BuildMenu:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5/A2/A3,-(A7)
	SUBA.L	A3,A3
	MOVEA.L	A3,A2
	MOVEQ	#$00,D5
L00A71:
	MOVEA.L	$0008(A5),A6
	TST.L	(A6)
	BEQ.B	L00A74
	MOVE.W	#$001E,-(A7)
	JSR	_malloc
	ADDQ.W	#2,A7
	MOVE.L	D0,D4
	MOVE.L	A2,D3
	BEQ.B	L00A72
	MOVE.L	D4,(A2)
	BRA.B	L00A73
L00A72:
	MOVEA.L	D4,A3
L00A73:
	MOVEA.L	D4,A2
	MOVE.W	#$0001,$000C(A2)
	MOVEA.L	$0008(A5),A6
	MOVE.L	(A6),$000E(A2)
;	MOVEA.L	$0008(A5),A6
	MOVE.L	$0006(A6),-(A7)
	JSR	_UseItems(PC)
	ADDQ.W	#4,A7
	MOVE.L	D0,$0012(A2)
	MOVE.W	D5,$0004(A2)
	MOVEA.L	$0008(A5),A6
	MOVE.L	(A6),-(A7)
	JSR	_scrlen
	ADDQ.W	#4,A7
	ADD.W	#$0014,D0
	MOVE.W	D0,$0008(A2)
	CLR.W	$0006(A2)
	MOVE.W	#$000A,$000A(A2)
	ADD.W	$0008(A2),D5
	ADDI.L	#$0000000A,$0008(A5)
	BRA.B	L00A71
L00A74:
	CLR.L	(A2)
	MOVE.L	A3,D0
	MOVEM.L	(A7)+,D4/D5/A2/A3
	UNLK	A5
	RTS

_InstallMenus:
;	LINK	A5,#-$0000

	PEA	_menu_bar-BASE(A4)	;_menu_bar
	JSR	_BuildMenu(PC)
	ADDQ.W	#4,A7
	MOVE.L	D0,-$53A2(A4)

	MOVE.L	-$53A2(A4),-(A7)
	MOVE.L	_RogueWin-BASE(A4),-(A7)	;_RogueWin
	JSR	_SetMenuStrip(PC)
	ADDQ.W	#8,A7

;	UNLK	A5
	RTS

_DoMenu:
	LINK	A5,#-$0000
	MOVEM.L	D4-D6/A2/A3,-(A7)
	MOVE.L	$0008(A5),D4
	SUBA.L	A2,A2
	MOVEQ	#$00,D6
	MOVEA.L	-$53A2(A4),A3
L00A75:
	MOVE.L	D4,D5
	MOVE.L	#$0000FFFF,D4
	MOVE.L	D5,-(A7)
	MOVE.L	A3,-(A7)
	JSR	_ItemAddress(PC)
	ADDQ.W	#8,A7
	MOVEA.L	D0,A2
	MOVE.L	D5,D0
	AND.w	#$001F,D0
	BRA.W	L00A88
L00A76:
	MOVE.L	D5,D0
	ASR.w	#5,D0
	AND.w	#$003F,D0
	BRA.B	L00A7C
L00A77:
	JSR	_about_rogue(PC)
	BRA.B	L00A7E
L00A78:
	JSR	_save_game
	BRA.B	L00A7E
L00A79:
	JSR	_restore_game(PC)
	SUBA.L	A2,A2
	BRA.B	L00A7E
L00A7A:
	JSR	_quit(PC)
	BRA.B	L00A7E
L00A7B:
	dc.w	L00A77-L00A7D	;about
	dc.w	L00A78-L00A7D	;save game
	dc.w	L00A79-L00A7D	;restore game
	dc.w	L00A7A-L00A7D	;quit
L00A7C:
	CMP.w	#$0004,D0
	BCC.B	L00A7E
	ASL.w	#1,D0
	MOVE.W	L00A7B(PC,D0.W),D0
L00A7D:	JMP	L00A7D(PC,D0.W)
L00A7E:
	BRA.W	L00A8A
L00A7F:
	MOVE.L	D5,D0
	ASR.w	#5,D0
	AND.w	#$003F,D0
	BRA.B	L00A82
L00A80:
	MOVEQ	#$0B,D2
	ASR.L	D2,D5
	AND.B	#$1F,D5
	MOVE.B	D5,_faststate-BASE(A4)	;_faststate
	BRA.B	L00A8A
L00A81:
	MOVEQ	#$0B,D2
	ASR.L	D2,D5
	AND.B	#$1F,D5
	MOVE.B	D5,_menu_style-BASE(A4)	;_menu_style
	BRA.B	L00A8A
L00A82:
	TST.w	D0
	BEQ.B	L00A80
	SUBQ.w	#1,D0
	BEQ.B	L00A81
	BRA.B	L00A8A
L00A84:
	PEA	L00A8C(PC)	;"",0
	JSR	_msg
	ADDQ.W	#4,A7

	MOVE.L	D5,D3
	ASR.L	#5,D3
	AND.w	#$003F,D3
	ASL.w	#2,D3
	LEA	-$539A(A4),A6
	MOVE.L	$00(A6,D3.w),-(A7)
	JSR	_use_obj(PC)
	ADDQ.W	#4,A7
	MOVEQ	#$7F,D6
	BRA.B	L00A8A
L00A85:
	MOVE.L	D5,D3
	ASR.L	#5,D3
	AND.w	#$003F,D3
	MOVEA.L	-$68AE(A4),A6
	MOVE.B	$00(A6,D3.w),D2
	EXT.W	D2
	MOVE.W	D2,D6
	BRA.B	L00A8A
L00A87:
	dc.w	L00A76-L00A89	;Game menu
	dc.w	L00A7F-L00A89	;Options Menu
	dc.w	L00A84-L00A89	;Use menu
	dc.w	L00A85-L00A89	;Command menu
L00A88:
	CMP.w	#$0004,D0
	BCC.B	L00A86
	ASL.w	#1,D0
	MOVE.W	L00A87(PC,D0.W),D0
L00A89:	JMP	L00A89(PC,D0.W)
L00A86:
	SUBA.L	A2,A2
L00A8A:
	MOVE.L	A2,D3
	BEQ.B	L00A8B
	MOVEQ	#$00,D3
	MOVE.W	$0020(A2),D3
	MOVE.L	D3,D4
L00A8B:
	CMP.L	#$0000FFFF,D4
	BNE.W	L00A75
	MOVE.W	D6,D0

	MOVEM.L	(A7)+,D4-D6/A2/A3
	UNLK	A5
	RTS

L00A8C:	dc.w	$0000

_want_a_menu:
	LINK	A5,#-$000A
	MOVEM.L	D4-D7/A2/A3,-(A7)

	MOVE.L	-$53A2(A4),-$0006(A5)
	BRA.B	L00A8E
L00A8D:
	MOVEA.L	-$0006(A5),A6
	MOVE.L	(A6),-$0006(A5)
L00A8E:
	TST.L	-$0006(A5)
	BEQ.B	L00A8F

	PEA	L00A9B(PC)	;"Use"
	MOVEA.L	-$0006(A5),A6
	MOVE.L	$000E(A6),-(A7)
	JSR	_strcmp
	ADDQ.W	#8,A7

	TST.W	D0
	BNE.B	L00A8D
L00A8F:
	TST.L	-$0006(A5)
	BNE.B	L00A91
L00A90:
	MOVEM.L	(A7)+,D4-D7/A2/A3
	UNLK	A5
	RTS

L00A91:
	MOVE.L	_RogueWin-BASE(A4),-(A7)	;_RogueWin
	JSR	_ClearMenuStrip
	ADDQ.W	#4,A7
	MOVEA.L	-$0006(A5),A6
	MOVEA.L	$0012(A6),A2
	BRA.B	L00A93
L00A92:
	MOVEA.L	(A2),A3
	MOVEA.L	$0012(A2),A6
	MOVE.L	$000C(A6),-(A7)
	JSR	_free
	ADDQ.W	#4,A7
	MOVE.L	$0012(A2),-(A7)
	JSR	_free
	ADDQ.W	#4,A7
	MOVE.L	A2,-(A7)
	JSR	_free
	ADDQ.W	#4,A7
	MOVEA.L	A3,A2
L00A93:
	MOVE.L	A2,D3
	BNE.B	L00A92

	MOVEQ	#$00,D6
	MOVE.W	D6,D7
	MOVE.W	D6,-$0002(A5)
	MOVE.L	-$529C(A4),-$000A(A5)	;_player + 46 (pack)
	BRA.W	L00A98
L00A94:
	MOVE.W	-$0002(A5),D3
	ADDQ.W	#1,-$0002(A5)
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$539A(A4),A6
	MOVE.L	-$000A(A5),$00(A6,D3.w)

	MOVE.W	#$0022,-(A7)
	JSR	_malloc
	ADDQ.W	#2,A7

	MOVEA.L	D0,A3
	MOVE.L	A2,D3
	BEQ.B	L00A95

	MOVE.L	A3,(A2)
	BRA.B	L00A96
L00A95:
	MOVEA.L	-$0006(A5),A6
	MOVE.L	A3,$0012(A6)
L00A96:
	MOVEA.L	A3,A2
	CLR.W	$0004(A2)
	MOVE.W	D6,$0006(A2)
	MOVEA.L	-$000A(A5),A6
	MOVE.L	$0010(A6),-(A7)
	JSR	_scrlen
	ADDQ.W	#4,A7
	MOVE.W	D0,$0008(A2)
	MOVE.W	$0008(A2),D3
	CMP.W	D7,D3
	BLE.B	L00A97

	MOVE.W	$0008(A2),D7
L00A97:
	MOVE.W	#$0008,$000A(A2)
	MOVE.W	#$0052,$000C(A2)
	CLR.L	$000E(A2)

	MOVE.W	#$0014,-(A7)
	JSR	_malloc
	ADDQ.W	#2,A7

	MOVE.L	D0,D5
	CLR.W	-(A7)
	MOVE.L	D5,-(A7)
	MOVEA.L	-$000A(A5),A6
	MOVE.L	$0010(A6),-(A7)
	MOVE.L	$0010(A6),A0
	JSR	_strlenquick

	ADDQ.W	#1,D0

	MOVE.W	D0,-(A7)
	JSR	_malloc
	ADDQ.W	#2,A7

	MOVE.L	D0,-(A7)
	JSR	_strcpy
	ADDQ.W	#8,A7
	MOVE.L	D0,-(A7)
	JSR	_ctointui(PC)
	LEA	$000A(A7),A7
	MOVE.L	D5,$0012(A2)
	CLR.L	$0016(A2)
	CLR.B	$001A(A2)
	CLR.L	$001C(A2)
	CLR.W	$0020(A2)
	ADDQ.W	#8,D6
	MOVEA.L	-$000A(A5),A6
	MOVE.L	(A6),-$000A(A5)
L00A98:
	TST.L	-$000A(A5)
	BNE.W	L00A94

	CLR.L	(A2)
	MOVEA.L	-$0006(A5),A6
	MOVEA.L	$0012(A6),A2
	BRA.B	L00A9A
L00A99:
	MOVE.W	D7,$0008(A2)
	MOVEA.L	(A2),A2
L00A9A:
	MOVE.L	A2,D3
	BNE.B	L00A99
	MOVE.L	-$53A2(A4),-(A7)
	MOVE.L	_RogueWin-BASE(A4),-(A7)	;_RogueWin
	JSR	_SetMenuStrip(PC)
	ADDQ.W	#8,A7
	BRA.W	L00A90

L00A9B:	dc.b	"Use",0

_use_obj:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVE.L	A2,-(A7)
	JSR	_typeof
	ADDQ.W	#4,A7

;	EXT.L	D0
	BRA	L00AA9
L00A9C:
	JSR	_get_dir(PC)
	TST.W	D0
	BEQ.B	L00A9D

	MOVE.L	A2,-(A7)
	JSR	_do_zap
	ADDQ.W	#4,A7
L00A9D:
	BRA.W	L00AAA
L00A9E:
	MOVE.L	A2,-(A7)
	JSR	_eat(PC)
	ADDQ.W	#4,A7
	BRA.W	L00AAA
L00A9F:
	MOVE.L	A2,-(A7)
	JSR	_quaff
	ADDQ.W	#4,A7
	BRA.W	L00AAA
L00AA0:
	MOVE.L	A2,-(A7)
	JSR	_read_scroll
	ADDQ.W	#4,A7
	BRA.B	L00AAA
L00AA1:
	MOVE.L	A2,-(A7)
	JSR	_wield(PC)
	ADDQ.W	#4,A7
	BRA.B	L00AAA
L00AA2:
	CMPA.L	_cur_armor-BASE(A4),A2	;_cur_armor
	BNE.B	L00AA3
	JSR	_take_off
	BRA.B	L00AA4
L00AA3:
	MOVE.L	A2,-(A7)
	JSR	_wear
	ADDQ.W	#4,A7
L00AA4:
	BRA.B	L00AAA
L00AA5:
	MOVEA.L	_cur_ring_1-BASE(A4),A6	;_cur_ring_1
	CMPA.L	A2,A6
	BEQ.B	L00AA6

	MOVEA.L	_cur_ring_2-BASE(A4),A6	;_cur_ring_2
	CMPA.L	A2,A6
	BNE.B	L00AA7
L00AA6:
	MOVE.L	A2,-(A7)
	JSR	_ring_off(PC)
	ADDQ.W	#4,A7
	BRA.B	L00AA8
L00AA7:
	MOVE.L	A2,-(A7)
	JSR	_ring_on(PC)
	ADDQ.W	#4,A7
L00AA8:
	BRA.B	L00AAA
L00AA9:
	SUB.w	#$0021,D0	;'!' potions
	BEQ.B	L00A9F
	SUB.w	#$000E,D0	;'/' wand/staff
	BEQ.W	L00A9C
	SUB.w	#$000B,D0	;':' food
	BEQ	L00A9E
	SUBQ.w	#3,D0		;'=' rings
	BEQ.B	L00AA5
	SUBQ.w	#2,D0		;'?' scrolls
	BEQ.B	L00AA0
	SUB.w	#$0022,D0	;'a' armor type
	BEQ.B	L00AA2
	SUB.w	#$000C,D0	;'m' weapon type
	BEQ.B	L00AA1
L00AAA:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

_fix_menu:
	LINK	A5,#-$0000

	MOVE.L	_RogueWin-BASE(A4),-(A7)	;_RogueWin
	JSR	_ClearMenuStrip
	ADDQ.W	#4,A7

	MOVEQ	#$00,D3
	MOVE.B	_faststate-BASE(A4),D3	;_faststate
	MOVE.W	D3,-(A7)
	CLR.W	-(A7)
	MOVE.W	#$0001,-(A7)
	BSR.B	_SetCheck
	ADDQ.W	#6,A7

	MOVEQ	#$00,D3
	MOVE.B	_menu_style-BASE(A4),D3	;_menu_style
	MOVE.W	D3,-(A7)
	MOVE.W	#$0001,-(A7)
	MOVE.W	#$0001,-(A7)
	BSR.B	_SetCheck
	ADDQ.W	#6,A7

	MOVE.L	-$53A2(A4),-(A7)
	MOVE.L	_RogueWin-BASE(A4),-(A7)	;_RogueWin
	JSR	_SetMenuStrip(PC)
	ADDQ.W	#8,A7

	UNLK	A5
	RTS

_SetCheck:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	moveq	#$0000001F,D3
	AND.W	$0008(A5),D3
	moveq	#$0000003F,D2
	AND.W	$000A(A5),D2
	ASL.L	#5,D2
	OR.L	D2,D3

	MOVE.L	D3,-(A7)
	MOVE.L	-$53A2(A4),-(A7)
	JSR	_ItemAddress(PC)
	ADDQ.W	#8,A7

	MOVEA.L	D0,A2
	MOVEQ	#$00,D2
	MOVE.W	$000C(A5),D1
L00AAB:
	MOVE.L	A2,D3
	BEQ.B	L00AAE

	CMP.W	D1,D2
	BNE.B	L00AAC

	ORI.W	#$0100,$000C(A2)
	BRA.B	L00AAD
L00AAC:
	ANDI.W	#$FEFF,$000C(A2)
L00AAD:
	ADDQ.W	#1,D2
	MOVEA.L	(A2),A2
	BRA.B	L00AAB
L00AAE:
	MOVE.L	(A7)+,A2
	UNLK	A5
	RTS

_about_rogue:
;	LINK	A5,#-$0000
	JSR	_wtext
	JSR	_black_out
	CLR.L	-(A7)
	MOVE.L	_TextWin-BASE(A4),-(A7)	;_TextWin
	PEA	L00AAF(PC)	; "Credits"
	JSR	_show_ilbm
	LEA	$000C(A7),A7
	JSR	_flush_type
	JSR	_readchar
	JSR	_clear
	CLR.L	-(A7)
	PEA	_my_palette-BASE(A4)	;_my_palette
	JSR	_fade_in
	ADDQ.W	#8,A7
	JSR	_wmap
;	UNLK	A5
	RTS

L00AAF:	dc.b	"Credits.lz4",0

_mouse_go:
	LINK	A5,#-$0000
	MOVE.W	$0008(A5),-$533A(A4)
	MOVE.W	$000A(A5),-$5338(A4)
	ST	_mouse_run-BASE(A4)	;_mouse_run
	MOVE.W	-$5338(A4),-(A7)
	MOVE.W	-$533A(A4),-(A7)
	BSR.B	_mouse_dir
	ADDQ.W	#4,A7
	UNLK	A5
	RTS

_mouse_adjust:
;	LINK	A5,#-$0000
	MOVE.W	-$533C(A4),D3
	CMP.W	_player+10-BASE(A4),D3	;_player + 10
	BNE.B	L00AB0
	MOVE.W	-$533E(A4),D3
	CMP.W	_player+12-BASE(A4),D3	;_player + 12
	BNE.B	L00AB0
	CLR.B	_running-BASE(A4)	;_running
	CLR.B	_mouse_run-BASE(A4)	;_mouse_run
L00AB0:
	MOVE.W	-$5338(A4),-(A7)
	MOVE.W	-$533A(A4),-(A7)
	BSR.B	_mouse_dir
	ADDQ.W	#4,A7
;	UNLK	A5
	RTS

_mouse_dir:
	LINK	A5,#-$0002
	MOVEM.L	D4-D7/A2/A3,-(A7)

	MOVE.W	_player+10-BASE(A4),d1	;_player + 10
	MOVE.W	_player+12-BASE(A4),d0	;_player + 12
	JSR	_movequick

	MOVE.W	_p_col-BASE(A4),D4	;_p_col
	ADDQ.W	#5,D4
	MOVE.W	_p_row-BASE(A4),D5	;_p_row
	ADDQ.W	#4,D5
	MOVE.W	$000A(A5),D6
	SUB.W	D4,D6
	MOVE.W	$0008(A5),D7
	SUB.W	D5,D7
	MOVE.W	#$0005,-$0002(A5)
L00AB1:
	MOVE.W	D6,D3
	EXT.L	D3
	DIVS.W	-$0002(A5),D3

	MOVE.W	D3,-(A7)
	JSR	_sign
	ADDQ.W	#2,A7

	MOVEA.W	D0,A2
	MOVE.W	D7,D3
	EXT.L	D3
	DIVS.W	-$0002(A5),D3

	MOVE.W	D3,-(A7)
	JSR	_sign
	ADDQ.W	#2,A7

	MOVEA.W	D0,A3
	MOVE.W	A2,D3
	BNE.B	L00AB2

	MOVE.W	A3,D3
	BNE.B	L00AB2

	ASR.W	-$0002(A5)
	CMPI.W	#$0002,-$0002(A5)
	BGT.B	L00AB1
L00AB2:
	MOVE.W	A2,D3
	BNE.B	L00AB3

	MOVE.W	A3,D3
	BNE.B	L00AB3

	MOVEA.W	#$0001,A2
L00AB3:
	MOVE.W	$000A(A5),D3
	EXT.L	D3
	DIVU.W	#$000A,D3
	MOVE.W	D3,-$533C(A4)

	MOVE.W	$0008(A5),D3
	EXT.L	D3
	DIVU.W	#$0009,D3
	MOVE.W	D3,-$533E(A4)

	MOVE.W	A2,-(A7)
	MOVE.W	A3,-(A7)
	BSR.B	_mouse_char
	ADDQ.W	#4,A7

	MOVEM.L	(A7)+,D4-D7/A2/A3
	UNLK	A5
	RTS

_mouse_char:
	LINK	A5,#-$0006
	MOVEM.L	D4-D7/A2/A3,-(A7)

	MOVE.W	$0008(A5),D4
	MOVE.W	$000A(A5),D5
	MOVE.W	_player+10-BASE(A4),D3	;_player + 10
	ADD.W	D5,D3
	MOVE.W	D3,-(A7)
	MOVE.W	_player+12-BASE(A4),D3	;_player + 12
	ADD.W	D4,D3
	MOVE.W	D3,-(A7)
	JSR	_one_step(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.W	L00AB8

	MOVE.W	-$533C(A4),-(A7)
	MOVE.W	-$533E(A4),-(A7)
	MOVE.W	_player+10-BASE(A4),-(A7)	;_player + 10
	MOVE.W	_player+12-BASE(A4),-(A7)	;_player + 12
	JSR	_DISTANCE
	ADDQ.W	#8,A7
	MOVEA.W	D0,A2
	MOVE.W	D0,-$0002(A5)
	MOVEQ	#-$01,D6
L00AB4:
	MOVEQ	#-$01,D7
L00AB5:
	TST.W	D7
	BNE.B	L00AB6

	TST.W	D6
	BEQ.B	L00AB7
L00AB6:
	MOVE.W	_player+10-BASE(A4),D3	;_player + 10
	ADD.W	D6,D3
	MOVE.W	D3,-(A7)
	MOVE.W	_player+12-BASE(A4),D3	;_player + 12
	ADD.W	D7,D3
	MOVE.W	D3,-(A7)
	BSR.B	_one_step
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00AB7

	MOVE.W	-$533C(A4),-(A7)
	MOVE.W	-$533E(A4),-(A7)
	MOVE.W	_player+10-BASE(A4),D3	;_player + 10
	ADD.W	D6,D3
	MOVE.W	D3,-(A7)
	MOVE.W	_player+12-BASE(A4),D3	;_player + 12
	ADD.W	D7,D3
	MOVE.W	D3,-(A7)
	JSR	_DISTANCE
	ADDQ.W	#8,A7
	MOVEA.W	D0,A3
	CMPA.W	A2,A3
	BGE.B	L00AB7

	MOVE.W	D7,-$0006(A5)
	MOVE.W	D6,-$0004(A5)
	MOVEA.W	A3,A2
L00AB7:
	ADDQ.W	#1,D7
	CMP.W	#$0001,D7
	BLE.B	L00AB5

	ADDQ.W	#1,D6
	CMP.W	#$0001,D6
	BLE.B	L00AB4

	CMPA.W	-$0002(A5),A2
	BGE.B	L00AB8

	MOVE.W	-$0006(A5),D4
	MOVE.W	-$0004(A5),D5
L00AB8:
	ADDQ.W	#1,D4
	MULU.W	#$0003,D4
	ADDQ.W	#1,D5
	ADD.w	D5,D4
	LEA	_mvt-BASE(A4),A6	;_mvt "ykuhllbjn"
	MOVE.B	$00(A6,D4.w),D0
	EXT.W	D0

	MOVEM.L	(A7)+,D4-D7/A2/A3
	UNLK	A5
	RTS

_one_step:
	LINK	A5,#-$0004

	MOVE.W	$000A(A5),d0
	MOVE.W	$0008(A5),d1
	JSR	_INDEXquick

	MOVEA.L	__level-BASE(A4),A6	;__level
	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	MOVE.W	D3,-(A7)
	JSR	_step_ok
	ADDQ.W	#2,A7
	TST.W	D0
	BNE.B	L00ABA

	MOVEQ	#$00,D0
L00AB9:
	UNLK	A5
	RTS

L00ABA:
	MOVE.W	$0008(A5),-$0002(A5)
	MOVE.W	$000A(A5),-$0004(A5)
	PEA	-$0004(A5)
	PEA	_player+10-BASE(A4)	;_player + 10
	JSR	_diag_ok
	ADDQ.W	#8,A7
	BRA.B	L00AB9

