;/*
; * msg:
; *  Display a message at the top of the screen.
; */

_msg:
	LINK	A5,#-$0000
	MOVEA.L	$0008(A5),A6
	TST.B	(A6)
	BNE.B	L0013B		;if the string is "", just clear the line

	moveq	#0,d0
	moveq	#0,d1
	JSR	_movequick

	JSR	_clrtoeol
	CLR.W	_mpos-BASE(A4)	;_mpos
L0013A:
	UNLK	A5
	RTS

L0013B:
	MOVE.L	$001C(A5),-(A7)
	MOVE.L	$0018(A5),-(A7)
	MOVE.L	$0014(A5),-(A7)
	MOVE.L	$0010(A5),-(A7)
	MOVE.L	$000C(A5),-(A7)
	MOVE.L	$0008(A5),-(A7)
	JSR	_doadd(PC)
	LEA	$0018(A7),A7
	BSR.B	_endmsg
	BRA.B	L0013A

;/*
; * addmsg:
; *  Add things to the current message
; */

_addmsg:
	LINK	A5,#-$0000
	MOVE.L	$001C(A5),-(A7)
	MOVE.L	$0018(A5),-(A7)
	MOVE.L	$0014(A5),-(A7)
	MOVE.L	$0010(A5),-(A7)
	MOVE.L	$000C(A5),-(A7)
	MOVE.L	$0008(A5),-(A7)
	JSR	_doadd(PC)
	LEA	$0018(A7),A7
	UNLK	A5
	RTS

;/*
; * endmsg:
; *  Display a new msg (giving him a chance to see the previous one
; *  if it is up there with the --More--)
; */

_endmsg:
;	LINK	A5,#-$0000
	TST.B	_save_msg-BASE(A4)	;_save_msg
	BEQ.B	L0013C
	MOVE.L	_msgbuf-BASE(A4),-(A7)	;_msgbuf
	PEA	_huh-BASE(A4)	;_huh
	JSR	_strcpy
	ADDQ.W	#8,A7
L0013C:
	TST.W	_mpos-BASE(A4)	;_mpos
	BEQ.B	L0013D
	CLR.L	-(A7)
	JSR	_look
	ADDQ.W	#4,A7

	MOVE.W	_mpos-BASE(A4),d1	;_mpos
	moveq	#0,d0
	JSR	_movequick

	PEA	L0013F(PC)	;"More"
	BSR.B	_more
	ADDQ.W	#4,A7
L0013D:
	MOVEA.L	_msgbuf-BASE(A4),A6	;_msgbuf
	MOVE.B	(A6),D0
	JSR	_islower

	TST.W	D0
	BEQ.B	L0013E
	MOVEA.L	_msgbuf-BASE(A4),A6	;_msgbuf
	MOVE.B	$0001(A6),D3
	EXT.W	D3
	CMP.W	#$0029,D3
	BEQ.B	L0013E
	MOVEA.L	_msgbuf-BASE(A4),A6	;_msgbuf
	MOVE.L	A6,-(A7)
	MOVEA.L	_msgbuf-BASE(A4),A6	;_msgbuf
	MOVE.B	(A6),D3
	MOVE.W	D3,-(A7)
	JSR	_toupper
	ADDQ.W	#2,A7
	MOVEA.L	(A7)+,A6
	MOVE.B	D0,(A6)
L0013E:
	MOVE.L	_msgbuf-BASE(A4),-(A7)	;_msgbuf
	CLR.W	-(A7)
	JSR	_putmsg(PC)
	ADDQ.W	#6,A7
	MOVE.W	_addch_text+20-BASE(A4),_mpos-BASE(A4)	;_mpos
	CLR.W	_addch_text+20-BASE(A4)
;	UNLK	A5
	RTS

L0013F:	dc.b	" More ",0,0

_more:
	LINK	A5,#-$0058
	MOVEM.L	D4/D5,-(A7)
	MOVE.W	#$0001,-$0056(A5)
	CLR.W	-$0058(A5)
	MOVE.L	$0008(A5),A0
	JSR	_strlenquick

	MOVE.W	D0,D5
	PEA	-$0004(A5)
	PEA	-$0002(A5)
	JSR	_getrc
	ADDQ.W	#8,A7
	TST.W	-$0002(A5)
	BEQ.B	L00140

	CLR.W	-$0002(A5)
	MOVE.W	#$0050,-$0004(A5)
L00140:
	MOVE.W	-$0004(A5),D3
	ADD.W	D5,D3
	CMP.W	#$0050,D3
	BLE.B	L00141

	MOVEQ	#$50,D1
	SUB.W	D5,D1
	MOVE.W	D1,-$0004(A5)
	MOVE.W	-$0002(A5),d0
	JSR	_movequick

	MOVE.W	#$0001,-$0058(A5)
