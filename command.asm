;/*
; * command:
; *  Process the user commands
; */

_command:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5,-(A7)
	TST.B	-$66B3(A4)	;_is_wizard
	BEQ.B	L00398

	MOVE.B	#$02,_wizard-BASE(A4)	;_wizard
	BRA.B	L00399
L00398:
	CMP.B	#2,_wizard-BASE(A4)	;_wizard
	BNE.B	L00399
	CLR.B	_wizard-BASE(A4)	;_wizard
L00399:
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISHASTE,D3	;C_ISHASTE
	BEQ.B	L0039A

	MOVEq	#$0002,D0
	JSR	_rnd
	MOVE.W	D0,D4
	ADDQ.W	#2,D4
	BRA.B	L0039B
L0039A:
	MOVEQ	#$01,D4
L0039B:
	MOVE.W	D4,D3
	SUBQ.W	#1,D4
	TST.W	D3
	BEQ.W	L003A5

	JSR	_status
	TST.W	_no_command-BASE(A4)	;_no_command
	BEQ.B	L0039D

	SUBQ.W	#1,_no_command-BASE(A4)	;_no_command
	CMPI.W	#$0000,_no_command-BASE(A4)	;_no_command
	BGT.B	L0039E

	PEA	L003A6(PC)	;"you can move again"
	JSR	_msg
	ADDQ.W	#4,A7
	CLR.W	_no_command-BASE(A4)	;_no_command
	BRA.B	L0039E
L0039D:
	JSR	_execcom(PC)
L0039E:
	MOVEQ	#$00,D5
L0039F:
	LEA	_cur_ring_1-BASE(A4),A6	;_cur_ring_x
	MOVE.L	$00(A6,D5.w),D0
	BEQ.B	L003A4

	MOVEA.L	D0,A1
	MOVE.W	$0020(A1),D0
;	EXT.L	D0
	BRA.B	L003A3
L003A0:
	JSR	_search(PC)
	BRA.B	L003A4
L003A1:
	MOVEq	#50,D0
	JSR	_rnd
	CMP.W	#17,D0
	BNE.B	L003A4

	JSR	_teleport
	BRA.B	L003A4
L003A3:
	SUBQ.w	#3,D0	; ring of searching
	BEQ.B	L003A0
	SUBQ.w	#8,D0	; ring of teleportation
	BEQ.B	L003A1
L003A4:
	ADDQ.W	#4,D5
	CMP.W	#$0004,D5
	BLE.B	L0039F

	BRA.W	L0039B
L003A5:
	JSR	_do_daemons(PC)
	MOVEM.L	(A7)+,D4/D5
	UNLK	A5
	RTS

L003A6:	dc.b	"you can move again",0,0

_com_char:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5,-(A7)
	MOVE.B	_fastmode-BASE(A4),D3	;_fastmode
	CMP.B	_faststate-BASE(A4),D3	;_faststate
	SEQ	D4
	ST	_menu_on-BASE(A4)	;_menu_on
L003A7:
	JSR	_readchar
	MOVE.W	D0,D5
	AND.W	#$0080,D0
	BEQ.B	L003A8

	MOVE.W	D5,D3
	AND.W	#$007F,D3
	MOVE.W	D3,-(A7)
	JSR	_ChangeFuncKey
	ADDQ.W	#2,A7
	BRA.B	L003A7
L003A8:
	CLR.B	_menu_on-BASE(A4)	;_menu_on
	TST.W	D4
	BEQ.B	L003A9

	MOVE.B	_faststate-BASE(A4),_fastmode-BASE(A4)	;_faststate,_fastmode
	BRA.B	L003AC
L003A9:
	TST.B	_faststate-BASE(A4)	;_faststate
	SEQ	_fastmode-BASE(A4)	;_fastmode
L003AC:
	MOVE.W	D5,D0
;	EXT.L	D0
	BRA.B	L003B2
L003AD:
	MOVEQ	#$74,D5
	BRA.B	L003B3
L003AE:
	MOVEQ	#$7A,D5
	BRA.B	L003B3
L003AF:
	ADD.W	#$0060,D5
	TST.B	_fastmode-BASE(A4)	;_fastmode
	SEQ	_fastmode-BASE(A4)	;_fastmode
	BRA.B	L003B3
L003B2:
	SUBQ.w	#2,D0	;B
	BEQ.B	L003AF
	SUBQ.w	#6,D0	;H
	BEQ.B	L003AF
	SUBQ.w	#2,D0	;J
	BEQ.B	L003AF
	SUBQ.w	#1,D0	;K
	BEQ.B	L003AF
	SUBQ.w	#1,D0	;L
	BEQ.B	L003AF
	SUBQ.w	#2,D0	;N
	BEQ.B	L003AF
	SUBQ.w	#7,D0	;U
	BEQ.B	L003AF
	SUBQ.w	#4,D0	;Y
	BEQ.B	L003AF
	SUB.w	#$0012,D0	;k
	BEQ.B	L003AD
	SUBQ.w	#2,D0		;m
	BEQ.B	L003AE
L003B3:
	TST.W	_mpos-BASE(A4)	;_mpos
	BEQ.B	L003B5
	TST.B	_running-BASE(A4)	;_running
	BNE.B	L003B5
	CMP.W	#$007F,D5
	BNE.B	L003B4
	CLR.W	_mpos-BASE(A4)	;_mpos
	BRA.B	L003B5
L003B4:
	PEA	L003B6(PC)
	JSR	_msg
	ADDQ.W	#4,A7
L003B5:
	MOVE.W	D5,D0
	MOVEM.L	(A7)+,D4/D5
	UNLK	A5
	RTS

L003B6:
	dc.w	$0000

_get_prefix:
;	LINK	A5,#-$0000
	MOVEM.L	D4-D6,-(A7)

	ST	_after-BASE(A4)	;_after
	MOVE.B	_faststate-BASE(A4),_fastmode-BASE(A4)	;_faststate,_fastmode
	MOVE.W	#$0001,-(A7)
	JSR	_look
	ADDQ.W	#2,A7
	TST.B	_running-BASE(A4)	;_running
	BNE.B	L003B7

	CLR.B	_door_stop-BASE(A4)	;_door_stop
