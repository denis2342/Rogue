_save_game:
	LINK	A5,#-$0056

	PEA	_whoami(A4)	;_whoami
	PEA	L00B2E(PC)
	MOVE.L	_prbuf(A4),-(A7)	;_prbuf
	JSR	_sprintf
	LEA	$000C(A7),A7
	MOVE.L	_prbuf(A4),-(A7)	;_prbuf
	CLR.W	-(A7)
	CLR.W	-(A7)
	JSR	_mvaddstr
	ADDQ.W	#8,A7
	JSR	_clrtoeol
	MOVE.L	_prbuf(A4),A0	;_prbuf
	JSR	_strlenquick

	MOVEQ	#$50,D3
	SUB.W	D0,D3
	MOVE.W	D3,-(A7)
	PEA	-$0050(A5)
	JSR	_getinfo
	ADDQ.W	#6,A7
	PEA	L00B2F(PC)
	JSR	_msg
	ADDQ.W	#4,A7
	MOVE.B	-$0050(A5),D3
	EXT.W	D3
	CMP.W	#$001B,D3	;escape
	BNE.B	L00B28
L00B27:
	UNLK	A5
	RTS

L00B28:
	MOVE.B	-$0050(A5),D3
	EXT.W	D3
;	TST.W	D3
	BNE.B	L00B29
	PEA	_whoami(A4)	;_whoami
	PEA	L00B30(PC)
	PEA	-$0050(A5)
	JSR	_sprintf
	LEA	$000C(A7),A7
L00B29:
	PEA	-$0050(A5)
	PEA	L00B31(PC)	;"Saving %s.  Please wait ...."
	JSR	_WBprint
	ADDQ.W	#8,A7
	CLR.W	-(A7)
	PEA	-$0050(A5)
	JSR	_AmigaOpen(PC)
	ADDQ.W	#6,A7
	MOVE.W	D0,_save_game_tmp(A4)
;	CMP.W	#$0000,D0
	BLE.B	L00B2B
	MOVE.W	_save_game_tmp(A4),-(A7)
	JSR	_AmigaClose(PC)
	ADDQ.W	#2,A7
	JSR	_WBenchToBack(PC)
	PEA	-$0050(A5)
	PEA	L00B32(PC)
	MOVE.L	_prbuf(A4),-(A7)	;_prbuf
	JSR	_sprintf
	LEA	$000C(A7),A7
	PEA	L00B34(PC)
	PEA	L00B33(PC)
	MOVE.L	_prbuf(A4),-(A7)	;_prbuf
	JSR	_ask_him
	LEA	$000C(A7),A7
	TST.W	D0
	BEQ.B	L00B2A
	BRA.W	L00B27
L00B2A:
	JSR	_WBenchToFront
	BRA.B	L00B2C
L00B2B:
	MOVE.W	_save_game_tmp(A4),-(A7)
	JSR	_AmigaClose(PC)
	ADDQ.W	#2,A7
L00B2C:
	MOVE.W	#$2710,-(A7)
	PEA	-$0050(A5)
	JSR	_AmigaCreat(PC)
	ADDQ.W	#6,A7
	MOVE.W	D0,_save_game_tmp(A4)
;	CMP.W	#$0000,D0
	BGE.B	L00B2D
	JSR	_WBenchToBack(PC)
	PEA	-$0050(A5)
	PEA	L00B35(PC)
	JSR	_msg
	ADDQ.W	#8,A7
	BRA.W	L00B27
L00B2D:
	MOVE.W	#$0001,_restore_bool(A4)
	JSR	_xfer_all(PC)
	PEA	-$0050(A5)
	PEA	L00B36(PC)
	JSR	_fatal
	ADDQ.W	#8,A7
	BRA.W	L00B27

L00B2E:	dc.b	"Save file name (default %s.save): ",0
L00B2F:	dc.b	$00
L00B30:	dc.b	"%s.save",0
L00B31:	dc.b	"Saving %s.  Please wait ....",10,0
L00B32:	dc.b	'The file "%s" already exists.',0
L00B33:	dc.b	"Cancel save",0
L00B34:	dc.b	"Overwrite it",0
L00B35:	dc.b	"Can't create the save file"
	dc.b	' "%s"',0
L00B36:	dc.b	"Game saved as %s",0