L00141:
	MOVEQ	#$00,D4
	BRA.B	L00144
L00142:
	LEA	-$0054(A5),A6
	MOVE.L	A6,-(A7)
	JSR	_inch(PC)
	MOVEA.L	(A7)+,A6
	MOVE.B	D0,$00(A6,D4.W)
	MOVE.W	D4,D3
	ADD.W	-$0004(A5),D3
	CMP.W	#$004E,D3
	BGE.B	L00143

	MOVE.W	-$0004(A5),D1
	ADD.W	D4,D1
	ADDQ.W	#1,D1
	MOVE.W	-$0002(A5),d0
	JSR	_movequick

L00143:
	MOVE.W	D4,D3
	ADDQ.W	#1,D3
	LEA	-$0054(A5),A6
	CLR.B	$00(A6,D3.W)
	ADDQ.W	#1,D4
L00144:
	CMP.W	D5,D4
	BLT.B	L00142

	MOVE.W	-$0004(A5),d1
	MOVE.W	-$0002(A5),d0
	JSR	_movequick

	JSR	_standout
	MOVE.L	$0008(A5),-(A7)
	JSR	_addstr
	ADDQ.W	#4,A7
	JSR	_standend
L00145:
	JSR	_readchar

	CMP.W	#$0020,D0	;' '
	BEQ.B	L00148

	TST.W	-$0058(A5)
	BEQ.B	L00146

	TST.W	-$0056(A5)
	BEQ.B	L00146

	MOVE.W	-$0004(A5),d1
	MOVE.W	-$0002(A5),d0
	JSR	_movequick

	PEA	-$0054(A5)
	JSR	_addstr
	ADDQ.W	#4,A7
	CLR.W	-$0056(A5)
	BRA.B	L00147
L00146:
	TST.W	-$0058(A5)
	BEQ.B	L00147

	MOVE.W	-$0004(A5),d1
	MOVE.W	-$0002(A5),d0
	JSR	_movequick

	JSR	_standout
	MOVE.L	$0008(A5),-(A7)
	JSR	_addstr
	ADDQ.W	#4,A7
	JSR	_standend
	MOVE.W	#$0001,-$0056(A5)
L00147:
	BRA.B	L00145
L00148:
	MOVE.W	-$0004(A5),d1
	MOVE.W	-$0002(A5),d0
	JSR	_movequick

	PEA	-$0054(A5)
	JSR	_addstr
	ADDQ.W	#4,A7

	MOVEM.L	(A7)+,D4/D5
	UNLK	A5
	RTS

;/*
; * doadd:
; *  Perform an add onto the message buffer
; */

_doadd:
	LINK	A5,#-$0000

	MOVE.L	$001C(A5),-(A7)
	MOVE.L	$0018(A5),-(A7)
	MOVE.L	$0014(A5),-(A7)
	MOVE.L	$0010(A5),-(A7)
	MOVE.L	$000C(A5),-(A7)
	MOVE.L	$0008(A5),-(A7)
	MOVE.W	_addch_text+20-BASE(A4),D3		;_addch_text + $14
	EXT.L	D3
	ADD.L	_msgbuf-BASE(A4),D3		;_msgbuf
	MOVE.L	D3,-(A7)
	JSR	_sprintf
	LEA	$001C(A7),A7

	MOVE.L	_msgbuf-BASE(A4),A0	;_msgbuf
	JSR	_strlenquick

	MOVE.W	D0,_addch_text+20-BASE(A4)		;_addch_text + $14

	UNLK	A5
	RTS

;/*
; * step_ok:
; *  Returns true if it is ok to step on ch
; */

_step_ok:
	LINK	A5,#-$0000
	MOVE.W	$0008(A5),D0
;	EXT.L	D0
	BRA.B	L008A0
L0089A:
	MOVEQ	#$00,D0
L0089B:
	UNLK	A5
	RTS

L0089C:
	CMPI.W	#$0041,$0008(A5)	; 'A'
	BLT.B	L0089D
	CMPI.W	#$005A,$0008(A5)	; 'Z'
	BLE.B	L0089A
L0089D:
	MOVEq	#$0001,D0
	BRA.B	L0089B