L003B7:
	ST	_is_pickup-BASE(A4)	;_is_pickup
	CLR.B	_again-BASE(A4)	;_again
	SUBQ.W	#1,_count-BASE(A4)	;_count
;	CMPI.W	#$0000,_count-BASE(A4)	;_count
	BLE.B	L003B8

	MOVE.B	_is_pickup_tmp-BASE(A4),_is_pickup-BASE(A4)	;_is_pickup
	MOVEQ	#$00,D3
	MOVE.B	_is_again-BASE(A4),D3
	MOVE.W	D3,D4
	CLR.B	_fastmode-BASE(A4)	;_fastmode
	BRA.W	L003C7
L003B8:
	CLR.W	_count-BASE(A4)	;_count
	TST.B	_running-BASE(A4)	;_running
	BEQ.B	L003B9

	JSR	_one_tick	;slow down the fast mode

	MOVE.B	_runch-BASE(A4),D3	;_runch
	EXT.W	D3
	MOVE.W	D3,D4
	MOVE.B	_is_pickup_tmp-BASE(A4),_is_pickup-BASE(A4)	;_is_pickup
	BRA.W	L003C7
L003B9:
	MOVEQ	#$00,D4
L003BA:
	JSR	_com_char(PC)
	MOVE.W	D0,D5
;	EXT.L	D0
	BRA.B	L003C5
L003BB:
	MOVE.W	_count-BASE(A4),D6	;_count
	MULU.W	#10,D6
;	MOVE.W	D5,D3
	SUB.W	#$0030,D5	;'0'
	ADD.W	D5,D6
;	CMP.W	#$0000,D6
	BLE.B	L003BC
	CMP.W	#100,D6		;limit count to 100 (original was 10000)
	BGE.B	L003BC
	MOVE.W	D6,_count-BASE(A4)	;_count
L003BC:
	JSR	_show_count(PC)
	BRA.W	L003C6

; toggle fastmode

L003BD:
	TST.B	_fastmode-BASE(A4)	;_fastmode
	SEQ	_fastmode-BASE(A4)
	BRA.W	L003C6

; pressed g for dont pickup

L003C0:
	CLR.B	_is_pickup-BASE(A4)	;_is_pickup
	BRA.W	L003C6

; pressed a for again

L003C1:
	MOVEQ	#$00,D3
	MOVE.B	_is_again-BASE(A4),D3
	MOVE.W	D3,D4
	MOVE.W	_again_num-BASE(A4),_count-BASE(A4)	;_count
	MOVE.B	_is_pickup_tmp-BASE(A4),_is_pickup-BASE(A4)	;_is_pickup
	ST	_again-BASE(A4)	;_again
	BRA.B	L003C6

L003C3:
	CLR.B	_door_stop-BASE(A4)	;_door_stop
	CLR.W	_count-BASE(A4)	;_count
	JSR	_show_count(PC)
	BRA.B	L003C6
L003C4:
	MOVE.W	D5,D4
	BRA.B	L003C6
L003C5:
	SUB.w	#$001B,D0	;escape
	BEQ.B	L003C3
	SUBQ.w	#5,D0		;' '
	BEQ.B	L003C6
	SUB.w	#$0010,D0	;'0'
	BEQ.W	L003BB
	SUBQ.w	#1,D0		;'1'
	BEQ.W	L003BB
	SUBQ.w	#1,D0		;'2'
	BEQ.W	L003BB
	SUBQ.w	#1,D0		;'3'
	BEQ.W	L003BB
	SUBQ.w	#1,D0		;'4'
	BEQ.W	L003BB
	SUBQ.w	#1,D0		;'5'
	BEQ.W	L003BB
	SUBQ.w	#1,D0		;'6'
	BEQ.W	L003BB
	SUBQ.w	#1,D0		;'7'
	BEQ.W	L003BB
	SUBQ.w	#1,D0		;'8'
	BEQ.W	L003BB
	SUBQ.w	#1,D0		;'9'
	BEQ.W	L003BB
	SUB.w	#$0028,D0	;'a'
	BEQ.W	L003C1
	SUBQ.w	#5,D0		;'f'
	BEQ.W	L003BD
	SUBQ.w	#1,D0		;'g'
	BEQ.W	L003C0
	BRA.B	L003C4
L003C6:
	TST.W	D4
	BEQ.W	L003BA
L003C7:
	TST.W	_count-BASE(A4)	;_count
	BEQ.B	L003C8

	CLR.B	_fastmode-BASE(A4)	;_fastmode
L003C8:
	MOVE.W	D4,D0
;	EXT.L	D0
	BRA.B	L003CD
L003C9:
	TST.B	_fastmode-BASE(A4)	;_fastmode
	BEQ.B	L003CE

	TST.B	_running-BASE(A4)	;_running
	BNE.B	L003CE

	moveq	#C_ISBLIND,D3	;C_ISBLIND
	AND.W	-$52B4(A4),D3	;_player + 22 (flags)
	BNE.B	L003CA

	ST	_door_stop-BASE(A4)	;_door_stop
	ST	_firstmove-BASE(A4)	;_firstmove
L003CA:
	MOVE.W	D4,-(A7)
	JSR	_toupper
	ADDQ.W	#2,A7
	MOVE.W	D0,D4
	BRA.B	L003CE
L003CC:
	CLR.W	_count-BASE(A4)	;_count
	BRA.B	L003CE
