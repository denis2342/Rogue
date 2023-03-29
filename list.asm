;/*
; * detach:
; *  takes an item out of whatever linked list it might be in
; */

__detach:
	LINK	A5,#-$0000
	MOVEM.L	A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2	;list
	MOVEA.L	$000C(A5),A3	;item

	MOVE.L	$0004(A3),D1	;do we have a previous item?
	BEQ.B	L00465

	MOVEA.L	D1,A6
	MOVE.L	(A3),(A6)	;move next item to previous item
L00465:
	MOVE.L	(A3),D0		;do we have a next item?
	BEQ.B	L00466

	MOVEA.L	D0,A6
	MOVE.L	D1,$0004(A6)	;move previous item to next item
L00466:
	CMP.L	(A2),A3		;is the item the first in the list?
	BNE.B	L00464

	MOVE.L	D0,(A2)		;make the next item head of list
L00464:

	CLR.L	(A3)+
	CLR.L	(A3)

	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

;/*
; * _attach:
; *  add an item to the head of a list
; */

__attach:
	LINK	A5,#-$0000
	MOVEM.L	A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2	;list
	MOVEA.L	$000C(A5),A3	;item

	CLR.L	$0004(A3)	;first item has no previous item

	MOVE.L	(A2),(A3)
	BEQ.B	L00468

	MOVEA.L	(A2),A6
	MOVE.L	A3,$0004(A6)
L00468:
	MOVE.L	A3,(A2)

	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

;/*
; * _free_list:
; *  Throw the whole blamed thing away
; */

__free_list:
	LINK	A5,#-$0000
	MOVEM.L	A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
L00469:
	TST.L	(A2)
	BEQ.B	L0046A

	MOVEA.L	(A2),A3
	MOVE.L	(A3),(A2)
	MOVE.L	A3,-(A7)
	JSR	_discard(PC)
	ADDQ.W	#4,A7
	BRA.B	L00469
L0046A:
	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

_talloc:
;	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)
	MOVEQ	#$00,D4
L0046B:
	MOVE.W	D4,D3
	ASL.w	#1,D3
	MOVEA.L	-$52CE(A4),A6	;__t_alloc
	TST.W	$00(A6,D3.w)
	BNE.B	L0046E

	ADDQ.W	#1,-$60A8(A4)	;_total
	MOVE.W	-$60A8(A4),D0	;_total
	CMP.W	-$6098(A4),D0	;_maxitems
	BLE.B	L0046C

	MOVE.W	D0,-$6098(A4)	;_total,_maxitems
L0046C:
	ADDQ.W	#1,$00(A6,D3.w)

	CLR.W	d1
	MOVEq	#50,d0
	MOVE.W	D4,D3
	MULU.W	d0,D3
	ADD.L	-$52D2(A4),D3
	MOVE.L	D3,a0
	JSR	_memset

	MOVE.W	D4,D0
	MULU.W	#50,D0
	ADD.L	-$52D2(A4),D0
L0046D:
	MOVE.L	(A7)+,D4
;	UNLK	A5
	RTS

L0046E:
	ADDQ.W	#1,D4
	CMP.W	#$0053,D4	;number of max total items
	BLT.B	L0046B

	MOVEQ	#$00,D0
	BRA.B	L0046D

;/*
; * new_item
; *  Get a new item with a specified size
; */

_new_item:
	MOVE.L	A2,-(A7)
	BSR.B	_talloc
	TST.L	D0
	BEQ.B	1$

	MOVEA.L	D0,A2
	CLR.L	(A2)+
	CLR.L	(A2)
1$
	MOVEA.L	(A7)+,A2
	RTS

;/*
; * discard:
; *  Free up an item
; */

_discard:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVEQ	#$00,D4

1$	MOVE.W	D4,D3
	MULU.W	#$0032,D3
	ADD.L	-$52D2(A4),D3
	CMP.L	A2,D3
	BEQ.B	2$

	ADDQ.W	#1,D4
	CMP.W	#$0053,D4
	BLT.B	1$

	MOVEQ	#$00,D0
	BRA.B	3$

2$	SUBQ.W	#1,-$60A8(A4)	;_total
	MOVE.W	D4,D3
;	EXT.L	D3
	ASL.w	#1,D3
	MOVEA.L	-$52CE(A4),A6	;__t_alloc
	CLR.W	$00(A6,D3.w)
	MOVEQ	#$01,D0

3$	MOVEM.L	(A7)+,D4/A2
	UNLK	A5
	RTS

