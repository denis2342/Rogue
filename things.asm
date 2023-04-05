
;/*
; * inv_name:
; *  Return the name of something as it would appear in an
; *  inventory.
; */

_nameof:
	LINK	A5,#-$0050
	MOVEM.L	D4-D6/A2,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVE.W	$000C(A5),D4
	MOVE.W	$0020(A2),D5
	MOVEQ	#$00,D6
	MOVE.L	_prbuf-BASE(A4),-$5336(A4)	;_prbuf

	MOVE.L	A2,-(A7)
	JSR	_typeof
	ADDQ.W	#4,A7

;	EXT.L	D0
	BRA.W	L00AEA

; scroll

L00ABB:
	PEA	L00AF2(PC)	;"scroll"
	MOVE.W	D4,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_do_count(PC)
	LEA	$000A(A7),A7
	MOVE.W	D4,D3
	AND.W	#$0004,D3	;only the simple name?
	BEQ.B	L00ABE

	LEA	-$66F6(A4),A6	;_s_know
	TST.B	$00(A6,D5.W)
	BEQ.B	L00ABC

	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#3,D3
	LEA	-$6EF0(A4),A6	;_s_magic
	MOVE.L	$00(A6,D3.w),-(A7)
	PEA	L00AF3(PC)	;"of %s"
	JSR	_nmadd
	ADDQ.W	#8,A7
	BRA.B	L00ABE
L00ABC:
	MOVE.W	D5,D3
	MULU.W	#21,D3
	LEA	_s_guess-BASE(A4),A6	;_s_guess
	TST.B	$00(A6,D3.L)
	BEQ.B	L00ABD

	MOVE.W	D5,D3
	MULU.W	#21,D3
;	LEA	_s_guess-BASE(A4),A6	;_s_guess
	ADD.L	A6,D3
	MOVE.L	D3,-(A7)
	PEA	L00AF4(PC)	;"called %s"
	JSR	_nmadd
	ADDQ.W	#8,A7
	BRA.B	L00ABE
L00ABD:
	MOVEQ	#$01,D6
L00ABE:
	TST.W	D6
	BNE.B	L00ABF

	MOVE.W	D4,D3
	AND.W	#$0002,D3	;with whats made of?
	BEQ.B	L00AC0
L00ABF:
	MOVE.W	D5,D3
	MULU.W	#21,D3
	LEA	-$66A6(A4),A6	;_s_names
	ADD.L	A6,D3
	MOVE.L	D3,-(A7)
	PEA	L00AF5(PC)	;"titled '%s'"
	JSR	_nmadd
	ADDQ.W	#8,A7
L00AC0:
	BRA.W	L00AEB

; potions

L00AC1:
	MOVEQ	#$00,D6
	PEA	L00AF6(PC)	;"potion"
	MOVE.W	D4,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_do_count(PC)
	LEA	$000A(A7),A7
	MOVE.W	D4,D3
	AND.W	#$0004,D3	;only the simple name?
	BEQ.B	L00AC4

	LEA	-$66E7(A4),A6	;_p_know
	TST.B	$00(A6,D5.W)
	BEQ.B	L00AC2

	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$5290(A4),A6	;_p_colors
	MOVE.L	$00(A6,D3.w),-(A7)
	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#3,D3
	LEA	-$6E78(A4),A6	;_p_magic
	MOVE.L	$00(A6,D3.w),-(A7)
	PEA	L00AF7(PC)	;"of %s(%s)"
	JSR	_nmadd
	LEA	$000C(A7),A7
	BRA.B	L00AC4
L00AC2:
	MOVE.W	D5,D3
	MULU.W	#21,D3
	LEA	_p_guess-BASE(A4),A6	;_p_guess
	TST.B	$00(A6,D3.L)
	BEQ.B	L00AC3

	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$5290(A4),A6	;_p_colors
	MOVE.L	$00(A6,D3.w),-(A7)
	MOVE.W	D5,D3
	MULU.W	#21,D3
	LEA	_p_guess-BASE(A4),A6	;_p_guess
	ADD.L	A6,D3
	MOVE.L	D3,-(A7)
	PEA	L00AF8(PC)	;"called %s(%s)"
	JSR	_nmadd
	LEA	$000C(A7),A7
	BRA.B	L00AC4
L00AC3:
	MOVEQ	#$01,D6
L00AC4:
	TST.W	D6
	BEQ.B	L00AC5

	MOVE.L	_prbuf-BASE(A4),-$5336(A4)	;_prbuf
	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$5290(A4),A6	;_p_colors
	MOVE.L	$00(A6,D3.w),-(A7)
	PEA	L00AF9(PC)	;"%s potion"
	PEA	-$0050(A5)
	JSR	_sprintf
	LEA	$000C(A7),A7
	PEA	-$0050(A5)
	MOVE.W	D4,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_do_count(PC)
	LEA	$000A(A7),A7
L00AC5:
	BRA.W	L00AEB

; food

L00AC6:
	CMP.W	#$0001,D5
	BNE.B	L00AC7

	MOVE.W	D4,D3
	AND.W	#$0002,D3	;with whats made of?
	BEQ.B	L00AC7

	PEA	-$6713(A4)
	MOVE.W	D4,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_do_count(PC)
	LEA	$000A(A7),A7
	BRA.B	L00ACB
L00AC7:
	MOVE.W	D4,D3
	AND.W	#$0010,D3	;should we change text for plurals?
	BEQ.B	L00ACA

	CMPI.W	#$0001,$001E(A2)	;one or more food?
	BNE.B	L00AC8

	PEA	L00AFA(PC)	;"Some food"
	JSR	_nmadd
	ADDQ.W	#4,A7
	BRA.B	L00AC9
L00AC8:
	MOVE.W	$001E(A2),-(A7)
	PEA	L00AFB(PC)	;"%d rations of food"
	JSR	_nmadd
	ADDQ.W	#6,A7
L00AC9:
	BRA.B	L00ACB
L00ACA:
	PEA	L00AFC(PC)	;"food"
	JSR	_nmadd
	ADDQ.W	#4,A7
L00ACB:
	BRA.W	L00AEB

; weapon type

