;/*
; * ring_on:
; *  Put a ring on a hand
; */

_ring_on:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVEQ	#-$01,D4
	MOVE.L	A2,D3
	BNE.B	L005A6

	MOVE.W	#$003D,-(A7)
	PEA	L005B4(PC)	;"put on"
	JSR	_get_item
	ADDQ.W	#6,A7
	MOVEA.L	D0,A2
	TST.L	D0
	BEQ.W	L005B3
L005A6:
	CMPI.W	#$003D,$000A(A2)	;'=' ring type
	BEQ.B	L005A7

	PEA	L005B5(PC)	;"you can't put that on your finger"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L005B3
L005A7:
	MOVE.L	A2,-(A7)
	JSR	_check_wisdom	;do we really want wear that ring?
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L005A9
L005A8:
	MOVEM.L	(A7)+,D4/A2
	UNLK	A5
	RTS

L005A9:
	MOVE.L	A2,-(A7)
	JSR	_is_current(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.W	L005B3

	TST.L	-$5190(A4)	;_cur_ring_1
	BNE.B	L005AA

	MOVEQ	#$00,D4
L005AA:
	TST.L	-$518C(A4)	;_cur_ring_2
	BNE.B	L005AB

	MOVEQ	#$01,D4
L005AB:
	TST.L	-$5190(A4)	;_cur_ring_1
	BNE.B	L005AC

	TST.L	-$518C(A4)	;_cur_ring_2
	BNE.B	L005AC

	JSR	_gethand(PC)
	MOVE.W	D0,D4
;	CMP.W	#$0000,D0
	BLT.W	L005B3
L005AC:
	CMP.W	#$0000,D4
	BGE.B	L005AD

	PEA	L005B6(PC)	;"you already have a ring on each hand"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L005B3
L005AD:
	MOVE.W	D4,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$5190(A4),A6	;_cur_ring_x
	MOVE.L	A2,$00(A6,D3.w)

	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_pack_name
	ADDQ.W	#6,A7

	MOVE.W	$0020(A2),D0
;	EXT.L	D0
	BRA.B	L005B1
L005AE:
	MOVE.W	$0026(A2),-(A7)
	JSR	_chg_str
	ADDQ.W	#2,A7
	BRA.B	L005B2
L005AF:
	JSR	_invis_on(PC)
	BRA.B	L005B2
L005B0:
	JSR	_aggravate
	BRA.B	L005B2
L005B1:
	SUBQ.w	#1,D0	; ring of add strength
	BEQ.B	L005AE
	SUBQ.w	#3,D0	; ring of see invisible
	BEQ.B	L005AF
	SUBQ.w	#2,D0	; ring of aggravate monster
	BEQ.B	L005B0
L005B2:
	MOVE.L	A2,-(A7)
	JSR	_pack_char(PC)
	ADDQ.W	#4,A7

	MOVE.W	D0,-(A7)

	MOVE.W	#$001F,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_nameof
	ADDQ.W	#6,A7

	MOVE.L	D0,-(A7)
	PEA	L005B7(PC)	;"you are now wearing %s (%c)"
	JSR	_msg
	LEA	$000A(A7),A7
	BRA.W	L005A8
L005B3:
	CLR.B	-$66F9(A4)	;_after
	BRA.W	L005A8

L005B4:	dc.b	"put on",0
L005B5:	dc.b	"you can't put that on your finger",0
L005B6:	dc.b	"you already have a ring on each hand",0
L005B7:	dc.b	"you are now wearing %s (%c)",0

;/*
; * ring_off:
; *  take off a ring
; */

_ring_off:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)
	MOVEA.L	$0008(A5),A2

	TST.L	-$5190(A4)	;_cur_ring_1
	BNE.B	L005BA

	TST.L	-$518C(A4)	;_cur_ring_2
	BNE.B	L005B9

	PEA	L005BF(PC)	;"you aren't wearing any rings"
	JSR	_msg
	ADDQ.W	#4,A7
	CLR.B	-$66F9(A4)	;_after
