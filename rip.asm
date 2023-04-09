;/*
; * score:
; *  Figure score and post it.
; */

_score:
	LINK	A5,#-$01FC
	MOVEM.L	D4/D5,-(A7)

	MOVEQ	#$00,D4
	MOVEQ	#$00,D5
	MOVE.W	#$0001,-$01FC(A5)
	JSR	_wtext
L00673:
	CLR.W	-(A7)
	PEA	L0067B(PC)	;"Rogue.Score"
	JSR	_AmigaOpen(PC)
	ADDQ.W	#6,A7

	MOVE.W	D0,r_score_fd(A4)	;rogue.score filehd
;	CMP.W	#$0000,D0
	BGE.B	L00677

	TST.B	_noscore(A4)	;_noscore
	BNE.B	L00674

	TST.W	$0008(A5)
	BNE.B	L00675
L00674:
	MOVEM.L	(A7)+,D4/D5
	UNLK	A5
	RTS

L00675:
	PEA	L0067E(PC)	;"Don't create it"
	PEA	L0067D(PC)	;"Create it"
	PEA	L0067C(PC)	;"The Hall of Fame file does not exist."
	JSR	_ask_him
	LEA	$000C(A7),A7
	TST.W	D0
	BNE.B	L00676

	CLR.W	-$01FC(A5)
	BRA.B	L00677
L00676:
	MOVE.W	#460,-(A7)	;10 entries with 46 bytes each
	PEA	L0067B(PC)	;"Rogue.Score"
	JSR	_AmigaCreat(PC)
	ADDQ.W	#6,A7

	MOVE.W	D0,-(A7)
	JSR	_AmigaClose(PC)
	ADDQ.W	#2,A7
	BRA.B	L00673
L00677:
	CLR.W	d1
	MOVE.W	#460,d0
	LEA	-$01FA(A5),a0
	JSR	_memset

	PEA	-$01FA(A5)
	JSR	_get_scores(PC)
	ADDQ.W	#4,A7

	move.b	#-1,_MathBase(A4)	;normal is negativ, score color flag

	tst.b	_noscore(A4)	;_noscore
	bne	L00679

	;hiding strength, maxhp and experience points in the highscore
	move.l	_player+26(A4),-$000E(A5)	;_player + 26 (EXP)
	move.b	_player+25(A4),-$000A(A5)	;_player + 24 strength
	move.b	_player+41(A4),-$0009(A5)	;_player + 40 (max HP)

	PEA	_whoami(A4)	;_whoami
	PEA	-$002E(A5)
	JSR	_strcpy
	ADDQ.W	#8,A7

	MOVE.W	$0008(A5),-$0006(A5)	;gold
	MOVE.B	$000D(A5),D3
	EXT.W	D3
	MOVE.W	D3,-$0004(A5)		;killed by
	TST.W	$000A(A5)
	BEQ.B	L00678

	MOVE.W	$000A(A5),-$0004(A5)
L00678:
	MOVE.W	_max_level(A4),-$0002(A5)	;_max_level (deepest level)
	MOVE.W	_player+30(A4),-$0008(A5)	;_player + 30 (rank)
	PEA	-$01FA(A5)	;506 (460 + 46)
	PEA	-$002E(A5)
	JSR	_add_scores(PC)
	ADDQ.W	#8,A7
	MOVE.W	D0,D5
L00679:
	MOVE.W	r_score_fd(A4),-(A7)
	JSR	_AmigaClose(PC)
	ADDQ.W	#2,A7

	CMP.W	#$0000,D5
	BLE.B	L0067A

	TST.W	-$01FC(A5)
	BEQ.B	L0067A

	MOVE.W	#460,-(A7)
	PEA	L0067B(PC)	;"Rogue.Score"
	JSR	_AmigaCreat(PC)
	ADDQ.W	#6,A7

	MOVE.W	D0,r_score_fd(A4)	;rogue.score filehd
;	CMP.W	#$0000,D0
	BLT.B	L0067A

	PEA	-$01FA(A5)	;506 (460 + 46)
	JSR	_put_scores(PC)
	ADDQ.W	#4,A7

	MOVE.W	r_score_fd(A4),-(A7)	;rogue.score filehd
	JSR	_AmigaClose(PC)
	ADDQ.W	#2,A7