L003CD:
	SUBQ.w	#4,D0
	BEQ.B	L003CE
	SUB.w	#$2A,D0		;'.' for rest
	BEQ.B	L003CE
	SUB.w	#$14,D0		;'B'
	BEQ.B	L003CE
	SUBQ.w	#1,D0		;'C'
	BEQ.B	L003CE
	SUBQ.w	#5,D0		;'H'
	BEQ.B	L003CE
	SUBQ.w	#2,D0		;'J'
	BEQ.B	L003CE
	SUBQ.w	#1,D0		;'K'
	BEQ.B	L003CE
	SUBQ.w	#1,D0		;'L'
	BEQ.B	L003CE
	SUBQ.w	#2,D0		;'N'
	BEQ.B	L003CE
	SUBQ.w	#7,D0		;'U'
	BEQ.B	L003CE
	SUBQ.w	#4,D0		;'Y'
	BEQ.B	L003CE

	SUB.w	#$09,D0		;'b'
	BEQ.B	L003C9
	SUBQ.w	#6,D0		;'h'
	BEQ.B	L003C9
	SUBQ.w	#2,D0		;'j'
	BEQ.B	L003C9
	SUBQ.w	#1,D0		;'k'
	BEQ.B	L003C9
	SUBQ.w	#1,D0		;'l'
	BEQ.B	L003C9
	SUBQ.w	#2,D0		;'n'
	BEQ.W	L003C9
	SUBQ.w	#3,D0		;'q'
	BEQ.B	L003CE
	SUBQ.w	#1,D0		;'r'
	BEQ.B	L003CE
	SUBQ.w	#1,D0		;'s'
	BEQ.B	L003CE
	SUBQ.w	#1,D0		;'t'
	BEQ.B	L003CE
	SUBQ.w	#1,D0		;'u'
	BEQ.W	L003C9
	SUBQ.w	#4,D0		;'y'
	BEQ.W	L003C9
	SUBQ.w	#1,D0		;'z'
	BNE.B	L003CC
L003CE:
	TST.W	_count-BASE(A4)	;_count
	BNE.B	L003CF

	TST.W	_again_num-BASE(A4)
	BEQ.B	L003D0
L003CF:
	BSR.B	_show_count
L003D0:
	MOVE.B	D4,_is_again-BASE(A4)
	MOVE.W	_count-BASE(A4),_again_num-BASE(A4)	;_count
	MOVE.B	_is_pickup-BASE(A4),_is_pickup_tmp-BASE(A4)	;_is_pickup
	MOVE.W	D4,D0
	MOVEM.L	(A7)+,D4-D6
;	UNLK	A5
	RTS

_show_count:
;	LINK	A5,#-$0000

	MOVEq	#$0038,d1
	MOVEq	#$0014,d0
	JSR	_movequick

	TST.W	_count-BASE(A4)	;_count
	BEQ.B	L003D1
	MOVE.W	_count-BASE(A4),-(A7)	;_count
	PEA	L003D3(PC)
	JSR	_printw
	ADDQ.W	#6,A7
	BRA.B	L003D2
L003D1:
	PEA	L003D4(PC)
	JSR	_addstr
	ADDQ.W	#4,A7
L003D2:
;	UNLK	A5
	RTS

L003D3:	dc.b	"%2d",0
L003D4:	dc.b	"  ",0,0

_execcom:
	LINK	A5,#-$0008
	MOVE.L	D4,-(A7)
L003D5:
	JSR	_get_prefix(PC)
	MOVE.W	D0,D4
;	EXT.L	D0
	BRA.W	L00408

; h,j,k,l,b,n,y,u

L003D6:
	PEA	-$0004(A5)
	MOVE.W	D4,-(A7)
	JSR	_find_dir(PC)
	ADDQ.W	#6,A7
	MOVE.W	-$0004(A5),-(A7)
	MOVE.W	-$0002(A5),-(A7)
	JSR	_do_move(PC)
	ADDQ.W	#4,A7
	BRA.W	L00409

; H,J,K,L,B,N,Y,U

L003D7:
	MOVE.W	D4,-(A7)
	JSR	_tolower
	ADDQ.W	#2,A7
	MOVE.W	D0,-(A7)
	JSR	_do_run(PC)
	ADDQ.W	#2,A7
	BRA.W	L00409
L003D8:
	JSR	_get_dir(PC)
	TST.W	D0
	BEQ.B	L003D9
	MOVE.W	_delta+0-BASE(A4),-(A7)	;_delta + 0
	MOVE.W	_delta+2-BASE(A4),-(A7)	;_delta + 2
	JSR	_missile(PC)
	ADDQ.W	#4,A7
	BRA.B	L003DA
L003D9:
	CLR.B	_after-BASE(A4)	;_after
L003DA:
	BRA.W	L00409
L003DB:
	CLR.B	_after-BASE(A4)	;_after
	JSR	_quit(PC)
	BRA.W	L00409

; i inventory

L003DC:
	CLR.B	_after-BASE(A4)	;_after
	PEA	L0040F(PC)	;"",0
	CLR.W	-(A7)
	MOVE.L	-$529C(A4),-(A7)	;_player + 46 (pack)
	JSR	_inventory(PC)
	LEA	$000A(A7),A7
	BRA.W	L00409
L003DD:
	JSR	_drop
	BRA.W	L00409

; q quaff

L003DE:
	CLR.L	-(A7)
	JSR	_quaff
	ADDQ.W	#4,A7
	BRA.W	L00409

; r read

L003DF:
	CLR.L	-(A7)
	JSR	_read_scroll
	ADDQ.W	#4,A7
	BRA.W	L00409

; e eat

L003E0:
	CLR.L	-(A7)
	JSR	_eat(PC)
	ADDQ.W	#4,A7
	BRA.W	L00409

; w wield

L003E1:
	CLR.L	-(A7)
	JSR	_wield(PC)
	ADDQ.W	#4,A7
	BRA.W	L00409

; W wear

L003E2:
	CLR.L	-(A7)
	JSR	_wear
	ADDQ.W	#4,A7
	BRA.W	L00409

; T put off armor

L003E3:
	JSR	_take_off
	BRA.W	L00409

; P put ring on

L003E4:
	CLR.L	-(A7)
	JSR	_ring_on(PC)
	ADDQ.W	#4,A7
	BRA.W	L00409

; R put ring off

L003E5:
	CLR.L	-(A7)
	JSR	_ring_off(PC)
	ADDQ.W	#4,A7
	BRA.W	L00409