L005B8:
	MOVE.L	(A7)+,A2
	UNLK	A5
	RTS

L005B9:
	TST.L	-$5190(A4)	;_cur_ring_1
	BNE.B	L005BA
	MOVEQ	#$01,D0
	BRA.B	L005BC
L005BA:
	TST.L	-$518C(A4)	;_cur_ring_2
	BNE.B	L005BB
	MOVEQ	#$00,D0
	BRA.B	L005BC
L005BB:
	MOVE.L	A2,D3
	BNE.B	L005BC
	JSR	_gethand
	CMP.W	#$0000,D0
	BLT.B	L005B8
L005BC:
	ASL.w	#2,D0
	LEA	-$5190(A4),A6	;_cur_ring_1
	MOVEA.L	$00(A6,D0.w),A2
	CLR.W	-$60B0(A4)	;_mpos
	MOVE.L	A2,D3
	BNE.B	L005BD

	PEA	L005C0(PC)	;"not wearing such a ring"
	JSR	_msg
	ADDQ.W	#4,A7

	CLR.B	-$66F9(A4)	;_after
	BRA.B	L005B8
L005BD:
	MOVE.L	A2,-(A7)
	JSR	_can_drop
	ADDQ.W	#4,A7

	TST.W	D0
	BEQ.B	L005B8

	MOVE.L	A2,-(A7)
	JSR	_pack_char	;return the next unused pack character
	ADDQ.W	#4,A7

	EXT.W	D0
	MOVE.W	D0,-(A7)
	MOVE.W	#$001E,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_nameof
	ADDQ.W	#6,A7

	MOVE.L	D0,-(A7)
	PEA	L005C1(PC)	;"was wearing %s(%c)"
	JSR	_msg
	LEA	$000A(A7),A7
	BRA.B	L005B8

L005BF:	dc.b	"you aren't wearing any rings",0
L005C0:	dc.b	"not wearing such a ring",0
L005C1:	dc.b	"was wearing %s(%c)",0

;/*
; * gethand:
; *  Which hand is the hero interested in?
; */

_gethand:
	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)
L005C2:
	PEA	L005C9(PC)	;"left hand or right hand? "
	JSR	_msg
	ADDQ.W	#4,A7
	JSR	_readchar
	MOVE.W	D0,D4
	CMP.W	#$001B,D0	;ESCAPE character
	BNE.B	L005C4
	CLR.B	-$66F9(A4)	;_after
	MOVEQ	#-$01,D0
L005C3:
	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

L005C4:
	CLR.W	-$60B0(A4)	;_mpos
	CMP.W	#$006C,D4	; l
	BEQ.B	L005C5
	CMP.W	#$004C,D4	; L
	BNE.B	L005C6
L005C5:
	MOVEQ	#$00,D0
	BRA.B	L005C3
L005C6:
	CMP.W	#$0072,D4	; r
	BEQ.B	L005C7
	CMP.W	#$0052,D4	; R
	BNE.B	L005C8
L005C7:
	MOVEQ	#$01,D0
	BRA.B	L005C3
L005C8:
	PEA	L005CA(PC)	;"please type L or R"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L005C2
;	BRA.B	L005C3

L005C9:	dc.b	"left hand or right hand? ",0
L005CA:	dc.b	"please type L or R",0,0

;/*
; * ring_eat:
; *  How much food does this ring use up?
; */

_ring_eat:
;	LINK	A5,#-$0000
	MOVE.W	$0004(A7),D3
	ASL.w	#2,D3
	LEA	-$5190(A4),A6	;_cur_ring_1
	MOVE.L	$00(A6,D3.w),D0
	BNE.B	L005CC
L005D9:
	MOVEQ	#$00,D0
L005CB:
;	UNLK	A5
	RTS

L005CD:
	MOVEQ	#$02,D0
	BRA.B	L005CB