L0067A:
	PEA	-$01FA(A5)	;506 (460 + 46)
	MOVE.W	D5,-(A7)
	JSR	_pr_scores(PC)
	ADDQ.W	#6,A7

	JSR	_flush_type
	JSR	_readchar
	BRA.W	L00674

L0067B:	dc.b	"Rogue.Score",0
L0067C:	dc.b	"The Hall of Fame file does not exist.",0
L0067D:	dc.b	"Create it",0
L0067E:	dc.b	"Don't create it",0

;/*
; * read_score
; *  Read in the score file
; */

_get_scores:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5,-(A7)

	MOVEQ	#$01,D5
	MOVEQ	#10-1,D4	;read ten entries, -1 for dbra
L00681:
	CMP.W	#$0000,D5
	BLE.B	L00682

	MOVE.W	#46,-(A7)		;read 46 bytes
	MOVE.L	$0008(A5),-(A7)
	MOVE.W	r_score_fd(A4),-(A7)	;rogue.score filehd
	JSR	_read
	ADDQ.W	#8,A7
	MOVE.W	D0,D5
	BGT.B	L00683
L00682:
	MOVEA.L	$0008(A5),A6
	CLR.W	$0028(A6)	;clear gold entry on fail
L00683:
	ADDI.L	#46,$0008(A5)
	DBRA	D4,L00681	; 10 highscore entries

	MOVEM.L	(A7)+,D4/D5
	UNLK	A5
	RTS

;/*
; * write_score
; *  Write out the score file
; */

_put_scores:
	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)

	MOVEQ	#10-1,D4	;save ten entries, -1 for dbra
loop$	MOVEA.L	$0008(A5),A6
	TST.W	$0028(A6)	;the gold score
	BEQ.B	L00685

	MOVE.W	#46,-(A7)	; 46 bytes per entry
	MOVE.L	A6,-(A7)
	MOVE.W	r_score_fd(A4),-(A7)	;rogue.score filehd
	JSR	_write
	ADDQ.W	#8,A7
	CMP.W	#$0000,D0
	BLE.B	L00685

	ADDI.L	#46,$0008(A5)	; next entry
	DBRA	D4,loop$	; 10 highscore entries

L00685:	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

;/*
; * score:
; *  Figure score and post it.
; */

_pr_scores:
	LINK	A5,#-$0054
	MOVE.L	D4,-(A7)
	JSR	_black_out

	CLR.L	-(A7)
	MOVE.L	_TextWin(A4),-(A7)	;_TextWin
	PEA	L00690(PC)	;"Hall.of.Fame"
	JSR	_show_ilbm
	LEA	$000C(A7),A7

	MOVE.W	#$0001,-(A7)
	JSR	_cursor(PC)
	ADDQ.W	#2,A7
	MOVEQ	#$00,D4
L00689:
	MOVEA.L	$000A(A5),A6
	CMPI.W	#$0000,$0028(A6)
	BLE.W	L0068F

	MOVEq	#$0004,d1
	MOVE.W	D4,D0
	ADDQ.W	#7,D0
	JSR	_movequick

	move.b	#1,_addch_text+0(A4)	;set the default color in IntuiText

	cmp.b	_MathBase(A4),d4	;_all_clear + 1
	bne	1$
	move.b	#3,_addch_text+0(A4)	;changes the color in IntuiText