L008A0:
	SUB.w	#$0020,D0	; ' '
	BEQ.B	L0089A
	SUB.w	#$000D,D0	; '-'
	BEQ.B	L0089A
	SUB.w	#$000F,D0	; '<'
	BEQ.B	L0089A
	SUBQ.w	#2,D0		; '>'
	BEQ.B	L0089A
	SUB.w	#$003D,D0	; '{'
	BEQ.B	L0089A
	SUBQ.w	#1,D0		; '|'
	BEQ.B	L0089A
	SUBQ.w	#1,D0		; '}'
	BEQ.B	L0089A
	BRA.B	L0089C
;	BRA.B	L0089B

; check if items are good or bad (return + for bad items)

_goodch:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVEQ	#$24,D4		;'$'
	MOVE.W	$0028(A2),D3
	AND.W	#O_ISCURSED,D3	;ISCURSED
	BEQ.B	L008A1

	MOVEQ	#$2B,D4		;'+'
L008A1:
	MOVE.L	A2,-(A7)
	JSR	_typeof
	ADDQ.W	#4,A7
;	EXT.L	D0
	BRA.W	L008B8
L008A2:
	MOVE.W	$0020(A2),D0	;check scrolls
;	EXT.L	D0
	BRA.B	L008A4
L008A3:
	MOVEQ	#$2B,D4		;'+'
	BRA.B	L008A5
L008A4:
	SUBQ.w	#3,D0	;sleep
	BEQ.B	L008A3
	SUBQ.w	#7,D0	;create monster
	BEQ.B	L008A3
	SUBQ.w	#2,D0	;aggravate monster
	BEQ.B	L008A3
L008A5:
	BRA.W	L008B9
L008A6:
	MOVE.W	$0020(A2),D0	;check potions
;	EXT.L	D0
	BRA.B	L008AA
L008A7:
	MOVEQ	#$2B,D4		;'+'
	BRA.B	L008AB
L008A8:
	MOVE.W	-$52AC(A4),D3	;_player + 30 (rank)
	SUBQ.W	#1,D3
;	EXT.L	D3
	ASL.w	#2,D3
	MOVEA.L	_e_levels-BASE(A4),A6	;_e_levels
	TST.L	$00(A6,D3.w)
	BNE.B	L008A9

	MOVEQ	#$2B,D4		;'+'
L008A9:
	BRA.B	L008AB
L008AA:
	TST.b	D0	;confusion
	BEQ.B	L008A7
	SUBQ.b	#1,D0	;paralysis
	BEQ.B	L008A7
	SUBQ.b	#1,D0	;poison
	BEQ.B	L008A7
	SUBQ.b	#6,D0	;raise level
	BEQ.B	L008A8
	SUBQ.b	#4,D0	;blindness
	BEQ.B	L008A7
L008AB:
	BRA.B	L008B9
L008AC:
	MOVE.W	$0020(A2),D0	;check wand/staff
;	EXT.L	D0
	BRA.B	L008AE
L008AD:
	MOVEQ	#$2B,D4		;'+'
	BRA.B	L008AF
L008AE:
	SUBQ.w	#7,D0		;haste monster
	BEQ.B	L008AD
	SUBQ.w	#5,D0		;teleport to
	BEQ.B	L008AD
L008AF:
	BRA.B	L008B9
L008B0:
	MOVE.W	$0020(A2),D0	;check rings
;	EXT.L	D0
	BRA.B	L008B5
L008B1:
	CMPI.W	#$0000,$0026(A2)	;has good values?
	BGE.B	L008B9
L008B3:
	MOVEQ	#$2B,D4		;'+'
	BRA.B	L008B9
L008B4:
	dc.w	L008B1-L008B6	;protection
	dc.w	L008B1-L008B6	;add strength
	dc.w	L008B9-L008B6	;sustain armor
	dc.w	L008B9-L008B6	;searching
	dc.w	L008B9-L008B6	;see invisible
	dc.w	L008B9-L008B6	;adornment
	dc.w	L008B3-L008B6	;aggravate monser
	dc.w	L008B1-L008B6	;dexterity
	dc.w	L008B1-L008B6	;increase damage
	dc.w	L008B9-L008B6	;regeneration
	dc.w	L008B9-L008B6	;slow digestion
	dc.w	L008B3-L008B6	;teleportation
L008B5:
	CMP.w	#$000C,D0
	BCC.B	L008B9
	ASL.w	#1,D0
	MOVE.W	L008B4(PC,D0.W),D0
L008B6:	JMP	L008B6(PC,D0.W)
L008B8:
	SUB.w	#$0021,D0	;'!' potion
	BEQ.W	L008A6
	SUB.w	#$000E,D0	;'/' wand/staff
	BEQ.B	L008AC
	SUB.w	#$000E,D0	;'=' ring
	BEQ.B	L008B0
	SUBQ.w	#2,D0		;'?' player
	BEQ.W	L008A2