_restore_game:
	LINK	A5,#-$0050
	MOVE.L	A2,-(A7)

	PEA	_whoami(A4)	;_whoami
	PEA	L00B3D(PC)
	MOVE.L	_prbuf(A4),-(A7)	;_prbuf
	JSR	_sprintf
	LEA	$000C(A7),A7
	MOVE.L	_prbuf(A4),-(A7)	;_prbuf
	CLR.W	-(A7)
	CLR.W	-(A7)
	JSR	_mvaddstr
	ADDQ.W	#8,A7
	JSR	_clrtoeol
	MOVE.L	_prbuf(A4),A0	;_prbuf
	JSR	_strlenquick

	MOVEQ	#$50,D3
	SUB.W	D0,D3
	MOVE.W	D3,-(A7)
	PEA	-$0050(A5)
	JSR	_getinfo
	ADDQ.W	#6,A7
	PEA	L00B42(PC)
	JSR	_msg
	ADDQ.W	#4,A7
	MOVE.B	-$0050(A5),D3
	EXT.W	D3
	CMP.W	#$001B,D3	;escape
	BNE.B	L00B38
L00B37:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L00B38:
	MOVE.B	-$0050(A5),D3
	EXT.W	D3
;	TST.W	D3
	BNE.B	L00B39
	PEA	_whoami(A4)	;_whoami
	PEA	L00B3F(PC)
	PEA	-$0050(A5)
	JSR	_sprintf
	LEA	$000C(A7),A7
L00B39:
	MOVE.W	_player+10(A4),d1	;_player + 10
	MOVE.W	_player+12(A4),d0	;_player + 12
	JSR	_movequick

	PEA	-$0050(A5)
	PEA	L00B40(PC)
	JSR	_WBprint
	ADDQ.W	#8,A7
	CLR.W	-(A7)
	PEA	-$0050(A5)
	JSR	_AmigaOpen(PC)
	ADDQ.W	#6,A7
	MOVE.W	D0,_save_game_tmp(A4)
;	CMP.W	#$0000,D0
	BGE.B	L00B3A
	JSR	_WBenchToBack(PC)
	PEA	-$0050(A5)
	PEA	L00B41(PC)
	JSR	_msg
	ADDQ.W	#8,A7
	BRA.B	L00B37
L00B3A:
	CLR.W	_restore_bool(A4)
	JSR	_xfer_all(PC)
	PEA	-$0050(A5)
	JSR	_unlink(PC)
	ADDQ.W	#4,A7
	JSR	_WBenchToBack(PC)
	JSR	_redraw
	ST	_new_stats(A4)	;_new_stats
	JSR	_status
	PEA	L00B42(PC)
	JSR	_msg
	ADDQ.W	#4,A7
	JSR	_InitGadgets
	PEA	_whoami(A4)	;_whoami
	PEA	L00B43(PC)
	JSR	_msg
	ADDQ.W	#8,A7
	MOVEA.L	_player+46(A4),A2	;_player + 46 (pack)
	BRA.B	L00B3C
L00B3B:
	CLR.L	$0010(A2)
	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_pack_name
	ADDQ.W	#6,A7
	MOVEA.L	(A2),A2
L00B3C:
	MOVE.L	A2,D3
	BNE.B	L00B3B
	JSR	_fix_menu(PC)
	JSR	_flush_type

	JSR	_NewRank	;fix to show rank after loading savegame

	BRA.W	L00B37

L00B3D:	dc.b	"Save file name (default %s.save): ",0
L00B3F:	dc.b	"%s.save",0
L00B40:	dc.b	"Restoring %s.  Please Wait ....",10,0
L00B41:	dc.b	"Can't open save file "
	dc.b	'"%s"',0
L00B42:	dc.b	$00
L00B43:	dc.b	"%s's game restored",0