1$	MOVEA.L	$000A(A5),A6
	MOVE.W	$0026(A6),D3
	SUBQ.W	#1,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	_he_man(A4),A6	;_he_man
	MOVE.L	$00(A6,D3.w),-(A7)
	MOVE.L	$000A(A5),-(A7)
	MOVEA.L	$000A(A5),A6
	MOVE.W	$0028(A6),-(A7)
	PEA	L00691(PC)	;'%5d %s, "%s"'
	JSR	_printw
	LEA	$000E(A7),A7
	MOVEA.L	$000A(A5),A6

	MOVE.W	$002A(A6),d0
	JSR	_isalpha(PC)

	TST.W	D0
	BEQ.B	L0068B

	MOVEA.L	$000A(A5),A6	;who got us killed?
	CMPI.W	#26,$002C(A6)
	BGE.B	L0068B

	MOVEA.L	$000A(A5),A6
	MOVE.W	$002A(A6),D3
	AND.W	#$00FF,D3
	MOVE.W	D3,-(A7)
	JSR	_killname(PC)
	ADDQ.W	#2,A7

	MOVE.L	D0,-(A7)
	PEA	L00692(PC)	;" by %s"
	PEA	-$0050(A5)
	JSR	_sprintf
	LEA	$000C(A7),A7

	MOVEA.L	$000A(A5),A6
	MOVE.W	$002C(A6),-(A7)
	PEA	L00693(PC)	;" killed on level %d"
	JSR	_printw
	ADDQ.W	#6,A7

	PEA	-$0054(A5)
	PEA	-$0052(A5)
	JSR	_getrc
	ADDQ.W	#8,A7

	LEA	-$0050(A5),A0
	JSR	_strlenquick

	ADD.W	-$0054(A5),D0
	CMP.W	#$0046,D0	;not longer than 70 chars
	BGE.B	L0068E

	PEA	-$0050(A5)
	JSR	_addstr
	ADDQ.W	#4,A7
	BRA.B	L0068E
L0068B:
	MOVEA.L	$000A(A5),A6
	CMPI.W	#$0002,$002A(A6)
	BNE.B	L0068C

	PEA	L00694(PC)	;" A total winner!"
	JSR	_addstr
	ADDQ.W	#4,A7
	BRA.B	L0068E
L0068C:
	MOVEA.L	$000A(A5),A6
	CMPI.W	#26,$002C(A6)	; level 26
	BLT.B	L0068D

	PEA	L00695(PC)	;" Honored by the Guild"
	JSR	_addstr
	ADDQ.W	#4,A7
	BRA.B	L0068E
L0068D:
	MOVEA.L	$000A(A5),A6
	MOVE.W	$002C(A6),-(A7)
	PEA	L00696(PC)	;" quit on level %d"
	JSR	_printw
	ADDQ.W	#6,A7
L0068E:
	ADDQ.W	#1,D4
	ADDI.L	#46,$000A(A5)
	CMP.W	#10,D4		; 10 highscore entries
	BLT.W	L00689
L0068F:
	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

L00690:	dc.b	"Hall.of.Fame.lz4",0
L00691:	dc.b	'%5d %s, "%s"',0
L00692:	dc.b	" by %s",0
L00693:	dc.b	" killed on level %d",0
L00694:	dc.b	" A total winner!",0
L00695:	dc.b	" Honored by the Guild",0
L00696:	dc.b	" quit on level %d",0

_add_scores:
	LINK	A5,#-$0002
	MOVEM.L	A2/A3,-(A7)

	MOVE.W	#$000B,-$0002(A5)
	MOVEA.L	$000C(A5),A2
	ADDA.L	#414,A2		;414 = 460 - 46
	BRA.B	L0069C
L00697:
	MOVEA.L	$0008(A5),A6
	MOVE.W	$0028(A6),D3	;gold score
	CMP.W	$0028(A2),D3
	BLS.B	L0069D

	MOVEA.L	A2,A3
	SUBQ.W	#1,-$0002(A5)
	MOVEA.L	$000C(A5),A6
	ADDA.L	#414,A6
	CMPA.L	A6,A3
	BCC.B	L00699

	TST.W	$0028(A2)
	BEQ.B	L00699

	MOVEA.L	A2,A6
	ADDA.L	#46,A6
	MOVEA.L	A2,A1
	MOVEQ	#$0A,D3

1$	MOVE.L	(A1)+,(A6)+	;move highscore one entry down
	DBF	D3,1$
	MOVE.W	(A1)+,(A6)+
L00699:
	SUBA.L	#46,A2
L0069C:
	CMPA.L	$000C(A5),A2
	BCC.B	L00697
L0069D:
	CMPI.W	#$000B,-$0002(A5)
	BNE.B	L0069F

	MOVEQ	#$00,D0
L0069E:
	move.b	d0,_MathBase(A4)	;_all_clear + 1
	subq.b	#1,_MathBase(A4)

	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

L0069F:
	MOVEA.L	$0008(A5),A1
	MOVEQ	#$0A,D3