L008B9:
	MOVE.W	D4,D0
	MOVEM.L	(A7)+,D4/A2
	UNLK	A5
	RTS

_putmsg:
	LINK	A5,#-$0002
	MOVEM.L	D4/A2/A3,-(A7)

	SUBA.L	A3,A3
	MOVEA.L	$000A(A5),A2
L00149:
	MOVE.L	A2,-(A7)
	MOVE.L	A3,-(A7)
	MOVE.W	$0008(A5),-(A7)
	JSR	_scrl(PC)
	LEA	$000A(A7),A7
	MOVE.L	A2,A0
	JSR	_strlenquick

	MOVE.W	D0,-$0002(A5)
	MOVE.W	D0,_addch_text+20-BASE(A4)
	CMPI.W	#$0050,-$0002(A5)
	BLE.B	L0014D

	PEA	L0014E(PC)
	JSR	_more(PC)
	ADDQ.W	#4,A7
	MOVEA.L	A2,A3
L0014A:
	MOVE.W	#$0020,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_index
	ADDQ.W	#6,A7
	MOVE.L	D0,D4
;	TST.L	D4
	BEQ.B	L0014B

	MOVEA.L	A3,A6
	ADDA.L	#$00000050,A6
	CMP.L	A6,D4
	BCS.B	L0014C
L0014B:
	CMPA.L	A2,A3
	BNE.B	L0014C
	MOVEA.L	A3,A2
	ADDA.L	#$00000050,A2
	BRA.B	L0014D
L0014C:
	MOVEA.L	A3,A6
	ADDA.L	#$00000050,A6
	CMP.L	A6,D4
	BCC.B	L0014D

	MOVE.L	A2,A0
	JSR	_strlenquick

	CMP.W	#$0050,D0
	BLT.B	L0014D

	MOVEA.L	D4,A2
	ADDQ.L	#1,A2
	BRA.B	L0014A
L0014D:
	CMPI.W	#$0050,-$0002(A5)
	BGT.W	L00149

	MOVEM.L	(A7)+,D4/A2/A3
	UNLK	A5
	RTS

L0014E:	dc.b	" Cont ",0,0

; curses scrl - scroll a curses window

_scrl:
	LINK	A5,#-$0004
	MOVEM.L	D4/D5,-(A7)

	LEA	L00154(PC),A6
	MOVE.L	A6,-$0004(A5)
	BRA.B	L0014F

	dc.l	$4DFA008A	;"M   "
	dc.l	$2B4EFFFC	;"+N  "
L0014F:
	TST.L	$000A(A5)
	BNE.B	L00151

	moveq	#0,d1
	MOVE.w	$0008(A5),d0
	JSR	_movequick

	MOVE.L	$000E(A5),A0
	JSR	_strlenquick

	CMP.W	#$0050,D0
	BGE.B	L00150
	JSR	_clrtoeol
L00150:
	MOVE.L	$000E(A5),-(A7)
	MOVE.L	-$0004(A5),-(A7)
	JSR	_printw
	ADDQ.W	#8,A7
	BRA.B	L00153
L00151:
	MOVEA.L	$000A(A5),A6
	CMPA.L	$000E(A5),A6
	BHI.B	L00153

	moveq	#0,d1
	MOVE.W	$0008(A5),d0
	JSR	_movequick

	MOVEA.L	$000A(A5),A6
	ADDQ.L	#1,$000A(A5)
	MOVE.L	A6,-(A7)
	MOVE.L	-$0004(A5),-(A7)
	JSR	_printw
	ADDQ.W	#8,A7
	MOVE.L	$000A(A5),A0
	JSR	_strlenquick

	CMP.W	#$004F,D0
	BGE.B	L00152
	JSR	_clrtoeol
L00152:
	BRA.B	L00151
L00153:
	MOVEM.L	(A7)+,D4/D5
	UNLK	A5
	RTS

L00154:	dc.b	"%.80s",0
	dc.b	"%.40s",0

; curses unctrl

_unctrl:
	LINK	A5,#-$0000
	MOVE.B	$0009(A5),D0

	JSR	_isspace(PC)

	TST.W	D0
	BEQ.B	L00155

	PEA	L0015A(PC)
	PEA	-$54F6(A4)
	JSR	_strcpy
	ADDQ.W	#8,A7
	BRA.B	L00159
