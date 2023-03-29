;/*
; * get_num:
; *  Get a numeric option
; */

_get_num:
	LINK	A5,#-$000C

	MOVE.W	#$000A,-(A7)
	PEA	-$000C(A5)
	JSR	_getinfo
	ADDQ.W	#6,A7

	PEA	-$000C(A5)
	JSR	_atoi(PC)
	ADDQ.W	#4,A7

	MOVEA.L	$0008(A5),A6
	MOVE.W	D0,(A6)
	UNLK	A5
	RTS