L00ACC:
	MOVE.W	D4,D3
	AND.W	#$0010,D3	;should we change text for plurals?
	BEQ.B	L00ACE

	CMPI.W	#$0001,$001E(A2)	;how many do we have?
	BLE.B	L00ACD

	MOVE.W	$001E(A2),-(A7)
	PEA	L00AFD(PC)	;"%d"
	JSR	_nmadd
	ADDQ.W	#6,A7
	BRA.B	L00ACE
L00ACD:
	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$6F5C(A4),A6	;_w_names
	MOVE.L	$00(A6,D3.w),-(A7)
	JSR	_vowelstr(PC)
	ADDQ.W	#4,A7
	MOVE.L	D0,-(A7)
	PEA	L00AFE(PC)	;"A%s"
	JSR	_nmadd
	ADDQ.W	#8,A7
L00ACE:
	MOVE.W	D4,D3
	AND.W	#$0008,D3	;with stats or only name?
	BEQ.B	L00ACF

	MOVE.W	$0028(A2),D3
	AND.W	#O_ISKNOW,D3
	BEQ.B	L00ACF

	MOVE.W	#$006D,-(A7)	;m weapon type
	MOVE.W	$0024(A2),-(A7)
	MOVE.W	$0022(A2),-(A7)
	JSR	_num(PC)
	ADDQ.W	#6,A7
	MOVE.L	D0,-(A7)
	JSR	_nmadd
	ADDQ.W	#4,A7
L00ACF:
	CMPI.W	#$0001,$001E(A2)	;how many do we have?
	BLE.B	L00AD0

	MOVE.W	D4,D3
	AND.W	#$0010,D3	;should we append 's' for plurals?
	BEQ.B	L00AD0

	LEA	L00B00(PC),A6	;"s"
	MOVE.L	A6,D3
	BRA.B	L00AD1
L00AD0:
	LEA	L00B01(PC),A6	;"",0
	MOVE.L	A6,D3
L00AD1:
	MOVE.L	D3,-(A7)
	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$6F5C(A4),A6	;_w_names
	MOVE.L	$00(A6,D3.w),-(A7)
	PEA	L00AFF(PC)	;"%s%s"
	JSR	_nmadd
	LEA	$000C(A7),A7
	MOVE.W	D4,D3
	AND.W	#$0040,D3	;print with full stats
	BEQ.B	L00AD2

	TST.B	$002A(A2)	; test for special feature (monster slayer weapon)
	BEQ.B	L00AD2

	MOVE.W	$0028(A2),D3	;monster slayer known?
	AND.W	#O_SPECKNOWN,D3
	BEQ.B	L00AD2

	MOVE.B	$002A(A2),D3
	EXT.W	D3
	SUB.W	#$0041,D3	;'A'
	MULU.W	#26,D3
	LEA	_monsters-BASE(A4),A6	;_monsters
	MOVE.L	$00(A6,D3.L),-(A7)
	PEA	L00B02(PC)	;"of %s slaying"
	JSR	_nmadd
	ADDQ.W	#8,A7
L00AD2:
	BRA.W	L00AEB

; armor type

L00AD3:
	MOVE.W	D4,D3
	AND.W	#$0008,D3	;with stats or only name?
	BEQ.B	L00AD5

	MOVE.W	$0028(A2),D3
	AND.W	#O_ISKNOW,D3
	BEQ.B	L00AD5

	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$6F30(A4),A6		;_a_names
	MOVE.L	$00(A6,D3.w),-(A7)
	MOVE.W	#$0061,-(A7)	;a armor type
	CLR.W	-(A7)
	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#1,D3
	LEA	-$6F00(A4),A6	;_a_class
	MOVE.W	$00(A6,D3.w),D2
	SUB.W	$0026(A2),D2
	MOVE.W	D2,-(A7)
	JSR	_num(PC)
	ADDQ.W	#6,A7
	MOVE.L	D0,-(A7)
	PEA	L00B03(PC)	;"%s %s"
	JSR	_nmadd
	LEA	$000C(A7),A7
	MOVE.W	D4,D3
	AND.W	#$0040,D3	;print with full stats
	BEQ.B	L00AD4

	MOVE.W	$0026(A2),D3
	SUB.W	#11,D3
	NEG.W	D3
	MOVE.W	D3,-(A7)
	PEA	L00B04(PC)	;"[armor class %d]"
	JSR	_nmadd
	ADDQ.W	#6,A7
L00AD4:
	BRA.B	L00AD6
L00AD5:
	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$6F30(A4),A6		;_a_names
	MOVE.L	$00(A6,D3.w),-(A7)
	JSR	_nmadd
	ADDQ.W	#4,A7
L00AD6:
	BRA.W	L00AEB

; amulet of yendor

L00AD7:
	PEA	L00B05(PC)	;"The Amulet of Yendor"
	JSR	_nmadd
	ADDQ.W	#4,A7
	BRA.W	L00AEB

; wand/staff

L00AD8:
	MOVE.W	D4,D3
	AND.W	#$0004,D3	;only the simple name?
	BEQ.W	L00ADC

	LEA	-$66CB(A4),A6	;_ws_know
	TST.B	$00(A6,D5.W)
	BEQ.B	L00AD9

	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$51E4(A4),A6	;_ws_made
	MOVE.L	$00(A6,D3.w),-(A7)
	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#3,D3
	LEA	-$6D98(A4),A6	;_ws_magic
	MOVE.L	$00(A6,D3.w),-(A7)
	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$521C(A4),A6	;_ws_type
	MOVE.L	$00(A6,D3.w),-(A7)
	PEA	L00B06(PC)	;"%s of %s(%s)"
	PEA	-$0050(A5)
	JSR	_sprintf
	LEA	$0014(A7),A7
	BRA.B	L00ADD
L00AD9:
	MOVE.W	D5,D3
	MULU.W	#21,D3
	LEA	_ws_guess-BASE(A4),A6	;_ws_guess
	TST.B	$00(A6,D3.L)
	BEQ.B	L00ADC

	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$51E4(A4),A6	;_ws_made
	MOVE.L	$00(A6,D3.w),-(A7)
	MOVE.W	D5,D3
	MULU.W	#21,D3
	LEA	_ws_guess-BASE(A4),A6	;_ws_guess
	ADD.L	A6,D3
	MOVE.L	D3,-(A7)
	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$521C(A4),A6	;_ws_type
	MOVE.L	$00(A6,D3.w),-(A7)
	PEA	L00B07(PC)	;"%s called %s(%s)"
	PEA	-$0050(A5)
	JSR	_sprintf
	LEA	$0014(A7),A7
	BRA.B	L00ADD