1$	MOVE.L	(A1)+,(A3)+	;put the new highscore in place
	DBF	D3,1$
	MOVE.W	(A1)+,(A3)+

	MOVE.W	-$0002(A5),D0
	BRA.B	L0069E

;/*
; * death:
; *  Do something really fun when he dies
; */

_death:
	LINK	A5,#-$0058
	MOVEM.L	D4/A2,-(A7)
	MOVE.B	$0009(A5),D4

	MOVE.W	_purse(A4),D3	;_purse
	EXT.L	D3
	DIVS.W	#10,D3
	SUB.W	D3,_purse(A4)	;_purse

	PEA	-$0054(A5)
	JSR	_time
	ADDQ.W	#4,A7
	PEA	-$0054(A5)
	JSR	_localtime
	ADDQ.W	#4,A7
	MOVE.L	D0,-$0058(A5)
	JSR	_black_out
	JSR	_wtext
	MOVE.W	#$0001,-(A7)
	MOVE.L	_TextWin(A4),-(A7)	;_TextWin
	PEA	L006A5(PC)	;"Tombstone"
	JSR	_show_ilbm
	LEA	$000A(A7),A7
	LEA	_whoami(A4),A6	;_whoami
	MOVE.L	A6,D3
;	BRA.B	L006A2
L006A1:
;	LEA	L006A6(PC),A6	;Software Pirate
;	MOVE.L	A6,D3
L006A2:
	MOVE.L	D3,-(A7)
	MOVE.W	#$0062,-(A7)
	JSR	_tomb_center(PC)
	ADDQ.W	#6,A7
	MOVE.W	_purse(A4),-(A7)	;_purse
	PEA	L006A7(PC)		;"%u Au"
	PEA	-$0050(A5)
	JSR	_sprintf
	LEA	$000A(A7),A7
	PEA	-$0050(A5)
	MOVE.W	#$0072,-(A7)
	JSR	_tomb_center(PC)
	ADDQ.W	#6,A7
	MOVE.B	D4,D3
	EXT.W	D3
	MOVE.W	D3,-(A7)
	JSR	_killname(PC)
	ADDQ.W	#2,A7
	MOVE.L	D0,D3
	MOVE.L	D3,-(A7)
	PEA	L006A8(PC)	;"Killed by %s"
	PEA	-$0050(A5)
	JSR	_sprintf
	LEA	$000C(A7),A7
	PEA	-$0050(A5)
	MOVE.W	#$0082,-(A7)
	JSR	_tomb_center(PC)
	ADDQ.W	#6,A7
	MOVEA.L	-$0058(A5),A6
	MOVE.W	$000A(A6),D3
	ADD.W	#$076C,D3
	MOVE.W	D3,-(A7)
	PEA	L006AA(PC)	;"%d"
	PEA	-$0050(A5)
	JSR	_sprintf
	LEA	$000A(A7),A7
	PEA	-$0050(A5)
	MOVE.W	#$0092,-(A7)
	JSR	_tomb_center(PC)
	ADDQ.W	#6,A7
	JSR	_flush_type
	JSR	_readchar
	JSR	_clear

	moveq	#0,d1
	MOVEq	#$0014,d0
	JSR	_movequick

	MOVE.B	D4,D3
	EXT.W	D3
	MOVE.W	D3,-(A7)		;killed by
	CLR.W	-(A7)
	MOVE.W	_purse(A4),-(A7)	;_purse
	JSR	_score(PC)
	ADDQ.W	#6,A7
	PEA	L006AB(PC)
	JSR	_fatal
	ADDQ.W	#4,A7
	MOVEM.L	(A7)+,D4/A2
	UNLK	A5
	RTS

L006A5:	dc.b	"Tombstone.lz4",0
;L006A6:	dc.b	"Software Pirate",0
L006A7:	dc.b	"%u Au",0
L006A8:	dc.b	"Killed by %s",0
;L006A9:	dc.b	"a Protection Thug",0
L006AA:	dc.b	"%d",0
L006AB:	dc.b	0,0

;/*
; * center:
; *  Return the index to center the given string
; */