_xfer_all:
	LINK	A5,#-$0002
	MOVEM.L	D4/D5/A2/A3,-(A7)

	MOVE.W	#$0050,-(A7)
	PEA	_whoami(A4)	;_whoami
	JSR	_xfer
	ADDQ.W	#6,A7

	LEA	_SV_END(A4),A6	;_SV_END
	LEA	_SV_START(A4),A1
	SUBA.L	A1,A6
	MOVE.W	A6,-(A7)
	move.l	A1,-(A7)
	JSR	_xfer
	ADDQ.W	#6,A7

	MOVE.W	#$000F,-(A7)
	PEA	_s_names(A4)
	JSR	_xfer_strs(PC)
	ADDQ.W	#6,A7

	MOVE.W	#$000F,-(A7)
	PEA	_s_guess(A4)	;_s_guess
	JSR	_xfer_strs(PC)
	ADDQ.W	#6,A7

	MOVE.W	#$000E,-(A7)
	PEA	_p_guess(A4)	;_p_guess
	JSR	_xfer_strs(PC)
	ADDQ.W	#6,A7

	MOVE.W	#$000E,-(A7)
	PEA	_r_guess(A4)	;_r_guess
	JSR	_xfer_strs(PC)
	ADDQ.W	#6,A7

	MOVE.W	#$000E,-(A7)
	PEA	_ws_guess(A4)	;_ws_guess
	JSR	_xfer_strs(PC)
	ADDQ.W	#6,A7

	JSR	_xfer_choice(PC)
	CLR.L	-(A7)
	PEA	_oldrp(A4)	;_oldrp
	JSR	_xfer_proom(PC)
	ADDQ.W	#8,A7

	CLR.L	-(A7)
	PEA	_lvl_obj(A4)	;_lvl_obj
	JSR	_xfer_pthing
	ADDQ.W	#8,A7

	CLR.L	-(A7)
	PEA	_mlist(A4)	;_mlist
	JSR	_xfer_pthing
	ADDQ.W	#8,A7

	CLR.L	-(A7)
	PEA	_cur_weapon(A4)	;_cur_weapon
	JSR	_xfer_pthing
	ADDQ.W	#8,A7

	CLR.L	-(A7)
	PEA	_cur_armor(A4)	;_cur_armor
	JSR	_xfer_pthing
	ADDQ.W	#8,A7

	CLR.L	-(A7)
	PEA	_cur_ring_1(A4)	;_cur_ring_1
	JSR	_xfer_pthing
	ADDQ.W	#8,A7

	CLR.L	-(A7)
	PEA	_cur_ring_2(A4)	;_cur_ring_2
	JSR	_xfer_pthing
	ADDQ.W	#8,A7

	TST.W	_restore_bool(A4)
	BNE.B	L00B44

	MOVE.W	#$0032,-(A7)
	PEA	_player(A4)	;_player + 0
	BSR.B	_xfer
	ADDQ.W	#6,A7
L00B44:
	PEA	_player(A4)	;_player + 0
	JSR	_xfer_monster(PC)
	ADDQ.W	#4,A7

	MOVE.W	#$00A6,-(A7)		;166
	MOVE.L	__t_alloc(A4),-(A7)	;__t_alloc
	BSR.B	_xfer
	ADDQ.W	#6,A7

	JSR	_xfer_things(PC)
	MOVE.W	#$04EC,-(A7)		;1260
	MOVE.L	__level(A4),-(A7)	;__level
	BSR.B	_xfer
	ADDQ.W	#6,A7

	MOVE.W	#$04EC,-(A7)		;1260
	MOVE.L	__flags(A4),-(A7)	;__flags
	BSR.B	_xfer
	ADDQ.W	#6,A7

	LEA	_CURSES_END(A4),A6
	LEA	_CURSES_START(A4),A1
	SUBA.L	A1,A6
	MOVE.W	A6,-(A7)
	PEA	_CURSES_START(A4)
	BSR.B	_xfer
	ADDQ.W	#6,A7

	JSR	_dm_xfer
	JSR	_XferKeys(PC)
	MOVE.W	_save_game_tmp(A4),-(A7)
	JSR	_AmigaClose(PC)
	ADDQ.W	#2,A7

	MOVEM.L	(A7)+,D4/D5/A2/A3
	UNLK	A5
	RTS

_XferKeys:
;	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)

	MOVEQ	#$00,D4

1$	MOVE.W	#$0020,-(A7)
	MOVE.W	D4,D3
	EXT.L	D3
	ASL.L	#2,D3
	MOVEA.L	_FuncKeys(A4),A6	;_FuncKeys
	MOVE.L	$00(A6,D3.L),-(A7)
	JSR	_xfer
	ADDQ.W	#6,A7
	ADDQ.W	#1,D4
	CMP.W	#$000A,D4
	BLT.B	1$

	MOVE.L	(A7)+,D4
;	UNLK	A5
	RTS

_xfer:
	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)
	MOVE.W	$000C(A5),_count(A4)	;_count
	TST.W	_restore_bool(A4)
	BEQ.B	L00B45

	MOVE.W	$000C(A5),-(A7)
	MOVE.L	$0008(A5),-(A7)
	MOVE.W	_save_game_tmp(A4),-(A7)
	JSR	_write
	ADDQ.W	#8,A7
	MOVE.W	D0,D4
	BRA.B	L00B46
L00B45:
	MOVE.W	$000C(A5),-(A7)
	MOVE.L	$0008(A5),-(A7)
	MOVE.W	_save_game_tmp(A4),-(A7)
	JSR	_read
	ADDQ.W	#8,A7
	MOVE.W	D0,D4
L00B46:
	CMP.W	#$0000,D4
	BGE.B	L00B47

	MOVE.W	D4,-(A7)
	PEA	L00B48(PC)
	JSR	_fatal
	ADDQ.W	#6,A7