L00155:
	MOVE.B	$0009(A5),D0
	JSR	_isprint(PC)

	TST.W	D0
	BNE.B	L00158

	MOVEQ	#$00,D3
	MOVE.B	$0009(A5),D3
	CMP.W	#$0020,D3
	BCC.B	L00156

	MOVEQ	#$00,D3
	MOVE.B	$0009(A5),D3
	ADD.W	#$0040,D3
	MOVE.W	D3,-(A7)
	PEA	L0015B(PC)
	PEA	-$54F6(A4)
	JSR	_sprintf
	LEA	$000A(A7),A7
	BRA.B	L00157
L00156:
	MOVEQ	#$00,D3
	MOVE.B	$0009(A5),D3
	MOVE.W	D3,-(A7)
	PEA	L0015C(PC)
	PEA	-$54F6(A4)
	JSR	_sprintf
	LEA	$000A(A7),A7
L00157:
	BRA.B	L00159
L00158:
	MOVE.B	$0009(A5),-$54F6(A4)
	CLR.B	-$54F5(A4)
L00159:
	LEA	-$54F6(A4),A6
	MOVE.L	A6,D0
	UNLK	A5
	RTS

L0015A:	dc.b	" ",0
L0015B:	dc.b	"^%c",0
L0015C:	dc.b	"\x%x",0

;/*
; * readchar:
; *  Reads and returns a character, checking for gross input errors
; */

_readchar:
	LINK	A5,#-$001E
	MOVEM.L	D4-D7/A2/A3,-(A7)
	CLR.W	-$001E(A5)
L004EE:
	MOVEA.L	_kb_head-BASE(A4),A6
	CMPA.L	_kb_tail-BASE(A4),A6	;_kb_tail
	BEQ.B	L004F0

	MOVEA.L	_kb_tail-BASE(A4),A6	;_kb_tail
	ADDQ.L	#1,_kb_tail-BASE(A4)	;_kb_tail
	MOVE.B	(A6),D0
	EXT.W	D0
L004EF:
	MOVEM.L	(A7)+,D4-D7/A2/A3
	UNLK	A5
	RTS

L004F0:
	LEA	_kb_buffer-BASE(A4),A6
	MOVE.L	A6,_kb_tail-BASE(A4)	;_kb_tail
	MOVE.L	A6,_kb_head-BASE(A4)
L004F1:
	MOVEA.L	_StdWin-BASE(A4),A6	;_StdWin
	MOVE.L	$0056(A6),-(A7)
	JSR	_GetMsg
	ADDQ.W	#4,A7
	MOVE.L	D0,-$0004(A5)
;	TST.L	D0
	BNE.B	L004F2
	JSR	_ran(PC)
	BRA.B	L004F1
L004F2:
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$0018(A6),D5
;	MOVEA.L	-$0004(A5),A6
	MOVE.L	$0014(A6),D4
;	MOVEA.L	-$0004(A5),A6
	MOVE.W	$0022(A6),D7
;	MOVEA.L	-$0004(A5),A6
	MOVEA.W	$0020(A6),A2
;	MOVEA.L	-$0004(A5),A6
	MOVE.W	$001A(A6),D6
;	MOVEA.L	-$0004(A5),A6
	MOVEA.L	$001C(A6),A3
	CMP.L	#$00002000,D4
	BNE.B	L004F7

	MOVE.W	D5,D3
;	EXT.L	D3
	CMP.w	#$0001,D3
	BNE.B	L004F6

	TST.B	_menu_on-BASE(A4)	;_menu_on
	BEQ.B	L004F5

	TST.B	_map_up-BASE(A4)	;_map_up
	BEQ.B	L004F5

	CMP.W	#$0000,D7
	BLT.B	L004F3

	MOVE.W	D6,D3
;	EXT.L	D3
	AND.w	#$0080,D3
	BEQ.B	L004F5
L004F3:
	MOVE.W	D6,D3
;	EXT.L	D3
	AND.w	#$0080,D3
	BNE.B	L004F4
	JSR	_want_a_menu
L004F4:
	BRA.B	L004F6
L004F5:
	MOVEA.L	_kb_head-BASE(A4),A6
	ADDQ.L	#1,_kb_head-BASE(A4)
	MOVE.B	#$20,(A6)
	MOVEA.L	-$0004(A5),A6
	MOVE.W	#$0002,$0018(A6)
L004F6:
	MOVE.L	-$0004(A5),-(A7)
	JSR	_ReplyMsg
	ADDQ.W	#4,A7
	BRA.W	L0050F
L004F7:
	MOVE.L	-$0004(A5),-(A7)
	JSR	_ReplyMsg
	ADDQ.W	#4,A7
	MOVE.L	D4,D0
	BRA.W	L0050E
