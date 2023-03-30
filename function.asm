_BuildFuncTable:
	LINK	A5,#-$0002

	CLR.W	-$0002(A5)	;start at F1

1$	MOVE.W	#$0023,-(A7)
	JSR	_malloc
	ADDQ.W	#2,A7

	MOVE.W	-$0002(A5),D3
;	EXT.L	D3
	ASL.w	#2,D3
	MOVEA.L	-$5898(A4),A6	;_FuncKeys

; macro bugfix

	MOVE.L	D0,$00(A6,D3.w)
;	PEA	L00B94(PC)	;"v"
	PEA	-$674D(A4)	;_macro
	ADDQ.W	#1,-$0002(A5)
	MOVE.W	-$0002(A5),D3

	MOVE.W	D3,-(A7)
	BSR	_NewFuncString
	ADDQ.W	#6,A7

	CMPI.W	#$000A,-$0002(A5)
	BLT.B	1$

	UNLK	A5
	RTS

_NewFuncString:
	LINK	A5,#-$0000

	MOVE.L	$000A(A5),-(A7)
	MOVE.W	$0008(A5),D3
	SUBQ.W	#1,D3
;	EXT.L	D3
	ASL.w	#2,D3
	MOVEA.L	-$5898(A4),A6	;_FuncKeys
	MOVE.L	$00(A6,D3.w),-(A7)
	MOVE.W	$0008(A5),-(A7)
	BSR.B	_CopyFuncString
	LEA	$000A(A7),A7

	UNLK	A5
	RTS

_CopyFuncString:
	LINK	A5,#-$0000

	MOVE.L	$000E(A5),A0
	JSR	_strlenquick

	MOVEA.L	$000A(A5),A6
	MOVE.B	D0,(A6)
	MOVE.B	#$04,$0001(A6)
	MOVE.B	#$01,$0002(A6)
	MOVE.B	D0,D3
	ADDQ.B	#4,D3
	MOVE.B	D3,$0003(A6)

	MOVE.L	$000E(A5),-(A7)
	PEA	$0004(A6)
	JSR	_strcpy
	ADDQ.W	#8,A7

	MOVEA.L	$000A(A5),A6
	MOVEQ	#$00,D3
	MOVE.B	$0003(A6),D3
	MOVE.W	$0008(A5),D2
	OR.W	#$0080,D2
	MOVE.B	D2,$00(A6,D3.L)
	UNLK	A5
	RTS

_getfuncstr:
	LINK	A5,#-$0000
	MOVEA.L	$000C(A5),A6
	MOVEQ	#$00,D3
	MOVE.B	(A6),D3
	MOVE.W	D3,-(A7)
	PEA	$0004(A6)
	MOVE.L	$0008(A5),-(A7)
	JSR	_strncpy
	LEA	$000A(A7),A7
	MOVEA.L	$000C(A5),A6
	MOVEQ	#$00,D3
	MOVE.B	(A6),D3
	MOVEA.L	$0008(A5),A6
	CLR.B	$00(A6,D3.L)
	MOVE.L	A6,D0
	UNLK	A5
	RTS

_ChangeFuncKey:
	LINK	A5,#-$0020

	CMPI.W	#$0001,$0008(A5)
	BLT.B	L00B96

	CMPI.W	#$000A,$0008(A5)
	BLE.B	L00B97
L00B96:
	UNLK	A5
	RTS

L00B97:
	PEA	-$0004(A5)
	PEA	-$0002(A5)
	JSR	_getrc
	ADDQ.W	#8,A7

	moveq	#0,d1
	moveq	#0,d0
	JSR	_movequick

	MOVE.W	$0008(A5),D3
	SUBQ.W	#1,D3
	EXT.L	D3
	ASL.L	#2,D3
	MOVEA.L	-$5898(A4),A6	;_FuncKeys

	MOVE.L	$00(A6,D3.L),-(A7)
	PEA	-$001F(A5)
	JSR	_getfuncstr(PC)
	ADDQ.W	#8,A7

	MOVE.L	D0,-(A7)
	MOVE.W	$0008(A5),-(A7)

	PEA	L00B99(PC)	;'Changing F%d from "%s" to: '
	JSR	_printw

	LEA	$000A(A7),A7
	JSR	_clrtoeol

	MOVE.W	#$001A,-(A7)
	PEA	-$001F(A5)
	JSR	_getinfo
	ADDQ.W	#6,A7

	CMP.W	#$001B,D0	;escape
	BEQ.B	L00B98

	PEA	-$001F(A5)
	MOVE.W	$0008(A5),-(A7)
	JSR	_NewFuncString(PC)
	ADDQ.W	#6,A7
L00B98:
	PEA	L00B9A(PC)
	JSR	_msg
	ADDQ.W	#4,A7

	MOVE.W	-$0004(A5),d1
	MOVE.W	-$0002(A5),d0
	JSR	_movequick

	BRA.W	L00B96

L00B99:	dc.b	'Changing F%d from "%s" to: ',0

L00B9A:	dc.b	0,0

_do_macro:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	-$5258(A4),A2	;_prbuf
	MOVE.L	$0008(A5),-(A7)	;show old macro content
	PEA	L008F1(PC)	;"F9 was %s, enter new macro: "
	JSR	_msg
	ADDQ.W	#8,A7

	MOVE.W	$000C(A5),D3	;length of macro buffer
	SUBQ.W	#1,D3

	MOVE.W	D3,-(A7)
	MOVE.L	-$5258(A4),-(A7)	;_prbuf
	JSR	_getinfo
	ADDQ.W	#6,A7

	CMP.W	#$001B,D0	;escape
	BEQ.B	3$

	MOVEA.L	$0008(A5),A6	;_macro address

1$	MOVE.B	(A2)+,D3
	CMP.b	#$06,D3
	BEQ.B	2$

	MOVE.B	D3,(A6)+

2$	TST.B	D3
	BNE.B	1$

3$	PEA	L008F2(PC)
	JSR	_msg
	ADDQ.W	#4,A7

	JSR	_flush_type

; bugfix

	MOVE.L	$0008(A5),-(A7)		;_macro
	MOVE.W	#$0009,-(A7)		;F9
	JSR	_NewFuncString
	ADDQ.W	#6,A7

	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L008F1:	dc.b	"F9 was %s, enter new macro: ",0
L008F2:	dc.b	$00