L00B47:
	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

L00B48:	dc.b	"I/O error %d. Game will not be complete.",0,0

_xfer_strs:
	LINK	A5,#-$0004
	MOVE.L	D4,-(A7)
	MOVEQ	#$00,D4
	BRA.W	L00B4E
L00B49:
	TST.W	_restore_bool(A4)
	BEQ.B	L00B4B

	MOVE.W	D4,D3
	MULU.W	#21,D3
	ADD.L	$0008(A5),D3
	MOVE.L	D3,A0
	JSR	_strlenquick

	MOVE.W	D0,-$0002(A5)
	MOVE.W	#$0002,-(A7)
	PEA	-$0002(A5)
	JSR	_xfer
	ADDQ.W	#6,A7
	TST.W	-$0002(A5)
	BEQ.B	L00B4A

	MOVE.W	-$0002(A5),-(A7)
	MOVE.W	D4,D3
	MULU.W	#21,D3
	ADD.L	$0008(A5),D3
	MOVE.L	D3,-(A7)
	JSR	_xfer
	ADDQ.W	#6,A7
L00B4A:
	BRA.B	L00B4D
L00B4B:
	MOVE.W	#$0002,-(A7)
	PEA	-$0002(A5)
	JSR	_xfer
	ADDQ.W	#6,A7
	TST.W	-$0002(A5)
	BEQ.B	L00B4C

	MOVE.W	-$0002(A5),-(A7)
	MOVE.W	D4,D3
	MULU.W	#21,D3
	ADD.L	$0008(A5),D3
	MOVE.L	D3,-(A7)
	JSR	_xfer
	ADDQ.W	#6,A7
L00B4C:
	MOVE.W	D4,D3
	MULU.W	#21,D3
	MOVE.W	-$0002(A5),D2
	EXT.L	D2
	ADD.L	D2,D3
	MOVEA.L	$0008(A5),A6
	CLR.B	$00(A6,D3.L)
L00B4D:
	ADDQ.W	#1,D4
L00B4E:
	CMP.W	$000C(A5),D4
	BLT.W	L00B49

	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

_xfer_choice:
	LINK	A5,#-$0004
	MOVEM.L	D4/D5/A2/A3,-(A7)

	LEA	_p_colors(A4),A6	;_p_colors
	MOVEA.L	A6,A2
L00B4F:
	TST.W	_restore_bool(A4)
	BEQ.B	L00B52

	LEA	_rainbow(A4),A6	;_rainbow
	MOVEA.L	A6,A3
	BRA.B	L00B51
L00B50:
	ADDQ.L	#4,A3
L00B51:
	MOVE.L	(A2),-(A7)
	MOVE.L	(A3),-(A7)
	JSR	_strcmp
	ADDQ.W	#8,A7
	TST.W	D0
	BNE.B	L00B50

	MOVE.L	A3,D3
	LEA	_rainbow(A4),A6	;_rainbow
	SUB.L	A6,D3
	LSR.L	#2,D3
	MOVE.W	D3,-$0002(A5)
L00B52:
	MOVE.W	#$0002,-(A7)
	PEA	-$0002(A5)
	JSR	_xfer
	ADDQ.W	#6,A7
	TST.W	_restore_bool(A4)
	BNE.B	L00B53

	MOVE.W	-$0002(A5),D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	_rainbow(A4),A6	;_rainbow
	MOVE.L	$00(A6,D3.w),(A2)
L00B53:
	ADDQ.L	#4,A2
	LEA	_prbuf(A4),A6	;_prbuf
	CMPA.L	A6,A2
	BCS.B	L00B4F

	LEA	_r_stones(A4),A6	;_r_stones
	MOVEA.L	A6,A2
L00B54:
	TST.W	_restore_bool(A4)
	BEQ.B	L00B57

	LEA	_stones(A4),A6	;_stones
	MOVE.L	A6,D5
	BRA.B	L00B56
L00B55:
	ADDQ.L	#6,D5
L00B56:
	MOVEA.L	D5,A6
	MOVE.L	(A6),-(A7)
	MOVE.L	(A2),-(A7)
	JSR	_strcmp
	ADDQ.W	#8,A7
	TST.W	D0
	BNE.B	L00B55

	MOVE.L	D5,D0
	LEA	_stones(A4),A6	;_stones
	SUB.L	A6,D0
	MOVEQ	#$06,D1
	JSR	_divu
	MOVE.W	D0,-$0002(A5)