L00ADC:
	MOVEQ	#$01,D6
L00ADD:
	TST.W	D6
	BEQ.B	L00ADF

	MOVE.W	D4,D3
	AND.W	#$0002,D3	;with whats made of?
	BEQ.B	L00ADE

	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$521C(A4),A6	;_ws_type
	MOVE.L	$00(A6,D3.w),-(A7)
	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$51E4(A4),A6	;_ws_made
	MOVE.L	$00(A6,D3.w),-(A7)
	PEA	L00B08(PC)	;"%s %s"
	PEA	-$0050(A5)
	JSR	_sprintf
	LEA	$0010(A7),A7
	BRA.B	L00ADF
L00ADE:
	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$521C(A4),A6	;_ws_type
	MOVE.L	$00(A6,D3.w),-(A7)
	PEA	-$0050(A5)
	JSR	_strcpy
	ADDQ.W	#8,A7
L00ADF:
	PEA	-$0050(A5)
	MOVE.W	D4,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_do_count(PC)
	LEA	$000A(A7),A7
	MOVE.W	D4,D3
	AND.W	#$0040,D3	;print with full stats
	BEQ.B	L00AE0

	MOVE.L	A2,-(A7)
	JSR	_charge_str
	ADDQ.W	#4,A7
	MOVE.L	D0,-(A7)
	JSR	_nmadd
	ADDQ.W	#4,A7
L00AE0:
	BRA.W	L00AEB

; ring

L00AE1:
	MOVE.W	D4,D3
	AND.W	#$0004,D3	;only the simple name?
	BEQ.W	L00AE7

	LEA	-$66D9(A4),A6	;_r_know
	TST.B	$00(A6,D5.W)
	BEQ.B	L00AE4

	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$5254(A4),A6	;_r_stones
	MOVE.L	$00(A6,D3.w),-(A7)
	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#3,D3
	LEA	-$6E08(A4),A6
	MOVE.L	$00(A6,D3.w),-(A7)
	MOVE.W	D4,D3
	AND.W	#$0008,D3
	BEQ.B	L00AE2

	MOVE.L	A2,-(A7)
	JSR	_ring_num(PC)
	ADDQ.W	#4,A7
	MOVE.L	D0,D3
	BRA.B	L00AE3
L00AE2:
	LEA	L00B01(PC),A6	;"",0
	MOVE.L	A6,D3
L00AE3:
	MOVE.L	D3,-(A7)
	PEA	L00B09(PC)
	PEA	-$0050(A5)
	JSR	_sprintf
	LEA	$0014(A7),A7
	BRA.B	L00AE8
L00AE4:
	MOVE.W	D5,D3
	MULU.W	#21,D3
	LEA	_r_guess-BASE(A4),A6	;_r_guess
	TST.B	$00(A6,D3.L)
	BEQ.B	L00AE7

	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$5254(A4),A6	;_r_stones
	MOVE.L	$00(A6,D3.w),-(A7)
	MOVE.W	D5,D3
	MULU.W	#21,D3
	LEA	_r_guess-BASE(A4),A6	;_r_guess
	ADD.L	A6,D3
	MOVE.L	D3,-(A7)
	PEA	L00B0B(PC)	;"ring called %s(%s)"
	PEA	-$0050(A5)
	JSR	_sprintf
	LEA	$0010(A7),A7
	BRA.B	L00AE8
L00AE7:
	MOVEQ	#$01,D6
L00AE8:
	TST.W	D6
	BEQ.B	L00AE9
	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$5254(A4),A6	;_r_stones
	MOVE.L	$00(A6,D3.w),-(A7)
	PEA	L00B0C(PC)	;"%s ring"
	PEA	-$0050(A5)
	JSR	_sprintf
	LEA	$000C(A7),A7
L00AE9:
	PEA	-$0050(A5)
	MOVE.W	D4,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_do_count(PC)
	LEA	$000A(A7),A7
	BRA.B	L00AEB
L00AEA:
	SUB.w	#$0021,D0	;'!' potions
	BEQ.W	L00AC1
	SUB.w	#$000B,D0	;',' amulet of yendor
	BEQ.W	L00AD7
	SUBQ.w	#3,D0		;'/' wand/staff
	BEQ.W	L00AD8
	SUB.w	#$000B,D0	;':' food
	BEQ.W	L00AC6
	SUBQ.w	#3,D0		;'=' ring
	BEQ.W	L00AE1
	SUBQ.w	#2,D0		;'?' scroll
	BEQ.W	L00ABB
	SUB.w	#$0022,D0	;'a' armor type
	BEQ.W	L00AD3
	SUB.w	#$000C,D0	;'m' weapon type
	BEQ.W	L00ACC
L00AEB:
	MOVE.W	D4,D3
	AND.W	#$0001,D3	;should we print the wearing/worn text?
	BEQ.B	L00AEF

	CMPA.L	_cur_armor-BASE(A4),A2	;_cur_armor
	BNE.B	L00AEC

	PEA	L00B0D(PC)	;"(being worn)"
	JSR	_nmadd
	ADDQ.W	#4,A7
L00AEC:
	CMPA.L	_cur_weapon-BASE(A4),A2	;_cur_weapon
	BNE.B	L00AED

	PEA	L00B0E(PC)	;"(weapon in hand)"
	JSR	_nmadd
	ADDQ.W	#4,A7
L00AED:
	CMPA.L	_cur_ring_1-BASE(A4),A2	;_cur_ring_1
	BNE.B	L00AEE

	PEA	L00B0F(PC)	;"(on left hand)"
	JSR	_nmadd
	ADDQ.W	#4,A7
	BRA.B	L00AEF
L00AEE:
	CMPA.L	_cur_ring_2-BASE(A4),A2	;_cur_ring_2
	BNE.B	L00AEF

	PEA	L00B10(PC)	;"(on right hand)"
	JSR	_nmadd
	ADDQ.W	#4,A7