L004F8:
	CLR.L	-$001A(A5)
	MOVE.B	#$01,-$0016(A5)
	MOVE.W	D5,-$0014(A5)
	MOVE.W	D6,-$0012(A5)
	PEA	-$58B8(A4)
	LEA	_kb_head-BASE(A4),A6
	SUBA.L	_kb_head-BASE(A4),A6
	MOVE.L	A6,-(A7)
	MOVE.L	_kb_head-BASE(A4),-(A7)
	PEA	-$001A(A5)
	JSR	_RawKeyConvert
	LEA	$0010(A7),A7
	MOVE.W	D0,-$001C(A5)
	MOVE.W	-$001C(A5),D3
	EXT.L	D3
	ADD.L	D3,_kb_head-BASE(A4)
	BRA.W	L0050F
L004F9:
	JSR	_flush_type(PC)
	MOVE.W	D5,D3
	EXT.L	D3
	MOVE.L	D3,-(A7)
	JSR	_DoMenu
	ADDQ.W	#4,A7
	MOVE.W	D0,-$001C(A5)
;	TST.W	D0
	BEQ.B	L004FA
	MOVE.B	#$01,_com_from_menu-BASE(A4)	;_com_from_menu
	MOVEA.L	_kb_head-BASE(A4),A6
	ADDQ.L	#1,_kb_head-BASE(A4)
	MOVE.B	-$001B(A5),(A6)
L004FA:
	BRA.W	L0050F
L004FB:
	TST.W	-$001E(A5)
	BEQ.B	L004FC
	MOVE.W	D7,-(A7)
	JSR	_sel_line(PC)
	ADDQ.W	#2,A7
	MOVE.W	D0,-(A7)
	JSR	_choose_row(PC)
	ADDQ.W	#2,A7
L004FC:
	BRA.W	L0050F
L004FD:
	MOVE.W	D5,D0
;	EXT.L	D0
	BRA.W	L00507
L004FE:
	TST.B	_map_up-BASE(A4)	;_map_up
	BEQ.B	L00501

	MOVE.W	D6,D3
;	EXT.L	D3
	AND.w	#$0003,D3
	BEQ.B	L004FF

	MOVEA.L	_kb_head-BASE(A4),A6
	ADDQ.L	#1,_kb_head-BASE(A4)
	MOVE.B	#$2E,(A6)
	BRA.B	L00500
L004FF:
	TST.B	_menu_on-BASE(A4)	;_menu_on
	BEQ.B	L00500

	MOVEA.L	_kb_head-BASE(A4),A6
	ADDQ.L	#1,_kb_head-BASE(A4)
	MOVE.L	A6,-(A7)
	MOVE.W	A2,-(A7)
	MOVE.W	D7,-(A7)
	JSR	_mouse_go
	ADDQ.W	#4,A7
	MOVEA.L	(A7)+,A6
	MOVE.B	D0,(A6)
L00500:
	BRA.B	L00502
L00501:
	TST.B	_want_click-BASE(A4)	;_want_click
	BEQ.B	L00502

	MOVE.W	D7,-(A7)
	JSR	_sel_line(PC)
	ADDQ.W	#2,A7
	MOVE.W	D0,-(A7)
	JSR	_choose_row(PC)
	ADDQ.W	#2,A7
	MOVE.W	#$0001,-$001E(A5)
L00502:
	BRA.B	L00508
L00503:
	TST.B	_map_up-BASE(A4)	;_map_up
	BNE.B	L00504

	CLR.W	-$001E(A5)
	MOVE.W	_choose_row_tmp-BASE(A4),-(A7)
	JSR	_sel_char
	ADDQ.W	#2,A7
	TST.b	D0
	BEQ.B	L00504

	MOVEA.L	_kb_head-BASE(A4),A6
	ADDQ.L	#1,_kb_head-BASE(A4)
	MOVE.L	A6,-(A7)
	MOVE.W	_choose_row_tmp-BASE(A4),-(A7)
	JSR	_sel_char
	ADDQ.W	#2,A7
	MOVEA.L	(A7)+,A6
	MOVE.B	D0,(A6)
	MOVE.W	_choose_row_tmp-BASE(A4),-(A7)
	JSR	_invert_row(PC)
	ADDQ.W	#2,A7
	MOVE.W	#$FFFF,_choose_row_tmp-BASE(A4)
L00504:
	BRA.B	L00508
L00505:
	TST.B	_map_up-BASE(A4)	;_map_up
	BEQ.B	L00506

	MOVE.W	D6,D3
;	EXT.L	D3
	AND.w	#$0003,D3
	BEQ.B	L00506

	MOVEA.L	_kb_head-BASE(A4),A6
	ADDQ.L	#1,_kb_head-BASE(A4)
	MOVE.B	#$73,(A6)