; S save game

L003E6:
	CLR.B	_after-BASE(A4)	;_after
	JSR	_save_game
	BRA.W	L00409

; c call item

L003E7:
	CLR.B	_after-BASE(A4)	;_after
	JSR	_call(PC)
	BRA.W	L00409

; > go down one level

L003E8:
	CLR.B	_after-BASE(A4)	;_after
	JSR	_d_level(PC)
	BRA.W	L00409

; < go up one level

L003E9:
	CLR.B	_after-BASE(A4)	;_after
	JSR	_u_level(PC)
	BRA.W	L00409

; ? help

L003EA:
	CLR.B	_after-BASE(A4)	;_after
	JSR	_help
	BRA.W	L00409

; s search

L003EC:
	JSR	_search(PC)
	BRA.W	L00409

; z zap

L003ED:
	JSR	_get_dir(PC)
	TST.W	D0
	BEQ.B	L003EE
	CLR.L	-(A7)
	JSR	_do_zap
	ADDQ.W	#4,A7
	BRA.B	L003EF
L003EE:
	CLR.B	_after-BASE(A4)	;_after
L003EF:
	BRA.W	L00409
L003F0:
	CLR.B	_after-BASE(A4)	;_after
	JSR	_discovered
	BRA.W	L00409

; CTRL-T

L003F1:
	CLR.B	_after-BASE(A4)	;_after
	EORI.B	#$01,_expert-BASE(A4)	;_expert
	TST.B	_expert-BASE(A4)	;_expert
	BEQ.B	L003F2
	LEA	L00410(PC),A6	;"Ok, I'll be brief"
	MOVE.L	A6,D3
	BRA.B	L003F3
L003F2:
	LEA	L00411(PC),A6	;"Goodie, I can use big words again!"
	MOVE.L	A6,D3
L003F3:
	MOVE.L	D3,-(A7)
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L00409

; shift-F set macro

L003F4:
	CLR.B	_after-BASE(A4)	;_after
	MOVE.W	#$0029,-(A7)
	PEA	_macro-BASE(A4)	;_macro
	JSR	_do_macro
	ADDQ.W	#6,A7
	BRA.W	L00409

; CTRL-A

_show_map_check:
	TST.B	_wizard-BASE(A4)	;_wizard
	BEQ.W	L00409

	CLR.B	_after-BASE(A4)	;_after

	bsr	_show_map
	BRA.W	L00409

; CTRL-C bugfix

_add_passages:
	TST.B	_wizard-BASE(A4)	;_wizard
	BEQ.W	L00409

	CLR.B	_after-BASE(A4)	;_after

	bsr	_add_pass
	BRA.W	L00409

; $ show inpack bugfix

show_inpack:
	TST.B	_wizard-BASE(A4)	;_wizard
	BEQ.W	L00409

	CLR.B	_after-BASE(A4)	;_after

	move.w	_inpack-BASE(A4),-(a7)	;_inpack
	pea	inpacktext
	JSR	_msg
	ADDQ.W	#6,A7

	BRA.W	L00409

inpacktext:	dc.b	"inpack = %d",0

; CTRL-E bugfix

_foodleft:
	TST.B	_wizard-BASE(A4)	;_wizard
	BEQ.W	L00409

	CLR.B	_after-BASE(A4)	;_after

	move.w	_food_left-BASE(A4),-(a7)	;_food_left
	pea	foodlefttext
	JSR	_msg
	ADDQ.W	#6,A7

	BRA.W	L00409

foodlefttext:	dc.b	"food left: %d",0

; ctrl-f macro

L003F5:
	CLR.B	_after-BASE(A4)	;_after
	LEA	_macro-BASE(A4),A6	;_macro
	MOVE.L	A6,_typeahead-BASE(A4)	;_typeahead
	BRA.W	L00409

; ctrl-r show last message

L003F6:
	CLR.B	_after-BASE(A4)	;_after
	PEA	_huh-BASE(A4)	;_huh
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L00409

; v show version

L003F7:
	CLR.B	_after-BASE(A4)		;_after
	move.w	#1,-(a7)		; new version extension
	MOVE.W	_verno-BASE(A4),-(A7)	;_verno
	MOVE.W	_revno-BASE(A4),-(A7)	;_revno
	PEA	L00412(PC)	;Rogue Version...
	JSR	_msg
	ADD.W	#10,A7
	BRA.W	L00409

; . rest

L003F8:
	JSR	_doctor(PC)
	BRA.W	L00409

; ^ search for traps in one direction

L003F9:
	CLR.B	_after-BASE(A4)	;_after
	JSR	_get_dir(PC)
	TST.W	D0
	BEQ.B	L003FB

	MOVE.W	-$52BE(A4),D3	;_player + 12
	ADD.W	_delta+2-BASE(A4),D3	;_delta + 2
	MOVE.W	D3,-$0006(A5)
	MOVE.W	-$52C0(A4),D3	;_player + 10
	ADD.W	_delta+0-BASE(A4),D3	;_delta + 0
	MOVE.W	D3,-$0008(A5)

	MOVE.W	-$0008(A5),d0
	MOVE.W	-$0006(A5),d1
	JSR	_INDEXquick

	MOVEA.L	__level-BASE(A4),A6	;__level
	MOVE.B	$00(A6,D0.W),D0
	JSR	_typech

	CMP.W	#$000E,D0
	BEQ.B	L003FA

	PEA	L00413(PC)	;"no trap there."
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L003FB
L003FA:
	MOVE.W	-$0008(A5),d0
	MOVE.W	-$0006(A5),d1
	JSR	_INDEXquick

	MOVEA.L	__flags-BASE(A4),A6	;__flags
	MOVE.B	$00(A6,D0.W),D3
	AND.W	#F_TMASK,D3
	MOVE.W	D3,-(A7)
	JSR	_tr_name(PC)
	ADDQ.W	#2,A7
	MOVE.L	D0,-(A7)
	PEA	L00414(PC)	;"you found %s"
	JSR	_msg
	ADDQ.W	#8,A7