L00AEF:
	MOVE.W	D4,D3
	AND.W	#$0020,D3	;should we capitalize the word
	BNE.B	L00AF0

	MOVEA.L	_prbuf-BASE(A4),A6	;_prbuf
	MOVE.B	(A6),D0
	JSR	_isupper

	TST.W	D0
	BEQ.B	L00AF0

	MOVEA.L	_prbuf-BASE(A4),A6	;_prbuf
	MOVE.L	A6,-(A7)
	MOVEA.L	_prbuf-BASE(A4),A6	;_prbuf
	MOVE.B	(A6),D3
	MOVE.W	D3,-(A7)
	JSR	_tolower
	ADDQ.W	#2,A7
	MOVEA.L	(A7)+,A6
	MOVE.B	D0,(A6)
	BRA.B	L00AF1
L00AF0:
	MOVE.W	D4,D3
	AND.W	#$0020,D3	;should we capitalize the word
	BEQ.B	L00AF1

	MOVEA.L	_prbuf-BASE(A4),A6	;_prbuf
	MOVE.B	(A6),D0
	JSR	_islower

	TST.W	D0
	BEQ.B	L00AF1

	MOVEA.L	_prbuf-BASE(A4),A6	;_prbuf
	MOVE.L	A6,-(A7)
	MOVEA.L	_prbuf-BASE(A4),A6	;_prbuf
	MOVE.B	(A6),D3
	MOVE.W	D3,-(A7)
	JSR	_toupper
	ADDQ.W	#2,A7

	MOVEA.L	(A7)+,A6
	MOVE.B	D0,(A6)
L00AF1:
	MOVE.L	_prbuf-BASE(A4),D0	;_prbuf
	MOVEM.L	(A7)+,D4-D6/A2
	UNLK	A5
	RTS

L00AF2:	dc.b	"scroll",0
L00AF3:	dc.b	"of %s",0
L00AF4:	dc.b	"called %s",0
L00AF5:	dc.b	"titled '%s'",0
L00AF6:	dc.b	"potion",0
L00AF7:	dc.b	"of %s(%s)",0
L00AF8:	dc.b	"called %s(%s)",0
L00AF9:	dc.b	"%s potion",0
L00AFA:	dc.b	"Some food",0
L00AFB:	dc.b	"%d rations of food",0
L00AFC:	dc.b	"food",0
L00AFD:	dc.b	"%d",0
L00AFE:	dc.b	"A%s",0
L00AFF:	dc.b	"%s%s",0
L00B00:	dc.b	"s",0
L00B01:	dc.b	$00
L00B02:	dc.b	"of %s slaying",0
L00B03:	dc.b	"%s %s",0
L00B04:	dc.b	"[armor class %d]",0
L00B05:	dc.b	"The Amulet of Yendor",0
L00B06:	dc.b	"%s of %s(%s)",0
L00B07:	dc.b	"%s called %s(%s)",0
L00B08:	dc.b	"%s %s",0
L00B09:	dc.b	"%sring of %s(%s)",0
L00B0B:	dc.b	"ring called %s(%s)",0
L00B0C:	dc.b	"%s ring",0
L00B0D:	dc.b	"(being worn)",0
L00B0E:	dc.b	"(weapon in hand)",0
L00B0F:	dc.b	"(on left hand)",0
L00B10:	dc.b	"(on right hand)",0

;/*
; * drop:
; *  Put something down
; */

_drop:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2/A3,-(A7)

	JSR	_INDEXplayer

	MOVEA.L	__level-BASE(A4),A6	;__level
	MOVE.B	$00(A6,D0.W),D4
	CMP.b	#$2E,D4		;'.'
	BEQ.B	L0052D

	CMP.b	#$23,D4		;'#'
	BEQ.B	L0052D

	PEA	L00535(PC)	;"there is something there already"
	JSR	_msg
	ADDQ.W	#4,A7
L0052C:
	MOVEM.L	(A7)+,D4/A2/A3
	UNLK	A5
	RTS