L00B57:
	MOVE.W	#$0002,-(A7)
	PEA	-$0002(A5)
	JSR	_xfer
	ADDQ.W	#6,A7
	TST.W	_restore_bool(A4)
	BNE.B	L00B58

	MOVE.W	-$0002(A5),D3
	MULU.W	#$0006,D3
	LEA	_stones(A4),A6	;_stones
	MOVE.L	$00(A6,D3.L),(A2)
	MOVE.L	A2,D3
	LEA	_r_stones(A4),A6	;_r_stones
	SUB.L	A6,D3
	LSR.L	#2,D3
	ASL.L	#3,D3
	LEA	_r_magic+6(A4),A6	;_r_magic + 6
	MOVE.W	-$0002(A5),D2
	MULU.W	#$0006,D2
	LEA	_stones+4(A4),A1	;_stones + 4
	MOVE.W	$00(A1,D2.L),D1
	ADD.W	D1,$00(A6,D3.L)
L00B58:
	ADDQ.L	#4,A2
	LEA	_ws_type(A4),A6	;_ws_type
	CMPA.L	A6,A2
	BCS.W	L00B54

;	LEA	_ws_type(A4),A6	;_ws_type
	MOVE.L	A6,D4
	LEA	_ws_made(A4),A6	;_ws_made
	MOVEA.L	A6,A2
	BRA.W	L00B65
L00B59:
	TST.W	_restore_bool(A4)
	BEQ.B	L00B60

	MOVEA.L	D4,A6
	MOVEA.L	(A6),A1
	CMPA.L	_ws_wand(A4),A1	;_ws_wand
	SEQ	D3
	AND.W	#$0001,D3
	MOVE.W	D3,-$0004(A5)
	MOVE.W	#$0002,-(A7)
	PEA	-$0004(A5)
	JSR	_xfer
	ADDQ.W	#6,A7
	TST.W	-$0004(A5)
	BEQ.B	L00B5A

	LEA	_metal(A4),A6	;_metal
	MOVEA.L	A6,A3
	BRA.B	L00B5B
L00B5A:
	LEA	_wood(A4),A6	;_wood
	MOVEA.L	A6,A3
L00B5B:
	BRA.B	L00B5D
L00B5C:
	ADDQ.L	#4,A3
L00B5D:
	MOVE.L	(A2),-(A7)
	MOVE.L	(A3),-(A7)
	JSR	_strcmp
	ADDQ.W	#8,A7
	TST.W	D0
	BNE.B	L00B5C
	MOVE.L	A3,D3
	TST.W	-$0004(A5)
	BEQ.B	L00B5E
	LEA	_metal(A4),A6	;_metal
	MOVE.L	A6,D2
	BRA.B	L00B5F
L00B5E:
	LEA	_wood(A4),A6	;_wood
	MOVE.L	A6,D2
L00B5F:
	SUB.L	D2,D3
	LSR.L	#2,D3
	MOVE.W	D3,-$0002(A5)
	MOVE.W	#$0002,-(A7)
	PEA	-$0002(A5)
	JSR	_xfer
	ADDQ.W	#6,A7
L00B60:
	TST.W	_restore_bool(A4)
	BNE.B	L00B64
	MOVE.W	#$0002,-(A7)
	PEA	-$0004(A5)
	JSR	_xfer
	ADDQ.W	#6,A7
	MOVEA.L	D4,A6
	TST.W	-$0004(A5)
	BEQ.B	L00B61
	MOVE.L	_ws_wand(A4),(A6)	;_ws_wand
	BRA.B	L00B62
L00B61:
	MOVE.L	_ws_staff(A4),(A6)	;_ws_staff
L00B62:
	MOVE.W	#$0002,-(A7)
	PEA	-$0002(A5)
	JSR	_xfer
	ADDQ.W	#6,A7
	TST.W	-$0004(A5)
	BEQ.B	L00B63
	MOVE.W	-$0002(A5),D3
	EXT.L	D3
	ASL.L	#2,D3
	LEA	_metal(A4),A6	;_metal
	MOVE.L	$00(A6,D3.L),(A2)
	BRA.B	L00B64
L00B63:
	MOVE.W	-$0002(A5),D3
	EXT.L	D3
	ASL.L	#2,D3
	LEA	_wood(A4),A6	;_wood
	MOVE.L	$00(A6,D3.L),(A2)
L00B64:
	ADDQ.L	#4,D4
	ADDQ.L	#4,A2
L00B65:
	MOVE.L	A2,D3
	LEA	_ws_made(A4),A6	;_ws_made
	SUB.L	A6,D3
	LSR.L	#2,D3
	CMP.W	#$000E,D3
	BLT.W	L00B59
	MOVEM.L	(A7)+,D4/D5/A2/A3
	UNLK	A5
	RTS