L003FB:
	BRA.W	L00409

; o options

L003FC:
	CLR.B	_after-BASE(A4)	;_after
	PEA	L00415(PC)	;"i don't have any options, oh my!"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L00409

; CTRL-l

L003FD:
	CLR.B	_after-BASE(A4)	;_after
	PEA	L00416(PC)	;"the screen looks fine to me (jll was here)"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L00409

; CTRL-d

L003FE:
	TST.B	_wizard-BASE(A4)	;_wizard
	BEQ.W	L00409
	ADDQ.W	#1,_level-BASE(A4)	;_level
	CMPI.W	#$0001,_count-BASE(A4)	;_count
	BLE.B	L003FF
	MOVE.W	_count-BASE(A4),_level-BASE(A4)	;_count,_level
L003FF:
	JSR	_new_level
	MOVE.W	#$0001,_again_num-BASE(A4)
	CLR.W	_count-BASE(A4)	;_count
	BRA.W	L00409

; shift-C

L00400:
	TST.B	_wizard-BASE(A4)	;_wizard
	BEQ.W	L00409
	CLR.B	_after-BASE(A4)	;_after
	JSR	_create_obj(PC)
	BRA.W	L00409

; CTRL-p

L00401:
;	MOVEQ	#$00,D3
	MOVE.B	_wizard-BASE(A4),D3	;_wizard
	CMP.b	#1,D3
	BEQ.B	L00402

	PEA	L00417(PC)	;"The Grand Beeking"
	PEA	_whoami-BASE(A4)	;_whoami
	JSR	_strcmp
	ADDQ.W	#8,A7
	TST.W	D0
	BEQ.B	L00406

	PEA	L00418(PC)	;"Mr. Mctesq"
	PEA	_whoami-BASE(A4)	;_whoami
	JSR	_strcmp
	ADDQ.W	#8,A7
	TST.W	D0
	BEQ.B	L00406
L00402:
	TST.B	_wizard-BASE(A4)	;_wizard
	BEQ.B	L00403
	LEA	L0041A(PC),A6	"now"
	MOVE.L	A6,D3
	BRA.B	L00404
L00403:
	LEA	L0041B(PC),A6	;"just"
	MOVE.L	A6,D3
L00404:
	MOVE.L	D3,-(A7)
	PEA	L00419(PC)	;"Sorry, You are %s a wimpy dude!"
	JSR	_msg
	ADDQ.W	#8,A7
	TST.B	_wizard-BASE(A4)	;_wizard
	BEQ.B	L00405

	MOVE.W	_level-BASE(A4),D3	;_level
	ADDQ.W	#1,D3
	EXT.L	D3
	DIVS.W	#$0002,D3
	MOVE.W	D3,-$52AC(A4)	;_player + 30 (rank)
	MOVE.W	_level-BASE(A4),D3	;_level
	MULU.W	#5,D3
	MOVE.W	D3,-$52A2(A4)	;_player + 40 (max hp)
	MOVE.W	D3,-$52A8(A4)	;_player + 34 (hp)
	MOVE.W	#$0010,-$6CC2(A4)	;_max_stats + 0 (max strength)
	MOVE.W	#$0010,-$52B2(A4)	;_player + 24 (strength)
	JSR	_raise_level
L00405:
	CLR.B	_wizard-BASE(A4)	;_wizard
	BRA.W	L00409

L00406:
	MOVE.B	#1,_wizard-BASE(A4)		;_wizard
	MOVE.W	#15,-$52AC(A4)	;_player + 30 (rank)
	MOVE.W	#200,-$52A2(A4)	;_player + 40 (max hp)
	MOVE.W	#200,-$52A8(A4)	;_player + 34 (hp)
	MOVE.W	#25,-$6CC2(A4)	;_max_stats + 0 (max strength)
	MOVE.W	#25,-$52B2(A4)	;_player + 24 (strength)

	JSR	_raise_level

	PEA	_whoami-BASE(A4)	;_whoami
	PEA	L0041C(PC)	;"%s, You are one macho dude!"
	JSR	_msg
	ADDQ.W	#8,A7

	BRA.W	L00409

L00407:
	CLR.B	_after-BASE(A4)	;_after
	CLR.B	_save_msg-BASE(A4)	;_save_msg
	MOVE.W	D4,-(A7)
	JSR	_unctrl(PC)
	ADDQ.W	#2,A7
	MOVE.L	D0,-(A7)
	PEA	L0041D(PC)	;"illegal command '%s'"
	JSR	_msg
	ADDQ.W	#8,A7
	CLR.W	_count-BASE(A4)	;_count
	MOVE.B	#$01,_save_msg-BASE(A4)	;_save_msg
	BRA.W	L00409