L0052D:
	CLR.W	-(A7)
	PEA	L00536(PC)	;"drop"
	JSR	_get_item
	ADDQ.W	#6,A7
	MOVEA.L	D0,A3
	TST.L	D0
	BEQ.B	L0052C

	MOVE.L	A3,-(A7)
	JSR	_can_drop(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L0052C

	CMPI.W	#$0002,$001E(A3)
	BLT.B	L00530

	TST.W	$002C(A3)
	BNE.B	L00531
L00530:
	MOVEq	#$0001,D3
	BRA.B	L00532
L00531:
	CLR.W	D3
L00532:
	MOVE.W	D3,-(A7)
	MOVE.L	A3,-(A7)
	JSR	_unpack
	ADDQ.W	#6,A7

	MOVEA.L	D0,A3
	TST.L	D0
	BNE.B	L00533

	JSR	_stuck(PC)
	BRA.B	L0052C
L00533:
	MOVE.L	A3,-(A7)
	PEA	-$6CB0(A4)	;_lvl_obj
	JSR	__attach
	ADDQ.W	#8,A7

	JSR	_INDEXplayer

	MOVEA.L	__level-BASE(A4),A6	;__level
	MOVE.B	$000B(A3),$00(A6,D0.W)
	MOVEA.L	A3,A6
	ADDA.L	#$0000000C,A6
	LEA	-$52C0(A4),A1	;_player + 10
	MOVE.L	(A1)+,(A6)+

	CMPI.W	#$002C,$000A(A3)	;',' amulet of yendor
	BNE.B	L00534

	CLR.B	-$66BD(A4)	;_amulet
L00534:
	MOVE.W	#$001E,-(A7)
	MOVE.L	A3,-(A7)
	JSR	_nameof
	ADDQ.W	#6,A7

	MOVE.L	D0,-(A7)
	PEA	L00537(PC)	;"dropped %s"
	JSR	_msg
	ADDQ.W	#8,A7
	BRA.W	L0052C

L00535:	dc.b	"there is something there already",0
L00536:	dc.b	"drop",0
L00537:	dc.b	"dropped %s",0,0

;/*
; * dropcheck:
; *  Do special checks for dropping or unweilding|unwearing|unringing
; */

_can_drop:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2,-(A7)
	MOVEA.L	$0008(A5),A2
	MOVE.L	A2,D3
	BNE.B	L00539
L00538b:
	MOVEQ	#$01,D0
L00538:
	MOVEM.L	(A7)+,D4/A2
	UNLK	A5
	RTS

L00539:
	CMPA.L	_cur_armor-BASE(A4),A2	;_cur_armor
	BEQ.B	L0053A
	CMPA.L	_cur_weapon-BASE(A4),A2	;_cur_weapon
	BEQ.B	L0053A
	CMPA.L	_cur_ring_1-BASE(A4),A2	;_cur_ring_1
	BEQ.B	L0053A
	CMPA.L	_cur_ring_2-BASE(A4),A2	;_cur_ring_2
	BNE.B	L00538b
L0053A:
	MOVE.W	$0028(A2),D3
	AND.W	#O_ISCURSED,D3	; check for O_ISCURSED bit
	BEQ.B	L0053B

	PEA	L00543(PC)	;"you can't.  It appears to be cursed"
	JSR	_msg
	ADDQ.W	#4,A7
	MOVEQ	#$00,D0
	BRA.B	L00538
L0053B:
	CMPA.L	_cur_weapon-BASE(A4),A2	;_cur_weapon
	BNE.B	L0053C
	CLR.L	_cur_weapon-BASE(A4)	;_cur_weapon
	BRA.B	L00542
L0053C:
	CMPA.L	_cur_armor-BASE(A4),A2	;_cur_armor
	BNE.B	L0053D
	JSR	_waste_time
	CLR.L	_cur_armor-BASE(A4)	;_cur_armor
	BRA.B	L00542
L0053D:
	MOVEQ	#$00,D3
	LEA	_cur_ring_1-BASE(A4),A6	;_cur_ring_x
	CMPA.L	$00(A6,D3.w),A2	;ring slot 0
	BEQ.B	L0053E
	MOVEQ	#$04,D3
	CMPA.L	$00(A6,D3.w),A2	;ring slot 1
	BNE.B	L00538b
L0053E:
;	LEA	_cur_ring_1-BASE(A4),A6	;_cur_ring_x
	CLR.L	$00(A6,D3.w)
	MOVE.W	$0020(A2),D0	;ring id
;	EXT.L	D0

	SUBQ.w	#1,D0	; ring of add strength
	BEQ.B	L0053F
	SUBQ.w	#3,D0	; ring of see invisible
	BEQ.B	L00540
L00542:
	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_pack_name
	ADDQ.W	#6,A7
	BRA.W	L00538b

; ring of add strength

L0053F:
	MOVE.W	$0026(A2),D3
	NEG.W	D3
	MOVE.W	D3,-(A7)
	JSR	_chg_str
	ADDQ.W	#2,A7
	BRA.B	L00542

; ring of see invisible

L00540:
	JSR	_unsee(PC)
	PEA	_unsee(PC)
	JSR	_extinguish(PC)
	ADDQ.W	#4,A7
	BRA.B	L00542

L00543:	dc.b	"you can't.  It appears to be cursed",0

;/*
; * new_thing:
; *  Return a new thing
; */

_new_thing:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5/A2,-(A7)
	JSR	_new_item
	MOVEA.L	D0,A2
	TST.L	D0
	BNE.B	L00545

	MOVEQ	#$00,D0
L00544:
	MOVEM.L	(A7)+,D4/D5/A2
	UNLK	A5
	RTS

L00545:
	CLR.W	$0024(A2)		;zero damage
	CLR.W	$0022(A2)		;zero hit
	MOVE.L	_no_damage-BASE(A4),$001A(A2)	;_no_damage throw damage
	MOVE.L	$001A(A2),$0016(A2)	;wield damage
	MOVE.W	#$000B,$0026(A2)	;armor class base value
	MOVE.W	#$0001,$001E(A2)	;one item
	CLR.W	$002C(A2)		;no group
	CLR.W	$0028(A2)		;flags like cursed and so on
	CLR.B	$002A(A2)		;not a monster slayer
	CMPI.W	#$0003,-$60A6(A4)	;_no_food
	BLE.B	L00546

	MOVEQ	#$02,D0
	BRA.B	L00547
L00546:
	MOVE.W	#$0007,-(A7)
	PEA	-$6A04(A4)
	JSR	_pick_one(PC)
	ADDQ.W	#6,A7
L00547:
;	EXT.L	D0
	BRA.W	L00560

; potions

L00548:
	MOVE.W	#$0021,$000A(A2)	;'!'
	MOVE.W	#14,-(A7)
	PEA	-$6E78(A4)	;_p_magic
	JSR	_pick_one(PC)
	ADDQ.W	#6,A7
	MOVE.W	D0,$0020(A2)
	BRA.W	L00562

; scrolls

L00549:
	MOVE.W	#$003F,$000A(A2)	;'?'
	MOVE.W	#15,-(A7)
	PEA	-$6EF0(A4)
	JSR	_pick_one(PC)
	ADDQ.W	#6,A7
	MOVE.W	D0,$0020(A2)
	BRA.W	L00562

; food

L0054A:
	CLR.W	-$60A6(A4)	;_no_food
	MOVE.W	#$003A,$000A(A2)	;':'
	MOVEq	#10,D0
	JSR	_rnd
	TST.W	D0
	BEQ.B	L0054B

	CLR.W	$0020(A2)
	BRA.B	L0054C
L0054B:
	MOVE.W	#$0001,$0020(A2)
L0054C:
	BRA.W	L00562

; weapon

L0054D:
	MOVEq	#10,D0
	JSR	_rnd
	MOVE.W	D0,$0020(A2)	;random subtype
	MOVE.L	A2,-(A7)
	JSR	_init_weapon
	ADDQ.W	#4,A7

	MOVEq	#100,D0
	JSR	_rnd
	MOVE.W	D0,D5
	CMP.W	#10,D0
	BGE.B	L0054E

	ORI.W	#O_ISCURSED,$0028(A2)	; 10% chance that the weapon is cursed

	MOVEq	#$0003,D0
	JSR	_rnd
	ADDQ.W	#1,D0
	SUB.W	D0,$0022(A2)	;1-3 negative hit
	BRA.B	L0054F
L0054E:
	CMP.W	#15,D5
	BGE.B	L0054F		;5% chance for a enchanted weapon

	MOVEq	#$0003,D0
	JSR	_rnd
	ADDQ.W	#1,D0
	ADD.W	D0,$0022(A2)	;1-3 positive hit
L0054F:
	BRA.W	L00562

; armor

L00550:
	MOVEQ	#$00,D4
	MOVEq	#100,D0
	JSR	_rnd
	LEA	-$6F10(A4),A6	;_a_chances
	BRA.B	L00552
L00551:
	MOVE.W	D4,D3
;	EXT.L	D3
	ASL.w	#1,D3
	CMP.W	$00(A6,D3.w),D0
	BLT.B	L00553

	ADDQ.W	#1,D4
L00552:
	CMP.W	#$0008,D4
	BLT.B	L00551
L00553:
	MOVE.W	D4,$0020(A2)
	moveq	#$61,d3	;a armor type
	ADD.W	D4,D3
	MOVE.W	D3,$000A(A2)
	MOVE.W	D4,D3
;	EXT.L	D3
	ASL.w	#1,D3
	LEA	-$6F00(A4),A6	;_a_class
	MOVE.W	$00(A6,D3.w),$0026(A2)

	MOVEq	#100,D0
	JSR	_rnd
	MOVE.W	D0,D5
	CMP.W	#10,D0
	BGE.B	L00554

	ORI.W	#O_ISCURSED,$0028(A2)	; 10% chance that the armor is cursed

	MOVEq	#$0003,D0
	JSR	_rnd
	ADDQ.W	#1,D0
	ADD.W	D0,$0026(A2)	;1-3 points bad
	BRA.B	L00555
L00554:
	CMP.W	#28,D5		;18% chance for enchanted armor
	BGE.B	L00555

	MOVEq	#$0003,D0
	JSR	_rnd
	ADDQ.W	#1,D0		;1-3 points good
	SUB.W	D0,$0026(A2)
L00555:
	BRA.W	L00562

; ring

L00556:
	MOVE.W	#$003D,$000A(A2)	;'='
	MOVE.W	#14,-(A7)
	PEA	-$6E08(A4)
	JSR	_pick_one(PC)
	ADDQ.W	#6,A7
	MOVE.W	D0,$0020(A2)
;	MOVE.W	$0020(A2),D0
;	EXT.L	D0
	BRA.B	L0055B
L00557:
	MOVEq	#3,D0
	JSR	_rnd
	MOVE.W	D0,$0026(A2)
;	TST.W	D0
	BNE.B	L00558

	MOVE.W	#$FFFF,$0026(A2)	;-1
	ORI.W	#O_ISCURSED,$0028(A2)	; set curse bit
L00558:
	BRA.B	L0055D
L00559:
	ORI.W	#O_ISCURSED,$0028(A2)
	BRA.B	L0055D
L0055A:
	dc.w	L00557-L0055C	;list of rings
	dc.w	L00557-L0055C
	dc.w	L0055D-L0055C
	dc.w	L0055D-L0055C
	dc.w	L0055D-L0055C
	dc.w	L0055D-L0055C
	dc.w	L00559-L0055C
	dc.w	L00557-L0055C
	dc.w	L00557-L0055C
	dc.w	L0055D-L0055C
	dc.w	L0055D-L0055C
	dc.w	L00559-L0055C
L0055B:
	CMP.w	#12,D0
	BCC.B	L0055D
	ASL.w	#1,D0
	MOVE.W	L0055A(PC,D0.W),D0
L0055C:	JMP	L0055C(PC,D0.W)
L0055D:
	BRA.B	L00562

; wand/staff

L0055E:
	MOVE.W	#$002F,$000A(A2)	;'/' wand/staff type
	MOVE.W	#$000E,-(A7)
	PEA	-$6D98(A4)	;_ws_magic
	BSR.B	_pick_one
	ADDQ.W	#6,A7
	MOVE.W	D0,$0020(A2)
	MOVE.L	A2,-(A7)
	JSR	_fix_stick
	ADDQ.W	#4,A7
	BRA.B	L00562
L0055F:
	dc.w	L00548-L00561	;potions
	dc.w	L00549-L00561	;scrolls
	dc.w	L0054A-L00561	;food
	dc.w	L0054D-L00561	;weapon
	dc.w	L00550-L00561	;armor
	dc.w	L00556-L00561	;ring
	dc.w	L0055E-L00561	;wand/staff
L00560:
	CMP.w	#$0007,D0
	BCC.B	L00562
	ASL.w	#1,D0
	MOVE.W	L0055F(PC,D0.W),D0
L00561:	JMP	L00561(PC,D0.W)
L00562:
	MOVE.L	A2,D0
	BRA.W	L00544

;/*
; * pick_one:
; *  Pick an item out of a list of nitems possible objects
; */

_pick_one:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5/A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVE.L	A2,D5
	MOVE.W	$000C(A5),D3
	EXT.L	D3
	ASL.L	#3,D3
	MOVEA.L	D3,A3
	ADDA.L	A2,A3

	MOVEq	#100,D0
	JSR	_rnd
	MOVE.W	D0,D4
	BRA.B	L00564
L00563:
	CMP.W	$0004(A2),D4
	BLT.B	L00565
	ADDQ.L	#8,A2
L00564:
	CMPA.L	A3,A2
	BCS.B	L00563
L00565:
	CMPA.L	A3,A2
	BNE.B	L00566
	MOVEA.L	D5,A2
L00566:
	MOVE.L	A2,D0
	SUB.L	D5,D0
	LSR.L	#3,D0

	MOVEM.L	(A7)+,D4/D5/A2/A3
	UNLK	A5
	RTS

;/*
; * discovered:
; *  list what the player has discovered in this game of a certain type
; */

_discovered:
	MOVEM.L	D5-D7/A2/A3,-(A7)

	MOVEq	#$0021,D7	;'!' potions
	MOVEQ	#14,D5
	LEA	-$66E7(A4),A2	;_p_know
	LEA	_p_guess-BASE(A4),A3	;_p_guess
	BSR.B	_print_disc

	PEA	L00567(PC)	;" ",0
	PEA	-$69CC(A4)	;_nullstr
	JSR	_add_line(PC)
	ADDQ.W	#8,A7

	MOVEq	#$003F,D7	;'?' scrolls
	MOVEQ	#15,D5
	LEA	-$66F6(A4),A2	;_s_know
	LEA	_s_guess-BASE(A4),A3	;_s_guess
	BSR.B	_print_disc

	PEA	L00567(PC)	;" ",0
	PEA	-$69CC(A4)	;_nullstr
	JSR	_add_line(PC)
	ADDQ.W	#8,A7

	MOVEq	#$003D,D7	;'=' rings
	MOVEQ	#14,D5
	LEA	-$66D9(A4),A2	;_r_know
	LEA	_r_guess-BASE(A4),A3	;_r_guess
	BSR.B	_print_disc

	PEA	L00567(PC)	;" ",0
	PEA	-$69CC(A4)	;_nullstr
	JSR	_add_line(PC)
	ADDQ.W	#8,A7

	MOVEq	#$002F,D7	;'/' sticks
	MOVEQ	#14,D5
	LEA	-$66CB(A4),A2	;_ws_know
	LEA	_ws_guess-BASE(A4),A3	;_ws_guess
	BSR.B	_print_disc

	PEA	-$69CC(A4)	;_nullstr
	JSR	_end_line(PC)
	ADDQ.W	#4,A7

	MOVEM.L	(A7)+,D5-D7/A2/A3
	RTS

L00567:	dc.b	" ",0

;/*
; * print_disc:
; *  Print what we've discovered of type 'type'
; */

_print_disc:
	MOVE.W	D5,-(A7)
	PEA	-$547E(A4)
	JSR	_set_order(PC)
	ADDQ.W	#6,A7

	MOVE.W	#$0001,-$5492(A4)
	CLR.W	-$5488(A4)
	MOVEQ	#$00,D6		;discovery counter
	BRA.B	L00572
L00570:
	MOVE.W	D5,D3
	ASL.w	#1,D3
	LEA	-$547E(A4),A6
	MOVE.W	$00(A6,D3.w),D2
	TST.B	$00(A2,D2.W)	;did we knew it?
	BNE.B	L00571

	MULU.W	#21,D2
	TST.B	$00(A3,D2.L)	;did we guessed it?
	BEQ.B	L00572
L00571:
	MOVE.W	D7,-$54A6(A4)
	MOVE.W	$00(A6,D3.w),-$5490(A4)
	MOVE.W	#$0026,-(A7)
	PEA	-$54B0(A4)
	JSR	_nameof
	ADDQ.W	#6,A7
	MOVE.L	D0,-(A7)
	PEA	L00575(PC)	;"%s"
	PEA	-$69CC(A4)	;_nullstr
	JSR	_add_line(PC)
	LEA	$000C(A7),A7
	ADDQ.W	#1,D6		;increase discovery counter
L00572:
	DBRA	D5,L00570	;are we done with the list?

	TST.W	D6		;did we discover anything?
	BNE.B	L00574

	MOVE.W	D7,-(A7)
	JSR	_nothing(PC)
	ADDQ.W	#2,A7
	MOVE.L	D0,-(A7)
	PEA	-$69CC(A4)	;_nullstr
	JSR	_add_line(PC)
	ADDQ.W	#8,A7
L00574:
	RTS

L00575:
	dc.b	"%s",0,0

;/*
; * set_order:
; *  Set up order for list
; */

_set_order:
	LINK	A5,#-$0000
	MOVEM.L	D4-D5,-(A7)

	MOVEQ	#$00,D4
	MOVEA.L	$0008(A5),A6	;A6 valid for complete function
	BRA.B	L00577
L00576:
	MOVE.W	D4,D3
;	EXT.L	D3
	ASL.w	#1,D3
	MOVE.W	D4,$00(A6,D3.w)
	ADDQ.W	#1,D4
L00577:
	CMP.W	$000C(A5),D4
	BLT.B	L00576

	MOVE.W	$000C(A5),D4
	BRA.B	L00579
L00578:
	MOVE.W	D4,D0
	JSR	_rnd

	MOVE.W	D4,D3
	SUBQ.W	#1,D3
	ASL.w	#1,D3
	MOVE.W	$00(A6,D3.w),D5
	ASL.w	#1,D0
	MOVE.W	$00(A6,D0.w),$00(A6,D3.w)
	MOVE.W	D5,$00(A6,D0.w)
	SUBQ.W	#1,D4
L00579:
	CMP.W	#$0000,D4
	BGT.B	L00578

	MOVEM.L	(A7)+,D4-D5
	UNLK	A5
	RTS

_clr_sel_chr:
	CLR.W	d1
	MOVEq	#$0015,d0
	LEA	-$5460(A4),a0
	JSR	_memset

	RTS

_sel_char:
;	LINK	A5,#-$0000
	MOVE.W	$0004(A7),D3
	LEA	-$5460(A4),A6
	MOVE.B	$00(A6,D3.W),D0
;	EXT.W	D0
;	UNLK	A5
	RTS

;/*
; * add_line:
; *  Add a line to the list of discoveries
; */

_add_line:
	LINK	A5,#-$0004
	MOVE.L	D4,-(A7)

	MOVEQ	#$20,D4
	JSR	_wtext
	CMPI.W	#$0014,-$54BC(A4)
	BGE.B	L0057A

	TST.L	$000C(A5)
	BNE.B	L0057F
L0057A:
	moveq	#0,d1
	MOVEq	#$0014,d0
	JSR	_movequick

	MOVEA.L	$0008(A5),A6
	TST.B	(A6)
	BEQ.B	L0057B

	MOVE.L	$0008(A5),-(A7)
	PEA	L00584(PC)	;"-Select item to %s. Esc to cancel-"
	JSR	_printw
	ADDQ.W	#8,A7
	BRA.B	L0057C
L0057B:
	PEA	L00585(PC)	;"-Press space to continue-"
	JSR	_addstr
	ADDQ.W	#4,A7
L0057C:
	MOVE.B	#$01,-$66B0(A4)	;_want_click
L0057D:
	JSR	_readchar
	MOVE.W	D0,D4
	CMP.W	#$001B,D4	;escape
	BEQ.B	L0057E

	CMP.W	#$0020,D4	;' '
	BEQ.B	L0057E

	MOVE.W	D4,d0
	JSR	_islower

	TST.W	D0
	BEQ.B	L0057D
L0057E:
	CLR.B	-$66B0(A4)	;_want_click
	MOVE.B	#$01,-$54BA(A4)
	CLR.W	-$54BC(A4)
	JSR	_clear
L0057F:
	TST.L	$000C(A5)
	BEQ.B	L00582

	TST.W	-$54BC(A4)
	BNE.B	L00580

	MOVEA.L	$000C(A5),A6
	MOVE.B	(A6),D3
	EXT.W	D3
;	TST.W	D3
	BEQ.B	L00582
L00580:
	CMP.W	#$001B,D4	;escape
	BEQ.B	L00582

	MOVE.W	D4,d0
	JSR	_islower

	TST.W	D0
	BNE.B	L00582

	moveq	#0,d1
	MOVE.W	-$54BC(A4),d0
	JSR	_movequick

	MOVE.W	-$54BC(A4),D3
	LEA	-$5460(A4),A6
	MOVEA.L	$000C(A5),A1
	MOVE.B	(A1),$00(A6,D3.W)
	MOVE.L	$0010(A5),-(A7)
	MOVE.L	$000C(A5),-(A7)
	JSR	_printw
	ADDQ.W	#8,A7
	PEA	-$0002(A5)
	PEA	-$0004(A5)
	JSR	_getrc
	ADDQ.W	#8,A7
	TST.W	-$0002(A5)
	BEQ.B	L00581

	MOVE.W	-$0004(A5),D3
	ADDQ.W	#1,D3
	MOVE.W	D3,-$54BC(A4)
L00581:
	MOVE.L	$000C(A5),-$54B8(A4)
	MOVE.L	$0010(A5),-$54B4(A4)
L00582:
	TST.W	-$54BC(A4)
	BNE.B	L00583

	JSR	_wmap
L00583:
	MOVE.W	D4,D0
	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

L00584:	dc.b	"-Select item to %s. Esc to cancel-",0
L00585:	dc.b	"-Press space to continue-",0,0

;/*
; * end_line:
; *  End the list of lines
; */

_end_line:
	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)

	CLR.L	-(A7)
	MOVE.L	$0008(A5),-(A7)
	JSR	_add_line(PC)
	ADDQ.W	#8,A7
	MOVE.W	D0,D4
	CLR.W	-$54BC(A4)
	CLR.B	-$54BA(A4)
	MOVE.W	D4,D0

	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