_xfer_proom:
	LINK	A5,#-$0002

	CLR.W	-$0002(A5)
	TST.W	_restore_bool(A4)
	BEQ.B	L00B6A

	MOVEA.L	$0008(A5),A6
	TST.L	(A6)
	BEQ.B	L00B67

;	MOVEA.L	$0008(A5),A6
	LEA	_rooms(A4),A1	;_rooms
	MOVEA.L	(A6),A0
	CMPA.L	A1,A0
	BCS.B	L00B66

;	MOVEA.L	$0008(A5),A6
	LEA	_passages(A4),A1	;_passages
	MOVEA.L	(A6),A0
	CMPA.L	A1,A0
	BCC.B	L00B66

;	MOVEA.L	$0008(A5),A6
	MOVE.L	(A6),D0
	LEA	_rooms(A4),A6	;_rooms
	SUB.L	A6,D0
	MOVEQ	#66,D1
	JSR	_divu
	ADD.W	#$2000,D0
	MOVE.W	D0,-$0002(A5)
	BRA.B	L00B67
L00B66:
	MOVEA.L	$0008(A5),A6
	MOVE.L	(A6),D0
	LEA	_passages(A4),A6	;_passages
	SUB.L	A6,D0
	MOVEQ	#66,D1
	JSR	_divu
	ADD.W	#$1000,D0
	MOVE.W	D0,-$0002(A5)
L00B67:
	TST.W	$000C(A5)
	BEQ.B	L00B68

	MOVEA.L	$0008(A5),A6
	MOVE.W	-$0002(A5),D3
	EXT.L	D3
	MOVE.L	D3,(A6)
	BRA.B	L00B69
L00B68:
	MOVE.W	#$0002,-(A7)
	PEA	-$0002(A5)
	JSR	_xfer
	ADDQ.W	#6,A7
L00B69:
	BRA.B	L00B6F
L00B6A:
	TST.W	$000C(A5)
	BEQ.B	L00B6B

	MOVEA.L	$0008(A5),A6
	MOVE.W	$0002(A6),-$0002(A5)
	BRA.B	L00B6C
L00B6B:
	MOVE.W	#$0002,-(A7)
	PEA	-$0002(A5)
	JSR	_xfer
	ADDQ.W	#6,A7
L00B6C:
	MOVE.W	-$0002(A5),D3
	AND.W	#$1000,D3
	BEQ.B	L00B6D

	MOVEA.L	$0008(A5),A6
	MOVE.W	-$0002(A5),D3
	AND.W	#$0FFF,D3
	MULU.W	#66,D3
	LEA	_passages(A4),A1	;_passages
	ADD.L	A1,D3
	MOVE.L	D3,(A6)
	BRA.B	L00B6F
L00B6D:
	MOVE.W	-$0002(A5),D3
	AND.W	#$2000,D3
	BEQ.B	L00B6E

	MOVEA.L	$0008(A5),A6
	MOVE.W	-$0002(A5),D3
	AND.W	#$0FFF,D3
	MULU.W	#66,D3
	LEA	_rooms(A4),A1	;_rooms
	ADD.L	A1,D3
	MOVE.L	D3,(A6)
	BRA.B	L00B6F
L00B6E:
	MOVEA.L	$0008(A5),A6
	CLR.L	(A6)
L00B6F:
	UNLK	A5
	RTS

_xfer_pthing:
	LINK	A5,#-$0002
	CLR.W	-$0002(A5)
	TST.W	_restore_bool(A4)
	BEQ.B	L00B73

	MOVEA.L	$0008(A5),A6
	TST.L	(A6)
	BEQ.B	L00B70

	MOVEA.L	$0008(A5),A6
	MOVE.L	(A6),D0
	SUB.L	__things(A4),D0	;__things
	MOVEQ	#$32,D1
	JSR	_divu
	ADD.W	#$1000,D0
	MOVE.W	D0,-$0002(A5)
L00B70:
	TST.W	$000C(A5)
	BEQ.B	L00B71

	MOVEA.L	$0008(A5),A6
	MOVE.W	-$0002(A5),D3
	EXT.L	D3
	MOVE.L	D3,(A6)
	BRA.B	L00B72
L00B71:
	MOVE.W	#$0002,-(A7)
	PEA	-$0002(A5)
	JSR	_xfer
	ADDQ.W	#6,A7
L00B72:
	BRA.B	L00B77
L00B73:
	TST.W	$000C(A5)
	BEQ.B	L00B74

	MOVEA.L	$0008(A5),A6
	MOVE.W	$0002(A6),-$0002(A5)
	BRA.B	L00B75