L00506:
	BRA.B	L00508
L00507:
	SUB.w	#$0068,D0
	BEQ.W	L004FE
	SUBQ.w	#1,D0
	BEQ.B	L00505
	SUB.w	#$007F,D0
	BEQ.B	L00503
L00508:
	BRA.W	L0050F
L00509:
	MOVEA.L	_kb_head-BASE(A4),A6
	MOVE.B	$0027(A3),(A6)
	MOVE.W	D6,D3
;	EXT.L	D3
	AND.w	#$0003,D3
	BEQ.B	L0050D
	MOVEA.L	_kb_head-BASE(A4),A6
	MOVE.B	(A6),D0
	EXT.W	D0
;	EXT.L	D0
	BRA.B	L0050C
L0050A:
	PEA	L00510(PC)		;"10s"
	MOVE.L	_kb_head-BASE(A4),-(A7)
	JSR	_strcpy
	ADDQ.W	#8,A7
	ADDQ.L	#2,_kb_head-BASE(A4)
	BRA.B	L0050D
L0050B:
	PEA	L00511(PC)		;"10."
	MOVE.L	_kb_head-BASE(A4),-(A7)
	JSR	_strcpy
	ADDQ.W	#8,A7
	ADDQ.L	#2,_kb_head-BASE(A4)
	BRA.B	L0050D
L0050C:
	SUB.w	#$002E,D0
	BEQ.B	L0050B
	SUB.w	#$0045,D0
	BEQ.B	L0050A
L0050D:
	ADDQ.L	#1,_kb_head-BASE(A4)
	BRA.B	L0050F
L0050E:
	SUBQ.w	#8,D0
	BEQ.W	L004FD
	SUBQ.w	#8,D0
	BEQ.W	L004FB
	SUB.w	#$0030,D0
	BEQ.B	L00509
	SUB.w	#$00C0,D0
	BEQ.W	L004F9
	SUB.w	#$0300,D0
	BEQ.W	L004F8
L0050F:
	MOVEA.L	_StdWin-BASE(A4),A6	;_StdWin
	MOVE.L	$0056(A6),-(A7)
	JSR	_GetMsg
	ADDQ.W	#4,A7
	MOVE.L	D0,-$0004(A5)
;	TST.L	D0
	BNE.W	L004F2
	BRA.W	L004EE
;	BRA.W	L004EF

L00510:	dc.b	"10s",0
L00511:	dc.b	"10.",0

;/*
; * status:
; *  Display the important stats line.  Keep the cursor where it was.
; */

_status:
	LINK	A5,#-$0004
	MOVE.L	D4,-(A7)

	PEA	-$0004(A5)
	PEA	-$0002(A5)
	JSR	_getrc
	ADDQ.W	#8,A7

	TST.B	_new_stats-BASE(A4)	;_new_stats
	BNE.B	L0015D

	MOVE.W	-$54EC(A4),D3
	CMP.W	-$52A8(A4),D3	;_player + 34 (hp)
	BNE.B	L0015D

	MOVE.W	-$54EA(A4),D3
	CMP.W	-$52A2(A4),D3	;_player + 40 (max hp)
	BEQ.B	L0015E
L0015D:
	moveq	#0,d1
	MOVEq	#$0014,d0
	JSR	_movequick

	MOVE.W	-$52A2(A4),-(A7)	;_player + 40 (max hp)
	MOVE.W	-$52A8(A4),-(A7)	;_player + 34 (hp)
	PEA	L00169(PC)	;"Hits:%.3d(%.3d)  "
	JSR	_printw
	ADDQ.W	#8,A7
	MOVE.W	-$52A8(A4),-$54EC(A4)	;_player + 34 (hp)
	MOVE.W	-$52A2(A4),-$54EA(A4)	;_player + 40 (max hp)
L0015E:
	TST.B	_new_stats-BASE(A4)	;_new_stats
	BNE.B	L0015F

	MOVE.W	-$54E8(A4),D3
	CMP.W	-$52B2(A4),D3	;_player + 24 (strength)
	BNE.B	L0015F

	MOVE.W	-$54E6(A4),D3
	CMP.W	_max_stats+0-BASE(A4),D3	;_max_stats + 0 (max strength)
	BEQ.B	L00160