;/*
; * nothing:
; *  Set up prbuf so that message for "nothing found" is there
; */

_nothing:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2/A3,-(A7)

	MOVE.B	$0009(A5),D4
	PEA	L0058D(PC)	;"Haven't discovered anything"
	MOVE.L	_prbuf-BASE(A4),-(A7)	;_prbuf
	JSR	_sprintf
	ADDQ.W	#8,A7

	TST.B	_terse-BASE(A4)	;_terse
	BEQ.B	L00586

	PEA	L0058E(PC)	;"Nothing"
	MOVE.L	_prbuf-BASE(A4),-(A7)	;_prbuf
	JSR	_sprintf
	ADDQ.W	#8,A7
L00586:
	MOVE.L	_prbuf-BASE(A4),A0	;_prbuf
	JSR	_strlenquick

	EXT.L	D0
	MOVEA.L	D0,A2
	ADDA.L	_prbuf-BASE(A4),A2	;_prbuf
	MOVEQ	#$00,D0
	MOVE.B	D4,D0
	BRA.B	L0058B
L00587:
	LEA	L0058F(PC),A3	;"potion"
	BRA.B	L0058C
L00588:
	LEA	L00590(PC),A3	;"scroll"
	BRA.B	L0058C
L00589:
	LEA	L00591(PC),A3	;"ring"
	BRA.B	L0058C