L00B74:
	MOVE.W	#$0002,-(A7)
	PEA	-$0002(A5)
	JSR	_xfer
	ADDQ.W	#6,A7
L00B75:
	MOVE.W	-$0002(A5),D3
	AND.W	#$1000,D3
	BEQ.B	L00B76

	MOVEA.L	$0008(A5),A6
	MOVE.W	-$0002(A5),D3
	AND.W	#$0FFF,D3
	MULU.W	#50,D3
	ADD.L	__things(A4),D3	;__things
	MOVE.L	D3,(A6)
	BRA.B	L00B77
L00B76:
	MOVEA.L	$0008(A5),A6
	CLR.L	(A6)
L00B77:
	UNLK	A5
	RTS

_xfer_things:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2,-(A7)
	MOVEQ	#$00,D4
L00B78:
	MOVE.W	D4,D3
	EXT.L	D3
	ASL.L	#1,D3
	MOVEA.L	__t_alloc(A4),A6	;__t_alloc
	TST.W	$00(A6,D3.L)
	BEQ.B	L00B7B

	MOVE.W	D4,D3
	MULS.W	#50,D3
	MOVEA.L	D3,A2
	ADDA.L	__things(A4),A2	;__things
	TST.W	_restore_bool(A4)
	BNE.B	L00B79

	MOVE.W	#50,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_xfer
	ADDQ.W	#6,A7
L00B79:
	TST.B	$0008(A2)
	BEQ.B	L00B7A

	MOVE.L	A2,-(A7)
	BSR.B	_xfer_monster
	ADDQ.W	#4,A7
	BRA.B	L00B7B
L00B7A:
	MOVE.L	A2,-(A7)
	JSR	_xfer_object(PC)
	ADDQ.W	#4,A7
L00B7B:
	ADDQ.W	#1,D4
	CMP.W	#$0053,D4
	BLT.B	L00B78

	MOVEM.L	(A7)+,D4/A2
	UNLK	A5
	RTS

_xfer_monster:
	LINK	A5,#-$0002
	MOVE.L	A2,-(A7)

	MOVEA.L	$0008(A5),A2
	TST.W	_restore_bool(A4)
	BNE.W	L00B84

	LEA	_player(A4),A6	;_player + 0
	CMPA.L	A6,A2
	BNE.B	L00B7C

	MOVE.L	_hero_damage(A4),$0024(A2)
	BRA.B	L00B7E
L00B7C:
	MOVE.B	$000F(A2),D3
	EXT.W	D3
	CMP.W	#$0046,D3
	BNE.B	L00B7D

	LEA	_f_damage(A4),A6	;_f_damage
	MOVE.L	A6,$0024(A2)
	BRA.B	L00B7E
L00B7D:
	MOVE.B	$000F(A2),D3
	EXT.W	D3
	SUB.W	#$0041,D3	;'A'
	MULU.W	#26,D3
	LEA	_monsters+20(A4),A6
	MOVE.L	$00(A6,D3.L),$0024(A2)
L00B7E:
	MOVE.W	$0014(A2),-$0002(A5)
	MOVE.W	-$0002(A5),D3
	AND.W	#$F000,D3
	MOVEQ	#$00,D0
	MOVE.W	D3,D0
	BRA.B	L00B83
L00B7F:
	LEA	_player+10(A4),A6	;_player + 10
	MOVE.L	A6,$0012(A2)
	BRA.B	L00B84
L00B80:
	MOVE.W	-$0002(A5),D3
	AND.W	#$0FFF,D3
	MULU.W	#$0032,D3
	ADD.L	__things(A4),D3	;__things
	ADD.L	#$0000000C,D3
	MOVE.L	D3,$0012(A2)
	BRA.B	L00B84
L00B81:
	MOVE.W	-$0002(A5),D3
	AND.W	#$0FFF,D3
	MULU.W	#66,D3
	LEA	_rooms+8(A4),A6	;_rooms + 8
	ADD.L	A6,D3
	MOVE.L	D3,$0012(A2)
	BRA.B	L00B84
L00B82:
	MOVE.W	-$0002(A5),D3
	AND.W	#$0FFF,D3
	MULU.W	#66,D3
	LEA	_passages+8(A4),A6
	ADD.L	A6,D3
	MOVE.L	D3,$0012(A2)
	BRA.B	L00B84
L00B83:
	SUB.w	#$1000,D0
	BEQ.B	L00B80
	SUB.w	#$1000,D0
	BEQ.B	L00B81
	SUB.w	#$1000,D0
	BEQ.B	L00B82
	SUB.w	#$1000,D0
	BEQ.B	L00B7F