L0015F:
	MOVEq	#$000F,d1
	MOVEq	#$0014,d0
	JSR	_movequick
	MOVE.W	_max_stats+0-BASE(A4),-(A7)	;_max_stats + 0 (max strength)
	MOVE.W	-$52B2(A4),-(A7)	;_player + 24 (strength)
	PEA	L0016A(PC)	;"Str:%.3d(%.3d)"
	JSR	_printw
	ADDQ.W	#8,A7
	MOVE.W	-$52B2(A4),-$54E8(A4)	;_player + 24 (strength)
	MOVE.W	_max_stats+0-BASE(A4),-$54E6(A4)	;_max_stats + 0 (max strength),
L00160:
	TST.B	_new_stats-BASE(A4)	;_new_stats
	BNE.B	L00161

	MOVE.W	-$54E4(A4),D3	;last printed purse
	CMP.W	_purse-BASE(A4),D3	;_purse
	BEQ.B	L00162
L00161:
	MOVEq	#$001C,d1
	MOVEq	#$0014,d0
	JSR	_movequick

	MOVE.W	_purse-BASE(A4),-(A7)	;_purse
	PEA	L0016B(PC)	;"Gold:%-5.5u"
	JSR	_printw
	ADDQ.W	#6,A7
	MOVE.W	_purse-BASE(A4),-$54E4(A4)	;_purse, last printed purse
L00162:
	MOVE.L	_cur_armor-BASE(A4),D0	;_cur_armor
	BEQ.B	L00163

	MOVEA.L	D0,A6		;_cur_armor
	MOVE.W	$0026(A6),D4
	BRA.B	L00164
L00163:
	MOVE.W	-$52AA(A4),D4	;_player + 32 (AC)
L00164:
	MOVE.L	_cur_ring_1-BASE(A4),D0	;_cur_ring_1
	BEQ.B	L00165

	MOVEA.L	D0,A6		;_cur_ring_1
	CMP.W	#R_PROTECT,$0020(A6)
	BNE.B	L00165

	SUB.W	$0026(A6),D4
L00165:
	MOVE.L	_cur_ring_2-BASE(A4),D0	;_cur_ring_2
	BEQ.B	L00166

	MOVEA.L	D0,A6		;_cur_ring_2
	CMP.W	#R_PROTECT,$0020(A6)
	BNE.B	L00166

	SUB.W	$0026(A6),D4
L00166:
	TST.B	_new_stats-BASE(A4)	;_new_stats
	BNE.B	L00167

	CMP.W	-$54E2(A4),D4	;last printed armor class
	BEQ.B	L00168
L00167:
	MOVEq	#$002A,d1
	MOVEq	#$0014,d0
	JSR	_movequick

	MOVE.W	D4,D3
	SUB.W	#11,D3
	NEG.W	D3
	MOVE.W	D3,-(A7)
	PEA	L0016C(PC)	;"Armor:%-2.2d"
	JSR	_printw
	ADDQ.W	#6,A7
	MOVE.W	D4,-$54E2(A4)	;last printed armor class

L00168:
	CLR.B	_new_stats-BASE(A4)	;_new_stats

	MOVE.w	-$0004(A5),d1
	MOVE.w	-$0002(A5),d0
	JSR	_movequick

	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

L00169:	dc.b	"Hits:%.3d(%.3d)  ",0
L0016A:	dc.b	"Str:%.3d(%.3d)",0
L0016B:	dc.b	"Gold:%-5.5u",0
L0016C:	dc.b	"Armor:%-2.2d",0

L0016Cb:	dc.b	"XP:%ld",0,0

;/*
; * wait_for
; *  Sit around until the guy types the right key
; */

_wait_for:
	LINK	A5,#-$0000

	CMP.B	#$0A,$0009(A5)
	BNE.B	2$
1$
	JSR	_readchar
	CMP.B	#$0A,D0
	BEQ.B	3$

	CMP.B	#$0D,D0
	BEQ.B	3$

	BRA.B	1$
2$
	JSR	_readchar
	MOVE.B	$0009(A5),D3
	CMP.B	D3,D0
	BNE.B	2$
3$
	UNLK	A5
	RTS

;/*
; * show_win:
; *  Function used to display a window and wait before returning
; */

;_show_win:
;	LINK	A5,#-$0000
;
;	MOVE.L	$0008(A5),-(A7)
;	CLR.W	-(A7)
;	CLR.W	-(A7)
;	JSR	_mvaddstr
;	ADDQ.W	#8,A7
;
;	MOVE.W	-$52C0(A4),d1	;_player + 10
;	MOVE.W	-$52BE(A4),d0	;_player + 12
;	JSR	_movequick
;
;	MOVE.W	#$0020,-(A7)	; SPACE
;	BSR.B	_wait_for
;	ADDQ.W	#2,A7
;
;	UNLK	A5
;	RTS