L0058A:
	LEA	L00592(PC),A3	;"stick"
	BRA.B	L0058C
L0058B:
	SUB.w	#$0021,D0	;'!' potion
	BEQ.B	L00587
	SUB.w	#$000E,D0	;'/' wand/staff
	BEQ.B	L0058A
	SUB.w	#$000E,D0	;'=' ring
	BEQ.B	L00589
	SUBQ.w	#2,D0		;'?' scroll
	BEQ.B	L00588
L0058C:
	MOVE.L	A3,-(A7)
	PEA	L00593(PC)	;" about any %ss"
	MOVE.L	A2,-(A7)

	JSR	_sprintf
	LEA	$000C(A7),A7
	MOVE.L	_prbuf-BASE(A4),D0	;_prbuf

	MOVEM.L	(A7)+,D4/A2/A3
	UNLK	A5
	RTS

L0058D:	dc.b	"Haven't discovered anything",0
L0058E:	dc.b	"Nothing",0
L0058F:	dc.b	"potion",0
L00590:	dc.b	"scroll",0
L00591:	dc.b	"ring",0
L00592:	dc.b	"stick",0
L00593:	dc.b	" about any %ss",0

_nmadd:
	LINK	A5,#-$0000

	MOVEA.L	-$5336(A4),A6
	CMPA.L	_prbuf-BASE(A4),A6	;_prbuf
	BEQ.B	L00B11

	MOVEA.L	-$5336(A4),A6
	ADDQ.L	#1,-$5336(A4)
	MOVE.B	#$20,(A6)