;_center:
;	LINK	A5,#-$0000
;	MOVE.L	$000A(A5),-(A7)
;	MOVE.L	$000A(A5),A0
;	JSR	_strlenquick
;
;	MOVEQ	#$50,D3
;	SUB.W	D0,D3
;	EXT.L	D3
;	DIVS.W	#$0002,D3
;	MOVE.W	D3,-(A7)
;	MOVE.W	$0008(A5),-(A7)
;	JSR	_mvaddstr(PC)
;	ADDQ.W	#8,A7
;	UNLK	A5
;	RTS

_tomb_center:
	LINK	A5,#-$0014
	CLR.W	-(A7)
	PEA	-$0014(A5)
	MOVE.L	$000A(A5),-(A7)
	JSR	_ctointui
	LEA	$000A(A7),A7

	CLR.B	-$0014(A5)
	MOVE.B	#$0E,-$0013(A5)

	MOVE.L	$000A(A5),-(A7)
	JSR	_scrlen
	ADDQ.W	#4,A7

	EXT.L	D0
	DIVS.W	#$0002,D0
	MOVE.W	#$0157,D1
	SUB.W	D0,D1
	move.w	d1,d0

	MOVE.W	$0008(A5),D1

	MOVEA.L	_TextWin(A4),A6	;_TextWin
	lea	-$0014(A5),a1
	MOVE.L	$0032(A6),a0

	MOVEA.L	_IntuitionBase(A4),A6	;_IntuitionBase
	JSR	_LVOPrintIText(A6)

;	MOVE.L	$0032(A6),-(A7)
;	JSR	_PrintIText
;	LEA	$0010(A7),A7

	UNLK	A5
	RTS

;/*
; * total_winner:
; *  Code for a winner
; */

_total_winner:
;	LINK	A5,#-$0000
	MOVEM.L	D4-D6/A2,-(A7)

	JSR	_clear

	PEA	L006DA(PC)	;"     Congratulations, you have made it to the light of day!"
	JSR	_addstr
	ADDQ.W	#4,A7

	PEA	L006DB(PC)	;"You have joined the elite ranks of those who have escaped the"
	CLR.W	-(A7)
	MOVE.W	#$0001,-(A7)
	JSR	_mvaddstr
	ADDQ.W	#8,A7

	PEA	L006DC(PC)	;"Dungeons of Doom alive.  You journey home and sell all your loot at"
	CLR.W	-(A7)
	MOVE.W	#$0002,-(A7)
	JSR	_mvaddstr
	ADDQ.W	#8,A7

	PEA	L006DD(PC)	;"a great profit and are admitted to the fighters guild."
	CLR.W	-(A7)
	MOVE.W	#$0003,-(A7)
	JSR	_mvaddstr
	ADDQ.W	#8,A7

	PEA	L006DE(PC)	;"--Press space to see your booty--"
	CLR.W	-(A7)
	MOVE.W	#$0014,-(A7)
	JSR	_mvaddstr
	ADDQ.W	#8,A7

	MOVE.W	#$0020,-(A7)	; SPACE
	JSR	_wait_for
	ADDQ.W	#2,A7

	JSR	_clear

	MOVE.W	#$0001,-(A7)
	JSR	_cursor(PC)
	ADDQ.W	#2,A7

	PEA	L006DF(PC)	;"   Worth  Item"
	CLR.W	-(A7)
	CLR.W	-(A7)
	JSR	_mvaddstr
	ADDQ.W	#8,A7

	MOVE.W	_purse(A4),D6	;_purse
	MOVEQ	#$61,D5
	MOVEA.L	_player+46(A4),A2	;_player + 46 (pack)
	BRA.W	L006D9
L006AC:
	MOVE.L	A2,-(A7)
	JSR	_typeof
	ADDQ.W	#4,A7
;	EXT.L	D0
	BRA.W	L006D6

; food

L006AD:
	MOVE.W	$001E(A2),D4	;every food is worth 2 gold
	ASL.W	#1,D4
	BRA.W	L006D7

; worth of weapon

L006AE:
	MOVE.W	$0020(A2),D0	;get the weapon subtype
;	EXT.L	D0
	move	#0,d4
	CMP.w	#$000A,D0
	BCC.B	L006BC

	ASL.w	#1,D0
	MOVE.W	L006B9(PC,D0.W),D4	;load the weapon gold value