L00408:
	SUBQ.w	#1,D0	; CTRL-A show map (wizard only)
	BEQ.W	_show_map_check
	SUBQ.w	#2,D0	; CTRL-C add passages (wizard only)
	BEQ.W	_add_passages
	SUBQ.w	#1,D0	; CTRL-D level up (if you can! ;)
	BEQ.W	L003FE
	SUBQ.w	#1,D0	; CTRL-E show food left (wizard only)
	BEQ.W	_foodleft
	SUBQ.w	#1,D0	; CTRL-F clear macro
	BEQ.W	L003F5
	SUBQ.w	#6,D0	; CTRL-L fun message
	BEQ.W	L003FD
	SUBQ.w	#4,D0	; CTRL-P activate wizard mode (if you can! ;)
	BEQ.W	L00401
	SUBQ.w	#2,D0	; CTRL-R show last message
	BEQ.W	L003F6
	SUBQ.w	#2,D0	; CTRL-T toggle expert mode
	BEQ.W	L003F1
	SUB.w	#$10,D0	; $ show inpack (wizard only)
	BEQ.W	show_inpack
	SUB.w	#$0A,D0	; . rest
	BEQ.W	L003F8
	SUB.w	#$0E,D0	; < go up
	BEQ.W	L003E9
	SUBQ.w	#2,D0	; > go down
	BEQ.W	L003E8
	SUBQ.w	#1,D0	; ? help page
	BEQ.W	L003EA
	SUBQ.w	#3,D0	; SHIFT-B
	BEQ.W	L003D7
	SUBQ.w	#1,D0	; SHIFT-C create object (if you can! ;)
	BEQ.W	L00400
	SUBQ.w	#1,D0	; SHIFT-D show discovered items
	BEQ.W	L003F0
	SUBQ.w	#2,D0	; SHIFT-F set macro
	BEQ.W	L003F4
	SUBQ.w	#2,D0	; SHIFT-H
	BEQ.W	L003D7
	SUBQ.w	#2,D0	; SHIFT-J
	BEQ.W	L003D7
	SUBQ.w	#1,D0	; SHIFT-K
	BEQ.W	L003D7
	SUBQ.w	#1,D0	; SHIFT-L
	BEQ.W	L003D7
	SUBQ.w	#2,D0	; SHIFT-N
	BEQ.W	L003D7
	SUBQ.w	#2,D0	; SHIFT-P put off ring
	BEQ.W	L003E4
	SUBQ.w	#1,D0	; SHIFT-Q quit game
	BEQ.W	L003DB
	SUBQ.w	#1,D0	; SHIFT-R put on ring
	BEQ.W	L003E5
	SUBQ.w	#1,D0	; SHIFT-S save game
	BEQ.W	L003E6
	SUBQ.w	#1,D0	; SHIFT-T put off armor
	BEQ.W	L003E3
	SUBQ.w	#1,D0	; SHIFT-U
	BEQ.W	L003D7
	SUBQ.w	#2,D0	; SHIFT-W put on armor
	BEQ.W	L003E2
	SUBQ.w	#2,D0	; SHIFT-Y
	BEQ.W	L003D7
	SUBQ.w	#5,D0	; ^ = search for traps in one direction
	BEQ.W	L003F9
	SUBQ.w	#4,D0	; b move diagonal
	BEQ.W	L003D6
	SUBQ.w	#1,D0	; c call
	BEQ.W	L003E7
	SUBQ.w	#1,D0	; d drop
	BEQ.W	L003DD
	SUBQ.w	#1,D0	; e eat
	BEQ.W	L003E0
	SUBQ.w	#3,D0	; h move left
	BEQ.W	L003D6
	SUBQ.w	#1,D0	; i inventory
	BEQ.W	L003DC
	SUBQ.w	#1,D0	; j move down
	BEQ.W	L003D6
	SUBQ.w	#1,D0	; k move up
	BEQ.W	L003D6
	SUBQ.w	#1,D0	; l move right
	BEQ.W	L003D6
	SUBQ.w	#2,D0	; n move diagonal
	BEQ.W	L003D6
	SUBQ.w	#1,D0	; o options
	BEQ.W	L003FC
	SUBQ.w	#2,D0	; q quaff
	BEQ.W	L003DE
	SUBQ.w	#1,D0	; r read
	BEQ.W	L003DF
	SUBQ.w	#1,D0	; s search
	BEQ.W	L003EC
	SUBQ.w	#1,D0	; t throw
	BEQ.W	L003D8
	SUBQ.w	#1,D0	; u move diagonal
	BEQ.W	L003D6
	SUBQ.w	#1,D0	; v version
	BEQ.W	L003F7
	SUBQ.w	#1,D0	; w wield
	BEQ.W	L003E1
	SUBQ.w	#2,D0	; y move diagonal
	BEQ.W	L003D6
	SUBQ.w	#1,D0	; z zap
	BEQ.W	L003ED
	SUBQ.w	#5,D0	; backspace
	BEQ.W	L00409
	BRA.W	L00407
L00409:
	CLR.B	-$66B1(A4)	;_com_from_menu

	TST.B	_take-BASE(A4)	;_take
	BEQ.B	L0040A

	TST.B	_is_pickup-BASE(A4)	;_is_pickup
	BEQ.B	L0040A

	MOVE.B	_take-BASE(A4),D3	;_take
	EXT.W	D3
	MOVE.W	D3,-(A7)
	JSR	_pick_up(PC)
	ADDQ.W	#2,A7
L0040A:
	CLR.B	_take-BASE(A4)	;_take
	TST.B	_running-BASE(A4)	;_running
	BNE.B	L0040B
	CLR.B	_door_stop-BASE(A4)	;_door_stop
L0040B:
	TST.B	_mouse_run-BASE(A4)	;_mouse_run
	BEQ.B	L0040E
	TST.B	_running-BASE(A4)	;_running
	BEQ.B	L0040D

	JSR	_INDEXplayer

	MOVEA.L	__flags-BASE(A4),A6	;__flags
	MOVE.B	$00(A6,D0.W),D3
	AND.W	#F_SEEN,D3
	BNE.B	L0040C
	JSR	_mouse_adjust
	MOVE.B	D0,_runch-BASE(A4)	;_runch
L0040C:
	BRA.B	L0040E
L0040D:
	CLR.B	_mouse_run-BASE(A4)	;_mouse_run
L0040E:
	TST.B	_after-BASE(A4)	;_after
	BEQ.W	L003D5

	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

L0040F:	dc.b	$00
L00410:	dc.b	"Ok, I'll be brief",0
L00411:	dc.b	"Goodie, I can use big words again!",0
L00412:	dc.b	"Rogue version %d.%d.%d (Mr. Mctesq was here)",0
L00413:	dc.b	"no trap there.",0
L00414:	dc.b	"you found %s",0
L00415:	dc.b	"i don't have any options, oh my!",0
L00416:	dc.b	"the screen looks fine to me (jll was here)",0
L00417:	dc.b	"The Grand Beeking",0
L00418:	dc.b	"Mr. Mctesq",0
L00419:	dc.b	"Sorry, You are %s a wimpy dude!",0
L0041A:	dc.b	"now",0
L0041B:	dc.b	"just",0
L0041C:	dc.b	"%s, You are one macho dude!",0
L0041D:	dc.b	"illegal command '%s'",0