L00B11:
	MOVEA.L	-$5336(A4),A6
	CLR.B	(A6)
	MOVE.L	$0010(A5),-(A7)
	MOVE.L	$000C(A5),-(A7)
	MOVE.L	$0008(A5),-(A7)
	MOVE.L	A6,-(A7)
	JSR	_sprintf
	LEA	$0010(A7),A7

	MOVEA.L	-$5336(A4),A6
1$	TST.B	(A6)+
	BNE.B	1$

2$	SUBQ.L	#1,A6
	MOVE.L	A6,-$5336(A4)
	UNLK	A5
	RTS

_do_count:
	LINK	A5,#-$0000
	MOVE.W	$000C(A5),D3
	AND.W	#O_ISMISL,D3	;O_ISMISL
	BEQ.B	L00B16

	MOVEA.L	$0008(A5),A6
	CMPI.W	#1,$001E(A6)	;is it one item?
	BNE.B	L00B14

	MOVE.L	$000E(A5),-(A7)
	MOVE.L	$000E(A5),-(A7)
	JSR	_vowelstr(PC)
	ADDQ.W	#4,A7
	MOVE.L	D0,-(A7)
	PEA	L00B18(PC)	;"a%s %s"
	BSR.B	_nmadd
	LEA	$000C(A7),A7
	BRA.B	L00B17
L00B14:
	MOVE.L	$000E(A5),-(A7)
	MOVEA.L	$0008(A5),A6
	MOVE.W	$001E(A6),-(A7)
	PEA	L00B19(PC)	;"%d %ss"
	JSR	_nmadd
	LEA	$000A(A7),A7
	BRA.B	L00B17
L00B16:
	MOVE.L	$000E(A5),-(A7)
	JSR	_nmadd
	ADDQ.W	#4,A7
L00B17:
	UNLK	A5
	RTS

L00B18:	dc.b	"a%s %s",0
L00B19:	dc.b	"%d %ss",0