L006BC:
	MOVE.W	$0022(A2),D3	;add hit
	ADD.W	$0024(A2),D3	;add damage
	MULU.W	#$0003,D3
	ADD.W	$001E(A2),D3	;add the number we have
	MULU.W	D3,D4
	ORI.W	#O_ISKNOW,$0028(A2)
	BRA.W	L006D7

; gold value of the weapons

L006B9:	dc.w	8	;mace
	dc.w	15	;broad sword
	dc.w	15	;short bow
	dc.w	1	;arrow
	dc.w	2	;dagger
	dc.w	75	;two handed sword
	dc.w	1	;dart
	dc.w	30	;crossbow
	dc.w	1	;crossbow bolt
	dc.w	5	;flail

; worth of armor

L006BD:
	MOVE.W	$0020(A2),D0	;get the armor sub type
;	EXT.L	D0
	move	#0,d4
	CMP.w	#$0008,D0
	BCC.B	L006C9

	ASL.w	#1,D0
	MOVE.W	L006C6(PC,D0.W),D4	;load the armor gold value
L006C9:
	MOVEQ	#$09,D3		;load armor class value from weapon
	SUB.W	$0026(A2),D3	;one point in armor class is worth 100 gold
	MULU.W	#100,D3		;so a plate mail with AC of 8 is worth 600 gold
	ADD.W	D3,D4
	MOVE.W	$0020(A2),D3	;which armor did we have?
;	EXT.L	D3
	ASL.w	#1,D3
	LEA	_a_class(A4),A6	;_a_class
	MOVE.W	$00(A6,D3.w),D2	;load the base AC value
	SUB.W	$0026(A2),D2
	MULU.W	#10,D2		; 10 extra gold for every AC point we made it better
	ADD.W	D2,D4
	ORI.W	#O_ISKNOW,$0028(A2)
	BRA.W	L006D7

; gold value of the armor

L006C6:	dc.w	20	;leather armor
	dc.w	25	;ring mail
	dc.w	20	;studded leather armor
	dc.w	30	;scale mail
	dc.w	75	;chain mail
	dc.w	80	;splint mail
	dc.w	90	;banded mail
	dc.w	150	;plate mail

; worth of scrolls

L006CA:
	MOVE.W	$0020(A2),D3
;	EXT.L	D3
	ASL.w	#3,D3
	LEA	_s_magic+6(A4),A6	;_s_magic + 6
	MOVE.W	$00(A6,D3.w),D4
	MULU.W	$001E(A2),D4	;multiply by the amount we have
	MOVE.W	$0020(A2),D3
	LEA	_s_know(A4),A6	;_s_know
	TST.B	$00(A6,D3.W)
	BNE.B	L006D7

	EXT.L	D4
	DIVS.W	#$0002,D4	;only worth half if we didnt knew it
	ST	$00(A6,D3.W)
	BRA.W	L006D7

; worth of potions

L006CC:
	MOVE.W	$0020(A2),D3
;	EXT.L	D3
	ASL.w	#3,D3
	LEA	_p_magic+6(A4),A6	;_p_magic + 6
	MOVE.W	$00(A6,D3.w),D4
	MULU.W	$001E(A2),D4	;multiply by the amount we have
	MOVE.W	$0020(A2),D3
	LEA	_p_know(A4),A6	;_p_know
	TST.B	$00(A6,D3.W)
	BNE.B	L006D7

	EXT.L	D4
	DIVS.W	#$0002,D4	;only worth half if we didnt knew it
	ST	$00(A6,D3.W)
	BRA.W	L006D7

; worth of rings

L006CE:
	MOVE.W	$0020(A2),D3
;	EXT.L	D3
	ASL.w	#3,D3
	LEA	_r_magic+6(A4),A6	;_r_magic + 6
	MOVE.W	$00(A6,D3.w),D4		;worth of the ring in gold
	CMPI.W	#R_ADDSTR,$0020(A2)
	BEQ.B	L006CF

	CMPI.W	#R_ADDDAM,$0020(A2)
	BEQ.B	L006CF

	CMPI.W	#R_PROTECT,$0020(A2)
	BEQ.B	L006CF

	CMPI.W	#R_ADDHIT,$0020(A2)
	BNE.B	L006D1