L00B84:
	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_xfer_pthing
	ADDQ.W	#6,A7
	MOVE.W	#$0001,-(A7)
	PEA	$0004(A2)
	JSR	_xfer_pthing
	ADDQ.W	#6,A7
	MOVE.W	#$0001,-(A7)
	PEA	$002E(A2)
	JSR	_xfer_pthing
	ADDQ.W	#6,A7
	MOVE.W	#$0001,-(A7)
	PEA	$002A(A2)
	JSR	_xfer_proom(PC)
	ADDQ.W	#6,A7
	TST.W	_restore_bool(A4)
	BEQ.W	L00B89

	LEA	_player+10(A4),A6	;_player + 10
	MOVEA.L	$0012(A2),A1
	CMPA.L	A6,A1
	BNE.B	L00B85

	MOVE.L	#$00004000,$0012(A2)
	BRA.W	L00B88
L00B85:
	MOVE.L	$0012(A2),D0
	SUB.L	__things(A4),D0	;__things
	MOVEQ	#$32,D1
	JSR	_divu
	CMP.L	#$00000000,D0
	BLT.B	L00B86

	CMPI.L	#$00000053,D0
	BGE.B	L00B86

	OR.L	#$00001000,D0
	MOVE.L	D0,$0012(A2)
	BRA.B	L00B88
L00B86:
	MOVE.L	$0012(A2),D0
	LEA	_rooms(A4),A6	;_rooms
	SUB.L	A6,D0
	MOVEQ	#66,D1
	JSR	_divu
	CMP.L	#$00000000,D0
	BLT.B	L00B87

	CMPI.L	#$00000009,D0
	BGE.B	L00B87

	OR.L	#$00002000,D0
	MOVE.L	D0,$0012(A2)
	BRA.B	L00B88
L00B87:
	MOVE.L	$0012(A2),D0
	LEA	_passages(A4),A6	;_passages
	SUB.L	A6,D0
	MOVEQ	#66,D1
	JSR	_divu
	CMP.L	#$00000000,D0
	BLT.B	L00B88

	CMPI.L	#$0000000D,D0
	BGE.B	L00B88

	OR.L	#$00003000,D0
	MOVE.L	D0,$0012(A2)
L00B88:
	MOVE.W	#$0032,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_xfer
	ADDQ.W	#6,A7
L00B89:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

_xfer_object:
	LINK	A5,#-$0000
	TST.W	_restore_bool(A4)
	BNE.B	L00B8D

	MOVEA.L	$0008(A5),A6

	TST.L	$0016(A6)
	BNE.B	1$

	MOVE.L	_no_damage(A4),$0016(A6)	;_no_damage
1$
	TST.L	$001A(A6)
	BNE.B	2$

	MOVE.L	_no_damage(A4),$001A(A6)	;_no_damage
2$
	CMPI.W	#$006D,$000A(A6)	;'m' weapon type
	BNE.B	3$

	MOVE.L	A6,A2
	JSR	_iw_setdam
	BRA.B	L00B8D
3$
	CMPI.W	#$002F,$000A(A6)	;'?' scroll
	BNE.B	L00B8D

	MOVE.L	A6,-(A7)
	JSR	_ws_setdam
	ADDQ.W	#4,A7
L00B8D:
	MOVE.W	#$0001,-(A7)
	MOVE.L	$0008(A5),-(A7)
	JSR	_xfer_pthing
	ADDQ.W	#6,A7

	MOVE.W	#$0001,-(A7)
	MOVEA.L	$0008(A5),A6

	PEA	$0004(A6)
	JSR	_xfer_pthing
	ADDQ.W	#6,A7

	TST.W	_restore_bool(A4)
	BEQ.B	3$

	MOVEA.L	$0008(A5),A6

	MOVEA.L	$0016(A6),A1
	CMPA.L	_no_damage(A4),A1	;_no_damage
	BNE.B	1$

	CLR.L	$0016(A6)
1$
	MOVEA.L	$001A(A6),A1
	CMPA.L	_no_damage(A4),A1	;_no_damage
	BNE.B	2$

	CLR.L	$001A(A6)
2$
	MOVE.W	#$0032,-(A7)
	MOVE.L	A6,-(A7)
	JSR	_xfer
	ADDQ.W	#6,A7
3$
	UNLK	A5
	RTS

_iw_setdam:
	MOVE.W	$0020(A2),D3
	MULU.W	#12,D3
	LEA	_w_magic(A4),A6	;_w_magic
;	MOVEA.L	D3,A3
;	ADDA.L	A6,A3
	MOVE.L	$00(A6,D3.w),$0016(A2)	; wield damage
	MOVE.L	$04(A6,D3.w),$001A(A2)	; throw damage
	RTS