;/*
; * search:
; *  player gropes about him to find hidden things.
; */

_search:
;	LINK	A5,#-$0000
	MOVEM.L	D4-D7/A2,-(A7)

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BNE.B	L008C1
L008C2:
	MOVE.W	-$52BE(A4),D6	;_player + 12
	MOVE.W	-$52C0(A4),D7	;_player + 10
	MOVE.W	D6,D4
	ADDQ.W	#1,D6
	ADDQ.W	#1,D7
	SUBQ.W	#1,D4
	BRA.W	L008CB
L008C3:
	MOVE.W	-$52C0(A4),D5	;_player + 10
	SUBQ.W	#1,D5
	BRA.W	L008CA
L008C4:
	CMP.W	-$52BE(A4),D4	;_player + 12
	BNE.B	L008C5

	CMP.W	-$52C0(A4),D5	;_player + 10
	BEQ.W	L008C9
L008C5:
	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_offmap(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.W	L008C9

	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick

;	EXT.L	D0
	MOVEA.w	D0,A2
	ADDA.L	__flags-BASE(A4),A2	;__flags
	MOVE.B	(A2),D3
	AND.W	#F_REAL,D3
	BNE.W	L008C9

	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick

	MOVEA.L	__level-BASE(A4),A6	;__level
	MOVE.B	$00(A6,D0.W),D3
	BRA.W	L008C8
L008C6:
	MOVEq	#$0005,D0	;20% chance to find something in the wall
	JSR	_rnd
	TST.W	D0
	BNE.W	L008C9

	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick

	MOVEA.L	__level-BASE(A4),A6	;__level
	MOVE.B	#$2B,$00(A6,D0.W)	;'+' DOOR
	ORI.B	#$10,(A2)
	CLR.B	_running-BASE(A4)	;_running
	CLR.W	_count-BASE(A4)	;_count
	BRA.W	L008C9
L008C7:
	MOVEq	#$0002,D0	;50% chance to find something on the floor
	JSR	_rnd
	TST.W	D0
	BNE.W	L008C9

	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick

	MOVEA.L	__level-BASE(A4),A6	;__level
	MOVE.B	(A2),D3
	AND.W	#$0007,D3
	ADD.W	#$000E,D3
	MOVE.B	D3,$00(A6,D0.W)
	ORI.B	#$10,(A2)
	CLR.B	_running-BASE(A4)	;_running
	CLR.W	_count-BASE(A4)	;_count
	MOVE.B	(A2),D3
	AND.W	#$0007,D3

	MOVE.W	D3,-(A7)
	JSR	_tr_name(PC)	;gets the pointer to the trap name
	ADDQ.W	#2,A7

	MOVE.L	D0,-(A7)
	PEA	L008CC(PC)	;"you found %s"
	JSR	_msg
	ADDQ.W	#8,A7

	BRA.B	L008C9
L008C8:
	SUB.b	#$002D,D3	;'-' WALL
	BEQ.W	L008C6
	SUBQ.b	#1,D3		;'.' FLOOR
	BEQ.B	L008C7
	SUB.b	#$000E,D3	;'<' WALL CORNER
	BEQ.W	L008C6
	SUBQ.b	#2,D3		;'>' WALL CORNER
	BEQ.W	L008C6
	SUB.b	#$003D,D3	;'{' WALL CORNER
	BEQ.W	L008C6
	SUBQ.b	#1,D3		;'|' WALL
	BEQ.W	L008C6
	SUBQ.b	#1,D3		;'}' WALL CORNER
	BEQ.W	L008C6
L008C9:
	ADDQ.W	#1,D5
L008CA:
	CMP.W	D7,D5
	BLE.W	L008C4

	ADDQ.W	#1,D4
L008CB:
	CMP.W	D6,D4
	BLE.W	L008C3
L008C1:
	MOVEM.L	(A7)+,D4-D7/A2
;	UNLK	A5
	RTS

L008CC:	dc.b	"you found %s",0,0

;/*
; * d_level:
; *  He wants to go down a level
; */

_d_level:
;	LINK	A5,#-$0000

	JSR	_INDEXplayer

	MOVEA.L	__level-BASE(A4),A6	;__level
	cmp.b	#'%',$00(A6,D0.W)	;'%'
	BEQ.B	1$

	PEA	L008CF(PC)	;"I see no way down"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	2$
1$
	ADDQ.W	#1,_level-BASE(A4)	;_level
	JSR	_new_level
2$
;	UNLK	A5
	RTS

L008CF:	dc.b	"I see no way down",0

;/*
; * u_level:
; *  He wants to go up a level
; */

_u_level:
;	LINK	A5,#-$0000

	JSR	_INDEXplayer

	MOVEA.L	__level-BASE(A4),A6	;__level
	cmp.b	#'%',$00(A6,D0.W)	;'%'
	BNE.B	L008D3

	TST.B	_amulet-BASE(A4)	;_amulet, do we have it?
	BEQ.B	L008D1

	SUBQ.W	#1,_level-BASE(A4)	;_level, are we already at level 1?
;	TST.W	_level-BASE(A4)	;_level
	BNE.B	L008D0

	JSR	_total_winner(PC)	;then we have reached the surface
L008D0:
	JSR	_new_level
	PEA	L008D5(PC)	;"you feel a wrenching sensation in your gut"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L008D4
L008D1:
	PEA	L008D6(PC)	;"your way is magically blocked"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L008D4
L008D3:
	PEA	L008D7(PC)	;"I see no way up"
	JSR	_msg
	ADDQ.W	#4,A7
L008D4:
;	UNLK	A5
	RTS

L008D5:	dc.b	"you feel a wrenching sensation in your gut",0
L008D6:	dc.b	"your way is magically blocked",0
L008D7:	dc.b	"I see no way up",0,0

;/*
; * call:
; *  Allow a user to call a potion, scroll, or ring something
; */

_call:
	LINK	A5,#-$0008
	MOVEM.L	A2/A3,-(A7)

	CLR.L	-$0008(A5)
	MOVE.W	#$FFFF,-(A7)
	PEA	L008E8(PC)	;"call"
	JSR	_get_item
	ADDQ.W	#6,A7
	MOVEA.L	D0,A2
	MOVE.L	A2,D3
	BNE.B	L008D9
L008D8:
	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

L008D9:
	MOVE.L	A2,-(A7)
	JSR	_typeof
	ADDQ.W	#4,A7
;	EXT.L	D0
	BRA.W	L008E3
L008DA:
	LEA	_r_guess-BASE(A4),A6	;_r_guess
	MOVE.L	A6,-$0004(A5)
	LEA	_r_know-BASE(A4),A6	;_r_know
	MOVEA.L	A6,A3
	MOVE.W	$0020(A2),D3
	MULU.W	#21,D3
	MOVEA.L	-$0004(A5),A6
	MOVE.B	$00(A6,D3.L),D2
;	EXT.W	D2
;	TST.W	D2
	BNE.B	L008DB

	MOVE.W	$0020(A2),D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	_r_stones-BASE(A4),A6	;_r_stones
	MOVE.L	$00(A6,D3.w),-$0008(A5)
L008DB:
	BRA.W	L008E4
L008DC:
	LEA	_p_guess-BASE(A4),A6	;_p_guess
	MOVE.L	A6,-$0004(A5)
	LEA	_p_know-BASE(A4),A6	;_p_know
	MOVEA.L	A6,A3
	MOVE.W	$0020(A2),D3
	MULU.W	#21,D3
	MOVEA.L	-$0004(A5),A6
	MOVE.B	$00(A6,D3.L),D2
;	EXT.W	D2
;	TST.W	D2
	BNE.B	L008DD

	MOVE.W	$0020(A2),D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	_p_colors-BASE(A4),A6	;_p_colors
	MOVE.L	$00(A6,D3.w),-$0008(A5)
L008DD:
	BRA.W	L008E4
L008DE:
	LEA	_s_guess-BASE(A4),A6	;_s_guess
	MOVE.L	A6,-$0004(A5)
	LEA	_s_know-BASE(A4),A6	;_s_know
	MOVEA.L	A6,A3
	MOVE.W	$0020(A2),D3
	MULU.W	#21,D3
	MOVEA.L	-$0004(A5),A6
	MOVE.B	$00(A6,D3.L),D2
;	EXT.W	D2
;	TST.W	D2
	BNE.B	L008DF

	MOVE.W	$0020(A2),D3
	MULU.W	#21,D3
	LEA	_s_names-BASE(A4),A6	;_s_names
	ADD.L	A6,D3
	MOVE.L	D3,-$0008(A5)
L008DF:
	BRA.B	L008E4
L008E0:
	LEA	_ws_guess-BASE(A4),A6	;_ws_guess
	MOVE.L	A6,-$0004(A5)
	LEA	_ws_know-BASE(A4),A6	;_ws_know
	MOVEA.L	A6,A3
	MOVE.W	$0020(A2),D3
	MULU.W	#21,D3
	MOVEA.L	-$0004(A5),A6
	MOVE.B	$00(A6,D3.L),D2
;	EXT.W	D2
;	TST.W	D2
	BNE.B	L008E1

	MOVE.W	$0020(A2),D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	_ws_made-BASE(A4),A6	;_ws_made
	MOVE.L	$00(A6,D3.w),-$0008(A5)
L008E1:
	BRA.B	L008E4
L008E2:
	PEA	L008E9(PC)	;"you can't call that anything"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L008D8
L008E3:
	SUB.w	#$0021,D0	;'!' potions
	BEQ.W	L008DC
	SUB.w	#$000E,D0	;'/' wands/staffs
	BEQ.B	L008E0
	SUB.w	#$000E,D0	;'=' rings
	BEQ.W	L008DA
	SUBQ.w	#2,D0		;'?' scrolls
	BEQ.W	L008DE
	BRA.B	L008E2
L008E4:
	MOVE.W	$0020(A2),D3
	TST.B	$00(A3,D3.W)
	BEQ.B	L008E5

	PEA	L008EA(PC)	;"that has already been identified"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L008D8
L008E5:
	TST.L	-$0008(A5)
	BNE.B	L008E6

	MOVE.W	$0020(A2),D3
	MULU.W	#21,D3
	ADD.L	-$0004(A5),D3
	MOVE.L	D3,-$0008(A5)
L008E6:
	MOVE.L	-$0008(A5),-(A7)
	PEA	L008EB(PC)	;'Was called "%s"'
	JSR	_msg
	ADDQ.W	#8,A7
	PEA	L008EC(PC)	;"what do you want to call it? "
	JSR	_msg
	ADDQ.W	#4,A7
	MOVE.W	#$0014,-(A7)
	MOVE.L	_prbuf-BASE(A4),-(A7)	;_prbuf
	JSR	_getinfo
	ADDQ.W	#6,A7
	MOVEA.L	_prbuf-BASE(A4),A6	;_prbuf
	TST.B	(A6)
	BEQ.B	L008E7

	MOVEA.L	_prbuf-BASE(A4),A6	;_prbuf
	MOVE.B	(A6),D3
;	EXT.W	D3
	CMP.b	#$1B,D3		;escape
	BEQ.B	L008E7

	MOVE.L	_prbuf-BASE(A4),-(A7)	;_prbuf
	MOVE.W	$0020(A2),D3
	MULU.W	#21,D3
	ADD.L	-$0004(A5),D3
	MOVE.L	D3,-(A7)
	JSR	_strcpy
	ADDQ.W	#8,A7
L008E7:
	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_pack_name
	ADDQ.W	#6,A7
	PEA	L008ED(PC)	;"",0
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L008D8

L008E8:	dc.b	"call",0
L008E9:	dc.b	"you can't call that anything",0
L008EA:	dc.b	"that has already been identified",0
L008EB:	dc.b	'Was called "%s"',0
L008EC:	dc.b	"what do you want to call it? ",0
L008ED:	dc.b	$00