L006CF:
	CMPI.W	#$0000,$0026(A2)
	BLE.B	L006D0

	MOVE.W	$0026(A2),D3
	MULU.W	#100,D3		; + 100 for every bonus value
	ADD.W	D3,D4
	BRA.B	L006D1
L006D0:
	MOVEQ	#$0A,D4		; or only ten if the ring has negative values
L006D1:
	MOVE.W	$0028(A2),D3	;get the flags
	AND.W	#O_ISKNOW,D3
	BNE.B	L006D2

	EXT.L	D4
	DIVS.W	#$0002,D4	;only worth half if we didnt knew it
	ORI.W	#O_ISKNOW,$0028(A2)
L006D2:
	MOVE.W	$0020(A2),D3
	LEA	_r_know(A4),A6	;_r_know
	ST	$00(A6,D3.W)
	BRA.W	L006D7

; worth of wand/staff

L006D3:
	MOVE.W	$0020(A2),D3
;	EXT.L	D3
	ASL.w	#3,D3
	LEA	_ws_magic+6(A4),A6
	MOVE.W	$00(A6,D3.w),D4
	MOVE.W	$0026(A2),D3	;get number of charges
	MULU.W	#20,D3
	ADD.W	D3,D4
	MOVE.W	$0028(A2),D3	;get the flags
	AND.W	#O_ISKNOW,D3
	BNE.B	L006D4

	EXT.L	D4
	DIVS.W	#$0002,D4	;only worth half if we didnt knew it
	ORI.W	#O_ISKNOW,$0028(A2)
L006D4:
	MOVE.W	$0020(A2),D3
	LEA	_ws_know(A4),A6	;_ws_know
	ST	$00(A6,D3.W)
	BRA.B	L006D7
L006D5:
	MOVE.W	#1000,D4
	BRA.B	L006D7
L006D6:
	SUB.w	#$0021,D0	; ! potion
	BEQ.W	L006CC
	SUB.w	#$000B,D0	; , amulet of yendor
	BEQ.B	L006D5
	SUBQ.w	#3,D0		; / wand/staff
	BEQ.B	L006D3
	SUB.w	#$000B,D0	; : food
	BEQ.W	L006AD
	SUBQ.w	#3,D0		; = ring
	BEQ.W	L006CE
	SUBQ.w	#2,D0		; ? scroll
	BEQ.W	L006CA
	SUB.w	#$0022,D0	; a armor
	BEQ.W	L006BD
	SUB.w	#$000C,D0	; m weapon
	BEQ.W	L006AE
L006D7:
	CMP.W	#$0000,D4
	BGE.B	L006D8
	MOVEQ	#$00,D4
L006D8:
	moveq	#0,d1
	MOVE.B	D5,D0
	SUB.W	#$0060,D0
	JSR	_movequick

	MOVE.W	#$005E,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_nameof
	ADDQ.W	#6,A7

	MOVE.L	D0,-(A7)
	MOVE.W	D4,-(A7)
	MOVEQ	#$00,D3
	MOVE.B	D5,D3
	MOVE.W	D3,-(A7)

	PEA	L006E0(PC)	;"%c) %5d  %s"
	JSR	_printw
	LEA	$000C(A7),A7
	ADD.W	D4,_purse(A4)	;_purse
	ADDQ.B	#1,D5
	MOVEA.L	(A2),A2
L006D9:
	MOVE.L	A2,D3
	BNE.W	L006AC

	moveq	#0,d1
	MOVE.B	D5,D0
	SUB.W	#$0060,D0
	JSR	_movequick

	MOVE.W	D6,-(A7)
	PEA	L006E1(PC)	;"   %5u  Gold Pieces          "
	JSR	_printw
	ADDQ.W	#6,A7

	PEA	L006E2(PC)	;"--Press any key to see Hall of Fame--"
	CLR.W	-(A7)
	MOVE.W	#$0015,-(A7)
	JSR	_mvaddstr
	ADDQ.W	#8,A7

	JSR	_readchar

	MOVE.W	#$0002,-(A7)
	MOVE.W	_purse(A4),-(A7)	;_purse
	JSR	_score(PC)
	ADDQ.W	#4,A7

	JSR	_black_out
	JSR	_wtext

	CLR.L	-(A7)
	MOVE.L	_TextWin(A4),-(A7)	;_TextWin
	PEA	L006E3(PC)	;"Total.Winner"
	JSR	_show_ilbm
	LEA	$000C(A7),A7

	JSR	_readchar

	PEA	L006E4(PC)	;'Mr. Mctesq and the Grand Beeking say, "Congratulations"'
	JSR	_fatal
	ADDQ.W	#4,A7

	MOVEM.L	(A7)+,D4-D6/A2
