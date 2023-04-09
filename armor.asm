;/*
; * wear:
; *  The player wants to wear something, so let him/her put it on.
; */

_wear:
	LINK	A5,#-$0000
	MOVEM.L	A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	TST.L	_cur_armor(A4)	;_cur_armor
	BEQ.B	L0012A

	LEA	L0012F(PC),a0	;".  You'll have to take it off first"
	JSR	_noterse

	MOVE.L	D0,-(A7)
	PEA	L0012E(PC)	;"you are already wearing some%s."
	JSR	_msg
	ADDQ.W	#8,A7
	CLR.B	_after(A4)	;_after
L00129:
	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

L0012A:
	MOVE.L	A2,D3
	BNE.B	L0012B

	MOVE.W	#$0061,-(A7)	;'a' armor type
	PEA	L00130(PC)	;"wear"
	JSR	_get_item
	ADDQ.W	#6,A7

	MOVEA.L	D0,A2
	TST.L	D0
	BEQ.B	L00129
L0012B:
	MOVE.L	A2,-(A7)
	JSR	_typeof
	ADDQ.W	#4,A7

	CMP.W	#$0061,D0	;'a' armor type
	BEQ.B	L0012C

	PEA	L00131(PC)	;"you can't wear that"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L00129
L0012C:
	MOVE.L	A2,-(A7)
	JSR	_check_wisdom
	ADDQ.W	#4,A7

	TST.W	D0
	BNE.B	L00129

	JSR	_waste_time(PC)

	ORI.W	#O_ISKNOW,$0028(A2)
	MOVE.L	A2,_cur_armor(A4)	;_cur_armor

	MOVE.W	#$005C,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_nameof
	ADDQ.W	#6,A7

	MOVE.L	D0,-(A7)
	PEA	L00132(PC)	;"you are now wearing %s"
	JSR	_msg
	ADDQ.W	#8,A7

	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_pack_name
	ADDQ.W	#6,A7

	BRA	L00129

L0012E:	dc.b	"you are already wearing some%s.",0
L0012F:	dc.b	".  You'll have to take it off first",0
L00130:	dc.b	"wear",0
L00131:	dc.b	"you can't wear that",0
L00132:	dc.b	"you are now wearing %s",0

;/*
; * take_off:
; *  Get the armor off of the players back
; */

_take_off:
;	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	_cur_armor(A4),A2	;_cur_armor
	MOVE.L	A2,D3
	BNE.B	L00134

	CLR.B	_after(A4)	;_after
	PEA	L00136(PC)	;"you aren't wearing any armor"
	JSR	_msg
	ADDQ.W	#4,A7
L00133:
	MOVEA.L	(A7)+,A2
;	UNLK	A5
	RTS

L00134:
	MOVE.L	_cur_armor(A4),-(A7)	;_cur_armor
	JSR	_can_drop
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00133

	CLR.L	_cur_armor(A4)	;_cur_armor
	MOVE.W	#$005C,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_nameof
	ADDQ.W	#6,A7

	MOVE.L	D0,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_pack_char(PC)
	ADDQ.W	#4,A7

	MOVE.W	D0,-(A7)
	PEA	L00137(PC)	;"you used to be wearing %c) %s"
	JSR	_msg
	LEA	$000A(A7),A7

	BRA.B	L00133

L00136:	dc.b	"you aren't wearing any armor",0
L00137:	dc.b	"you used to be wearing %c) %s",0,0

;/*
; * waste_time:
; *  Do nothing but let other things happen
; */

_waste_time:
;	LINK	A5,#-$0000
	JSR	_do_daemons(PC)
;	UNLK	A5
	RTS