L005CF:
	MOVEq	#$0005,D0
	JSR	_rnd
	TST.W	D0
	BNE.B	L005D9

	MOVEq	#$0001,D0
	BRA.B	L005CB
L005D2:
	MOVEq	#$0003,D0
	JSR	_rnd
	TST.W	D0
	BNE.B	L005D9
L005CE:
	MOVEQ	#$01,D0
	BRA.B	L005CB
L005D5:
	MOVEq	#$0002,D0
	JSR	_rnd
	NEG.W	D0
	BRA.B	L005CB
L005DA:
	dc.w	L005CE-L005DC	;  1   protection
	dc.w	L005CE-L005DC	;  1   add strength
	dc.w	L005CE-L005DC	;  1   sustain strength
	dc.w	L005CF-L005DC	;  1/5 searching
	dc.w	L005CF-L005DC	;  1/5 see invisible
	dc.w	L005D9-L005DC	;  0   adornment
	dc.w	L005D9-L005DC	;  0   aggravate monster
	dc.w	L005D2-L005DC	;  1/3 dexterity
	dc.w	L005D2-L005DC	;  1/3 increase damage
	dc.w	L005CD-L005DC	;  2   regeneration
	dc.w	L005D5-L005DC	; -1/2 slow digestion
	dc.w	L005D9-L005DC	;  0   teleportation
	dc.w	L005CE-L005DC	;  1   stealth
	dc.w	L005CE-L005DC	;  1   maintain armor
L005CC:
	MOVE.L	D0,A1
	MOVE.W	$0020(A1),D0

	CMP.W	#$000E,D0
	BCC.B	L005D9
	ASL.W	#1,D0
	MOVE.W	L005DA(PC,D0.W),D0
L005DC:	JMP	L005DC(PC,D0.W)

;/*
; * ring_num:
; *  Print ring bonuses
; */

_ring_num:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVE.W	$0028(A2),D3
	AND.W	#O_ISKNOW,D3	;O_ISKNOW
	BNE.B	L005DE

	LEA	L005E5(PC),A6	;"",0
	MOVE.L	A6,D0
L005DD:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L005DE:
	MOVE.W	$0020(A2),D0
;	EXT.L	D0
	BRA.B	L005E2
L005DF:
	MOVE.W	#$003D,-(A7)	;'=' ring
	CLR.W	-(A7)
	MOVE.W	$0026(A2),-(A7)
	JSR	_num(PC)
	ADDQ.W	#6,A7

	MOVE.L	D0,-(A7)
	MOVE.L	-$51A0(A4),-(A7)
	JSR	_strcpy
	ADDQ.W	#8,A7
	PEA	L005E6(PC)	;' '
	MOVE.L	-$51A0(A4),-(A7)
	JSR	_strcat
	ADDQ.W	#8,A7
	BRA.B	L005E4
L005E0:
	LEA	L005E7(PC),A6	;"",0
	MOVE.L	A6,D0
	BRA.B	L005DD
L005E1:
	dc.w	L005DF-L005E3	; "protection"
	dc.w	L005DF-L005E3	; "add strength"
	dc.w	L005E0-L005E3	; "sustain strength"
	dc.w	L005E0-L005E3	; "searching"
	dc.w	L005E0-L005E3	; "see invisible"
	dc.w	L005E0-L005E3	; "adornment"
	dc.w	L005E0-L005E3	; "aggravate monster"
	dc.w	L005DF-L005E3	; "dexterity"
	dc.w	L005DF-L005E3	; "increase damage"
L005E2:
	CMP.w	#$0009,D0
	BCC.B	L005E0
	ASL.w	#1,D0
	MOVE.W	L005E1(PC,D0.W),D0
L005E3:	JMP	L005E3(PC,D0.W)
L005E4:
	MOVE.L	-$51A0(A4),D0
	BRA.B	L005DD

L005E5:	dc.b	$00
L005E6:	dc.b	" ",0
L005E7:	dc.b	$00