;	UNLK	A5
	RTS

L006DA:	dc.b	"     Congratulations, you have made it to the light of day!",0
L006DB:	dc.b	"You have joined the elite ranks of those who have escaped the",0
L006DC:	dc.b	"Dungeons of Doom alive.  You journey home and sell all your loot at",0
L006DD:	dc.b	"a great profit and are admitted to the fighters guild.",0
L006DE:	dc.b	"--Press space to see your booty--",0
L006DF:	dc.b	"   Worth  Item",0
L006E0:	dc.b	"%c) %5d  %s",0
L006E1:	dc.b	"   %5u  Gold Pieces          ",0
L006E2:	dc.b	"--Press any key to see Hall of Fame--",0
L006E3:	dc.b	"Total.Winner.lz4",0
L006E4:	dc.b	'Mr. Mctesq and the Grand Beeking say, "Congratulations"',0,0

;/*
; * killname:
; *  Convert a code to a monster name
; */

_killname:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5/A2,-(A7)

	MOVE.B	$0009(A5),D4
	MOVEA.L	_prbuf(A4),A2	;_prbuf
	MOVEQ	#$01,D5
	MOVE.B	D4,D0
	EXT.W	D0
;	EXT.L	D0
	BRA.B	L006ED
L006E5:
	LEA	L006F1(PC),A2	;arrow
	BRA.B	L006EE
L006E6:
	LEA	L006F2(PC),A2	;bolt
	BRA.B	L006EE
L006E7:
	LEA	L006F3(PC),A2	;dart
	BRA.B	L006EE
L006E8:
	LEA	L006F4(PC),A2	;starvation
	MOVEQ	#$00,D5
	BRA.B	L006EE
L006E9:
	LEA	L006F5(PC),A2	;fall
	BRA.B	L006EE
L006EA:
	MOVE.B	D4,D3
	EXT.W	D3
	CMP.W	#$0041,D3	;'A'
	BLT.B	L006EB
	CMP.W	#$005A,D3	;'Z'
	BGT.B	L006EB
	SUB.W	#$0041,D3	;'A'
	MULU.W	#26,D3
	LEA	_monsters(A4),A6	;_monsters
	MOVEA.L	$00(A6,D3.L),A2
	BRA.B	L006EE
L006EB:
	LEA	L006F6(PC),A2	;God
	MOVEQ	#$00,D5
L006EC:
	BRA.B	L006EE
L006ED:
	SUB.w	#$0061,D0	;a arrow
	BEQ.B	L006E5
	SUBQ.w	#1,D0		;b bolt
	BEQ.B	L006E6
	SUBQ.w	#2,D0		;d dart
	BEQ.B	L006E7
	SUBQ.w	#2,D0		;f fall
	BEQ.B	L006E9
	SUB.w	#$000D,D0	;s starvation
	BEQ.B	L006E8
	BRA.B	L006EA		;check for the monsters
L006EE:
	TST.B	D5		;should we put a vowel in front?
	BEQ.B	L006EF

	MOVE.L	A2,-(A7)
	JSR	_vowelstr(PC)
	ADDQ.W	#4,A7
	MOVE.L	D0,-(A7)
	PEA	L006F7(PC)
	MOVE.L	_prbuf(A4),-(A7)	;_prbuf
	JSR	_sprintf
	LEA	$000C(A7),A7
	BRA.B	L006F0
L006EF:
	MOVEA.L	_prbuf(A4),A6	;_prbuf
	CLR.B	(A6)
L006F0:
	MOVE.L	A2,-(A7)
	MOVE.L	_prbuf(A4),-(A7)	;_prbuf
	JSR	_strcat
	ADDQ.W	#8,A7
	MOVE.L	_prbuf(A4),D0	;_prbuf

	MOVEM.L	(A7)+,D4/D5/A2
	UNLK	A5
	RTS
