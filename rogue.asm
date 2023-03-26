;$VER: D68k 2.1.3 (11.01.2023)

;Disassembled File  : Rogue
;FileSize in Bytes  : 0109976

; vasmm68k_mot -m68010 -Fhunkexe rogue.asm -o rogue -I include -esc -databss -nosym -opt-allbra

 include 'exec/exec_lib.i'
 include 'dos/dos_lib.i'
 include 'intuition/intuition_lib.i'
 include 'graphics/graphics_lib.i'

 include 'rogue.i'

	SECTION "",CODE       ;000 084512

__Corg:
	JMP	begin

L00000:	dc.b	"wand",0
L00001:	dc.b	"staff",0,0

;/*
; * init_player:
; *  Roll her up
; */

_init_player:
;	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)
	LEA	-$52B2(A4),A6	;_player + 24 (strength)
	LEA	-$6CC2(A4),A1	;_max_stats + 0 (max strength)
	MOVE.L	(A1)+,(A6)+
	MOVE.L	(A1)+,(A6)+
	MOVE.L	(A1)+,(A6)+
	MOVE.L	(A1)+,(A6)+
	MOVE.W	(A1)+,(A6)+

	MOVE.W	#$0514,D0	; we get 1300 food +-10%
	JSR	_spread
	MOVE.W	D0,-$609E(A4)	;_food_left

	CLR.W	d1
	MOVE.W	#$1036,d0	;4150
	MOVE.L	-$52D2(A4),a0	;__things
	JSR	_memset

	CLR.W	d1
	MOVE.W	#$00A6,d0	;166
	MOVE.L	-$52CE(A4),a0	;__t_alloc
	JSR	_memset

	JSR	_new_item
	MOVEA.L	D0,A2
	CLR.W	$0020(A2)		;zero is mace
	MOVE.L	A2,-(A7)
	JSR	_init_weapon
	ADDQ.W	#4,A7
	MOVE.W	#$0001,$0022(A2)	;+1
	MOVE.W	#$0001,$0024(A2)	;+1
	ORI.W	#O_ISKNOW,$0028(A2)
	MOVE.W	#$0001,$001E(A2)	;one mace
	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_add_pack
	ADDQ.W	#6,A7
	MOVE.L	A2,-$5298(A4)	;_cur_weapon
	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_pack_name
	ADDQ.W	#6,A7

	JSR	_new_item
	MOVEA.L	D0,A2
	MOVE.W	#$0002,$0020(A2)	;2 is short bow
	MOVE.L	A2,-(A7)
	JSR	_init_weapon
	ADDQ.W	#4,A7
	MOVE.W	#$0001,$0022(A2)	;+1
	CLR.W	$0024(A2)		;+0
	MOVE.W	#$0001,$001E(A2)	;one weapon
	ORI.W	#O_ISKNOW,$0028(A2)
	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_add_pack
	ADDQ.W	#6,A7

	JSR	_new_item
	MOVEA.L	D0,A2
	MOVE.W	#$0003,$0020(A2)	;arrows
	MOVE.L	A2,-(A7)
	JSR	_init_weapon
	ADDQ.W	#4,A7
	MOVEq	#$000F,D0	;create 25-40 arrows
	JSR	_rnd
	ADD.W	#$0019,D0
	MOVE.W	D0,$001E(A2)
	CLR.W	$0024(A2)	;+0
	CLR.W	$0022(A2)	;+0
	ORI.W	#O_ISKNOW,$0028(A2)
	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_add_pack
	ADDQ.W	#6,A7

	JSR	_new_item
	MOVEA.L	D0,A2
	MOVE.W	#$0062,$000A(A2)	;b = ring mail
	MOVE.W	#$0001,$0020(A2)	;ring mail
	MOVE.W	-$6EFE(A4),D3		;_a_class + 2
	SUBQ.W	#1,D3			;make the ring mail +1
	MOVE.W	D3,$0026(A2)
	ORI.W	#O_ISKNOW,$0028(A2)
	MOVE.W	#$0001,$001E(A2)	;one armor
	CLR.W	$002C(A2)	;group 0
	MOVE.L	A2,-$5294(A4)	;_cur_armor
	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_add_pack
	ADDQ.W	#6,A7

	JSR	_new_item
	MOVEA.L	D0,A2
	MOVE.W	#$003A,$000A(A2)	;':' food
	MOVE.W	#$0001,$001E(A2)	;only one piece
	CLR.W	$0020(A2)
	CLR.W	$002C(A2)	;group 0
	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_add_pack
	ADDQ.W	#6,A7

	MOVEA.L	(A7)+,A2
;	UNLK	A5
	RTS

L00003:	dc.b	"amber",0
L00004:	dc.b	"aquamarine",0
L00005:	dc.b	"black",0
L00006:	dc.b	"blue",0
L00007:	dc.b	"brown",0
L00008:	dc.b	"clear",0
L00009:	dc.b	"crimson",0
L0000A:	dc.b	"cyan",0
L0000B:	dc.b	"ecru",0
L0000C:	dc.b	"gold",0
L0000D:	dc.b	"green",0
L0000E:	dc.b	"grey",0
L0000F:	dc.b	"magenta",0
L00010:	dc.b	"orange",0
L00011:	dc.b	"pink",0
L00012:	dc.b	"plaid",0
L00013:	dc.b	"purple",0
L00014:	dc.b	"red",0
L00015:	dc.b	"silver",0
L00016:	dc.b	"tan",0
L00017:	dc.b	"tangerine",0
L00018:	dc.b	"topaz",0
L00019:	dc.b	"turquoise",0
L0001A:	dc.b	"vermilion",0
L0001B:	dc.b	"violet",0
L0001C:	dc.b	"white",0
L0001D:	dc.b	"yellow",0

_consonants:	dc.b	"bcdfghjklmnpqrstvwxyz",0
_vowels:	dc.b	"aeiou",0

L00020:	dc.b	"agate",0
L00021:	dc.b	"alexandrite",0
L00022:	dc.b	"amethyst",0
L00023:	dc.b	"carnelian",0
L00024:	dc.b	"diamond",0
L00025:	dc.b	"emerald",0
L00026:	dc.b	"germanium",0
L00027:	dc.b	"granite",0
L00028:	dc.b	"garnet",0
L00029:	dc.b	"jade",0
L0002A:	dc.b	"kryptonite",0
L0002B:	dc.b	"lapis lazuli",0
L0002C:	dc.b	"moonstone",0
L0002D:	dc.b	"obsidian",0
L0002E:	dc.b	"onyx",0
L0002F:	dc.b	"opal",0
L00030:	dc.b	"pearl",0
L00031:	dc.b	"peridot",0
L00032:	dc.b	"ruby",0
L00033:	dc.b	"sapphire",0
L00034:	dc.b	"stibotantalite",0
L00035:	dc.b	"tiger eye",0
L00036:	dc.b	"topaz",0
L00037:	dc.b	"turquoise",0
L00038:	dc.b	"taaffeite",0
L00039:	dc.b	"zircon",0

L0003A:	dc.b	"avocado wood",0
L0003B:	dc.b	"balsa",0
L0003C:	dc.b	"bamboo",0
L0003D:	dc.b	"banyan",0
L0003E:	dc.b	"birch",0
L0003F:	dc.b	"cedar",0
L00040:	dc.b	"cherry",0
L00041:	dc.b	"cinnibar",0
L00042:	dc.b	"cypress",0
L00043:	dc.b	"dogwood",0
L00044:	dc.b	"driftwood",0
L00045:	dc.b	"ebony",0
L00046:	dc.b	"elm",0
L00047:	dc.b	"eucalyptus",0
L00048:	dc.b	"fall",0
L00049:	dc.b	"hemlock",0
L0004A:	dc.b	"holly",0
L0004B:	dc.b	"ironwood",0
L0004C:	dc.b	"kukui wood",0
L0004D:	dc.b	"mahogany",0
L0004E:	dc.b	"manzanita",0
L0004F:	dc.b	"maple",0
L00050:	dc.b	"oaken",0
L00051:	dc.b	"persimmon wood",0
L00052:	dc.b	"pecan",0
L00053:	dc.b	"pine",0
L00054:	dc.b	"poplar",0
L00055:	dc.b	"redwood",0
L00056:	dc.b	"rosewood",0
L00057:	dc.b	"spruce",0
L00058:	dc.b	"teak",0
L00059:	dc.b	"walnut",0
L0005A:	dc.b	"zebrawood",0

L0005B:	dc.b	"aluminum",0
L0005C:	dc.b	"beryllium",0
L0005D:	dc.b	"bone",0
L0005E:	dc.b	"brass",0
L0005F:	dc.b	"bronze",0
L00060:	dc.b	"copper",0
L00061:	dc.b	"electrum",0
L00062:	dc.b	"gold",0
L00063:	dc.b	"iron",0
L00064:	dc.b	"lead",0
L00065:	dc.b	"magnesium",0
L00066:	dc.b	"mercury",0
L00067:	dc.b	"nickel",0
L00068:	dc.b	"pewter",0
L00069:	dc.b	"platinum",0
L0006A:	dc.b	"steel",0
L0006B:	dc.b	"silver",0
L0006C:	dc.b	"silicon",0
L0006D:	dc.b	"tin",0
L0006E:	dc.b	"titanium",0
L0006F:	dc.b	"tungsten",0
L00070:	dc.b	"zinc",0

_init_things:
;	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)
	LEA	-$69FC(A4),A6	;_things + 8
	MOVEA.L	A6,A2
L00071:
	MOVE.W	-$0004(A2),D3
	ADD.W	D3,$0004(A2)
	ADDQ.L	#8,A2
	LEA	-$69D4(A4),A6	;_things + 48
	CMPA.L	A6,A2
	BLS.B	L00071

	MOVEA.L	(A7)+,A2
;	UNLK	A5
	RTS

;/*
; * init_colors:
; *  Initialize the potion color scheme for this time
; */

_init_colors:
	LINK	A5,#-$001C
	MOVEM.L	D4/D5,-(A7)

	MOVEQ	#27-1,D4	;-1 so no jump to dbra needed
	LEA	-$001B(A5),A6

1$	CLR.B	(A6)+
	DBRA	D4,1$

	MOVEQ	#$00,D4
L00074:
	MOVEq	#$001B,D0
	JSR	_rnd
	MOVE.W	D0,D5
	LEA	-$001B(A5),A6
	TST.B	$00(A6,D5.W)
	BNE.B	L00074

	LEA	-$001B(A5),A6
	ST	$00(A6,D5.W)
	MOVE.W	D4,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$5290(A4),A6	;_p_colors
	MOVE.W	D5,D2
;	EXT.L	D2
	ASL.w	#2,D2
	LEA	-$7A46(A4),A1	;_rainbow
	MOVE.L	$00(A1,D2.w),$00(A6,D3.w)
	LEA	-$66E7(A4),A6	;_p_know
	CLR.B	$00(A6,D4.W)
	CMP.W	#$0000,D4
	BLE.B	L00075

	MOVE.W	D4,D3
;	EXT.L	D3
	ASL.w	#3,D3
	LEA	-$6E74(A4),A6	;_p_magic + 4

	MOVE.W	D4,D2
	SUBQ.W	#1,D2
;	EXT.L	D2
	ASL.w	#3,D2
	LEA	-$6E74(A4),A1	;_p_magic + 4

	MOVE.W	$00(A1,D2.w),D1
	ADD.W	D1,$00(A6,D3.w)
L00075:
	ADDQ.W	#1,D4
	CMP.W	#$000E,D4
	BLT.B	L00074

	MOVEM.L	(A7)+,D4/D5
	UNLK	A5
	RTS

_rchr:
	LINK	A5,#-$0000

	MOVE.W	$000C(A5),D0
	JSR	_rnd

	MOVEA.L	$0008(A5),A6
	MOVE.B	$00(A6,D0.W),D0
	UNLK	A5
	RTS

_getsyl:
	CLR.B	-$5543(A4)	;zero terminated string

	move.w	#21,-(a7)
	PEA	_consonants
	bsr	_rchr
	ADDQ.W	#6,A7

	MOVE.B	D0,-$5544(A4)

	move.w	#5,-(a7)
	PEA	_vowels
	bsr	_rchr
	ADDQ.W	#6,A7

	MOVE.B	D0,-$5545(A4)

	move.w	#21,-(a7)
	PEA	_consonants
	bsr	_rchr
	ADDQ.W	#6,A7

	LEA	-$5546(A4),A3
	MOVE.B	D0,(A3)

	RTS

;/*
; * init_names:
; *  Generate the names of the various scrolls
; */

_init_names:
	LINK	A5,#-$0006
	MOVEM.L	A2/A3,-(A7)
	CLR.W	-$0004(A5)
L00076:
	MOVEA.L	-$5258(A4),A2	;_prbuf
	TST.B	-$66B2(A4)	;_terse
	BEQ.B	L00077
	MOVEQ	#$03,D3
	BRA.B	L00078
L00077:
	MOVEQ	#$04,D3
L00078:
	MOVE.W	D3,D0
	JSR	_rnd
	ADDQ.W	#2,D0		;3-5 syllable pairs
	MOVE.W	D0,-$0006(A5)
L00079:
	MOVE.W	-$0006(A5),D3
	BEQ.B	L0007E
	SUBQ.W	#1,-$0006(A5)

	MOVEq	#$0002,D0
	JSR	_rnd
	ADDQ.W	#1,D0		;small or long (3/6) syllable
	MOVE.W	D0,-$0002(A5)
L0007A:
	MOVE.W	-$0002(A5),D3
	BEQ.B	L0007D
	SUBQ.W	#1,-$0002(A5)

	bsr	_getsyl		;returns in A3!

;	MOVE.L	A3,A0
;	JSR	_strlenquick
;	EXT.L	D0

; syllable is always 3 chars long, until you change the function!
	moveq	#3,d0

	ADD.L	A2,D0
	MOVEA.L	-$5258(A4),A6	;_prbuf
	ADDA.L	#$00000013,A6
	CMP.L	A6,D0
	BLS.B	L0007B

	CLR.W	-$0006(A5)
	BRA.B	L0007D
L0007B:
	move.B	(A3)+,d3
	BEQ.B	L0007A

	MOVE.B	d3,(A2)+
	BRA.B	L0007B
L0007D:
	MOVE.B	#$20,(A2)+	;' '
	BRA.B	L00079
L0007E:
	CLR.B	-(A2)	; this should eliminate the space at the end

	cmp.b	#$20,-(a2)	;bugfix: no more spaces at end of scroll names
	bne	1$
	clr.b	(a2)

1$	MOVEA.L	-$5258(A4),A6	;_prbuf
	CLR.B	$0014(A6)
	MOVE.W	-$0004(A5),D3

	LEA	-$66F6(A4),A6	;_s_know
	CLR.B	$00(A6,D3.W)	;mark as unknown

	MOVE.L	-$5258(A4),-(A7)	;_prbuf

	MOVE.W	-$0004(A5),D3
	MULU.W	#21,D3
	LEA	-$66A6(A4),A6	;_s_names
	ADD.L	A6,D3
	MOVE.L	D3,-(A7)

	JSR	_strcpy
	ADDQ.W	#8,A7

	CMPI.W	#$0000,-$0004(A5)
	BLE.B	L0007F

	LEA	-$6EEC(A4),A6	;_s_magic + 4
	MOVE.W	-$0004(A5),D3
	MOVE.W	D3,D2
	SUBQ.W	#1,D2

	ASL.w	#3,D3
	ASL.w	#3,D2
	MOVE.W	$00(A6,D2.w),D1
	ADD.W	D1,$00(A6,D3.w)
L0007F:
	ADDQ.W	#1,-$0004(A5)
	CMPI.W	#15,-$0004(A5)	;for 15 scrolls
	BLT.W	L00076

	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

;/*
; * init_stones:
; *  Initialize the ring stone setting scheme for this time
; */

_init_stones:
	LINK	A5,#-$001A
	MOVEM.L	D4/D5,-(A7)

	MOVEQ	#26-1,D4	;-1 so no jump to dbra needed
	LEA	-$001A(A5),A6

1$	CLR.B	(A6)+
	DBRA	d4,1$

	MOVEQ	#$00,D4
L00082:
	MOVEq	#26,D0	;26 different stones
	JSR	_rnd
	MOVE.W	D0,D5
	LEA	-$001A(A5),A6
	TST.B	$00(A6,D5.W)	;look for unused entry
	BNE.B	L00082

;	LEA	-$001A(A5),A6
	ST	$00(A6,D5.W)	;mark as used
	MOVE.W	D4,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$5254(A4),A6	;_r_stones
	MOVE.W	D5,D2
	MULU.W	#$0006,D2
	LEA	-$79D2(A4),A1	;_stones
	MOVE.L	$00(A1,D2.L),$00(A6,D3.w)
	LEA	-$66D9(A4),A6	;_r_know
	CLR.B	$00(A6,D4.W)
	CMP.W	#$0000,D4
	BLE.B	L00083

	LEA	-$6E04(A4),A6	;_r_magic + 4
	MOVE.W	D4,D3
	MOVE.W	D4,D2
	SUBQ.W	#1,D2
	ASL.w	#3,D3
	ASL.w	#3,D2
	MOVE.W	$00(A6,D2.w),D1
	ADD.W	D1,$00(A6,D3.w)
L00083:
	MOVE.W	D4,D3
;	EXT.L	D3
	ASL.w	#3,D3
	LEA	-$6E02(A4),A6	;_r_magic + 6
	MOVE.W	D5,D2
	MULU.W	#6,D2
	LEA	-$79CE(A4),A1	;_stones + 4
	MOVE.W	$00(A1,D2.L),D1
	ADD.W	D1,$00(A6,D3.w)

	ADDQ.W	#1,D4
	CMP.W	#14,D4		;14 different rings
	BLT.W	L00082

	MOVEM.L	(A7)+,D4/D5
	UNLK	A5
	RTS

;/*
; * init_materials:
; *  Initialize the construction materials for wands and staffs
; */

_init_materials:
	LINK	A5,#-$0038
	MOVEM.L	D4/D5/A2,-(A7)

	MOVEQ	#$00,D4
	LEA	-$0037(A5),A6
L00084:
	CLR.B	$00(A6,D4.W)
	ADDQ.W	#1,D4
	CMP.W	#$0021,D4	;'!' potions
	BCS.B	L00084

	MOVEQ	#$00,D4
	LEA	-$0016(A5),A6
L00086:
	CLR.B	$00(A6,D4.W)
	ADDQ.W	#1,D4
	CMP.W	#$0016,D4	;?
	BCS.B	L00086

	MOVEQ	#$00,D4
L00088:
	MOVEq	#$0002,D0
	JSR	_rnd
	TST.W	D0
	BNE.B	L0008A

	MOVEq	#22,D0
	JSR	_rnd
	MOVE.W	D0,D5
	LEA	-$0016(A5),A6
	TST.B	$00(A6,D5.W)
	BNE.B	L00089

	MOVE.W	D4,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$521C(A4),A6	;_ws_type
	MOVE.L	-$7A4E(A4),$00(A6,D3.w)	;_ws_wand
	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$78B2(A4),A6	;_wood
	MOVEA.L	$00(A6,D3.w),A2
	LEA	-$0016(A5),A6
	ST	$00(A6,D5.W)
	BRA.B	L0008C
L00089:
	BRA.B	L0008B
L0008A:
	MOVEq	#33,D0
	JSR	_rnd
	MOVE.W	D0,D5
	LEA	-$0037(A5),A6
	TST.B	$00(A6,D5.W)
	BNE.B	L0008B

	MOVE.W	D4,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$521C(A4),A6	;_ws_type
	MOVE.L	-$7A4A(A4),$00(A6,D3.w)	;_ws_staff
	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$7936(A4),A6	;_wood
	MOVEA.L	$00(A6,D3.w),A2
	LEA	-$0037(A5),A6
	ST	$00(A6,D5.W)
	BRA.B	L0008C
L0008B:
	BRA.W	L00088
L0008C:
	MOVE.W	D4,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$51E4(A4),A6	;_ws_made
	MOVE.L	A2,$00(A6,D3.w)
	LEA	-$66CB(A4),A6	;_ws_know
	CLR.B	$00(A6,D4.W)
	CMP.W	#$0000,D4
	BLE.B	L0008D

	MOVE.W	D4,D3
;	EXT.L	D3
	ASL.w	#3,D3
	LEA	-$6D94(A4),A6	;_ws_magic + 4
	MOVE.W	D4,D2
	SUBQ.W	#1,D2
;	EXT.L	D2
	ASL.w	#3,D2
	LEA	-$6D94(A4),A1	;_ws_magic + 4
	MOVE.W	$00(A1,D2.w),D1
	ADD.W	D1,$00(A6,D3.w)
L0008D:
	ADDQ.W	#1,D4
	CMP.W	#$000E,D4
	BLT.W	L00088

	MOVEM.L	(A7)+,D4/D5/A2
	UNLK	A5
	RTS

_init_ds:
;	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVE.W	#1760,-(A7)
	JSR	_newmem
	ADDQ.W	#2,A7
	MOVE.L	D0,-$5198(A4)	;__flags

	MOVE.W	#$06E0,-(A7)	;1760
	JSR	_newmem
	ADDQ.W	#2,A7
	MOVE.L	D0,-$519C(A4)	;__level

	MOVE.W	#$1036,-(A7)	;4150
	JSR	_newmem
	ADDQ.W	#2,A7
	MOVE.L	D0,-$52D2(A4)	;__things

	MOVE.W	#$00A6,-(A7)
	JSR	_newmem
	ADDQ.W	#2,A7
	MOVE.L	D0,-$52CE(A4)	;__t_alloc

	MOVE.W	#$0050,-(A7)
	JSR	_newmem
	ADDQ.W	#2,A7
	MOVE.L	D0,-$51A8(A4)	;_tbuf

	MOVE.W	#$0080,-(A7)
	JSR	_newmem
	ADDQ.W	#2,A7
	MOVE.L	D0,-$51A4(A4)	;_msgbuf

	MOVE.W	#$0050,-(A7)
	JSR	_newmem
	ADDQ.W	#2,A7
	MOVE.L	D0,-$5258(A4)	_prbuf

	MOVE.W	#$0006,-(A7)
	JSR	_newmem
	ADDQ.W	#2,A7
	MOVE.L	D0,-$51A0(A4)	;_ring_buf

	MOVE.W	-$6CCC(A4),D3	;_nlevels 23
	ADDQ.W	#1,D3
	ASL.W	#2,D3
	MOVE.W	D3,-(A7)
	JSR	_newmem
	ADDQ.W	#2,A7
	MOVE.L	D0,-$51AC(A4)	;_e_levels
	MOVEA.L	D0,A2

;	MOVE.L	#$000000A,(A2)+	; start with 10 xp
;	BRA.B	L0008F

	moveq	#10,D0		; start with 10 xp
	move.w	-$6CCC(A4),D3	;_nlevels 23 (means player ranks)
	subq	#1,d3

1$	MOVE.L	D0,(A2)+
	ASL.L	#1,D0
	DBRA	d3,1$

;L0008E:
;	MOVE.L	-$0004(A2),D3
;	ASL.L	#1,D3
;	MOVE.L	D3,(A2)+
;	ADDQ.L	#4,A2
;L0008F:
;	MOVE.W	-$6CCC(A4),D3	;_nlevels 23
;	ASL.w	#2,D3
;	EXT.L	D3
;	ADD.L	-$51AC(A4),D3	;_e_levels
;	add.l	d0,d3
;	CMPA.L	D3,A2
;	BCS.B	L0008E

	CLR.L	(A2)
	MOVEA.L	(A7)+,A2
;	UNLK	A5
	RTS

;/*
; * do_run:
; *  Start the hero running
; */

_do_run:
;	LINK	A5,#-$0000
	ST	-$66B6(A4)	;_running
	CLR.B	-$66F9(A4)	;_after
	MOVE.B	$0005(A7),-$66A8(A4)	;_runch
;	UNLK	A5
	RTS

;/*
; * do_move:
; *  Check to see that a move is legal.  If it is handle the
; * consequences (fighting, picking up, etc.)
; */

_do_move:
	LINK	A5,#-$0000
	MOVEM.L	D4-D7,-(A7)
	CLR.B	-$66B8(A4)	;_firstmove
	TST.B	-$66AD(A4)	;_bailout
	BEQ.B	L00091

	CLR.B	-$66AD(A4)	;_bailout
	PEA	L000C3(PC)	;"the crack widens ... "
	JSR	_msg
	ADDQ.W	#4,A7
	PEA	L000C4(PC)
	JSR	_descend(PC)
	ADDQ.W	#4,A7
L00090:
	MOVEM.L	(A7)+,D4-D7
	UNLK	A5
	RTS

L00091:
	TST.W	-$60AE(A4)	;_no_move
	BEQ.B	L00092
	SUBQ.W	#1,-$60AE(A4)	;_no_move
	PEA	L000C5(PC)	;"you are still stuck in the bear trap"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L00090
L00092:
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISHUH,D3	;C_ISHUH
	BEQ.B	L00093

	MOVEq	#$0005,D0
	JSR	_rnd
	TST.W	D0
	BEQ.B	L00093

	PEA	-$5194(A4)	;_nh
	PEA	-$52CA(A4)	;_player + 0
	JSR	_rndmove(PC)
	ADDQ.W	#8,A7
	BRA.B	L00094
L00093:
	MOVE.W	-$52BE(A4),D3	;_player + 12
	ADD.W	$0008(A5),D3
	MOVE.W	D3,-$5192(A4)	;_nh + 2
	MOVE.W	-$52C0(A4),D3	;_player + 10
	ADD.W	$000A(A5),D3
	MOVE.W	D3,-$5194(A4)	;_nh
L00094:
	MOVE.W	-$5194(A4),-(A7)	;_nh
	MOVE.W	-$5192(A4),-(A7)	;_nh + 2
	JSR	_offmap
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.W	L0009B

	PEA	-$5194(A4)	;_nh
	PEA	-$52C0(A4)	;_player + 10
	JSR	_diag_ok
	ADDQ.W	#8,A7
	TST.W	D0
	BNE.B	L00095

	CLR.B	-$66F9(A4)	;_after
	CLR.B	-$66B6(A4)	;_running
	BRA.W	L00090
L00095:
	TST.B	-$66B6(A4)	;_running
	BEQ.B	L00096

	PEA	-$5194(A4)	;_nh
	PEA	-$52C0(A4)	;_player + 10
	JSR	__ce
	ADDQ.W	#8,A7
	TST.W	D0
	BEQ.B	L00096

	CLR.B	-$66B6(A4)	;_running
	CLR.B	-$66F9(A4)	;_after
L00096:
	MOVE.W	-$5194(A4),d0	;_nh
	MOVE.W	-$5192(A4),d1	;_nh + 2
	JSR	_INDEXquick

	MOVEA.L	-$5198(A4),A6	;__flags
	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	MOVE.W	D3,D5
	MOVE.W	-$5194(A4),-(A7)	;_nh
	MOVE.W	-$5192(A4),-(A7)	;_nh + 2
	JSR	_winat
	ADDQ.W	#4,A7
	MOVE.B	D0,D4

	JSR	_INDEXplayer

	MOVEA.L	-$519C(A4),A6	;__level
	CMP.B	#$2B,$00(A6,D0.W)	;'+' DOOR
	BNE.B	L00097

	CMP.B	#$2E,D4		;'.' FLOOR
	BNE.B	L00097

	CLR.B	-$66B6(A4)	;_running
L00097:
	MOVE.W	D5,D3
	AND.W	#$0010,D3
	BNE.B	L00098

	CMP.B	#$2E,D4		;'.' FLOOR
	BNE.B	L00098

	MOVE.W	-$5194(A4),d0	;_nh
	MOVE.W	-$5192(A4),d1	;_nh + 2
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.W	D5,D3
	AND.W	#$0007,D3
	ADD.W	#$000E,D3
	MOVE.B	D3,D4
	MOVE.B	D3,$00(A6,D0.W)

	MOVE.W	-$5194(A4),d0	;_nh
	MOVE.W	-$5192(A4),d1	;_nh + 2
	JSR	_INDEXquick

	MOVEA.L	-$5198(A4),A6	;__flags
	ORI.B	#$10,$00(A6,D0.W)
	BRA.B	L00099
L00098:
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISHELD,D3	;C_ISHELD
	BEQ.B	L00099

	CMP.B	#$46,D4		;'F'
	BEQ.B	L00099

	PEA	L000C6(PC)	;"you are being held"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L00090
L00099:
	TST.W	-$6096(A4)	;_fall_level
	BEQ.B	L0009A

	SUBQ.W	#1,-$6096(A4)	;_fall_level
	PEA	L000C7(PC)	;"Wild magic pulls you through the floor"
	JSR	_descend(PC)
	ADDQ.W	#4,A7
	CLR.B	-$66B6(A4)	;_running
	BRA.W	L00090
L0009A:
	MOVE.W	D4,D0
	JSR	_typech

;	EXT.L	D0
	BRA.W	L000C1
L0009B:
	TST.B	-$66B6(A4)	;_running
	BEQ.W	L000B1
	MOVEA.L	-$52A0(A4),A6	;_player + 42 (proom)
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3	;ISGONE?
	BEQ.W	L000B1

	MOVE.W	$000E(A6),D3
	AND.W	#$0004,D3	;ISMAZE?
	BNE.W	L000B1

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BNE.W	L000B1

	MOVE.B	-$66A8(A4),D0	;_runch
	EXT.W	D0
;	EXT.L	D0
	BRA.W	L000AF
L0009C:
	CMPI.W	#$0001,-$52BE(A4)	;_player + 12
	BLE.B	L0009E

	JSR	_INDEXplayer
	SUBQ.W	#1,D0

	MOVEA.L	-$5198(A4),A6	;__flags
;	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	AND.W	#$0040,D3
	BNE.B	L0009D

	JSR	_INDEXplayer
	SUBQ.W	#1,D0

	MOVEA.L	-$519C(A4),A6	;__level
	CMP.B	#$2B,$00(A6,D0.W)	;'+'
	BNE.B	L0009E
L0009D:
	MOVEq	#$0001,D3
	BRA.B	L0009F
L0009E:
	CLR.W	D3
L0009F:
	MOVE.B	D3,D6
	MOVE.W	-$60BC(A4),D3	;_maxrow
	SUBQ.W	#1,D3
	MOVE.W	-$52BE(A4),D2	;_player + 12
	CMP.W	D3,D2
	BGE.B	L000A1

	JSR	_INDEXplayer
	ADDQ.W	#1,D0

	MOVEA.L	-$5198(A4),A6	;__flags
;	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	AND.W	#$0040,D3
	BNE.B	L000A0

	JSR	_INDEXplayer
	ADDQ.W	#1,D0

	MOVEA.L	-$519C(A4),A6	;__level
	CMP.B	#$2B,$00(A6,D0.W)	;'+'
	BNE.B	L000A1
L000A0:
	MOVEq	#$0001,D3
	BRA.B	L000A2
L000A1:
	CLR.W	D3
L000A2:
	MOVE.B	D6,D2
	EOR.B	D3,D2
	BEQ.W	L000B1

	TST.B	D6
	BEQ.B	L000A3

	MOVE.B	#$6B,-$66A8(A4)	;'k', _runch
	MOVE.W	#$FFFF,$0008(A5)
	BRA.B	L000A4
L000A3:
	MOVE.B	#$6A,-$66A8(A4)	;'j',_runch
	MOVE.W	#$0001,$0008(A5)
L000A4:
	CLR.W	$000A(A5)
	BRA.W	L00093
L000A5:
	CMPI.W	#$0001,-$52C0(A4)	;_player + 10
	BLE.B	L000A7

	MOVE.W	-$52C0(A4),D0	;_player + 10
	SUBQ.W	#1,D0
	MOVE.W	-$52BE(A4),d1	;_player + 12
	JSR	_INDEXquick

	MOVEA.L	-$5198(A4),A6	;__flags
	MOVE.B	$00(A6,D0.W),D3
	AND.B	#$40,D3
	BNE.B	L000A6

;	MOVE.W	-$52C0(A4),D0	;_player + 10
;	SUBQ.W	#1,D0
;	MOVE.W	-$52BE(A4),d1	;_player + 12
;	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	CMP.B	#$2B,$00(A6,D0.W)	;'+'
	BNE.B	L000A7
L000A6:
	MOVEq	#$0001,D3
	BRA.B	L000A8
L000A7:
	CLR.W	D3
L000A8:
	MOVE.B	D3,D6
	CMPI.W	#$003A,-$52C0(A4)	;':',_player + 10
	BGE.B	L000AA

	MOVE.W	-$52C0(A4),D0	;_player + 10
	ADDQ.W	#1,D0
	MOVE.W	-$52BE(A4),d1	;_player + 12
	JSR	_INDEXquick

	MOVEA.L	-$5198(A4),A6	;__flags
;	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	AND.W	#$0040,D3
	BNE.B	L000A9

;	MOVE.W	-$52C0(A4),D0	;_player + 10
;	ADDQ.W	#1,D0
;	MOVE.W	-$52BE(A4),d1	;_player + 12
;	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	CMP.B	#$002B,$00(A6,D0.W)
	BNE.B	L000AA
L000A9:
	MOVEq	#$0001,D3
	BRA.B	L000AB
L000AA:
	CLR.W	D3
L000AB:
	MOVE.B	D6,D2
	EOR.B	D3,D2
	BEQ.B	L000B1

	TST.B	D6
	BEQ.B	L000AC

	MOVE.B	#$68,-$66A8(A4)	;'h',_runch
	MOVE.W	#$FFFF,$000A(A5)
	BRA.B	L000AD
L000AC:
	MOVE.B	#$6C,-$66A8(A4)	;'l',_runch
	MOVE.W	#$0001,$000A(A5)
L000AD:
	CLR.W	$0008(A5)
	BRA.W	L00093
L000AE:
	dc.w	L0009C-L000B0	;h
	dc.w	L000B1-L000B0	;i
	dc.w	L000A5-L000B0	;j
	dc.w	L000A5-L000B0	;k
	dc.w	L0009C-L000B0	;l
L000AF:
	SUB.W	#$0068,D0
	CMP.W	#$0005,D0
	BCC.B	L000B1
	ASL.W	#1,D0
	MOVE.W	L000AE(PC,D0.W),D0
L000B0:	JMP	L000B0(PC,D0.W)
L000B1:
	CLR.B	-$66B6(A4)	;_running
	CLR.B	-$66F9(A4)	;_after
	BRA.W	L000C2
L000B2:
	CLR.B	-$66B6(A4)	;_running

	JSR	_INDEXplayer

	MOVEA.L	-$5198(A4),A6	;__flags
	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	AND.W	#$0040,D3
	BEQ.B	L000B3
	PEA	-$5194(A4)	;_nh
	JSR	_enter_room
	ADDQ.W	#4,A7
L000B3:
	BRA.W	L000BC
L000B4:
	PEA	-$5194(A4)	;_nh
	JSR	_be_trapped(PC)
	ADDQ.W	#4,A7
	MOVE.B	D0,D4
;	TST.W	D3
	BEQ.B	L000B5

	CMP.B	#$04,D0
	BNE.B	L000BC
L000B5:
	BRA.W	L00090
L000B7:
	MOVE.W	D5,D3
	AND.W	#$0010,D3
	BNE.B	L000BC

	PEA	-$52C0(A4)	;_player + 10
	JSR	_be_trapped(PC)
	ADDQ.W	#4,A7
L000B8:
	BRA.B	L000BC
L000B9:
	CLR.B	-$66B6(A4)	;_running
	MOVE.W	D4,d0
	JSR	_isupper

	TST.W	D0
	BNE.B	L000BA

	MOVE.W	-$5194(A4),d1	;_nh
	MOVE.W	-$5192(A4),d0	;_nh +2
	JSR	_moatquick

	TST.L	D0
	BEQ.B	L000BB
L000BA:
	CLR.L	-(A7)
	MOVE.L	-$5298(A4),-(A7)	;_cur_weapon
	MOVEQ	#$00,D3
	MOVE.B	D4,D3
	MOVE.W	D3,-(A7)
	PEA	-$5194(A4)	;_nh
	JSR	_fight
	LEA	$000E(A7),A7
	BRA.W	L000C0
L000BB:
	CLR.B	-$66B6(A4)	;_running
	CMP.B	#$25,D4
	BEQ.B	L000BC
	MOVE.B	D4,-$66A9(A4)	;_take
L000BC:
	JSR	_INDEXplayer

	MOVEA.L	-$519C(A4),A6	;__level

	MOVE.B	$00(A6,D0.W),D2
	MOVE.W	-$52C0(A4),d1	;_player + 10
	MOVE.W	-$52BE(A4),d0	;_player + 12
	JSR	_mvaddchquick

	MOVE.W	D5,D3
	AND.W	#$0040,D3
	BEQ.B	L000BE

	MOVE.W	-$6090(A4),d0
	MOVE.W	-$608E(A4),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	CMP.B	#$2B,$00(A6,D0.W)
	BEQ.B	L000BD

;	MOVE.W	-$6090(A4),d0
;	MOVE.W	-$608E(A4),d1
;	JSR	_INDEXquick

	MOVEA.L	-$5198(A4),A6	;__flags
	MOVE.B	$00(A6,D0.W),D3
	AND.B	#$20,D3
	BEQ.B	L000BE
L000BD:
	PEA	-$5194(A4)	;_nh
	JSR	_leave_room
	ADDQ.W	#4,A7
L000BE:
	MOVE.W	D5,D3
	AND.W	#$0020,D3
	BEQ.B	L000BF

	MOVE.W	-$6090(A4),d0
	MOVE.W	-$608E(A4),d1
	JSR	_INDEXquick

	MOVEA.L	-$5198(A4),A6	;__flags
	MOVE.B	$00(A6,D0.W),D3
	AND.B	#$20,D3
	BNE.B	L000BF

	PEA	-$5194(A4)	;_nh
	JSR	_enter_room
	ADDQ.W	#4,A7
L000BF:
	LEA	-$52C0(A4),A6	;_player + 10
	LEA	-$5194(A4),A1	;_nh
	MOVE.L	(A1)+,(A6)+
L000C0:
	BRA.B	L000C2
L000C1:
	SUB.w	#$000E,D0
	BEQ.W	L000B4
	SUB.w	#$0012,D0
	BEQ.W	L0009B
	SUBQ.w	#3,D0
	BEQ.W	L000BC
	SUBQ.w	#8,D0
	BEQ.W	L000B2
	SUBQ.w	#2,D0
	BEQ.W	L0009B
	SUBQ.w	#1,D0
	BEQ.W	L000B7
	SUB.w	#$000E,D0
	BEQ.W	L0009B
	SUBQ.w	#2,D0
	BEQ.W	L0009B
	SUB.w	#$003D,D0
	BEQ.W	L0009B
	SUBQ.w	#1,D0
	BEQ.W	L0009B
	SUBQ.w	#1,D0
	BEQ.W	L0009B
	BRA.W	L000B9
L000C2:
	BRA.W	L00090

L000C3:	dc.b	"the crack widens ... ",0
L000C4:	dc.b	$00
L000C5:	dc.b	"you are still stuck in the bear trap",0
L000C6:	dc.b	"you are being held",0
L000C7:	dc.b	"Wild magic pulls you through the floor",0

;/*
; * door_open:
; *  Called to illuminate a room.  If it is dark, remove anything
; *  that might move.
; */

_door_open:
	LINK	A5,#-$0000
	MOVEM.L	D4-D6/A2,-(A7)

	MOVEA.L	$0008(A5),A6
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3
	BNE.W	L000CD

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BNE.W	L000CD

;	MOVEA.L	$0008(A5),A6
	MOVE.W	$0002(A6),D4
	BRA	L000CC
L000C8:
	MOVEA.L	$0008(A5),A6
	MOVE.W	(A6),D5
	BRA.B	L000CB
L000C9:
	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_winat
	ADDQ.W	#4,A7

	JSR	_isupper

	TST.W	D0
	BEQ.B	L000CA

	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_wake_monster
	ADDQ.W	#4,A7
	MOVEA.L	D0,A2
	CMP.B	#$20,$0011(A2)
	BNE.B	L000CA

	MOVE.L	$0008(A5),-(A7)
	JSR	_is_dark
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.B	L000CA

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BNE.B	L000CA

	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	$00(A6,D0.W),$0011(A2)
L000CA:
	ADDQ.W	#1,D5
L000CB:
	MOVEA.L	$0008(A5),A6
	MOVE.W	(A6),D3
	ADD.W	$0004(A6),D3
	CMP.W	D3,D5
	BLT.B	L000C9

	ADDQ.W	#1,D4
L000CC:
	MOVEA.L	$0008(A5),A6
	MOVE.W	$0002(A6),D3
	ADD.W	$0006(A6),D3
	CMP.W	D3,D4
	BLT.W	L000C8
L000CD:
	MOVEM.L	(A7)+,D4-D6/A2
	UNLK	A5
	RTS

;/*
; * be_trapped:
; *  The guy stepped on a trap.... Make him pay.
; */

_be_trapped:
	LINK	A5,#-$0004
	MOVEM.L	D4/D5/A2,-(A7)
	MOVEA.L	$0008(A5),A2
	CLR.B	-$66B6(A4)	;_running
	CLR.W	-$60A4(A4)	;_count

	MOVE.W	(A2),d0
	MOVE.W	$0002(A2),d1
	JSR	_INDEXquick

	MOVE.W	D0,D5
	MOVEA.L	-$5198(A4),A6	;__flags
	MOVE.B	$00(A6,D5.W),D3
	AND.B	#$07,D3
	MOVE.B	D3,D4
	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	D4,D3
	ADD.B	#$0E,D3
	MOVE.B	D3,$00(A6,D5.W)
	MOVE.B	#$01,-$66B4(A4)	;_was_trapped
	MOVEQ	#$00,D0
	MOVE.B	D4,D0
	BRA.W	L000E0
L000CE:
	PEA	L000E3(PC)	;"you fell into a trap!"
	JSR	_descend(PC)
	ADDQ.W	#4,A7
	BRA.W	L000E2
L000CF:
	MOVEq	#$0003,D0
	JSR	_spread

	ADD.W	D0,-$60AE(A4)	;_no_move
	PEA	L000E4(PC)	;"you are caught in a bear trap"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L000E2
L000D0:
	MOVEq	#$0005,D0
	JSR	_spread

	ADD.W	D0,-$60AC(A4)	;_no_command
	ANDI.W	#~C_ISRUN,-$52B4(A4)	;clear C_ISRUN, _player + 22 (flags)

	LEA	L000E6(PC),a0	;"strange white "
	JSR	_noterse

	MOVE.L	D0,-(A7)
	PEA	L000E5(PC)	;"a %smist envelops you and you fall asleep"
	JSR	_msg
	ADDQ.W	#8,A7
	BRA.W	L000E2
L000D1:
	MOVE.W	#$0001,-(A7)	;arrow is hplus = 1
	MOVE.W	-$52AA(A4),-(A7)	;_player + 32 AC
	MOVE.W	-$52AC(A4),D3	;_player + 30 (rank)
	SUBQ.W	#1,D3
	MOVE.W	D3,-(A7)
	JSR	_swing
	ADDQ.W	#6,A7
	TST.W	D0
	BEQ.B	L000D4

	MOVE.W	#$0006,-(A7)	;1d6
	MOVE.W	#$0001,-(A7)
	JSR	_roll
	ADDQ.W	#4,A7
	SUB.W	D0,-$52A8(A4)	;_player + 34 (hp)
;	CMPI.W	#$0000,-$52A8(A4)	;_player + 34 (hp)
	BGT.B	L000D2

	PEA	L000E7(PC)	;"an arrow killed you"
	JSR	_msg
	ADDQ.W	#4,A7
	MOVE.W	#$0061,-(A7)	;'a' arrow
	JSR	_death
	ADDQ.W	#2,A7
	BRA.B	L000D3
L000D2:
	PEA	L000E8(PC)	;"oh no! An arrow shot you"
	JSR	_msg
	ADDQ.W	#4,A7
L000D3:
	BRA.B	L000D6
L000D4:
	JSR	_new_item
	MOVE.L	D0,-$0004(A5)
;	TST.L	D0
	BEQ.B	L000D5

	MOVEA.L	D0,A6
	MOVE.W	#$0003,$0020(A6)
	MOVE.L	A6,-(A7)
	JSR	_init_weapon
	ADDQ.W	#4,A7
	MOVEA.L	-$0004(A5),A6
	MOVE.W	#$0001,$001E(A6)	;one arrow
	ADDA.L	#$0000000C,A6
	LEA	-$52C0(A4),A1	;_player + 10
	MOVE.L	(A1)+,(A6)+
	CLR.L	-(A7)
	MOVE.L	-$0004(A5),-(A7)
	JSR	_fall
	ADDQ.W	#8,A7
L000D5:
	PEA	L000E9(PC)	;"an arrow shoots past you"
	JSR	_msg
	ADDQ.W	#4,A7
L000D6:
	BRA.W	L000E2
L000D7:
	JSR	_teleport

	MOVEq	#$0012,d2
	MOVE.W	(A2),d1
	MOVE.W	$0002(A2),d0
	JSR	_mvaddchquick

	ADDQ.B	#1,-$66B4(A4)	;_was_trapped
	BRA.W	L000E2
L000D8:
	MOVE.W	#$0001,-(A7)	;hplus = 1
	MOVE.W	-$52AA(A4),-(A7)	;_player + 32 AC
	MOVE.W	-$52AC(A4),D3	;_player + 30 (rank)
	ADDQ.W	#1,D3
	MOVE.W	D3,-(A7)
	JSR	_swing
	ADDQ.W	#6,A7
	TST.W	D0
	BEQ.B	L000DD

	MOVE.W	#$0004,-(A7)	;1d4
	MOVE.W	#$0001,-(A7)
	JSR	_roll
	ADDQ.W	#4,A7
	SUB.W	D0,-$52A8(A4)	;_player + 34 (hp)
	CMPI.W	#$0000,-$52A8(A4)	;_player + 34 (hp)
	BGT.B	L000D9
	PEA	L000EA(PC)	;"a poisoned dart killed you"
	JSR	_msg
	ADDQ.W	#4,A7
	MOVE.W	#$0064,-(A7)	;'d' dart
	JSR	_death
	ADDQ.W	#2,A7
L000D9:
	TST.L	-$5190(A4)	;_cur_ring_1
	BEQ.B	L000DA
	MOVEA.L	-$5190(A4),A6	;_cur_ring_1
	CMPI.W	#R_SUSTSTR,$0020(A6)	;ring of sustain strength
	BEQ.B	L000DC
L000DA:
	TST.L	-$518C(A4)	;_cur_ring_2
	BEQ.B	L000DB
	MOVEA.L	-$518C(A4),A6	;_cur_ring_2
	CMPI.W	#R_SUSTSTR,$0020(A6)	;ring of sustain strength
	BEQ.B	L000DC
L000DB:
	CLR.W	-(A7)
	JSR	_save
	ADDQ.W	#2,A7
	TST.W	D0
	BNE.B	L000DC
	MOVE.W	#$FFFF,-(A7)	; subtract one strength point
	JSR	_chg_str
	ADDQ.W	#2,A7
L000DC:
	PEA	L000EB(PC)	;"a dart just hit you in the shoulder"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L000E2
L000DD:
	PEA	L000EC(PC)	;"a dart whizzes by your ear and vanishes"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L000E2
L000DF:
	dc.w	L000CE-L000E1	;door
	dc.w	L000D1-L000E1	;arrow
	dc.w	L000D0-L000E1	;sleep
	dc.w	L000CF-L000E1	;bear
	dc.w	L000D7-L000E1	;teleport
	dc.w	L000D8-L000E1	;dart
L000E0:
	CMP.w	#$0006,D0
	BCC.B	L000E2
	ASL.w	#1,D0
	MOVE.W	L000DF(PC,D0.W),D0
L000E1:	JMP	L000E1(PC,D0.W)
L000E2:
	JSR	_flush_type
	MOVEQ	#$00,D0
	MOVE.B	D4,D0
	MOVEM.L	(A7)+,D4/D5/A2
	UNLK	A5
	RTS

L000E3:	dc.b	"you fell into a trap!",0
L000E4:	dc.b	"you are caught in a bear trap",0
L000E5:	dc.b	"a %smist envelops you and you fall asleep",0
L000E6:	dc.b	"strange white ",0
L000E7:	dc.b	"an arrow killed you",0
L000E8:	dc.b	"oh no! An arrow shot you",0
L000E9:	dc.b	"an arrow shoots past you",0
L000EA:	dc.b	"a poisoned dart killed you",0
L000EB:	dc.b	"a dart just hit you in the shoulder",0
L000EC:	dc.b	"a dart whizzes by your ear and vanishes",0

_descend:
	LINK	A5,#-$0000

	ADDQ.W	#1,-$60B4(A4)	;_level
	MOVEA.L	$0008(A5),A6
	TST.B	(A6)
	BNE.B	L000ED

	PEA	L000EF(PC)	;" "
	JSR	_msg
	ADDQ.W	#4,A7
L000ED:
	JSR	_new_level
	PEA	L000F0(PC)	;""
	JSR	_msg
	ADDQ.W	#4,A7

	MOVE.L	$0008(A5),-(A7)
	JSR	_msg
	ADDQ.W	#4,A7

	MOVE.W	#VS_FALL,-(A7)
	JSR	_save
	ADDQ.W	#2,A7

	TST.W	D0
	BNE.B	L000EE

	PEA	L000F1(PC)	;"you are damaged by the fall"
	JSR	_msg
	ADDQ.W	#4,A7

	MOVE.W	#$0008,-(A7)	;1d8
	MOVE.W	#$0001,-(A7)
	JSR	_roll
	ADDQ.W	#4,A7

	SUB.W	D0,-$52A8(A4)	;_player + 34 (hp)
	CMPI.W	#$0000,-$52A8(A4)	;_player + 34 (hp)
	BGT.B	L000EE

	MOVE.W	#$0066,-(A7)	;'f' fall
	JSR	_death
	ADDQ.W	#2,A7
L000EE:
	UNLK	A5
	RTS

L000EF:	dc.b	" ",0
L000F0:	dc.b	$00
L000F1:	dc.b	"you are damaged by the fall",0,0

;/*
; * rndmove:
; *  Move in a random direction if the monster/person is confused
; */

_rndmove:
	LINK	A5,#-$0000
	MOVEM.L	D4-D6/A2,-(A7)

	MOVEq	#$0003,D0
	JSR	_rnd

	MOVEA.L	$0008(A5),A6
	ADD.W	$000C(A6),D0

	MOVEA.L	$000C(A5),A6
	SUBQ.W	#1,D0
	MOVE.W	D0,$0002(A6)
	MOVE.W	D0,D5

	MOVEq	#$0003,D0
	JSR	_rnd

	MOVEA.L	$0008(A5),A6
	ADD.W	$000A(A6),D0

	MOVEA.L	$000C(A5),A6
	SUBQ.W	#1,D0
	MOVE.W	D0,(A6)

	MOVE.W	D0,D4
	MOVEA.L	$0008(A5),A6
	CMP.W	$000C(A6),D5
	BNE.B	L000F3

;	MOVEA.L	$0008(A5),A6
	CMP.W	$000A(A6),D4
	BNE.B	L000F3
L000F2:
	MOVEM.L	(A7)+,D4-D6/A2
	UNLK	A5
	RTS

L000F3:
	CMP.W	#$0001,D5
	BLT.B	L000F9

	CMP.W	-$60BC(A4),D5	;_maxrow
	BGE.B	L000F9

	CMP.W	#$0000,D4
	BLT.B	L000F9

	CMP.W	#$003C,D4
	BGE.B	L000F9

	MOVE.L	$000C(A5),-(A7)
	MOVEA.L	$0008(A5),A6
	PEA	$000A(A6)
	JSR	_diag_ok
	ADDQ.W	#8,A7
	TST.W	D0
	BEQ.B	L000F9

	MOVE.W	D4,-(A7)
	MOVE.W	D5,-(A7)
	JSR	_winat
	ADDQ.W	#4,A7

	MOVEQ	#$00,D6
	MOVE.B	D0,D6
	MOVE.W	D6,-(A7)
	JSR	_step_ok
	ADDQ.W	#2,A7
	TST.W	D0
	BEQ.B	L000F9

	CMP.B	#$3F,D6
	BNE.B	L000F8

	MOVEA.L	-$6CB0(A4),A2	;_lvl_obj
	BRA.B	L000F6
L000F4:
	CMP.W	$000E(A2),D5
	BNE.B	L000F5

	CMP.W	$000C(A2),D4
	BEQ.B	L000F7
L000F5:
	MOVEA.L	(A2),A2
L000F6:
	MOVE.L	A2,D3
	BNE.B	L000F4
L000F7:
	MOVE.L	A2,D3
	BEQ.B	L000F8

	CMPI.W	#$0006,$0020(A2)
	BEQ.B	L000F9
L000F8:
	BRA.W	L000F2
L000F9:
	MOVEA.L	$000C(A5),A6
	MOVEA.L	$0008(A5),A1
	ADDA.L	#$0000000A,A1
	MOVE.L	(A1)+,(A6)+
	BRA.W	L000F2

L000FA:	dc.b	"topaz.font",0,0
L000FB:	dc.b	"Rogue: The Adventure game",0

_SetOffset:
;	LINK	A5,#-$0000
;	MOVE.W	$0004(A7),-$77D2(A4)	;_Window2 + 48
;	MOVE.W	$0006(A7),-$77D0(A4)	;_Window2 + 50
;	UNLK	A5
;	RTS

__move:
	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)

	MOVE.W	$0008(A5),D4
	BGT.B	L000FC

	TST.B	-$7064(A4)	;_map_up
	BNE.B	L000FD
L000FC:
	CMP.W	#$0014,D4
	BGE.B	L000FD

	TST.W	$000C(A5)	;_graphics_disabled inside here
	BNE.B	L000FD

	MOVEQ	#10,D3
	BRA.B	L000FE
L000FD:
	MOVEQ	#$08,D3
L000FE:
	MULU.W	$000A(A5),D3
	ADD.W	-$77D0(A4),D3	;_Window2 + 50
	MOVE.W	D3,-$5152(A4)	;_p_col

	MULU.W	#$0009,D4
	ADD.W	-$77D2(A4),D4	;_Window2 + 48
	MOVE.W	D4,-$5154(A4)	;_p_row

	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

_alloc_raster:
	LINK	A5,#-$0000

	moveq	#$0F,D3
	ADD.W	$0008(A5),D3
	ASR.W	#3,D3
	AND.W	#$FFFE,D3
	MULU.W	$000A(A5),D3
;	ADDQ.W	#1,D3
	EXT.L	D3
	MOVE.L	D3,-(A7)
	JSR	_lmalloc2
	ADDQ.W	#4,A7

;	ADDQ.L	#1,D0
;	AND.L	#$FFFFFFFE,D0
	UNLK	A5
	RTS

_standout:
;	LINK	A5,#-$0000
	CLR.B	-$77CE(A4)	;_addch_text + 0
	MOVE.B	#$01,-$77CD(A4)	;_addch_text + 1
;	UNLK	A5
	RTS

_standend:
;	LINK	A5,#-$0000
	MOVE.B	#$01,-$77CE(A4)	;_addch_text + 0
	CLR.B	-$77CD(A4)	;_addch_text + 1
;	UNLK	A5
	RTS

_wtext:
;	LINK	A5,#-$0000

	TST.B	-$7064(A4)	;_map_up
	BEQ.B	L00100

	MOVE.L	-$5150(A4),-$77E4(A4)	;_StdScr
	PEA	-$7802(A4)		;_Window2
	JSR	_OpenWindow
	ADDQ.W	#4,A7
	MOVE.L	D0,-$5144(A4)	;_TextWin
;	TST.L	D0
	BNE.B	L000FF

	PEA	L00101(PC)	;"No Alternate Window"
	JSR	_fatal
	ADDQ.W	#4,A7
L000FF:
	CLR.B	-$7064(A4)	;_map_up
	MOVE.L	-$5144(A4),-$514C(A4)	;_TextWin,_StdWin
	JSR	_intui_sync(PC)
L00100:
;	UNLK	A5
	RTS

L00101:	dc.b	"No Alternate Window",0

_wmap:
;	LINK	A5,#-$0000

	TST.B	-$7064(A4)	;_map_up
	BNE.B	L00102

	TST.L	-$5144(A4)	;_TextWin
	BEQ.B	L00102

	MOVE.L	-$5144(A4),-(A7)	;_TextWin
	JSR	_CloseWindow
	ADDQ.W	#4,A7
	CLR.L	-$5144(A4)	;_TextWin
	ST	-$7064(A4)	;_map_up
	MOVE.L	-$5148(A4),-$514C(A4)	;_RogueWin,_StdWin
	JSR	_intui_sync(PC)
L00102:
;	UNLK	A5
	RTS

__graphch:
	LINK	A5,#-$0000
	MOVEM.L	a2/a6/D4-D7,-(A7)

	MOVE.B	$0009(A5),D4	;in D4 is what we want to paint on the screen

	MOVEQ	#$00,D3
	MOVE.B	D4,D3
	ASL.w	#1,d3
	LEA	-$5140(A4),A1	;_char_data
	move.w	0(a1,d3.w),d1
	BPL	L00104

	MOVE.W	D4,-(A7)
	JSR	__addch
	ADDQ.W	#2,A7
L00103:
	MOVEM.L	(A7)+,D4-D7/a2/a6
	UNLK	A5
	RTS

L00104:
	lea	-$517C(A4),a0	;_chbm = srcbitmap

	moveq	#0,d0

	MOVEA.L	-$514C(A4),A6	;_StdWin
	MOVEA.L	$0032(A6),A1
	move.l	$0004(A1),a1	;dstbitmap
	MOVE.W	-$5152(A4),D2	;_p_col ;dstx
	MOVE.W	-$5154(A4),D3	;_p_row = dsty

	TST.B	-$7064(A4)	;_map_up
	BEQ.B	L00106
	ADD.W	#$000C,D3	;dsty + 12
L00106:

	moveq	#$000A,d4	;sizex
	moveq	#$0009,d5	;sizey

	moveq	#-$40,d6	;we need $c0, minterm
	moveq	#-1,d7		;we need $ff, mask
	sub.l	a2,a2		;tempA

	MOVEA.L	-$5184(A4),A6	;_GfxBase
	JSR	_LVOBltBitMap(A6)

;	CLR.L	-(A7)	;tempA
;	PEA	$00FF	;mask
;	PEA	$00C0	;minterm, is a vanilla copy
;	PEA	$0009	;sizey
;	PEA	$000A	;sizex
;	MOVE.L	D6,-(A7)	;dsty
;	MOVE.W	-$5152(A4),D3	;_p_col
;	EXT.L	D3
;	MOVE.L	D3,-(A7)	;dstx
;	MOVEA.L	-$514C(A4),A6	;_StdWin
;	MOVEA.L	$0032(A6),A1
;	MOVE.L	$0004(A1),-(A7)	;dstbitmap
;	CLR.L	-(A7)		;srcy
;	CLR.L	-(A7)		;srcx
;	PEA	-$517C(A4)	;scrbitmap, _chbm
;	JSR	_BltBitMap
;	LEA	$002C(A7),A7
	BRA.W	L00103

__addch:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2,-(A7)

	LEA	L00107(PC),A2
	MOVE.B	$0009(A5),(A2)
	MOVEA.L	-$514C(A4),A6	;_StdWin
	MOVEA.L	$0032(A6),A1
	MOVE.B	$0018(A1),D4
	MOVE.B	#$01,$0018(A1)
	MOVE.L	A2,-$77C2(A4)	_addch_text + 12

	MOVE.W	-$5152(A4),D0	;_p_col
	MOVE.W	-$5154(A4),D1	;_p_row
	lea	-$77CE(A4),a1	;_addch_text + 0
	MOVE.L	$0032(A6),a0

	MOVEA.L	-$5188(A4),A6	;_IntuitionBase
	JSR	_LVOPrintIText(A6)

;	MOVE.W	-$5154(A4),D3	;_p_row
;	EXT.L	D3
;	MOVE.L	D3,-(A7)
;	MOVE.W	-$5152(A4),D3	;_p_col
;	EXT.L	D3
;	MOVE.L	D3,-(A7)
;	PEA	-$77CE(A4)	;_addch_text + 0
;	MOVE.L	$0032(A6),-(A7)
;	JSR	_PrintIText
;	LEA	$0010(A7),A7

	MOVEA.L	-$514C(A4),A6	;_StdWin
	MOVEA.L	$0032(A6),A1
	MOVE.B	D4,$0018(A1)

	MOVEM.L	(A7)+,D4/A2
	UNLK	A5
	RTS

L00107:
	dc.w	$5800		;"X",0

__clearbot:
;	LINK	A5,#-$0000
	MOVE.W	-$5154(A4),D3	;_p_row
	EXT.L	D3
	MOVEA.L	D3,A6

	PEA	$0006(A6)
	MOVE.W	-$5152(A4),D3	;_p_col
	EXT.L	D3
	MOVE.L	D3,-(A7)
	MOVEA.L	-$514C(A4),A6	;_StdWin
	MOVE.L	$0032(A6),-(A7)
	JSR	_GfxMove
	LEA	$000C(A7),A7

	MOVEA.L	-$514C(A4),A6	;_StdWin
	MOVE.L	$0032(A6),-(A7)
	JSR	_ClearScreen
	ADDQ.W	#4,A7
;	UNLK	A5
	RTS

__clrtoeol:
;	LINK	A5,#-$0000

	MOVE.W	-$5154(A4),D3	;_p_row
	EXT.L	D3
	MOVEA.L	D3,A6
	PEA	$0006(A6)
	MOVE.W	-$5152(A4),D3	;_p_col
	EXT.L	D3
	MOVE.L	D3,-(A7)
	MOVEA.L	-$514C(A4),A6	;_StdWin
	MOVE.L	$0032(A6),-(A7)
	JSR	_GfxMove
	LEA	$000C(A7),A7

	MOVEA.L	-$514C(A4),A6	;_StdWin
	MOVE.L	$0032(A6),-(A7)
	JSR	_ClearEOL
	ADDQ.W	#4,A7

;	UNLK	A5
	RTS

_winit:
	LINK	A5,#-$0002
	MOVEM.L	D4-D6/A2,-(A7)
	PEA	$001D		;version 29
	PEA	L00111(PC)	;"graphics.library"
	JSR	_OpenLibrary
	ADDQ.W	#8,A7
	MOVE.L	D0,-$5184(A4)	;_GfxBase
;	TST.L	-$5184(A4)
	BNE.B	L00108

	PEA	L00112(PC)
	JSR	_fatal
	ADDQ.W	#4,A7
L00108:
	PEA	$001D		;version 29
	PEA	L00113(PC)	;"intuition.library"
	JSR	_OpenLibrary
	ADDQ.W	#8,A7
	MOVE.L	D0,-$5188(A4)	;_IntuitionBase
;	TST.L	-$5188(A4)
	BNE.B	L00109

	PEA	L00114(PC)
	JSR	_fatal
	ADDQ.W	#4,A7
L00109:
;	PEA	$001D		;version 29
;	PEA	L00115(PC)	;"layers.library"
;	JSR	_OpenLibrary
;	ADDQ.W	#8,A7
;	MOVE.L	D0,-$5180(A4)	;_LayersBase
;	TST.L	-$5180(A4)
;	BNE.B	L0010A

;	PEA	L00116(PC)	;"No layers"
;	JSR	_fatal
;	ADDQ.W	#4,A7

;L0010A:
	CLR.W	-(A7)
	PEA	L00117(PC)	;"rogue.char"
	JSR	_open
	ADDQ.W	#6,A7
	MOVE.W	D0,D5		;char filehd
;	CMP.W	#$0000,D0
	BGE.B	L0010B2

	PEA	L00118(PC)	;"No rogue.char file"
	JSR	_db_print
	ADDQ.W	#4,A7
	ST	-$7063(A4)	;_graphics_disabled
	BRA	readCharEnd

L0010B2:
	LEA	-$5140(A4),A0	;_char_data
	moveq	#-1,d1
	move.w	#255,d0
	jsr	_memset

	MOVE.W	#2688,-(A7)	;4 * 72 * 9(pixel) + some spare
	MOVE.W	#$000A,-(A7)
	JSR	_alloc_raster(PC)
	ADDQ.W	#4,A7

	tst.l	D0
	BNE.B	1$

	PEA	L00119(PC)	;"No memory for character data"
	JSR	_fatal
	ADDQ.W	#4,A7

1$	move.l	#1344,d1	;72 * 18 + some spare
	lea	-$5174(A4),A3	;_chbm + 8 (where the planes begin)
	move.l	D0,(A3)+
	add.l	d1,d0
	move.l	D0,(A3)+
	add.l	d1,d0
	move.l	D0,(A3)+
	add.l	d1,d0
	move.l	D0,(A3)

	moveq	#0,d4
L0010B:
	MOVE.W	#$0002,-(A7)	;read two bytes
	PEA	-$0002(A5)
	MOVE.W	D5,-(A7)	;char filehd
	JSR	_read
	ADDQ.W	#8,A7

	CMP.W	#$0002,D0	;did we read two byte?
	BNE.B	L0010E

	MOVEQ	#$00,D6		;start with plane 0
	MOVE.W	-$0002(A5),D3

	LEA	-$5140(A4),A6	;_char_data
	asl.w	#1,d3

	move.l	d4,d2
	mulu	#9,d2		;calculate position in bitmap, then don't need to do it later
	MOVE.w	D2,$00(A6,D3.w)	;remember which character was read at which position
L0010D:
	;calculate the position to read the bitmap to

	LEA	-$5174(A4),A6	;_chbm + 8 (where the planes begin)
	add.l	d6,a6
	move.l	(a6),a6		;get one of the four planes depending on D6

	move.l	d4,d3
	mulu	#18,d3
	add.l	d3,a6

	MOVE.W	#18,-(A7)	;size
	MOVE.L	A6,-(A7)
	MOVE.W	D5,-(A7)	;char filehd
	JSR	_read
	ADDQ.W	#8,A7

	ADDQ.W	#4,D6
	CMP.W	#16,D6
	BLT.B	L0010D

	addq.l	#1,d4

	BRA.W	L0010B
L0010E:
	MOVE.W	D5,-(A7)
	JSR	_close
	ADDQ.W	#2,A7
readCharEnd:

	PEA	-$7852(A4)	;_NewScreen
	JSR	_OpenScreen
	ADDQ.W	#4,A7

	MOVE.L	D0,-$5150(A4)	;_StdScr
;	TST.L	D0
	BNE.B	L0010F

	PEA	L0011A(PC)	;"No Screen"
	JSR	_fatal
	ADDQ.W	#4,A7
L0010F:
	PEA	9*72		;height
	PEA	10		;width
	PEA	$0004		;number of planes (bits per color)
	PEA	-$517C(A4)	;_chbm
	JSR	_InitBitMap
	LEA	$0010(A7),A7

	MOVE.L	-$5150(A4),-$7814(A4)	;_StdScr
	PEA	-$7832(A4)		;_Window1
	JSR	_OpenWindow
	ADDQ.W	#4,A7

	MOVE.L	D0,-$5148(A4)	;_RogueWin
	MOVE.L	D0,-$514C(A4)	;_StdWin
;	TST.L	D0
	BNE.B	L00110

	PEA	L0011B(PC)
	JSR	_fatal
	ADDQ.W	#4,A7
L00110:
	JSR	_InstallMenus
	JSR	_wmap(PC)
	MOVEM.L	(A7)+,D4-D6/A2
	UNLK	A5
	RTS

L00111:	dc.b	"graphics.library",0
L00112:	dc.b	"No graphics",0
L00113:	dc.b	"intuition.library",0
L00114:	dc.b	"No intuition",0
;L00115:	dc.b	"layers.library",0
;L00116:	dc.b	"No layers",0
L00117:	dc.b	"rogue.char",0
L00118:	dc.b	"No rogue.char file",10,0
L00119:	dc.b	"No memory for character data",0
L0011A:	dc.b	"No Screen",0
L0011B:	dc.b	"No Window",0

_wclose:
;	LINK	A5,#-$0000
	MOVEM.L	D4/D5,-(A7)
	TST.L	-$5150(A4)	;_StdScr
	BEQ.B	L0011C
	JSR	_black_out
L0011C:
	TST.L	-$5144(A4)	;_TextWin
	BEQ.B	L0011D
	MOVE.L	-$5144(A4),-(A7)	;_TextWin
	JSR	_ClearMenuStrip
	ADDQ.W	#4,A7
	MOVE.L	-$5144(A4),-(A7)	;_TextWin
	JSR	_CloseWindow
	ADDQ.W	#4,A7
L0011D:
	TST.L	-$5148(A4)	;_RogueWin
	BEQ.B	L0011E

	MOVE.L	-$5148(A4),-(A7)	;_RogueWin
	JSR	_ClearMenuStrip
	ADDQ.W	#4,A7

	MOVE.L	-$5148(A4),-(A7)	;_RogueWin
	JSR	_CloseWindow
	ADDQ.W	#4,A7
L0011E:
	TST.L	-$5150(A4)	;_StdScr
	BEQ.B	L0011F
	MOVE.L	-$5150(A4),-(A7)	;_StdScr
	JSR	_CloseScreen
	ADDQ.W	#4,A7
L0011F:
	TST.L	-$5184(A4)	;_GfxBase
	BEQ.B	L00120
	MOVE.L	-$5184(A4),-(A7)	;_GfxBase
	JSR	_CloseLibrary
	ADDQ.W	#4,A7
L00120:
	TST.L	-$5188(A4)	;_IntuitionBase
	BEQ.B	L00121
	MOVE.L	-$5188(A4),-(A7)	;_IntuitionBase
	JSR	_CloseLibrary
	ADDQ.W	#4,A7
L00121:
;	TST.L	-$5180(A4)	;_LayersBase
;	BEQ.B	L00122
;	MOVE.L	-$5180(A4),-(A7)	;_LayersBase
;	JSR	_CloseLibrary
;	ADDQ.W	#4,A7
;L00122:
	MOVEM.L	(A7)+,D4/D5
	UNLK	A5
	RTS

_ScreenTitle:
	LINK	A5,#-$0000

	MOVE.W	#$004A,-(A7)
	MOVE.L	$0008(A5),-(A7)
	PEA	-$5542(A4)
	JSR	_strncpy
	LEA	$000A(A7),A7

	PEA	-$5542(A4)
	PEA	-$1
	MOVE.L	-$5148(A4),-(A7)	;_RogueWin
	JSR	_SetWindowTitles
	LEA	$000C(A7),A7

	UNLK	A5
	RTS

_invert_row:
	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)
	MOVE.W	$0008(A5),D3
	MULU.W	#$0009,D3
	SUBQ.W	#1,D3
	EXT.L	D3
	MOVE.L	D3,D4
	PEA	$0002
	MOVEA.L	-$514C(A4),A6	;_StdWin
	MOVE.L	$0032(A6),-(A7)
	JSR	_SetDrMd
	ADDQ.W	#8,A7
	PEA	$000F
	MOVEA.L	-$514C(A4),A6	;_StdWin
	MOVE.L	$0032(A6),-(A7)
	JSR	_SetAPen
	ADDQ.W	#8,A7
	MOVEA.L	D4,A6
	PEA	$0009(A6)
	PEA	$027F
	MOVE.L	D4,-(A7)
	CLR.L	-(A7)
	MOVEA.L	-$514C(A4),A6	;_StdWin
	MOVE.L	$0032(A6),-(A7)
	JSR	_RectFill
	LEA	$0014(A7),A7
	CLR.L	-(A7)
	MOVEA.L	-$514C(A4),A6	;_StdWin
	MOVE.L	$0032(A6),-(A7)
	JSR	_SetDrMd
	ADDQ.W	#8,A7
	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

__zapstr:
	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)

	MOVEA.L	-$514C(A4),A6	;_StdWin
	MOVEA.L	$0032(A6),A1
	MOVE.B	$0018(A1),D4
	MOVE.B	#$01,$0018(A1)
	MOVE.L	$0008(A5),-$77C2(A4)	;_addch_text + 12

	MOVE.W	-$5152(A4),D0	;_p_col
	MOVE.W	-$5154(A4),D1	;_p_row
	lea	-$77CE(A4),a1	;_addch_text + 0
	MOVE.L	$0032(A6),a0

	MOVEA.L	-$5188(A4),A6	;_IntuitionBase
	JSR	_LVOPrintIText(A6)

;	MOVE.W	-$5154(A4),D3	;_p_row
;	EXT.L	D3
;	MOVE.L	D3,-(A7)
;	MOVE.W	-$5152(A4),D3	;_p_col
;	EXT.L	D3
;	MOVE.L	D3,-(A7)
;	PEA	-$77CE(A4)
;	MOVEA.L	-$514C(A4),A6	;_StdWin
;	MOVE.L	$0032(A6),-(A7)
;	JSR	_PrintIText
;	LEA	$0010(A7),A7

	MOVEA.L	-$514C(A4),A6	;_StdWin
	MOVEA.L	$0032(A6),A1
	MOVE.B	D4,$0018(A1)

	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

_intui_sync:
	LINK	A5,#-$000C
	PEA	-$0008(A5)
	PEA	-$0004(A5)
	JSR	_CurrentTime
	ADDQ.W	#8,A7
L00123:
	PEA	-$000C(A5)
	PEA	-$0004(A5)
	JSR	_CurrentTime
	ADDQ.W	#8,A7
	MOVE.L	-$000C(A5),D3
	CMP.L	-$0008(A5),D3
	BEQ.B	L00123
	UNLK	A5
	RTS

_OffVerify:
	LINK	A5,#-$0008
	JSR	_Forbid
	TST.L	-$514C(A4)	;_StdWin
	BEQ.B	L00127
	MOVE.L	-$7828(A4),D3
	AND.L	#$FFFFDFFF,D3
	MOVE.L	D3,-(A7)
	MOVE.L	-$514C(A4),-(A7)	;_StdWin
	JSR	_ModifyIDCMP
	ADDQ.W	#8,A7
	MOVEA.L	-$514C(A4),A6	;_StdWin
	MOVEA.L	$0056(A6),A1
	MOVE.L	$0014(A1),-$0004(A5)
	BRA.B	L00126
L00124:
	MOVEA.L	-$0004(A5),A6
	CMPI.L	#$00002000,$0014(A6)
	BNE.B	L00125
	MOVEA.L	-$0004(A5),A6
	MOVE.W	#$0002,$0018(A6)
	MOVE.L	-$0004(A5),-(A7)
	JSR	_Remove
	ADDQ.W	#4,A7
	MOVE.L	-$0004(A5),-(A7)
	JSR	_ReplyMsg
	ADDQ.W	#4,A7
L00125:
	MOVE.L	-$0008(A5),-$0004(A5)
L00126:
	MOVEA.L	-$0004(A5),A6
	MOVE.L	(A6),-$0008(A5)
	TST.L	-$0008(A5)
	BNE.B	L00124
L00127:
	JSR	_Permit
	UNLK	A5
	RTS

_OnVerify:
	LINK	A5,#-$0000
	TST.L	-$514C(A4)	;_StdWin
	BEQ.B	L00128
	MOVE.L	-$7828(A4),-(A7)
	MOVE.L	-$514C(A4),-(A7)	;_StdWin
	JSR	_ModifyIDCMP
	ADDQ.W	#8,A7
L00128:
	UNLK	A5
	RTS

_WBprint:
	LINK	A5,#-$0000
	JSR	_WBenchToFront
	MOVE.W	$0012(A5),-(A7)
	MOVE.W	$0010(A5),-(A7)
	MOVE.W	$000E(A5),-(A7)
	MOVE.W	$000C(A5),-(A7)
	MOVE.L	$0008(A5),-(A7)
	JSR	_printf
	LEA	$000C(A7),A7
	UNLK	A5
	RTS

;/*
; * wear:
; *  The player wants to wear something, so let him/her put it on.
; */

_wear:
	LINK	A5,#-$0000
	MOVEM.L	A2/A3,-(A7)
	MOVEA.L	$0008(A5),A2
	TST.L	-$5294(A4)	;_cur_armor
	BEQ.B	L0012A

	LEA	L0012F(PC),a0	;".  You'll have to take it off first"
	JSR	_noterse

	MOVE.L	D0,-(A7)
	PEA	L0012E(PC)	;"you are already wearing some%s."
	JSR	_msg
	ADDQ.W	#8,A7
	CLR.B	-$66F9(A4)	;_after
L00129:
	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

L0012A:
	MOVE.L	A2,D3
	BNE.B	L0012B
	MOVE.W	#$0061,-(A7)
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
	CMP.W	#$0061,D0
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
	ORI.W	#$0002,$0028(A2)
	MOVE.L	A2,-$5294(A4)	;_cur_armor
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
	MOVEA.L	-$5294(A4),A2	;_cur_armor
	MOVE.L	A2,D3
	BNE.B	L00134
	CLR.B	-$66F9(A4)	;_after
	PEA	L00136(PC)	;"you aren't wearing any armor"
	JSR	_msg
	ADDQ.W	#4,A7
L00133:
	MOVEA.L	(A7)+,A2
;	UNLK	A5
	RTS

L00134:
	MOVE.L	-$5294(A4),-(A7)	;_cur_armor
	JSR	_can_drop(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.B	L00135
	BRA.B	L00133
L00135:
	CLR.L	-$5294(A4)	;_cur_armor
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

_ifterse:
	LINK	A5,#-$0000

	MOVE.W	$0018(A5),-(A7)
	MOVE.W	$0016(A5),-(A7)
	MOVE.W	$0014(A5),-(A7)
	MOVE.W	$0012(A5),-(A7)
	MOVE.W	$0010(A5),-(A7)

	TST.B	-$66AB(A4)	;_expert
	BEQ.B	L00138

	MOVE.L	$0008(A5),-(A7)	; expert string
	BRA.B	L00139

L00138:
	MOVE.L	$000C(A5),-(A7)	;terse string

L00139:
	BSR.B	_msg
	LEA	$000E(A7),A7
	UNLK	A5
	RTS

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
	CLR.W	-$60B0(A4)	;_mpos
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
	TST.B	-$66B5(A4)	;_save_msg
	BEQ.B	L0013C
	MOVE.L	-$51A4(A4),-(A7)	;_msgbuf
	PEA	-$4940(A4)	;_huh
	JSR	_strcpy
	ADDQ.W	#8,A7
L0013C:
	TST.W	-$60B0(A4)	;_mpos
	BEQ.B	L0013D
	CLR.L	-(A7)
	JSR	_look
	ADDQ.W	#4,A7

	MOVE.W	-$60B0(A4),d1	;_mpos
	moveq	#0,d0
	JSR	_movequick

	PEA	L0013F(PC)	;"More"
	BSR.B	_more
	ADDQ.W	#4,A7
L0013D:
	MOVEA.L	-$51A4(A4),A6	;_msgbuf
	MOVE.B	(A6),D0
	JSR	_islower

	TST.W	D0
	BEQ.B	L0013E
	MOVEA.L	-$51A4(A4),A6	;_msgbuf
	MOVE.B	$0001(A6),D3
	EXT.W	D3
	CMP.W	#$0029,D3
	BEQ.B	L0013E
	MOVEA.L	-$51A4(A4),A6	;_msgbuf
	MOVE.L	A6,-(A7)
	MOVEA.L	-$51A4(A4),A6	;_msgbuf
	MOVE.B	(A6),D3
	MOVE.W	D3,-(A7)
	JSR	_toupper
	ADDQ.W	#2,A7
	MOVEA.L	(A7)+,A6
	MOVE.B	D0,(A6)
L0013E:
	MOVE.L	-$51A4(A4),-(A7)	;_msgbuf
	CLR.W	-(A7)
	JSR	_putmsg(PC)
	ADDQ.W	#6,A7
	MOVE.W	-$77BA(A4),-$60B0(A4)	;_mpos
	CLR.W	-$77BA(A4)
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
	MOVE.W	-$77BA(A4),D3		;_addch_text + $14
	EXT.L	D3
	ADD.L	-$51A4(A4),D3		;_msgbuf
	MOVE.L	D3,-(A7)
	JSR	_sprintf
	LEA	$001C(A7),A7

	MOVE.L	-$51A4(A4),A0	;_msgbuf
	JSR	_strlenquick

	MOVE.W	D0,-$77BA(A4)		;_addch_text + $14

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
	MOVE.W	D0,-$77BA(A4)
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

	TST.B	-$66FB(A4)	;_new_stats
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
	TST.B	-$66FB(A4)	;_new_stats
	BNE.B	L0015F

	MOVE.W	-$54E8(A4),D3
	CMP.W	-$52B2(A4),D3	;_player + 24 (strength)
	BNE.B	L0015F

	MOVE.W	-$54E6(A4),D3
	CMP.W	-$6CC2(A4),D3	;_max_stats + 0 (max strength)
	BEQ.B	L00160
L0015F:
	MOVEq	#$000F,d1
	MOVEq	#$0014,d0
	JSR	_movequick
	MOVE.W	-$6CC2(A4),-(A7)	;_max_stats + 0 (max strength)
	MOVE.W	-$52B2(A4),-(A7)	;_player + 24 (strength)
	PEA	L0016A(PC)	;"Str:%.3d(%.3d)"
	JSR	_printw
	ADDQ.W	#8,A7
	MOVE.W	-$52B2(A4),-$54E8(A4)	;_player + 24 (strength)
	MOVE.W	-$6CC2(A4),-$54E6(A4)	;_max_stats + 0 (max strength),
L00160:
	TST.B	-$66FB(A4)	;_new_stats
	BNE.B	L00161

	MOVE.W	-$54E4(A4),D3	;last printed purse
	CMP.W	-$60B2(A4),D3	;_purse
	BEQ.B	L00162
L00161:
	MOVEq	#$001C,d1
	MOVEq	#$0014,d0
	JSR	_movequick

	MOVE.W	-$60B2(A4),-(A7)	;_purse
	PEA	L0016B(PC)	;"Gold:%-5.5u"
	JSR	_printw
	ADDQ.W	#6,A7
	MOVE.W	-$60B2(A4),-$54E4(A4)	;_purse, last printed purse
L00162:
	TST.L	-$5294(A4)	;_cur_armor
	BEQ.B	L00163

	MOVEA.L	-$5294(A4),A6	;_cur_armor
	MOVE.W	$0026(A6),D4
	BRA.B	L00164
L00163:
	MOVE.W	-$52AA(A4),D4	;_player + 32 (AC)
L00164:
	TST.L	-$5190(A4)	;_cur_ring_1
	BEQ.B	L00165

	MOVEA.L	-$5190(A4),A6	;_cur_ring_1
	CMP.W	#R_PROTECT,$0020(A6)
	BNE.B	L00165

	SUB.W	$0026(A6),D4
L00165:
	TST.L	-$518C(A4)	;_cur_ring_2
	BEQ.B	L00166

	MOVEA.L	-$518C(A4),A6	;_cur_ring_2
	CMP.W	#R_PROTECT,$0020(A6)
	BNE.B	L00166

	SUB.W	$0026(A6),D4
L00166:
	TST.B	-$66FB(A4)	;_new_stats
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
	MOVEq	#52,d1
	MOVEq	#20,d0
	JSR	_movequick

	MOVE.L	-$52B0(A4),-(A7)	;_player + 26 (EXP)
	PEA	L0016Cb(PC)	;"XP:%d"
	JSR	_printw
	ADDQ.W	#8,A7

	CLR.B	-$66FB(A4)	;_new_stats

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
	BNE.B	L0016F
L0016D:
	JSR	_readchar
	CMP.B	#$0A,D0
	BEQ.B	L0016E
	CMP.B	#$0D,D0
	BEQ.B	L0016E
	BRA.B	L0016D
L0016E:
	BRA.B	L00170
L0016F:
	JSR	_readchar
	MOVE.B	$0009(A5),D3
	CMP.B	D3,D0
	BEQ.B	L00170
	BRA.B	L0016F
L00170:
	UNLK	A5
	RTS

;/*
; * show_win:
; *  Function used to display a window and wait before returning
; */

_show_win:
	LINK	A5,#-$0000

	MOVE.L	$0008(A5),-(A7)
	CLR.W	-(A7)
	CLR.W	-(A7)
	JSR	_mvaddstr
	ADDQ.W	#8,A7

	MOVE.W	-$52C0(A4),d1	;_player + 10
	MOVE.W	-$52BE(A4),d0	;_player + 12
	JSR	_movequick

	MOVE.W	#$0020,-(A7)	; SPACE
	BSR.B	_wait_for
	ADDQ.W	#2,A7

	UNLK	A5
	RTS

_getinfo:
	LINK	A5,#-$0006	;changed from -$A6 to -$06, cant see anything using more than 6 bytes
	MOVEM.L	D4/A2,-(A7)

	CLR.W	-$0002(A5)
	MOVE.W	#$0001,-$0006(A5)
	MOVEA.L	$0008(A5),A2
	MOVEA.L	$0008(A5),A6
	CLR.B	(A6)
	MOVE.W	#$0001,-(A7)
	JSR	_cursor(PC)
	ADDQ.W	#2,A7

	MOVE.W	D0,-$0004(A5)
L00171:
	CMPI.W	#$0001,-$0006(A5)
	BNE.W	L0017B

	MOVE.W	#$005F,-(A7)	;'_' used as cursor
	JSR	__addch
	ADDQ.W	#2,A7

	JSR	_readchar
	MOVE.B	D0,D4

	MOVE.W	#$0020,-(A7)	;' '
	JSR	__addch
	ADDQ.W	#2,A7

	MOVE.B	D4,D0
	EXT.W	D0
;	EXT.L	D0
	BRA.W	L00179
L00172:
	MOVEA.L	$0008(A5),A6
	CMPA.L	A2,A6
	BEQ.B	1$

	JSR	_backspace(PC)
	SUBQ.W	#1,-$0002(A5)
	SUBQ.L	#1,$0008(A5)
	BRA.B	L00172
1$
	MOVEA.L	$0008(A5),A6
	MOVEQ	#$1B,D3		;escape
	MOVE.B	D3,(A6)
	MOVE.W	D3,-$0006(A5)
	MOVE.W	-$0004(A5),-(A7)
	JSR	_cursor(PC)
	ADDQ.W	#2,A7

	BRA.B	L0017A
L00174:
	MOVEA.L	$0008(A5),A6
	CMPA.L	A2,A6
	BEQ.B	2$

	JSR	_backspace(PC)
	SUBQ.W	#1,-$0002(A5)
	SUBQ.L	#1,$0008(A5)
2$
	BRA.B	L0017A
L00176:
	MOVE.W	-$0002(A5),D3
	CMP.W	$000C(A5),D3
	BLT.B	3$

	JSR	_beep(PC)
	BRA.B	L0017A
3$
	ADDQ.W	#1,-$0002(A5)
	MOVE.B	D4,D3
	EXT.W	D3
	MOVE.W	D3,-(A7)
	JSR	_addch
	ADDQ.W	#2,A7

	MOVEA.L	$0008(A5),A6
	ADDQ.L	#1,$0008(A5)
	MOVE.B	D4,(A6)
	MOVE.B	D4,D3
;	EXT.W	D3
	AND.W	#$0080,D3
	BEQ.B	L0017A
L00178:
	MOVEA.L	$0008(A5),A6
	CLR.B	(A6)
	MOVE.W	-$0004(A5),-(A7)
	JSR	_cursor(PC)
	ADDQ.W	#2,A7

	MOVE.B	D4,D3
	EXT.W	D3
	MOVE.W	D3,-$0006(A5)
	BRA.B	L0017A
L00179:
	SUBQ.w	#8,D0
	BEQ.B	L00174
	SUBQ.w	#2,D0
	BEQ.B	L00178
	SUBQ.w	#3,D0
	BEQ.B	L00178
	SUB.w	#$000E,D0
	BEQ.W	L00172
	BRA.B	L00176
L0017A:
	BRA.W	L00171
L0017B:
	MOVE.W	-$0006(A5),D0

	MOVEM.L	(A7)+,D4/A2
	UNLK	A5
	RTS

_backspace:
	LINK	A5,#-$0004

	PEA	-$0004(A5)
	PEA	-$0002(A5)
	JSR	_getrc
	ADDQ.W	#8,A7

	SUBQ.W	#1,-$0004(A5)
;	CMPI.W	#$0000,-$0004(A5)
	BGE.B	L0017C

	CLR.W	-$0004(A5)
L0017C:
	MOVEq	#$0020,d2
	MOVE.W	-$0004(A5),d1
	MOVE.W	-$0002(A5),d0
	JSR	_mvaddchquick

	MOVE.W	-$0004(A5),d1
	MOVE.W	-$0002(A5),d0
	JSR	_movequick

	UNLK	A5
	RTS

_noterse:
	TST.B	-$66B2(A4)	;_terse
	BNE.B	1$

	TST.B	-$66AB(A4)	;_expert
	BEQ.B	2$

1$	LEA	-$69CC(A4),A0	;_nullstr
2$	MOVE.L	A0,D0
	RTS

;/*
; * new_level:
; *  Dig and draw a new level
; */

_new_level:
	LINK	A5,#-$0004
	MOVEM.L	D4-D6/A2/A3,-(A7)
	JSR	_NewRank(PC)
	ANDI.W	#~C_ISHELD,-$52B4(A4)	;clear C_ISHELD ($80) _player + 22 (flags)
	CLR.B	-$66FA(A4)	;_no_more_fears
	MOVE.W	-$60B4(A4),D3	;_level
	CMP.W	-$60BA(A4),D3	;_ntraps
	BLE.B	L00183

	MOVE.W	-$60B4(A4),-$60BA(A4)	;_level,_ntraps
L00183:
	MOVEq	#$0020,d1
	MOVE.W	#1760,d0
	MOVE.L	-$519C(A4),a0	;__level
	JSR	_memset

	MOVEq	#$0010,d1	;what you see is what you get
	MOVE.W	#1760,d0
	MOVE.L	-$5198(A4),a0	;__flags
	JSR	_memset

	MOVEA.L	-$6CAC(A4),A2	;_mlist
	BRA.B	L00185
L00184:
	PEA	$002E(A2)
	JSR	__free_list(PC)
	ADDQ.W	#4,A7
	MOVEA.L	(A2),A2
L00185:
	MOVE.L	A2,D3
	BNE.B	L00184

	PEA	-$6CAC(A4)	;_mlist
	JSR	__free_list(PC)
	ADDQ.W	#4,A7

	JSR	_f_restor

	PEA	-$6CB0(A4)	;_lvl_obj
	JSR	__free_list(PC)
	ADDQ.W	#4,A7

	JSR	_do_rooms
	ST	-$66FB(A4)	;_new_stats
	JSR	_clear
	JSR	_status
	JSR	_do_passages(PC)
	ADDQ.W	#1,-$60A6(A4)	;_no_food
	JSR	_put_things(PC)
	PEA	-$0004(A5)
	JSR	_blank_spot
	ADDQ.W	#4,A7
	MOVE.W	D0,D6
	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	#$25,$00(A6,D6.W)	;'%' STAIRS

	MOVEq	#10,D0
	JSR	_rnd
	CMP.W	-$60B4(A4),D0	;_level
	BGE.B	L00188

	MOVE.W	-$60B4(A4),D0	;_level
	EXT.L	D0
	DIVS.W	#$0004,D0
	JSR	_rnd
	ADDQ.W	#1,D0
	MOVE.W	D0,-$60B8(A4)	;_dnum
	CMPI.W	#10,D0		;_dnum
	BLE.B	L00186

	MOVE.W	#$000A,-$60B8(A4)	;_dnum
L00186:
	MOVE.W	-$60B8(A4),D5	;_dnum
L00187:
	MOVE.W	D5,D3
	SUBQ.W	#1,D5
	TST.W	D3
	BEQ.B	L00188

	PEA	-$0004(A5)
	JSR	_blank_spot
	ADDQ.W	#4,A7

	MOVE.W	D0,D6
	MOVE.W	D6,D3
	EXT.L	D3
	MOVEA.L	D3,A3
	ADDA.L	-$5198(A4),A3	;__flags
	ANDI.B	#$EF,(A3)	;all but F_REAL

	MOVEq	#$0006,D0
	JSR	_rnd

	OR.B	D0,(A3)
	BRA.B	L00187
L00188:
	PEA	-$52C0(A4)	;_player + 10
	JSR	_blank_spot
	ADDQ.W	#4,A7

	MOVE.W	D0,D6
	MOVEA.L	-$5198(A4),A6	;__flags
	MOVE.B	$00(A6,D6.W),D3
	AND.B	#$0010,D3	;F_REAL
	BEQ.B	L00188

	MOVE.W	-$52C0(A4),d1	;_player + 10
	MOVE.W	-$52BE(A4),d0	;_player + 12
	JSR	_moatquick

	TST.L	D0
	BNE.B	L00188

	CLR.W	-$60B0(A4)	;_mpos
	PEA	-$52C0(A4)	;_player + 10
	JSR	_enter_room
	ADDQ.W	#4,A7

	MOVEq	#$0040,d2	;'@' PLAYER
	MOVE.W	-$52C0(A4),d1	;hero.y
	MOVE.W	-$52BE(A4),d0	;hero.x
	JSR	_mvaddchquick

	LEA	-$6090(A4),A6
	LEA	-$52C0(A4),A1	;_player + 10
	MOVE.L	(A1)+,(A6)+
	MOVE.L	-$52A0(A4),-$48C0(A4)	;_player + 42 (proom),_oldrp
	JSR	_InitGadgets

	MOVEM.L	(A7)+,D4-D6/A2/A3
	UNLK	A5
	RTS

;/*
; * rnd_room:
; *  Pick a room that is really there
; */

_rnd_room:
1$	MOVEq	#$0009,D0
	JSR	_rnd
	MOVE.W	D0,D3
	MULU.W	#66,D3
	LEA	-$607A(A4),A6	;_rooms + 14 (r_flags)

	MOVE.W	$00(A6,D3.L),D2
	AND.W	#$0002,D2	;ISGONE?
	BEQ.B	2$

	MOVE.W	$00(A6,D3.L),D2
	AND.W	#$0004,D2	;ISMAZE?
	BEQ.B	1$
2$	RTS

;/*
; * put_things:
; *  Put potions and scrolls on this level
; */

_put_things:
	LINK	A5,#-$0004
	MOVEM.L	D4/D5/A2,-(A7)

	MOVEQ	#$00,D4
	TST.B	-$66BC(A4)	;_saw_amulet
	BEQ.B	L0018B

	MOVE.W	-$60B4(A4),D3	;_level
	CMP.W	-$60BA(A4),D3	;_ntraps
	BGE.B	L0018B

	MOVEQ	#$08,D4
	BRA.W	L0018F
L0018B:
	CMPI.W	#26,-$60B4(A4)	;_level
	BLT.W	L0018E

	TST.B	-$66BC(A4)	;_saw_amulet
	BNE.W	L0018E

	JSR	_new_item
	MOVEA.L	D0,A2
	TST.L	D0
	BEQ.W	L0018E

	MOVE.L	A2,-(A7)
	PEA	-$6CB0(A4)	;_lvl_obj
	JSR	__attach
	ADDQ.W	#8,A7
	CLR.W	$0024(A2)
	CLR.W	$0022(A2)
	MOVE.L	-$69AE(A4),$001A(A2)	;_no_damage
	MOVE.L	$001A(A2),$0016(A2)
	MOVE.W	#$000B,$0026(A2)
	MOVE.W	#$002C,$000A(A2)
L0018C:
	JSR	_rnd_room(PC)
	MOVE.W	D0,D5
	PEA	-$0004(A5)
	MOVE.W	D5,D3
	MULU.W	#66,D3
	LEA	-$6088(A4),A6	;_rooms
	ADD.L	A6,D3
	MOVE.L	D3,-(A7)
	JSR	_rnd_pos
	ADDQ.W	#8,A7

	MOVE.W	-$0004(A5),-(A7)
	MOVE.W	-$0002(A5),-(A7)
	JSR	_winat
	ADDQ.W	#4,A7

	CMP.W	#$002E,D0	;'.'
	BEQ.B	L0018D

	MOVE.W	-$0004(A5),-(A7)
	MOVE.W	-$0002(A5),-(A7)
	JSR	_winat
	ADDQ.W	#4,A7
	CMP.W	#$0023,D0
	BNE.B	L0018C
L0018D:
	MOVE.W	-$0004(A5),d0
	MOVE.W	-$0002(A5),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	#$2C,$00(A6,D0.W)
	MOVEA.L	A2,A6
	ADDA.L	#$0000000C,A6
	LEA	-$0004(A5),A1
	MOVE.L	(A1)+,(A6)+
L0018E:
	MOVEq	#$0014,D0
	JSR	_rnd
	TST.W	D0
	BNE.B	L0018F

	JSR	_treas_room(PC)
L0018F:
	BRA.W	L00194
L00190:
	CMPI.W	#$0053,-$60A8(A4)	;'S' with _total
	BGE.W	L00193

	MOVEq	#100,D0
	JSR	_rnd

	CMP.W	#35,D0
	BGE.W	L00193

	JSR	_new_thing(PC)
	MOVEA.L	D0,A2
	MOVE.L	A2,-(A7)
	PEA	-$6CB0(A4)	;_lvl_obj
	JSR	__attach
	ADDQ.W	#8,A7
L00191:
	JSR	_rnd_room(PC)
	MOVE.W	D0,D5
	PEA	-$0004(A5)
	MOVE.W	D5,D3
	MULU.W	#66,D3
	LEA	-$6088(A4),A6	;_rooms
	ADD.L	A6,D3
	MOVE.L	D3,-(A7)
	JSR	_rnd_pos
	ADDQ.W	#8,A7

	MOVE.W	-$0004(A5),d0
	MOVE.W	-$0002(A5),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	CMPI.B	#$002E,$00(A6,D0.W)
	BEQ.B	L00192

;	MOVE.W	-$0004(A5),d0
;	MOVE.W	-$0002(A5),d1
;	JSR	_INDEXquick

;	MOVEA.L	-$519C(A4),A6	;__level
	CMPI.B	#$0023,$00(A6,D0.W)
	BNE.B	L00191
L00192:
	MOVE.W	-$0004(A5),d0
	MOVE.W	-$0002(A5),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	$000B(A2),$00(A6,D0.W)
	MOVEA.L	A2,A6
	ADDA.L	#$0000000C,A6
	LEA	-$0004(A5),A1
	MOVE.L	(A1)+,(A6)+
L00193:
	ADDQ.W	#1,D4
L00194:
	CMP.W	#$0009,D4
	BLT.W	L00190

	MOVEM.L	(A7)+,D4/D5/A2
	UNLK	A5
	RTS

;/*
; * treas_room:
; *  Add a treasure room
; */

_treas_room:
	LINK	A5,#-$000C
	MOVEM.L	A2/A3,-(A7)
	JSR	_rnd_room(PC)
	MULS.W	#$0042,D0
	LEA	-$6088(A4),A6	;_rooms
	MOVEA.L	D0,A3
	ADDA.L	A6,A3
	MOVE.W	$0006(A3),D3
	SUBQ.W	#2,D3
	MOVE.W	$0004(A3),D2
	SUBQ.W	#2,D2
	MULU.W	D2,D3
	SUBQ.W	#2,D3
	MOVE.W	D3,-$0006(A5)
	CMPI.W	#$0008,-$0006(A5)
	BLE.B	L00195
	MOVE.W	#$0008,-$0006(A5)
L00195:
	MOVE.W	-$0006(A5),D0
	JSR	_rnd
	ADDQ.W	#2,D0
	MOVE.W	D0,-$0002(A5)
	MOVE.W	D0,-$0008(A5)
L00196:
	MOVE.W	-$0002(A5),D3
	SUBQ.W	#1,-$0002(A5)
	TST.W	D3
	BEQ.W	L00199
	CMPI.W	#$0053,-$60A8(A4)	;'S' with _total
	BGE.B	L00199
L00197:
	PEA	-$000C(A5)
	MOVE.L	A3,-(A7)
	JSR	_rnd_pos
	ADDQ.W	#8,A7

	MOVE.W	-$000C(A5),d0
	MOVE.W	-$000A(A5),d1
	JSR	_INDEXquick

	MOVE.W	D0,-$0004(A5)
	MOVE.W	-$0004(A5),D3
	MOVEA.L	-$519C(A4),A6	;__level

	MOVE.B	$00(A6,D3.W),D2
	CMP.B	#$2E,D2
	BEQ.B	L00198

;	MOVE.W	-$0004(A5),D3
;	MOVEA.L	-$519C(A4),A6	;__level
;	MOVEQ	#$00,D2
;	MOVE.B	$00(A6,D3.W),D2
	CMP.B	#$23,D2
	BNE.B	L00197
L00198:
	JSR	_new_thing(PC)
	MOVEA.L	D0,A2
	MOVEA.L	A2,A6
	ADDA.L	#$0000000C,A6
	LEA	-$000C(A5),A1
	MOVE.L	(A1)+,(A6)+
	MOVE.L	A2,-(A7)
	PEA	-$6CB0(A4)	;_lvl_obj
	JSR	__attach
	ADDQ.W	#8,A7
	MOVE.W	-$0004(A5),D3
	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	$000B(A2),$00(A6,D3.W)
	BRA.W	L00196
L00199:
	MOVE.W	-$0006(A5),D0
	JSR	_rnd
	ADDQ.W	#2,D0
	MOVE.W	D0,-$0002(A5)
	MOVE.W	-$0008(A5),D3
	ADDQ.W	#2,D3
	CMP.W	D3,D0
	BGE.B	L0019A
	MOVE.W	-$0008(A5),D3
	ADDQ.W	#2,D3
	MOVE.W	D3,-$0002(A5)
L0019A:
	MOVE.W	$0006(A3),D3
	SUBQ.W	#2,D3
	MOVE.W	$0004(A3),D2
	SUBQ.W	#2,D2
	MULU.W	D2,D3
	MOVE.W	D3,-$0006(A5)
	MOVE.W	-$0002(A5),D3
	CMP.W	-$0006(A5),D3
	BLE.B	L0019B
	MOVE.W	-$0006(A5),-$0002(A5)
L0019B:
	ADDQ.W	#1,-$60B4(A4)	;_level
L0019C:
	MOVE.W	-$0002(A5),D3
	SUBQ.W	#1,-$0002(A5)
	TST.W	D3
	BEQ.W	L001A2
	CLR.W	-$0006(A5)
L0019D:
	PEA	-$000C(A5)
	MOVE.L	A3,-(A7)
	JSR	_rnd_pos
	ADDQ.W	#8,A7

	MOVE.W	-$000C(A5),d0
	MOVE.W	-$000A(A5),d1
	JSR	_INDEXquick

	MOVE.W	D0,-$0004(A5)
	MOVE.W	-$0004(A5),D3
	MOVEA.L	-$519C(A4),A6	;__level
	MOVEQ	#$00,D2
	MOVE.B	$00(A6,D3.W),D2
	CMP.W	#$002E,D2
	BEQ.B	L0019E
	MOVE.W	-$0004(A5),D3
	MOVEA.L	-$519C(A4),A6	;__level
	MOVEQ	#$00,D2
	MOVE.B	$00(A6,D3.W),D2
	CMP.W	#$0023,D2
	BNE.B	L0019F
L0019E:
	MOVE.W	-$000C(A5),d1
	MOVE.W	-$000A(A5),d0
	JSR	_moatquick

	TST.L	D0
	BEQ.B	L001A0
L0019F:
	ADDQ.W	#1,-$0006(A5)
	CMPI.W	#$000A,-$0006(A5)
	BLT.B	L0019D
L001A0:
	CMPI.W	#$000A,-$0006(A5)
	BEQ.B	L001A1
	JSR	_new_item
	MOVEA.L	D0,A2
	TST.L	D0
	BEQ.B	L001A1
	PEA	-$000C(A5)
	CLR.L	-(A7)
	JSR	_randmonster
	ADDQ.W	#4,A7
	MOVE.W	D0,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_new_monster
	LEA	$000A(A7),A7
	ORI.W	#$0020,$0016(A2)
	MOVE.L	A2,-(A7)
	JSR	_give_pack
	ADDQ.W	#4,A7
L001A1:
	BRA.W	L0019C
L001A2:
	SUBQ.W	#1,-$60B4(A4)	;_level
	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

L001A3:	dc.b	"you hear maniacal laughter%s.",0
L001A4:	dc.b	" in the distance",0,0

;/*
; * read_scroll:
; *  Read a scroll from the pack and do the appropriate thing
; */

_read_scroll:
	LINK	A5,#-$0006
	MOVEM.L	D4-D7/A2/A3,-(A7)
	MOVEA.L	$0008(A5),A2
	CLR.B	-$0001(A5)
	MOVE.L	A2,D3
	BNE.B	L001A5
	MOVE.W	#$003F,-(A7)	;'?'
	PEA	L001E7(PC)	;"read"
	JSR	_get_item
	ADDQ.W	#6,A7
	MOVEA.L	D0,A2
L001A5:
	MOVE.L	A2,D3
	BNE.B	L001A7
L001A6:
	MOVEM.L	(A7)+,D4-D7/A2/A3
	UNLK	A5
	RTS

L001A7:
	CMPI.W	#$003F,$000A(A2)	;'?' is it a scroll?
	BEQ.B	L001A8

	PEA	L001E8(PC)	;"there is nothing on it to read"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L001A6
L001A8:
	CMPI.W	#S_WILDMAGIC,$0020(A2)	;for scrolls of wild magic, wisdom does not apply
	BEQ.B	L001AA

	MOVE.L	A2,-(A7)
	JSR	_check_wisdom
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L001A9
	BRA.B	L001A6
L001A9:
	PEA	L001EA(PC)	;"as you read the scroll, it vanishes"
	PEA	L001E9(PC)	;"the scroll vanishes"
	JSR	_ifterse(PC)
	ADDQ.W	#8,A7

	CMPA.L	-$5298(A4),A2	;scroll is _cur_weapon?
	BNE.B	L001AA

	CLR.L	-$5298(A4)	;clear _cur_weapon
L001AA:
	MOVE.W	$0020(A2),D0
;	EXT.L	D0
	BRA.W	L001E4

; monster confusion scroll

L001AB:
	ORI.W	#C_CANHUH,-$52B4(A4)	;set C_CANHUH,_player + 22 (flags)
	PEA	L001EB(PC)	;"your hands begin to glow red"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L001E6

; enchant armor scroll

L001AC:
	TST.L	-$5294(A4)	;_cur_armor
	BEQ.B	L001AD
	MOVEA.L	-$5294(A4),A6	;_cur_armor
	SUBQ.W	#1,$0026(A6)
;	MOVEA.L	-$5294(A4),A6	;_cur_armor
	ANDI.W	#~O_ISCURSED,$0028(A6)	;clear O_ISCURSED bit
	MOVE.W	#$0001,-(A7)
	MOVE.L	-$5294(A4),-(A7)	;_cur_armor
	JSR	_pack_name
	ADDQ.W	#6,A7
	PEA	L001ED(PC)	;"your armor glows faintly for a moment"
	PEA	L001EC(PC)	;"your armor glows faintly"
	JSR	_ifterse(PC)
	ADDQ.W	#8,A7
L001AD:
	BRA.W	L001E6

; hold monster scroll

L001AE:
	MOVE.W	-$52C0(A4),D5	;_player + 10
	SUBQ.W	#3,D5
	BRA.B	L001B4
L001AF:
	CMP.W	#$0000,D5
	BLT.B	L001B3
	CMP.W	#$003C,D5
	BGE.B	L001B3
	MOVE.W	-$52BE(A4),D4	;_player + 12
	SUBQ.W	#3,D4
	BRA.B	L001B2
L001B0:
	CMP.W	#$0000,D4
	BLE.B	L001B1
	CMP.W	-$60BC(A4),D4	;_maxrow
	BGE.B	L001B1

	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_moatquick

	MOVEA.L	D0,A3
	TST.L	D0
	BEQ.B	L001B1
	ANDI.W	#~C_ISRUN,$0016(A3)	;clear C_ISRUN
	ORI.W	#C_ISHELD,$0016(A3)	;set C_ISHELD
L001B1:
	ADDQ.W	#1,D4
L001B2:
	MOVE.W	-$52BE(A4),D3	;_player + 12
	ADDQ.W	#3,D3
	CMP.W	D3,D4
	BLE.B	L001B0
L001B3:
	ADDQ.W	#1,D5
L001B4:
	MOVE.W	-$52C0(A4),D3	;_player + 10
	ADDQ.W	#3,D3
	CMP.W	D3,D5
	BLE.B	L001AF
	BRA.W	L001E6

; sleep scroll

L001B5:
	ST	-$66F3(A4)	;_s_know + 3 "sleep"

	MOVEq	#$0005,D0
	JSR	_spread

	MOVE.W	D0,D0
	JSR	_rnd
	ADDQ.W	#4,D0

	ADD.W	D0,-$60AC(A4)	;_no_command

	ANDI.W	#~C_ISRUN,-$52B4(A4)	;clear C_ISRUN, _player + 22 (flags)
	PEA	L001EE(PC)	;"you fall asleep"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L001E6

; create monster scroll

L001B6:
	PEA	-$0006(A5)
	MOVE.W	-$52C0(A4),-(A7)	;_player + 10
	MOVE.W	-$52BE(A4),-(A7)	;_player + 12
	JSR	_plop_monster(PC)
	ADDQ.W	#8,A7
	TST.W	D0
	BEQ.B	L001B7

	JSR	_new_item
	MOVEA.L	D0,A3
	TST.L	D0
	BEQ.B	L001B7

	PEA	-$0006(A5)
	CLR.L	-(A7)
	JSR	_randmonster
	ADDQ.W	#4,A7
	MOVE.W	D0,-(A7)
	MOVE.L	A3,-(A7)
	JSR	_new_monster
	LEA	$000A(A7),A7
	BRA.B	L001B8
L001B7:
	PEA	L001F0(PC)	;"you hear a faint cry of anguish in the distance"
	PEA	L001EF(PC)	;"you hear a faint cry of anguish"
	JSR	_ifterse(PC)
	ADDQ.W	#8,A7
L001B8:
	BRA.W	L001E6

; identify scroll

L001B9:
	ST	-$66F1(A4)	;_s_know + 5 "identify"
	PEA	L001F1(PC)	;"this scroll is an identify scroll"
	JSR	_msg
	ADDQ.W	#4,A7
	TST.B	-$66AA(A4)	;_menu_style
	BEQ.B	L001BA

	PEA	L001F2(PC)	;" More "
	JSR	_more(PC)
	ADDQ.W	#4,A7
L001BA:
	MOVE.W	#$0001,-(A7)
	CLR.L	-(A7)
	JSR	_whatis
	ADDQ.W	#6,A7
	BRA.W	L001E6

; magic mapping scroll

L001BB:
	ST	-$66F5(A4)	;_s_know + 1 "magic mapping"
	PEA	L001F3(PC)	;"oh, now this scroll has a map on it"
	JSR	_msg
	ADDQ.W	#4,A7
	MOVEQ	#$01,D4
	BRA.W	L001C6
L001BC:
	MOVEQ	#$00,D5
L001BD:
	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick

	MOVE.W	D0,D7
	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	$00(A6,D7.W),D6
	MOVEQ	#$00,D0
	MOVE.B	D6,D0
	BRA.B	L001C2
L001BE:
	MOVEA.L	-$5198(A4),A6	;__flags
	MOVE.B	$00(A6,D7.W),D3
	AND.W	#$0010,D3
	BNE.B	L001BF

	MOVEA.L	-$519C(A4),A6	;__level
	MOVEQ	#$2B,D6		;'+'
	MOVE.B	D6,$00(A6,D7.W)
	MOVEA.L	-$5198(A4),A6	;__flags
	ANDI.B	#$EF,$00(A6,D7.W)
L001BF:
	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_moatquick

	MOVEA.L	D0,A3
	TST.L	D0
	BEQ.B	L001C0

	CMP.B	#$20,$0011(A3)	; SPACE
	BNE.B	L001C0

	MOVE.B	D6,$0011(A3)
L001C0:
	BRA.B	L001C3
L001C1:
	MOVEQ	#$20,D6
	BRA.B	L001C3
L001C2:
	SUB.w	#$0023,D0	;'#'
	BEQ.B	L001BF
	SUBQ.w	#2,D0		;'%'
	BEQ.B	L001BF
	SUBQ.w	#6,D0		;'+'
	BEQ.B	L001BF
	SUBQ.w	#2,D0		;'-'
	BEQ.B	L001BE
	SUB.w	#$000F,D0	;'<'
	BEQ.B	L001BE
	SUBQ.w	#2,D0		;'>'
	BEQ.B	L001BE
	SUB.w	#$003D,D0	;'{'
	BEQ.B	L001BE
	SUBQ.w	#1,D0		;'|'
	BEQ.B	L001BE
	SUBQ.w	#1,D0		;'}'
	BEQ.B	L001BE
	BRA.B	L001C1
L001C3:
	CMP.B	#$2B,D6		;'+'
	BNE.B	L001C4

	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_movequick

	JSR	_inch(PC)
	CMP.W	#$002B,D0	;'+'
	BEQ.B	L001C4
	JSR	_standout
L001C4:
	CMP.B	#$20,D6		;' '
	BEQ.B	L001C5

	MOVE.W	D6,d2
	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_mvaddchquick

L001C5:
	JSR	_standend
	ADDQ.W	#1,D5
	CMP.W	#$003C,D5
	BLT.W	L001BD
	ADDQ.W	#1,D4
L001C6:
	CMP.W	-$60BC(A4),D4	;_maxrow
	BLT.W	L001BC
	BRA.W	L001E6

; wild magic scroll

L001C7:
	PEA	L001F4(PC)	;"This is a scroll of wild magic"
	JSR	_msg
	ADDQ.W	#4,A7

	ST	-$66EF(A4)	;_s_know + 7 "wild magic"

; special case for wild magic scrolls, because it is maybe not consumed

	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_pack_name	;updates the items name in the pack
	ADDQ.W	#6,A7

	MOVE.W	-$52A8(A4),D3	;_player + 34 (hp)
	LSR.W	#1,D3		;divide the players health in half
	SUB.W	D3,-$52A8(A4)	;_player + 34 (hp)

	MOVE.W	#-1,-(A7)	;subtract one strength point

	JSR	_chg_str
	ADDQ.W	#2,A7
	JSR	_status
	PEA	L001F5(PC)	;"You sense something uncontrollable about this object."
	JSR	_warning(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L001C9

	MOVEq	#100,D0		;10% chance you can't control it
	JSR	_rnd
	CMP.W	#10,D0
	BGE	L001A6

	PEA	L001F6(PC)	;"The wild magic is too strong for you to control ..."
	JSR	_msg
	ADDQ.W	#4,A7
L001C9:
	MOVE.L	A2,-(A7)
	JSR	_wild_magic(PC)	; lets see what we've got
	ADDQ.W	#4,A7
	BRA.W	L001E6

; teleportation scroll

L001CA:
	MOVE.L	-$52A0(A4),-$0006(A5)	;_player + 42 (proom)
	JSR	_teleport
	MOVEA.L	-$0006(A5),A6
	CMPA.L	-$52A0(A4),A6	;_player + 42 (proom)
	BEQ	L001E6
	MOVE.B	#$01,-$66EE(A4)
	BRA.W	L001E6

; enchant weapon

L001CC:
	TST.L	-$5298(A4)	;_cur_weapon
	BEQ.B	L001CD
	MOVE.L	-$5298(A4),-(A7)	;_cur_weapon
	JSR	_typeof
	ADDQ.W	#4,A7
	CMP.W	#$006D,D0	;'m' weapon type
	BNE.B	L001CD

	JSR	_s_enchant(PC)
	MOVEA.L	-$5298(A4),A6	;_cur_weapon
	MOVE.W	$0020(A6),D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$6F5C(A4),A6	;_w_names
	MOVE.L	$00(A6,D3.w),-(A7)
	PEA	L001F8(PC)	;"your %s glows blue for a moment"
	JSR	_msg
	ADDQ.W	#8,A7
	BRA.W	L001E6
L001CD:
	PEA	L001F7(PC)	;"you feel a strange sense of loss"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L001E6

; scare monster scroll

L001D0:
	TST.B	-$66B2(A4)	;_terse
	BNE.B	L001D1
	TST.B	-$66AB(A4)	;_expert
	BEQ.B	L001D2
L001D1:
	LEA	L001F9(PC),A6	; $0
	MOVE.L	A6,D3
	BRA.B	L001D3
L001D2:
	MOVE.L	-$77B4(A4),D3	;_in_dist
L001D3:
	MOVE.L	D3,-(A7)
	MOVE.L	-$77B8(A4),-(A7)	;_laugh
	JSR	_msg
	ADDQ.W	#8,A7
	BRA.W	L001E6

; remove curse scroll

L001D4:
	JSR	_s_remove(PC)
	LEA	L001FB(PC),a0	;"you feel as if "
	JSR	_noterse

	MOVE.L	D0,-(A7)
	PEA	L001FA(PC)	;"%ssomebody is watching over you"
	JSR	_msg
	ADDQ.W	#8,A7
	BRA.W	L001E6

; aggravate monster

L001D5:
	JSR	_aggravate
	PEA	L001FD(PC)	;"you hear a high pitched humming noise"
	PEA	L001FC(PC)	;"you hear a humming noise"
	JSR	_ifterse(PC)
	ADDQ.W	#8,A7
	BRA.W	L001E6

; blank paper scroll

L001D6:
	PEA	L001FE(PC)	;"this scroll seems to be blank"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L001E6

; vorpalize weapon scroll

L001D7:
	TST.L	-$5298(A4)	;_cur_weapon
	BEQ.B	L001D8

	MOVE.L	-$5298(A4),-(A7)	;_cur_weapon
	JSR	_typeof
	ADDQ.W	#4,A7
	CMP.W	#$006D,D0	;'m' weapon type
	BEQ.B	L001DC
L001D8:
	TST.B	-$66B2(A4)	;_terse
	BNE.B	L001D9
	TST.B	-$66AB(A4)	;_expert
	BEQ.B	L001DA
L001D9:
	LEA	L001F9(PC),A6	; $0
	MOVE.L	A6,D3
	BRA.B	L001DB

L001DA:
	MOVE.L	-$77B4(A4),D3	;_in_dist
L001DB:
	MOVE.L	D3,-(A7)
	MOVE.L	-$77B8(A4),-(A7)	;_laugh
	JSR	_msg
	ADDQ.W	#8,A7
	BRA.W	L001E1

; vorpalize weapon

L001DC:
	MOVEA.L	-$5298(A4),A6	;_cur_weapon
	TST.B	$002A(A6)	;already vorpalized
	BEQ.B	L001DD

	MOVE.W	$0020(A6),D3
	ASL.w	#2,D3
	LEA	-$6F5C(A4),A6	;_w_names
	MOVE.L	$00(A6,D3.w),-(A7)
	PEA	L00200(PC)	;"your %s vanishes in a puff of smoke"
	JSR	_msg
	ADDQ.W	#8,A7
	CLR.L	-(A7)
	MOVE.L	-$5298(A4),-(A7)	;_cur_weapon
	JSR	_unpack
	ADDQ.W	#8,A7
	MOVE.L	-$5298(A4),-(A7)	;_cur_weapon
	JSR	_discard
	ADDQ.W	#4,A7
	CLR.L	-$5298(A4)	;_cur_weapon
	BRA.B	L001E1
L001DD:
	JSR	_pick_mons
	MOVEA.L	-$5298(A4),A6	;_cur_weapon
	MOVE.B	D0,$002A(A6)	;set the monster which we can slay now
	ADDQ.W	#1,$0022(A6)	;hplus
	ADDQ.W	#1,$0024(A6)	;dplus
	MOVE.W	#$0001,$0026(A6)
	TST.B	-$66B2(A4)	;_terse
	BNE.B	L001DE

	TST.B	-$66AB(A4)	;_expert
	BEQ.B	L001DF
L001DE:
	LEA	L001F9(PC),A6
	MOVE.L	A6,D3
	BRA.B	L001E0
L001DF:
	MOVE.L	-$69C6(A4),D3	;_intense
L001E0:
	MOVE.L	D3,-(A7)
	MOVEA.L	-$5298(A4),A6	;_cur_weapon
	MOVE.W	$0020(A6),D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$6F5C(A4),A6	;_w_names
	MOVE.L	$00(A6,D3.w),-(A7)
	MOVE.L	-$69C2(A4),-(A7)	;_flash
	JSR	_msg
	LEA	$000C(A7),A7
	MOVE.W	#$0001,-(A7)
	MOVE.L	-$5298(A4),-(A7)	;_cur_weapon
	JSR	_pack_name
	ADDQ.W	#6,A7
L001E1:
	BRA.B	L001E6

L001E2:
	PEA	L00202(PC)	;"what a puzzling scroll!"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L001A6
L001E3:
	dc.w	L001AB-L001E5	;monster confusion
	dc.w	L001BB-L001E5	;magic mapping
	dc.w	L001AE-L001E5	;hold monster
	dc.w	L001B5-L001E5	;sleep
	dc.w	L001AC-L001E5	;enchant armor
	dc.w	L001B9-L001E5	;identify
	dc.w	L001D0-L001E5	;scare monster
	dc.w	L001C7-L001E5	;wild magic
	dc.w	L001CA-L001E5	;teleportation
	dc.w	L001CC-L001E5	;enchant weapon
	dc.w	L001B6-L001E5	;create monster
	dc.w	L001D4-L001E5	;remove curse
	dc.w	L001D5-L001E5	;aggravate monster
	dc.w	L001D6-L001E5	;blank paper
	dc.w	L001D7-L001E5	;vorpalize weapon
L001E4:
	CMP.W	#$000F,D0
	BCC.B	L001E2
	ASL.W	#1,D0
	MOVE.W	L001E3(PC,D0.W),D0
L001E5:	JMP	L001E5(PC,D0.W)

L001E6:
	MOVE.W	#$0001,-(A7)
	JSR	_look
	ADDQ.W	#2,A7
	JSR	_status

	MOVE.W	$0020(A2),D3
	MULU.W	#21,D3
	LEA	-$656A(A4),A6	;_s_guess
	ADD.L	A6,D3
	MOVE.L	D3,-(A7)

	MOVE.W	$0020(A2),D3
	LEA	-$66F6(A4),A6	;_s_know
	MOVEQ	#$00,D2
	MOVE.B	$00(A6,D3.W),D2

	MOVE.W	D2,-(A7)
	JSR	_call_it
	ADDQ.W	#6,A7

	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_pack_name
	ADDQ.W	#6,A7

	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_unpack
	ADDQ.W	#6,A7

	MOVE.L	D0,-(A7)
	JSR	_discard
	ADDQ.W	#4,A7
	BRA.W	L001A6

L001E7:	dc.b	"read",0
L001E8:	dc.b	"there is nothing on it to read",0
L001E9:	dc.b	"the scroll vanishes",0
L001EA:	dc.b	"as you read the scroll, it vanishes",0
L001EB:	dc.b	"your hands begin to glow red",0
L001EC:	dc.b	"your armor glows faintly",0
L001ED:	dc.b	"your armor glows faintly for a moment",0
L001EE:	dc.b	"you fall asleep",0
L001EF:	dc.b	"you hear a faint cry of anguish",0
L001F0:	dc.b	"you hear a faint cry of anguish in the distance",0
L001F1:	dc.b	"this scroll is an identify scroll",0
L001F2:	dc.b	" More ",0
L001F3:	dc.b	"oh, now this scroll has a map on it",0
L001F4:	dc.b	"This is a scroll of wild magic",0
L001F5:	dc.b	"You sense something uncontrollable about this object.",0
L001F6:	dc.b	"The wild magic is too strong for you to control ...",0
L001F7:	dc.b	"you feel a strange sense of loss",0
L001F8:	dc.b	"your %s glows blue for a moment",0
L001F9:	dc.b	$00
L001FA:	dc.b	"%ssomebody is watching over you",0
L001FB:	dc.b	"you feel as if ",0
L001FC:	dc.b	"you hear a humming noise",0
L001FD:	dc.b	"you hear a high pitched humming noise",0
L001FE:	dc.b	"this scroll seems to be blank",0
L00200:	dc.b	"your %s vanishes in a puff of smoke",0
L00202:	dc.b	"what a puzzling scroll!",0,0

_wild_magic:
	LINK	A5,#-$0004
	MOVEM.L	D4/D5/A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2

	MOVEq	#$0006,D0	;6 possible actions can happen
	JSR	_rnd
;	EXT.L	D0
	BRA.W	L00214

; thunderclaps, removes all monster from the level, also there will be no new ones in this level

L00203:
	MOVEA.L	-$6CAC(A4),A3	;_mlist
	BRA.B	L00205
L00204:
	MOVE.L	(A3),D4
	MOVE.W	#$0001,-(A7)
	MOVE.L	A3,-(A7)
	PEA	$000A(A3)
	JSR	_remove
	LEA	$000A(A7),A7
	MOVEA.L	D4,A3
L00205:
	MOVE.L	A3,D3		;get monster from list
	BNE.B	L00204

	PEA	L00217(PC)	;"You hear a series of loud thunderclaps rolling through the passages"
	JSR	_msg
	ADDQ.W	#4,A7
	ST	-$66FA(A4)	;_no_more_fears
	BRA.W	L00216

; overwhelmed

L00206:
	JSR	_p_confuse(PC)
	JSR	_p_blind(PC)
	JSR	_aggravate
	PEA	L00218(PC)	;"You are overwhelmed by the force of wild magic"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L00216

; pack glows yellow, identifies everything in the pack

L00207:
	MOVEA.L	-$529C(A4),A3	;_player + 46 (pack)
	BRA.B	L00209
L00208:
	CLR.L	-(A7)
	MOVE.L	A3,-(A7)
	JSR	_whatis
	ADDQ.W	#8,A7
	MOVEA.L	(A3),A3
L00209:
	MOVE.L	A3,D3
	BNE.B	L00208

	PEA	L00219(PC)	;"Your pack glows yellow for a moment"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L00216

; falls 2-6 level

L0020A:
	MOVEq	#$0003,D0
	JSR	_rnd
	ADDQ.W	#4,D0
	MOVE.W	D0,-$6096(A4)	;_fall_level
	BRA.W	L00216

; surrounded by a blue glow

L0020B:
	JSR	_s_remove(PC)	;removes the curses of the used weapon/armor and rings

	TST.L	-$5298(A4)	;_cur_weapon
	BEQ.B	L0020C

	MOVEA.L	-$5298(A4),A6	;_cur_weapon
	CMPI.W	#$006D,$000A(A6)	;m weapon type
	BNE.B	L0020C

	; double enchant currently wielded weapon

	JSR	_s_enchant(PC)
	JSR	_s_enchant(PC)
L0020C:
	TST.L	-$5294(A4)	;_cur_armor
	BEQ.B	L0020D

	; increase armor class by two points

	MOVEA.L	-$5294(A4),A6	;_cur_armor
	SUBQ.W	#2,$0026(A6)
	MOVE.W	#$0001,-(A7)
	MOVE.L	-$5294(A4),-(A7)	;_cur_armor
	JSR	_pack_name
	ADDQ.W	#6,A7
L0020D:
	PEA	L0021A(PC)	;"You are surrounded by a blue glow"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L00216

; pack feels lighter

L0020E:
	PEA	L0021B(PC)	;"There is a fluttering behind you and suddenly your pack feels lighter."
	JSR	_msg
	ADDQ.W	#4,A7
	MOVEA.L	-$529C(A4),A3	;_player + 46 (pack)
	BRA.W	L00212
L0020F:
	MOVE.L	(A3),D4
	CMPA.L	A2,A3
	BEQ.W	L00211

	MOVE.L	A3,-(A7)
	JSR	__is_current
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.W	L00211
L00210:
	PEA	-$0004(A5)
	JSR	_blank_spot
	ADDQ.W	#4,A7

	MOVE.W	D0,D5
	MOVEA.L	-$5198(A4),A6	;__flags
	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D5.W),D3
	AND.W	#$0010,D3
	BEQ.B	L00210

	MOVE.W	-$0004(A5),d1
	MOVE.W	-$0002(A5),d0
	JSR	_moatquick

	TST.L	D0
	BNE.B	L00210

	MOVE.W	#$0001,-(A7)
	MOVE.L	A3,-(A7)
	JSR	_unpack
	ADDQ.W	#6,A7

	MOVEA.L	D0,A3
	MOVE.L	A3,-(A7)
	PEA	-$6CB0(A4)	;_lvl_obj
	JSR	__attach
	ADDQ.W	#8,A7

	MOVEA.L	A3,A6
	ADDA.L	#$0000000C,A6
	LEA	-$0004(A5),A1
	MOVE.L	(A1)+,(A6)+
	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	$000B(A3),$00(A6,D5.W)
	MOVE.W	-$0004(A5),-(A7)
	MOVE.W	-$0002(A5),-(A7)
	JSR	_cansee
	ADDQ.W	#4,A7

	TST.W	D0
	BEQ.B	L00211

	MOVEA.L	-$519C(A4),A6	;__level

	MOVE.B	$00(A6,D5.W),D2
	MOVE.W	-$0004(A5),d1
	MOVE.W	-$0002(A5),d0
	JSR	_mvaddchquick

L00211:
	MOVEA.L	D4,A3
L00212:
	MOVE.L	A3,D3
	BNE.W	L0020F
	BRA.B	L00216
L00213:
	dc.w	L00203-L00215	;+ "You hear a series of loud thunderclaps rolling through the passages"
	dc.w	L00206-L00215	;- "You are overwhelmed by the force of wild magic"
	dc.w	L00207-L00215	;+ "Your pack glows yellow for a moment"
	dc.w	L0020A-L00215	;-- falls a random number (2-6) of levels
	dc.w	L0020B-L00215	;++ "You are surrounded by a blue glow"
	dc.w	L0020E-L00215	;- "There is a fluttering behind you and suddenly your pack feels lighter."
L00214:
	CMP.w	#$0006,D0
	BCC.B	L00216

	ASL.w	#1,D0
	MOVE.W	L00213(PC,D0.W),D0
L00215:	JMP	L00215(PC,D0.W)
L00216:
	MOVEM.L	(A7)+,D4/D5/A2/A3
	UNLK	A5
	RTS

L00217:	dc.b	"You hear a series of loud thunderclaps rolling through the passages",0
L00218:	dc.b	"You are overwhelmed by the force of wild magic",0
L00219:	dc.b	"Your pack glows yellow for a moment",0
L0021A:	dc.b	"You are surrounded by a blue glow",0
L0021B:	dc.b	"There is a fluttering behind you and suddenly your pack feels lighter.",0

; removes the curse of the wielded weapon, worn armor and used rings

_s_remove:
;	LINK	A5,#-$0000

	TST.L	-$5294(A4)	;_cur_armor
	BEQ.B	L0021C
	MOVEA.L	-$5294(A4),A6	;_cur_armor
	ANDI.W	#~O_ISCURSED,$0028(A6)	;clear ISCURSED bit
L0021C:
	TST.L	-$5298(A4)	;_cur_weapon
	BEQ.B	L0021D
	MOVEA.L	-$5298(A4),A6	;_cur_weapon
	ANDI.W	#~O_ISCURSED,$0028(A6)
L0021D:
	TST.L	-$5190(A4)	;_cur_ring_1
	BEQ.B	L0021E
	MOVEA.L	-$5190(A4),A6	;_cur_ring_1
	ANDI.W	#~O_ISCURSED,$0028(A6)
L0021E:
	TST.L	-$518C(A4)	;_cur_ring_2
	BEQ.B	L0021F
	MOVEA.L	-$518C(A4),A6	;_cur_ring_2
	ANDI.W	#~O_ISCURSED,$0028(A6)
L0021F:
;	UNLK	A5
	RTS

_s_enchant:
;	LINK	A5,#-$0000
	MOVEA.L	-$5298(A4),A6	;_cur_weapon

	ANDI.W	#~O_ISCURSED,$0028(A6)	;clear O_ISCURSED bit
	MOVEq	#$0002,D0
	JSR	_rnd
	MOVEA.L	-$5298(A4),A6	;_cur_weapon
	TST.W	D0
	BNE.B	L00220

	ADDQ.W	#1,$0022(A6)
	BRA.B	L00221
L00220:
	ADDQ.W	#1,$0024(A6)
L00221:
	MOVE.W	#$0001,-(A7)
	MOVE.L	A6,-(A7)	;_cur_weapon
	JSR	_pack_name
	ADDQ.W	#6,A7

;	UNLK	A5
	RTS

_slime_split:
	LINK	A5,#-$0000

	MOVE.L	A2,-(A7)
	MOVE.L	$0008(A5),-(A7)
	JSR	_new_slime(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00222

	JSR	_new_item
	MOVEA.L	D0,A2
	TST.L	D0
	BNE.B	L00223
L00222:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L00223:
	PEA	L00225(PC)
	JSR	_msg
	ADDQ.W	#4,A7
	PEA	-$54E0(A4)
	MOVE.W	#$0053,-(A7)	;'S' slime
	MOVE.L	A2,-(A7)
	JSR	_new_monster
	LEA	$000A(A7),A7

	MOVE.W	-$54E0(A4),-(A7)
	MOVE.W	-$54DE(A4),-(A7)
	JSR	_cansee
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00224

	MOVE.W	-$54E0(A4),d0
	MOVE.W	-$54DE(A4),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	$00(A6,D0.W),$0011(A2)

	MOVEq	#$53,d2		;'S'
	MOVE.W	-$54E0(A4),d1
	MOVE.W	-$54DE(A4),d0
	JSR	_mvaddchquick

L00224:
	PEA	-$54E0(A4)
	JSR	_start_run
	ADDQ.W	#4,A7
	BRA.B	L00222

L00225:	dc.b	"The slime divides.  Ick!",0,0

_new_slime:
	LINK	A5,#-$0008
	MOVEM.L	D4-D7/A2,-(A7)

	SUBA.L	A2,A2
	MOVEA.L	$0008(A5),A6
	ORI.W	#$8000,$0016(A6)	;C_ISFLY
	PEA	-$0008(A5)
	MOVEA.L	$0008(A5),A6
	MOVE.W	$000A(A6),D7
	MOVE.W	D7,-(A7)
	MOVEA.L	$0008(A5),A6
	MOVE.W	$000C(A6),D6
	MOVE.W	D6,-(A7)
	JSR	_plop_monster(PC)
	ADDQ.W	#8,A7
	TST.W	D0
	BNE.B	L0022B

	MOVE.W	D6,D4
	SUBQ.W	#1,D4
	BRA.B	L0022A
L00226:
	MOVE.W	D7,D5
	SUBQ.W	#1,D5
	BRA.B	L00229
L00227:
	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_winat
	ADDQ.W	#4,A7
	CMP.W	#$0053,D0	;'S' slime
	BNE.B	L00228

	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_moatquick

	MOVE.L	D0,-$0004(A5)
;	TST.L	D0
	BEQ.B	L00228

	MOVEA.L	-$0004(A5),A6
	MOVE.W	$0016(A6),D3
	AND.W	#$8000,D3	;C_ISFLY
	BNE.B	L00228

	MOVE.L	-$0004(A5),-(A7)
	BSR.B	_new_slime
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00228

	MOVE.W	D6,D4
	ADDQ.W	#2,D4
	MOVE.W	D7,D5
	ADDQ.W	#2,D5
L00228:
	ADDQ.W	#1,D5
L00229:
	MOVE.W	D7,D3
	ADDQ.W	#1,D3
	CMP.W	D3,D5
	BLE.B	L00227

	ADDQ.W	#1,D4
L0022A:
	MOVE.W	D6,D3
	ADDQ.W	#1,D3
	CMP.W	D3,D4
	BLE.B	L00226

	BRA.B	L0022C
L0022B:
	MOVEA.W	#$0001,A2
	LEA	-$54E0(A4),A6
	LEA	-$0008(A5),A1
	MOVE.L	(A1)+,(A6)+
L0022C:
	MOVEA.L	$0008(A5),A6
	ANDI.W	#$7FFF,$0016(A6)	;clear C_ISFLY
	MOVE.W	A2,D0

	MOVEM.L	(A7)+,D4-D7/A2
	UNLK	A5
	RTS

;/*
;* Create a monster:
;* First look in a circle around him, next try his room
;* otherwise give up
;*/

_plop_monster:
	LINK	A5,#-$0002
	MOVEM.L	D4/D5,-(A7)

	CLR.B	-$0001(A5)
	MOVE.W	$0008(A5),D4
	SUBQ.W	#1,D4
	BRA.W	L00233
L0022D:
	MOVE.W	$000A(A5),D5
	SUBQ.W	#1,D5
	BRA	L00232
L0022E:
	CMP.W	-$52BE(A4),D4	;_player + 12
	BNE.B	L0022F

	CMP.W	-$52C0(A4),D5	;_player + 10
	BEQ.B	L00231
L0022F:
	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_offmap
	ADDQ.W	#4,A7

	TST.W	D0
	BNE.B	L00231

	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_winat
	ADDQ.W	#4,A7

	MOVE.B	D0,-$0002(A5)
	MOVEQ	#$00,D3
	MOVE.B	D0,D3

	MOVE.W	D3,-(A7)
	JSR	_step_ok
	ADDQ.W	#2,A7

	TST.W	D0
	BEQ.B	L00231

	CMP.B	#$3F,-$0002(A5)	;'?' scroll
	BNE.B	L00230

	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_find_obj
	ADDQ.W	#4,A7

	MOVEA.L	D0,A6
	CMPI.W	#S_SCAREM,$0020(A6)	;is it a scroll of scare monster?
	BEQ.B	L00231
L00230:
	ADDQ.B	#1,-$0001(A5)
	MOVEQ	#$00,D0
	MOVE.B	-$0001(A5),D0
	JSR	_rnd
	TST.W	D0
	BNE.B	L00231

	MOVEA.L	$000C(A5),A6
	MOVE.W	D4,$0002(A6)
	MOVEA.L	$000C(A5),A6
	MOVE.W	D5,(A6)
L00231:
	ADDQ.W	#1,D5
L00232:
	MOVE.W	$000A(A5),D3
	ADDQ.W	#1,D3
	CMP.W	D3,D5
	BLE.W	L0022E

	ADDQ.W	#1,D4
L00233:
	MOVE.W	$0008(A5),D3
	ADDQ.W	#1,D3
	CMP.W	D3,D4
	BLE.W	L0022D

	MOVEQ	#$00,D0
	MOVE.B	-$0001(A5),D0

	MOVEM.L	(A7)+,D4/D5
	UNLK	A5
	RTS

;/*
; * runners:
; *  Make all the running monsters move.
; */

_runners:
;	LINK	A5,#-$0000
	MOVEM.L	D4/A2,-(A7)

	MOVEA.L	-$6CAC(A4),A2	;_mlist
	BRA.W	L0023B
L00234:
	MOVE.W	$0016(A2),D3
	AND.W	#C_ISHELD,D3	;C_ISHELD
	BNE.W	L0023A

	MOVE.W	$0016(A2),D3
	AND.W	#C_ISRUN,D3	;C_ISRUN
	BEQ.W	L0023A

	MOVE.W	$000A(A2),-(A7)
	MOVE.W	$000C(A2),-(A7)
	MOVE.W	-$52C0(A4),-(A7)	;_player + 10
	MOVE.W	-$52BE(A4),-(A7)	;_player + 12
	JSR	_DISTANCE
	ADDQ.W	#8,A7

	MOVE.W	D0,D4
	MOVE.W	$0016(A2),D3
	AND.W	#C_ISSLOW,D3	;C_ISSLOW
	BNE.B	L00235

	cmp.b	#$53,$000F(A2)	;'S' slime
	BNE.B	L00236

	CMP.W	#$0003,D4
	BLE.B	L00236
L00235:
	TST.B	$000E(A2)
	BEQ.B	L00237
L00236:
	MOVE.L	A2,-(A7)
	BSR.B	_do_chase
	ADDQ.W	#4,A7
L00237:
	MOVE.W	$0016(A2),D3
	AND.W	#C_ISHASTE,D3	;C_ISHASTE
	BEQ.B	L00238

	MOVE.L	A2,-(A7)
	BSR.B	_do_chase
	ADDQ.W	#4,A7
L00238:
	MOVE.W	$000A(A2),-(A7)
	MOVE.W	$000C(A2),-(A7)
	MOVE.W	-$52C0(A4),-(A7)	;_player + 10
	MOVE.W	-$52BE(A4),-(A7)	;_player + 12
	JSR	_DISTANCE
	ADDQ.W	#8,A7
	MOVE.W	D0,D4
	MOVE.W	$0016(A2),D3	;creature flags
	AND.W	#C_ISFLY,D3	;C_ISFLY
	BEQ.B	L00239

	CMP.W	#$0003,D4
	BLE.B	L00239

	MOVE.L	A2,-(A7)
	BSR.B	_do_chase
	ADDQ.W	#4,A7
L00239:
	EORI.B	#$01,$000E(A2)
L0023A:
	MOVEA.L	(A2),A2
L0023B:
	MOVE.L	A2,D3
	BNE.W	L00234

	MOVEM.L	(A7)+,D4/A2
;	UNLK	A5
	RTS

;/*
; * do_chase:
; *  Make one thing chase another.
; */

_do_chase:
	LINK	A5,#-$000A
	MOVEM.L	D4-D7/A2/A3,-(A7)

	MOVE.W	#$7FFF,D6
	MOVEA.L	$0008(A5),A6
	MOVE.L	$002A(A6),D4	;creature room
	MOVE.W	$0016(A6),D3	;creature flags
	AND.W	#C_ISGREED,D3	;C_ISGREED
	BEQ.B	L0023C

	MOVEA.L	D4,A6
	TST.W	$000C(A6)
	BNE.B	L0023C

	MOVEA.L	$0008(A5),A6
	LEA	-$52C0(A4),A1	;_player + 10
	MOVE.L	A1,$0012(A6)
L0023C:
	MOVE.L	-$52A0(A4),D5	;_player + 42 (proom)
	MOVEA.L	$0008(A5),A6
	LEA	-$52C0(A4),A1	;_player + 10
	MOVEA.L	$0012(A6),A0
	CMPA.L	A1,A0
	BEQ.B	L0023D

	MOVE.L	$0012(A6),-(A7)
	JSR	_roomin(PC)
	ADDQ.W	#4,A7
	MOVE.L	D0,D5
L0023D:
	TST.L	D5
	BNE.B	L0023F
L0023E:
	MOVEM.L	(A7)+,D4-D7/A2/A3
	UNLK	A5
	RTS

L0023F:
	MOVEA.L	$0008(A5),A6

	MOVE.W	$000A(A6),d0
	MOVE.W	$000C(A6),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	cmp.b	#$2B,$00(A6,D0.W)	;'+' door
	BNE.B	L00240

	MOVEq	#$0001,D3
	BRA.B	L00241
L00240:
	CLR.W	D3
L00241:
	MOVE.B	D3,-$0002(A5)
L00242:
	CMP.L	D5,D4
	BEQ.W	L00247

	MOVEA.L	D4,A6
	MOVE.W	$000E(A6),D3
	AND.W	#$0004,D3
	BNE.W	L00247

	MOVEQ	#$00,D7
	BRA.B	L00245
L00243:
	MOVE.W	D7,D3
	EXT.L	D3
	ASL.L	#2,D3
	MOVEA.L	D3,A6
	ADDA.L	D4,A6
	MOVE.W	$0012(A6),-(A7)
	MOVE.W	$0014(A6),-(A7)
	MOVEA.L	$0008(A5),A6
	MOVEA.L	$0012(A6),A1
	MOVE.W	(A1),-(A7)
	MOVE.W	$0002(A1),-(A7)
	JSR	_DISTANCE
	ADDQ.W	#8,A7
	MOVE.W	D0,-$0004(A5)
	CMP.W	D6,D0
	BGE.B	L00244

	LEA	-$0008(A5),A6
	MOVE.W	D7,D3
	EXT.L	D3
	ASL.L	#2,D3
	MOVEA.L	D3,A1
	ADDA.L	D4,A1
	ADDA.L	#$00000012,A1
	MOVE.L	(A1)+,(A6)+
	MOVE.W	-$0004(A5),D6
L00244:
	ADDQ.W	#1,D7
L00245:
	MOVEA.L	D4,A6
	CMP.W	$0010(A6),D7
	BLT.B	L00243

	TST.B	-$0002(A5)
	BEQ.B	L00246

	MOVEA.L	$0008(A5),A6
	MOVE.W	$000A(A6),d0
	MOVE.W	$000C(A6),d1
	JSR	_INDEXquick

	MOVEA.L	-$5198(A4),A6	;__flags
	MOVE.B	$00(A6,D0.W),D3
	AND.W	#$000F,D3	;get the room number
	MULU.W	#66,D3
	LEA	-$5E36(A4),A6	;_passages
	MOVE.L	D3,D4
	ADD.L	A6,D4
	CLR.B	-$0002(A5)
	BRA.W	L00242
L00246:
	BRA.W	L00250
L00247:
	LEA	-$0008(A5),A6
	MOVEA.L	$0008(A5),A1
	MOVEA.L	$0012(A1),A0
	MOVE.L	(A0)+,(A6)+

	MOVEA.L	$0008(A5),A6
	MOVE.B	$000F(A6),D3
	CMP.b	#$44,D3		;'D' dragon
	BEQ.B	L00248

	CMP.b	#$49,D3		;'I' ice monster
	BNE.W	L00250
L00248:
	MOVEA.L	$0008(A5),A6

	MOVE.W	$000A(A6),D3
	CMP.W	-$52C0(A4),D3	;_player + 10
	BEQ.B	L0024D

	MOVE.W	$000C(A6),D3
	CMP.W	-$52BE(A4),D3	;_player + 12
	BEQ.B	L0024D

	SUB.W	-$52BE(A4),D3	;_player + 12
	BGE.B	L0024A

	NEG.W	D3
L0024A:
	MOVEA.L	$0008(A5),A6
	MOVE.W	$000A(A6),D2
	SUB.W	-$52C0(A4),D2	;_player + 10
	BGE.B	L0024B

	NEG.W	D2
	BRA.B	L0024C
L0024B:
	MOVEA.L	$0008(A5),A6
	MOVE.W	$000A(A6),D2
	SUB.W	-$52C0(A4),D2	;_player + 10
L0024C:
	CMP.W	D2,D3
	BNE.W	L00250
L0024D:
	MOVE.W	-$52C0(A4),-(A7)	;_player + 10
	MOVE.W	-$52BE(A4),-(A7)	;_player + 12
	MOVEA.L	$0008(A5),A6
	MOVE.W	$000A(A6),-(A7)
	MOVE.W	$000C(A6),-(A7)
	JSR	_DISTANCE
	ADDQ.W	#8,A7
	MOVE.W	D0,-$0004(A5)
	CMP.W	#$0002,D0
	BLE.W	L00250

	CMPI.W	#$0024,D0
	BGT.W	L00250

	MOVEA.L	$0008(A5),A6
	MOVE.W	$0016(A6),D3
	AND.W	#C_ISCANC,D3	;C_ISCANC
	BNE.B	L00250

	MOVEq	#$0005,D0
	JSR	_rnd
	TST.W	D0		; 20% chance to get flame/frost
	BNE.B	L00250

	CLR.B	-$66B6(A4)	;_running
	MOVEA.L	$0008(A5),A6
	MOVE.W	-$52BE(A4),D3	;_player + 12
	SUB.W	$000C(A6),D3
	MOVE.W	D3,-(A7)
	JSR	_sign
	ADDQ.W	#2,A7

	MOVE.W	D0,-$608A(A4)	;_delta + 2
	MOVEA.L	$0008(A5),A6
	MOVE.W	-$52C0(A4),D3	;_player + 10
	SUB.W	$000A(A6),D3
	MOVE.W	D3,-(A7)
	JSR	_sign
	ADDQ.W	#2,A7

	MOVE.W	D0,-$608C(A4)	;_delta + 0
	MOVEA.L	$0008(A5),A6
	CMP.b	#$44,$000F(A6)	;'D' dragon
	BNE.B	1$

	PEA	L00263(PC)	;"flame"
	BRA.B	2$
1$
	PEA	L00264(PC)	;"frost"
2$
	PEA	-$608C(A4)	;_delta + 0
	PEA	$000A(A6)
	JSR	_fire_bolt(PC)
	LEA	$000C(A7),A7
	BRA.W	L0023E
L00250:
	PEA	-$0008(A5)
	MOVE.L	$0008(A5),-(A7)
	JSR	_chase(PC)
	ADDQ.W	#8,A7
	PEA	-$52C0(A4)	;_player + 10
	PEA	-$48BC(A4)
	JSR	__ce
	ADDQ.W	#8,A7
	TST.W	D0
	BEQ.B	L00251

	MOVE.L	$0008(A5),-(A7)
	JSR	_attack
	ADDQ.W	#4,A7
	BRA.W	L0023E
L00251:
	MOVEA.L	$0008(A5),A6
	MOVE.L	$0012(A6),-(A7)
	PEA	-$48BC(A4)
	JSR	__ce
	ADDQ.W	#8,A7
	TST.W	D0
	BEQ.W	L00258

	MOVEA.L	-$6CB0(A4),A2	;_lvl_obj
	BRA.W	L00257
L00252:
	MOVEA.L	$0008(A5),A6
	MOVEA.L	A2,A1
	ADDA.L	#$0000000C,A1
	MOVEA.L	$0012(A6),A0
	CMPA.L	A1,A0
	BNE.W	L00256

	MOVE.L	A2,-(A7)
	PEA	-$6CB0(A4)	;_lvl_obj
	JSR	__detach
	ADDQ.W	#8,A7
	MOVE.L	A2,-(A7)
	MOVEA.L	$0008(A5),A6
	PEA	$002E(A6)
	JSR	__attach
	ADDQ.W	#8,A7

	MOVE.W	$000C(A2),d0
	MOVE.W	$000E(A2),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVEA.L	$0008(A5),A1
	MOVEA.L	$002A(A1),A0
	MOVE.W	$000E(A0),D3
	AND.W	#$0002,D3
	BEQ.B	L00253

	MOVEQ	#$23,D3		;'#'
	BRA.B	L00254
L00253:
	MOVEQ	#$2E,D3		;'.'
L00254:
	MOVE.B	D3,$00(A6,D0.W)
	MOVE.B	D3,-$0009(A5)
	MOVE.W	$000C(A2),-(A7)
	MOVE.W	$000E(A2),-(A7)
	JSR	_cansee(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00255

	MOVE.B	-$0009(A5),D2
	MOVE.W	$000C(A2),d1
	MOVE.W	$000E(A2),d0
	JSR	_mvaddchquick

L00255:
	MOVE.L	$0008(A5),-(A7)
	JSR	_find_dest(PC)
	ADDQ.W	#4,A7

	MOVEA.L	$0008(A5),A6
	MOVE.L	D0,$0012(A6)
	BRA.B	L00258
L00256:
	MOVEA.L	(A2),A2
L00257:
	MOVE.L	A2,D3
	BNE.W	L00252
L00258:
	MOVEA.L	$0008(A5),A6
	CMP.B	#$46,$000F(A6)	;'F' venus flytrap
	BEQ	L0023E

	MOVE.B	$0011(A6),D3
	CMP.B	#$22,D3		;'"'
	BEQ.W	L0025C

	CMP.B	#$20,D3		;' ' SPACE
	BNE.B	L0025A

	MOVE.W	$000A(A6),-(A7)
	MOVE.W	$000C(A6),-(A7)
	JSR	_cansee(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L0025A

	MOVEA.L	$0008(A5),A6
	MOVE.W	$000A(A6),d0
	MOVE.W	$000C(A6),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level

	CMP.B	#$2E,$00(A6,D0.W)	;'.' FLOOR
	BNE.B	L0025A

	MOVEA.L	$0008(A5),A6
	MOVEq	#$2E,d2		;'.' FLOOR
	MOVE.W	$000A(A6),d1
	MOVE.W	$000C(A6),d0
	JSR	_mvaddchquick

	BRA.B	L0025C
L0025A:
	MOVEA.L	$0008(A5),A6
	CMP.B	#$2E,$0011(A6)	;'.' FLOOR
	BNE.B	L0025B

	MOVE.W	$000A(A6),-(A7)
	MOVE.W	$000C(A6),-(A7)
	JSR	_cansee(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.B	L0025B

	MOVEA.L	$0008(A5),A6
	MOVEq	#$20,d2		;' ' SPACE
	MOVE.W	$000A(A6),d1
	MOVE.W	$000C(A6),d0
	JSR	_mvaddchquick

	BRA.B	L0025C
L0025B:
	MOVEA.L	$0008(A5),A6

	MOVE.B	$0011(A6),D2
	MOVE.W	$000A(A6),d1
	MOVE.W	$000C(A6),d0
	JSR	_mvaddchquick

L0025C:
	MOVEA.L	$0008(A5),A6
	MOVEA.L	$002A(A6),A3
	PEA	$000A(A6)
	PEA	-$48BC(A4)
	JSR	__ce
	ADDQ.W	#8,A7
	TST.W	D0
	BNE.B	L0025F

	PEA	-$48BC(A4)
	JSR	_roomin(PC)
	ADDQ.W	#4,A7

	MOVEA.L	$0008(A5),A6
	MOVE.L	D0,$002A(A6)	;proom
	BNE.B	1$

	MOVE.L	A3,$002A(A6)	;proom
	BRA.W	L0023E
1$
	MOVEA.L	$002A(A6),A1	;proom
	CMPA.L	A3,A1
	BEQ.B	L0025E

	MOVE.L	A6,-(A7)
	JSR	_find_dest(PC)
	ADDQ.W	#4,A7

	MOVEA.L	$0008(A5),A6
	MOVE.L	D0,$0012(A6)
L0025E:
	MOVEA.L	$0008(A5),A6
	ADDA.L	#$0000000A,A6
	LEA	-$48BC(A4),A1
	MOVE.L	(A1)+,(A6)+
L0025F:
	MOVE.L	$0008(A5),-(A7)
	BSR.B	_see_monst
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00260

	MOVE.W	-$48BC(A4),-(A7)
	MOVE.W	-$48BA(A4),-(A7)
	JSR	_mvinch(PC)
	ADDQ.W	#4,A7

	MOVEA.L	$0008(A5),A6
	MOVE.B	D0,$0011(A6)

	MOVE.B	$0010(A6),D2
	MOVE.W	-$48BC(A4),d1
	MOVE.W	-$48BA(A4),d0
	JSR	_mvaddchquick

	BRA.B	L00261
L00260:
	MOVEA.L	$0008(A5),A6
	MOVE.B	#$22,$0011(A6)	;'"'
L00261:
	MOVEA.L	$0008(A5),A6
	CMP.B	#$2E,$0011(A6)	;'.'
	BNE.B	L00262

	MOVE.L	A3,-(A7)
	JSR	_is_dark
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00262

	MOVEA.L	$0008(A5),A6
	MOVE.B	#$20,$0011(A6)	;' '
L00262:
	BRA.W	L0023E

L00263:	dc.b	"flame",0
L00264:	dc.b	"frost",0

;/*
; * see_monst:
; *  Return TRUE if the hero can see the monster
; */

_see_monst:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BEQ.B	L00266

L00268:
	MOVEQ	#$00,D0		;zero means can't see the monster
L00265:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L00266:
	MOVE.W	$0016(A2),D3
	AND.W	#C_ISINVIS,D3	;C_ISINVIS
	BEQ.B	L00267

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_CANSEE,D3	;C_CANSEE
	BEQ.B	L00268
L00267:
	MOVE.W	-$52C0(A4),-(A7)	;_player + 10
	MOVE.W	-$52BE(A4),-(A7)	;_player + 12
	MOVE.W	$000A(A2),-(A7)
	MOVE.W	$000C(A2),-(A7)
	JSR	_DISTANCE
	ADDQ.W	#8,A7
	CMP.W	#$0003,D0
	BLT.B	L00269

	MOVEA.L	$002A(A2),A6
	CMPA.L	-$52A0(A4),A6	;_player + 42 (proom)
	BNE.B	L00268
	MOVE.L	$002A(A2),-(A7)
	JSR	_is_dark
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.B	L00268

	MOVEA.L	$002A(A2),A6
	MOVE.W	$000E(A6),D3
	AND.W	#$0004,D3
	BNE.B	L00268
L00269:
	MOVEQ	#$01,D0
	BRA.B	L00265

;/*
; * runto:
; *  Set a monster running after the hero.
; */

_start_run:
	LINK	A5,#-$0000
	MOVEM.L	A2/A3,-(A7)
	MOVEA.L	$0008(A5),A2

	MOVE.W	(A2),d1
	MOVE.W	$0002(A2),d0
	JSR	_moatquick

	TST.L	D0
	BEQ.B	1$
	MOVEA.L	D0,A3

	ORI.W	#C_ISRUN,$0016(A3)	;set C_ISRUN
	ANDI.W	#~C_ISHELD,$0016(A3)	;clear C_ISHELD
	MOVE.L	A3,-(A7)
	JSR	_find_dest(PC)
	ADDQ.W	#4,A7
	MOVE.L	D0,$0012(A3)
1$
	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

;/*
; * chase:
; *  Find the spot for the chaser(er) to move closer to the
; *  chasee(ee).  Returns TRUE if we want to keep on chasing later
; *  FALSE if we reach the goal.
; */

_chase:
	LINK	A5,#-$0010
	MOVEM.L	D4-D7/A2,-(A7)

	MOVE.W	#$0001,-$000C(A5)
	MOVE.L	$0008(A5),A6
	move.l	a6,d3
	ADD.L	#$0000000A,D3
	MOVE.L	D3,-$0008(A5)

	MOVE.W	$0016(A6),D3
	AND.W	#C_ISHUH,D3	;C_ISHUH
	BEQ.B	L0026B

	MOVEq	#$0005,D0
	JSR	_rnd
	TST.W	D0
	BNE.B	L0026D
L0026B:
	MOVEA.L	$0008(A5),A6
	MOVE.B	$000F(A6),D3
;	EXT.W	D3
	CMP.b	#$50,D3		;'P' phantom, 20% confused
	BNE.B	1$

	MOVEq	#$0005,D0
	JSR	_rnd
	TST.W	D0
	BEQ.B	L0026D
1$
	MOVEA.L	$0008(A5),A6
	MOVE.B	$000F(A6),D3
;	EXT.W	D3
	CMP.b	#$42,D3		;'B' bat, 50% confused
	BNE.B	L0026F

	MOVEq	#$0002,D0
	JSR	_rnd
	TST.W	D0
	BNE.B	L0026F
L0026D:
	PEA	-$48BC(A4)
	MOVE.L	$0008(A5),-(A7)
	JSR	_rndmove(PC)
	ADDQ.W	#8,A7
	MOVEA.L	$000C(A5),A6
	MOVE.W	(A6),-(A7)
;	MOVEA.L	$000C(A5),A6
	MOVE.W	$0002(A6),-(A7)
	MOVE.W	-$48BC(A4),-(A7)
	MOVE.W	-$48BA(A4),-(A7)
	JSR	_DISTANCE
	ADDQ.W	#8,A7
	MOVE.W	D0,-$0002(A5)

	MOVEq	#30,D0
	JSR	_rnd
	CMP.W	#17,D0
	BNE.B	L0026E

	MOVEA.L	$0008(A5),A6
	ANDI.W	#~C_ISHUH,$0016(A6)	;clear C_ISHUH
L0026E:
	BRA.W	L0027B
L0026F:
	MOVEA.L	$000C(A5),A6
	MOVE.W	(A6),-(A7)
;	MOVEA.L	$000C(A5),A6
	MOVE.W	$0002(A6),-(A7)
	MOVEA.L	-$0008(A5),A6
	MOVE.W	(A6),-(A7)
;	MOVEA.L	-$0008(A5),A6
	MOVE.W	$0002(A6),-(A7)
	JSR	_DISTANCE
	ADDQ.W	#8,A7
	MOVE.W	D0,-$0002(A5)
	LEA	-$48BC(A4),A6
	MOVEA.L	-$0008(A5),A1
	MOVE.L	(A1)+,(A6)+
	MOVEA.L	-$0008(A5),A6
	MOVE.W	$0002(A6),D6
	ADDQ.W	#1,D6
;	MOVEA.L	-$0008(A5),A6
	MOVE.W	(A6),D7
	ADDQ.W	#1,D7
;	MOVEA.L	-$0008(A5),A6
	MOVE.W	(A6),D4
	SUBQ.W	#1,D4
	BRA.W	L0027A
L00270:
	MOVEA.L	-$0008(A5),A6
	MOVE.W	$0002(A6),D5
	SUBQ.W	#1,D5
	BRA.W	L00279
L00271:
	MOVE.W	D4,-$0010(A5)
	MOVE.W	D5,-$000E(A5)
	MOVE.W	D4,-(A7)
	MOVE.W	D5,-(A7)
	JSR	_offmap
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.W	L00278

	PEA	-$0010(A5)
	MOVE.L	-$0008(A5),-(A7)
	JSR	_diag_ok(PC)
	ADDQ.W	#8,A7
	TST.W	D0
	BEQ.W	L00278

	MOVE.W	D4,-(A7)
	MOVE.W	D5,-(A7)
	JSR	_winat
	ADDQ.W	#4,A7
	MOVE.B	D0,-$0009(A5)
	MOVEQ	#$00,D3
	MOVE.B	-$0009(A5),D3
	MOVE.W	D3,-(A7)
	JSR	_step_ok
	ADDQ.W	#2,A7
	TST.W	D0
	BEQ.W	L00278

;	MOVEQ	#$00,D3
	MOVE.B	-$0009(A5),D3
	CMP.b	#$3F,D3		;'?' scrolls
	BNE.B	L00276

	MOVEA.L	-$6CB0(A4),A2	;_lvl_obj
	BRA.B	L00274
L00272:
	CMP.W	$000E(A2),D5
	BNE.B	L00273

	CMP.W	$000C(A2),D4
	BEQ.B	L00275
L00273:
	MOVEA.L	(A2),A2
L00274:
	MOVE.L	A2,D3
	BNE.B	L00272
L00275:
	MOVE.L	A2,D3
	BEQ.B	L00276

	CMPI.W	#S_SCAREM,$0020(A2)	; scroll of scare monster
	BEQ.B	L00278
L00276:
	MOVEA.L	$000C(A5),A6
	MOVE.W	(A6),-(A7)
;	MOVEA.L	$000C(A5),A6
	MOVE.W	$0002(A6),-(A7)
	MOVE.W	D4,-(A7)
	MOVE.W	D5,-(A7)
	JSR	_DISTANCE
	ADDQ.W	#8,A7
	MOVE.W	D0,-$0004(A5)
	MOVE.W	-$0004(A5),D3
	CMP.W	-$0002(A5),D3
	BGE.B	L00277

	MOVE.W	#$0001,-$000C(A5)
	LEA	-$48BC(A4),A6
	LEA	-$0010(A5),A1
	MOVE.L	(A1)+,(A6)+
	MOVE.W	-$0004(A5),-$0002(A5)
	BRA.B	L00278
L00277:
	MOVE.W	-$0004(A5),D3
	CMP.W	-$0002(A5),D3
	BNE.B	L00278

	ADDQ.W	#1,-$000C(A5)
	MOVE.W	-$000C(A5),D0
	JSR	_rnd
	TST.W	D0
	BNE.B	L00278

	LEA	-$48BC(A4),A6
	LEA	-$0010(A5),A1
	MOVE.L	(A1)+,(A6)+
	MOVE.W	-$0004(A5),-$0002(A5)
L00278:
	ADDQ.W	#1,D5
L00279:
	CMP.W	D6,D5
	BLE.W	L00271

	ADDQ.W	#1,D4
L0027A:
	CMP.W	D7,D4
	BLE.W	L00270
L0027B:
	MOVEM.L	(A7)+,D4-D7/A2
	UNLK	A5
	RTS

;/*
; * roomin:
; *  Find what room some coordinates are in. NULL means they aren't
; *  in any room.
; */

_roomin:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	LEA	-$6088(A4),A6	;_rooms
	MOVEA.L	A6,A3
L0027C:
	MOVE.W	(A3),D3
	ADD.W	$0004(A3),D3
	MOVE.W	(A2),D2
	CMP.W	D3,D2
	BGE.B	L0027E

	MOVE.W	(A3),D3
	CMP.W	(A2),D3
	BGT.B	L0027E

	MOVE.W	$0002(A3),D3
	ADD.W	$0006(A3),D3
	MOVE.W	$0002(A2),D2
	CMP.W	D3,D2
	BGE.B	L0027E

	MOVE.W	$0002(A3),D3
	CMP.W	$0002(A2),D3
	BGT.B	L0027E
	MOVE.L	A3,D0
L0027D:
	MOVEM.L	(A7)+,D4/A2/A3
	UNLK	A5
	RTS

L0027E:
	ADDA.L	#$00000042,A3
	LEA	-$5E78(A4),A6
	CMPA.L	A6,A3
	BLS.B	L0027C

	MOVE.W	(A2),d0
	MOVE.W	$0002(A2),d1
	JSR	_INDEXquick

	EXT.L	D0
	MOVE.L	D0,D4
	ADD.L	-$5198(A4),D4	;__flags
	MOVEA.L	D4,A6
	MOVE.B	(A6),D3
	AND.W	#$0040,D3	;room flags?
	BEQ.B	L0027F

;	MOVEA.L	D4,A6
;	MOVEQ	#$00,D0
	MOVE.B	(A6),D0
	AND.W	#$000F,D0
	MULU.W	#66,D0
	LEA	-$5E36(A4),A6	;_passages
	ADD.L	A6,D0
	BRA.B	L0027D
L0027F:
	ADDQ.B	#1,-$66AD(A4)	;_bailout
	MOVE.W	(A2),-(A7)
	MOVE.W	$0002(A2),-(A7)
	PEA	L00280(PC)	;"Roomin bailout, in some bizzare place %d,%d"
	JSR	_db_print
	ADDQ.W	#8,A7
	MOVEQ	#$00,D0
	BRA.B	L0027D

L00280:	dc.b	"Roomin bailout, in some bizzare place %d,%d",10,0,0

;/*
; * diag_ok:
; *  Check to see if the move is legal if it is diagonal
; */

_diag_ok:
	LINK	A5,#-$0000
	MOVEM.L	A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVEA.L	$000C(A5),A3
	MOVE.W	(A3),D3
	CMP.W	(A2),D3
	BEQ.B	L00281

	MOVE.W	$0002(A3),D3
	CMP.W	$0002(A2),D3
	BNE.B	L00283
L00281:
	MOVEQ	#$01,D0
L00282:
	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

L00283:
	MOVE.W	(A2),d0
	MOVE.W	$0002(A3),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	MOVE.W	D3,-(A7)

	JSR	_step_ok
	ADDQ.W	#2,A7

	TST.W	D0
	BEQ.B	L00282

	MOVE.W	(A3),d0
	MOVE.W	$0002(A2),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	MOVE.W	D3,-(A7)

	JSR	_step_ok
	ADDQ.W	#2,A7
	BRA.B	L00282

;/*
; * cansee:
; *  Returns true if the hero can see a certain coordinate.
; */

_cansee:
	LINK	A5,#-$0004
	MOVEM.L	D4/D5/A2,-(A7)

	MOVE.W	$0008(A5),D4
	MOVE.W	$000A(A5),D5

	MOVEq	#C_ISBLIND,D3	;C_ISBLIND
	AND.W	-$52B4(A4),D3	;_player + 22 (flags)
	BEQ.B	L00287

L00289:
	MOVEQ	#$00,D0
L00286:
	MOVEM.L	(A7)+,D4/D5/A2
	UNLK	A5
	RTS

L00287:
	MOVE.W	-$52C0(A4),-(A7)	;_player + 10
	MOVE.W	-$52BE(A4),-(A7)	;_player + 12
	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_DISTANCE
	ADDQ.W	#8,A7

	CMP.W	#$0003,D0
	BGE.B	L00288

	MOVEQ	#$01,D0
	BRA.B	L00286
L00288:
	MOVE.W	D4,-$0002(A5)
	MOVE.W	D5,-$0004(A5)

	PEA	-$0004(A5)
	JSR	_roomin(PC)
	ADDQ.W	#4,A7
	CMP.L	-$52A0(A4),D0	;_player + 42 (proom)
	BNE.B	L00289

	MOVE.L	D0,-(A7)
	JSR	_is_dark
	ADDQ.W	#4,A7
	TST.W	D0
	SEQ	D0
	BRA.B	L00286

;/*
; * find_dest:
; *  find the proper destination for the monster
; */

_find_dest:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5/A2/A3,-(A7)
	MOVEA.L	$0008(A5),A2
	MOVE.B	$000F(A2),D3
	EXT.W	D3
	SUB.W	#$0041,D3	;'A'
	MULU.W	#26,D3
	LEA	-$6CA4(A4),A6	;_monsters + 4
	TST.W	$00(A6,D3.L)
	BLE.B	L0028B		;does the monster carry?

	MOVEA.L	$002A(A2),A6
	CMPA.L	-$52A0(A4),A6	;_player + 42 (proom)
	BEQ.B	L0028B

	MOVE.L	A2,-(A7)
	JSR	_see_monst(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L0028D
L0028B:
	LEA	-$52C0(A4),A6	;_player + 10
	MOVE.L	A6,D0
L0028C:
	MOVEM.L	(A7)+,D4/D5/A2/A3
	UNLK	A5
	RTS

L0028D:
	MOVE.L	$002A(A2),D5
	MOVEA.L	-$6CB0(A4),A3	;_lvl_obj
	BRA.B	L00294
L0028E:
	CMPI.W	#$003F,$000A(A3)	;'?'
	BNE.B	L0028F

	CMPI.W	#S_SCAREM,$0020(A3)	;scroll of scare monster
	BEQ.B	L00293
L0028F:
	PEA	$000C(A3)
	JSR	_roomin(PC)
	ADDQ.W	#4,A7
	CMP.L	D5,D0
	BNE.B	L00293

	MOVEq	#100,D0
	JSR	_rnd
	CMP.W	D4,D0
	BGE.B	L00293

	MOVEA.L	-$6CAC(A4),A2	;_mlist
	BRA.B	L00291
L00290:
	MOVEA.L	A3,A6
	ADDA.L	#$0000000C,A6
	MOVEA.L	$0012(A2),A1
	CMPA.L	A6,A1
	BEQ.B	L00292

	MOVEA.L	(A2),A2
L00291:
	MOVE.L	A2,D3
	BNE.B	L00290
L00292:
	MOVE.L	A2,D3
	BNE.B	L00293

	MOVE.L	A3,D0
	ADD.L	#$0000000C,D0
	BRA.B	L0028C
L00293:
	MOVEA.L	(A3),A3
L00294:
	MOVE.L	A3,D3
	BNE.B	L0028E

	LEA	-$52C0(A4),A6	;_player + 10
	MOVE.L	A6,D0
	BRA.B	L0028C

;/*
; * leave_pack:
; *  take an item out of the pack
; */

_unpack:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	$0008(A5),A6
	CMPI.W	#$0001,$001E(A6)	;one item?
	BLE.W	L0029E

	TST.W	$000C(A5)
	BEQ.B	L00299

	JSR	_new_item
	MOVEA.L	D0,A2
	TST.L	D0
	BEQ.B	L00297

	MOVEA.L	A2,A6
	MOVEA.L	$0008(A5),A1

	MOVEQ	#$0B,D3
L00295:
	MOVE.L	(A1)+,(A6)+	;we make a copy of the item to split it up
	DBF	D3,L00295
	MOVE.W	(A1)+,(A6)+

	MOVE.W	#$0001,$001E(A2)
	MOVEA.L	$0008(A5),A6
	SUBQ.W	#1,$001E(A6)

	MOVE.W	#$0001,-(A7)
	MOVE.L	A6,-(A7)
	BSR.B	_pack_name
	ADDQ.W	#6,A7
	MOVEA.L	$0008(A5),A6
	TST.W	$002C(A6)
	BNE.B	L00296

	SUBQ.W	#1,-$60AA(A4)	;_inpack
L00296:
	MOVE.L	A2,D0
L00297:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L00299:
	MOVEA.L	$0008(A5),A6
	moveq	#1,d3

	TST.W	$001E(A6)	;zero means one item
	BEQ.B	1$

	TST.W	$002C(A6)	;is it in a group?
	BNE.B	1$

	MOVE.W	$001E(A6),D3	;get number of items

1$	SUB.W	D3,-$60AA(A4)	;_inpack
	BRA.B	L0029F
L0029E:
	SUBQ.W	#1,-$60AA(A4)	;_inpack
L0029F:
	MOVE.L	$0008(A5),-(A7)
	PEA	-$529C(A4)	;_player + 46 (pack)
	JSR	__detach
	ADDQ.W	#8,A7
	CLR.W	-(A7)
	MOVE.L	$0008(A5),-(A7)
	BSR.B	_pack_name
	ADDQ.W	#6,A7

	MOVEA.L	$0008(A5),A6
	CMPI.W	#$002C,$000A(A6)	;did we unpack the amulet?
	BNE.B	L002A0

	CLR.B	-$66BD(A4)	;_amulet
L002A0:
	MOVE.L	$0008(A5),D0
	BRA.B	L00297

_pack_name:
	LINK	A5,#-$0000
	MOVEM.L	A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	TST.L	$0010(A2)
	BEQ.B	L002A1

	MOVE.L	$0010(A2),-(A7)
	JSR	_free
	ADDQ.W	#4,A7

	CLR.L	$0010(A2)
L002A1:
	TST.W	$000C(A5)	;zero here means we just delete the entry
	BEQ.B	L002A2

	MOVE.W	#$FFFF,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_nameof
	ADDQ.W	#6,A7

	MOVEA.L	D0,A0
	MOVE.L	A0,-(A7)
	JSR	_strlenquick

	ADDQ.W	#1,D0
	MOVE.W	D0,-(A7)
	JSR	_newmem
	ADDQ.W	#2,A7

	MOVE.L	D0,-(A7)
	JSR	_strcpy
	ADDQ.W	#8,A7
	MOVE.L	D0,$0010(A2)
L002A2:
	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

;/*
; * pack_char:
; *  Return the next unused pack character.
; */

_pack_obj:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2,-(A7)

	MOVEA.L	-$529C(A4),A2	;_player + 46 (pack)
	MOVEQ	#$61,D4	;'a'
	BRA.B	L002A6

L002A3:
	CMP.B	$0009(A5),D4
	BEQ.B	L002A5

	MOVEA.L	(A2),A2		;get next item from pack
	ADDQ.B	#1,D4
L002A6:
	MOVE.L	A2,D3		;null check for item
	BNE.B	L002A3

	MOVEA.L	$000A(A5),A6
	MOVE.B	D4,(A6)
	MOVEQ	#$00,D0
	BRA.B	L002A4

L002A5:
	MOVE.L	A2,D0
L002A4:
	MOVEM.L	(A7)+,D4/A2
	UNLK	A5
	RTS

;/*
; * add_pack:
; *  Pick up an object and add it to the pack.  If the argument is
; *  non-null use it as the linked_list pointer instead of gettting
; *  it off the ground.
; */

_add_pack:
	LINK	A5,#-$0000
	MOVEM.L	D4-D7/A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVE.L	A2,D3
	BNE.B	L002A9

	MOVEQ	#$01,D6

	MOVE.W	-$52C0(A4),-(A7)	;_player + 10
	MOVE.W	-$52BE(A4),-(A7)	;_player + 12
	JSR	_find_obj
	ADDQ.W	#4,A7

	MOVEA.L	D0,A2
	TST.L	D0
	BNE.B	L002AA
L002A7:
	MOVEM.L	(A7)+,D4-D7/A2/A3
	UNLK	A5
	RTS

L002A9:
	MOVEQ	#$00,D6
L002AA:
	MOVEA.L	-$52A0(A4),A6	;_player + 42 (proom)
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3	;ISGONE?

	BEQ.B	L002AB
	MOVEQ	#$23,D3		;'#' PASSAGE
	BRA.B	L002AC
L002AB:
	MOVEQ	#$2E,D3		;'.' FLOOR
L002AC:
	MOVE.B	D3,D7
	TST.W	$002C(A2)	;is it in a group?
	BEQ.B	L002B1

	MOVEA.L	-$529C(A4),A3	;_player + 46 (pack)
	BRA.B	L002B0
L002AD:
	MOVE.W	$002C(A3),D3
	CMP.W	$002C(A2),D3	;compare groups
	BNE.B	L002AF

	MOVE.W	$001E(A2),D3	;how many items was it
	ADD.W	D3,$001E(A3)
	TST.B	D6
	BEQ.B	L002AE

	MOVE.L	A2,-(A7)
	PEA	-$6CB0(A4)	;_lvl_obj
	JSR	__detach
	ADDQ.W	#8,A7

	MOVE.B	D7,D2
	MOVE.W	-$52C0(A4),d1	;_player + 10
	MOVE.W	-$52BE(A4),d0	;_player + 12
	JSR	_mvaddchquick

	JSR	_INDEXplayer

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	D7,$00(A6,D0.W)
L002AE:
	MOVE.L	A2,-(A7)
	JSR	_discard
	ADDQ.W	#4,A7
	MOVEA.L	A3,A2
	BRA.W	L002C6
L002AF:
	MOVEA.L	(A3),A3		;get next item from player pack
L002B0:
	MOVE.L	A3,D3		;and repeat the check if there is one
	BNE.B	L002AD

L002B1:
	CMPI.W	#22,-$60AA(A4)	;_inpack, max items in inventory
	BLT.B	L002B2

	PEA	L002CC(PC)	;"you can't carry anything else"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L002A7
L002B2:
	CMPI.W	#$003F,$000A(A2)	;'?' scroll
	BNE.B	L002B4

	CMPI.W	#S_SCAREM,$0020(A2)	;scroll of scare monster
	BNE.B	L002B4

	MOVE.W	$0028(A2),D3		;load object flags
	AND.W	#O_SCAREUSED,D3	;unused?
	BEQ.B	L002B3

	MOVE.L	A2,-(A7)
	PEA	-$6CB0(A4)	;_lvl_obj
	JSR	__detach
	ADDQ.W	#8,A7

	MOVE.B	D7,D2
	MOVE.W	-$52C0(A4),d1	;_player + 10
	MOVE.W	-$52BE(A4),d0	;_player + 12
	JSR	_mvaddchquick

	JSR	_INDEXplayer

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	D7,$00(A6,D0.W)

	LEA	L002CE(PC),a0	;" as you pick it up"
	JSR	_noterse

	MOVE.L	D0,-(A7)
	PEA	L002CD(PC)	;"the scroll turns to dust%s."
	JSR	_msg
	ADDQ.W	#8,A7

	BRA.W	L002A7
L002B3:
	ORI.W	#O_SCAREUSED,$0028(A2)	;set scare bit used
L002B4:
	ADDQ.W	#1,-$60AA(A4)	;_inpack++
	TST.B	D6
	BEQ.B	L002B5

	MOVE.L	A2,-(A7)
	PEA	-$6CB0(A4)	;_lvl_obj
	JSR	__detach
	ADDQ.W	#8,A7

	MOVE.B	D7,D2
	MOVE.W	-$52C0(A4),d1	;_player + 10
	MOVE.W	-$52BE(A4),d0	;_player + 12
	JSR	_mvaddchquick

	JSR	_INDEXplayer

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	D7,$00(A6,D0.W)
L002B5:
	MOVEQ	#$00,D5
	MOVEA.L	-$529C(A4),A3	;_player + 46 (pack)

	MOVE.L	A2,-(A7)
	JSR	_typeof
	ADDQ.W	#4,A7
	move.b	D0,D7		;keep the type of the item we are looking for in D7

	BRA.B	L002B7
L002B6:
	MOVE.L	A3,-(A7)
	JSR	_typeof
	ADDQ.W	#4,A7

	CMP.B	D7,D0		;both items of the same type?
	BEQ.B	L002B8

	MOVEA.L	(A3),A3		;if not load the next item in pack
L002B7:
	MOVE.L	A3,D3		;and if there is one repeat the check
	BNE.B	L002B6
L002B8:
	MOVE.L	A3,D3		;did we find something?
	BNE.B	L002BC

	MOVEA.L	-$529C(A4),A3	;_player + 46 (pack)
	BRA.B	L002BA
L002B9:
	CMPI.W	#$003A,$000A(A3)	;':' food
	BNE.B	L002BE

	MOVE.L	A3,D4		;if we had food rembember the pointer to it
	MOVEA.L	(A3),A3		;and get the next item in pack
L002BA:
	MOVE.L	A3,D3
	BNE.B	L002B9
	BRA.B	L002BE		;we maybe have the last match in D4
L002BC:
	MOVE.L	A2,-(A7)
	JSR	_typeof
	ADDQ.W	#4,A7

	MOVE.B	D0,D7
L002BCb:
	MOVE.L	A3,-(A7)
	JSR	_typeof
	ADDQ.W	#4,A7

	CMP.B	D7,D0		;compare the types
	BNE.B	L002BE

	MOVE.W	$0020(A3),D3	;compare the subtypes
	CMP.W	$0020(A2),D3
	BNE.B	L002BD

	MOVEQ	#$01,D5
	BRA.B	L002BE
L002BD:
	MOVE.L	A3,D4		;found a match, remember it
	MOVEA.L	(A3),A3
	MOVE.L	A3,D3
	BEQ.B	L002BE
	BRA.B	L002BCb
L002BE:
	MOVE.L	A3,D3		;is there another item in the pack?
	BNE.B	L002C1

	TST.L	-$529C(A4)	;_player + 46 (pack)
	BNE.B	L002BF

	MOVE.L	A2,-$529C(A4)	;_player + 46 (pack)
	BRA.B	L002C6
L002BF:
	MOVEA.L	D4,A6
	MOVE.L	A2,(A6)
	MOVE.L	D4,$0004(A2)
	CLR.L	(A2)
	BRA.B	L002C6
L002C1:
	TST.B	D5
	BEQ.B	L002C3
	CMPI.W	#$0021,$000A(A2)	;'!' potion
	BEQ.B	L002C2
	CMPI.W	#$003F,$000A(A2)	;'?' scroll
	BEQ.B	L002C2
	CMPI.W	#$003A,$000A(A2)	;':' food
	BEQ.B	L002C2
	CMPI.W	#$002A,$000A(A2)	;'*' gold
	BNE.B	L002C3
L002C2:
	ADDQ.W	#1,$001E(A3)	;one item

	MOVE.L	A2,-(A7)
	JSR	_discard
	ADDQ.W	#4,A7
	MOVEA.L	A3,A2
	BRA.B	L002C6

L002C3:
	MOVE.L	$0004(A3),$0004(A2)
;	TST.L	$0004(A3)
	BEQ.B	L002C4

	MOVEA.L	$0004(A2),A6
	MOVE.L	A2,(A6)
	BRA.B	L002C5
L002C4:
	MOVE.L	A2,-$529C(A4)	;_player + 46 (pack)
L002C5:
	MOVE.L	A3,(A2)
	MOVE.L	A2,$0004(A3)
L002C6:
	MOVEA.L	-$6CAC(A4),A3	;_mlist
	BRA.B	L002C9
L002C7:
	MOVEA.L	A2,A6
	ADDA.L	#$0000000C,A6
	CMPA.L	$0012(A3),A6
	BNE.B	L002C8

	LEA	-$52C0(A4),A6	;_player + 10
	MOVE.L	A6,$0012(A3)
L002C8:
	MOVEA.L	(A3),A3
L002C9:
	MOVE.L	A3,D3
	BNE.B	L002C7

	CMPI.W	#$002C,$000A(A2)	;',' amulet of yendor
	BNE.B	L002CA

	ST	-$66BD(A4)	;_amulet
	ST	-$66BC(A4)	;_saw_amulet
L002CA:
	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_pack_name(PC)
	ADDQ.W	#6,A7

	TST.B	$000D(A5)
	BNE.B	L002CB

	MOVE.L	A2,-(A7)
	JSR	_pack_char(PC)
	ADDQ.W	#4,A7

	MOVE.W	D0,-(A7)
	MOVE.W	#$005E,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_nameof
	ADDQ.W	#6,A7

	MOVE.L	D0,-(A7)
	PEA	L002CF(PC)	;"You now have %s(%c)."
	JSR	_msg
	LEA	$000A(A7),A7
L002CB:
	BRA.W	L002A7

L002CC:	dc.b	"you can't carry anything else",0
L002CD:	dc.b	"the scroll turns to dust%s.",0
L002CE:	dc.b	" as you pick it up",0
L002CF:	dc.b	"You now have %s(%c).",0

;/*
; * inventory:
; *  List what is in the pack.  Return TRUE if there is something of
; *  the given type.
; */

_inventory:
	LINK	A5,#-$0056
	MOVEM.L	D4-D7,-(A7)

	MOVE.W	$000C(A5),D4
	MOVEQ	#$00,D6
	JSR	_clr_sel_chr(PC)
	MOVEQ	#$61,D5		;'a'
	BRA.W	L002D6
L002D0:
	MOVE.L	$0008(A5),-(A7)
	JSR	_typeof
	ADDQ.W	#4,A7
	MOVE.W	D0,D7
	TST.W	D4
	BEQ.B	L002D2

	CMP.W	D7,D4
	BEQ.B	L002D2

	CMP.W	#$FFFF,D4	; -1
	BNE.B	L002D1

	CMP.W	#$003F,D7	; '?' scroll
	BEQ.B	L002D2
	CMP.W	#$0021,D7	; '!' potion
	BEQ.B	L002D2
	CMP.W	#$003D,D7	; '=' ring
	BEQ.B	L002D2
	CMP.W	#$002F,D7	; '/' stick
	BEQ.B	L002D2
L002D1:
	CMP.W	#$006D,D4	; 'm' weapon type
	BNE.B	L002D5
	CMP.W	#$0021,D7	; '!' potion
	BNE.B	L002D5
L002D2:
	ADDQ.W	#1,D6
	MOVEQ	#$00,D3
	MOVE.B	D5,D3
	MOVE.W	D3,-(A7)
	PEA	L002DA(PC)	;"%c)   %%s"
	PEA	-$0050(A5)
	JSR	_sprintf
	LEA	$000A(A7),A7
	MOVEA.L	$0008(A5),A6
	MOVE.L	$0010(A6),-(A7)
	PEA	-$0050(A5)
	MOVE.L	$000E(A5),-(A7)
	JSR	_add_line(PC)
	LEA	$000C(A7),A7
	MOVE.W	D0,-$0056(A5)
	CMPI.W	#$0020,-$0056(A5)
	BEQ.B	L002D4

	CLR.W	-$54BC(A4)	;former function _end_add() inlined
	CLR.B	-$54BA(A4)
	JSR	_wmap

	MOVE.W	-$0056(A5),D0
L002D3:
	MOVEM.L	(A7)+,D4-D7
	UNLK	A5
	RTS

L002D4:
	PEA	-$0054(A5)
	PEA	-$0052(A5)
	JSR	_getrc
	ADDQ.W	#8,A7

	MOVEq	#$0002,d1
	MOVE.W	-$0052(A5),d0
	JSR	_movequick

	MOVEA.L	$0008(A5),A6
	MOVE.W	$000A(A6),-(A7)
	JSR	__graphch(PC)
	ADDQ.W	#2,A7
L002D5:
	ADDQ.B	#1,D5
	MOVEA.L	$0008(A5),A6
	MOVE.L	(A6),$0008(A5)
L002D6:
	TST.L	$0008(A5)
	BNE.W	L002D0

	TST.W	D6
	BNE.B	L002D9

	TST.W	D4
	BNE.B	L002D7

	LEA	L002DB(PC),A6	;"you are empty handed"
	MOVE.L	A6,D3
	BRA.B	L002D8
L002D7:
	LEA	L002DC(PC),A6	;"you don't have anything appropriate"
	MOVE.L	A6,D3
L002D8:
	MOVE.L	D3,-(A7)
	JSR	_msg
	ADDQ.W	#4,A7
	MOVEQ	#$00,D0
	BRA.B	L002D3
L002D9:
	MOVE.L	$000E(A5),-(A7)
	JSR	_end_line(PC)
	ADDQ.W	#4,A7
	BRA.B	L002D3

L002DA:	dc.b	"%c)   %%s",0
L002DB:	dc.b	"you are empty handed",0
L002DC:	dc.b	"you don't have anything appropriate",0,0

;/*
; * pick_up:
; *  Add something to characters pack.
; */

_pick_up:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	CMP.b	#$2A,$0009(A5)	;'*' gold
	BNE.B	L002DF

	MOVE.W	-$52C0(A4),-(A7)	;_player + 10
	MOVE.W	-$52BE(A4),-(A7)	;_player + 12
	JSR	_find_obj
	ADDQ.W	#4,A7
	MOVEA.L	D0,A2
	TST.L	D0
	BEQ.B	L002DD

	MOVE.W	$0026(A2),-(A7)
	JSR	_money(PC)
	ADDQ.W	#2,A7

	MOVE.L	A2,-(A7)
	PEA	-$6CB0(A4)	;_lvl_obj
	JSR	__detach
	ADDQ.W	#8,A7

	MOVE.L	A2,-(A7)
	JSR	_discard
	ADDQ.W	#4,A7

	MOVEA.L	-$52A0(A4),A6	;_player + 42 (proom)
	CLR.W	$000C(A6)
	BRA.B	L002DD

L002DF:
	CLR.L	-(A7)
	CLR.L	-(A7)
	JSR	_add_pack(PC)
	ADDQ.W	#8,A7
L002DD:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

;/*
; * get_item:
; *  Pick something out of a pack for a purpose
; */

_get_item:
	LINK	A5,#-$0004
	MOVEM.L	D4/A2,-(A7)
	CLR.W	-$0004(A5)
	CMP.B	#$02,-$66AA(A4)	;_menu_style
	BNE.B	L002E1

	PEA	L002F2(PC)	;"eat"
	MOVE.L	$0008(A5),-(A7)
	JSR	_strcmp
	ADDQ.W	#8,A7
	TST.W	D0
	BEQ.B	L002E1

	PEA	L002F3(PC)	;"drop"
	MOVE.L	$0008(A5),-(A7)
	JSR	_strcmp
	ADDQ.W	#8,A7
	TST.W	D0
	BNE.B	L002E2
L002E1:
	CMP.B	#$01,-$66AA(A4)	;_menu_style
	BEQ.B	L002E2

	TST.B	-$66B1(A4)	;_com_from_menu
	BEQ.B	L002E3
L002E2:
	MOVE.W	#$0001,-$0004(A5)
L002E3:
	MOVE.B	-$66F7(A4),-$0002(A5)	;_again
	TST.L	-$529C(A4)	;_player + 46 (pack)
	BNE.B	L002E4

	PEA	L002F4(PC)	;"you aren't carrying anything"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L002F1
L002E4:
	MOVE.B	-$54DC(A4),D4
L002E5:
	TST.B	-$0002(A5)
	BEQ.B	L002E6

	PEA	-$0001(A5)
	MOVEQ	#$00,D3
	MOVE.B	D4,D3
	MOVE.W	D3,-(A7)
	JSR	_pack_obj(PC)
	ADDQ.W	#6,A7
	CMP.L	-$77B0(A4),D0
	BEQ.B	L002E9
L002E6:
	TST.W	-$0004(A5)
	BEQ.B	L002E7

	MOVEQ	#$2A,D4		;'*'
	BRA.B	L002E9
L002E7:
	TST.B	-$66B2(A4)	;_terse
	BNE.B	L002E8

	TST.B	-$66AB(A4)	;_expert
	BNE.B	L002E8

	PEA	L002F5(PC)	;"which object do you want to "
	JSR	_addmsg
	ADDQ.W	#4,A7
L002E8:
	MOVE.L	$0008(A5),-(A7)
	PEA	L002F6(PC)	;"%s? (* for list): "
	JSR	_msg
	ADDQ.W	#8,A7
	MOVE.B	#$01,-$66B0(A4)	;_want_click
	JSR	_readchar
	MOVE.B	D0,D4
	CLR.B	-$66B0(A4)	;_want_click
L002E9:
	CLR.W	-$60B0(A4)	;_mpos
	CLR.B	-$0002(A5)
	CLR.W	-$0004(A5)
	CMP.B	#$2A,D4		;'*'
	BNE.B	L002EC

	MOVE.L	$0008(A5),-(A7)
	MOVE.W	$000C(A5),-(A7)
	MOVE.L	-$529C(A4),-(A7)	;_player + 46 (pack)
	JSR	_inventory(PC)
	LEA	$000A(A7),A7
	MOVE.B	D0,D4
	TST.B	D0
	BNE.B	L002EB

	CLR.B	-$66F9(A4)	;_after
	MOVEQ	#$00,D0
L002EA:
	MOVEM.L	(A7)+,D4/A2
	UNLK	A5
	RTS

L002EB:
	CMP.B	#$20,D4		;' '
	BEQ.B	L002F0

	MOVE.B	D4,-$54DC(A4)
L002EC:
	CMP.B	#$1B,D4		;escape
	BNE.B	L002ED

	CLR.B	-$66F9(A4)	;_after
	PEA	L002F7(PC)
	JSR	_msg
	ADDQ.W	#4,A7
	MOVEQ	#$00,D0
	BRA.B	L002EA
L002ED:
	PEA	-$0001(A5)
	MOVEQ	#$00,D3
	MOVE.B	D4,D3
	MOVE.W	D3,-(A7)
	JSR	_pack_obj(PC)
	ADDQ.W	#6,A7
	MOVEA.L	D0,A2
	TST.L	D0
	BNE.B	L002EE

	MOVEQ	#$00,D3
	MOVE.B	-$0001(A5),D3
	SUBQ.W	#1,D3
	MOVE.W	D3,-(A7)
	PEA	L002F9(PC)	;"please specify a letter between 'a' and '%c'"
	PEA	L002F8(PC)	;"range is 'a' to '%c'"
	JSR	_ifterse(PC)
	LEA	$000A(A7),A7
	BRA.B	L002F0
L002EE:
	PEA	L002FA(PC)	;"identify"
	MOVE.L	$0008(A5),-(A7)
	JSR	_strcmp
	ADDQ.W	#8,A7
	TST.W	D0
	BEQ.B	L002EF

	MOVE.B	D4,-$54DC(A4)
	MOVE.L	A2,-$77B0(A4)
L002EF:
	MOVE.L	A2,D0
	BRA.W	L002EA
L002F0:
	BRA.W	L002E5
L002F1:
	MOVEQ	#$00,D0
	BRA.W	L002EA

L002F2:	dc.b	"eat",0
L002F3:	dc.b	"drop",0
L002F4:	dc.b	"you aren't carrying anything",0
L002F5:	dc.b	"which object do you want to ",0
L002F6:	dc.b	"%s? (* for list): ",0
L002F7:	dc.b	$00
L002F8:	dc.b	"range is 'a' to '%c'",0
L002F9:	dc.b	"please specify a letter between 'a' and '%c'",0
L002FA:	dc.b	"identify",0

;/*
; * pack_char:
; *  Return the next unused pack character.
; */

_pack_char:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2/A3,-(A7)
	MOVEA.L	$0008(A5),A2
	MOVEQ	#$61,D4
	MOVEA.L	-$529C(A4),A3	;_player + 46 (pack)
	BRA.B	L002FE
L002FB:
	CMPA.L	A2,A3
	BNE.B	L002FD
	MOVE.L	D4,D0
L002FC:
	MOVEM.L	(A7)+,D4/A2/A3
	UNLK	A5
	RTS

L002FD:
	ADDQ.B	#1,D4
	MOVEA.L	(A3),A3		;get next pointer in pack
L002FE:
	MOVE.L	A3,D3		;got an item?
	BNE.B	L002FB

	MOVEQ	#$3F,D0		;return '?' if empty
	BRA.B	L002FC

;/*
; * money:
; *  Add or subtract gold from the pack
; */

_money:
	LINK	A5,#-$0000
	MOVE.L	D5,-(A7)

	MOVEA.L	-$52A0(A4),A6	;_player + 42 (room)
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3	;ISGONE
	BEQ.B	1$

	MOVEQ	#$23,D5		;'#' passage
	BRA.B	2$
1$
	MOVEQ	#$2E,D5		;'.' floor
2$
	MOVE.B	D5,D2
	MOVE.W	-$52C0(A4),d1	;_player + 10
	MOVE.W	-$52BE(A4),d0	;_player + 12
	JSR	_mvaddchquick

	JSR	_INDEXplayer

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	D5,$00(A6,D0.W)

	MOVE.W	$0008(A5),D3
	ADD.W	D3,-$60B2(A4)	;_purse
	CMP.W	#$0000,D3	;no gold?
	BLE.B	3$

	MOVE.W	D3,-(A7)
	PEA	L00302(PC)	;"you found %d gold pieces"
	JSR	_msg
	ADDQ.W	#6,A7
3$
	MOVE.L	(A7)+,D5
	UNLK	A5
	RTS

L00302:	dc.b	"you found %d gold pieces",0,0

;/*
; * fix_stick:
; *  Set up a new stick
; */

_fix_stick:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVE.L	A2,-(A7)
	BSR.B	_ws_setdam
	ADDQ.W	#4,A7
	MOVEq	#$0005,D0
	JSR	_rnd
	ADDQ.W	#3,D0
	MOVE.W	D0,$0026(A2)		;every stick has 3-7 charges

	MOVE.W	$0020(A2),D0
	BEQ.B	L00304	;staff of light

	SUBQ.w	#1,D0
	BEQ.B	L00303	;staff of striking
L00306:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L00303:
	MOVE.W	#$0064,$0022(A2)	; +100 hit
	MOVE.W	#$0003,$0024(A2)	; +3 damage
	BRA.B	L00306

L00304:
	MOVEq	#$000A,D0
	JSR	_rnd
	ADD.W	#$000A,D0
	MOVE.W	D0,$0026(A2)	;10-19 charges
	BRA.B	L00306

_ws_setdam:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	$0008(A5),A2
	PEA	L0030A(PC)	;"staff"
	MOVE.W	$0020(A2),D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$521C(A4),A6	;_ws_type
	MOVE.L	$00(A6,D3.w),-(A7)
	JSR	_strcmp
	ADDQ.W	#8,A7
	TST.W	D0
	BNE.B	1$

	LEA	L0030B(PC),A6	;"2d3"
	BRA.B	2$

1$	LEA	L0030C(PC),A6	;"1d1"

2$	CMPI.W	#WS_STRIKING,$0020(A2)
	BNE.B	3$

	LEA	L0030D(PC),A6	;"2d8"

3$	MOVE.L	A6,$0016(A2)	;wield damage

	LEA	L0030E(PC),A6	;"1d1"
	MOVE.L	A6,$001A(A2)	;throw damage

	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L0030A:	dc.b	"staff",0
L0030B:	dc.b	"2d3",0
L0030C:	dc.b	"1d1",0
L0030D:	dc.b	"2d8",0
L0030E:	dc.b	"1d1",0

;/*
; * do_zap:
; *  Perform a zap with a wand
; */

_do_zap:
	LINK	A5,#-$0038
	MOVEM.L	D4-D7/A2/A3,-(A7)

	TST.L	$0008(A5)
	BNE.B	L00310

	MOVE.W	#$002F,-(A7)	;'/'
	PEA	L00347(PC)	;"zap with"
	JSR	_get_item
	ADDQ.W	#6,A7
	MOVE.L	D0,$0008(A5)
;	TST.L	D0
	BNE.B	L00310
L0030F:
	MOVEM.L	(A7)+,D4-D7/A2/A3
	UNLK	A5
	RTS

L00310:
	MOVEA.L	$0008(A5),A6
	MOVE.W	$0020(A6),-$0006(A5)
	CMPI.W	#$002F,$000A(A6)	;'/'
	BEQ.B	L00311

	PEA	L00348(PC)	;"you can't zap with that!"
	JSR	_msg
	ADDQ.W	#4,A7
	CLR.B	-$66F9(A4)	;_after
	BRA.B	L0030F
L00311:
	MOVEA.L	$0008(A5),A6
	TST.W	$0026(A6)
	BNE.B	L00312

	PEA	L00349(PC)	;"nothing happens"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L0030F
L00312:
	MOVE.W	-$0006(A5),D0
;	EXT.L	D0
	BRA.W	L00343

; light

L00313:
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;check player C_ISBLIND
	BEQ.B	L00314

	PEA	L0034A(PC)	;"you feel a warm glow around you"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L00316
L00314:
	ST	-$66CB(A4)	;_ws_know
	MOVEA.L	-$52A0(A4),A6	;_player + 42 (proom)
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3	;check for room ISDARK
	BEQ.B	L00315

	PEA	L0034B(PC)	;"the corridor glows and then fades"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L00316
L00315:
	PEA	L0034C(PC)	;"the room is lit by a shimmering blue light"
	JSR	_msg
	ADDQ.W	#4,A7
L00316:
	MOVEA.L	-$52A0(A4),A6	;_player + 42 (proom)
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3	;check for room ISDARK
	BNE.B	L00317

	MOVEA.L	-$52A0(A4),A6	;_player + 42 (proom)
	ANDI.W	#$FFFE,$000E(A6)	;clear room ISDARK
	PEA	-$52C0(A4)	;_player + 10
	JSR	_enter_room
	ADDQ.W	#4,A7
L00317:
	BRA.W	L00345

; drain life

L00318:
	CMPI.W	#$0002,-$52A8(A4)	;_player + 34 (hp)
	BGE.B	L00319

	PEA	L0034D(PC)	;"you are too weak to use it"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L0030F
L00319:
	JSR	_drain(PC)
	BRA.W	L00345

; polymorph, teleport to, teleport away and cancellation

L0031A:
	MOVE.W	-$52BE(A4),D4	;_player + 12
	MOVE.W	-$52C0(A4),D5	;_player + 10
L0031B:
	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_winat
	ADDQ.W	#4,A7

	MOVE.W	D0,-(A7)
	JSR	_step_ok
	ADDQ.W	#2,A7
	TST.W	D0
	BEQ.B	L0031C

	ADD.W	-$608A(A4),D4	;_delta + 2
	ADD.W	-$608C(A4),D5	;_delta + 0
	BRA.B	L0031B
L0031C:
	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_moatquick

	MOVE.L	D0,-$0004(A5)
;	TST.L	D0
	BEQ.W	L0032B

	MOVEA.L	-$0004(A5),A6
	MOVE.B	$000F(A6),D6
	MOVE.B	D6,-$0007(A5)
	CMP.b	#$46,D6		;'F'
	BNE.B	L0031D

	ANDI.W	#~C_ISHELD,-$52B4(A4)	;clear C_ISHELD ($80) for _player + 22 (flags)
L0031D:
	CMPI.W	#WS_POLYMORPH,-$0006(A5)	;5 = polymorph
	BNE.W	L00322

	MOVEA.L	-$0004(A5),A6
	MOVE.L	$002E(A6),-$000C(A5)
	MOVE.L	-$0004(A5),-(A7)
	PEA	-$6CAC(A4)	;_mlist
	JSR	__detach
	ADDQ.W	#8,A7
	MOVE.L	-$0004(A5),-(A7)
	JSR	_see_monst
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L0031E

	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level

	MOVE.B	$00(A6,D0.W),D2
	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_mvaddchquick

L0031E:
	MOVEA.L	-$0004(A5),A6
	MOVE.B	$0011(A6),D7
	MOVE.W	D4,-$608A(A4)	;_delta + 2
	MOVE.W	D5,-$608C(A4)	;_delta + 0
	PEA	-$608C(A4)	;_delta + 0

	MOVEq	#26,D0
	JSR	_rnd
	moveq	#$41,D6	;'A'
	ADD.B	D0,D6
	MOVE.W	D6,-(A7)
	MOVE.L	-$0004(A5),-(A7)
	JSR	_new_monster
	LEA	$000A(A7),A7
	MOVE.L	-$0004(A5),-(A7)
	JSR	_see_monst
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L0031F

	MOVE.B	D6,D2
	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_mvaddchquick

L0031F:
	MOVEA.L	-$0004(A5),A6
	MOVE.B	D7,$0011(A6)
	MOVE.L	-$000C(A5),$002E(A6)

	CMP.B	-$0007(A5),D6
	BEQ.B	L00320

	MOVEq	#$0001,D3
	BRA.B	L00321
L00320:
	CLR.W	D3
L00321:
	OR.B	D3,-$66C6(A4)
	BRA.W	L0032A
L00322:
	CMPI.W	#WS_CANCEL,-$0006(A5)	;is it a cancellation wand/staff?
	BNE.B	L00323

	MOVEA.L	-$0004(A5),A6
	ORI.W	#C_ISCANC,$0016(A6)	;C_ISCANC
	ANDI.W	#$FBEF,$0016(A6)	;clear C_ISINVIS|C_CANHUH
	MOVE.B	$000F(A6),$0010(A6)	;make the xerox visible
	BRA.W	L0032A
L00323:
	MOVE.L	-$0004(A5),-(A7)
	JSR	_see_monst
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00324

	MOVEA.L	-$0004(A5),A6

	MOVE.B	$0011(A6),D2
	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_mvaddchquick

L00324:
	CMPI.W	#WS_TELAWAY,-$0006(A5)	;is it a teleport away wand/staff?
	BNE.B	L00326

	MOVEA.L	-$0004(A5),A6
	MOVE.B	#$22,$0011(A6)
	PEA	$000A(A6)
	JSR	_blank_spot
	ADDQ.W	#4,A7
	MOVE.L	-$0004(A5),-(A7)
	JSR	_see_monst
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00325

	MOVEA.L	-$0004(A5),A6

	MOVE.B	$0010(A6),D2
	MOVE.W	$000A(A6),d1
	MOVE.W	$000C(A6),d0
	JSR	_mvaddchquick

L00325:
	BRA.B	L00327
L00326:
	MOVEA.L	-$0004(A5),A6
	MOVE.W	-$52BE(A4),D3	;_player + 12
	ADD.W	-$608A(A4),D3	;_delta + 2
	MOVE.W	D3,$000C(A6)
	MOVE.W	-$52C0(A4),D3	;_player + 10
	ADD.W	-$608C(A4),D3	;_delta + 0
	MOVE.W	D3,$000A(A6)
L00327:
	MOVEA.L	-$0004(A5),A6
;	MOVE.B	$000F(A6),D3
;	EXT.W	D3
;	CMP.W	#$0046,D3	;'F'
	cmp.b	#$46,$000F(A6)
	BNE.B	L00328

	ANDI.W	#~C_ISHELD,-$52B4(A4)	;clear C_ISHELD ($80) for _player + 22 (flags)
L00328:
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$000C(A6),D3
	CMP.W	D4,D3
	BNE.B	1$

	MOVE.W	$000A(A6),D3
	CMP.W	D5,D3
	BEQ.B	L0032A
1$
	MOVE.L	A6,-(A7)
	MOVE.W	$000A(A6),-(A7)
	MOVE.W	$000C(A6),-(A7)
	JSR	_mvinch(PC)
	ADDQ.W	#4,A7
	MOVEA.L	(A7)+,A6
	MOVE.B	D0,$0011(A6)
L0032A:
	MOVEA.L	-$0004(A5),A6
	LEA	-$52C0(A4),A1	;_player + 10
	MOVE.L	A1,$0012(A6)
	ORI.W	#C_ISRUN,$0016(A6)	;C_ISRUN
L0032B:
	BRA.W	L00345

; magic missile

L0032C:
	ST	-$66C5(A4)		;set _ws_know + 6
	MOVE.W	#$000A,-$0018(A5)
	MOVE.W	#$0077,-$002E(A5)
	LEA	L0034E(PC),A6		;"1d8"
	MOVE.L	A6,-$001E(A5)
	MOVE.W	#$03E8,-$0016(A5)	;1000
	MOVE.W	#$0001,-$0014(A5)
	MOVE.W	#$0010,-$0010(A5)

	TST.L	-$5298(A4)	;_cur_weapon
	BEQ.B	L0032D

	MOVEA.L	-$5298(A4),A6	;_cur_weapon
	MOVE.B	$0021(A6),-$0024(A5)
L0032D:
	LEA	L0034F(PC),A6	;"missile"
	MOVE.L	A6,-$6F34(A4)
	MOVE.W	-$608C(A4),-(A7)	;_delta + 0
	MOVE.W	-$608A(A4),-(A7)	;_delta + 2
	PEA	-$0038(A5)
	JSR	_do_motion(PC)
	ADDQ.W	#8,A7

	MOVE.W	-$002C(A5),d1
	MOVE.W	-$002A(A5),d0
	JSR	_moatquick

	MOVE.L	D0,-$0004(A5)
;	TST.L	D0
	BEQ.B	L0032E

	MOVE.L	-$0004(A5),-(A7)
	MOVE.W	#VS_MAGIC,-(A7)
	JSR	_save_throw
	ADDQ.W	#6,A7
	TST.W	D0
	BNE.B	L0032E

	PEA	-$0038(A5)
	MOVE.W	-$002C(A5),-(A7)
	MOVE.W	-$002A(A5),-(A7)
	JSR	_hit_monster(PC)
	ADDQ.W	#8,A7
	BRA.B	L0032F
L0032E:
	PEA	L00350(PC)	;"the missile vanishes with a puff of smoke"
	JSR	_msg
	ADDQ.W	#4,A7
L0032F:
	BRA.W	L00345

; striking

L00330:
	MOVE.W	-$52BE(A4),D3	;_player + 12
	ADD.W	D3,-$608A(A4)	;_delta + 2
	MOVE.W	-$52C0(A4),D3	;_player + 10
	ADD.W	D3,-$608C(A4)	;_delta + 0

	MOVE.W	-$608C(A4),d1	;_delta + 0
	MOVE.W	-$608A(A4),d0	;_delta + 2
	JSR	_moatquick

	MOVE.L	D0,-$0004(A5)
;	TST.L	D0
	BEQ.B	L00333

	MOVEq	#$0014,D0
	JSR	_rnd

	MOVEA.L	$0008(A5),A6

	TST.W	D0
	BNE.B	L00331

	LEA	L00351(PC),A1	;"3d8"
	MOVE.L	A1,$0016(A6)
	MOVE.W	#$0009,$0024(A6)	;+9 damage
	BRA.B	L00332
L00331:
	LEA	L00352(PC),A1	;"2d8"
	MOVE.L	A1,$0016(A6)
	MOVE.W	#$0004,$0024(A6)	;+4 hit
L00332:
	CLR.L	-(A7)
	MOVE.L	$0008(A5),-(A7)
	MOVEA.L	-$0004(A5),A6
	MOVE.B	$000F(A6),D3
	EXT.W	D3
	MOVE.W	D3,-(A7)
	PEA	-$608C(A4)	;_delta + 0
	JSR	_fight
	LEA	$000E(A7),A7
L00333:
	BRA.W	L00345

; haste monster, slow monster

L00334:
	MOVE.W	-$52BE(A4),D4	;_player + 12
	MOVE.W	-$52C0(A4),D5	;_player + 10
L00335:
	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_winat
	ADDQ.W	#4,A7
	MOVE.W	D0,-(A7)
	JSR	_step_ok
	ADDQ.W	#2,A7
	TST.W	D0
	BEQ.B	L00336

	ADD.W	-$608A(A4),D4	;_delta + 2
	ADD.W	-$608C(A4),D5	;_delta + 0
	BRA.B	L00335
L00336:
	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_moatquick

	MOVE.L	D0,-$0004(A5)
;	TST.L	D0
	BEQ.B	L0033D

	CMPI.W	#$0007,-$0006(A5)	;7 = haste monster
	BNE.B	L00339

	MOVEA.L	-$0004(A5),A6
	MOVE.W	$0016(A6),D3
	AND.W	#C_ISSLOW,D3	;check for C_ISSLOW
	BEQ.B	1$

	ANDI.W	#~C_ISSLOW,$0016(A6)	;clear C_ISSLOW
	BRA.B	L0033C
1$
	ORI.W	#C_ISHASTE,$0016(A6)	;set C_ISHASTE
	BRA.B	L0033C
L00339:
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$0016(A6),D3
	AND.W	#C_ISHASTE,D3	;check C_ISHASTE
	BEQ.B	1$

	ANDI.W	#~C_ISHASTE,$0016(A6)	;clear C_ISHASTE
	BRA.B	2$
1$
	ORI.W	#C_ISSLOW,$0016(A6)	;set C_ISSLOW
2$
	MOVE.B	#$01,$000E(A6)
L0033C:
	MOVE.W	D4,-$608A(A4)	;_delta + 2
	MOVE.W	D5,-$608C(A4)	;_delta + 0
	PEA	-$608C(A4)	;_delta + 0
	JSR	_start_run
	ADDQ.W	#4,A7
L0033D:
	BRA.B	L00345

; lightning, fire and cold

L0033E:
	CMPI.W	#$0002,-$0006(A5)
	BNE.B	L0033F

	LEA	L00353(PC),A2	;"bolt"
	BRA.B	L00341
L0033F:
	CMPI.W	#$0003,-$0006(A5)
	BNE.B	L00340

	LEA	L00354(PC),A2	;"flame"
	BRA.B	L00341
L00340:
	LEA	L00355(PC),A2	;"ice"
L00341:
	MOVE.L	A2,-(A7)
	PEA	-$608C(A4)	;_delta + 0
	PEA	-$52C0(A4)	;_player + 10
	JSR	_fire_bolt(PC)
	LEA	$000C(A7),A7
	MOVE.W	-$0006(A5),D3
	LEA	-$66CB(A4),A6	;_ws_know
	ST	$00(A6,D3.W)
	BRA.B	L00345
L00342:
	dc.w	L00313-L00344	;light
	dc.w	L00330-L00344	;striking
	dc.w	L0033E-L00344	;lightning bolt
	dc.w	L0033E-L00344	;fire flame
	dc.w	L0033E-L00344	;cold ice
	dc.w	L0031A-L00344	;polymorph
	dc.w	L0032C-L00344	;magic missile
	dc.w	L00334-L00344	;haste monster
	dc.w	L00334-L00344	;slow monster
	dc.w	L00318-L00344	;drain life
	dc.w	L00345-L00344	;nothing
	dc.w	L0031A-L00344	;teleport to
	dc.w	L0031A-L00344	;teleport away
	dc.w	L0031A-L00344	;cancellation
L00343:
	CMP.w	#$000E,D0
	BCC.B	L00345
	ASL.w	#1,D0
	MOVE.W	L00342(PC,D0.W),D0
L00344:	JMP	L00344(PC,D0.W)

; nothing

L00345:
	MOVEA.L	$0008(A5),A6
	SUBQ.W	#1,$0026(A6)
	CMPI.W	#$0000,$0026(A6)
	BGE.B	L00346
	CLR.W	$0026(A6)
L00346:
	MOVE.W	#$0001,-(A7)
	MOVE.L	$0008(A5),-(A7)
	JSR	_pack_name
	ADDQ.W	#6,A7
	BRA.W	L0030F

L00347:	dc.b	"zap with",0
L00348:	dc.b	"you can't zap with that!",0
L00349:	dc.b	"nothing happens",0
L0034A:	dc.b	"you feel a warm glow around you",0
L0034B:	dc.b	"the corridor glows and then fades",0
L0034C:	dc.b	"the room is lit by a shimmering blue light",0
L0034D:	dc.b	"you are too weak to use it",0
L0034E:	dc.b	"1d8",0
L0034F:	dc.b	"missile",0
L00350:	dc.b	"the missile vanishes with a puff of smoke",0
L00351:	dc.b	"3d8",0
L00352:	dc.b	"2d8",0
L00353:	dc.b	"bolt",0
L00354:	dc.b	"flame",0
L00355:	dc.b	"ice",0,0

;/*
; * drain:
; *  Do drain hit points from player shtick
; */

_drain:
	LINK	A5,#-$00A4
	MOVEM.L	D4/D5/A2/A3,-(A7)
	MOVEQ	#$00,D4

	JSR	_INDEXplayer

	MOVEA.L	-$519C(A4),A6	;__level
	CMP.b	#$2B,$00(A6,D0.W)	;'+'?
	BNE.B	L00356

;	JSR	_INDEXplayer

	MOVEA.L	-$5198(A4),A6	;__flags
	MOVE.B	$00(A6,D0.W),D3
	AND.W	#$000F,D3
	MULU.W	#66,D3
	LEA	-$5E36(A4),A6	;_passages
	MOVEA.L	D3,A2
	ADDA.L	A6,A2
	BRA.B	L00357
L00356:
	SUBA.L	A2,A2
L00357:
	MOVEA.L	-$52A0(A4),A6	;_player + 42 (proom)
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3
	MOVE.B	D3,D5
	LEA	-$00A4(A5),A6
	MOVEA.L	A6,A3
	MOVE.L	-$6CAC(A4),-$0004(A5)	;_mlist
	BRA.W	L0035B
L00358:
	MOVEA.L	-$0004(A5),A6
	MOVEA.L	$002A(A6),A1
	CMPA.L	-$52A0(A4),A1	;_player + 42 (proom)
	BEQ.B	L00359

	MOVEA.L	-$0004(A5),A6
	MOVEA.L	$002A(A6),A1
	CMPA.L	A2,A1
	BEQ.B	L00359

	TST.B	D5
	BEQ.B	L0035A

	MOVEA.L	-$0004(A5),A6
	MOVE.W	$000A(A6),d0
	MOVE.W	$000C(A6),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	CMP.b	#$2B,$00(A6,D0.W)	;'+'?
	BNE.B	L0035A

	MOVEA.L	-$0004(A5),A6
	MOVE.W	$000A(A6),d0
	MOVE.W	$000C(A6),d1
	JSR	_INDEXquick

	MOVEA.L	-$5198(A4),A6	;__flags
	MOVE.B	$00(A6,D0.W),D3
	AND.W	#$000F,D3
	MULU.W	#$0042,D3
	LEA	-$5E36(A4),A6	;_passages
	ADD.L	A6,D3
	CMP.L	-$52A0(A4),D3	;_player + 42 (proom)
	BNE.B	L0035A
L00359:
	MOVEA.L	A3,A6
	ADDQ.L	#4,A3
	MOVE.L	-$0004(A5),(A6)
L0035A:
	MOVEA.L	-$0004(A5),A6
	MOVE.L	(A6),-$0004(A5)
L0035B:
	TST.L	-$0004(A5)
	BNE.W	L00358

	MOVE.L	A3,D3
	LEA	-$00A4(A5),A6
	SUB.L	A6,D3
	LSR.L	#2,D3
	MOVE.W	D3,D4
;	TST.W	D3
	BNE.B	L0035D

	PEA	L00362(PC)	;"you have a tingling feeling"
	JSR	_msg
	ADDQ.W	#4,A7
L0035C:
	MOVEM.L	(A7)+,D4/D5/A2/A3
	UNLK	A5
	RTS

L0035D:
	CLR.L	(A3)
	MOVE.W	-$52A8(A4),D3	;_player + 34 (hp)
	ASR.W	#1,D3		;hp cut in half
	MOVE.W	D3,-$52A8(A4)	;_player + 34 (hp)
;	MOVE.W	-$52A8(A4),D3	;_player + 34 (hp)
	EXT.L	D3
	DIVS.W	D4,D3
	MOVE.W	D3,D4
	ADDQ.W	#1,D4
	LEA	-$00A4(A5),A6
	MOVEA.L	A6,A3
	BRA.B	L00361
L0035E:
	MOVE.L	(A3),-$0004(A5)
	MOVEA.L	-$0004(A5),A6
	SUB.W	D4,$0022(A6)
	CMPI.W	#$0000,$0022(A6)
	BGT.B	L0035F

	MOVE.L	-$0004(A5),-(A7)
	JSR	_see_monst
	ADDQ.W	#4,A7
	MOVE.W	D0,-(A7)
	MOVE.L	-$0004(A5),-(A7)
	JSR	_killed
	ADDQ.W	#6,A7
	BRA.B	L00360
L0035F:
	MOVEA.L	-$0004(A5),A6
	PEA	$000A(A6)
	JSR	_start_run
	ADDQ.W	#4,A7
L00360:
	ADDQ.L	#4,A3
L00361:
	TST.L	(A3)
	BNE.B	L0035E

	BRA.B	L0035C

L00362:	dc.b	"you have a tingling feeling",0

;/*
; * fire_bolt:
; *  Fire a bolt in a given direction from a specific starting place
; */

_fire_bolt:
	LINK	A5,#-$0084
	MOVEM.L	D4-D7/A2/A3,-(A7)

	PEA	L0038B(PC)	;"frost"
	MOVE.L	$0010(A5),-(A7)
	JSR	_strcmp
	ADDQ.W	#8,A7
	TST.W	D0
	BNE.B	L00363

	MOVEq	#$0001,D3
	BRA.B	L00364
L00363:
	CLR.W	D3
L00364:
	MOVE.B	D3,-$0083(A5)
	MOVEQ	#$00,D3
	MOVE.B	-$0083(A5),D3
	ADD.W	#$0077,D3
	MOVE.W	D3,-$0078(A5)
	MOVE.W	#$000A,-$0062(A5)
	LEA	L0038C(PC),A6		;"6d6"
	MOVE.L	A6,-$0068(A5)
	MOVE.L	-$0068(A5),-$006C(A5)
	MOVE.W	#$001E,-$0060(A5)
	CLR.W	-$005E(A5)
	MOVE.L	$0010(A5),-$6F34(A4)
	MOVE.B	-$0077(A5),D4
	LEA	-$0008(A5),A6
	MOVEA.L	$0008(A5),A1
	MOVE.L	(A1)+,(A6)+
	LEA	-$52C0(A4),A6	;_player + 10
	MOVEA.L	$0008(A5),A1
	CMPA.L	A6,A1
	BEQ.B	L00365

	MOVEq	#$0001,D3
	BRA.B	L00366
L00365:
	CLR.W	D3
L00366:
	MOVE.B	D3,D6
	MOVEQ	#$00,D7
	CLR.B	-$0001(A5)
	SUBA.L	A3,A3
	BRA.W	L00386
L00367:
	MOVEA.L	$000C(A5),A6
	MOVE.W	$0002(A6),D3
	ADD.W	D3,-$0006(A5)
	MOVEA.L	$000C(A5),A6
	MOVE.W	(A6),D3
	ADD.W	D3,-$0008(A5)
	MOVE.W	-$0008(A5),-(A7)
	MOVE.W	-$0006(A5),-(A7)
	JSR	_winat
	ADDQ.W	#4,A7
	MOVE.B	D0,D5
	MOVE.W	A3,D3
	MULS.W	#$0006,D3
	MOVEA.L	D3,A6
	LEA	-$0050(A5),A1
	ADDA.L	A1,A6
	LEA	-$0008(A5),A1
	MOVE.L	(A1)+,(A6)+
	MOVE.W	A3,D3
	MULS.W	#$0006,D3
	LEA	-$004C(A5),A6
	MOVE.L	D3,-(A7)
	MOVE.L	A6,-(A7)
	MOVE.W	-$0008(A5),-(A7)
	MOVE.W	-$0006(A5),-(A7)
	JSR	_mvinch(PC)
	ADDQ.W	#4,A7
	MOVEA.L	(A7)+,A6
	MOVE.L	(A7)+,D3
	MOVE.B	D0,$00(A6,D3.L)
	CMP.B	D4,D0
	BNE.B	L00368

	MOVE.W	A3,D3
	MULS.W	#$0006,D3
	LEA	-$004C(A5),A6
	CLR.B	$00(A6,D3.L)
L00368:
	MOVEQ	#$00,D0
	MOVE.B	D5,D0
	BRA.W	L00384
L00369:
	TST.B	-$0001(A5)
	BNE.B	L0036C

	TST.B	D6
	BNE.B	L0036A

	MOVEq	#$0001,D3
	BRA.B	L0036B
L0036A:
	CLR.W	D3
L0036B:
	MOVE.B	D3,D6
L0036C:
	CLR.B	-$0001(A5)
	MOVEA.L	$000C(A5),A6
	NEG.W	$0002(A6)
;	MOVEA.L	$000C(A5),A6
	NEG.W	(A6)
	SUBQ.W	#1,A3
	MOVE.L	$0010(A5),-(A7)
	PEA	L0038D(PC)	"the %s bounces"
	JSR	_msg
	ADDQ.W	#8,A7
	BRA.W	L00385
L0036D:
	TST.B	D6
	BNE.W	L00378

	MOVE.W	-$0008(A5),d1
	MOVE.W	-$0006(A5),d0
	JSR	_moatquick

	MOVEA.L	D0,A2
	TST.L	D0
	BEQ.W	L00378

	MOVEQ	#$01,D6
	TST.B	-$0001(A5)
	BNE.B	L0036E

	MOVEq	#$0001,D3
	BRA.B	L0036F
L0036E:
	CLR.W	D3
L0036F:
	MOVE.B	D3,-$0001(A5)
	CMP.B	#$22,$0011(A2)	;'"'
	BEQ.B	L00370

	MOVE.W	-$0008(A5),d0
	MOVE.W	-$0006(A5),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	$00(A6,D0.W),$0011(A2)
L00370:
	MOVE.L	A2,-(A7)
	MOVE.W	#VS_MAGIC,-(A7)
	JSR	_save_throw
	ADDQ.W	#6,A7
	TST.W	D0
	BEQ.B	L00371

	TST.B	-$0083(A5)
	BEQ.W	L00374
L00371:
	LEA	-$0076(A5),A6
	LEA	-$0008(A5),A1
	MOVE.L	(A1)+,(A6)+
	MOVEQ	#$01,D7
	CMP.B	#$44,$000F(A2)	; D = dragon
	BNE.B	L00372

	PEA	L0038E(PC)	;"flame"
	MOVE.L	$0010(A5),-(A7)
	JSR	_strcmp
	ADDQ.W	#8,A7
	TST.W	D0
	BNE.B	L00372

	PEA	L0038F(PC)	;"the flame bounces off the dragon"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L00373
L00372:
	PEA	-$0082(A5)
	MOVE.W	-$0008(A5),-(A7)
	MOVE.W	-$0006(A5),-(A7)
	JSR	_hit_monster(PC)
	ADDQ.W	#8,A7
	MOVE.W	-$0008(A5),-(A7)
	MOVE.W	-$0006(A5),-(A7)
	JSR	_mvinch(PC)
	ADDQ.W	#4,A7
	MOVEQ	#$00,D3
	MOVE.B	D4,D3
	CMP.W	D3,D0
	BEQ.B	L00373

	MOVE.W	A3,D3
	MULS.W	#$0006,D3
	LEA	-$004C(A5),A6
	MOVE.L	D3,-(A7)
	MOVE.L	A6,-(A7)
	MOVE.W	-$0008(A5),-(A7)
	MOVE.W	-$0006(A5),-(A7)
	JSR	_mvinch(PC)
	ADDQ.W	#4,A7
	MOVEA.L	(A7)+,A6
	MOVE.L	(A7)+,D3
	MOVE.B	D0,$00(A6,D3.L)
L00373:
	BRA.B	L00377
L00374:
	MOVEQ	#$00,D3
	MOVE.B	D5,D3
	CMP.W	#$0058,D3	;'X'
	BNE.B	L00375

	CMP.B	#$58,$0010(A2)	;'X'
	BNE.B	L00377
L00375:
	LEA	-$52C0(A4),A6	;_player + 10
	MOVEA.L	$0008(A5),A1
	CMPA.L	A6,A1
	BNE.B	L00376

	PEA	-$0008(A5)
	JSR	_start_run
	ADDQ.W	#4,A7
L00376:
	MOVEQ	#$00,D3
	MOVE.B	D5,D3
	SUB.W	#$0041,D3	;'A'
	MULU.W	#26,D3
	LEA	-$6CA8(A4),A6	;_monsters
	MOVE.L	$00(A6,D3.L),-(A7)
	MOVE.L	$0010(A5),-(A7)
	PEA	L00390(PC)	;"the %s whizzes past the %s"
	JSR	_msg
	LEA	$000C(A7),A7
L00377:
	BRA.W	L00381
L00378:
	TST.B	D6
	BEQ.W	L00381

	PEA	-$52C0(A4)	;_player + 10
	PEA	-$0008(A5)
	JSR	__ce
	ADDQ.W	#8,A7
	TST.W	D0
	BEQ.W	L00381

	MOVEQ	#$00,D6
	TST.B	-$0001(A5)
	BNE.B	L00379

	MOVEq	#$0001,D3
	BRA.B	L0037A
L00379:
	CLR.W	D3
L0037A:
	MOVE.B	D3,-$0001(A5)
	MOVE.W	#VS_MAGIC,-(A7)
	JSR	_save
	ADDQ.W	#2,A7
	TST.W	D0
	BNE.W	L00380

	TST.B	-$0083(A5)
	BEQ.B	L0037C

	LEA	L00392(PC),a0	;" from the Ice Monster"
	JSR	_noterse

	MOVE.L	D0,-(A7)
	PEA	L00391(PC)	;"You are frozen by a blast of frost%s."
	JSR	_msg
	ADDQ.W	#8,A7
	CMPI.W	#$0014,-$60AC(A4)	;_no_command
	BGE.B	L0037B

	MOVEq	#$0007,D0
	JSR	_spread

	ADD.W	D0,-$60AC(A4)	;_no_command
L0037B:
	BRA.B	L0037E
L0037C:
	MOVE.W	#$0006,-(A7)	;6d6
	MOVE.W	#$0006,-(A7)
	JSR	_roll
	ADDQ.W	#4,A7
	SUB.W	D0,-$52A8(A4)	;_player + 34 (hp)
	BGT.B	L0037E

	LEA	-$52C0(A4),A6	;_player + 10
	MOVEA.L	$0008(A5),A1
	CMPA.L	A6,A1
	BNE.B	L0037D

	MOVE.W	#$0062,-(A7)	;'b' bear trap
	JSR	_death
	ADDQ.W	#2,A7
	BRA.B	L0037E
L0037D:
	MOVEA.L	$0008(A5),A6
	MOVE.W	(A6)+,d1
	MOVE.W	(A6),d0
	JSR	_moatquick

	MOVEA.L	D0,A6
	MOVE.B	$000F(A6),D3
;	EXT.W	D3
	MOVE.W	D3,-(A7)
	JSR	_death
	ADDQ.W	#2,A7
L0037E:
	MOVEQ	#$01,D7
	TST.B	-$0083(A5)
	BNE.B	L0037F

	MOVE.L	$0010(A5),-(A7)
	PEA	L00393(PC)	;"you are hit by the %s"
	JSR	_msg
	ADDQ.W	#8,A7
L0037F:
	BRA.B	L00381
L00380:
	MOVE.L	$0010(A5),-(A7)
	PEA	L00394(PC)	;"the %s whizzes by you"
	JSR	_msg
	ADDQ.W	#8,A7
L00381:
;	TST.B	-$0083(A5)
;	BEQ.B	L00382

;	MOVE.W	#$000D,-(A7)
;	JSR	_set_attr(PC)
;	ADDQ.W	#2,A7

;	BRA.B	L00383
;L00382:
;	MOVE.W	#$0003,-(A7)
;	JSR	_set_attr(PC)
;	ADDQ.W	#2,A7
L00383:
	JSR	_tick_pause

	MOVE.B	D4,D2
	MOVE.W	-$0008(A5),d1
	MOVE.W	-$0006(A5),d0
	JSR	_mvaddchquick

	JSR	_standend
	BRA.B	L00385
L00384:
	SUB.w	#$0020,D0	;' ' SPACE
	BEQ.W	L00369
	SUB.w	#$000B,D0	;'+' DOOR
	BEQ.W	L00369
	SUBQ.w	#2,D0		;'-' vertical WALL
	BEQ.W	L00369
	SUB.w	#$000F,D0	;'<' top left corner
	BEQ.W	L00369
	SUBQ.w	#2,D0		;'>' top right corner
	BEQ.W	L00369
	SUB.w	#$003D,D0	;'{' bottom left corner
	BEQ.W	L00369
	SUBQ.w	#1,D0		;'|' horizontal WALL
	BEQ.W	L00369
	SUBQ.w	#1,D0		;'}' bottom right corner
	BEQ.W	L00369
	BRA.W	L0036D
L00385:
	ADDQ.W	#1,A3
L00386:
	CMPA.W	#$0006,A3
	BGE.B	L00387

	TST.B	D7
	BEQ.W	L00367
L00387:
	CLR.W	-$0004(A5)
	BRA.B	L0038A
L00388:
	JSR	_tick_pause
	MOVE.W	-$0004(A5),D3
	MULS.W	#$0006,D3
	LEA	-$004C(A5),A6
	TST.B	$00(A6,D3.L)
	BEQ.B	L00389

	MOVE.W	-$0004(A5),D3
	MULS.W	#$0006,D3
	LEA	-$004C(A5),A6

	MOVE.B	$00(A6,D3.L),D2

	MOVE.W	-$0004(A5),D3
	MULS.W	#$0006,D3
	LEA	-$0050(A5),A6
	MOVE.W	$00(A6,D3.L),d1

	MOVE.W	-$0004(A5),D3
	MULS.W	#$0006,D3
	LEA	-$004E(A5),A6
	MOVE.W	$00(A6,D3.L),d0
	JSR	_mvaddchquick

L00389:
	ADDQ.W	#1,-$0004(A5)
L0038A:
	MOVE.W	-$0004(A5),D3
	CMP.W	A3,D3
	BLT.B	L00388

	MOVEM.L	(A7)+,D4-D7/A2/A3
	UNLK	A5
	RTS

L0038B:	dc.b	"frost",0
L0038C:	dc.b	"6d6",0
L0038D:	dc.b	"the %s bounces",0
L0038E:	dc.b	"flame",0
L0038F:	dc.b	"the flame bounces off the dragon",0
L00390:	dc.b	"the %s whizzes past the %s",0
L00391:	dc.b	"You are frozen by a blast of frost%s.",0
L00392:	dc.b	" from the Ice Monster",0
L00393:	dc.b	"you are hit by the %s",0
L00394:	dc.b	"the %s whizzes by you",0,0

;/*
; * charge_str:
; *  Return an appropriate string for a wand charge
; */

_charge_str:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)
	MOVEA.L	$0008(A5),A2
	MOVE.W	$0028(A2),D3
	AND.W	#O_ISKNOW,D3
	BNE.B	L00395

	CLR.B	-$54DA(A4)
	BRA.B	L00396
L00395:
	MOVE.W	$0026(A2),-(A7)
	PEA	L00397(PC)	;" [%d charges]"
	PEA	-$54DA(A4)
	JSR	_sprintf
	LEA	$000A(A7),A7
L00396:
	LEA	-$54DA(A4),A6
	MOVE.L	A6,D0
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L00397:	dc.b	" [%d charges]",0

;/*
; * command:
; *  Process the user commands
; */

_command:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5,-(A7)
	TST.B	-$66B3(A4)	;_is_wizard
	BEQ.B	L00398

	MOVE.B	#$02,-$66AE(A4)	;_wizard
	BRA.B	L00399
L00398:
	CMP.B	#2,-$66AE(A4)	;_wizard
	BNE.B	L00399
	CLR.B	-$66AE(A4)	;_wizard
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
	TST.W	-$60AC(A4)	;_no_command
	BEQ.B	L0039D
	SUBQ.W	#1,-$60AC(A4)	;_no_command
	CMPI.W	#$0000,-$60AC(A4)	;_no_command
	BGT.B	L0039C

	PEA	L003A6(PC)	;"you can move again"
	JSR	_msg
	ADDQ.W	#4,A7
	CLR.W	-$60AC(A4)	;_no_command
L0039C:
	BRA.B	L0039E
L0039D:
	JSR	_execcom(PC)
L0039E:
	MOVEQ	#$00,D5
L0039F:
	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$5190(A4),A6	;_cur_ring_1
	TST.L	$00(A6,D3.w)
	BEQ.B	L003A4

	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#2,D3
;	LEA	-$5190(A4),A6	;_cur_ring_1
	MOVEA.L	$00(A6,D3.w),A1
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
	BNE.B	L003A2
	JSR	_teleport
L003A2:
	BRA.B	L003A4
L003A3:
	SUBQ.w	#3,D0	; ring of searching
	BEQ.B	L003A0
	SUBQ.w	#8,D0	; ring of teleportation
	BEQ.B	L003A1
L003A4:
	ADDQ.W	#1,D5
	CMP.W	#$0001,D5
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
	MOVE.B	-$66BA(A4),D3	;_fastmode
	CMP.B	-$66B9(A4),D3	;_faststate
	SEQ	D4
	ST	-$48B8(A4)	;_menu_on
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
	CLR.B	-$48B8(A4)	;_menu_on
	TST.W	D4
	BEQ.B	L003A9

	MOVE.B	-$66B9(A4),-$66BA(A4)	;_faststate,_fastmode
	BRA.B	L003AC
L003A9:
	TST.B	-$66B9(A4)	;_faststate
	SEQ	-$66BA(A4)	;_fastmode
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
	TST.B	-$66BA(A4)	;_fastmode
	SEQ	-$66BA(A4)	;_fastmode
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
	TST.W	-$60B0(A4)	;_mpos
	BEQ.B	L003B5
	TST.B	-$66B6(A4)	;_running
	BNE.B	L003B5
	CMP.W	#$007F,D5
	BNE.B	L003B4
	CLR.W	-$60B0(A4)	;_mpos
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

	ST	-$66F9(A4)	;_after
	MOVE.B	-$66B9(A4),-$66BA(A4)	;_faststate,_fastmode
	MOVE.W	#$0001,-(A7)
	JSR	_look
	ADDQ.W	#2,A7
	TST.B	-$66B6(A4)	;_running
	BNE.B	L003B7

	CLR.B	-$66BB(A4)	;_door_stop
L003B7:
	ST	-$54C3(A4)	;_is_pickup
	CLR.B	-$66F7(A4)	;_again
	SUBQ.W	#1,-$60A4(A4)	;_count
;	CMPI.W	#$0000,-$60A4(A4)	;_count
	BLE.B	L003B8

	MOVE.B	-$54C2(A4),-$54C3(A4)	;_is_pickup
	MOVEQ	#$00,D3
	MOVE.B	-$54C4(A4),D3
	MOVE.W	D3,D4
	CLR.B	-$66BA(A4)	;_fastmode
	BRA.W	L003C7
L003B8:
	CLR.W	-$60A4(A4)	;_count
	TST.B	-$66B6(A4)	;_running
	BEQ.B	L003B9

	JSR	_one_tick	;slow down the fast mode

	MOVE.B	-$66A8(A4),D3	;_runch
	EXT.W	D3
	MOVE.W	D3,D4
	MOVE.B	-$54C2(A4),-$54C3(A4)	;_is_pickup
	BRA.W	L003C7
L003B9:
	MOVEQ	#$00,D4
L003BA:
	JSR	_com_char(PC)
	MOVE.W	D0,D5
;	EXT.L	D0
	BRA.B	L003C5
L003BB:
	MOVE.W	-$60A4(A4),D6	;_count
	MULU.W	#10,D6
;	MOVE.W	D5,D3
	SUB.W	#$0030,D5	;'0'
	ADD.W	D5,D6
;	CMP.W	#$0000,D6
	BLE.B	L003BC
	CMP.W	#100,D6		;limit count to 100 (original was 10000)
	BGE.B	L003BC
	MOVE.W	D6,-$60A4(A4)	;_count
L003BC:
	JSR	_show_count(PC)
	BRA.W	L003C6

; toggle fastmode

L003BD:
	TST.B	-$66BA(A4)	;_fastmode
	SEQ	-$66BA(A4)
	BRA.W	L003C6

; pressed g for dont pickup

L003C0:
	CLR.B	-$54C3(A4)	;_is_pickup
	BRA.W	L003C6

; pressed a for again

L003C1:
	MOVEQ	#$00,D3
	MOVE.B	-$54C4(A4),D3
	MOVE.W	D3,D4
	MOVE.W	-$54C6(A4),-$60A4(A4)	;_count
	MOVE.B	-$54C2(A4),-$54C3(A4)	;_is_pickup
	ST	-$66F7(A4)	;_again
	BRA.B	L003C6

L003C3:
	CLR.B	-$66BB(A4)	;_door_stop
	CLR.W	-$60A4(A4)	;_count
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
	TST.W	-$60A4(A4)	;_count
	BEQ.B	L003C8

	CLR.B	-$66BA(A4)	;_fastmode
L003C8:
	MOVE.W	D4,D0
;	EXT.L	D0
	BRA.B	L003CD
L003C9:
	TST.B	-$66BA(A4)	;_fastmode
	BEQ.B	L003CE

	TST.B	-$66B6(A4)	;_running
	BNE.B	L003CE

	moveq	#C_ISBLIND,D3	;C_ISBLIND
	AND.W	-$52B4(A4),D3	;_player + 22 (flags)
	BNE.B	L003CA

	ST	-$66BB(A4)	;_door_stop
	ST	-$66B8(A4)	;_firstmove
L003CA:
	MOVE.W	D4,-(A7)
	JSR	_toupper
	ADDQ.W	#2,A7
	MOVE.W	D0,D4
	BRA.B	L003CE
L003CC:
	CLR.W	-$60A4(A4)	;_count
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
	TST.W	-$60A4(A4)	;_count
	BNE.B	L003CF

	TST.W	-$54C6(A4)
	BEQ.B	L003D0
L003CF:
	BSR.B	_show_count
L003D0:
	MOVE.B	D4,-$54C4(A4)
	MOVE.W	-$60A4(A4),-$54C6(A4)	;_count
	MOVE.B	-$54C3(A4),-$54C2(A4)	;_is_pickup
	MOVE.W	D4,D0
	MOVEM.L	(A7)+,D4-D6
;	UNLK	A5
	RTS

_show_count:
;	LINK	A5,#-$0000

	MOVEq	#$0038,d1
	MOVEq	#$0014,d0
	JSR	_movequick

	TST.W	-$60A4(A4)	;_count
	BEQ.B	L003D1
	MOVE.W	-$60A4(A4),-(A7)	;_count
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
	MOVE.W	-$608C(A4),-(A7)	;_delta + 0
	MOVE.W	-$608A(A4),-(A7)	;_delta + 2
	JSR	_missile(PC)
	ADDQ.W	#4,A7
	BRA.B	L003DA
L003D9:
	CLR.B	-$66F9(A4)	;_after
L003DA:
	BRA.W	L00409
L003DB:
	CLR.B	-$66F9(A4)	;_after
	JSR	_quit(PC)
	BRA.W	L00409

; i inventory

L003DC:
	CLR.B	-$66F9(A4)	;_after
	PEA	L0040F(PC)	;"",0
	CLR.W	-(A7)
	MOVE.L	-$529C(A4),-(A7)	;_player + 46 (pack)
	JSR	_inventory(PC)
	LEA	$000A(A7),A7
	BRA.W	L00409
L003DD:
	JSR	_drop(PC)
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
	CLR.B	-$66F9(A4)	;_after
	JSR	_save_game
	BRA.W	L00409

; c call item

L003E7:
	CLR.B	-$66F9(A4)	;_after
	JSR	_call(PC)
	BRA.W	L00409

; > go down one level

L003E8:
	CLR.B	-$66F9(A4)	;_after
	JSR	_d_level(PC)
	BRA.W	L00409

; < go up one level

L003E9:
	CLR.B	-$66F9(A4)	;_after
	JSR	_u_level(PC)
	BRA.W	L00409

; ? help

L003EA:
	CLR.B	-$66F9(A4)	;_after
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
	CLR.B	-$66F9(A4)	;_after
L003EF:
	BRA.W	L00409
L003F0:
	CLR.B	-$66F9(A4)	;_after
	JSR	_discovered(PC)
	BRA.W	L00409

; CTRL-T

L003F1:
	CLR.B	-$66F9(A4)	;_after
	EORI.B	#$01,-$66AB(A4)	;_expert
	TST.B	-$66AB(A4)	;_expert
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
	CLR.B	-$66F9(A4)	;_after
	MOVE.W	#$0029,-(A7)
	PEA	-$674D(A4)	;_macro
	JSR	_do_macro(PC)
	ADDQ.W	#6,A7
	BRA.W	L00409

; CTRL-A

_show_map_check:
	TST.B	-$66AE(A4)	;_wizard
	BEQ.W	L00409

	CLR.B	-$66F9(A4)	;_after

	bsr	_show_map
	BRA.W	L00409

; CTRL-C bugfix

_add_passages:
	TST.B	-$66AE(A4)	;_wizard
	BEQ.W	L00409

	CLR.B	-$66F9(A4)	;_after

	bsr	_add_pass
	BRA.W	L00409

; $ show inpack bugfix

show_inpack:
	TST.B	-$66AE(A4)	;_wizard
	BEQ.W	L00409

	CLR.B	-$66F9(A4)	;_after

	move.w	-$60AA(A4),-(a7)	;_inpack
	pea	inpacktext
	JSR	_msg
	ADDQ.W	#6,A7

	BRA.W	L00409

inpacktext:	dc.b	"inpack = %d",0

; CTRL-E bugfix

_foodleft:
	TST.B	-$66AE(A4)	;_wizard
	BEQ.W	L00409

	CLR.B	-$66F9(A4)	;_after

	move.w	-$609E(A4),-(a7)	;_food_left
	pea	foodlefttext
	JSR	_msg
	ADDQ.W	#6,A7

	BRA.W	L00409

foodlefttext:	dc.b	"food left: %d",0

; ctrl-f macro

L003F5:
	CLR.B	-$66F9(A4)	;_after
	LEA	-$674D(A4),A6	;_macro
	MOVE.L	A6,-$69CA(A4)	;_typeahead
	BRA.W	L00409

; ctrl-r show last message

L003F6:
	CLR.B	-$66F9(A4)	;_after
	PEA	-$4940(A4)	;_huh
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L00409

; v show version

L003F7:
	CLR.B	-$66F9(A4)		;_after
	move.w	#1,-(a7)		; new version extension
	MOVE.W	-$6F5E(A4),-(A7)	;_verno
	MOVE.W	-$6F60(A4),-(A7)	;_revno
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
	CLR.B	-$66F9(A4)	;_after
	JSR	_get_dir(PC)
	TST.W	D0
	BEQ.B	L003FB

	MOVE.W	-$52BE(A4),D3	;_player + 12
	ADD.W	-$608A(A4),D3	;_delta + 2
	MOVE.W	D3,-$0006(A5)
	MOVE.W	-$52C0(A4),D3	;_player + 10
	ADD.W	-$608C(A4),D3	;_delta + 0
	MOVE.W	D3,-$0008(A5)

	MOVE.W	-$0008(A5),d0
	MOVE.W	-$0006(A5),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
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

	MOVEA.L	-$5198(A4),A6	;__flags
	MOVE.B	$00(A6,D0.W),D3
	AND.W	#$0007,D3
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
	CLR.B	-$66F9(A4)	;_after
	PEA	L00415(PC)	;"i don't have any options, oh my!"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L00409

; CTRL-l

L003FD:
	CLR.B	-$66F9(A4)	;_after
	PEA	L00416(PC)	;"the screen looks fine to me (jll was here)"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L00409

; CTRL-d

L003FE:
	TST.B	-$66AE(A4)	;_wizard
	BEQ.W	L00409
	ADDQ.W	#1,-$60B4(A4)	;_level
	CMPI.W	#$0001,-$60A4(A4)	;_count
	BLE.B	L003FF
	MOVE.W	-$60A4(A4),-$60B4(A4)	;_count,_level
L003FF:
	JSR	_new_level
	MOVE.W	#$0001,-$54C6(A4)
	CLR.W	-$60A4(A4)	;_count
	BRA.W	L00409

; shift-C

L00400:
	TST.B	-$66AE(A4)	;_wizard
	BEQ.W	L00409
	CLR.B	-$66F9(A4)	;_after
	JSR	_create_obj(PC)
	BRA.W	L00409

; CTRL-p

L00401:
;	MOVEQ	#$00,D3
	MOVE.B	-$66AE(A4),D3	;_wizard
	CMP.b	#1,D3
	BEQ.B	L00402

	PEA	L00417(PC)	;"The Grand Beeking"
	PEA	-$672B(A4)	;_whoami
	JSR	_strcmp
	ADDQ.W	#8,A7
	TST.W	D0
	BEQ.B	L00406

	PEA	L00418(PC)	;"Mr. Mctesq"
	PEA	-$672B(A4)	;_whoami
	JSR	_strcmp
	ADDQ.W	#8,A7
	TST.W	D0
	BEQ.B	L00406
L00402:
	TST.B	-$66AE(A4)	;_wizard
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
	TST.B	-$66AE(A4)	;_wizard
	BEQ.B	L00405

	MOVE.W	-$60B4(A4),D3	;_level
	ADDQ.W	#1,D3
	EXT.L	D3
	DIVS.W	#$0002,D3
	MOVE.W	D3,-$52AC(A4)	;_player + 30 (rank)
	MOVE.W	-$60B4(A4),D3	;_level
	MULU.W	#5,D3
	MOVE.W	D3,-$52A2(A4)	;_player + 40 (max hp)
	MOVE.W	D3,-$52A8(A4)	;_player + 34 (hp)
	MOVE.W	#$0010,-$6CC2(A4)	;_max_stats + 0 (max strength)
	MOVE.W	#$0010,-$52B2(A4)	;_player + 24 (strength)
	JSR	_raise_level
L00405:
	CLR.B	-$66AE(A4)	;_wizard
	BRA.W	L00409

L00406:
	MOVE.B	#1,-$66AE(A4)		;_wizard
	MOVE.W	#15,-$52AC(A4)	;_player + 30 (rank)
	MOVE.W	#200,-$52A2(A4)	;_player + 40 (max hp)
	MOVE.W	#200,-$52A8(A4)	;_player + 34 (hp)
	MOVE.W	#25,-$6CC2(A4)	;_max_stats + 0 (max strength)
	MOVE.W	#25,-$52B2(A4)	;_player + 24 (strength)

	JSR	_raise_level

	PEA	-$672B(A4)	;_whoami
	PEA	L0041C(PC)	;"%s, You are one macho dude!"
	JSR	_msg
	ADDQ.W	#8,A7

	BRA.W	L00409

L00407:
	CLR.B	-$66F9(A4)	;_after
	CLR.B	-$66B5(A4)	;_save_msg
	MOVE.W	D4,-(A7)
	JSR	_unctrl(PC)
	ADDQ.W	#2,A7
	MOVE.L	D0,-(A7)
	PEA	L0041D(PC)	;"illegal command '%s'"
	JSR	_msg
	ADDQ.W	#8,A7
	CLR.W	-$60A4(A4)	;_count
	MOVE.B	#$01,-$66B5(A4)	;_save_msg
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

	TST.B	-$66A9(A4)	;_take
	BEQ.B	L0040A

	TST.B	-$54C3(A4)	;_is_pickup
	BEQ.B	L0040A

	MOVE.B	-$66A9(A4),D3	;_take
	EXT.W	D3
	MOVE.W	D3,-(A7)
	JSR	_pick_up(PC)
	ADDQ.W	#2,A7
L0040A:
	CLR.B	-$66A9(A4)	;_take
	TST.B	-$66B6(A4)	;_running
	BNE.B	L0040B
	CLR.B	-$66BB(A4)	;_door_stop
L0040B:
	TST.B	-$66AF(A4)	;_mouse_run
	BEQ.B	L0040E
	TST.B	-$66B6(A4)	;_running
	BEQ.B	L0040D

	JSR	_INDEXplayer

	MOVEA.L	-$5198(A4),A6	;__flags
	MOVE.B	$00(A6,D0.W),D3
	AND.W	#$0040,D3
	BNE.B	L0040C
	JSR	_mouse_adjust
	MOVE.B	D0,-$66A8(A4)	;_runch
L0040C:
	BRA.B	L0040E
L0040D:
	CLR.B	-$66AF(A4)	;_mouse_run
L0040E:
	TST.B	-$66F9(A4)	;_after
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
; * conn:
; *  Draw a corridor from a room in a certain direction.
; */

_conn:
	LINK	A5,#-$0026
	MOVEM.L	D4/D5,-(A7)
	MOVE.W	$0008(A5),D3
	CMP.W	$000A(A5),D3
	BGE.B	L00420

	MOVE.W	$0008(A5),D5
	MOVE.W	$0008(A5),D3
	ADDQ.W	#1,D3
	CMP.W	$000A(A5),D3
	BNE.B	L0041E

	MOVE.W	#$0072,-$0012(A5)
	BRA.B	L0041F
L0041E:
	MOVE.W	#$0064,-$0012(A5)
L0041F:
	BRA.B	L00422
L00420:
	MOVE.W	$000A(A5),D5
	MOVE.W	$000A(A5),D3
	ADDQ.W	#1,D3
	CMP.W	$0008(A5),D3
	BNE.B	L00421

	MOVE.W	#$0072,-$0012(A5)
	BRA.B	L00422
L00421:
	MOVE.W	#$0064,-$0012(A5)
L00422:
	MOVE.W	D5,D3
	MULS.W	#$0042,D3
	LEA	-$6088(A4),A6	;_rooms
	ADD.L	A6,D3
	MOVE.L	D3,-$0004(A5)
	CMPI.W	#$0064,-$0012(A5)
	BNE.W	L0042C

	MOVE.W	D5,D4
	ADDQ.W	#3,D4
	MOVE.W	D4,D3
	MULS.W	#66,D3
	LEA	-$6088(A4),A6	;_rooms
	ADD.L	A6,D3
	MOVE.L	D3,-$0008(A5)
	CLR.W	-$0016(A5)
	MOVE.W	#$0001,-$0014(A5)
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3
	BEQ.B	L00423

	MOVEA.L	-$0004(A5),A6
	MOVE.W	$000E(A6),D3
	AND.W	#$0004,D3
	BEQ.B	L00425
L00423:
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$0002(A6),D3
	ADD.W	$0006(A6),D3
	SUBQ.W	#1,D3
	MOVE.W	D3,-$0020(A5)
L00424:
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$0004(A6),D0
	SUBQ.W	#2,D0
	JSR	_rnd
	MOVEA.L	-$0004(A5),A6
	ADD.W	(A6),D0
	ADDQ.W	#1,D0
	MOVE.W	D0,-$0022(A5)

	MOVE.W	-$0022(A5),d0
	MOVE.W	-$0020(A5),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	CMP.B	#$20,$00(A6,D0.W)	;' ' SPACE
	BEQ.B	L00424

	BRA.B	L00426
L00425:
	MOVEA.L	-$0004(A5),A6
	MOVE.W	(A6),-$0022(A5)
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$0002(A6),-$0020(A5)
L00426:
	MOVEA.L	-$0008(A5),A6
	MOVE.W	$0002(A6),-$0024(A5)
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3
	BEQ.B	L00427

	MOVE.W	$000E(A6),D3
	AND.W	#$0004,D3
	BEQ.B	L00428
L00427:
	MOVEA.L	-$0008(A5),A6
	MOVE.W	$0004(A6),D0
	SUBQ.W	#2,D0
	JSR	_rnd
	MOVEA.L	-$0008(A5),A6
	ADD.W	(A6),D0
	ADDQ.W	#1,D0
	MOVE.W	D0,-$0026(A5)

	MOVE.W	-$0026(A5),d0
	MOVE.W	-$0024(A5),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	CMP.B	#$20,$00(A6,D0.W)	;' ' SPACE
	BEQ.B	L00427
	BRA.B	L00429
L00428:
	MOVEA.L	-$0008(A5),A6
	MOVE.W	(A6),-$0026(A5)
L00429:
	MOVE.W	-$0020(A5),D0
	SUB.W	-$0024(A5),D0
	JSR	__abs(PC)

	SUBQ.W	#1,D0
	MOVE.W	D0,-$000A(A5)
	CLR.W	-$001C(A5)
	MOVE.W	-$0022(A5),D3
	CMP.W	-$0026(A5),D3
	BGE.B	L0042A

	MOVE.W	#$0001,-$001E(A5)
	BRA.B	L0042B
L0042A:
	MOVE.W	#$FFFF,-$001E(A5)
L0042B:
	MOVE.W	-$0022(A5),D0
	SUB.W	-$0026(A5),D0
	JSR	__abs(PC)

	MOVE.W	D0,-$000E(A5)
	BRA.W	L00436
L0042C:
	CMPI.W	#$0072,-$0012(A5)	;'r'
	BNE.W	L00436

	MOVE.W	D5,D4
	ADDQ.W	#1,D4
	MOVE.W	D4,D3
	MULU.W	#66,D3
	LEA	-$6088(A4),A6	;_rooms
	ADD.L	A6,D3
	MOVE.L	D3,-$0008(A5)
	MOVE.W	#$0001,-$0016(A5)
	CLR.W	-$0014(A5)
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3
	BEQ.B	L0042D

	MOVEA.L	-$0004(A5),A6
	MOVE.W	$000E(A6),D3
	AND.W	#$0004,D3
	BEQ.B	L0042F
L0042D:
	MOVEA.L	-$0004(A5),A6
	MOVE.W	(A6),D3
	ADD.W	$0004(A6),D3
	SUBQ.W	#1,D3
	MOVE.W	D3,-$0022(A5)
L0042E:
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$0006(A6),D0
	SUBQ.W	#2,D0
	JSR	_rnd
	MOVEA.L	-$0004(A5),A6
	ADD.W	$0002(A6),D0
	ADDQ.W	#1,D0
	MOVE.W	D0,-$0020(A5)

	MOVE.W	-$0022(A5),d0
	MOVE.W	-$0020(A5),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	CMP.B	#$20,$00(A6,D0.W)	;' ' SPACE
	BEQ.B	L0042E

	BRA.B	L00430
L0042F:
	MOVEA.L	-$0004(A5),A6
	MOVE.W	(A6),-$0022(A5)
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$0002(A6),-$0020(A5)
L00430:
	MOVEA.L	-$0008(A5),A6
	MOVE.W	(A6),-$0026(A5)
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3
	BEQ.B	L00431

	MOVE.W	$000E(A6),D3
	AND.W	#$0004,D3
	BEQ.B	L00432
L00431:
	MOVEA.L	-$0008(A5),A6
	MOVE.W	$0006(A6),D0
	SUBQ.W	#2,D0
	JSR	_rnd
	MOVEA.L	-$0008(A5),A6
	ADD.W	$0002(A6),D0
	ADDQ.W	#1,D0
	MOVE.W	D0,-$0024(A5)

	MOVE.W	-$0026(A5),d0
	MOVE.W	-$0024(A5),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	CMP.B	#$20,$00(A6,D0.W)	;' ' SPACE
	BEQ.B	L00431

	BRA.B	L00433
L00432:
	MOVEA.L	-$0008(A5),A6
	MOVE.W	$0002(A6),-$0024(A5)
L00433:
	MOVE.W	-$0022(A5),D0
	SUB.W	-$0026(A5),D0
	JSR	__abs(PC)

	SUBQ.W	#1,D0
	MOVE.W	D0,-$000A(A5)
	MOVE.W	-$0020(A5),D3
	CMP.W	-$0024(A5),D3
	BGE.B	L00434

	MOVE.W	#$0001,-$001C(A5)
	BRA.B	L00435
L00434:
	MOVE.W	#$FFFF,-$001C(A5)
L00435:
	CLR.W	-$001E(A5)
	MOVE.W	-$0020(A5),D0
	SUB.W	-$0024(A5),D0
	JSR	__abs(PC)

	MOVE.W	D0,-$000E(A5)
L00436:
	MOVE.W	-$000A(A5),D0
	SUBQ.W	#1,D0
	JSR	_rnd
	ADDQ.W	#1,D0
	MOVE.W	D0,-$000C(A5)
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3
	BNE.B	L00437

	PEA	-$0022(A5)
	MOVE.L	-$0004(A5),-(A7)
	JSR	_door(PC)
	ADDQ.W	#8,A7
	BRA.B	L00438
L00437:
	MOVE.W	-$0022(A5),-(A7)
	MOVE.W	-$0020(A5),-(A7)
	JSR	_psplat(PC)
	ADDQ.W	#4,A7
L00438:
	MOVEA.L	-$0008(A5),A6
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3
	BNE.B	L00439

	PEA	-$0026(A5)
	MOVE.L	-$0008(A5),-(A7)
	JSR	_door(PC)
	ADDQ.W	#8,A7
	BRA.B	L0043A
L00439:
	MOVE.W	-$0026(A5),-(A7)
	MOVE.W	-$0024(A5),-(A7)
	JSR	_psplat(PC)
	ADDQ.W	#4,A7
L0043A:
	MOVE.W	-$0022(A5),-$001A(A5)
	MOVE.W	-$0020(A5),-$0018(A5)
L0043B:
	TST.W	-$000A(A5)
	BEQ.B	L0043E

	MOVE.W	-$0016(A5),D3
	ADD.W	D3,-$001A(A5)
	MOVE.W	-$0014(A5),D3
	ADD.W	D3,-$0018(A5)
	MOVE.W	-$000A(A5),D3
	CMP.W	-$000C(A5),D3
	BNE.B	L0043D
L0043C:
	MOVE.W	-$000E(A5),D3
	SUBQ.W	#1,-$000E(A5)
	TST.W	D3
	BEQ.B	L0043D

	MOVE.W	-$001A(A5),-(A7)
	MOVE.W	-$0018(A5),-(A7)
	JSR	_psplat(PC)
	ADDQ.W	#4,A7
	MOVE.W	-$001E(A5),D3
	ADD.W	D3,-$001A(A5)
	MOVE.W	-$001C(A5),D3
	ADD.W	D3,-$0018(A5)
	BRA.B	L0043C
L0043D:
	MOVE.W	-$001A(A5),-(A7)
	MOVE.W	-$0018(A5),-(A7)
	JSR	_psplat(PC)
	ADDQ.W	#4,A7
	SUBQ.W	#1,-$000A(A5)
	BRA.B	L0043B
L0043E:
	MOVE.W	-$0016(A5),D3
	ADD.W	D3,-$001A(A5)
	MOVE.W	-$0014(A5),D3
	ADD.W	D3,-$0018(A5)
	PEA	-$0026(A5)
	PEA	-$001A(A5)
	JSR	__ce
	ADDQ.W	#8,A7
	TST.W	D0
	BNE.B	L0043F

	MOVE.W	-$0016(A5),D3
	SUB.W	D3,-$0026(A5)
	MOVE.W	-$0014(A5),D3
	SUB.W	D3,-$0024(A5)
	MOVE.W	-$0026(A5),-(A7)
	MOVE.W	-$0024(A5),-(A7)
	JSR	_psplat(PC)
	ADDQ.W	#4,A7
L0043F:
	MOVEM.L	(A7)+,D4/D5
	UNLK	A5
	RTS

;/*
; * do_passages:
; *  Draw all the passages on a level.
; */

_do_passages:
	LINK	A5,#-$000A
	MOVEM.L	D4/D5,-(A7)

	LEA	-$77AC(A4),A6
	MOVE.L	A6,-$0006(A5)
L00440:
	MOVEQ	#$00,D5
L00441:
	MOVE.W	D5,D3
	EXT.L	D3
	MOVEA.L	D3,A6
	ADDA.L	-$0006(A5),A6
	CLR.B	$0009(A6)
	ADDQ.W	#1,D5
	CMP.W	#$0009,D5
	BLT.B	L00441

	MOVEA.L	-$0006(A5),A6
	CLR.B	$0012(A6)
	ADDI.L	#$00000014,-$0006(A5)
	LEA	-$76F8(A4),A6
	MOVEA.L	-$0006(A5),A1
	CMPA.L	A6,A1
	BCS.B	L00440

	MOVE.W	#$0001,-$0002(A5)
	MOVEq	#$0009,D0
	JSR	_rnd
	MULU.W	#$0014,D0
	LEA	-$77AC(A4),A6
	ADD.L	A6,D0
	MOVE.L	D0,-$0006(A5)
	MOVEA.L	-$0006(A5),A6
	MOVE.B	#$01,$0012(A6)
L00442:
	MOVEQ	#$00,D5
	MOVEQ	#$00,D4
L00443:
	MOVEA.L	-$0006(A5),A6
	TST.B	$00(A6,D4.W)
	BEQ.B	L00444

	MOVE.W	D4,D3
	MULU.W	#$0014,D3
	LEA	-$779A(A4),A6
	TST.B	$00(A6,D3.L)
	BNE.B	L00444

	ADDQ.W	#1,D5
	MOVE.W	D5,D0
	JSR	_rnd
	TST.W	D0
	BNE.B	L00444

	MOVE.W	D4,D3
	MULU.W	#$0014,D3
	LEA	-$77AC(A4),A6
	ADD.L	A6,D3
	MOVE.L	D3,-$000A(A5)
L00444:
	ADDQ.W	#1,D4
	CMP.W	#$0009,D4
	BLT.B	L00443

	TST.W	D5
	BNE.B	L00446
L00445:
	MOVEq	#$0009,D0
	JSR	_rnd
	MULU.W	#$0014,D0
	LEA	-$77AC(A4),A6
	ADD.L	A6,D0
	MOVE.L	D0,-$0006(A5)
	MOVEA.L	-$0006(A5),A6
	TST.B	$0012(A6)
	BEQ.B	L00445

	BRA.B	L00447
L00446:
	MOVEA.L	-$000A(A5),A6
	MOVE.B	#$01,$0012(A6)

	LEA	-$77AC(A4),A6
	MOVE.L	-$0006(A5),D4
	SUB.L	A6,D4

	MOVEQ	#$14,d0
	divu	D0,d4

;	LEA	-$77AC(A4),A6
	MOVE.L	-$000A(A5),D5
	SUB.L	A6,D5

;	MOVEQ	#$14,d0
	divu	D0,d5

	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_conn(PC)
	ADDQ.W	#4,A7

	MOVE.W	D5,D3
	EXT.L	D3
	MOVEA.L	D3,A6
	ADDA.L	-$0006(A5),A6
	MOVE.B	#$01,$0009(A6)
	MOVE.W	D4,D3
	EXT.L	D3
	MOVEA.L	D3,A6
	ADDA.L	-$000A(A5),A6
	MOVE.B	#$01,$0009(A6)
	ADDQ.W	#1,-$0002(A5)
L00447:
	CMPI.W	#$0009,-$0002(A5)
	BLT.W	L00442

	MOVEq	#$0005,D0
	JSR	_rnd
	MOVE.W	D0,-$0002(A5)
	BRA.W	L0044C
L00448:
	MOVEq	#$0009,D0
	JSR	_rnd
	MULU.W	#$0014,D0
	LEA	-$77AC(A4),A6
	ADD.L	A6,D0
	MOVE.L	D0,-$0006(A5)
	MOVEQ	#$00,D5
	MOVEQ	#$00,D4
L00449:
	MOVEA.L	-$0006(A5),A6
	TST.B	$00(A6,D4.W)
	BEQ.B	L0044A

	MOVE.W	D4,D3
	EXT.L	D3
	MOVEA.L	D3,A6
	ADDA.L	-$0006(A5),A6
	TST.B	$0009(A6)
	BNE.B	L0044A

	ADDQ.W	#1,D5
	MOVE.W	D5,D0
	JSR	_rnd
	TST.W	D0
	BNE.B	L0044A

	MOVE.W	D4,D3
	MULU.W	#$0014,D3
	LEA	-$77AC(A4),A6
	ADD.L	A6,D3
	MOVE.L	D3,-$000A(A5)
L0044A:
	ADDQ.W	#1,D4
	CMP.W	#$0009,D4
	BLT.B	L00449

	TST.W	D5
	BEQ.B	L0044B

	LEA	-$77AC(A4),A6
	MOVE.L	-$0006(A5),D4
	SUB.L	A6,D4

	MOVEQ	#$14,d0
	divu	D0,d4

;	LEA	-$77AC(A4),A6
	MOVE.L	-$000A(A5),D5
	SUB.L	A6,D5

;	MOVEQ	#$14,d0
	divu	D0,d5

	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_conn(PC)
	ADDQ.W	#4,A7
	MOVE.W	D5,D3
	EXT.L	D3
	MOVEA.L	D3,A6
	ADDA.L	-$0006(A5),A6
	MOVE.B	#$01,$0009(A6)
	MOVE.W	D4,D3
	EXT.L	D3
	MOVEA.L	D3,A6
	ADDA.L	-$000A(A5),A6
	MOVE.B	#$01,$0009(A6)
L0044B:
	SUBQ.W	#1,-$0002(A5)
L0044C:
	CMPI.W	#$0000,-$0002(A5)
	BGT.W	L00448
	JSR	_passnum(PC)

	MOVEM.L	(A7)+,D4/D5
	UNLK	A5
	RTS

;/*
; * door:
; *  Add a door or possibly a secret door.  Also enters the door in
; *  the exits array of the room.
; */

_door:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5,-(A7)
	MOVEA.L	$000C(A5),A6

	MOVE.W	(A6)+,d0
	MOVE.W	(A6),d1
	JSR	_INDEXquick

	MOVE.W	D0,D4
	MOVEq	#10,D0
	JSR	_rnd
	ADDQ.W	#1,D0
	CMP.W	-$60B4(A4),D0	;_level
	BGE.B	L00450

	MOVEq	#5,D0
	JSR	_rnd
	TST.W	D0
	BNE.B	L00450

	MOVEA.L	-$519C(A4),A6	;__level
	MOVEA.L	$000C(A5),A1
	MOVEA.L	$0008(A5),A0

	MOVE.W	$0002(A1),D3
	CMP.W	$0002(A0),D3
	BEQ.B	L0044D

;	MOVEA.L	$0008(A5),A0
	MOVE.W	$0002(A0),D3
	ADD.W	$0006(A0),D3
	SUBQ.W	#1,D3
;	MOVEA.L	$000C(A5),A1
	CMP.W	$0002(A1),D3
	BNE.B	L0044E
L0044D:
	MOVEQ	#$2D,D3		;'-'
	BRA.B	L0044F
L0044E:
	MOVEQ	#$7C,D3		;'|'
L0044F:
	MOVE.B	D3,$00(A6,D4.W)
	MOVEA.L	-$5198(A4),A6	;__flags
	ANDI.B	#$EF,$00(A6,D4.W)	;clear F_REAL
	BRA.B	L00451
L00450:
	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	#$2B,$00(A6,D4.W)	;'+'
L00451:
	MOVEA.L	$0008(A5),A6
	MOVEA.L	$000C(A5),A1

	MOVE.W	$0010(A6),D3
	ADDQ.W	#1,$0010(A6)

	ASL.L	#2,D3

	MOVE.W	(A1)+,$12(A6,D3.w)
	MOVE.W	(A1),$14(A6,D3.w)

	MOVEM.L	(A7)+,D4/D5
	UNLK	A5
	RTS

;/*
; * add_pass:
; *  Add the passages to the current window (wizard command)
; */

_add_pass:
	LINK	A5,#-$0000
	MOVEM.L	D4-D5,-(A7)

	MOVEQ	#$01,D4
	BRA.B	L00456
L00452:
	MOVEQ	#$00,D5
L00453:
	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level

	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3

	CMP.W	#$002B,D3	;'+'
	BEQ.B	L00454

	CMP.W	#$0023,D3	;'#'
	BNE.B	L00455
L00454:
	MOVE.W	D3,d2
	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_mvaddchquick

L00455:
	ADDQ.W	#1,D5
	CMP.W	#$003C,D5	;'<'
	BLT.B	L00453

	ADDQ.W	#1,D4
L00456:
	CMP.W	-$60BC(A4),D4	;_maxrow
	BLT.B	L00452

	MOVEM.L	(A7)+,D4-D5
	UNLK	A5
	RTS

;/*
; * passnum:
; *  Assign a number to each passageway
; */

_passnum:
;	LINK	A5,#-$0000
	MOVEM.L	D4/A2,-(A7)
	CLR.W	-$54C0(A4)
	CLR.B	-$54BE(A4)
	LEA	-$5E36(A4),A2	;_passages
	LEA	-$5ADC(A4),A6	;_SV_END
1$
	CLR.W	$0010(A2)
	ADDA.L	#$00000042,A2
	CMPA.L	A6,A2
	BCS.B	1$

	LEA	-$6088(A4),A6	;_rooms
	MOVEA.L	A6,A2
L00458:
	MOVEQ	#$00,D4
	BRA.B	L0045A
L00459:
	ADDQ.B	#1,-$54BE(A4)
	MOVE.W	D4,D3
	EXT.L	D3
	ASL.L	#2,D3
	MOVEA.L	D3,A6
	ADDA.L	A2,A6
	MOVE.W	$0012(A6),-(A7)
	MOVE.W	$0014(A6),-(A7)
	BSR.B	_numpass
	ADDQ.W	#4,A7
	ADDQ.W	#1,D4
L0045A:
	CMP.W	$0010(A2),D4
	BLT.B	L00459
	ADDA.L	#$00000042,A2
	LEA	-$5E36(A4),A6	;_passages
	CMPA.L	A6,A2
	BCS.B	L00458

	MOVEM.L	(A7)+,D4/A2
;	UNLK	A5
	RTS

;/*
; * numpass:
; *  Number a passageway square and its brethren
; */

_numpass:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2/A3,-(A7)
	MOVE.W	$000A(A5),-(A7)
	MOVE.W	$0008(A5),-(A7)
	JSR	_offmap
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L0045C
L0045B:
	MOVEM.L	(A7)+,D4/A2/A3
	UNLK	A5
	RTS

L0045C:
	MOVE.W	$000A(A5),d0
	MOVE.W	$0008(A5),d1
	JSR	_INDEXquick

;	EXT.L	D0
	MOVEA.w	D0,A2
	ADDA.L	-$5198(A4),A2	;__flags
	MOVEQ	#$00,D3
	MOVE.B	(A2),D3
	AND.W	#$000F,D3
	BEQ.B	L0045D

	BRA.B	L0045B
L0045D:
	TST.B	-$54BE(A4)
	BEQ.B	L0045E

	ADDQ.W	#1,-$54C0(A4)
	CLR.B	-$54BE(A4)
L0045E:
	MOVE.W	$000A(A5),d0
	MOVE.W	$0008(A5),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	$00(A6,D0.W),D4

	MOVE.B	D4,D3
	CMP.B	#$2B,D3
	BEQ.B	L0045F

	MOVE.B	(A2),D3
	AND.B	#$10,D3
	BNE.B	L00460

	MOVE.B	D4,D3
	CMP.B	#$2E,D3
	BEQ.B	L00460
L0045F:
	MOVE.W	-$54C0(A4),D3
	MULU.W	#66,D3
	LEA	-$5E36(A4),A6	;_passages
	MOVEA.L	D3,A3
	ADDA.L	A6,A3
	MOVE.W	$0010(A3),D3
	EXT.L	D3
	ASL.L	#2,D3
	MOVEA.L	D3,A6
	ADDA.L	A3,A6
	MOVE.W	$0008(A5),$0014(A6)
	MOVE.W	$000A(A5),$0012(A6)
	ADDQ.W	#1,$0010(A3)
	BRA.B	L00461
L00460:
	MOVE.B	(A2),D3
	AND.B	#$0040,D3
	BNE.B	L00461

	BRA.W	L0045B
L00461:
	MOVE.B	-$54BF(A4),D3
	OR.B	D3,(A2)

	MOVE.W	$000A(A5),-(A7)
	MOVE.W	$0008(A5),D3
	ADDQ.W	#1,D3
	MOVE.W	D3,-(A7)
	JSR	_numpass(PC)
	ADDQ.W	#4,A7

	MOVE.W	$000A(A5),-(A7)
	MOVE.W	$0008(A5),D3
	SUBQ.W	#1,D3
	MOVE.W	D3,-(A7)
	JSR	_numpass(PC)
	ADDQ.W	#4,A7

	MOVE.W	$000A(A5),D3
	ADDQ.W	#1,D3
	MOVE.W	D3,-(A7)
	MOVE.W	$0008(A5),-(A7)
	JSR	_numpass(PC)
	ADDQ.W	#4,A7

	MOVE.W	$000A(A5),D3
	SUBQ.W	#1,D3
	MOVE.W	D3,-(A7)
	MOVE.W	$0008(A5),-(A7)
	JSR	_numpass(PC)
	ADDQ.W	#4,A7

	BRA.W	L0045B

_psplat:
	MOVE.W	$0006(A7),d0
	MOVE.W	$0004(A7),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	#$23,$00(A6,D0.W)

	MOVEA.L	-$5198(A4),A6	;__flags
	ORI.B	#$40,$00(A6,D0.W)

	RTS

__abs:
	TST.W	D0
	BGE.B	1$
	NEG.W	D0
1$	RTS

;/*
; * detach:
; *  takes an item out of whatever linked list it might be in
; */

__detach:
	LINK	A5,#-$0000
	MOVEM.L	A2/A3,-(A7)
	MOVEA.L	$0008(A5),A2
	MOVEA.L	$000C(A5),A3
	MOVEA.L	(A2),A6
	CMPA.L	A3,A6
	BNE.B	L00464
	MOVE.L	(A3),(A2)
L00464:
	TST.L	$0004(A3)
	BEQ.B	L00465
	MOVEA.L	$0004(A3),A6
	MOVE.L	(A3),(A6)
L00465:
	TST.L	(A3)
	BEQ.B	L00466
	MOVEA.L	(A3),A6
	MOVE.L	$0004(A3),$0004(A6)
L00466:
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

	MOVEA.L	$0008(A5),A2
	MOVEA.L	$000C(A5),A3
	TST.L	(A2)
	BEQ.B	L00467

	MOVE.L	(A2),(A3)
	MOVEA.L	(A2),A6
	MOVE.L	A3,$0004(A6)
	CLR.L	$0004(A3)
	BRA.B	L00468
L00467:
	CLR.L	(A3)
	CLR.L	$0004(A3)
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
	MOVE.W	-$60A8(A4),D3	;_total
	CMP.W	-$6098(A4),D3	;_maxitems
	BLE.B	L0046C

	MOVE.W	-$60A8(A4),-$6098(A4)	;_total,_maxitems
L0046C:
	MOVE.W	D4,D3
	ASL.w	#1,D3
	MOVEA.L	-$52CE(A4),A6	;__t_alloc
	ADDQ.W	#1,$00(A6,D3.w)

	CLR.W	d1
	MOVE.W	#50,d0
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
	CMP.W	#$0053,D4
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
L00470:
	MOVE.W	D4,D3
	MULS.W	#$0032,D3
	ADD.L	-$52D2(A4),D3
	CMP.L	A2,D3
	BNE.B	L00472

	SUBQ.W	#1,-$60A8(A4)	;_total
	MOVE.W	D4,D3
;	EXT.L	D3
	ASL.w	#1,D3
	MOVEA.L	-$52CE(A4),A6	;__t_alloc
	CLR.W	$00(A6,D3.w)
	MOVEQ	#$01,D0
L00471:
	MOVEM.L	(A7)+,D4/A2
	UNLK	A5
	RTS

L00472:
	ADDQ.W	#1,D4
	CMP.W	#$0053,D4
	BLT.B	L00470

	MOVEQ	#$00,D0
	BRA.B	L00471

_isupper:
	moveq	#$1,d3
	bra	chartest

_islower:
	moveq	#$2,d3
	bra	chartest

_isalpha:
	moveq	#$3,d3
	bra	chartest

_isdigit:
	moveq	#$4,d3
	bra	chartest

_isspace:
	moveq	#$10,d3
	bra	chartest

_isprint:
	move.w	#$c7,d3		;upper | lower | digit | $40 | $80
;	bra	chartest

chartest:
	ext.w	d0
	BMI.B	2$
	LEA	-$55CA(A4),A6		;_ctp_
	AND.B	$00(A6,D0.W),D3
	move.b	d3,d0
	RTS

2$	MOVEQ	#$00,D0
	rts

_toupper:
	MOVE.B	$0005(A7),D0
	JSR	_islower(PC)

	TST.W	D0
	BEQ.B	L0047F

	MOVE.B	$0005(A7),D0
	SUB.B	#$0020,D0
	BRA.B	L00480
L0047F:
	MOVE.B	$0005(A7),D0
L00480:
	EXT.W	D0
	RTS

_tolower:
	MOVE.B	$0005(A7),D0
	JSR	_isupper(PC)

	TST.W	D0
	BEQ.B	L00481

	MOVE.B	$0005(A7),D0
	ADD.B	#$0020,D0
	BRA.B	L00482
L00481:
	MOVE.B	$0005(A7),D0
L00482:
	EXT.W	D0
	RTS

;/*
; * quaff:
; *  Quaff a potion from the pack
; */

_quaff:
	LINK	A5,#-$0004
	MOVEM.L	A2/A3,-(A7)
	MOVEA.L	$0008(A5),A2
	MOVE.L	A2,D3
	BNE.B	L00484
	MOVE.W	#$0021,-(A7)
	PEA	L004AE(PC)
	JSR	_get_item
	ADDQ.W	#6,A7
	MOVEA.L	D0,A2
	TST.L	D0
	BNE.B	L00484
L00483:
	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

L00484:
	CMPI.W	#$0021,$000A(A2)	;'!' potion
	BEQ.B	L00485
	PEA	L004AF(PC)	;"yuk! Why would you want to drink that?"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L00483
L00485:
	MOVE.L	A2,-(A7)
	JSR	_check_wisdom
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00486
	BRA.B	L00483
L00486:
	CMPA.L	-$5298(A4),A2	;_cur_weapon
	BNE.B	L00487
	CLR.L	-$5298(A4)	;_cur_weapon
L00487:
	MOVE.W	$0020(A2),D0
;	EXT.L	D0
	BRA.W	L004AB

; potion of confusion

L00488:
	ST	-$66E7(A4)	;_p_know + 0 (potion of confusion)
	JSR	_p_confuse(PC)
	PEA	L004B0(PC)	;"wait, what's going on? Huh? What? Who?"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L004AD

; potion of poison

L00489:
	LEA	L004B1(PC),A6	;"you feel %s sick."
	MOVE.L	A6,-$0004(A5)
	ST	-$66E5(A4)	;_p_know + 2 (potion of poison)

	TST.L	-$5190(A4)	;_cur_ring_1
	BEQ.B	L0048A

	MOVEA.L	-$5190(A4),A6	;_cur_ring_1
	CMPI.W	#R_SUSTSTR,$0020(A6)
	BEQ.B	L0048C
L0048A:
	TST.L	-$518C(A4)	;_cur_ring_2
	BEQ.B	L0048B

	MOVEA.L	-$518C(A4),A6	;_cur_ring_2
	CMPI.W	#R_SUSTSTR,$0020(A6)
	BEQ.B	L0048C
L0048B:
	MOVEq	#$0003,D0
	JSR	_rnd
;	ADDQ.W	#1,D0
;	NEG.W	D0
	subq.w	#3,d0
	MOVE.W	D0,-(A7)	;subtract 1-3 strength points
	JSR	_chg_str
	ADDQ.W	#2,A7
	PEA	L004B2(PC)	;"very"
	MOVE.L	-$0004(A5),-(A7)
	JSR	_msg
	ADDQ.W	#8,A7
	BRA.B	L0048D
L0048C:
	PEA	L004B3(PC)	;"momentarily"
	MOVE.L	-$0004(A5),-(A7)
	JSR	_msg
	ADDQ.W	#8,A7
L0048D:
	BRA.W	L004AD

; potion of healing

L0048E:
	ST	-$66E2(A4)	;_p_know + 5 (potion of healing)
	MOVE.W	#$0004,-(A7)	;xd4
	MOVE.W	-$52AC(A4),-(A7)	;_player + 30 (rank)
	JSR	_roll
	ADDQ.W	#4,A7
	ADD.W	D0,-$52A8(A4)	;_player + 34 (hp)
	MOVE.W	-$52A8(A4),D3	;_player + 34 (hp)
	CMP.W	-$52A2(A4),D3	;_player + 40 (max hp)
	BLE.B	L0048F
	ADDQ.W	#1,-$52A2(A4)	;_player + 40 (max hp)
	MOVE.W	-$52A2(A4),-$52A8(A4)	;_player + 34 (hp),_player + 40 (max hp)
L0048F:
	JSR	_sight(PC)
	PEA	L004B4(PC)	;"you begin to feel better"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L004AD

; potion of gain strength

L00490:
	ST	-$66E4(A4)	;_p_know + 3 (potion of gain strength)
	MOVE.W	#$0001,-(A7)	; plus one strength point
	JSR	_chg_str
	ADDQ.W	#2,A7
	PEA	L004B5(PC)	;"you feel stronger. What bulging muscles!"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L004AD

; potion of night vision

L00491:
	MOVE.W	#300,D0
	JSR	_spread

	MOVE.W	D0,-(A7)

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISFOUND,D3	;C_ISFOUND
	BEQ.B	L00492

	PEA	_lose_vision(PC)
	JSR	_lengthen(PC)
	ADDQ.W	#6,A7
	BRA.B	L00493
L00492:
	CLR.W	-(A7)
	PEA	_lose_vision(PC)
	JSR	_fuse(PC)
	ADDQ.W	#8,A7
L00493:
	JSR	_sight(PC)
	PEA	L004B6(PC)	;"Your vision is clouded for a moment.  Now it seems very bright in here."
	JSR	_msg
	ADDQ.W	#4,A7
	ORI.W	#C_ISFOUND,-$52B4(A4)	;_player + 22 (flags)
	PEA	-$52C0(A4)	;_player + 10
	JSR	_leave_room
	ADDQ.W	#4,A7
	PEA	-$52C0(A4)	;_player + 10
	JSR	_enter_room
	ADDQ.W	#4,A7
	BRA.W	L004AD

; potion of discernment

L00494:
	MOVEq	#100,D0
	JSR	_spread

	MOVE.W	D0,-(A7)

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_WISDOM,D3
	BEQ.B	L00495

	PEA	_foolish(PC)
	JSR	_lengthen(PC)
	ADDQ.W	#6,A7
	BRA.B	L00496
L00495:
	ORI.W	#C_WISDOM,-$52B4(A4)	;WISDOM, _player + 22 (flags)

	CLR.W	-(A7)
	PEA	_foolish(PC)
	JSR	_fuse(PC)
	ADDQ.W	#8,A7
L00496:
	PEA	L004B7(PC)	;"You feel light headed for a moment, then it passes."
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L004AD

; potion of paralysis

L00497:
	ST	-$66E6(A4)	;_p_know + 1 (potion of paralysis)

	MOVEq	#$0002,D0
	JSR	_spread

	MOVE.W	D0,-$60AC(A4)	;_no_command
	ANDI.W	#~C_ISRUN,-$52B4(A4)	;clear C_ISRUN, _player + 22 (flags)
	PEA	L004B8(PC)	;"you can't move"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L004AD

; potion of see invisible

L00498:
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_CANSEE,D3	;C_CANSEE
	BNE.B	L00499

	MOVE.W	#300,D0
	JSR	_spread

	MOVE.W	D0,-(A7)
	CLR.W	-(A7)
	PEA	_unsee(PC)
	JSR	_fuse(PC)
	ADDQ.W	#8,A7
	CLR.L	-(A7)
	JSR	_look
	ADDQ.W	#4,A7
	JSR	_invis_on(PC)
L00499:
	JSR	_sight(PC)
	PEA	-$6713(A4)
	PEA	L004B9(PC)	;"this potion tastes like %s juice"
	JSR	_msg
	ADDQ.W	#8,A7
	BRA.W	L004AD

; potion of raise level

L0049A:
	ST	-$66DF(A4)	;_p_know + 8 (potion of raise level)
	MOVE.W	-$52AC(A4),D3	;_player + 30 (rank)
	SUBQ.W	#1,D3
;	EXT.L	D3
	ASL.w	#2,D3
	MOVEA.L	-$51AC(A4),A6	;_e_levels
	TST.L	$00(A6,D3.w)
	BEQ.B	L0049B

	PEA	L004BA(PC)	;"you suddenly feel much more skillful"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L0049C
L0049B:
	PEA	L004BB(PC)	;"you suddenly feel much less skillful"
	JSR	_msg
	ADDQ.W	#4,A7
L0049C:
	JSR	_raise_level
	BRA.W	L004AD

; potion of extra healing

L0049D:
	ST	-$66DE(A4)	;_p_know + 9 (potion of extra healing)
	MOVE.W	-$52A8(A4),D3	;_player + 34 (hp)
	CMP.W	-$52A2(A4),D3	;_player + 40 (max hp)
	BNE.B	L0049E

	ADDQ.W	#1,-$52A2(A4)	;_player + 40 (max hp)
L0049E:
	MOVE.W	-$52A2(A4),-$52A8(A4)	;_player + 40 (max hp),_player + 34 (hp)
	JSR	_sight(PC)
	PEA	L004BC(PC)	;"you begin to feel much better"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L004AD

; potion of haste self

L0049F:
	ST	-$66DD(A4)	;_p_know + 10 (potion of haste self)
	MOVE.W	#$0001,-(A7)
	JSR	_add_haste(PC)
	ADDQ.W	#2,A7
	TST.W	D0
	BEQ.B	L004A0

	PEA	L004BD(PC)	;"you feel yourself moving much faster"
	JSR	_msg
	ADDQ.W	#4,A7
L004A0:
	BRA.W	L004AD

; restore strength

L004A1:
	TST.L	-$5190(A4)	;_cur_ring_1
	BEQ.B	L004A2

	MOVEA.L	-$5190(A4),A6	;_cur_ring_1
	CMPI.W	#R_ADDSTR,$0020(A6)
	BNE.B	L004A2

	MOVE.W	$0026(A6),D3
	NEG.W	D3
	MOVE.W	D3,-(A7)
	PEA	-$52B2(A4)	;_player + 24 (strength)
	JSR	_add_str(PC)
	ADDQ.W	#6,A7
L004A2:
	TST.L	-$518C(A4)	;_cur_ring_2
	BEQ.B	L004A3

	MOVEA.L	-$518C(A4),A6	;_cur_ring_2
	CMPI.W	#R_ADDSTR,$0020(A6)
	BNE.B	L004A3

	MOVE.W	$0026(A6),D3
	NEG.W	D3
	MOVE.W	D3,-(A7)
	PEA	-$52B2(A4)	;_player + 24 (strength)
	JSR	_add_str(PC)
	ADDQ.W	#6,A7
L004A3:
	MOVE.W	-$52B2(A4),D3	;_player + 24 (strength)
	CMP.W	-$6CC2(A4),D3	;_max_stats + 0 (max strength)
	BCC.B	L004A4

	MOVE.W	-$6CC2(A4),-$52B2(A4)	;_max_stats + 0 (max strength),_player + 24 (strength)
L004A4:
	TST.L	-$5190(A4)	;_cur_ring_1
	BEQ.B	L004A5

	MOVEA.L	-$5190(A4),A6	;_cur_ring_1
	CMPI.W	#R_ADDSTR,$0020(A6)
	BNE.B	L004A5

	MOVE.W	$0026(A6),-(A7)
	PEA	-$52B2(A4)	;_player + 24 (strength)
	JSR	_add_str(PC)
	ADDQ.W	#6,A7
L004A5:
	TST.L	-$518C(A4)	;_cur_ring_2
	BEQ.B	L004A6

	MOVEA.L	-$518C(A4),A6	;_cur_ring_2
	CMPI.W	#R_ADDSTR,$0020(A6)
	BNE.B	L004A6

	MOVE.W	$0026(A6),-(A7)
	PEA	-$52B2(A4)	;_player + 24 (strength)
	JSR	_add_str(PC)
	ADDQ.W	#6,A7
L004A6:
	LEA	L004BF(PC),a0	;"hey, this tastes great.  It makes "
	JSR	_noterse

	MOVE.L	D0,-(A7)
	PEA	L004BE(PC)	;"%syou feel warm all over"
	JSR	_msg
	ADDQ.W	#8,A7
	BRA.B	L004AD

; potion of blindness

L004A7:
	ST	-$66DB(A4)	;_p_know + 12 (potion of blindness)
	JSR	_p_blind(PC)
	PEA	L004C0(PC)	;"a cloak of darkness falls around you"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L004AD

; potion of thurst quenching

L004A8:
	PEA	L004C1(PC)	;"this potion tastes extremely dull"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L004AD
L004A9:
	PEA	L004C2(PC)	;"what an odd tasting potion!"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.W	L00483
L004AA:
	dc.w	L00488-L004AC	;potion of confusion
	dc.w	L00497-L004AC	;potion of paralysis
	dc.w	L00489-L004AC	;potion of poison
	dc.w	L00490-L004AC	;potion of gain strength
	dc.w	L00498-L004AC	;potion of see invisible
	dc.w	L0048E-L004AC	;potion of healing
	dc.w	L00491-L004AC	;potion of night vision
	dc.w	L00494-L004AC	;potion of discernment
	dc.w	L0049A-L004AC	;potion of raise level
	dc.w	L0049D-L004AC	;potion of extra healing
	dc.w	L0049F-L004AC	;potion of haste self
	dc.w	L004A1-L004AC	;potion of restore strength
	dc.w	L004A7-L004AC	;potion of blindness
	dc.w	L004A8-L004AC	;potion of thurst quenching
L004AB:
	CMP.w	#$000E,D0
	BCC.B	L004A9
	ASL.w	#1,D0
	MOVE.W	L004AA(PC,D0.W),D0
L004AC:	JMP	L004AC(PC,D0.W)
L004AD:
	JSR	_status

	MOVE.W	$0020(A2),D3
	MULU.W	#21,D3
	LEA	-$642E(A4),A6	;_p_guess
	ADD.L	A6,D3
	MOVE.L	D3,-(A7)
	MOVE.W	$0020(A2),D3
	LEA	-$66E7(A4),A6	;_p_know
	MOVEQ	#$00,D2
	MOVE.B	$00(A6,D3.W),D2
	MOVE.W	D2,-(A7)
	JSR	_call_it
	ADDQ.W	#6,A7

	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_pack_name
	ADDQ.W	#6,A7

	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_unpack
	ADDQ.W	#6,A7

	MOVE.L	D0,-(A7)
	JSR	_discard
	ADDQ.W	#4,A7
	BRA.W	L00483

L004AE:	dc.b	"quaff",0
L004AF:	dc.b	"yuk! Why would you want to drink that?",0
L004B0:	dc.b	"wait, what's going on? Huh? What? Who?",0
L004B1:	dc.b	"you feel %s sick.",0
L004B2:	dc.b	"very",0
L004B3:	dc.b	"momentarily",0
L004B4:	dc.b	"you begin to feel better",0
L004B5:	dc.b	"you feel stronger. What bulging muscles!",0
L004B6:	dc.b	"Your vision is clouded for a moment.  Now it seems very bright in here.",0
L004B7:	dc.b	"You feel light headed for a moment, then it passes.",0
L004B8:	dc.b	"you can't move",0
L004B9:	dc.b	"this potion tastes like %s juice",0
L004BA:	dc.b	"you suddenly feel much more skillful",0
L004BB:	dc.b	"you suddenly feel much less skillful",0
L004BC:	dc.b	"you begin to feel much better",0
L004BD:	dc.b	"you feel yourself moving much faster",0
L004BE:	dc.b	"%syou feel warm all over",0
L004BF:	dc.b	"hey, this tastes great.  It makes ",0
L004C0:	dc.b	"a cloak of darkness falls around you",0
L004C1:	dc.b	"this potion tastes extremely dull",0
L004C2:	dc.b	"what an odd tasting potion!",0,0

;/*
; * invis_on:
; *  Turn on the ability to see invisible
; */

_invis_on:
;	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	ORI.W	#C_CANSEE,-$52B4(A4)	;_player + 22 (flags)

	MOVEA.L	-$6CAC(A4),A2	;_mlist
	BRA.B	3$

1$	MOVE.W	$0016(A2),D3
	AND.W	#C_ISINVIS,D3	;check if the monster is invisible
	BEQ.B	2$

	MOVE.L	A2,-(A7)
	JSR	_see_monst
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	2$

	MOVE.B	$0010(A2),D2
	MOVE.W	$000A(A2),d1
	MOVE.W	$000C(A2),d0
	JSR	_mvaddchquick

2$	MOVEA.L	(A2),A2		;get next monster in list

3$	MOVE.L	A2,D3
	BNE.B	1$

	MOVEA.L	(A7)+,A2
;	UNLK	A5
	RTS

_th_effect:
	LINK	A5,#-$0000
	MOVEM.L	A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVEA.L	$000C(A5),A3
	MOVE.W	$0020(A2),D0
;	EXT.L	D0
	BRA.W	L004CD

; potion of confusion and potion of blindness

L004C6:
	ORI.W	#C_ISHUH,$0016(A3)	;monster is confused
	MOVE.B	$000F(A3),D3
	EXT.W	D3
	SUB.W	#$0041,D3	;'A'
	MULU.W	#26,D3
	LEA	-$6CA8(A4),A6	;_monsters
	MOVE.L	$00(A6,D3.L),-(A7)
	PEA	L004D0(PC)	;"the %s appears confused"
	JSR	_msg
	ADDQ.W	#8,A7
	BRA.B	L004CF

; potion of paralysis

L004C7:
	ANDI.W	#~C_ISRUN,$0016(A3)	;clear C_ISRUN
	ORI.W	#C_ISHELD,$0016(A3)	;set C_ISHELD
	BRA.B	L004CF

; potion of (extra) healing heals the monster 0-7 points

L004C8:
	MOVEq	#$0008,D0
	JSR	_rnd
	ADD.W	D0,$0022(A3)

	MOVE.W	$0022(A3),D3
	CMP.W	$0028(A3),D3
	BLE.B	L004C9

	ADDQ.W	#1,$0028(A3)
	MOVE.W	$0028(A3),$0022(A3)
L004C9:
	BRA.B	L004CF

; potion of raise level

L004CA:
	ADDQ.W	#8,$0022(A3)	;hp + 8
	ADDQ.W	#8,$0028(A3)	;max hp + 8
	ADDQ.W	#1,$001E(A3)
	BRA.B	L004CF

; potion of haste self

L004CB:
	ORI.W	#C_ISHASTE,$0016(A3)	;set C_ISHASTE
	BRA.B	L004CF

L004CC:
	dc.w	L004C6-L004CE	;confusion
	dc.w	L004C7-L004CE	;paralysis
	dc.w	L004CF-L004CE	;poison
	dc.w	L004CF-L004CE	;gain strength
	dc.w	L004CF-L004CE	;see invisible
	dc.w	L004C8-L004CE	;healing
	dc.w	L004CF-L004CE	;night vision
	dc.w	L004CF-L004CE	;discernment
	dc.w	L004CA-L004CE	;raise level
	dc.w	L004C8-L004CE	;extra healing
	dc.w	L004CB-L004CE	;haste self
	dc.w	L004CF-L004CE	;restore strength
	dc.w	L004C6-L004CE	;blindness
L004CD:
	CMP.w	#$000D,D0
	BCC.B	L004CF
	ASL.w	#1,D0
	MOVE.W	L004CC(PC,D0.W),D0
L004CE:	JMP	L004CE(PC,D0.W)

L004CF:
	PEA	L004D1(PC)	;"the flask shatters."
	JSR	_msg
	ADDQ.W	#4,A7
	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

L004D0:	dc.b	"the %s appears confused",0
L004D1:	dc.b	"the flask shatters.",0

_p_confuse:
;	LINK	A5,#-$0000

	MOVEq	#$0008,D0
	JSR	_rnd
	MOVE.W	D0,-(A7)	;save rnd to stack

	MOVEq	#20,D0
	JSR	_spread

	ADD.W	D0,(A7)		;add spread to rnd on stack

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISHUH,D3	;C_ISHUH
	BEQ.B	1$

	PEA	_unconfuse(PC)
	JSR	_lengthen(PC)
	ADDQ.W	#6,A7
	BRA.B	2$

1$	CLR.W	-(A7)
	PEA	_unconfuse(PC)
	JSR	_fuse(PC)
	ADDQ.W	#8,A7

2$	ORI.W	#C_ISHUH,-$52B4(A4)	;C_ISHUH,_player + 22 (flags)
;	UNLK	A5
	RTS

_p_blind:
;	LINK	A5,#-$0000
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3
	BNE.B	L004D4

	ORI.W	#C_ISBLIND,-$52B4(A4)	;_player + 22 (flags)

	MOVE.W	#300,D0
	JSR	_spread

	MOVE.W	D0,-(A7)
	CLR.W	-(A7)
	PEA	_sight(PC)
	JSR	_fuse(PC)
	ADDQ.W	#8,A7
	CLR.L	-(A7)
	JSR	_look
	ADDQ.W	#4,A7
L004D4:
;	UNLK	A5
	RTS

_clear:
;	LINK	A5,#-$0000
	MOVEM.L	D4/D5,-(A7)
	TST.B	-$7064(A4)	;_map_up
	BEQ.B	L004D5

	MOVEq	#$0020,d1
	MOVE.W	#1680,d0
	lea	-$76F6(A4),a0	;_screen_map
	JSR	_memset

L004D5:
	moveq	#0,d1
	moveq	#0,d0
	JSR	_movequick

	JSR	__clearbot(PC)
	MOVEM.L	(A7)+,D4/D5
;	UNLK	A5
	RTS

_redraw:
;	LINK	A5,#-$0000
	MOVEM.L	D4-D6,-(A7)
	JSR	_wmap

	moveq	#0,d1
	moveq	#1,d0
	JSR	_movequick

	JSR	__clearbot(PC)
	MOVEQ	#$01,D4
L004D6:
	MOVEQ	#$00,D5
L004D7:
	MOVE.W	D4,D3
	MULU.W	#$0050,D3
	ADD.w	D5,D3

	LEA	-$76F6(A4),A6	;_screen_map
	MOVEQ	#$00,D6
	MOVE.B	$00(A6,D3.w),D6
	CMP.W	#$0020,D6
	BEQ.B	L004D8

	CLR.B	$00(A6,D3.w)
	MOVE.W	D6,d2
	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_mvaddchquick

L004D8:
	ADDQ.W	#1,D5
	CMP.W	#60,D5
	BCS.B	L004D7

	ADDQ.W	#1,D4
	CMP.W	#21,D4
	BCS.B	L004D6

	MOVEM.L	(A7)+,D4-D6
;	UNLK	A5
	RTS

_cursor:
;	LINK	A5,#-$0000
	MOVEQ	#$00,D0
	MOVE.B	-$7063(A4),D0	;_graphics_disabled
	MOVE.B	$0005(A7),-$7063(A4)	;_graphics_disabled
;	UNLK	A5
	RTS

_clrtoeol:
;	LINK	A5,#-$0000

	TST.B	-$7064(A4)	;_map_up
	BEQ.B	1$

	MOVEq	#32,d1		;space for memset

	MOVEQ	#$00,D3
	MOVE.B	-$7065(A4),D3	;_c_col

	MOVEQ	#$00,D2
	MOVE.B	-$7066(A4),D2	;_c_row

	MOVEQ	#80,D0
	mulu.w	D0,d2
	SUB.W	D3,D0

	ADD.L	D3,D2
	LEA	-$76F6(A4),A0	;_screen_map
	ADD.L	D2,A0
	JSR	_memset

1$
	JSR	__clrtoeol(PC)
;	UNLK	A5
	RTS

_mvaddstr:
	LINK	A5,#-$0000

	MOVE.W	$000A(A5),d1
	MOVE.W	$0008(A5),d0
	JSR	_movequick

	MOVE.L	$000C(A5),-(A7)
	JSR	_addstr
	ADDQ.W	#4,A7
	UNLK	A5
	RTS

_mvaddchquick:
	MOVE.W	D2,-(A7)

	JSR	_movequick

	BSR.B	_addch
	ADDQ.W	#2,A7
	RTS

_mvinch:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5,-(A7)

	MOVE.W	$0008(A5),D4
	MOVE.W	$000A(A5),D5

	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_movequick

	MOVE.W	D4,D3
	MULU.W	#80,D3
	MOVE.W	D5,D2
	EXT.L	D2
	ADD.L	D2,D3
	LEA	-$76F6(A4),A6	;_screen_map
	MOVEQ	#$00,D0
	MOVE.B	$00(A6,D3.L),D0

	MOVEM.L	(A7)+,D4/D5
	UNLK	A5
	RTS

_inch:
;	LINK	A5,#-$0000

	MOVEQ	#$00,D0
	MOVE.B	-$7066(A4),D0	;_c_row

;	MOVEQ	#80,D1
;	JSR	_mulu
	mulu.w	#80,d0

	MOVEQ	#$00,D3
	MOVE.B	-$7065(A4),D3	;_c_col
	ADD.L	D0,D3
	LEA	-$76F6(A4),A6	;_screen_map
	MOVEQ	#$00,D0
	MOVE.B	$00(A6,D3.L),D3

;	UNLK	A5
	RTS

_addch:
	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)
	MOVE.B	$0009(A5),D4
	MOVEQ	#$00,D0
	MOVE.B	D4,D0
	BRA.W	L004E2
L004DA:
	MOVEQ	#$00,D1
	MOVE.B	-$7066(A4),D0	;_c_row
	JSR	_movequick

L004DB:
	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

L004DC:
	MOVEQ	#$00,D1
	MOVE.B	-$7066(A4),D0	;_c_row
	ADDQ.W	#1,D0
	JSR	_movequick

	BRA.B	L004DB
L004DD:
	TST.B	-$7064(A4)	;_map_up
	BNE.B	L004DE

	MOVE.W	D4,-(A7)
	JSR	__addch
	ADDQ.W	#2,A7
	BRA.W	L004E1
L004DE:
	MOVEQ	#$00,D0
	MOVE.B	-$7066(A4),D0	;_c_row

;	MOVEQ	#80,D1
;	JSR	_mulu
	mulu.w	#80,d0

	MOVEQ	#$00,D2
	MOVE.B	-$7065(A4),D2	;_c_col
	ADD.L	D2,D0
	LEA	-$76F6(A4),A6	;_screen_map
	MOVE.B	$00(A6,D0.L),D2
	CMP.B	D2,D4
	BEQ.B	L004E1

	TST.B	-$7066(A4)	;_c_row
	BLS.B	L004DF

	MOVE.B	-$7066(A4),D3	;_c_row
	CMP.B	#$14,D3
	BCC.B	L004DF

	TST.B	-$7063(A4)	;_graphics_disabled
	BNE.B	L004DF

	MOVE.W	D4,-(A7)
	JSR	__graphch(PC)
	ADDQ.W	#2,A7
	BRA.B	L004E0
L004DF:
	MOVE.W	D4,-(A7)
	JSR	__addch
	ADDQ.W	#2,A7
L004E0:
	MOVE.B	-$7065(A4),D3	;_c_col
	CMP.B	#$3C,D3
	BCC.B	L004E1

	MOVEQ	#$00,D0
	MOVE.B	-$7066(A4),D0	;_c_row

;	MOVEQ	#80,D1
;	JSR	_mulu
	mulu.w	#80,d0

	MOVEQ	#$00,D3
	MOVE.B	-$7065(A4),D3	;_c_col
	ADD.L	D3,D0
	LEA	-$76F6(A4),A6	;_screen_map
	MOVE.B	D4,$00(A6,D0.L)
L004E1:
	BRA.B	L004E3
L004E2:
	SUB.w	#$000A,D0
	BEQ.W	L004DC
	SUBQ.w	#3,D0
	BEQ.W	L004DA
	BRA.W	L004DD
L004E3:
	MOVE.B	-$7065(A4),D1	;_c_col
	ADDQ.W	#1,D1
	MOVE.B	-$7066(A4),D0	;_c_row
	JSR	_movequick

	BRA.W	L004DB

_addstr:
	LINK	A5,#-$0002
	MOVE.B	-$7063(A4),-$0001(A5)	;backup _graphics_disabled
	ST	-$7063(A4)	;_graphics_disabled

	MOVE.L	$0008(A5),-(A7)
	JSR	__zapstr(PC)
	ADDQ.W	#4,A7

	MOVE.L	$0008(A5),A0
	JSR	_strlenquick

	MOVE.B	-$7065(A4),D1	;_c_col
	ADD.B	D0,D1
	MOVE.B	-$7066(A4),D0	;_c_row
	JSR	_movequick

	MOVE.B	-$0001(A5),-$7063(A4)	;_graphics_disabled
	UNLK	A5
	RTS

;_set_attr:
;	LINK	A5,#-$0000
;	UNLK	A5
;	RTS

;_error:
;	LINK	A5,#-$0004
;	PEA	-$0004(A5)
;	PEA	-$0002(A5)
;	JSR	_getrc(PC)
;	ADDQ.W	#8,A7
;
;	moveq	#0,d1
;	MOVE.W	$0008(A5),d0
;	JSR	_movequick
;
;	JSR	_clrtoeol(PC)
;	MOVE.W	$0016(A5),-(A7)
;	MOVE.W	$0014(A5),-(A7)
;	MOVE.W	$0012(A5),-(A7)
;	MOVE.W	$0010(A5),-(A7)
;	MOVE.W	$000E(A5),-(A7)
;	MOVE.L	$000A(A5),-(A7)
;	BSR.B	_printw
;	LEA	$000E(A7),A7
;
;	MOVE.W	-$0004(A5),d1
;	MOVE.W	-$0002(A5),d0
;	BSR	_movequick
;
;	UNLK	A5
;	RTS

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

_printw:
	LINK	A5,#-$0084
	MOVE.L	$0028(A5),-(A7)
	MOVE.L	$0024(A5),-(A7)
	MOVE.L	$0020(A5),-(A7)
	MOVE.L	$001C(A5),-(A7)
	MOVE.L	$0018(A5),-(A7)
	MOVE.L	$0014(A5),-(A7)
	MOVE.L	$0010(A5),-(A7)
	MOVE.L	$000C(A5),-(A7)
	MOVE.L	$0008(A5),-(A7)
	PEA	-$0084(A5)
	JSR	_sprintf
	LEA	$0028(A7),A7
	PEA	-$0084(A5)
	JSR	_addstr
	ADDQ.W	#4,A7
	UNLK	A5
	RTS

; move the cursor

; D0 = row
; D1 = column

_movequick:
	CMP.B	#$50,D1		; position 80
	BCS.B	L004E4

	TST.B	D0
	BEQ.B	L004E5

	ADDQ.B	#1,D0
	MOVEQ	#$00,D1
L004E4:
	CMP.B	#21,D0		; more than 20 lines?
	BCS.B	L004E5

	MOVEQ	#20,D0		;20 is max
L004E5:
	MOVE.B	D0,-$7066(A4)	;_c_row
	MOVE.B	D1,-$7065(A4)	;_c_col

	MOVEQ	#$00,D3
	MOVE.B	-$7063(A4),D3	;_graphics_disabled
	MOVE.W	D3,-(A7)
;	MOVEQ	#$00,D3
	MOVE.B	D1,D3
	MOVE.W	D3,-(A7)
;	MOVEQ	#$00,D3
	MOVE.B	D0,D3
	MOVE.W	D3,-(A7)
	JSR	__move(PC)
	ADDQ.W	#6,A7
	RTS

_getrc:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEQ	#$00,D3
	MOVE.B	-$7066(A4),D3	;_c_row
	MOVEA.L	$0008(A5),A2
	MOVE.W	D3,(A2)
;	MOVEQ	#$00,D3
	MOVE.B	-$7065(A4),D3	;_c_col
	MOVEA.L	$000C(A5),A2
	MOVE.W	D3,(A2)

	MOVE.L	(A7)+,A2
	UNLK	A5
	RTS

_initscr:
;	LINK	A5,#-$0000
	JSR	_winit(PC)
;	UNLK	A5
	RTS

_endwin:
	LINK	A5,#-$0000
	JSR	_wclose(PC)
	UNLK	A5
	RTS

_ready_to_go:
;	LINK	A5,#-$0000
	MOVE.W	#$0001,-(A7)
	PEA	-$705E(A4)	;_my_palette
	JSR	_fade_in
	ADDQ.W	#6,A7
;	UNLK	A5
	RTS

;/*
; * setup:
; *  Get starting setup for all games
; */

_setup:
	LINK	A5,#-$0030
	CLR.B	-$66B2(A4)	;_terse
	CLR.B	-$66AB(A4)	;_expert
	MOVE.W	#22,-$60BC(A4)	;_maxrow

	CLR.L	-(A7)
	PEA	-$0030(A5)
	PEA	-$1
	PEA	L004E6(PC)		;"console.device"
	JSR	_OpenDevice

	LEA	$0010(A7),A7
	MOVE.L	-$001C(A5),-$48B6(A4)	;_ConsoleDevice
	BSR.B	_flush_type

	JSR	_BuildFuncTable

	PEA	L004E7(PC)		;"ea"
	MOVE.W	#$0001,-(A7)		;F1
	JSR	_NewFuncString
	ADDQ.W	#6,A7

	PEA	L004E8(PC)		;"TW"
	MOVE.W	#$0002,-(A7)		;F2
	JSR	_NewFuncString
	ADDQ.W	#6,A7

	PEA	L004E9(PC)		;"10s"
	MOVE.W	#$0003,-(A7)		;F3
	JSR	_NewFuncString
	ADDQ.W	#6,A7

	PEA	L004EA(PC)		"10."
	MOVE.W	#$0004,-(A7)		;F4
	JSR	_NewFuncString
	ADDQ.W	#6,A7

	UNLK	A5
	RTS

L004E6:	dc.b	"console.device",0
L004E7:	dc.b	"ea",0		; F1
L004E8:	dc.b	"TW",0		; F2
L004E9:	dc.b	"10s",0		; F3
L004EA:	dc.b	"10.",0,0	; F4

_flush_type:
	LINK	A5,#-$0000

	LEA	-$48B2(A4),A6
	MOVE.L	A6,-$47AE(A4)	;_kb_tail
	MOVE.L	A6,-$47B2(A4)
	TST.L	-$514C(A4)	;_StdWin
	BEQ.B	L004ED
L004EB:
	MOVEA.L	-$514C(A4),A6	;_StdWin
	MOVE.L	$0056(A6),-(A7)
	JSR	_GetMsg
	ADDQ.W	#4,A7
	TST.L	D0
	BEQ.B	L004ED

	MOVEA.L	D0,A6
	CMPI.L	#$00002000,$0014(A6)
	BNE.B	L004EC

	CMP.W	#$0001,$0018(A6)
	BNE.B	L004EC

	MOVE.W	#$0002,$0018(A6)
L004EC:
	MOVE.L	D0,-(A7)
	JSR	_ReplyMsg
	ADDQ.W	#4,A7
	BRA.B	L004EB
L004ED:
	UNLK	A5
	RTS

;/*
; * readchar:
; *  Reads and returns a character, checking for gross input errors
; */

_readchar:
	LINK	A5,#-$001E
	MOVEM.L	D4-D7/A2/A3,-(A7)
	CLR.W	-$001E(A5)
L004EE:
	MOVEA.L	-$47B2(A4),A6
	CMPA.L	-$47AE(A4),A6	;_kb_tail
	BEQ.B	L004F0

	MOVEA.L	-$47AE(A4),A6	;_kb_tail
	ADDQ.L	#1,-$47AE(A4)	;_kb_tail
	MOVE.B	(A6),D0
	EXT.W	D0
L004EF:
	MOVEM.L	(A7)+,D4-D7/A2/A3
	UNLK	A5
	RTS

L004F0:
	LEA	-$48B2(A4),A6
	MOVE.L	A6,-$47AE(A4)	;_kb_tail
	MOVE.L	A6,-$47B2(A4)
L004F1:
	MOVEA.L	-$514C(A4),A6	;_StdWin
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

	TST.B	-$48B8(A4)	;_menu_on
	BEQ.B	L004F5

	TST.B	-$7064(A4)	;_map_up
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
	MOVEA.L	-$47B2(A4),A6
	ADDQ.L	#1,-$47B2(A4)
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
	LEA	-$47B2(A4),A6
	SUBA.L	-$47B2(A4),A6
	MOVE.L	A6,-(A7)
	MOVE.L	-$47B2(A4),-(A7)
	PEA	-$001A(A5)
	JSR	_RawKeyConvert
	LEA	$0010(A7),A7
	MOVE.W	D0,-$001C(A5)
	MOVE.W	-$001C(A5),D3
	EXT.L	D3
	ADD.L	D3,-$47B2(A4)
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
	MOVE.B	#$01,-$66B1(A4)	;_com_from_menu
	MOVEA.L	-$47B2(A4),A6
	ADDQ.L	#1,-$47B2(A4)
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
	TST.B	-$7064(A4)	;_map_up
	BEQ.B	L00501

	MOVE.W	D6,D3
;	EXT.L	D3
	AND.w	#$0003,D3
	BEQ.B	L004FF

	MOVEA.L	-$47B2(A4),A6
	ADDQ.L	#1,-$47B2(A4)
	MOVE.B	#$2E,(A6)
	BRA.B	L00500
L004FF:
	TST.B	-$48B8(A4)	;_menu_on
	BEQ.B	L00500

	MOVEA.L	-$47B2(A4),A6
	ADDQ.L	#1,-$47B2(A4)
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
	TST.B	-$66B0(A4)	;_want_click
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
	TST.B	-$7064(A4)	;_map_up
	BNE.B	L00504

	CLR.W	-$001E(A5)
	MOVE.W	-$7060(A4),-(A7)
	JSR	_sel_char(PC)
	ADDQ.W	#2,A7
	TST.b	D0
	BEQ.B	L00504

	MOVEA.L	-$47B2(A4),A6
	ADDQ.L	#1,-$47B2(A4)
	MOVE.L	A6,-(A7)
	MOVE.W	-$7060(A4),-(A7)
	JSR	_sel_char(PC)
	ADDQ.W	#2,A7
	MOVEA.L	(A7)+,A6
	MOVE.B	D0,(A6)
	MOVE.W	-$7060(A4),-(A7)
	JSR	_invert_row(PC)
	ADDQ.W	#2,A7
	MOVE.W	#$FFFF,-$7060(A4)
L00504:
	BRA.B	L00508
L00505:
	TST.B	-$7064(A4)	;_map_up
	BEQ.B	L00506

	MOVE.W	D6,D3
;	EXT.L	D3
	AND.w	#$0003,D3
	BEQ.B	L00506

	MOVEA.L	-$47B2(A4),A6
	ADDQ.L	#1,-$47B2(A4)
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
	MOVEA.L	-$47B2(A4),A6
	MOVE.B	$0027(A3),(A6)
	MOVE.W	D6,D3
;	EXT.L	D3
	AND.w	#$0003,D3
	BEQ.B	L0050D
	MOVEA.L	-$47B2(A4),A6
	MOVE.B	(A6),D0
	EXT.W	D0
;	EXT.L	D0
	BRA.B	L0050C
L0050A:
	PEA	L00510(PC)		;"10s"
	MOVE.L	-$47B2(A4),-(A7)
	JSR	_strcpy
	ADDQ.W	#8,A7
	ADDQ.L	#2,-$47B2(A4)
	BRA.B	L0050D
L0050B:
	PEA	L00511(PC)		;"10."
	MOVE.L	-$47B2(A4),-(A7)
	JSR	_strcpy
	ADDQ.W	#8,A7
	ADDQ.L	#2,-$47B2(A4)
	BRA.B	L0050D
L0050C:
	SUB.w	#$002E,D0
	BEQ.B	L0050B
	SUB.w	#$0045,D0
	BEQ.B	L0050A
L0050D:
	ADDQ.L	#1,-$47B2(A4)
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
	MOVEA.L	-$514C(A4),A6	;_StdWin
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

_srand:
	LINK	A5,#-$000C
	PEA	-$000C(A5)
	JSR	_DateStamp
	ADDQ.W	#4,A7
	MOVE.L	-$0004(A5),D0
	ADD.L	-$000C(A5),D0
	ADD.L	-$0008(A5),D0
	UNLK	A5
	RTS

_credits:
	LINK	A5,#-$001C

	JSR	_black_out
	JSR	_wtext
	MOVE.W	#$0001,-(A7)
	MOVE.L	-$5144(A4),-(A7)	;_TextWin
	PEA	L00513(PC)	; "Title.Screen"
	st	-$47AA(A4)	;turn on _all_clear to reverse red/blue
	JSR	_show_ilbm
	LEA	$000A(A7),A7
;_SetOffset
	MOVE.W	#$0007,-$77D2(A4)	;_Window2 + 48
	MOVE.W	#$0005,-$77D0(A4)	;_Window2 + 50

	MOVE.W	#$0001,-(A7)
	JSR	_cursor(PC)
	ADDQ.W	#2,A7

	move.w	d0,-(a7)	;saving _graphics_disabled state

	MOVEq	#$0021,d1
	MOVEq	#$0013,d0
	JSR	_movequick

	MOVE.W	#$0017,-(A7)
	PEA	-$001B(A5)
	JSR	_getinfo
	ADDQ.W	#6,A7

;_SetOffset
	CLR.W	-$77D2(A4)	;_Window2 + 48
	CLR.W	-$77D0(A4)	;_Window2 + 50

;	CLR.W	-(A7)	;getting _graphics_disabled state back (its already on the stack)
	JSR	_cursor(PC)
	ADDQ.W	#2,A7

	TST.B	-$001B(A5)
	BEQ.B	L00512

	CMP.B	#$1B,-$001B(A5)
	BEQ.B	L00512

	PEA	-$001B(A5)
	PEA	-$672B(A4)	;_whoami
	JSR	_strcpy
	ADDQ.W	#8,A7
L00512:
	JSR	_wmap
	JSR	_black_out
	JSR	_clear
	UNLK	A5
	RTS

L00513:	dc.b	"Title.Screen.lz4",0,0

_newmem:
	MOVE.W	$0004(A7),-(A7)
	JSR	_malloc
	ADDQ.W	#2,A7

	TST.L	D0
	BNE.B	1$

	PEA	L00515(PC)	;"No Memory"
	JSR	_fatal
	ADDQ.W	#4,A7

1$	RTS

L00515:	dc.b	"No Memory",0

_beep:
;	LINK	A5,#-$0000

	move.l	-$5150(A4),a0	;_StdScr
	MOVEA.L	-$5188(A4),A6	;_IntuitionBase
	jsr	_LVODisplayBeep(A6)

;	UNLK	A5
	RTS

_tick_pause:
	BSR.B	_one_tick
	BSR.B	_one_tick
	BSR.B	_one_tick
	BSR.B	_one_tick
	RTS

_one_tick:
	LINK	A5,#-$000C
	MOVE.L	D4,-(A7)
	PEA	-$000C(A5)
	JSR	_DateStamp
	ADDQ.W	#4,A7
	MOVE.L	-$0004(A5),D4
L00517:
	PEA	-$000C(A5)
	JSR	_DateStamp
	ADDQ.W	#4,A7

	CMP.L	-$0004(A5),D4
	BEQ.B	L00517

	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

_NewRank:
	LINK	A5,#-$0078

	CLR.B	-$0078(A5)
	CMPI.W	#$0001,-$52AC(A4)	;_player + 30 (rank)
	BLE.B	L00519

	MOVE.W	-$52AC(A4),D3	;_player + 30 (rank)
	SUBQ.W	#1,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$6D28(A4),A6	;_he_man
	MOVE.L	$00(A6,D3.w),-(A7)
	PEA	L00520(PC)	;' "%s"'
	PEA	-$0078(A5)
	JSR	_sprintf
	LEA	$000C(A7),A7
L00519:
	CMPI.W	#$0001,-$60B4(A4)	;_level
	BNE.B	L0051B

	CMPI.W	#$0002,-$52AC(A4)	;_player + 30 (rank)
	BGE.B	L0051B

	TST.W	-$609A(A4)	;_hungry_state
	BNE.B	L0051B
L0051A:
	UNLK	A5
	RTS

L0051B:
	MOVE.W	-$609A(A4),D3	;_hungry_state
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$701E(A4),A6	;_hungry_state_texts
	MOVE.L	$00(A6,D3.w),-(A7)
	MOVE.W	-$60B4(A4),-(A7)	;_level
	PEA	-$0078(A5)
	PEA	-$672B(A4)	;_whoami
	PEA	L00521(PC)	;"Rogue: %s%s on level %d  %s"
	PEA	-$0050(A5)
	JSR	_sprintf
	LEA	$0016(A7),A7
	PEA	-$0050(A5)
	JSR	_ScreenTitle(PC)
	ADDQ.W	#4,A7
	BRA.B	L0051A

L0051C:	dc.b	$00
L0051D:	dc.b	"Hungry",0
L0051E:	dc.b	"Weak",0
L0051F:	dc.b	"Faint",0
L00520:	dc.b	' "%s"',0
L00521:	dc.b	"Rogue: %s%s on level %d  %s",0,0

_sel_line:
;	LINK	A5,#-$0000
	MOVE.W	$0004(A7),D0
	EXT.L	D0
	DIVS.W	#$0009,D0
;	UNLK	A5
	RTS

_db_print:
	LINK	A5,#-$0000
	TST.B	-$66AC(A4)	;_db_enabled
	BEQ.B	1$

	MOVE.L	$0024(A5),-(A7)
	MOVE.L	$0020(A5),-(A7)
	MOVE.L	$001C(A5),-(A7)
	MOVE.L	$0018(A5),-(A7)
	MOVE.L	$0014(A5),-(A7)
	MOVE.L	$0010(A5),-(A7)
	MOVE.L	$000C(A5),-(A7)
	MOVE.L	$0008(A5),-(A7)
	JSR	_printf
	LEA	$0020(A7),A7

1$	UNLK	A5
	RTS

_ask_him:
	LINK	A5,#-$003C
	MOVEM.L	D4/D5,-(A7)

	MOVE.W	#$0006,-(A7)
	PEA	-$0014(A5)
	MOVE.L	$0008(A5),-(A7)
	JSR	_ctointui
	LEA	$000A(A7),A7

	MOVE.W	#$0006,-(A7)
	PEA	-$0028(A5)
	MOVE.L	$000C(A5),-(A7)
	JSR	_ctointui
	LEA	$000A(A7),A7

	MOVE.W	#$0006,-(A7)
	PEA	-$003C(A5)
	MOVE.L	$0010(A5),-(A7)
	JSR	_ctointui
	LEA	$000A(A7),A7

	MOVE.L	$0008(A5),-(A7)
	JSR	_scrlen(PC)
	ADDQ.W	#4,A7

	EXT.L	D0
	MOVE.L	D0,D4
	MOVE.L	-$001C(A5),-(A7)
	JSR	_scrlen(PC)
	ADDQ.W	#4,A7

	MOVE.W	D0,-(A7)
	MOVE.L	-$0030(A5),-(A7)
	JSR	_scrlen(PC)
	ADDQ.W	#4,A7

	MOVE.W	(A7)+,D3
	ADD.W	D0,D3
	EXT.L	D3
	MOVE.L	D3,D5
	ADD.L	#$00000050,D5
	CMP.L	D5,D4
	BGE.B	L00523

	MOVE.L	D5,D4
	MOVE.L	D4,D0
	ADD.L	#$00000028,D0
	MOVEQ	#$02,D1
	JSR	_divu
	MOVE.L	D0,-(A7)
	MOVE.L	$0008(A5),-(A7)
	JSR	_scrlen(PC)
	ADDQ.W	#4,A7
	EXT.L	D0
	MOVE.L	(A7)+,D3
	SUB.L	D0,D3
	MOVE.W	D3,-$0010(A5)
L00523:
	MOVE.W	#$0004,-$000E(A5)
	MOVE.W	#$0004,-$0036(A5)
	MOVE.W	#$0004,-$0022(A5)
	PEA	$0046
	MOVEA.L	D4,A6
	PEA	$0028(A6)
	CLR.L	-(A7)
	CLR.L	-(A7)
	PEA	-$003C(A5)
	PEA	-$0028(A5)
	PEA	-$0014(A5)
	MOVE.L	-$514C(A4),-(A7)	;_StdWin
	JSR	_AutoRequest
	LEA	$0020(A7),A7
	MOVEM.L	(A7)+,D4/D5
	UNLK	A5
	RTS

_warning:
	LINK	A5,#-$0000

	PEA	L00527(PC)	;"Don't use it"
	PEA	L00526(PC)	;"Use it anyway"
	MOVE.L	$0008(A5),-(A7)
	JSR	_ask_him(PC)
	LEA	$000C(A7),A7
	TST.W	D0
	BNE.B	L00524

	MOVEq	#$0001,D0
	BRA.B	L00525
L00524:
	CLR.W	D0
L00525:
	UNLK	A5
	RTS

L00526:	dc.b	"Use it anyway",0
L00527:	dc.b	"Don't use it",0,0

_scrlen:
	LINK	A5,#-$0000

	MOVE.L	$0008(A5),A0
	JSR	_strlenquick

	EXT.L	D0
	MOVE.L	D0,-(A7)
	MOVE.L	$0008(A5),-(A7)
	MOVEA.L	-$514C(A4),A6	;_StdWin
	MOVE.L	$0032(A6),-(A7)
	JSR	_TextLength
	LEA	$000C(A7),A7

	UNLK	A5
	RTS

_choose_row:
	LINK	A5,#-$0000

	CMPI.W	#$FFFF,-$7060(A4)
	BEQ.B	L00528

	MOVE.W	-$7060(A4),D3
	CMP.W	$0008(A5),D3
	BEQ.B	L00528

	MOVE.W	D3,-(A7)
	JSR	_invert_row(PC)
	ADDQ.W	#2,A7
	MOVE.W	#$FFFF,-$7060(A4)
L00528:
	MOVE.W	$0008(A5),-(A7)
	JSR	_sel_char(PC)
	ADDQ.W	#2,A7
	TST.b	D0
	BEQ.B	L00529

	MOVE.W	$0008(A5),D3
	CMP.W	-$7060(A4),D3
	BEQ.B	L00529

	MOVE.W	D3,-(A7)
	JSR	_invert_row(PC)
	ADDQ.W	#2,A7
	MOVE.W	$0008(A5),-$7060(A4)
L00529:
	UNLK	A5
	RTS

_stuck:
;	LINK	A5,#-$0000
	LEA	L0052B(PC),a0	;"can't drop it, "
	JSR	_noterse

	MOVE.L	D0,-(A7)
	PEA	L0052A(PC)	;"%sit appears to be stuck in your pack!"
	JSR	_msg
	ADDQ.W	#8,A7
	CLR.B	-$66F9(A4)	;_after
	MOVEQ	#$00,D0
;	UNLK	A5
	RTS

L0052A:	dc.b	"%sit appears to be stuck in your pack!",0
L0052B:	dc.b	"can't drop it, ",0,0

;/*
; * drop:
; *  Put something down
; */

_drop:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2/A3,-(A7)

	JSR	_INDEXplayer

	MOVEA.L	-$519C(A4),A6	;__level
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

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	$000B(A3),$00(A6,D0.W)
	MOVEA.L	A3,A6
	ADDA.L	#$0000000C,A6
	LEA	-$52C0(A4),A1	;_player + 10
	MOVE.L	(A1)+,(A6)+
	CMPI.W	#$002C,$000A(A3)	;','
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
	CMPA.L	-$5294(A4),A2	;_cur_armor
	BEQ.B	L0053A
	CMPA.L	-$5298(A4),A2	;_cur_weapon
	BEQ.B	L0053A
	CMPA.L	-$5190(A4),A2	;_cur_ring_1
	BEQ.B	L0053A
	CMPA.L	-$518C(A4),A2	;_cur_ring_2
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
	CMPA.L	-$5298(A4),A2	;_cur_weapon
	BNE.B	L0053C
	CLR.L	-$5298(A4)	;_cur_weapon
	BRA.B	L00542
L0053C:
	CMPA.L	-$5294(A4),A2	;_cur_armor
	BNE.B	L0053D
	JSR	_waste_time(PC)
	CLR.L	-$5294(A4)	;_cur_armor
	BRA.B	L00542
L0053D:
	MOVEQ	#$00,D3
	LEA	-$5190(A4),A6	;_cur_ring_x
	CMPA.L	$00(A6,D3.w),A2	;ring slot 0
	BEQ.B	L0053E
	MOVEQ	#$04,D3
	CMPA.L	$00(A6,D3.w),A2	;ring slot 1
	BNE.B	L00538b
L0053E:
;	LEA	-$5190(A4),A6	;_cur_ring_x
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
	CLR.W	$0024(A2)		;zero hit
	CLR.W	$0022(A2)		;zero damage
	MOVE.L	-$69AE(A4),$001A(A2)	;_no_damage
	MOVE.L	$001A(A2),$0016(A2)
	MOVE.W	#$000B,$0026(A2)	;armor class base value
	MOVE.W	#$0001,$001E(A2)	;one item
	CLR.W	$002C(A2)		;no group
	CLR.W	$0028(A2)		;flags like cursed and so on
	CLR.B	$002A(A2)
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
	MOVE.W	D0,$0020(A2)
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
	SUB.W	D0,$0022(A2)
	BRA.B	L0054F
L0054E:
	CMP.W	#15,D5
	BGE.B	L0054F

	MOVEq	#$0003,D0
	JSR	_rnd
	ADDQ.W	#1,D0
	ADD.W	D0,$0022(A2)
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
	CMP.W	#28,D5		;only good values by a roll higher than 28
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
	JSR	_fix_stick(PC)
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
	LEA	-$642E(A4),A3	;_p_guess
	BSR.B	_print_disc

	PEA	L00567(PC)	;" ",0
	PEA	-$69CC(A4)	;_nullstr
	JSR	_add_line(PC)
	ADDQ.W	#8,A7

	MOVEq	#$003F,D7	;'?' scrolls
	MOVEQ	#15,D5
	LEA	-$66F6(A4),A2	;_s_know
	LEA	-$656A(A4),A3	;_s_guess
	BSR.B	_print_disc

	PEA	L00567(PC)	;" ",0
	PEA	-$69CC(A4)	;_nullstr
	JSR	_add_line(PC)
	ADDQ.W	#8,A7

	MOVEq	#$003D,D7	;'=' rings
	MOVEQ	#14,D5
	LEA	-$66D9(A4),A2	;_r_know
	LEA	-$6308(A4),A3	;_r_guess
	BSR.B	_print_disc

	PEA	L00567(PC)	;" ",0
	PEA	-$69CC(A4)	;_nullstr
	JSR	_add_line(PC)
	ADDQ.W	#8,A7

	MOVEq	#$002F,D7	;'/' sticks
	MOVEQ	#14,D5
	LEA	-$66CB(A4),A2	;_ws_know
	LEA	-$61E2(A4),A3	;_ws_guess
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
	MOVE.L	-$5258(A4),-(A7)	;_prbuf
	JSR	_sprintf
	ADDQ.W	#8,A7

	TST.B	-$66B2(A4)	;_terse
	BEQ.B	L00586

	PEA	L0058E(PC)	;"Nothing"
	MOVE.L	-$5258(A4),-(A7)	;_prbuf
	JSR	_sprintf
	ADDQ.W	#8,A7
L00586:
	MOVE.L	-$5258(A4),A0	;_prbuf
	JSR	_strlenquick

	EXT.L	D0
	MOVEA.L	D0,A2
	ADDA.L	-$5258(A4),A2	;_prbuf
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
	MOVE.L	-$5258(A4),D0	;_prbuf

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

_dm_null:
;	LINK	A5,#-$0000
;	UNLK	A5
	RTS

;/*
; * d_slot:
; *  Find an empty slot in the daemon/fuse list
; */

_d_slot:
;	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)
	LEA	-$544A(A4),A2
	LEA	-$53D2(A4),A6
L00594:
	TST.W	(A2)
	BEQ.B	L00596

	ADDQ.L	#6,A2
	CMPA.L	A6,A2
	BCS.B	L00594

	MOVEQ	#$00,D0
L00595:
	MOVEA.L	(A7)+,A2
;	UNLK	A5
	RTS

L00596:
	MOVE.L	A2,D0
	BRA.B	L00595

;/*
; * find_slot:
; *  Find a particular slot in the table
; */

_find_slot:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	LEA	-$544A(A4),A2
	LEA	-$53D2(A4),A6

	MOVE.W	$0008(A5),D3	;looking for this

L00597:
	CMP.W	(A2),D3
	BEQ.B	L00599

	ADDQ.L	#6,A2
	CMPA.L	A6,A2
	BCS.B	L00597

	MOVEQ	#$00,D0
L00598:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L00599:
	MOVE.L	A2,D0
	BRA.B	L00598

;/*
; * start_daemon:
; *  Start a daemon, takes a function.
; */

_daemon:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	BSR.B	_d_slot
	MOVEA.L	D0,A2
	MOVE.L	$0008(A5),-(A7)
	JSR	_cvt_f_i(PC)
	ADDQ.W	#4,A7
	MOVE.W	D0,(A2)
	MOVE.W	$000C(A5),$0002(A2)
	MOVE.W	#$FFFB,$0004(A2)

	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

;/*
; * do_daemons:
; *  Run all the daemons that are active with the current flag,
; *  passing the argument to the function.
; */

_do_daemons:
;	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	LEA	-$544A(A4),A6
	MOVEA.L	A6,A2
L0059A:
	TST.W	(A2)
	BEQ.B	L0059C

	CMPI.W	#$FFFB,$0004(A2)
	BEQ.B	L0059B

	SUBQ.W	#1,$0004(A2)
;	CMPI.W	#$0000,$0004(A2)
	BGT.B	L0059C
L0059B:
	MOVE.W	$0002(A2),-(A7)
	MOVE.W	(A2),D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$700E(A4),A6		;_dm_null, start of deamon callbacks
	MOVEA.L	$00(A6,D3.w),A1
	JSR	(A1)
	ADDQ.W	#2,A7
	CMPI.W	#$FFFB,$0004(A2)
	BEQ.B	L0059C

	CLR.W	(A2)
L0059C:
	ADDQ.L	#6,A2
	LEA	-$53D2(A4),A6
	CMPA.L	A6,A2
	BCS.B	L0059A

	MOVEA.L	(A7)+,A2
;	UNLK	A5
	RTS

;/*
; * fuse:
; *  Start a fuse to go off in a certain number of turns
; */

_fuse:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	JSR	_d_slot(PC)
	MOVEA.L	D0,A2
	MOVE.L	$0008(A5),-(A7)
	BSR.B	_cvt_f_i
	ADDQ.W	#4,A7
	MOVE.W	D0,(A2)
	MOVE.W	$000C(A5),$0002(A2)
	MOVE.W	$000E(A5),$0004(A2)

	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

;/*
; * lengthen:
; *  Increase the time until a fuse goes off
; */

_lengthen:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVE.L	$0008(A5),-(A7)
	BSR.B	_cvt_f_i
	ADDQ.W	#4,A7
	MOVE.W	D0,-(A7)
	JSR	_find_slot(PC)
	ADDQ.W	#2,A7
	MOVEA.L	D0,A2
	TST.L	D0
	BEQ.B	1$

	MOVE.W	$000C(A5),D3
	ADD.W	D3,$0004(A2)
1$
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS


;/*
; * extinguish:
; *  Put out a fuse
; */

_extinguish:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)
	MOVE.L	$0008(A5),-(A7)
	BSR.B	_cvt_f_i
	ADDQ.W	#4,A7
	MOVE.W	D0,-(A7)
	JSR	_find_slot(PC)
	ADDQ.W	#2,A7
	MOVEA.L	D0,A2
	TST.L	D0
	BEQ.B	1$

	CLR.W	(A2)

1$	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

_cvt_f_i:
	LINK	A5,#-$0000
	MOVEM.L	A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	LEA	-$700E(A4),A6
	MOVEA.L	A6,A3
	BRA.B	L005A4
L005A1:
	MOVEA.L	(A3),A6
	CMPA.L	A2,A6
	BNE.B	L005A3

	MOVE.L	A3,D0
	LEA	-$700E(A4),A6
	SUB.L	A6,D0
	LSR.L	#2,D0
L005A2:
	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

L005A3:
	ADDQ.L	#4,A3
L005A4:
	TST.L	(A3)
	BNE.B	L005A1

	PEA	L005A5(PC)	;"A new kind of fuse was experienced."
	JSR	_db_print
	ADDQ.W	#4,A7
	MOVEQ	#$00,D0
	BRA.B	L005A2
L005A5:
	dc.b	"A new kind of fuse was experienced.",0

_dm_xfer:
;	LINK	A5,#-$0000
	MOVE.W	#$0078,-(A7)
	PEA	-$544A(A4)
	JSR	_xfer
	ADDQ.W	#6,A7
;	UNLK	A5
	RTS

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
	MOVEM.L	D4/D5/A2,-(A7)
	MOVEA.L	$0008(A5),A2
	MOVEQ	#$00,D4
	TST.L	-$5190(A4)	;_cur_ring_1
	BNE.B	L005B9
	TST.L	-$518C(A4)	;_cur_ring_2
	BNE.B	L005B9
	PEA	L005BF(PC)	;"you aren't wearing any rings"
	JSR	_msg
	ADDQ.W	#4,A7
	CLR.B	-$66F9(A4)	;_after
L005B8:
	MOVEM.L	(A7)+,D4/D5/A2
	UNLK	A5
	RTS

L005B9:
	TST.L	-$5190(A4)	;_cur_ring_1
	BNE.B	L005BA
	MOVEQ	#$01,D4
	BRA.B	L005BC
L005BA:
	TST.L	-$518C(A4)	;_cur_ring_2
	BNE.B	L005BB
	MOVEQ	#$00,D4
	BRA.B	L005BC
L005BB:
	MOVE.L	A2,D3
	BNE.B	L005BC
	JSR	_gethand(PC)
	MOVE.W	D0,D4
;	CMP.W	#$0000,D0
	BGE.B	L005BC
	BRA.B	L005B8
L005BC:
	MOVE.W	D4,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$5190(A4),A6	;_cur_ring_1
	MOVEA.L	$00(A6,D3.w),A2
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
	JSR	_pack_char(PC)
	ADDQ.W	#4,A7
	MOVE.B	D0,D5
	MOVE.L	A2,-(A7)
	JSR	_can_drop(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L005BE
	MOVE.B	D5,D3
	EXT.W	D3
	MOVE.W	D3,-(A7)
	MOVE.W	#$001E,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_nameof
	ADDQ.W	#6,A7
	MOVE.L	D0,-(A7)
	PEA	L005C1(PC)	;"was wearing %s(%c)"
	JSR	_msg
	LEA	$000A(A7),A7
L005BE:
	BRA.W	L005B8

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

L005CC:
	MOVE.L	D0,A1
	MOVE.W	$0020(A1),D0
	BRA.B	L005DB
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
L005DB:
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

; weapon damage wielded and thrown

; mace
L005E8:	dc.b	"2d4",0	; 2-8 avg 5
L005E9:	dc.b	"1d3",0	; 1-3 avg 2

; broad sword
L005EA:	dc.b	"2d8",0	; 2-16 avg 9
L005EB:	dc.b	"1d2",0	; 1-2 avg 1.5

; short bow
L005EC:	dc.b	"1d1",0	; 1-1 avg 1
L005ED:	dc.b	"1d1",0	; 1-1 avg 1

; arrow
L005EE:	dc.b	"1d1",0	; 1-1 avg 1
L005EF:	dc.b	"2d3",0	; 2-6 avg 4

; dagger
L005F0:	dc.b	"1d6",0	; 1-6 avg 3.5
L005F1:	dc.b	"1d4",0	; 1-4 avg 2.5

; two handed sword
L005F2:	dc.b	"4d4",0	; 4-16 avg 10	;best wielded weapon
L005F3:	dc.b	"1d2",0	; 1-2 avg 1.5

; dart
L005F4:	dc.b	"1d1",0	; 1-1 avg 1
L005F5:	dc.b	"1d3",0	; 1-3 avg 2

; crossbow
L005F6:	dc.b	"1d1",0	; 1-1 avg 1
L005F7:	dc.b	"1d1",0	; 1-1 avg 1

; crossbow bolts
L005F8:	dc.b	"1d2",0	; 1-2 avg 1.5
L005F9:	dc.b	"2d5",0	; 2-10 avg 6	;best throw weapon

; flail
L005FA:	dc.b	"2d6",0	; 2-12 avg 7
L005FB:	dc.b	"1d6",0	; 1-6 avg 3.5

;/*
; * missile:
; *  Fire a missile in a given direction
; */

_missile:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVE.W	#$006D,-(A7)	;m weapon type
	PEA	L00603(PC)	;"throw"
	JSR	_get_item
	ADDQ.W	#6,A7

	MOVEA.L	D0,A2
	TST.L	D0
	BNE.B	L005FD
L005FC:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L005FD:
	MOVE.L	A2,-(A7)
	JSR	_can_drop(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L005FC

	MOVE.L	A2,-(A7)
	JSR	_is_current(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.B	L005FC

	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_unpack
	ADDQ.W	#6,A7

	MOVEA.L	D0,A2
	TST.L	D0
	BNE.B	L00600

	JSR	_stuck(PC)
	BRA.B	L005FC
L00600:
	MOVE.W	$000A(A5),-(A7)
	MOVE.W	$0008(A5),-(A7)
	MOVE.L	A2,-(A7)
	BSR.B	_do_motion
	ADDQ.W	#8,A7

	MOVE.W	$000C(A2),d1
	MOVE.W	$000E(A2),d0
	JSR	_moatquick

	TST.L	D0
	BEQ.B	L00601

	MOVE.L	A2,-(A7)
	MOVE.W	$000C(A2),-(A7)
	MOVE.W	$000E(A2),-(A7)
	JSR	_hit_monster(PC)
	ADDQ.W	#8,A7
	TST.W	D0
	BNE.B	L005FC
L00601:
	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_fall(PC)
	ADDQ.W	#6,A7
	BRA.B	L005FC

L00603:	dc.b	"throw",0

;/*
; * do_motion:
; *  Do the actual motion on the screen done by an object traveling
; *  across the room
; */

_do_motion:
	LINK	A5,#-$0000
	MOVEM.L	D4-D7,-(A7)

	MOVE.W	$000C(A5),D4
	MOVE.W	$000E(A5),D5
	MOVEQ	#$22,D6
	MOVEA.L	$0008(A5),A6
	ADDA.L	#$0000000C,A6
	LEA	-$52C0(A4),A1	;_player + 10
	MOVE.L	(A1)+,(A6)+
L00604:
	CMP.b	#$22,D6		;'"'
	BEQ.B	L00605

	PEA	-$52C0(A4)	;_player + 10
	MOVEA.L	$0008(A5),A6
	PEA	$000C(A6)
	JSR	__ce
	ADDQ.W	#8,A7

	TST.W	D0
	BNE.B	L00605

	MOVEA.L	$0008(A5),A6
	MOVE.W	$000C(A6),-(A7)
;	MOVEA.L	$0008(A5),A6
	MOVE.W	$000E(A6),-(A7)
	JSR	_cansee
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00605

	MOVE.B	D6,D2
	MOVEA.L	$0008(A5),A6
	MOVE.W	$000C(A6),d1
	MOVE.W	$000E(A6),d0
	JSR	_mvaddchquick

L00605:
	MOVEA.L	$0008(A5),A6
	ADD.W	D4,$000E(A6)
	ADD.W	D5,$000C(A6)
	MOVE.W	$000C(A6),-(A7)
	MOVE.W	$000E(A6),-(A7)
	JSR	_winat
	ADDQ.W	#4,A7

	MOVE.W	D0,D7
	MOVE.W	D0,-(A7)
	JSR	_step_ok
	ADDQ.W	#2,A7
	TST.W	D0
	BEQ.B	L0060A

	CMP.W	#$002B,D7	;'+'
	BEQ.B	L0060A

	MOVEA.L	$0008(A5),A6
	MOVE.W	$000C(A6),-(A7)
	MOVE.W	$000E(A6),-(A7)
	JSR	_cansee
	ADDQ.W	#4,A7

	TST.W	D0
	BEQ.B	L00606

	MOVEA.L	$0008(A5),A6
	MOVE.W	$000C(A6),d0
	MOVE.W	$000E(A6),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	$00(A6,D0.W),D6

	MOVEA.L	$0008(A5),A6
	MOVE.W	$000A(A6),d2
	MOVE.W	$000C(A6),d1
	MOVE.W	$000E(A6),d0
	JSR	_mvaddchquick

	JSR	_tick_pause
	BRA.B	L00609
L00606:
	MOVEQ	#$22,D6
L00609:
	BRA.W	L00604
L0060A:
	MOVEM.L	(A7)+,D4-D7
	UNLK	A5
	RTS

;/*
; * fall:
; *  Drop an item someplace around here.
; */

_fall:
	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)
	PEA	-$53D2(A4)
	MOVE.L	$0008(A5),-(A7)
	JSR	_fallpos(PC)
	ADDQ.W	#8,A7
;	EXT.L	D0
	BRA.W	L00611
L0060B:
	MOVE.W	-$53D2(A4),d0
	MOVE.W	-$53D0(A4),d1
	JSR	_INDEXquick

	MOVE.W	D0,D4
	MOVEA.L	-$519C(A4),A6	;__level
	MOVEA.L	$0008(A5),A1
	MOVE.B	$000B(A1),$00(A6,D4.W)
	MOVEA.L	$0008(A5),A6
	ADDA.L	#$0000000C,A6
	LEA	-$53D2(A4),A1
	MOVE.L	(A1)+,(A6)+
	MOVE.W	-$53D2(A4),-(A7)
	MOVE.W	-$53D0(A4),-(A7)
	JSR	_cansee
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.W	L0060E

	MOVEA.L	$0008(A5),A6

	MOVE.W	$000C(A6),d0
	MOVE.W	$000E(A6),d1
	JSR	_INDEXquick

	MOVEA.L	-$5198(A4),A6	;__flags
;	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	AND.B	#$40,D3
	BNE.B	L0060C

;	MOVEA.L	$0008(A5),A6
;	MOVE.W	$000C(A6),d0
;	MOVE.W	$000E(A6),d1
;	JSR	_INDEXquick

;	MOVEA.L	-$5198(A4),A6	;__flags
;	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	AND.B	#$20,D3
	BEQ.B	L0060D
L0060C:
	JSR	_standout
L0060D:
	MOVEA.L	$0008(A5),A6
	MOVE.W	$000A(A6),d2
	MOVE.W	-$53D2(A4),d1
	MOVE.W	-$53D0(A4),d0
	JSR	_mvaddchquick

	JSR	_standend

	MOVE.W	-$53D2(A4),d1
	MOVE.W	-$53D0(A4),d0
	JSR	_moatquick

	TST.L	D0
	BEQ.B	L0060E

	MOVEA.L	D0,A6
	MOVEA.L	$0008(A5),A1
	MOVE.B	$000B(A1),$0011(A6)
L0060E:
	MOVE.L	$0008(A5),-(A7)
	PEA	-$6CB0(A4)	;_lvl_obj
	JSR	__attach
	ADDQ.W	#8,A7
L0060F:
	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

L00610:
	CLR.B	$000D(A5)
	BRA.B	L00612
L00611:
	SUBQ.w	#1,D0
	BEQ.W	L0060B
	SUBQ.w	#1,D0
	BEQ.B	L00610
L00612:
	TST.B	$000D(A5)
	BEQ.B	L00613

	LEA	L00615(PC),a0	;" as it hits the ground"
	JSR	_noterse

	MOVE.L	D0,-(A7)
	CLR.W	-(A7)
	MOVE.L	$0008(A5),-(A7)
	JSR	_nameof
	ADDQ.W	#6,A7
	MOVE.L	D0,-(A7)
	PEA	L00614(PC)	;"the %s vanishes%s."
	JSR	_msg
	LEA	$000C(A7),A7
L00613:
	MOVE.L	$0008(A5),-(A7)
	JSR	_discard
	ADDQ.W	#4,A7
	BRA.B	L0060F

L00614:	dc.b	"the %s vanishes%s.",0
L00615:	dc.b	" as it hits the ground",0

;/*
; * init_weapon:
; *  Set up the initial goodies for a weapon
; */

_init_weapon:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	$0008(A5),A2	;empty object we fill up now
	MOVE.W	$0020(A2),D0	;weapon index

	MOVEQ	#$6D,D3
	ADD.B	D0,D3		; 'm' 'weapon type
	MOVE.W	D3,$000A(A2)

	mulu.w	#12,d0

	LEA	-$6FDA(A4),A6		;_w_magic
	MOVE.L	$00(A6,D0.w),$0016(A2)	;wield damage
	MOVE.L	$04(A6,D0.w),$001A(A2)	;throw damage
	MOVE.B	$08(A6,D0.w),$0014(A2)	;weapon needed for better throw
	MOVE.W	$0A(A6,D0.w),D3		;flags
	move.w	D3,$0028(A2)

	moveq	#0,d1		;set group
	moveq	#1,d0		;default number of items
	AND.W	#O_ISMANY,D3	;check for O_ISMANY
	BEQ.B	1$

	MOVEq	#$0008,D0	;random count of bolts, arrows, darts...
	JSR	_rnd
	ADDQ.W	#8,D0		; add 8 - 15

	MOVE.W	-$609C(A4),d1	;get group for item
	ADDQ.W	#1,-$609C(A4)	;_group++

1$	MOVE.W	d0,$001E(A2)	;one or the random number of items
	MOVE.W	d1,$002C(A2)	;set group for item

	MOVE.L	(A7)+,A2
	UNLK	A5
	RTS

_iw_setdam:
	MOVE.W	$0020(A2),D3
	MULU.W	#12,D3
	LEA	-$6FDA(A4),A6	;_w_magic
;	MOVEA.L	D3,A3
;	ADDA.L	A6,A3
	MOVE.L	$00(A6,D3.w),$0016(A2)	; wield damage
	MOVE.L	$04(A6,D3.w),$001A(A2)	; throw damage
	RTS

;/*
; * hit_monster:
; *  Does the missile hit the monster?
; */

_hit_monster:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5/A2,-(A7)

	MOVE.W	$0008(A5),D4
	MOVE.W	$000A(A5),D5

	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_moatquick

	TST.L	D0
	BEQ.B	L00618

	MOVEA.L	D0,A2
	MOVE.W	D4,-$53CC(A4)
	MOVE.W	D5,-$53CE(A4)
	MOVE.W	#$0001,-(A7)
	MOVE.L	$000C(A5),-(A7)
	MOVE.B	$000F(A2),D3
	EXT.W	D3
	MOVE.W	D3,-(A7)
	PEA	-$53CE(A4)
	JSR	_fight
	LEA	$000C(A7),A7
L00618:
	MOVEM.L	(A7)+,D4/D5/A2
	UNLK	A5
	RTS

;/*
; * num:
; *  Figure out the plus number for armor/weapons
; */

_num:
	LINK	A5,#-$0000

	MOVE.W	$0008(A5),-(A7)
	BGE.B	1$

	PEA	L00620(PC)	;"",0
	BRA.B	2$
1$
	PEA	L00621(PC)	;"+"
2$
	PEA	L0061F(PC)	;"%s%d"
	PEA	-$53CA(A4)
	JSR	_sprintf
	LEA	$000E(A7),A7

	CMP.b	#$6D,$000D(A5)	; m weapon type
	BNE.B	L0061E

	MOVE.W	$000A(A5),-(A7)
	BGE.B	3$

	PEA	L00620(PC)	;"",0
	BRA.B	4$

3$	PEA	L00621(PC)	;"+"

4$	PEA	L00622(PC)	;",%s%d"
	LEA	-$53CA(A4),A0
	JSR	_strlenquick

	LEA	-$53CA(A4),A6
	ADD.W	D0,A6
	MOVE.L	A6,-(A7)
	JSR	_sprintf
	LEA	$000E(A7),A7
L0061E:
	LEA	-$53CA(A4),A6
	MOVE.L	A6,D0

	UNLK	A5
	RTS

L0061F:	dc.b	"%s%d",0
L00620:	dc.b	$00
L00621:	dc.b	"+",0
L00622:	dc.b	",%s%d",0

;/*
; * wield:
; *  Pull out a certain weapon

_wield:
	LINK	A5,#-$0000
	MOVEM.L	A2/A3,-(A7)
	MOVEA.L	$0008(A5),A2
	MOVEA.L	-$5298(A4),A3		;_cur_weapon
	MOVE.L	A3,-(A7)		;_cur_weapon
	JSR	_can_drop(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.B	L00626
	MOVE.L	A3,-$5298(A4)	;_cur_weapon
	MOVE.W	#$0001,-(A7)
	MOVE.L	A3,-(A7)	;_cur_weapon
	JSR	_pack_name
	ADDQ.W	#6,A7
L00625:
	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

L00626:
	MOVE.W	#$0001,-(A7)
	MOVE.L	A3,-$5298(A4)	;_cur_weapon
	MOVE.L	A3,-(A7)
	JSR	_pack_name
	ADDQ.W	#6,A7
	MOVE.L	A2,D3
	BNE.B	L00628

	MOVE.W	#$006D,-(A7)	; weapon type
	PEA	L0062B(PC)	;"wield"
	JSR	_get_item
	ADDQ.W	#6,A7
	MOVEA.L	D0,A2
	TST.L	D0
	BNE.B	L00628
L00627:
	CLR.B	-$66F9(A4)	;_after
	BRA.B	L00625
L00628:
	MOVE.L	A2,-(A7)
	JSR	_typeof(PC)
	ADDQ.W	#4,A7
	CMP.W	#$0061,D0	; 'a' armor type
	BNE.B	L00629

	PEA	L0062C(PC)	;"you can't wield armor"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L00627
L00629:
	MOVE.L	A2,-(A7)
	JSR	_is_current(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.B	L00627

	MOVE.L	A2,-(A7)
	JSR	_check_wisdom
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.B	L00625

	MOVE.L	A2,-$5298(A4)	;_cur_weapon
	MOVE.W	#$0001,-(A7)
	MOVE.L	A3,-(A7)
	JSR	_pack_name
	ADDQ.W	#6,A7
	MOVE.L	A2,-(A7)
	JSR	_pack_char(PC)
	ADDQ.W	#4,A7
	MOVE.W	D0,-(A7)
	MOVE.W	#$005E,-(A7)	;"^"
	MOVE.L	A2,-(A7)
	JSR	_nameof
	ADDQ.W	#6,A7
	MOVE.L	D0,-(A7)
	PEA	L0062D(PC)	;"you are now wielding %s (%c)"
	JSR	_msg
	LEA	$000A(A7),A7
	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_pack_name
	ADDQ.W	#6,A7
	BRA.W	L00625

L0062B:	dc.b	"wield",0
L0062C:	dc.b	"you can't wield armor",0
L0062D:	dc.b	"you are now wielding %s (%c)",0,0

;/*
; * fallpos:
; *  Pick a random position around the given (y, x) coordinates
; */

_fallpos:
	LINK	A5,#-$0004
	MOVEM.L	D4-D7/A2,-(A7)

	MOVEA.L	$000C(A5),A2
	MOVEQ	#$00,D6
	MOVEA.L	$0008(A5),A6
	MOVE.W	$000E(A6),D4
	SUBQ.W	#1,D4
	BRA.W	L00637
L0062E:
	MOVEA.L	$0008(A5),A6
	MOVE.W	$000C(A6),D5
	SUBQ.W	#1,D5
	BRA.W	L00636
L0062F:
	CMP.W	-$52BE(A4),D4	;_player + 12
	BNE.B	L00630

	CMP.W	-$52C0(A4),D5	;_player + 10
	BEQ.W	L00635
L00630:
	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_offmap
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.W	L00635

	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	MOVE.W	D3,D7
	CMP.W	#$002E,D3	;'.'
	BEQ.B	L00631

	CMP.W	#$0023,D7	;'#'
	BNE.B	L00633
L00631:
	ADDQ.W	#1,D6
	MOVE.W	D6,D0
	JSR	_rnd
	TST.W	D0
	BNE.B	L00632

	MOVE.W	D4,$0002(A2)
	MOVE.W	D5,(A2)
L00632:
	BRA.B	L00635
L00633:
	MOVE.W	D7,-(A7)
	JSR	_step_ok
	ADDQ.W	#2,A7
	TST.W	D0
	BEQ.B	L00635

	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_find_obj
	ADDQ.W	#4,A7
	MOVE.L	D0,-$0004(A5)
;	TST.L	D0
	BEQ.B	L00635

	MOVEA.L	-$0004(A5),A6
	MOVEA.L	$0008(A5),A1
	MOVE.W	$000A(A6),D3
	CMP.W	$000A(A1),D3
	BNE.B	L00635

;	MOVEA.L	-$0004(A5),A6
	TST.W	$002C(A6)
	BEQ.B	L00635

;	MOVEA.L	-$0004(A5),A6
;	MOVEA.L	$0008(A5),A1
	MOVE.W	$002C(A6),D3
	CMP.W	$002C(A1),D3
	BNE.B	L00635

;	MOVEA.L	-$0004(A5),A6
;	MOVEA.L	$0008(A5),A1
	MOVE.W	$001E(A1),D3
	ADD.W	D3,$001E(A6)
	MOVEQ	#$02,D0
L00634:
	MOVEM.L	(A7)+,D4-D7/A2
	UNLK	A5
	RTS

L00635:
	ADDQ.W	#1,D5
L00636:
	MOVEA.L	$0008(A5),A6
	MOVE.W	$000C(A6),D3
	ADDQ.W	#1,D3
	CMP.W	D3,D5
	BLE.W	L0062F

	ADDQ.W	#1,D4
L00637:
	MOVEA.L	$0008(A5),A6
	MOVE.W	$000E(A6),D3
	ADDQ.W	#1,D3
	CMP.W	D3,D4
	BLE.W	L0062E

	TST.W	D6
	BEQ.B	L00638

	MOVEq	#$0001,D0
	BRA.B	L00639
L00638:
	CLR.W	D0
L00639:
	BRA.B	L00634

_typeof:
	MOVEA.L	$0004(A7),A6
	MOVE.W	$000A(A6),D0

_typech:
	CMP.b	#$6D,D0		; m
	BLT.B	1$

	CMP.b	#$79,D0		; y
	BGE.B	3$

	MOVEQ	#$6D,D0		; m weapon type
	rts

1$	CMP.b	#$61,D0		; a
	BLT.B	2$

	CMP.b	#$69,D0		; i
	BGE.B	3$

	MOVEQ	#$61,D0		; a armor type
	rts

2$	CMP.b	#$0E,D0		; #14
	BLT.B	3$

	CMP.b	#$14,D0		; #20
	BGE.B	3$

	MOVEQ	#$0E,D0		; #14

3$	ext.w	d0
	RTS

_foolish:
;	LINK	A5,#-$0000
	ANDI.W	#~C_WISDOM,-$52B4(A4)	;clear C_WISDOM,_player + 22 (flags)
	PEA	L0063D(PC)		;"You see your destiny, but the knowledge vaporizes"
	JSR	_msg
	ADDQ.W	#4,A7
;	UNLK	A5
	RTS

L0063D:	dc.b	"You see your destiny, but the knowledge vaporizes",0

_lose_vision:
;	LINK	A5,#-$0000
	ANDI.W	#~C_ISFOUND,-$52B4(A4)	;clear C_ISFOUND,_player + 22 (flags)
	PEA	-$52C0(A4)	;_player + 10
	JSR	_leave_room
	ADDQ.W	#4,A7
	PEA	-$52C0(A4)	;_player + 10
	JSR	_enter_room
	ADDQ.W	#4,A7
	CLR.L	-(A7)
	JSR	_look
	ADDQ.W	#4,A7
	PEA	L0063E(PC)	;"The light from your lamp seems dimmer now."
	JSR	_msg
	ADDQ.W	#4,A7
;	UNLK	A5
	RTS

L0063E:	dc.b	"The light from your lamp seems dimmer now.",0,0

;/*
; * doctor:
; *  A healing daemon that restores hit points after rest
; */

_doctor:
;	LINK	A5,#-$0000
	MOVEM.L	D4/D5,-(A7)

	MOVE.W	-$52AC(A4),D4	;_player + 30 (rank)
	MOVE.W	-$52A8(A4),D5	;_player + 34 (hp)
	ADDQ.W	#1,-$60A0(A4)	;_quiet
	CMP.W	#$0008,D4
	BGE.B	L00640

	MOVE.W	D4,D3
	ASL.W	#1,D3
	ADD.W	-$60A0(A4),D3	;_quiet
	CMP.W	#$0014,D3
	BLE.B	L0063F

	ADDQ.W	#1,-$52A8(A4)	;_player + 34 (hp)
L0063F:
	BRA.B	L00641

L00640:	CMPI.W	#$0003,-$60A0(A4)	;_quiet
	BLT.B	L00641

	MOVE.W	D4,D3
	SUBQ.W	#7,D3
	MOVE.W	D3,D0
	JSR	_rnd
	ADDQ.W	#1,D0
	ADD.W	D0,-$52A8(A4)	;_player + 34 (hp)

L00641:	MOVE.L	-$5190(A4),D3	;_cur_ring_1
	BEQ.B	L00642

	MOVEA.L	D3,A6
	CMPI.W	#R_REGEN,$0020(A6)	; 9 = ring of regeneration
	BNE.B	L00642

	ADDQ.W	#1,-$52A8(A4)	;_player + 34 (hp)

L00642:	MOVE.L	-$518C(A4),D3	;_cur_ring_2
	BEQ.B	L00643

	MOVEA.L	D3,A6
	CMPI.W	#R_REGEN,$0020(A6)	; 9 = ring of regeneration
	BNE.B	L00643

	ADDQ.W	#1,-$52A8(A4)	;_player + 34 (hp)

L00643:	CMP.W	-$52A8(A4),D5	;_player + 34 (hp)
	BEQ.B	L00645

	MOVE.W	-$52A8(A4),D3	;_player + 34 (hp)
	CMP.W	-$52A2(A4),D3	;_player + 40 (max hp)
	BLE.B	L00644

	MOVE.W	-$52A2(A4),-$52A8(A4)	;_player + 40 (max hp),_player + 34 (hp)
L00644:
	CLR.W	-$60A0(A4)	;_quiet
L00645:
	MOVEM.L	(A7)+,D4/D5
;	UNLK	A5
	RTS

;/*
; * Swander:
; *  Called when it is time to start rolling for wandering monsters
; */

_swander:
;	LINK	A5,#-$0000
	CLR.W	-(A7)
	PEA	_rollwand(PC)
	JSR	_daemon(PC)
	ADDQ.W	#6,A7
;	UNLK	A5
	RTS

;/*
; * rollwand:
; *  Called to roll to see if a wandering monster starts up
; */

_rollwand:
;	LINK	A5,#-$0000
	ADDQ.W	#1,-$6F62(A4)	;_between
	MOVEq	#$0003,D0
	JSR	_rnd
	ADDQ.W	#3,D0
	MOVE.W	-$6F62(A4),D3	;_between
	CMP.W	D0,D3
	BLT.B	L00647

	MOVE.W	#$0006,-(A7)	;1d6
	MOVE.W	#$0001,-(A7)
	JSR	_roll
	ADDQ.W	#4,A7
	CMP.W	#$0004,D0
	BNE.B	L00646

	JSR	_wanderer(PC)
	PEA	_rollwand(PC)
	JSR	_extinguish(PC)
	ADDQ.W	#4,A7

	MOVEq	#100,D0
	JSR	_spread

	MOVE.W	D0,-(A7)
	CLR.W	-(A7)
	PEA	_swander(PC)
	JSR	_fuse(PC)
	ADDQ.W	#8,A7
L00646:
	CLR.W	-$6F62(A4)	;_between
L00647:
;	UNLK	A5
	RTS

;/*
; * unconfuse:
; *  Release the poor player from his confusion
; */

_unconfuse:
;	LINK	A5,#-$0000
	ANDI.W	#~C_ISHUH,-$52B4(A4)	;clear ISHUH,_player + 22 (flags)
	PEA	L00648(PC)	;"you feel less confused now"
	JSR	_msg
	ADDQ.W	#4,A7
;	UNLK	A5
	RTS

L00648:	dc.b	"you feel less confused now",0,0

;/*
; * unsee:
; *  Turn off the ability to see invisible
; */

_unsee:
;	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)
	MOVEA.L	-$6CAC(A4),A2	;_mlist
	BRA.B	3$

1$	MOVE.W	$0016(A2),D3
	AND.W	#C_ISINVIS,D3	;C_ISINVIS
	BEQ.B	2$

	MOVE.L	A2,-(A7)
	JSR	_see_monst
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	2$

;	MOVEQ	#$00,D3
;	MOVE.B	$0011(A2),D3
;	CMP.W	#$0022,D3	;'"'
	cmp.b	#$22,$0011(A2)
	BEQ.B	2$

	MOVE.B	$0011(A2),D2
	MOVE.W	$000A(A2),d1
	MOVE.W	$000C(A2),d0
	JSR	_mvaddchquick

2$	MOVEA.L	(A2),A2

3$	MOVE.L	A2,D3
	BNE.B	1$

	ANDI.W	#~C_CANSEE,-$52B4(A4)	;clear CANSEE, _player + 22 (flags)

	MOVEA.L	(A7)+,A2
;	UNLK	A5
	RTS

;/*
; * sight:
; *  He gets his sight back
; */

_sight:
;	LINK	A5,#-$0000
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BEQ.B	L0064D

	PEA	_sight(PC)
	JSR	_extinguish(PC)
	ADDQ.W	#4,A7
	ANDI.W	#~C_ISBLIND,-$52B4(A4)	;clear C_ISBLIND, _player + 22 (flags)
	MOVEA.L	-$52A0(A4),A6	;_player + 42 (proom)
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3
	BNE.B	L0064C

	PEA	-$52C0(A4)	;_player + 10
	JSR	_enter_room
	ADDQ.W	#4,A7
L0064C:
	PEA	L0064E(PC)	;"the veil of darkness lifts"
	JSR	_msg
	ADDQ.W	#4,A7
L0064D:
;	UNLK	A5
	RTS

L0064E:	dc.b	"the veil of darkness lifts",0,0

;/*
; * nohaste:
; *  End the hasting
; */

_nohaste:
;	LINK	A5,#-$0000
	ANDI.W	#~C_ISHASTE,-$52B4(A4)	;clear C_ISHASTE,_player + 22 (flags)
	PEA	L0064F(PC)
	JSR	_msg
	ADDQ.W	#4,A7
;	UNLK	A5
	RTS

L0064F:	dc.b	"you feel yourself slowing down",0,0

;/*
; * stomach:
; *  Digest the hero's food
; */

_stomach:
;	LINK	A5,#-$0000
	MOVEM.L	D4/D5,-(A7)
	MOVE.W	-$609E(A4),D3	;_food_left
	BGT.B	L00653

	SUBQ.W	#1,-$609E(A4)	;_food_left
	CMP.W	#$FCAE,D3	;-352
	BGE.B	L00650

	MOVE.W	#$0073,-(A7)	;'s' starvation
	JSR	_death
	ADDQ.W	#2,A7
L00650:
	TST.W	-$60AC(A4)	;_no_command
	BNE	L00656

	MOVEq	#$0005,D0	;20% chance
	JSR	_rnd
	TST.W	D0
	BNE	L00656

	MOVEq	#$0008,D0
	JSR	_rnd
	ADDQ.W	#4,D0
	ADD.W	D0,-$60AC(A4)	;_no_command
	ANDI.W	#~C_ISRUN,-$52B4(A4)	;clear C_ISRUN, _player + 22 (flags)
	CLR.B	-$66B6(A4)	;_running
	CLR.W	-$60A4(A4)	;_count
	MOVE.W	#$0003,-$609A(A4)	;_hungry_state

	LEA	L00658(PC),a0	;"you feel very weak. "
	JSR	_noterse

	MOVE.L	D0,-(A7)
	PEA	L00657(PC)	;"%syou faint from lack of food"
	JSR	_msg
	ADDQ.W	#8,A7
	JSR	_NewRank(PC)
	BRA.B	L00656
L00653:
	MOVE.W	D3,D4	;_food_left

	CLR.W	-(A7)
	JSR	_ring_eat(PC)
	ADDQ.W	#2,A7

	MOVE.W	D0,-(A7)

	MOVE.W	#$0001,-(A7)
	JSR	_ring_eat(PC)
	ADDQ.W	#2,A7

	MOVE.W	(A7)+,D3
	ADD.W	D0,D3
	MOVE.W	D3,D5
	ADDQ.W	#1,D5
	TST.B	-$66B2(A4)	;_terse
	BEQ.B	L00654

	MULU.W	#$0002,D5
L00654:
	SUB.W	D5,-$609E(A4)	;_food_left
	CMPI.W	#150,-$609E(A4)	;_food_left
	BGE.B	L00655

	CMP.W	#150,D4
	BLT.B	L00655

	MOVE.W	#$0002,-$609A(A4)	;_hungry_state
	JSR	_NewRank(PC)
	PEA	L00659(PC)	;"you are starting to feel weak"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L00656
L00655:
	CMPI.W	#300,-$609E(A4)	;_food_left
	BGE.B	L00656

	CMP.W	#300,D4
	BLT.B	L00656

	MOVE.W	#$0001,-$609A(A4)	;_hungry_state
	JSR	_NewRank(PC)
	PEA	L0065A(PC)	;"you are starting to get hungry"
	JSR	_msg
	ADDQ.W	#4,A7
L00656:
	MOVEM.L	(A7)+,D4/D5
;	UNLK	A5
	RTS

L00652:

L00657:	dc.b	"%syou faint from lack of food",0
L00658:	dc.b	"you feel very weak. ",0
L00659:	dc.b	"you are starting to feel weak",0
L0065A:	dc.b	"you are starting to get hungry",0

_main:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)
	JSR	_init_ds
	JSR	_initscr(PC)
	JSR	_setup(PC)	;bugfix, now process can return from -s option
	CLR.W	-$60B6(A4)	;_dnum
L0065B:
	SUBQ.W	#1,$0008(A5)
	TST.W	$0008(A5)
	BEQ.B	L00660

	ADDQ.L	#4,$000A(A5)
	MOVEA.L	$000A(A5),A6
	MOVEA.L	(A6),A2
	MOVE.B	(A2),D3
;	EXT.W	D3
	CMP.b	#$2D,D3		;'-'
	BEQ.B	L0065C

;	MOVE.B	(A2),D3
;	EXT.W	D3
	CMP.b	#$2F,D3		;'/'
	BNE.B	L0065B
L0065C:
	MOVE.B	$0001(A2),D0
	EXT.W	D0
;	EXT.L	D0
	BRA.B	L0065E
L0065D:
	ST	-$66F8(A4)	;_noscore

	CLR.W	-(A7)
	CLR.W	-(A7)
	CLR.W	-(A7)
	JSR	_score(PC)	;used with option "-s" to display highscore direct
	ADDQ.W	#6,A7

	PEA	L00662(PC)	;"",0
	JSR	_fatal(PC)
	ADDQ.W	#4,A7
	BRA.B	L0065F
L0065E:
	SUB.w	#$0053,D0	;'S'
	BEQ.B	L0065D
	SUB.w	#$0020,D0	;'s'
	BEQ.B	L0065D
L0065F:
	BRA.B	L0065B
L00660:
	TST.W	-$60B6(A4)	;_dnum
	BNE.B	L00661
	JSR	_srand(PC)
	MOVE.W	D0,-$60B6(A4)	;_dnum
L00661:
	MOVE.W	-$60B6(A4),D3	;_dnum
	EXT.L	D3
	MOVE.L	D3,-$6094(A4)	;_seed
	JSR	_credits
	JSR	_init_player
	JSR	_init_things
	JSR	_init_names
	JSR	_init_colors
	JSR	_init_stones
	JSR	_init_materials
	JSR	_new_level

	CLR.W	-(A7)
	PEA	_doctor(PC)
	JSR	_daemon(PC)
	ADDQ.W	#6,A7

	MOVEq	#100,D0
	JSR	_spread

	MOVE.W	D0,-(A7)
	CLR.W	-(A7)
	PEA	_swander(PC)
	JSR	_fuse(PC)
	ADDQ.W	#8,A7

	CLR.W	-(A7)
	PEA	_stomach(PC)
	JSR	_daemon(PC)
	ADDQ.W	#6,A7

	CLR.W	-(A7)
	PEA	_runners(PC)
	JSR	_daemon(PC)
	ADDQ.W	#6,A7

	LEA	L00664(PC),a0	; Welcome...
	JSR	_noterse

	MOVE.L	D0,-(A7)
	PEA	-$672B(A4)	;_whoami
	PEA	L00663(PC)	; Hello...
	JSR	_msg
	LEA	$000C(A7),A7
	JSR	_ready_to_go(PC)
	CLR.W	-(A7)
	JSR	_playit(PC)
	ADDQ.W	#2,A7
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L00662:	dc.b	$00
L00663:	dc.b	"Hello %s%s.",0
L00664:	dc.b	".  Welcome to the Dungeons of Doom",0

;/*
; * endit:
; *  Exit the program abnormally.
; */

_endit:
	LINK	A5,#-$0000
	PEA	L00665(PC)	;"Ok, if you want to exit that badly, I'll have to allow it"
	JSR	_fatal(PC)
	ADDQ.W	#4,A7
	UNLK	A5
	RTS

L00665:
	dc.b	"Ok, if you want to exit that badly, I'll"
	dc.b	" have to allow it",0

_ran:
	MOVE.L	-$6094(A4),D0	;_seed
	MOVEQ	#$7D,D1
	JSR	_mulu
	MOVE.L	D0,-$6094(A4)	;_seed
;	MOVE.L	-$6094(A4),D0	;_seed
	MOVE.L	#$002AAAAB,D1
	JSR	_divu
	MOVE.L	#$002AAAAB,D1
	JSR	_mulu
	SUB.L	D0,-$6094(A4)	;_seed
	MOVE.L	-$6094(A4),D0	;_seed
	RTS

;/*
; * rnd:
; *  Pick a very random number.
; */

; converted to register paramter
; WORD in D0
; RETURN in D0

_rnd:
	MOVE.L	D4,-(A7)

	MOVE.W	D0,D4
	BEQ.B	2$

	BSR.B	_ran
	MOVE.L	D0,D3
	BSR.B	_ran		;this does not change D3
	ADD.L	D3,D0
	bclr	#31,D0
	MOVE.W	D4,D1
	EXT.L	D1
	JSR	_mods

2$	MOVE.L	(A7)+,D4
	RTS

;/*
; * roll:
; *  Roll a number of dice
; */

_roll:
	LINK	A5,#-$0000
	MOVEM.L	D4-D6,-(A7)

	MOVE.W	$0008(A5),D4	; number of dices
	MOVE.W	$000A(A5),D5	; number of sides/faces
	MOVE.w	D4,D6
	bra	2$

1$	MOVE.W	D5,D0
	BSR.B	_rnd
	ADD.W	D0,D6
2$	dbra	d4,1$

	MOVE.W	D6,D0

	MOVEM.L	(A7)+,D4-D6
	UNLK	A5
	RTS

;/*
; * playit:
; *  The main loop of the program.  Loop until the game is over,
; *  refreshing things and looking at the proper times.
; */

_playit:
;	LINK	A5,#-$0000
	MOVE.W	-$52C0(A4),-$6090(A4)	;_player + 10
	MOVE.W	-$52BE(A4),-$608E(A4)	;_player + 12
	PEA	-$52C0(A4)	;_player + 10
	JSR	_roomin
	ADDQ.W	#4,A7
	MOVE.L	D0,-$48C0(A4)	;_oldrp
L0066A:
	TST.B	-$66B7(A4)	;_playing
	BEQ.B	L0066B
	JSR	_command(PC)
	BRA.B	L0066A
L0066B:
	JSR	_endit(PC)
;	UNLK	A5
	RTS

;/*
; * quit:
; *  Have player make certain, then exit.
; */

_quit:
;	LINK	A5,#-$0000
	PEA	L0066F(PC)	;"No"
	PEA	L0066E(PC)	;"Yes"
	PEA	L0066D(PC)	;"Do you really want to quit?"
	JSR	_ask_him
	LEA	$000C(A7),A7
	TST.W	D0
	BEQ.B	1$

	CLR.W	-(A7)			;killed by
	MOVE.W	#$0001,-(A7)
	MOVE.W	-$60B2(A4),-(A7)	;_purse
	JSR	_score(PC)
	ADDQ.W	#6,A7
	MOVE.W	-$60B2(A4),-(A7)	;_purse
	PEA	L00670(PC)	;"You quit with %d gold pieces"
	JSR	_fatal(PC)
	ADDQ.W	#6,A7
1$
;	UNLK	A5
	RTS

L0066D:	dc.b	"Do you really want to quit?",0
L0066E:	dc.b	"Yes",0
L0066F:	dc.b	"No",0
L00670:	dc.b	"You quit with %d gold pieces",0

;/*
; * leave:
; *  Leave quickly, but curteously
; */

;_leave:
;	LINK	A5,#-$0000
;	CLR.L	-(A7)
;	JSR	_look
;	ADDQ.W	#4,A7
;	CLR.W	-(A7)
;	MOVE.W	#$0014,-(A7)
;	JSR	x_move
;	ADDQ.W	#4,A7
;	JSR	_clrtoeol
;	CLR.W	-(A7)
;	MOVE.W	#$0013,-(A7)
;	JSR	x_move
;	ADDQ.W	#4,A7
;	JSR	_clrtoeol
;	CLR.W	-(A7)
;	MOVE.W	#$0013,-(A7)
;	JSR	x_move
;	ADDQ.W	#4,A7
;	PEA	L00671(PC)	;"Ok, if you want to leave that badly"
;	BSR.B	_fatal
;	ADDQ.W	#4,A7
;	UNLK	A5
;	RTS

;L00671:	dc.b	"Ok, if you want to leave that badly",0

_fatal:
	LINK	A5,#-$0000
	JSR	_endwin(PC)
	MOVE.L	$000C(A5),-(A7)
	MOVE.L	$0008(A5),-(A7)
	JSR	_printf
	ADDQ.W	#8,A7
	PEA	L00672(PC)	;'To play again, just type "Rogue"'
	JSR	_printf
	ADDQ.W	#4,A7
	CLR.W	-(A7)
	JSR	_exit
	ADDQ.W	#2,A7
	UNLK	A5
	RTS

L00672:	dc.b	10,'To play again, just type "Rogue"',10,0,0

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

	MOVE.W	D0,-$53C0(A4)	;rogue.score filehd
;	CMP.W	#$0000,D0
	BGE.B	L00677

	TST.B	-$66F8(A4)	;_noscore
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

	move.b	#-1,-$46d8(A4)	;normal is negativ, score color flag

	tst.b	-$66F8(A4)	;_noscore
	bne	L00679

	;hiding strength, maxhp and experience points in the highscore
	move.l	-$52B0(A4),-$000E(A5)	;_player + 26 (EXP)
	move.b	-$52B1(A4),-$000A(A5)	;_player + 24 strength
	move.b	-$52A1(A4),-$0009(A5)	;_player + 40 (max HP)

	PEA	-$672B(A4)	;_whoami
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
	MOVE.W	-$60BA(A4),-$0002(A5)	;_ntraps (deepest level)
	MOVE.W	-$52AC(A4),-$0008(A5)	;_player + 30 (rank)
	PEA	-$01FA(A5)	;506 (460 + 46)
	PEA	-$002E(A5)
	JSR	_add_scores(PC)
	ADDQ.W	#8,A7
	MOVE.W	D0,D5
L00679:
	MOVE.W	-$53C0(A4),-(A7)
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

	MOVE.W	D0,-$53C0(A4)	;rogue.score filehd
;	CMP.W	#$0000,D0
	BLT.B	L0067A

	PEA	-$01FA(A5)	;506 (460 + 46)
	JSR	_put_scores(PC)
	ADDQ.W	#4,A7

	MOVE.W	-$53C0(A4),-(A7)	;rogue.score filehd
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
	MOVE.W	-$53C0(A4),-(A7)	;rogue.score filehd
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
	MOVE.W	-$53C0(A4),-(A7)	;rogue.score filehd
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
	MOVE.L	-$5144(A4),-(A7)	;_TextWin
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

	move.b	#1,-$77CE(A4)	;set the default color in IntuiText

	cmp.b	-$46d8(A4),d4	;_all_clear + 1
	bne	1$
	move.b	#3,-$77CE(A4)	;changes the color in IntuiText

1$	MOVEA.L	$000A(A5),A6
	MOVE.W	$0026(A6),D3
	SUBQ.W	#1,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$6D28(A4),A6	;_he_man
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
	BGE.B	L0068A

	PEA	-$0050(A5)
	JSR	_addstr
	ADDQ.W	#4,A7
L0068A:
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
	move.b	d0,-$46d8(A4)	;_all_clear + 1
	subq.b	#1,-$46d8(A4)

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

	MOVE.W	-$60B2(A4),D3	;_purse
	EXT.L	D3
	DIVS.W	#10,D3
	SUB.W	D3,-$60B2(A4)	;_purse

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
	MOVE.L	-$5144(A4),-(A7)	;_TextWin
	PEA	L006A5(PC)	;"Tombstone"
	JSR	_show_ilbm
	LEA	$000A(A7),A7
	LEA	-$672B(A4),A6	;_whoami
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
	MOVE.W	-$60B2(A4),-(A7)	;_purse
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
	MOVE.W	-$60B2(A4),-(A7)	;_purse
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

	MOVEA.L	-$5144(A4),A6	;_TextWin
	lea	-$0014(A5),a1
	MOVE.L	$0032(A6),a0

	MOVEA.L	-$5188(A4),A6	;_IntuitionBase
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

	MOVE.W	-$60B2(A4),D6	;_purse
	MOVEQ	#$61,D5
	MOVEA.L	-$529C(A4),A2	;_player + 46 (pack)
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
	LEA	-$6F00(A4),A6	;_a_class
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
	LEA	-$6EEA(A4),A6	;_s_magic + 6
	MOVE.W	$00(A6,D3.w),D4
	MULU.W	$001E(A2),D4	;multiply by the amount we have
	MOVE.W	$0020(A2),D3
	LEA	-$66F6(A4),A6	;_s_know
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
	LEA	-$6E72(A4),A6	;_p_magic + 6
	MOVE.W	$00(A6,D3.w),D4
	MULU.W	$001E(A2),D4	;multiply by the amount we have
	MOVE.W	$0020(A2),D3
	LEA	-$66E7(A4),A6	;_p_know
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
	LEA	-$6E02(A4),A6	;_r_magic + 6
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
	LEA	-$66D9(A4),A6	;_r_know
	ST	$00(A6,D3.W)
	BRA.W	L006D7

; worth of wand/staff

L006D3:
	MOVE.W	$0020(A2),D3
;	EXT.L	D3
	ASL.w	#3,D3
	LEA	-$6D92(A4),A6
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
	LEA	-$66CB(A4),A6	;_ws_know
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
	ADD.W	D4,-$60B2(A4)	;_purse
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
	MOVE.W	-$60B2(A4),-(A7)	;_purse
	JSR	_score(PC)
	ADDQ.W	#4,A7

	JSR	_black_out
	JSR	_wtext

	CLR.L	-(A7)
	MOVE.L	-$5144(A4),-(A7)	;_TextWin
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
	MOVEA.L	-$5258(A4),A2	;_prbuf
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
	LEA	-$6CA8(A4),A6	;_monsters
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
	MOVE.L	-$5258(A4),-(A7)	;_prbuf
	JSR	_sprintf
	LEA	$000C(A7),A7
	BRA.B	L006F0
L006EF:
	MOVEA.L	-$5258(A4),A6	;_prbuf
	CLR.B	(A6)
L006F0:
	MOVE.L	A2,-(A7)
	MOVE.L	-$5258(A4),-(A7)	;_prbuf
	JSR	_strcat
	ADDQ.W	#8,A7
	MOVE.L	-$5258(A4),D0	;_prbuf

	MOVEM.L	(A7)+,D4/D5/A2
	UNLK	A5
	RTS

L006F1:	dc.b	"arrow",0
L006F2:	dc.b	"bolt",0
L006F3:	dc.b	"dart",0
L006F4:	dc.b	"starvation",0
L006F5:	dc.b	"fall",0
L006F6:	dc.b	"God",0

L006F7:	dc.b	"a%s ",0

; weapons
L006F8:	dc.b	"mace",0		; 0
L006F9:	dc.b	"broad sword",0		; 1
L006FA:	dc.b	"short bow",0		; 2
L006FB:	dc.b	"arrow",0		; 3
L006FC:	dc.b	"dagger",0		; 4
L006FD:	dc.b	"two handed sword",0	; 5
L006FE:	dc.b	"dart",0		; 6
L006FF:	dc.b	"crossbow",0		; 7
L00700:	dc.b	"crossbow bolt",0	; 8
L00701:	dc.b	"flail",0		; 9

; armor
L00702:	dc.b	"leather armor",0		; 0
L00703:	dc.b	"ring mail",0			; 1
L00704:	dc.b	"studded leather armor",0	; 2
L00705:	dc.b	"scale mail",0			; 3
L00706:	dc.b	"chain mail",0			; 4
L00707:	dc.b	"splint mail",0			; 5
L00708:	dc.b	"banded mail",0			; 6
L00709:	dc.b	"plate mail",0			; 7

; scrolls
L0070A:	dc.b	"monster confusion",0	; 0
L0070B:	dc.b	"magic mapping",0	; 1
L0070C:	dc.b	"hold monster",0	; 2
L0070D:	dc.b	"sleep",0		; 3
L0070E:	dc.b	"enchant armor",0	; 4
L0070F:	dc.b	"identify",0		; 5
L00710:	dc.b	"scare monster",0	; 6
L00711:	dc.b	"wild magic",0		; 7
L00712:	dc.b	"teleportation",0	; 8
L00713:	dc.b	"enchant weapon",0	; 9
L00714:	dc.b	"create monster",0	; 10
L00715:	dc.b	"remove curse",0	; 11
L00716:	dc.b	"aggravate monsters",0	; 12
L00717:	dc.b	"blank paper",0		; 13
L00718:	dc.b	"vorpalize weapon",0	; 14

; potions
L00719:	dc.b	"confusion",0		; 0
L0071A:	dc.b	"paralysis",0		; 1
L0071B:	dc.b	"poison",0		; 2
L0071C:	dc.b	"gain strength",0	; 3
L0071D:	dc.b	"see invisible",0	; 4
L0071E:	dc.b	"healing",0		; 5
L0071F:	dc.b	"night vision",0	; 6
L00720:	dc.b	"discernment",0		; 7
L00721:	dc.b	"raise level",0		; 8
L00722:	dc.b	"extra healing",0	; 9
L00723:	dc.b	"haste self",0		; 10
L00724:	dc.b	"restore strength",0	; 11
L00725:	dc.b	"blindness",0		; 12
L00726:	dc.b	"thirst quenching",0	; 13

; rings
L00727:	dc.b	"protection",0		; 0
L00728:	dc.b	"add strength",0	; 1
L00729:	dc.b	"sustain strength",0	; 2
L0072A:	dc.b	"searching",0		; 3
L0072B:	dc.b	"see invisible",0	; 4
L0072C:	dc.b	"adornment",0		; 5
L0072D:	dc.b	"aggravate monster",0	; 6
L0072E:	dc.b	"dexterity",0		; 7
L0072F:	dc.b	"increase damage",0	; 8
L00730:	dc.b	"regeneration",0	; 9
L00731:	dc.b	"slow digestion",0	; 10
L00732:	dc.b	"teleportation",0	; 11
L00733:	dc.b	"stealth",0		; 12
L00734:	dc.b	"maintain armor",0	; 13

; wand/staff
L00735:	dc.b	"light",0		; 0
L00736:	dc.b	"striking",0		; 1
L00737:	dc.b	"lightning",0		; 2
L00738:	dc.b	"fire",0		; 3
L00739:	dc.b	"cold",0		; 4
L0073A:	dc.b	"polymorph",0		; 5
L0073B:	dc.b	"magic missile",0	; 6
L0073C:	dc.b	"haste monster",0	; 7
L0073D:	dc.b	"slow monster",0	; 8
L0073E:	dc.b	"drain life",0		; 9
L0073F:	dc.b	"nothing",0		; 10
L00740:	dc.b	"teleport away",0	; 11
L00741:	dc.b	"teleport to",0		; 12
L00742:	dc.b	"cancellation",0	; 13

; ranks
L00743:	dc.b	$00
L00744:	dc.b	"Guild Novice",0
L00745:	dc.b	"Apprentice",0
L00746:	dc.b	"Journeyman",0
L00747:	dc.b	"Adventurer",0
L00748:	dc.b	"Fighter",0
L00749:	dc.b	"Warrior",0
L0074A:	dc.b	"Rogue",0
L0074B:	dc.b	"Champion",0
L0074C:	dc.b	"Master Rogue",0
L0074D:	dc.b	"Warlord",0
L0074E:	dc.b	"Hero",0
L0074F:	dc.b	"Guild Master",0
L00750:	dc.b	"Dragonlord",0
L00751:	dc.b	"Wizard",0
L00752:	dc.b	"Rogue Geek",0
L00753:	dc.b	"Rogue Addict",0
L00754:	dc.b	"Schmendrick",0
L00755:	dc.b	"Gunfighter",0
L00756:	dc.b	"Time Waster",0
L00757:	dc.b	"Bug Chaser",0
L00758:	dc.b	"Penultimate Rogue",0
L00759:	dc.b	"Ultimate Rogue",0
L0075A:	dc.b	"Software Pirate",0
L0075B:	dc.b	"Copy Protection Mafia",0

L0075C:	dc.b	"1d4",0

L0075D:	dc.b	"aquator",0
L0075E:	dc.b	"0d0/0d0",0

L0075F:	dc.b	"bat",0
L00760:	dc.b	"1d2",0

L00761:	dc.b	"centaur",0
L00762:	dc.b	"1d6/1d6",0

L00763:	dc.b	"dragon",0
L00764:	dc.b	"1d8/1d8/3d10",0

L00765:	dc.b	"emu",0
L00766:	dc.b	"1d2",0

L00767:	dc.b	"venus flytrap",0
L00768:	dc.b	"%%%d0",0

L00769:	dc.b	"griffin",0
L0076A:	dc.b	"4d3/3d5/4d3",0

L0076B:	dc.b	"hobgoblin",0
L0076C:	dc.b	"1d8",0

L0076D:	dc.b	"ice monster",0
L0076E:	dc.b	"1d2",0

L0076F:	dc.b	"jabberwock",0
L00770:	dc.b	"2d12/2d4",0

L00771:	dc.b	"kestral",0
L00772:	dc.b	"1d4",0

L00773:	dc.b	"leprechaun",0
L00774:	dc.b	"1d2",0

L00775:	dc.b	"medusa",0
L00776:	dc.b	"3d4/3d4/2d5",0

L00777:	dc.b	"nymph",0
L00778:	dc.b	"1d0",0

L00779:	dc.b	"orc",0
L0077A:	dc.b	"1d8",0

L0077B:	dc.b	"phantom",0
L0077C:	dc.b	"4d4",0

L0077D:	dc.b	"quagga",0
L0077E:	dc.b	"1d2/1d2/1d4",0

L0077F:	dc.b	"rattlesnake",0
L00780:	dc.b	"1d6",0

L00781:	dc.b	"slime",0
L00782:	dc.b	"1d3",0

L00783:	dc.b	"troll",0
L00784:	dc.b	"1d8/1d8/2d6",0

L00785:	dc.b	"ur-vile",0
L00786:	dc.b	"1d3/1d3/1d3/4d6",0

L00787:	dc.b	"vampire",0
L00788:	dc.b	"1d10",0

L00789:	dc.b	"wraith",0
L0078A:	dc.b	"1d6",0

L0078B:	dc.b	"xeroc",0
L0078C:	dc.b	"3d4",0

L0078D:	dc.b	"yeti",0
L0078E:	dc.b	"1d6/1d6",0

L0078F:	dc.b	"zombie",0
L00790:	dc.b	"1d8",0

L00791:	dc.b	" of intense white light",0
L00792:	dc.b	"your %s gives off a flash%s",0
L00793:	dc.b	"it",0
L00794:	dc.b	"you",0
L00795:	dc.b	"Not enough Memory",0
L00796:	dc.b	"  *** Stack Overflow ***",$d,10,"$",0
L00797:	dc.b	"0d0",0
L00798:	dc.b	"1d4",0

_draw_maze:
	LINK	A5,#-$019C
	MOVEM.L	D4/D5,-(A7)
	LEA	-$00C8(A5),A6
	MOVE.L	A6,-$53B0(A4)
	LEA	-$0190(A5),A6
	MOVE.L	A6,-$53AC(A4)
	CLR.W	-$53B2(A4)
	CLR.W	-$53B4(A4)
	MOVEA.L	$0008(A5),A6
	MOVE.W	$0002(A6),-$53B8(A4)
;	TST.W	-$53B8(A4)
	BNE.B	L00799

	MOVEA.L	$0008(A5),A6
	ADDQ.W	#1,$0002(A6)
	MOVE.W	$0002(A6),-$53B8(A4)
L00799:
	MOVEA.L	$0008(A5),A6
	MOVE.W	(A6),D5
	MOVE.W	-$53B8(A4),D4
	MOVE.W	D5,-$53B6(A4)
	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_splat(PC)
	ADDQ.W	#4,A7
	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_new_frontier(PC)
	ADDQ.W	#4,A7
L0079A:
	TST.W	-$53BE(A4)
	BEQ.B	L0079B

	JSR	_con_frnt(PC)
	MOVE.W	-$53BA(A4),-(A7)
	MOVE.W	-$53BC(A4),-(A7)
	JSR	_new_frontier(PC)
	ADDQ.W	#4,A7
	BRA.B	L0079A
L0079B:
	MOVEA.L	$0008(A5),A6
	MOVE.W	-$53B4(A4),D3
	SUB.W	(A6),D3
	ADDQ.W	#1,D3
	MOVE.W	D3,$0004(A6)
	MOVE.W	-$53B2(A4),D3
	SUB.W	$0002(A6),D3
	ADDQ.W	#1,D3
	MOVE.W	D3,$0006(A6)
L0079C:
	PEA	-$0196(A5)
	MOVE.L	$0008(A5),-(A7)
	JSR	_rnd_pos
	ADDQ.W	#8,A7
	CLR.W	-$0192(A5)
	LEA	-$69A6(A4),A6
	MOVE.L	A6,-$019A(A5)
	MOVE.W	#$0001,-$019C(A5)
	BRA.B	L0079F
L0079D:
	MOVEA.L	-$019A(A5),A6
	MOVE.W	$0002(A6),D4
	ADD.W	-$0194(A5),D4
	MOVE.W	(A6),D5
	ADD.W	-$0196(A5),D5
	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_offmap
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.B	L0079E

	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	CMP.B	#$23,$00(A6,D0.W)
	BNE.B	L0079E

	MOVE.W	-$019C(A5),D3
	ADD.W	D3,-$0192(A5)
L0079E:
	ASL.W	-$019C(A5)
	ADDQ.L	#4,-$019A(A5)
L0079F:
	LEA	-$6996(A4),A6
	MOVEA.L	-$019A(A5),A1
	CMPA.L	A6,A1
	BCS.B	L0079D

	MOVE.W	-$0196(A5),d0
	MOVE.W	-$0194(A5),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	CMP.B	#$23,$00(A6,D0.W)
	BEQ.W	L0079C

	MOVE.W	-$0192(A5),D3
	EXT.L	D3
	DIVS.W	#$0005,D3
	SWAP	D3
	TST.W	D3
	BNE.W	L0079C

	MOVE.W	-$0196(A5),-(A7)
	MOVE.W	-$0194(A5),-(A7)
	JSR	_splat(PC)
	ADDQ.W	#4,A7
	MOVEM.L	(A7)+,D4/D5
	UNLK	A5
	RTS

_new_frontier:
	LINK	A5,#-$0000

	MOVE.W	$000A(A5),-(A7)
	MOVE.W	$0008(A5),D3
	SUBQ.W	#2,D3
	MOVE.W	D3,-(A7)
	BSR.B	_add_frnt
	ADDQ.W	#4,A7

	MOVE.W	$000A(A5),-(A7)
	MOVE.W	$0008(A5),D3
	ADDQ.W	#2,D3
	MOVE.W	D3,-(A7)
	BSR.B	_add_frnt
	ADDQ.W	#4,A7

	MOVE.W	$000A(A5),D3
	SUBQ.W	#2,D3
	MOVE.W	D3,-(A7)
	MOVE.W	$0008(A5),-(A7)
	BSR.B	_add_frnt
	ADDQ.W	#4,A7

	MOVE.W	$000A(A5),D3
	ADDQ.W	#2,D3
	MOVE.W	D3,-(A7)
	MOVE.W	$0008(A5),-(A7)
	BSR.B	_add_frnt
	ADDQ.W	#4,A7

	UNLK	A5
	RTS

_add_frnt:
	LINK	A5,#-$0000
	MOVE.W	$000A(A5),-(A7)
	MOVE.W	$0008(A5),-(A7)
	JSR	_inrange(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L007A0

	MOVE.W	$000A(A5),d0
	MOVE.W	$0008(A5),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	CMP.B	#$20,$00(A6,D0.W)
	BNE.B	L007A0

;	MOVE.W	$000A(A5),d0
;	MOVE.W	$0008(A5),d1
;	JSR	_INDEXquick

;	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	#$46,$00(A6,D0.W)
	MOVE.W	-$53BE(A4),D3
	EXT.L	D3
	ASL.L	#1,D3
	MOVEA.L	-$53B0(A4),A6
	MOVE.W	$0008(A5),$00(A6,D3.L)
	MOVE.W	-$53BE(A4),D3
	ADDQ.W	#1,-$53BE(A4)
	EXT.L	D3
	ASL.L	#1,D3
	MOVEA.L	-$53AC(A4),A6
	MOVE.W	$000A(A5),$00(A6,D3.L)
L007A0:
	UNLK	A5
	RTS

_con_frnt:
	LINK	A5,#-$000E
	MOVEM.L	D4-D7,-(A7)

	MOVEQ	#$00,D6
	MOVEQ	#$00,D7
	CLR.W	-$000A(A5)
	MOVE.W	-$53BE(A4),D0
	JSR	_rnd
	MOVE.W	D0,D4

	MOVE.W	D4,D3
	EXT.L	D3
	ASL.L	#1,D3

	MOVEA.L	-$53B0(A4),A6
	MOVE.W	$00(A6,D3.L),-$53BC(A4)

	MOVEA.L	-$53AC(A4),A6
	MOVE.W	$00(A6,D3.L),-$53BA(A4)

	MOVEA.L	-$53B0(A4),A6
	MOVE.W	-$53BE(A4),D2

	SUBQ.W	#1,D2
	EXT.L	D2
	ASL.L	#1,D2
	MOVE.W	$00(A6,D2.L),$00(A6,D3.L)

	MOVEA.L	-$53AC(A4),A6
	SUBQ.W	#1,-$53BE(A4)
	MOVE.W	-$53BE(A4),D2
	EXT.L	D2
	ASL.L	#1,D2
	MOVE.W	$00(A6,D2.L),$00(A6,D3.L)
	MOVE.W	-$53BA(A4),-(A7)
	MOVE.W	-$53BC(A4),D3
	SUBQ.W	#2,D3
	MOVE.W	D3,-(A7)
	JSR	_maze_at(PC)
	ADDQ.W	#4,A7
	CMP.W	#$0000,D0
	BLE.B	L007A1

	MOVE.W	-$000A(A5),D3
	ADDQ.W	#1,-$000A(A5)
	EXT.L	D3
	ASL.L	#1,D3
	LEA	-$0008(A5),A6
	CLR.W	$00(A6,D3.L)
L007A1:
	MOVE.W	-$53BA(A4),-(A7)
	MOVE.W	-$53BC(A4),D3
	ADDQ.W	#2,D3
	MOVE.W	D3,-(A7)
	JSR	_maze_at(PC)
	ADDQ.W	#4,A7
	CMP.W	#$0000,D0
	BLE.B	L007A2

	MOVE.W	-$000A(A5),D3
	ADDQ.W	#1,-$000A(A5)
	EXT.L	D3
	ASL.L	#1,D3
	LEA	-$0008(A5),A6
	MOVE.W	#$0001,$00(A6,D3.L)
L007A2:
	MOVE.W	-$53BA(A4),D3
	SUBQ.W	#2,D3
	MOVE.W	D3,-(A7)
	MOVE.W	-$53BC(A4),-(A7)
	JSR	_maze_at(PC)
	ADDQ.W	#4,A7
	CMP.W	#$0000,D0
	BLE.B	L007A3

	MOVE.W	-$000A(A5),D3
	ADDQ.W	#1,-$000A(A5)
	EXT.L	D3
	ASL.L	#1,D3
	LEA	-$0008(A5),A6
	MOVE.W	#$0002,$00(A6,D3.L)
L007A3:
	MOVE.W	-$53BA(A4),D3
	ADDQ.W	#2,D3
	MOVE.W	D3,-(A7)
	MOVE.W	-$53BC(A4),-(A7)
	JSR	_maze_at(PC)
	ADDQ.W	#4,A7
	CMP.W	#$0000,D0
	BLE.B	L007A4

	MOVE.W	-$000A(A5),D3
	ADDQ.W	#1,-$000A(A5)
	EXT.L	D3
	ASL.L	#1,D3
	LEA	-$0008(A5),A6
	MOVE.W	#$0003,$00(A6,D3.L)
L007A4:
	MOVE.W	-$000A(A5),D0
	JSR	_rnd
	EXT.L	D0
	ASL.L	#1,D0
	LEA	-$0008(A5),A6
	MOVE.W	$00(A6,D0.L),D5
	MOVE.W	-$53BA(A4),-(A7)
	MOVE.W	-$53BC(A4),-(A7)
	JSR	_splat(PC)
	ADDQ.W	#4,A7
	MOVE.W	D5,D0
	BRA.B	L007AA
L007A5:
	MOVEQ	#$01,D5
	MOVEQ	#-$01,D6
	BRA.B	L007AC
L007A6:
	MOVEQ	#$00,D5
	MOVEQ	#$01,D6
	BRA.B	L007AC
L007A7:
	MOVEQ	#$03,D5
	MOVEQ	#-$01,D7
	BRA.B	L007AC
L007A8:
	MOVEQ	#$02,D5
	MOVEQ	#$01,D7
	BRA.B	L007AC
L007A9:
	dc.w	L007A5-L007AB
	dc.w	L007A6-L007AB
	dc.w	L007A7-L007AB
	dc.w	L007A8-L007AB
L007AA:
	CMP.w	#$0004,D0
	BCC.B	L007AC
	ASL.w	#1,D0
	MOVE.W	L007A9(PC,D0.W),D0
L007AB:	JMP	L007AB(PC,D0.W)
L007AC:
	MOVE.W	-$53BC(A4),D3
	ADD.W	D6,D3
	MOVE.W	D3,-$000C(A5)
	MOVE.W	-$53BA(A4),D3
	ADD.W	D7,D3
	MOVE.W	D3,-$000E(A5)
	MOVE.W	-$000E(A5),-(A7)
	MOVE.W	-$000C(A5),-(A7)
	JSR	_inrange(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L007AD

	MOVE.W	-$000E(A5),-(A7)
	MOVE.W	-$000C(A5),-(A7)
	BSR.B	_splat
	ADDQ.W	#4,A7
L007AD:
	MOVEM.L	(A7)+,D4-D7
	UNLK	A5
	RTS

_maze_at:
	LINK	A5,#-$0000
	MOVE.W	$000A(A5),-(A7)
	MOVE.W	$0008(A5),-(A7)
	JSR	_inrange(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L007AF

	MOVE.W	$000A(A5),d0
	MOVE.W	$0008(A5),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
;	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	CMP.B	#$23,D3
	BNE.B	L007AF
	MOVEQ	#$01,D0
L007AE:
	UNLK	A5
	RTS

L007AF:
	MOVEQ	#$00,D0
	BRA.B	L007AE
_splat:
	LINK	A5,#-$0000
	MOVE.W	$000A(A5),d0
	MOVE.W	$0008(A5),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	#$23,$00(A6,D0.W)

;	MOVE.W	$000A(A5),d0
;	MOVE.W	$0008(A5),d1
;	JSR	_INDEXquick

	MOVEA.L	-$5198(A4),A6	;__flags
	MOVE.B	#$30,$00(A6,D0.W)
	MOVE.W	$000A(A5),D3
	CMP.W	-$53B4(A4),D3
	BLE.B	L007B0

	MOVE.W	$000A(A5),-$53B4(A4)
L007B0:
	MOVE.W	$0008(A5),D3
	CMP.W	-$53B2(A4),D3
	BLE.B	L007B1
	MOVE.W	$0008(A5),-$53B2(A4)
L007B1:
	UNLK	A5
	RTS

_inrange:
	LINK	A5,#-$0000

	MOVE.W	$0008(A5),D3
	CMP.W	-$53B8(A4),D3
	BLT.B	L007B2

	MOVE.W	-$60BC(A4),D3	;_maxrow
	ADDQ.W	#1,D3
	EXT.L	D3
	DIVS.W	#$0003,D3
	ADD.W	-$53B8(A4),D3
	MOVE.W	$0008(A5),D2
	CMP.W	D3,D2
	BGE.B	L007B2

	MOVE.W	$000A(A5),D3
	CMP.W	-$53B6(A4),D3
	BLT.B	L007B2

	moveq	#$14,d3
	ADD.W	-$53B6(A4),D3
	MOVE.W	$000A(A5),D2
	CMP.W	D3,D2
	BGE.B	L007B2

	MOVEq	#$0001,D0
	BRA.B	L007B3
L007B2:
	CLR.W	D0
L007B3:
	UNLK	A5
	RTS

;/*
; * whatis:
; *  What a certain object is
; */

_whatis:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	$0008(A5),A2	;item to identify
	MOVE.L	A2,D3
	BNE.B	L007B6

	TST.L	-$529C(A4)	;_player + 46 (pack)
	BNE.B	L007B5

	PEA	L007C2(PC)	;"You don't have anything in your pack to identify"
	JSR	_msg
	ADDQ.W	#4,A7
L007B4:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L007B5:
	MOVE.L	A2,D3
	BNE.B	L007B6

	CLR.W	-(A7)
	PEA	L007C3(PC)	;"identify"
	JSR	_get_item
	ADDQ.W	#6,A7
	MOVEA.L	D0,A2
	TST.L	D0
	BNE.B	L007B6

	PEA	L007C4(PC)	;"You must identify something"
	JSR	_msg
	ADDQ.W	#4,A7
	PEA	L007C5(PC)	;" "
	JSR	_msg
	ADDQ.W	#4,A7
	CLR.W	-$60B0(A4)	;_mpos
	BRA.B	L007B5

L007B6:
	MOVE.L	A2,-(A7)
	JSR	_typeof
	ADDQ.W	#4,A7
;	EXT.L	D0
	BRA.W	L007BE

; scrolls

L007B9:
	MOVE.W	$0020(A2),D3
	LEA	-$66F6(A4),A6	;_s_know
	ST	$00(A6,D3.W)
;	MOVE.W	$0020(A2),D3
	MULU.W	#21,D3
	LEA	-$656A(A4),A6	;_s_guess
	CLR.B	$00(A6,D3.L)
	BRA.W	L007BF

; potions

L007BA:
	MOVE.W	$0020(A2),D3
	LEA	-$66E7(A4),A6	;_p_know
	ST	$00(A6,D3.W)
;	MOVE.W	$0020(A2),D3
	MULU.W	#21,D3
	LEA	-$642E(A4),A6	;_p_guess
	CLR.B	$00(A6,D3.L)
	BRA.W	L007BF

; wands/staffs

L007BB:
	MOVE.W	$0020(A2),D3
	LEA	-$66CB(A4),A6	;_ws_know
	ST	$00(A6,D3.W)
	ORI.W	#O_ISKNOW,$0028(A2)
;	MOVE.W	$0020(A2),D3
	MULU.W	#21,D3
	LEA	-$61E2(A4),A6	;_ws_guess
	CLR.B	$00(A6,D3.L)
	BRA.B	L007BF

; armor types and weapon types

L007BC:
	ORI.W	#O_ISKNOW,$0028(A2)
	BRA.B	L007BF

; rings

L007BD:
	MOVE.W	$0020(A2),D3
	LEA	-$66D9(A4),A6	;_r_know
	ST	$00(A6,D3.W)
	ORI.W	#O_ISKNOW,$0028(A2)
	MOVE.W	$0020(A2),D3
	MULU.W	#21,D3
	LEA	-$6308(A4),A6	;_r_guess
	CLR.B	$00(A6,D3.L)
	BRA.B	L007BF
L007BE:
	SUB.w	#$0021,D0	;'!' potion
	BEQ.B	L007BA
	SUB.w	#$000E,D0	;'/' wand/staff
	BEQ.B	L007BB
	SUB.w	#$000E,D0	;'=' ring
	BEQ.B	L007BD
	SUBQ.w	#2,D0		;'?' scroll
	BEQ.W	L007B9
	SUB.w	#$0022,D0	;'a' armor type
	BEQ.B	L007BC
	SUB.w	#$000C,D0	;'m' weapon type
	BEQ.B	L007BC
L007BF:
	TST.B	$002A(A2)	;has item special feature?
	BEQ.B	L007C0

	ORI.W	#O_SPECKNOWN,$0028(A2)	;set O_SPECKNOWN
L007C0:
	TST.W	$000C(A5)
	BEQ.B	L007C1

	MOVE.W	#$007E,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_nameof
	ADDQ.W	#6,A7

	MOVE.L	D0,-(A7)
	JSR	_msg
	ADDQ.W	#4,A7
L007C1:
	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_pack_name
	ADDQ.W	#6,A7

	MOVE.W	$000A(A2),d6

	; for rings and wands/staff we want to check if there
	; are more items who need an update

	CMP.B	#'/',d6		; wand/staff
	beq	1$

	CMP.B	#'=',d6		; ring
	bne	L007B4

1$	bsr	_pack_update

	BRA.W	L007B4

L007C2:	dc.b	"You don't have anything in your pack to identify",0
L007C3:	dc.b	"identify",0
L007C4:	dc.b	"You must identify something",0
L007C5:	dc.b	" ",0

_pack_update:
	move.l	a3,-(a7)
	MOVE.L	-$529C(A4),a3	;_player + 46 (pack)

;	MOVE.W	$000A(A2),d6	;item type we want to update
	move.w	$20(A2),d5	;subtype

	bra	2$

1$	cmp.l	A2,A3		;don't update twice!
	beq	3$

	cmp.w	$000A(A3),d6		;item type from list same as item type we want to update?
	bne	3$

	cmp.w	$20(a3),d5	;is it even the same subtype?
	bne	3$

	MOVE.W	#$0001,-(A7)
	MOVE.L	A3,-(A7)
	JSR	_pack_name	;update name of item
	ADDQ.W	#6,A7

3$	move.l	(a3),a3		;get next pointer in pack

2$	move.l	a3,d7		;something there?
	bne	1$

	move.l	(a7)+,a3
	rts

;/*
; * create_obj:
; *  wizard command for getting anything he wants
; */

_create_obj:
	LINK	A5,#-$0008

	JSR	_new_item
	MOVE.L	D0,-$0004(A5)
;	TST.L	D0
	BNE.B	L007C7

	PEA	L007ED(PC)	;"can't create anything now"
	JSR	_msg
	ADDQ.W	#4,A7
L007C6:
	UNLK	A5
	RTS

L007C7:
	TST.B	-$66F7(A4)	;_again
	BNE.B	L007C8

	PEA	L007EE(PC)	;"type of item: "
	JSR	_msg
	ADDQ.W	#4,A7
	JSR	_readchar
	MOVE.W	D0,-$53A4(A4)
L007C8:
	MOVE.W	-$53A4(A4),D0
;	EXT.L	D0
	BRA.B	L007D1

L007C9:
	MOVE.W	#$0021,$000A(A6)	; '!' potion
	BRA.B	L007D2
L007CA:
	MOVE.W	#$003F,$000A(A6)	; '?' scroll
	BRA.B	L007D2
L007CB:
	MOVE.W	#$002F,$000A(A6)	; '/' stick
	BRA.B	L007D2
L007CC:
	MOVE.W	#$003D,$000A(A6)	; '=' ring
	BRA.B	L007D2
L007CD:
	MOVE.W	#$006D,$000A(A6)	; 'm' weapon
	BRA.B	L007D2
L007CE:
	MOVE.W	#$0061,$000A(A6)	; 'a' armor
	BRA.B	L007D2
L007CF:
	MOVE.W	#$002C,$000A(A6)	; ',' amulet of yendor
	BRA	L007EC
L007D0:
	MOVE.W	#$003A,$000A(A6)	; ':' food
	BRA.B	L007D2
L007D0b:
	MOVE.W	#$002A,$000A(A6)	; '*' gold
	BRA	L007EB
L007D1:
	MOVEA.L	-$0004(A5),A6
	SUB.w	#$0021,D0	; '!' potion
	BEQ.B	L007C9
	SUBQ.w	#8,D0		; ')' weapon
	BEQ.B	L007CD
	SUBQ.w	#1,D0		; '*' gold
	BEQ.B	L007D0b
	SUBQ.w	#2,D0		; ',' amulet of yendor
	BEQ.B	L007CF
	SUBQ.w	#3,D0		; '/' stick
	BEQ.B	L007CB
	SUB.w	#$000E,D0	; '=' ring
	BEQ.B	L007CC
	SUBQ.w	#2,D0		; '?' scroll
	BEQ.B	L007CA
	SUB.w	#$001E,D0	; ']' armor
	BEQ.B	L007CE
	BRA.B	L007D0		; ':' food
L007D2:
	CLR.W	-$60B0(A4)	;_mpos
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$000A(A6),-(A7)
	PEA	L007EF(PC)	;"which %c do you want? (0-f)"
	JSR	_msg
	ADDQ.W	#6,A7
	TST.B	-$66F7(A4)	;_again
	BEQ.B	L007D3

	MOVE.B	-$53A5(A4),-$53A8(A4)
	BRA.B	L007D4
L007D3:
	JSR	_readchar
	MOVE.B	D0,-$53A8(A4)
	MOVEQ	#$00,D3
	MOVE.B	D0,D3
	MOVE.W	D3,-$53A6(A4)
L007D4:
	MOVEA.L	-$0004(A5),A6
	MOVE.L	A6,-(A7)
	MOVE.B	-$53A8(A4),D0

	JSR	_isdigit(PC)

	MOVEA.L	(A7)+,A6

	TST.W	D0
	BEQ.B	L007D5

	MOVEQ	#$00,D3
	MOVE.B	-$53A8(A4),D3
	SUB.W	#$0030,D3	; - '0'
	MOVE.W	D3,$0020(A6)
	BRA.B	L007D6
L007D5:
	MOVEQ	#$00,D3
	MOVE.B	-$53A8(A4),D3
	SUB.W	#$0057,D3	; - 'a' + 10
	MOVE.W	D3,$0020(A6)
L007D6:
	MOVEA.L	-$0004(A5),A6
	CLR.W	$002C(A6)	;clear group
;	MOVEA.L	-$0004(A5),A6
	MOVE.W	#$0001,$001E(A6)	;one item
;	MOVEA.L	-$0004(A5),A6
	LEA	L007F0(PC),A1	;"0d0"
	MOVE.L	A1,$001A(A6)
	MOVE.L	$001A(A6),$0016(A6)
	CLR.W	-$60B0(A4)	;_mpos
;	MOVEA.L	-$0004(A5),A6
	CMPI.W	#$006D,$000A(A6)	; 'm' weapon type
	BEQ.B	L007D7

;	MOVEA.L	-$0004(A5),A6
	CMPI.W	#$0061,$000A(A6)	; 'a' armor type
	BNE.W	L007DF
L007D7:
	TST.B	-$66F7(A4)	;_again
	BNE.B	L007D8

	PEA	L007F1(PC)	;"blessing? (+,-,n)"
	JSR	_msg
	ADDQ.W	#4,A7
	JSR	_readchar
	MOVE.B	D0,-$53A7(A4)
	CLR.W	-$60B0(A4)	;_mpos
L007D8:
	CMP.B	#$2D,-$53A7(A4)	; '-'
	BNE.B	L007D9

	MOVEA.L	-$0004(A5),A6
	ORI.W	#O_ISCURSED,$0028(A6)	; set curse bit
L007D9:
	MOVEA.L	-$0004(A5),A6
	CMPI.W	#$006D,$000A(A6)	; 'm' weapon
	BNE.B	L007DC

;	MOVEA.L	-$0004(A5),A6
	MOVE.L	A6,-(A7)
	JSR	_init_weapon
	ADDQ.W	#4,A7

	MOVEq	#$0003,D0
	JSR	_rnd
	ADDQ.W	#1,D0
	MOVEA.L	-$0004(A5),A6

	CMP.B	#$2D,-$53A7(A4)	; '-'
	BNE.B	1$

	SUB.W	D0,$0022(A6)
1$
	CMP.B	#$2B,-$53A7(A4)	; '+'
	BNE.B	L007DB

	ADD.W	D0,$0022(A6)
L007DB:
	BRA.B	L007DE
L007DC:
	MOVEA.L	-$0004(A5),A6
	moveq	#$61,D3		;a armor type
	ADD.W	$0020(A6),D3
	MOVE.W	D3,$000A(A6)
;	MOVEA.L	-$0004(A5),A6
	MOVE.W	$0020(A6),D3
;	EXT.L	D3
	ASL.w	#1,D3
	LEA	-$6F00(A4),A1	;_a_class
	MOVE.W	$00(A1,D3.w),$0026(A6)

	MOVEq	#$0003,D0
	JSR	_rnd
	ADDQ.W	#1,D0
	MOVEA.L	-$0004(A5),A6

	CMP.B	#$2D,-$53A7(A4)	; -
	BNE.B	1$

	ADD.W	D0,$0026(A6)
1$
	CMP.B	#$2B,-$53A7(A4)	; +
	BNE.B	L007DE

	SUB.W	D0,$0026(A6)
L007DE:
	BRA.W	L007EC
L007DF:
	MOVEA.L	-$0004(A5),A6
	CMPI.W	#$003D,$000A(A6)	; '=' ring
	BNE.W	L007EA

;	MOVEA.L	-$0004(A5),A6
	MOVE.W	$0020(A6),D0
;	EXT.L	D0
	BRA.W	L007E7
L007E0:
	TST.B	-$66F7(A4)	;_again
	BNE.B	L007E1

	PEA	L007F1(PC)	;"blessing? (+,-,n)"
	JSR	_msg
	ADDQ.W	#4,A7
	JSR	_readchar
	MOVE.B	D0,-$53A7(A4)
	CLR.W	-$60B0(A4)	;_mpos
L007E1:
	CMP.B	#$2D,-$53A7(A4)	; '-'
	BNE.B	L007E3

	MOVE.W	#-1,$0026(A6)
	BRA.B	L007E5
L007E3:
	MOVE.L	A6,-(A7)
	MOVEq	#$0002,D0
	JSR	_rnd
	ADDQ.W	#1,D0
	MOVEA.L	(A7)+,A6
	MOVE.W	D0,$0026(A6)
	BRA.B	L007E9
L007E5:
	MOVEA.L	-$0004(A5),A6
	ORI.W	#O_ISCURSED,$0028(A6)
	BRA.B	L007E9
L007E6:
	dc.w	L007E0-L007E8	;regeneration, can be good or bad
	dc.w	L007E0-L007E8	;add strength, can be good or bad
	dc.w	L007E9-L007E8	;always good
	dc.w	L007E9-L007E8	;always good
	dc.w	L007E9-L007E8	;always good
	dc.w	L007E9-L007E8	;always good
	dc.w	L007E5-L007E8	;aggravate monster, always cursed
	dc.w	L007E0-L007E8	;dexterity, can be good or bad
	dc.w	L007E0-L007E8	;add damage, can be good or bad
	dc.w	L007E9-L007E8	;always good
	dc.w	L007E9-L007E8	;always good
	dc.w	L007E5-L007E8	;teleportation, always cursed
L007E7:
	CMP.w	#$000C,D0
	BCC.B	L007E9
	ASL.w	#1,D0
	MOVE.W	L007E6(PC,D0.W),D0
L007E8:	JMP	L007E8(PC,D0.W)

L007E9:
	BRA.B	L007EC
L007EA:
	MOVEA.L	-$0004(A5),A6
	CMPI.W	#$002F,$000A(A6)	; '/'
	BNE.B	L007EB

	MOVE.L	-$0004(A5),-(A7)
	JSR	_fix_stick(PC)
	ADDQ.W	#4,A7
	BRA.B	L007EC
L007EB:
	MOVEA.L	-$0004(A5),A6
	CMPI.W	#$002A,$000A(A6)	; '*'
	BNE.B	L007EC

	CLR.W	-$60B0(A4)	;_mpos
	PEA	L007F3(PC)	;"how much? "
	JSR	_msg
	ADDQ.W	#4,A7

	MOVEA.L	-$0004(A5),A6
	PEA	$0026(A6)
	JSR	_get_num(PC)
	ADDQ.W	#4,A7

	CLR.W	-$60B0(A4)	;_mpos

	MOVEA.L	-$0004(A5),A6
	move.w	$0026(A6),-(a7)
	jsr	_money
	addq.l	#2,a7

	JSR	_status
	BRA.W	L007C6

L007EC:
	CLR.L	-(A7)
	MOVE.L	-$0004(A5),-(A7)
	JSR	_add_pack
	ADDQ.W	#8,A7
	BRA.W	L007C6

L007ED:	dc.b	"can't create anything now",0
L007EE:	dc.b	"type of item: ",0
L007EF:	dc.b	"which %c do you want? (0-f)",0
L007F0:	dc.b	"0d0",0
L007F1:	dc.b	"blessing? (+,-,n)",0
L007F3:	dc.b	"how much? ",0

;/*
; * teleport:
; *  Bamf the hero someplace else
; */

_teleport:
	LINK	A5,#-$0004
	MOVE.L	D4,-(A7)

	JSR	_INDEXplayer

	MOVEA.L	-$519C(A4),A6	;__level

	MOVE.B	$00(A6,D0.W),D2
	MOVE.W	-$52C0(A4),d1	;_player + 10
	MOVE.W	-$52BE(A4),d0	;_player + 12
	JSR	_mvaddchquick

L007F4:
	JSR	_rnd_room
	MOVE.W	D0,D4
	PEA	-$0004(A5)
	MOVE.W	D4,D3
	MULU.W	#66,D3
	LEA	-$6088(A4),A6	;_rooms
	ADD.L	A6,D3
	MOVE.L	D3,-(A7)
	JSR	_rnd_pos
	ADDQ.W	#8,A7
	MOVE.W	-$0004(A5),-(A7)
	MOVE.W	-$0002(A5),-(A7)
	JSR	_winat
	ADDQ.W	#4,A7
	MOVE.W	D0,-(A7)
	JSR	_step_ok
	ADDQ.W	#2,A7
	TST.W	D0
	BEQ.B	L007F4

	MOVE.W	D4,D3
	MULU.W	#66,D3
	LEA	-$6088(A4),A6	;_rooms
	ADD.L	A6,D3
	CMP.L	-$52A0(A4),D3	;_player + 42 (proom)
	BEQ.B	L007F5

	PEA	-$52C0(A4)	;_player + 10
	JSR	_leave_room
	ADDQ.W	#4,A7
	LEA	-$52C0(A4),A6	;_player + 10
	LEA	-$0004(A5),A1
	MOVE.L	(A1)+,(A6)+
	PEA	-$52C0(A4)	;_player + 10
	JSR	_enter_room
	ADDQ.W	#4,A7
	BRA.B	L007F6
L007F5:
	LEA	-$52C0(A4),A6	;_player + 10
	LEA	-$0004(A5),A1
	MOVE.L	(A1)+,(A6)+
	MOVE.W	#$0001,-(A7)
	JSR	_look
	ADDQ.W	#2,A7
L007F6:
	MOVEq	#$0040,d2	;'@' PLAYER
	MOVE.W	-$52C0(A4),d1	;_player + 10
	MOVE.W	-$52BE(A4),d0	;_player + 12
	JSR	_mvaddchquick

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISHELD,D3	;C_ISHELD
	BEQ.B	L007F7

	ANDI.W	#~C_ISHELD,-$52B4(A4)	;clear C_ISHELD,_player + 22 (flags)
	JSR	_f_restor
L007F7:
	CLR.W	-$60AE(A4)	;_no_move
	CLR.W	-$60A4(A4)	;_count
	CLR.B	-$66B6(A4)	;_running
	JSR	_flush_type

	TST.B	-$66AE(A4)	;_wizard
	BNE.B	L007FA

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISHUH,D3	;C_ISHUH
	BEQ.B	L007F8

	MOVEq	#$0004,D0
	JSR	_rnd
	ADDQ.W	#2,D0
	MOVE.W	D0,-(A7)
	PEA	_unconfuse(PC)
	JSR	_lengthen(PC)
	ADDQ.W	#6,A7
	BRA.B	L007F9
L007F8:
	MOVEq	#$0004,D0
	JSR	_rnd
	ADDQ.W	#2,D0
	MOVE.W	D0,-(A7)
	CLR.W	-(A7)
	PEA	_unconfuse(PC)
	JSR	_fuse(PC)
	ADDQ.W	#8,A7
L007F9:
	ORI.W	#C_ISHUH,-$52B4(A4)	;ISHUH,_player + 22 (flags)
L007FA:
	MOVE.W	D4,D0

	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

;/*
; * show_map:
; *  Print out the map for the wizard
; */

_show_map:
	LINK	A5,#-$0000
	MOVEM.L	D4-D6,-(A7)

	MOVEQ	#$01,D4
	BRA.B	L007FF
L007FB:
	MOVEQ	#$00,D5
L007FC:
	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick

	MOVEA.L	-$5198(A4),A6	;__flags
	MOVE.B	$00(A6,D0.W),D6
	AND.W	#$0010,D6
	TST.W	D6
	BNE.B	L007FD

	JSR	_standout
L007FD:
	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick
	MOVEA.L	-$519C(A4),A6	;__level

	MOVE.B	$00(A6,D0.W),D2
	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_mvaddchquick

	TST.W	D6
	BNE.B	L007FE

	JSR	_standend
L007FE:
	ADDQ.W	#1,D5
	CMP.W	#$003C,D5
	BLT.B	L007FC

	ADDQ.W	#1,D4
L007FF:
	CMP.W	-$60BC(A4),D4	;_maxrow
	BLT.B	L007FB

	MOVEM.L	(A7)+,D4-D6
	UNLK	A5
	RTS

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

_tr_name:
	LINK	A5,#-$0000
	MOVEQ	#$00,D0
	MOVE.B	$0009(A5),D0
	CMP.w	#$0006,D0
	BCC.B	L0080A

	ASL.w	#2,D0
	MOVE.L	L00807(PC,D0.W),D0
	BRA.B	L00801

L0080A:
	MOVE.W	D0,-(A7)
	PEA	L00811(PC)	;"wierd trap: %d"
	JSR	_msg
	ADDQ.W	#6,A7
	MOVEQ	#$00,D0
L00801:
	UNLK	A5
	RTS

L00807:
	dc.l	L0080B
	dc.l	L0080E
	dc.l	L0080D
	dc.l	L0080C
	dc.l	L0080F
	dc.l	L00810

L0080B:	dc.b	"a trapdoor",0
L0080C:	dc.b	"a beartrap",0
L0080D:	dc.b	"a sleeping gas trap",0
L0080E:	dc.b	"an arrow trap",0
L0080F:	dc.b	"a teleport trap",0
L00810:	dc.b	"a poison dart trap",0
L00811:	dc.b	"wierd trap: %d",0

_near_to:
	LINK	A5,#-$0000
	MOVEM.L	A2,-(A7)

	MOVEA.L	$0008(A5),A2

	MOVE.W	$0002(A2),D3

	SUB.W	$000C(A5),D3
	BGE.B	L00812

	NEG.W	D3
L00812:
	CMP.W	#$0001,D3
	BGT.B	L00816

	MOVE.W	(A2),D3
	SUB.W	$000E(A5),D3
	BGE.B	L00814

	NEG.W	D3
L00814:
	CMP.W	#$0001,D3
	BGT.B	L00816

	MOVEq	#$0001,D0
	BRA.B	L00817
L00816:
	CLR.W	D0
L00817:
	MOVEM.L	(A7)+,A2
	UNLK	A5
	RTS

;/*
; * look:
; *  A quick glance all around the player
; */

_look:
	LINK	A5,#-$0018
	MOVEM.L	D4-D7/A2/A3,-(A7)

	CLR.W	-$000A(A5)
	ST	-$48B7(A4)		;_looking
	MOVE.L	-$52A0(A4),-$0004(A5)	;_player + 42 (proom)

	JSR	_INDEXplayer

	MOVEA.W	D0,A2
	MOVE.W	A2,D3
	MOVEA.L	-$5198(A4),A6	;__flags
	MOVE.B	$00(A6,D3.W),-$000B(A5)
	MOVE.W	A2,D3
	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	$00(A6,D3.W),D7

	PEA	-$52C0(A4)	;_player + 10
	PEA	-$6090(A4)
	JSR	__ce(PC)
	ADDQ.W	#8,A7

	TST.W	D0
	BNE.W	L00823

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BNE.W	L00822

	MOVE.W	-$6090(A4),D4
	SUBQ.W	#1,D4
	BRA.W	L00821
L00818:
	MOVE.W	-$608E(A4),D5
	SUBQ.W	#1,D5
	BRA.W	L00820
L00819:
	CMP.W	-$52BE(A4),D5	;_player + 12
	BNE.B	L0081A

	CMP.W	-$52C0(A4),D4	;_player + 10
	BEQ.W	L0081F
L0081A:
	MOVE.W	D4,-(A7)
	MOVE.W	D5,-(A7)
	JSR	_offmap(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.W	L0081F

	MOVE.W	D4,-(A7)
	MOVE.W	D5,-(A7)
	PEA	-$6090(A4)
	JSR	_near_to(PC)
	ADDQ.W	#8,A7

	TST.W	D0
	BEQ.B	L0081B

	MOVE.W	D4,-(A7)
	MOVE.W	D5,-(A7)
	PEA	-$52C0(A4)	;_player + 10
	JSR	_near_to(PC)
	ADDQ.W	#8,A7

	TST.W	D0
	BNE.W	L0081F
L0081B:
	MOVE.W	D4,-(A7)
	MOVE.W	D5,-(A7)
	JSR	_mvinch(PC)
	ADDQ.W	#4,A7
	MOVE.B	D0,D6
	CMP.B	#$2E,D0		;'.'
	BNE.B	L0081D

	MOVE.L	-$48C0(A4),-(A7)	;_oldrp
	JSR	_is_dark(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L0081C

	MOVEA.L	-$48C0(A4),A6	;_oldrp
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3
	BNE.B	L0081C

	MOVE.W	#$0020,-(A7)	;' '
	JSR	_addch
	ADDQ.W	#2,A7
L0081C:
	BRA.B	L0081F
L0081D:
	MOVE.W	D4,d0
	MOVE.W	D5,d1
	JSR	_INDEXquick

	EXT.L	D0
	ADD.L	-$5198(A4),D0	;__flags
	MOVE.L	D0,-$0010(A5)
	MOVEA.L	-$0010(A5),A6
;	MOVEQ	#$00,D3
	MOVE.B	(A6),D3
	AND.W	#$0020,D3
	BNE.B	L0081E

	MOVEA.L	-$0010(A5),A6
	MOVE.B	(A6),D3
	AND.B	#$40,D3
	BEQ.B	L0081F
L0081E:
	CMP.B	#$23,D6		;'#' PASSAGE
	BEQ.B	L0081F

	CMP.B	#$25,D6		;'%' STAIRS
	BEQ.B	L0081F

	MOVEA.L	-$0010(A5),A6
	MOVE.B	(A6),D3
	AND.B	#$0F,D3
	MOVE.B	-$000B(A5),D2
	AND.B	#$0F,D2
	CMP.B	D2,D3
	BNE.B	L0081F

	MOVE.W	#$0023,-(A7)	;'#' PASSAGE
	JSR	_addch
	ADDQ.W	#2,A7
L0081F:
	ADDQ.W	#1,D5
L00820:
	MOVE.W	-$608E(A4),D3
	ADDQ.W	#1,D3
	CMP.W	D3,D5
	BLE.W	L00819

	ADDQ.W	#1,D4
L00821:
	MOVE.W	-$6090(A4),D3
	ADDQ.W	#1,D3
	CMP.W	D3,D4
	BLE.W	L00818
L00822:
	LEA	-$6090(A4),A6
	LEA	-$52C0(A4),A1	;_player + 10
	MOVE.L	(A1)+,(A6)+
	MOVE.L	-$0004(A5),-$48C0(A4)	;_oldrp
L00823:
	MOVE.W	-$52BE(A4),D3	;_player + 12
	ADDQ.W	#1,D3
	MOVE.W	D3,-$0006(A5)
	MOVE.W	-$52C0(A4),D3	;_player + 10
	ADDQ.W	#1,D3
	MOVE.W	D3,-$0008(A5)
	MOVE.W	-$52C0(A4),D3	;_player + 10
	SUBQ.W	#1,D3
	MOVE.W	D3,-$0014(A5)
	MOVE.W	-$52BE(A4),D3	;_player + 12
	SUBQ.W	#1,D3
	MOVE.W	D3,-$0012(A5)
	TST.B	-$66BB(A4)	;_door_stop
	BEQ.B	L00824
	TST.B	-$66B8(A4)	;_firstmove
	BNE.B	L00824
	TST.B	-$66B6(A4)	;_running
	BEQ.B	L00824
	MOVE.W	-$52BE(A4),D3	;_player + 12
	ADD.W	-$52C0(A4),D3	;_player + 10
	MOVE.W	D3,-$0016(A5)
	MOVE.W	-$52BE(A4),D3	;_player + 12
	SUB.W	-$52C0(A4),D3	;_player + 10
	MOVE.W	D3,-$0018(A5)
L00824:
	MOVEq	#$0040,d2	;'@' PLAYER
	MOVE.W	-$52C0(A4),d1	;_player + 10
	MOVE.W	-$52BE(A4),d0	;_player + 12
	JSR	_mvaddchquick

	MOVE.W	-$0012(A5),D5
	BRA.W	L00849
L00825:
	CMP.W	#$0000,D5
	BLE.W	L00848

	CMP.W	-$60BC(A4),D5	;_maxrow
	BGE.W	L00848

	MOVE.W	-$0014(A5),D4
	BRA.W	L00847
L00826:
	CMP.W	#$0000,D4
	BLE.W	L00846
	CMP.W	#$003C,D4	;'<' room corner
	BGE.W	L00846
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BNE.B	L00828
	CMP.W	-$52BE(A4),D5	;_player + 12
	BNE.B	L00827
	CMP.W	-$52C0(A4),D4	;_player + 10
	BEQ.W	L00846
L00827:
	BRA.B	L00829
L00828:
	CMP.W	-$52BE(A4),D5	;_player + 12
	BNE.W	L00846
	CMP.W	-$52C0(A4),D4	;_player + 10
	BNE.W	L00846
L00829:
	MOVE.W	D4,d0
	MOVE.W	D5,d1
	JSR	_INDEXquick

	MOVEA.W	D0,A2
	MOVE.W	A2,D3
	EXT.L	D3
	ADD.L	-$5198(A4),D3	;__flags
	MOVE.L	D3,-$0010(A5)
	MOVE.W	A2,D3
	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	$00(A6,D3.W),D6
	MOVEQ	#$00,D3
	MOVE.B	D7,D3
	CMP.W	#$002B,D3	;'+' DOOR
	BEQ.B	L0082C

	CMP.B	#$2B,D6		;'+' DOOR
	BEQ.B	L0082C

	MOVE.B	-$000B(A5),D3
	AND.B	#$40,D3
	MOVEA.L	-$0010(A5),A6
	MOVE.B	(A6),D2
	AND.B	#$40,D2
	CMP.B	D2,D3
	BEQ.B	L0082B

	MOVE.B	-$000B(A5),D3
	AND.B	#$20,D3
	BNE.B	L0082A

	MOVEA.L	-$0010(A5),A6
	MOVE.B	(A6),D3
	AND.B	#$20,D3
	BEQ.W	L00846
L0082A:
	BRA.B	L0082C
L0082B:
	MOVEA.L	-$0010(A5),A6
	MOVE.B	(A6),D3
	AND.W	#$0040,D3
	BEQ.B	L0082C

	MOVEA.L	-$0010(A5),A6
	MOVE.B	(A6),D3
	AND.B	#$0F,D3
	MOVE.B	-$000B(A5),D2
	AND.B	#$0F,D2
	CMP.B	D2,D3
	BNE.W	L00846
L0082C:
	MOVE.W	D4,d1
	MOVE.W	D5,d0
	JSR	_moatquick

	MOVEA.L	D0,A3
	TST.L	D0
	BEQ.B	L00832

	MOVE.W	$0016(A3),D3
	AND.W	#C_ISINVIS,D3	;C_ISINVIS
	BEQ.B	L0082E

	; bugfix: test if we actually can see the invisible

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_CANSEE,D3	;C_CANSEE
	BNE	L0082E

	TST.B	-$66BB(A4)	;_door_stop
	BEQ.B	L0082D

	TST.B	-$66B8(A4)	;_firstmove
	BNE.B	L0082D

	CLR.B	-$66B6(A4)	;_running
L0082D:
	BRA.B	L00832
L0082E:
	TST.B	$0009(A5)
	BEQ.B	L0082F

	MOVE.W	D4,-(A7)
	MOVE.W	D5,-(A7)
	JSR	_wake_monster
	ADDQ.W	#4,A7
L0082F:
	CMP.B	#$20,$0011(A3)
	BNE.B	L00830

	MOVE.L	-$0004(A5),-(A7)
	JSR	_is_dark(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.B	L00831

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BNE.B	L00831
L00830:
	MOVE.W	A2,D3
	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	$00(A6,D3.W),$0011(A3)
L00831:
	MOVE.L	A3,-(A7)
	JSR	_see_monst
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00832

	MOVE.B	$0010(A3),D6
L00832:
	MOVE.W	D4,d1
	MOVE.W	D5,d0
	JSR	_movequick

	MOVEQ	#$00,D3
	MOVE.B	D6,D3
	MOVE.W	D3,-(A7)
	JSR	_addch
	ADDQ.W	#2,A7

	JSR	_standend

	TST.B	-$66BB(A4)	;_door_stop
	BEQ.W	L00846

	TST.B	-$66B8(A4)	;_firstmove
	BNE.W	L00846

	TST.B	-$66B6(A4)	;_running
	BEQ.W	L00846

	MOVE.B	-$66A8(A4),D0	;_runch
	EXT.W	D0
;	EXT.L	D0
	BRA.B	L0083B
L00833:
	CMP.W	-$0008(A5),D4
	BEQ.W	L00846
	BRA.W	L0083C
L00834:
	CMP.W	-$0012(A5),D5
	BEQ.W	L00846
	BRA.W	L0083C
L00835:
	CMP.W	-$0006(A5),D5
	BEQ.W	L00846
	BRA.B	L0083C
L00836:
	CMP.W	-$0014(A5),D4
	BEQ.W	L00846
	BRA.B	L0083C
L00837:
	MOVE.W	D5,D3
	ADD.W	D4,D3
	SUB.W	-$0016(A5),D3
	CMP.W	#$0001,D3
	BGE.W	L00846
	BRA.B	L0083C
L00838:
	MOVE.W	D5,D3
	SUB.W	D4,D3
	SUB.W	-$0018(A5),D3
	CMP.W	#$0001,D3
	BGE.W	L00846
	BRA.B	L0083C
L00839:
	MOVE.W	D5,D3
	ADD.W	D4,D3
	SUB.W	-$0016(A5),D3
	CMP.W	#$FFFF,D3
	BLE.W	L00846
	BRA.B	L0083C
L0083A:
	MOVE.W	D5,D3
	SUB.W	D4,D3
	SUB.W	-$0018(A5),D3
	CMP.W	#$FFFF,D3
	BLE.W	L00846
	BRA.B	L0083C
L0083B:
	SUB.w	#$0062,D0	;'b'
	BEQ.B	L0083A
	SUBQ.w	#6,D0		;'h'
	BEQ.B	L00833
	SUBQ.w	#2,D0		;'j'
	BEQ.B	L00834
	SUBQ.w	#1,D0		;'k'
	BEQ.B	L00835
	SUBQ.w	#1,D0		;'l'
	BEQ.B	L00836
	SUBQ.w	#2,D0		;'n'
	BEQ.B	L00839
	SUBQ.w	#7,D0		;'u'
	BEQ.B	L00838
	SUBQ.w	#4,D0		;'y'
	BEQ.B	L00837
L0083C:
	MOVEQ	#$00,D0
	MOVE.B	D6,D0
	BRA.B	L00845
L0083D:
	CMP.W	-$52C0(A4),D4	;_player + 10
	BEQ.B	L0083E
	CMP.W	-$52BE(A4),D5	;_player + 12
	BNE.B	L0083F
L0083E:
	CLR.B	-$66B6(A4)	;_running
L0083F:
	BRA.B	L00846
L00840:
	CMP.W	-$52C0(A4),D4	;_player + 10
	BEQ.B	L00841
	CMP.W	-$52BE(A4),D5	;_player + 12
	BNE.B	L00846
L00841:
	ADDQ.W	#1,-$000A(A5)
	BRA.B	L00846
L00844:
	CLR.B	-$66B6(A4)	;_running
	BRA.B	L00846
L00845:
	SUB.w	#$0020,D0	;' '	SPACE
	BEQ.B	L00846
	SUBQ.w	#3,D0		;'#'	PASSAGE
	BEQ.B	L00840
	SUBQ.w	#8,D0		;'+'	DOOR
	BEQ.B	L0083D
	SUBQ.w	#2,D0		;'-'	WALL
	BEQ.B	L00846
	SUBQ.w	#1,D0		;'.'	FLOOR
	BEQ.B	L00846
	SUB.w	#$000E,D0	;'<'	DOWN
	BEQ.B	L00846
	SUBQ.w	#2,D0		;'>'	UP
	BEQ.B	L00846
	SUB.w	#$003D,D0	;'{'	top left room corner
	BEQ.B	L00846
	SUBQ.w	#1,D0		;'|'	WALL
	BEQ.B	L00846
	SUBQ.w	#1,D0		;'}'	top right room corner
	BEQ.B	L00846
	BRA.B	L00844
L00846:
	ADDQ.W	#1,D4
L00847:
	CMP.W	-$0008(A5),D4
	BLE.W	L00826
L00848:
	ADDQ.W	#1,D5
L00849:
	CMP.W	-$0006(A5),D5
	BLE.W	L00825

	TST.B	-$66BB(A4)	;_door_stop
	BEQ.B	L0084A

	TST.B	-$66B8(A4)	;_firstmove
	BNE.B	L0084A

	CMPI.W	#$0001,-$000A(A5)
	BLE.B	L0084A

	CLR.B	-$66B6(A4)	;_running
L0084A:
	MOVEq	#$0040,d2	;'@' PLAYER
	MOVE.W	-$52C0(A4),d1	;_player + 10
	MOVE.W	-$52BE(A4),d0	;_player + 12
	JSR	_mvaddchquick

	TST.B	-$66B4(A4)	;_was_trapped
	BEQ.B	L0084B

	JSR	_beep(PC)
	CLR.B	-$66B4(A4)	;_was_trapped
L0084B:
	CLR.B	-$48B7(A4)	;_looking

	MOVEM.L	(A7)+,D4-D7/A2/A3
	UNLK	A5
	RTS

;/*
; * find_obj:
; *  Find the unclaimed object at y, x
; */

_find_obj:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5/A2,-(A7)

	MOVE.W	$0008(A5),D4
	MOVE.W	$000A(A5),D5

	MOVEA.L	-$6CB0(A4),A2	;_lvl_obj
	BRA.B	L0084F
L0084C:
	CMP.W	$000E(A2),D4
	BNE.B	L0084E

	CMP.W	$000C(A2),D5
	BNE.B	L0084E

	MOVE.L	A2,D0
L0084D:
	MOVEM.L	(A7)+,D4/D5/A2
	UNLK	A5
	RTS

L0084E:
	MOVEA.L	(A2),A2		;get next object
L0084F:
	MOVE.L	A2,D3		;null check
	BNE.B	L0084C

	MOVEQ	#$00,D0
	BRA.B	L0084D

;/*
; * eat:
; *  She wants to eat something, so let her try
; */

_eat:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)
	MOVEA.L	$0008(A5),A2
	MOVE.L	A2,D3
	BNE.B	L00851

	MOVE.W	#$003A,-(A7)	;':' food
	PEA	L0085C(PC)	;"eat"
	JSR	_get_item
	ADDQ.W	#6,A7

	MOVEA.L	D0,A2
	TST.L	D0
	BNE.B	L00851
L00850:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L00851:
	CMPI.W	#$003A,$000A(A2)	;':' food
	BEQ.B	L00852

	PEA	L0085D(PC)	;"ugh, you would get ill if you ate that"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L00850
L00852:
	MOVE.W	#$0001,-(A7)	;one item
	MOVE.L	A2,-(A7)
	JSR	_unpack
	ADDQ.W	#6,A7

	MOVEA.L	D0,A2		;could we remove the item from the pack?
	TST.L	D0
	BNE.B	L00853

	JSR	_stuck(PC)
	BRA.B	L00850
L00853:
	CMPI.W	#$0000,-$609E(A4)	;_food_left
	BGE.B	L00854

	CLR.W	-$609E(A4)	;_food_left
L00854:
	CMPI.W	#1980,-$609E(A4)	;_food_left
	BLE.B	L00855

	MOVEq	#$0005,D0
	JSR	_rnd
	ADDQ.W	#2,D0
	ADD.W	D0,-$60AC(A4)	;_no_command
L00855:
	MOVE.W	#1300,D0
	JSR	_spread

	MOVE.W	D0,-(A7)

	MOVE.W	#400,D0
	JSR	_rnd

	MOVE.W	(A7)+,D3
	ADD.W	D0,D3
	SUB.W	#200,D3
	ADD.W	D3,-$609E(A4)	;_food_left
	CMPI.W	#2000,-$609E(A4)	;_food_left
	BLE.B	L00856

	MOVE.W	#2000,-$609E(A4)	;_food_left
L00856:
	TST.W	-$609A(A4)	;_hungry_state
	BEQ.B	L00857
	CLR.W	-$609A(A4)	;_hungry_state
	JSR	_NewRank(PC)
L00857:
	CMPI.W	#$0001,$0020(A2)
	BNE.B	L00858

	PEA	-$6713(A4)	;_fruit "Mango"
	PEA	L0085E(PC)	;"my, that was a yummy %s"
	JSR	_msg
	ADDQ.W	#8,A7
	BRA.B	L0085A
L00858:
	MOVEq	#100,D0
	JSR	_rnd
	CMP.W	#70,D0
	BLE.B	L00859

	ADDQ.L	#1,-$52B0(A4)	;_player + 26 (EXP)

	PEA	L0085F(PC)	;"yuk, this food tastes awful"
	JSR	_msg
	ADDQ.W	#4,A7
	JSR	_check_level(PC)
	BRA.B	L0085A
L00859:
	PEA	L00860(PC)	;"yum, that tasted good"
	JSR	_msg
	ADDQ.W	#4,A7
L0085A:
	TST.W	-$60AC(A4)	;_no_command
	BEQ.B	L0085B

	PEA	L00861(PC)	;"You feel bloated and fall asleep"
	JSR	_msg
	ADDQ.W	#4,A7
L0085B:
	MOVE.L	A2,-(A7)
	JSR	_discard
	ADDQ.W	#4,A7
	BRA.W	L00850

L0085C:	dc.b	"eat",0
L0085D:	dc.b	"ugh, you would get ill if you ate that",0
L0085E:	dc.b	"my, that was a yummy %s",0
L0085F:	dc.b	"yuk, this food tastes awful",0
L00860:	dc.b	"yum, that tasted good",0
L00861:	dc.b	"You feel bloated and fall asleep",0

;/*
; * chg_str:
; *  used to modify the players strength.  It keeps track of the
; *  highest it has been, just in case
; */

_chg_str:
	LINK	A5,#-$0002
	MOVE.L	D4,-(A7)

	MOVE.W	$0008(A5),D4
	BNE.B	L00863
L00862:
	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

L00863:
	MOVE.W	D4,-(A7)
	PEA	-$52B2(A4)	;_player + 24 (strength)
	BSR.B	_add_str
	ADDQ.W	#6,A7

	MOVE.W	-$52B2(A4),-$0002(A5)	;_player + 24 (strength)

	TST.L	-$5190(A4)	;_cur_ring_1
	BEQ.B	L00864

	MOVEA.L	-$5190(A4),A6	;_cur_ring_1
	CMPI.W	#R_ADDSTR,$0020(A6)
	BNE.B	L00864

	MOVE.W	$0026(A6),D3
	NEG.W	D3
	MOVE.W	D3,-(A7)
	PEA	-$0002(A5)
	BSR.B	_add_str
	ADDQ.W	#6,A7
L00864:
	TST.L	-$518C(A4)	;_cur_ring_2
	BEQ.B	L00865

	MOVEA.L	-$518C(A4),A6	;_cur_ring_2
	CMPI.W	#R_ADDSTR,$0020(A6)
	BNE.B	L00865

	MOVE.W	$0026(A6),D3
	NEG.W	D3
	MOVE.W	D3,-(A7)
	PEA	-$0002(A5)
	BSR.B	_add_str
	ADDQ.W	#6,A7
L00865:
	MOVE.W	-$0002(A5),D3
	CMP.W	-$6CC2(A4),D3	;_max_stats + 0 (max strength)
	BLS.B	L00862

	MOVE.W	-$0002(A5),-$6CC2(A4)	;_max_stats + 0 (max strength)
	BRA.B	L00862

;/*
; * add_str:
; *  Perform the actual add, checking upper and lower bound limits
; */

_add_str:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	$0008(A5),A2
	move.w	(a2),d3

	add.W	$000C(A5),D3

	CMPI.W	#3,d3
	BCC.B	1$
	MOVEq	#3,d3
	BRA.B	2$

1$	CMPI.W	#31,d3
	BLS.B	2$
	MOVEq	#31,d3

2$	move.w	d3,(a2)
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

;/*
; * add_haste:
; *  Add a haste to the player
; */

_add_haste:
	LINK	A5,#-$0000
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISHASTE,D3	; check C_ISHASTE bit
	BEQ.B	L0086A

	MOVEq	#$0008,D0
	JSR	_rnd
	ADD.W	D0,-$60AC(A4)	;_no_command

	ANDI.W	#~C_ISRUN,-$52B4(A4)	;clear C_ISRUN, _player + 22 (flags)

	PEA	_nohaste(PC)
	JSR	_extinguish(PC)
	ADDQ.W	#4,A7

	ANDI.W	#~C_ISHASTE,-$52B4(A4)	;clear C_ISHASTE,_player + 22 (flags)

	PEA	L0086C(PC)	;"you faint from exhaustion"
	JSR	_msg
	ADDQ.W	#4,A7

	MOVEQ	#$00,D0
L00869:
	UNLK	A5
	RTS

L0086A:
	ORI.W	#C_ISHASTE,-$52B4(A4)	;C_ISHASTE,_player + 22 (flags)
	TST.B	$0009(A5)
	BEQ.B	L0086B

	MOVEq	#$0028,D0
	JSR	_rnd

	ADD.W	#$000A,D0

	MOVE.W	D0,-(A7)
	CLR.W	-(A7)
	PEA	_nohaste(PC)
	JSR	_fuse(PC)
	ADDQ.W	#8,A7
L0086B:
	MOVEQ	#$01,D0
	BRA.B	L00869

L0086C:	dc.b	"you faint from exhaustion",0

;/*
; * aggravate:
; *  Aggravate all the monsters on this level
; */

_aggravate:
;	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	-$6CAC(A4),A2	;_mlist
	BRA.B	L0086E
L0086D:
	PEA	$000A(A2)
	JSR	_start_run	;set the monster on fire
	ADDQ.W	#4,A7
	MOVEA.L	(A2),A2		;get next monster
L0086E:
	MOVE.L	A2,D3		;check if there is one
	BNE.B	L0086D

	MOVEA.L	(A7)+,A2
;	UNLK	A5
	RTS

;/*
; * vowelstr:
; *      For printfs: if string starts with a vowel, return "n" for an
; *  "an".
; */

_vowelstr:
	MOVEA.L	$0004(A7),A6
	MOVE.B	(A6),D0
	EXT.W	D0

	SUB.w	#$0041,D0	;'A'
	BEQ.B	L0086F
	SUBQ.w	#4,D0		;'E'
	BEQ.B	L0086F
	SUBQ.w	#4,D0		;'I'
	BEQ.B	L0086F
	SUBQ.w	#6,D0		;'O'
	BEQ.B	L0086F
	SUBQ.w	#6,D0		;'U'
	BEQ.B	L0086F
	SUB.w	#$000C,D0	;'a'
	BEQ.B	L0086F
	SUBQ.w	#4,D0		;'e'
	BEQ.B	L0086F
	SUBQ.w	#4,D0		;'i'
	BEQ.B	L0086F
	SUBQ.w	#6,D0		;'o'
	BEQ.B	L0086F
	SUBQ.w	#6,D0		;'u'
	BEQ.B	L0086F

	LEA	L00874(PC),A6
	BRA.B	L00870

L0086F:
	LEA	L00873(PC),A6
L00870:
	MOVE.L	A6,D0

	RTS

L00873:	dc.b	"n",0
L00874:	dc.b	0,0

;/*
; * is_current:
; *  See if the object is one of the currently used items
; */

__is_current:
	MOVEQ	#$00,D0

	MOVE.L	$0004(A7),D3
	BEQ.B	2$

	CMP.L	-$5294(A4),D3	;_cur_armor
	BEQ.B	1$
	CMP.L	-$5298(A4),D3	;_cur_weapon
	BEQ.B	1$
	CMP.L	-$5190(A4),D3	;_cur_ring_1
	BEQ.B	1$
	CMP.L	-$518C(A4),D3	;_cur_ring_2
	BNE.B	2$

1$	MOVEQ	#$01,D0
2$	RTS

_is_current:
;	LINK	A5,#-$0000
	MOVE.L	$0004(A7),-(A7)
	BSR.B	__is_current
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L0087A

	PEA	L0087B(PC)	;"That's already in use"
	JSR	_msg
	ADDQ.W	#4,A7
	MOVEQ	#$01,D0
L00879:
;	UNLK	A5
L0087A:
	RTS

L0087B:	dc.b	"That's already in use",0

;/*
; * get_dir:
; *      Set up the direction co_ordinate for use in varios "prefix"
; *  commands
; */

_get_dir:
;	LINK	A5,#-$0002
	MOVEM.L	D4/A2,-(A7)

	TST.B	-$66F7(A4)	;_again
	BEQ.B	L0087D

	MOVEQ	#$01,D0
L0087C:
	MOVEM.L	(A7)+,D4/A2
;	UNLK	A5
	RTS

L0087D:
	PEA	L00882(PC)	;"which direction? "
	JSR	_msg
	ADDQ.W	#4,A7
L0087E:
	JSR	_readchar
	MOVE.W	D0,D4
	CMP.W	#$001B,D0	;escape
	BNE.B	L0087F

	PEA	L00883(PC)	;"",0
	JSR	_msg
	ADDQ.W	#4,A7
	MOVEQ	#$00,D0
	BRA.B	L0087C
L0087F:
	PEA	-$608C(A4)	;_delta + 0
	MOVE.W	D4,-(A7)
	BSR.B	_find_dir
	ADDQ.W	#6,A7
	TST.W	D0
	BEQ.B	L0087E

	PEA	L00884(PC)	;"",0
	JSR	_msg
	ADDQ.W	#4,A7
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISHUH,D3	;C_ISHUH
	BEQ.B	L00881

	MOVEq	#$0005,D0
	JSR	_rnd
	TST.W	D0
	BNE.B	L00881
L00880:
	MOVEq	#$0003,D0
	JSR	_rnd
	SUBQ.W	#1,D0
	MOVE.W	D0,-$608A(A4)	;_delta + 2

	MOVEq	#$0003,D0
	JSR	_rnd
	SUBQ.W	#1,D0
	MOVE.W	D0,-$608C(A4)	;_delta + 0

	TST.W	-$608A(A4)	;_delta + 2
	BNE.B	L00881

	TST.W	-$608C(A4)	;_delta + 0
	BEQ.B	L00880
L00881:
	MOVEQ	#$01,D0
	BRA.W	L0087C

L00882:	dc.b	"which direction? ",0
L00883:	dc.b	$00
L00884:	dc.b	$00

_find_dir:
	LINK	A5,#-$0002

	MOVE.B	#$01,-$0001(A5)
	MOVEQ	#$00,D0
	MOVE.B	$0009(A5),D0
	MOVEA.L	$000A(A5),A6
	BRA.W	L0088E
L00885:
	MOVE.W	#$FFFF,(A6)+
	CLR.W	(A6)
	BRA.W	L0088F
L00886:
	CLR.W	(A6)+
	MOVE.W	#$0001,(A6)
	BRA.W	L0088F
L00887:
	CLR.W	(A6)+
	MOVE.W	#$FFFF,(A6)
	BRA.W	L0088F
L00888:
	MOVE.W	#$0001,(A6)+
	CLR.W	(A6)
	BRA.W	L0088F
L00889:
	MOVE.W	#$FFFF,(A6)+
	MOVE.W	#$FFFF,(A6)
	BRA.W	L0088F
L0088A:
	MOVE.W	#$0001,(A6)+
	MOVE.W	#$FFFF,(A6)
	BRA.W	L0088F
L0088B:
	MOVE.W	#$FFFF,(A6)+
	MOVE.W	#$0001,(A6)
	BRA.B	L0088F
L0088C:
	MOVE.W	#$0001,(A6)+
	MOVE.W	#$0001,(A6)
	BRA.B	L0088F
L0088E:
	bclr	#5,d0	;easy way to make all uppercase

	SUB.w	#$0042,D0	;'B'
	BEQ.B	L0088B
	SUBQ.w	#6,D0		;'H'
	BEQ.W	L00885
	SUBQ.w	#2,D0		;'J'
	BEQ.W	L00886
	SUBQ.w	#1,D0		;'K'
	BEQ.W	L00887
	SUBQ.w	#1,D0		;'L'
	BEQ.W	L00888
	SUBQ.w	#2,D0		;'N'
	BEQ.B	L0088C
	SUBQ.w	#7,D0		;'U'
	BEQ.B	L0088A
	SUBQ.w	#4,D0		;'Y'
	BEQ.W	L00889

	CLR.B	-$0001(A5)
L0088F:
	MOVEQ	#$00,D0
	MOVE.B	-$0001(A5),D0
	UNLK	A5
	RTS

;/*
; * sign:
; *  Return the sign of the number
; */

_sign:
	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)
	MOVE.W	$0008(A5),D4
;	CMP.W	#$0000,D4
	BGE.B	L00891
	MOVEQ	#-$01,D0
L00890:
	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

L00891:
	CMP.W	#$0000,D4
	BLE.B	L00892

	MOVEq	#$0001,D0
	BRA.B	L00890
L00892:
	CLR.W	D0
	BRA.B	L00890

;/*
; * spread:
; *  Give a spread around a given number (+/- 10%)
; */

_spread:
	MOVE.L	D4,-(A7)

	MOVE.W	D0,D4
	MOVE.W	D4,D0
	EXT.L	D0
	DIVU.W	#$0005,D0
	JSR	_rnd
	MOVE.W	D4,D3
	EXT.L	D3
	DIVU.W	#$000A,D3
	SUB.W	D3,D4
	ADD.W	D4,D0

	MOVE.L	(A7)+,D4
	RTS

;/*
; * call_it:
; *  Call an object something after use.
; */

_call_it:
	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)
	MOVE.B	$0009(A5),D4
	TST.B	D4
	BEQ.B	L00894
	MOVEA.L	$000A(A5),A6
	TST.B	(A6)
	BEQ.B	L00894
	MOVEA.L	$000A(A5),A6
	CLR.B	(A6)
	BRA.B	L00896
L00894:
	TST.B	D4
	BNE.B	L00896
	MOVEA.L	$000A(A5),A6
	MOVE.B	(A6),D3
	EXT.W	D3
;	TST.W	D3
	BNE.B	L00896

	LEA	L00898(PC),a0	;"what do you want to "
	JSR	_noterse

	MOVE.L	D0,-(A7)
	PEA	L00897(PC)	;"%scall it? "
	JSR	_msg
	ADDQ.W	#8,A7
	MOVE.W	#$0014,-(A7)
	MOVE.L	-$5258(A4),-(A7)	;_prbuf
	JSR	_getinfo
	ADDQ.W	#6,A7
	MOVEA.L	-$5258(A4),A6	;_prbuf
	MOVE.B	(A6),D3
;	EXT.W	D3
	CMP.b	#$1B,D3		;escape
	BEQ.B	L00895
	MOVE.L	-$5258(A4),-(A7)	;_prbuf
	MOVE.L	$000A(A5),-(A7)
	JSR	_strcpy
	ADDQ.W	#8,A7
L00895:
	PEA	L00899(PC)
	JSR	_msg
	ADDQ.W	#4,A7
L00896:
	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

L00897:	dc.b	"%scall it? ",0
L00898:	dc.b	"what do you want to ",0
L00899:	dc.b	0

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
	MOVEA.L	-$51AC(A4),A6	;_e_levels
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

;/*
; * dist:
; *  Calculate the "distance" between to points.  Actually,
; *  this calculates d^2, not d, but that's good enough for
; *  our purposes, since it's only used comparitively.
; */

_DISTANCE:
;	LINK	A5,#-$0000

	MOVE.W	$0006(A7),D3
	SUB.W	$000A(A7),D3
	MOVE.W	$0004(A7),D0
	SUB.W	$0008(A7),D0
	MULU.W	D3,D3
	MULU.W	D0,D0
	ADD.W	D3,D0

;	UNLK	A5
	RTS

__ce:
	LINK	A5,#-$0000
	MOVEA.L	$0008(A5),A6
	MOVEA.L	$000C(A5),A1
	MOVE.W	(A6),D3
	CMP.W	(A1),D3
	BNE.B	L008BA
	MOVEA.L	$0008(A5),A6
	MOVEA.L	$000C(A5),A1
	MOVE.W	$0002(A6),D3
	CMP.W	$0002(A1),D3
	BNE.B	L008BA
	MOVEq	#$0001,D0
	BRA.B	L008BB
L008BA:
	CLR.W	D0
L008BB:
	UNLK	A5
	RTS

_INDEXplayer:
	MOVE.W	-$60BC(A4),D0	;_maxrow
	SUBQ.W	#1,D0
	MULU.W	-$52C0(A4),D0
	ADD.W	-$52BE(A4),D0
	SUBQ.W	#1,D0
	RTS

_INDEXquick:
	MOVE.W	-$60BC(A4),D2	;_maxrow
	SUBQ.W	#1,D2
	MULU.W	D2,D0
	ADD.W	D1,D0
	SUBQ.W	#1,D0
	RTS

;x_INDEX:
;	LINK	A5,#-$0000

;	MOVE.W	-$60BC(A4),D0	;_maxrow
;	SUBQ.W	#1,D0
;	MULU.W	$0006(A7),D0
;	ADD.W	$0004(A7),D0
;	SUBQ.W	#1,D0

;	UNLK	A5
;	RTS

_offmap:
	CMPI.W	#$0001,$0004(A7)
	BLT.B	L008BC

	MOVE.W	$0004(A7),D3
	CMP.W	-$60BC(A4),D3	;_maxrow
	BGE.B	L008BC

	MOVE.W	$0006(A7),D3
	BLT.B	L008BC

	CMPI.W	#$003C,D3	;'<'
	BLT.B	L008BD
L008BC:
	MOVEq	#$0001,D0
	BRA.B	L008BE
L008BD:
	CLR.W	D0
L008BE:
	RTS

_winat:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVE.W	$000A(A5),d1
	MOVE.W	$0008(A5),d0
	JSR	_moatquick

	TST.L	D0
	BEQ.B	L008C0

	MOVEA.L	D0,A2
	MOVEQ	#$00,D0
	MOVE.B	$0010(A2),D0
L008BF:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L008C0:
	MOVE.W	$000A(A5),d0
	MOVE.W	$0008(A5),d1
	BSR.B	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	MOVE.W	D3,D0
	BRA.B	L008BF

;/*
; * search:
; *  player gropes about him to find hidden things.
; */

_search:
;	LINK	A5,#-$0000
	MOVEM.L	D4-D7/A2,-(A7)

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BEQ.B	L008C2
L008C1:
	MOVEM.L	(A7)+,D4-D7/A2
;	UNLK	A5
	RTS

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
	ADDA.L	-$5198(A4),A2	;__flags
	MOVE.B	(A2),D3
	AND.W	#$0010,D3
	BNE.W	L008C9

	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	MOVE.L	D3,D0
	BRA.W	L008C8
L008C6:
	MOVEq	#$0005,D0	;20% chance to find something in the wall
	JSR	_rnd
	TST.W	D0
	BNE.W	L008C9

	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	#$2B,$00(A6,D0.W)	;'+' DOOR
	ORI.B	#$10,(A2)
	CLR.B	-$66B6(A4)	;_running
	CLR.W	-$60A4(A4)	;_count
	BRA.W	L008C9
L008C7:
	MOVEq	#$0002,D0	;50% chance to find something on the floor
	JSR	_rnd
	TST.W	D0
	BNE.W	L008C9

	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	(A2),D3
	AND.W	#$0007,D3
	ADD.W	#$000E,D3
	MOVE.B	D3,$00(A6,D0.W)
	ORI.B	#$10,(A2)
	CLR.B	-$66B6(A4)	;_running
	CLR.W	-$60A4(A4)	;_count
	MOVE.B	(A2),D3
	AND.W	#$0007,D3

	MOVE.W	D3,-(A7)
	JSR	_tr_name(PC)
	ADDQ.W	#2,A7

	MOVE.L	D0,-(A7)
	PEA	L008CC(PC)	;"you found %s"
	JSR	_msg
	ADDQ.W	#8,A7

	BRA.B	L008C9
L008C8:
	SUB.w	#$002D,D0	;'-' WALL
	BEQ.W	L008C6
	SUBQ.w	#1,D0		;'.' FLOOR
	BEQ.B	L008C7
	SUB.w	#$000E,D0	;'<' WALL CORNER
	BEQ.W	L008C6
	SUBQ.w	#2,D0		;'>' WALL CORNER
	BEQ.W	L008C6
	SUB.w	#$003D,D0	;'{' WALL CORNER
	BEQ.W	L008C6
	SUBQ.w	#1,D0		;'|' WALL
	BEQ.W	L008C6
	SUBQ.w	#1,D0		;'}' WALL CORNER
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

	BRA.W	L008C1

L008CC:	dc.b	"you found %s",0,0

;/*
; * d_level:
; *  He wants to go down a level
; */

_d_level:
;	LINK	A5,#-$0000

	JSR	_INDEXplayer

	MOVEA.L	-$519C(A4),A6	;__level
	cmp.b	#'%',$00(A6,D0.W)	;'%'
	BEQ.B	1$

	PEA	L008CF(PC)	;"I see no way down"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	2$
1$
	ADDQ.W	#1,-$60B4(A4)	;_level
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

	MOVEA.L	-$519C(A4),A6	;__level
	cmp.b	#'%',$00(A6,D0.W)	;'%'
	BNE.B	L008D3

	TST.B	-$66BD(A4)	;_amulet
	BEQ.B	L008D1

	SUBQ.W	#1,-$60B4(A4)	;_level
;	TST.W	-$60B4(A4)	;_level
	BNE.B	L008D0

	JSR	_total_winner(PC)
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
	LEA	-$6308(A4),A6	;_r_guess
	MOVE.L	A6,-$0004(A5)
	LEA	-$66D9(A4),A6	;_r_know
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
	LEA	-$5254(A4),A6	;_r_stones
	MOVE.L	$00(A6,D3.w),-$0008(A5)
L008DB:
	BRA.W	L008E4
L008DC:
	LEA	-$642E(A4),A6	;_p_guess
	MOVE.L	A6,-$0004(A5)
	LEA	-$66E7(A4),A6	;_p_know
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
	LEA	-$5290(A4),A6	;_p_colors
	MOVE.L	$00(A6,D3.w),-$0008(A5)
L008DD:
	BRA.W	L008E4
L008DE:
	LEA	-$656A(A4),A6	;_s_guess
	MOVE.L	A6,-$0004(A5)
	LEA	-$66F6(A4),A6	;_s_know
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
	LEA	-$66A6(A4),A6	;_s_names
	ADD.L	A6,D3
	MOVE.L	D3,-$0008(A5)
L008DF:
	BRA.B	L008E4
L008E0:
	LEA	-$61E2(A4),A6	;_ws_guess
	MOVE.L	A6,-$0004(A5)
	LEA	-$66CB(A4),A6	;_ws_know
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
	LEA	-$51E4(A4),A6	;_ws_made
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
	MOVE.L	-$5258(A4),-(A7)	;_prbuf
	JSR	_getinfo
	ADDQ.W	#6,A7
	MOVEA.L	-$5258(A4),A6	;_prbuf
	TST.B	(A6)
	BEQ.B	L008E7

	MOVEA.L	-$5258(A4),A6	;_prbuf
	MOVE.B	(A6),D3
;	EXT.W	D3
	CMP.b	#$1B,D3		;escape
	BEQ.B	L008E7

	MOVE.L	-$5258(A4),-(A7)	;_prbuf
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

_is_dark:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	$0008(A5),A2	;get the room
	MOVE.W	$000E(A2),D3	;get the room flags
	AND.W	#$0006,D3	;check for ISGONE + ISMAZE
	BEQ.B	L008F4

	MOVEQ	#$01,D0
L008F3:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L008F4:
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISFOUND,D3	;C_ISFOUND
	BEQ.B	L008F5

	MOVEQ	#$00,D0
	BRA.B	L008F3
L008F5:
	MOVE.W	$000E(A2),D0
	AND.W	#$0001,D0	;ISDARK?
	BRA.B	L008F3

; check wisdom for potion of discernment

_check_wisdom:
	LINK	A5,#-$0002
	MOVEM.L	A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_WISDOM,D3	;C_WISDOM
	BNE.B	L008F8

	MOVEQ	#$00,D0
L008F7:
	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

L008F8:
	CMPI.W	#$003F,$000A(A2)	;'?'
	BNE.B	L008F9

	CMPI.W	#$0006,$0020(A2)	;scroll of scare monster
	BNE.B	L008F9

	LEA	L008FC(PC),A3	;"You have mixed feelings about this object."
	BRA.B	L008FB
L008F9:
	MOVE.L	A2,-(A7)
	JSR	_goodch(PC)
	ADDQ.W	#4,A7
	CMP.W	#$002B,D0	;'+' check for a 'positive' item
	BEQ.B	L008FA

	MOVEQ	#$00,D0
	BRA.B	L008F7
L008FA:
	LEA	L008FD(PC),A3	"You have a bad feeling about this object."
L008FB:
	MOVE.L	A3,-(A7)
	JSR	_warning(PC)
	ADDQ.W	#4,A7
	MOVE.W	D0,-$0002(A5)
	MOVE.W	-$0002(A5),D0
	BRA.B	L008F7

L008FC:	dc.b	"You have mixed feelings about this object.",0
L008FD:	dc.b	"You have a bad feeling about this object.",0,0

_blank_spot:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5/A2,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVEQ	#$00,D4
L008FE:
	MOVE.L	A2,-(A7)
	JSR	_rnd_room
	MULU.W	#66,D0
	LEA	-$6088(A4),A6	;_rooms
	ADD.L	A6,D0
	MOVE.L	D0,-(A7)
	JSR	_rnd_pos
	ADDQ.W	#8,A7

	MOVE.W	(A2),d0
	MOVE.W	$0002(A2),d1
	JSR	_INDEXquick

	MOVE.W	D0,D5
	MOVE.W	D4,D3
	ADDQ.W	#1,D4
	CMP.W	#100,D3
	BLE.B	L008FF

	MOVEQ	#$00,D4
	JSR	_srand(PC)
L008FF:
	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	$00(A6,D5.W),D3
	CMP.b	#'.',D3		:FLOOR
	BEQ.B	L00900

;	MOVEA.L	-$519C(A4),A6	;__level
;	MOVE.B	$00(A6,D5.W),D3
	CMP.b	#'#',D3		;PASSAGE
	BNE.B	L008FE
L00900:
	MOVE.W	D5,D0

	MOVEM.L	(A7)+,D4/D5/A2
	UNLK	A5
	RTS

;/*
; * do_rooms:
; *  Create rooms and corridors with a connectivity graph
; */

_do_rooms:
	LINK	A5,#-$001C
	MOVEM.L	D4/D5/A2,-(A7)

	MOVE.W	-$60BC(A4),D3	;_maxrow
	ADDQ.W	#1,D3
	MOVE.W	D3,-$0016(A5)
	MOVE.W	-$60B4(A4),-$0014(A5)	;_level
	MOVE.W	#$0014,-$000E(A5)
	MOVE.W	-$0016(A5),D3
	EXT.L	D3
	DIVS.W	#$0003,D3
	MOVE.W	D3,-$000C(A5)
	LEA	-$6088(A4),A6	;_rooms
	MOVE.L	A6,-$0004(A5)
L00901:
	MOVEA.L	-$0004(A5),A6
	CLR.W	$000E(A6)
	CLR.W	$0010(A6)
	CLR.W	$000C(A6)
	ADDI.L	#$00000042,-$0004(A5)
	LEA	-$5E36(A4),A6	;_passages
	MOVEA.L	-$0004(A5),A1
	CMPA.L	A6,A1
	BCS.B	L00901

	MOVEq	#$0004,D0
	JSR	_rnd
	MOVE.W	D0,D4
	BRA.B	L00903
L00902:
	JSR	_rnd_room
	MOVE.W	D0,D5
	MULU.W	#$0042,D0
	LEA	-$6088(A4),A6	;_rooms
	ADD.L	A6,D0
	MOVE.L	D0,-$0004(A5)
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$000E(A6),D3
	AND.W	#$0004,D3
	BNE.B	L00902

;	MOVEA.L	-$0004(A5),A6
	ORI.W	#$0002,$000E(A6)
	CMP.W	#$0002,D5
	BLE.B	L00903

	CMP.W	#$0006,D5
	BGE.B	L00903

	CMPI.W	#$000A,-$60B4(A4)	;_level
	BLE.B	L00903

	MOVEq	#$0008,D0
	JSR	_rnd
	MOVE.W	-$60B4(A4),D3	;_level
	SUB.W	#$0009,D3
	CMP.W	D3,D0
	BGE.B	L00903

	MOVEA.L	-$0004(A5),A6
	ORI.W	#$0004,$000E(A6)
L00903:
	DBRA	D4,L00902

	MOVEQ	#$00,D4
	LEA	-$6088(A4),A6	;_rooms
	MOVE.L	A6,-$0004(A5)
	BRA.W	L00913
L00905:
	MOVE.W	D4,D3
	EXT.L	D3
	DIVS.W	#$0003,D3
	SWAP	D3
	MULU.W	-$000E(A5),D3
	ADDQ.W	#1,D3
	MOVE.W	D3,-$000A(A5)
	MOVE.W	D4,D3
	EXT.L	D3
	DIVS.W	#$0003,D3
	MULU.W	-$000C(A5),D3
	MOVE.W	D3,-$0008(A5)
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$000E(A6),D3
	AND.W	#$0002,D3
	BEQ.W	L00908

;	MOVEA.L	-$0004(A5),A6
	MOVE.W	$000E(A6),D3
	AND.W	#$0004,D3
	BEQ.B	L00906

;	MOVEA.L	-$0004(A5),A6
	MOVE.W	-$000A(A5),(A6)
;	MOVEA.L	-$0004(A5),A6
	MOVE.W	-$0008(A5),$0002(A6)
	MOVE.L	-$0004(A5),-(A7)
	JSR	_draw_maze(PC)
	ADDQ.W	#4,A7
	BRA.B	L00907
L00906:
	MOVE.W	-$000E(A5),D3
	SUBQ.W	#2,D3

	MOVE.W	D3,D0
	JSR	_rnd
	ADD.W	-$000A(A5),D0

	MOVEA.L	-$0004(A5),A6
	ADDQ.W	#1,D0
	MOVE.W	D0,(A6)
	MOVE.L	A6,-(A7)
	MOVE.W	-$000C(A5),D3
	SUBQ.W	#2,D3

	MOVE.W	D3,D0
	JSR	_rnd
	ADD.W	-$0008(A5),D0
	MOVEA.L	(A7)+,A6
	ADDQ.W	#1,D0
	MOVE.W	D0,$0002(A6)
	MOVEA.L	-$0004(A5),A6
	MOVE.W	#$FFC4,$0004(A6)
	MOVE.W	-$0016(A5),D3
	NEG.W	D3
	MOVE.W	D3,$0004(A6)
	MOVEA.L	-$0004(A5),A6
	CMPI.W	#$0000,$0002(A6)
	BLE.B	L00906

	MOVE.W	-$0016(A5),D3
	SUBQ.W	#1,D3
	MOVE.W	$0002(A6),D2
	CMP.W	D3,D2
	BGE.B	L00906
L00907:
	BRA.W	L00912
L00908:
	MOVEq	#$000A,D0
	JSR	_rnd
	MOVE.W	-$60B4(A4),D3	;_level
	SUBQ.W	#1,D3
	CMP.W	D3,D0
	BGE.B	L00909

	MOVEA.L	-$0004(A5),A6
	ORI.W	#$0001,$000E(A6)
L00909:
	MOVE.W	-$000E(A5),D3
	SUBQ.W	#4,D3
	MOVE.W	D3,D0
	JSR	_rnd
	ADDQ.W	#4,D0
	MOVEA.L	-$0004(A5),A6
	MOVE.W	D0,$0004(A6)

	MOVE.W	-$000C(A5),D3
	SUBQ.W	#4,D3
	MOVE.W	D3,D0
	JSR	_rnd
	ADDQ.W	#4,D0
	MOVEA.L	-$0004(A5),A6
	MOVE.W	D0,$0006(A6)

	MOVE.W	-$000E(A5),D3
	SUB.W	$0004(A6),D3
	MOVE.W	D3,D0
	JSR	_rnd
	ADD.W	-$000A(A5),D0
	MOVEA.L	-$0004(A5),A6
	MOVE.W	D0,(A6)

	MOVE.W	-$000C(A5),D3
	SUB.W	$0006(A6),D3
	MOVE.W	D3,D0
	JSR	_rnd
	ADD.W	-$0008(A5),D0
	MOVEA.L	-$0004(A5),A6
	MOVE.W	D0,$0002(A6)

	TST.W	$0002(A6)
	BEQ.W	L00909

	MOVE.L	A6,-(A7)
	JSR	_draw_room(PC)
	ADDQ.W	#4,A7
	MOVEq	#$0002,D0
	JSR	_rnd
	TST.W	D0
	BNE.W	L0090D

	TST.B	-$66BC(A4)	;_saw_amulet
	BEQ.B	L0090A

	MOVE.W	-$60B4(A4),D3	;_level
	CMP.W	-$60BA(A4),D3	;_ntraps
	BLT.W	L0090D
L0090A:
	JSR	_new_item
	MOVE.L	D0,-$001A(A5)
;	TST.L	D0
	BEQ.W	L0090D

	MOVE.W	-$60B4(A4),D0	;_level
	MULU.W	#$000A,D0
	ADD.W	#$0032,D0
	JSR	_rnd

	MOVEA.L	-$001A(A5),A6
	MOVEA.L	-$0004(A5),A1

	ADDQ.W	#2,D0
	MOVE.W	D0,$000C(A1)
	MOVE.W	D0,$0026(A6)
L0090B:
	MOVEA.L	-$0004(A5),A6
	PEA	$0008(A6)
	MOVE.L	A6,-(A7)
	JSR	_rnd_pos(PC)
	ADDQ.W	#8,A7
	MOVEA.L	-$0004(A5),A6

	MOVE.W	$0008(A6),d0
	MOVE.W	$000A(A6),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	$00(A6,D0.W),-$001B(A5)
	MOVE.B	-$001B(A5),D3
	CMP.b	#'.',D3
	BEQ.B	L0090C

;	MOVE.B	-$001B(A5),D3
	CMP.b	#'#',D3
	BEQ.B	L0090C
	BRA.B	L0090B
L0090C:
	MOVEA.L	-$001A(A5),A6
	ADDA.L	#$0000000C,A6
	MOVEA.L	-$0004(A5),A1
	ADDQ.L	#8,A1
	MOVE.L	(A1)+,(A6)+
	MOVEA.L	-$001A(A5),A6
	MOVE.W	#$0020,$0028(A6)
;	MOVEA.L	-$001A(A5),A6
	MOVE.W	#$0001,$002C(A6)
;	MOVEA.L	-$001A(A5),A6
	MOVE.W	#$002A,$000A(A6)
	MOVE.L	-$001A(A5),-(A7)
	PEA	-$6CB0(A4)	;_lvl_obj
	JSR	__attach
	ADDQ.W	#8,A7
	MOVEA.L	-$0004(A5),A6

	MOVE.W	$0008(A6),d0
	MOVE.W	$000A(A6),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	#'*',$00(A6,D0.W)
L0090D:
	MOVEq	#$0064,D0
	JSR	_rnd
	MOVEA.L	-$0004(A5),A6
	CMPI.W	#$0000,$000C(A6)
	BLE.B	L0090E

	MOVEQ	#$50,D3
	BRA.B	L0090F
L0090E:
	MOVEQ	#$19,D3
L0090F:
	CMP.W	D3,D0
	BGE.B	L00912

	JSR	_new_item
	MOVEA.L	D0,A2
	TST.L	D0
	BEQ.B	L00912
L00910:
	PEA	-$0012(A5)
	MOVE.L	-$0004(A5),-(A7)
	JSR	_rnd_pos(PC)
	ADDQ.W	#8,A7

	MOVE.W	-$0012(A5),-(A7)
	MOVE.W	-$0010(A5),-(A7)
	JSR	_winat
	ADDQ.W	#4,A7

	CMP.B	#$2E,D0		;'.' FLOOR
	BEQ.B	L00911

	CMP.B	#$23,D0		;'#' PASSAGE
	BNE.B	L00910
L00911:
	PEA	-$0012(A5)
	CLR.L	-(A7)
	JSR	_randmonster
	ADDQ.W	#4,A7

	MOVE.W	D0,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_new_monster
	LEA	$000A(A7),A7
	MOVE.L	A2,-(A7)
	JSR	_give_pack
	ADDQ.W	#4,A7
L00912:
	ADDI.L	#$00000042,-$0004(A5)
	ADDQ.W	#1,D4
L00913:
	CMP.W	#$0009,D4	;make 9 rooms
	BLT.W	L00905

	MOVEM.L	(A7)+,D4/D5/A2
	UNLK	A5
	RTS

;/*
; * draw_room:
; *  Draw a box around a room and lay down the floor for normal
; *  rooms; for maze rooms, draw maze.
; */

_draw_room:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5,-(A7)
	MOVEA.L	$0008(A5),A6
	MOVE.W	(A6),-(A7)
	MOVE.L	$0008(A5),-(A7)
	JSR	_vert(PC)
	ADDQ.W	#6,A7

	MOVEA.L	$0008(A5),A6
	MOVE.W	(A6),D3
	ADD.W	$0004(A6),D3
	SUBQ.W	#1,D3
	MOVE.W	D3,-(A7)
	MOVE.L	$0008(A5),-(A7)
	JSR	_vert(PC)
	ADDQ.W	#6,A7

	MOVEA.L	$0008(A5),A6
	MOVE.W	$0002(A6),-(A7)
	MOVE.L	$0008(A5),-(A7)
	JSR	_horiz(PC)
	ADDQ.W	#6,A7

	MOVEA.L	$0008(A5),A6
	MOVE.W	$0002(A6),D3
	ADD.W	$0006(A6),D3
	SUBQ.W	#1,D3
	MOVE.W	D3,-(A7)
	MOVE.L	$0008(A5),-(A7)
	JSR	_horiz(PC)

	ADDQ.W	#6,A7
	MOVEA.L	$0008(A5),A6

	MOVE.W	(A6),d0
	MOVE.W	$0002(A6),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	#'<',$00(A6,D0.W)
	MOVEA.L	$0008(A5),A6

	MOVE.W	(A6),D0
	ADD.W	$0004(A6),D0
	SUBQ.W	#1,D0
	MOVE.W	$0002(A6),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	#'>',$00(A6,D0.W)
	MOVEA.L	$0008(A5),A6

	MOVE.W	(A6),d0
	MOVE.W	$0002(A6),D1
	ADD.W	$0006(A6),D1
	SUBQ.W	#1,D1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	#'{',$00(A6,D0.W)
	MOVEA.L	$0008(A5),A6

	MOVE.W	(A6)+,D0
	MOVE.W	(A6)+,D1
	ADD.W	(A6)+,D0
	ADD.W	(A6)+,D1
	SUBQ.W	#1,D0
	SUBQ.W	#1,D1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	#'}',$00(A6,D0.W)
	MOVEA.L	$0008(A5),A6
	MOVE.W	$0002(A6),D4
	ADDQ.W	#1,D4
	BRA.B	L00917
L00914:
	MOVEA.L	$0008(A5),A6
	MOVE.W	(A6),D5
	ADDQ.W	#1,D5
	BRA.B	L00916
L00915:
	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	#'.',$00(A6,D0.W)
	ADDQ.W	#1,D5
L00916:
	MOVEA.L	$0008(A5),A6
	MOVE.W	(A6),D3
	ADD.W	$0004(A6),D3
	SUBQ.W	#1,D3
	CMP.W	D3,D5
	BLT.B	L00915

	ADDQ.W	#1,D4
L00917:
	MOVEA.L	$0008(A5),A6
	MOVE.W	$0002(A6),D3
	ADD.W	$0006(A6),D3
	SUBQ.W	#1,D3
	CMP.W	D3,D4
	BLT.B	L00914

	MOVEM.L	(A7)+,D4/D5
	UNLK	A5
	RTS

;/*
; * vert:
; *  Draw a vertical line
; */

_vert:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5/A2,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVE.W	$000C(A5),D4
	MOVE.W	$0002(A2),D5
	ADDQ.W	#1,D5
	BRA.B	L00919
L00918:
	MOVE.W	D4,d0
	MOVE.W	D5,d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	#'|',$00(A6,D0.W)
	ADDQ.W	#1,D5
L00919:
	MOVE.W	$0006(A2),D3
	ADD.W	$0002(A2),D3
	SUBQ.W	#1,D3
	CMP.W	D3,D5
	BLE.B	L00918

	MOVEM.L	(A7)+,D4/D5/A2
	UNLK	A5
	RTS

;/*
; * horiz:
; *  Draw a horizontal line
; */

_horiz:
	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)

	MOVEA.L	$0008(A5),A6
	MOVE.W	(A6),D4
	BRA.B	L0091B
L0091A:
	MOVE.W	D4,d0
	MOVE.W	$000C(A5),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVE.B	#'-',$00(A6,D0.W)
	ADDQ.W	#1,D4
L0091B:
	MOVEA.L	$0008(A5),A6
	MOVE.W	(A6),D3
	ADD.W	$0004(A6),D3
	SUBQ.W	#1,D3
	CMP.W	D3,D4
	BLE.B	L0091A

	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

;/*
; * rnd_pos:
; *  Pick a random spot in a room
; */

_rnd_pos:
	LINK	A5,#-$0000
	MOVEM.L	A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVEA.L	$000C(A5),A3

	MOVE.W	$0004(A2),D0
	SUBQ.W	#2,D0

	JSR	_rnd
	ADD.W	(A2),D0
	ADDQ.W	#1,D0
	MOVE.W	D0,(A3)
	MOVE.W	$0006(A2),D3
	SUBQ.W	#2,D3

	MOVE.W	D3,D0
	JSR	_rnd
	ADD.W	$0002(A2),D0
	ADDQ.W	#1,D0
	MOVE.W	D0,$0002(A3)

	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

;/*
; * enter_room:
; *  Code that is executed whenver you appear in a room
; */

_enter_room:
	LINK	A5,#-$0000
	MOVEM.L	D4-D6/A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVE.L	A2,-(A7)
	JSR	_roomin
	ADDQ.W	#4,A7
	MOVE.L	D0,-$52A0(A4)	;_player + 42 (proom)
	MOVEA.L	D0,A3
	TST.B	-$66AD(A4)	;_bailout
	BNE.B	L0091C

	MOVE.W	$000E(A3),D3
	AND.W	#$0002,D3	;ISGONE
	BEQ.B	L0091D

	MOVE.W	$000E(A3),D3
	AND.W	#$0004,D3	;ISMAZE
	BNE.B	L0091D
L0091C:
	MOVEM.L	(A7)+,D4-D6/A2/A3
	UNLK	A5
	RTS

L0091D:
	MOVE.L	A3,-(A7)
	JSR	_door_open
	ADDQ.W	#4,A7
	MOVE.L	A3,-(A7)
	JSR	_is_dark
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.W	L00925

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BNE.W	L00925

	MOVE.W	$000E(A3),D3
	AND.W	#$0004,D3	;ISMAZE
	BNE.W	L00925

	MOVE.W	$0002(A3),D4
	BRA.W	L00924
L0091E:
	MOVE.W	(A3),d1
	MOVE.W	D4,d0
	JSR	_movequick

	MOVE.W	(A3),D5
	BRA.B	L00923
L0091F:
	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_moatquick

	MOVE.L	D0,D6
;	TST.L	D6
	BEQ.B	L00920

	MOVE.L	D6,-(A7)
	JSR	_see_monst
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.B	L00921
L00920:
	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	MOVE.W	D3,-(A7)
	JSR	_addch
	ADDQ.W	#2,A7
	BRA.B	L00922
L00921:
	MOVE.L	D6,-(A7)

	MOVE.W	D5,d0
	MOVE.W	D4,d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVEA.L	(A7)+,A1
	MOVE.B	$00(A6,D0.W),$0011(A1)
	MOVEA.L	D6,A6
	MOVEQ	#$00,D3
	MOVE.B	$0010(A6),D3
	MOVE.W	D3,-(A7)
	JSR	_addch
	ADDQ.W	#2,A7
L00922:
	ADDQ.W	#1,D5
L00923:
	MOVE.W	$0004(A3),D3
	ADD.W	(A3),D3
	CMP.W	D3,D5
	BLT.B	L0091F

	ADDQ.W	#1,D4
L00924:
	MOVE.W	$0006(A3),D3
	ADD.W	$0002(A3),D3
	CMP.W	D3,D4
	BLT.W	L0091E
L00925:
	BRA.W	L0091C

;/*
; * leave_room:
; *  Code for when we exit a room
; */

_leave_room:
	LINK	A5,#-$0000
	MOVEM.L	D4-D7/A2/A3,-(A7)
	MOVEA.L	$0008(A5),A2
	MOVEA.L	-$52A0(A4),A3	;_player + 42 (proom)

	MOVE.W	(A2),d0
	MOVE.W	$0002(A2),d1
	JSR	_INDEXquick

	MOVEA.L	-$5198(A4),A6	;__flags
;	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	AND.W	#$000F,D3
	MULU.W	#66,D3
	LEA	-$5E36(A4),A6	;_passages
	ADD.L	A6,D3
	MOVE.L	D3,-$52A0(A4)	;_player + 42 (proom)

	MOVE.L	A3,-(A7)
	JSR	_is_dark
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00926

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BNE.B	L00926

	MOVEQ	#$20,D3		;' '
	BRA.B	L00927
L00926:
	MOVEQ	#$2E,D3		;'.' FLOOR
L00927:
	MOVE.B	D3,D6
	MOVE.W	$000E(A3),D3
	AND.W	#$0004,D3	;ISMAZE
	BEQ.B	L00928

	MOVEQ	#$23,D6		;'#' PASSAGE
L00928:
	MOVE.W	$0002(A3),D4
	ADDQ.W	#1,D4
	BRA.W	L00933
L00929:
	MOVE.W	(A3),D5
	ADDQ.W	#1,D5
	BRA.W	L00932
L0092A:
	MOVE.W	D5,-(A7)
	MOVE.W	D4,-(A7)
	JSR	_mvinch(PC)
	ADDQ.W	#4,A7
	MOVE.B	D0,D7
	JSR	_typech

;	EXT.L	D0
	BRA.B	L00930
L0092C:
	MOVE.B	D6,D3
	CMP.B	#$20,D3
	BNE.B	L0092D

	MOVE.W	#$0020,-(A7)
	JSR	_addch
	ADDQ.W	#2,A7
L0092D:
	BRA.B	L00931
L0092E:
	MOVE.B	D7,D0
	AND.W	#$007F,D0

	JSR	_isupper

	TST.W	D0
	BEQ.B	L0092F

	MOVE.W	D5,d1
	MOVE.W	D4,d0
	JSR	_moatquick

	MOVEA.L	D0,A6
	MOVE.B	#$22,$0011(A6)
L0092F:
	MOVEQ	#$00,D3
	MOVE.B	D6,D3
	MOVE.W	D3,-(A7)
	JSR	_addch
	ADDQ.W	#2,A7
	BRA.B	L00931
L00930:
	SUB.w	#$000E,D0	;14
	BEQ.B	L00931
	SUB.w	#$0012,D0	;' ' SPACE
	BEQ.B	L00931
	SUBQ.w	#3,D0		;'#' PASSAGE
	BEQ.B	L00931
	SUBQ.w	#2,D0		;'%' EXIT
	BEQ.B	L00931
	SUB.w	#$0009,D0	;'.' FLOOR
	BEQ.B	L0092C
	BRA.B	L0092E
L00931:
	ADDQ.W	#1,D5
L00932:
	MOVE.W	$0004(A3),D3
	ADD.W	(A3),D3
	SUBQ.W	#1,D3
	CMP.W	D3,D5
	BLT.W	L0092A

	ADDQ.W	#1,D4
L00933:
	MOVE.W	$0006(A3),D3
	ADD.W	$0002(A3),D3
	SUBQ.W	#1,D3
	CMP.W	D3,D4
	BLT.W	L00929

	MOVE.L	A3,-(A7)
	JSR	_door_open
	ADDQ.W	#4,A7

	MOVEM.L	(A7)+,D4-D7/A2/A3
	UNLK	A5
	RTS

;/*
; * fight:
; *  The player attacks the monster.
; */

_fight:
	LINK	A5,#-$0002
	MOVEM.L	D4/D5/A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVEA.L	$000E(A5),A3

	MOVE.W	(A2),d1
	MOVE.W	$0002(A2),d0
	JSR	_moatquick

	MOVE.L	D0,D4
;	TST.L	D0
	BNE.B	L00935
	MOVEQ	#$00,D0
L00934:
	MOVEM.L	(A7)+,D4/D5/A2/A3
	UNLK	A5
	RTS

L00935:
	CLR.W	-$60A0(A4)	;_quiet
	CLR.W	-$60A4(A4)	;_count
	MOVE.L	A2,-(A7)
	JSR	_start_run
	ADDQ.W	#4,A7
	MOVEA.L	D4,A6
	MOVE.B	$000F(A6),D3
	CMP.B	#$58,D3		;'X' xeroc
	BNE.B	L00937

	MOVE.B	$0010(A6),D3
	CMP.B	#$58,D3		;'X' xeroc
	BEQ.B	L00937

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BNE.B	L00937

	MOVE.B	#$58,$0010(A6)	;'X' xeroc
	MOVE.B	#$58,$000D(A5)	;'X' xeroc
	TST.B	$0013(A5)
	BEQ.B	L00936

	MOVEQ	#$00,D0
	BRA.B	L00934
L00936:
	PEA	L00944(PC)	;"wait! That's a Xeroc!"
	JSR	_msg
	ADDQ.W	#4,A7
L00937:
	MOVE.B	$000D(A5),D3
	EXT.W	D3
	SUB.W	#$0041,D3	;'A'
	MULU.W	#26,D3
	LEA	-$6CA8(A4),A6	;_monsters
	MOVE.L	$00(A6,D3.L),D5
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BEQ.B	L00938

	MOVE.L	-$69BE(A4),D5	;_it
L00938:
	MOVEQ	#$00,D3
	MOVE.B	$0013(A5),D3
	MOVE.W	D3,-(A7)
	MOVE.L	A3,-(A7)
	MOVE.L	D4,-(A7)
	PEA	-$52CA(A4)	;_player + 0
	JSR	_roll_em(PC)
	LEA	$000E(A7),A7
	TST.W	D0		;did we hit?
	BNE.B	L00939

	MOVE.L	A3,D3
	BEQ.W	L00940

	CMPI.W	#$0021,$000A(A3)	;'!' potion
	BNE.W	L00940
L00939:
	CLR.B	-$0001(A5)
	TST.B	$0013(A5)
	BEQ.B	L0093A

	PEA	L00946(PC)	;"hit"
	PEA	L00945(PC)	;"hits"
	MOVE.L	D5,-(A7)
	MOVE.L	A3,-(A7)
	JSR	_thunk(PC)
	LEA	$0010(A7),A7
	BRA.B	L0093B
L0093A:
	MOVE.L	D5,-(A7)
	CLR.L	-(A7)
	JSR	_hit(PC)
	ADDQ.W	#8,A7
L0093B:
	CMPI.W	#$0021,$000A(A3)	;'!' potions
	BNE.B	L0093C

	MOVE.L	D4,-(A7)
	MOVE.L	A3,-(A7)
	JSR	_th_effect(PC)
	ADDQ.W	#8,A7
	TST.B	$0013(A5)
	BNE.B	L0093C

	MOVE.W	#$0001,-(A7)
	MOVE.L	A3,-(A7)
	JSR	_unpack
	ADDQ.W	#6,A7
	MOVE.L	D0,-(A7)
	JSR	_discard
	ADDQ.W	#4,A7
	CLR.L	-$5298(A4)	;_cur_weapon
L0093C:
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_CANHUH,D3	;C_CANHUH
	BEQ.B	L0093D

	MOVE.B	#$01,-$0001(A5)
	MOVEA.L	D4,A6
	ORI.W	#C_ISHUH,$0016(A6)	;C_ISHUH
	ANDI.W	#~C_CANHUH,-$52B4(A4)	;clear C_CANHUH,_player + 22 (flags)
	PEA	L00947(PC)	;"your hands stop glowing red"
	JSR	_msg
	ADDQ.W	#4,A7
L0093D:
	MOVEA.L	D4,A6
	CMPI.W	#$0000,$0022(A6)	;more than 0 hp left?
	BGT.B	L0093E

	MOVE.W	#$0001,-(A7)
	MOVE.L	D4,-(A7)
	JSR	_killed(PC)
	ADDQ.W	#6,A7
	BRA.B	L0093F
L0093E:
	TST.B	-$0001(A5)
	BEQ.B	L0093F

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BNE.B	L0093F
	MOVE.L	D5,-(A7)
	PEA	L00948(PC)	;"the %s appears confused"
	JSR	_msg
	ADDQ.W	#8,A7
L0093F:
	MOVEQ	#$01,D0
	BRA.W	L00934
L00940:
	TST.B	$0013(A5)
	BEQ.B	L00941

	PEA	L0094A(PC)	;"missed"
	PEA	L00949(PC)	;"misses"
	MOVE.L	D5,-(A7)
	MOVE.L	A3,-(A7)
	JSR	_thunk(PC)
	LEA	$0010(A7),A7
	BRA.B	L00942
L00941:
	MOVE.L	D5,-(A7)
	CLR.L	-(A7)
	JSR	_miss(PC)
	ADDQ.W	#8,A7
L00942:
	MOVEA.L	D4,A6
	cmp.b	#$53,$000F(A6)	;'S' slime
	BNE.B	L00943

	MOVEq	#100,D0
	JSR	_rnd
	CMP.W	#25,D0		;25% chance that the slime splits
	BLE.B	L00943

	MOVE.L	D4,-(A7)
	JSR	_slime_split
	ADDQ.W	#4,A7
L00943:
	MOVEQ	#$00,D0
	BRA.W	L00934

L00944:	dc.b	"wait! That's a Xeroc!",0
L00945:	dc.b	"hits",0
L00946:	dc.b	"hit",0
L00947:	dc.b	"your hands stop glowing red",0
L00948:	dc.b	"the %s appears confused",0
L00949:	dc.b	"misses",0
L0094A:	dc.b	"missed",0,0

;/*
; * attack:
; *  The monster attacks the player
; */

_attack:
	LINK	A5,#-$0004
	MOVEM.L	D4/D5/A2/A3,-(A7)

	CLR.B	-$66B6(A4)	;_running
	CLR.W	-$60A0(A4)	;_quiet
	CLR.W	-$60A4(A4)	;_count

	MOVEA.L	$0008(A5),A6
	CMP.B	#$58,$000F(A6)	;'X' xerox
	BNE.B	1$

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BNE.B	1$

	MOVE.B	#$58,$0010(A6)	;'X' xerox

1$	MOVE.B	$000F(A6),D3
	EXT.W	D3
	SUB.W	#$0041,D3	;'A'
	MULU.W	#26,D3
	LEA	-$6CA8(A4),A6	;_monsters
	MOVEA.L	$00(A6,D3.L),A2
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BEQ.B	L0094C
	MOVEA.L	-$69BE(A4),A2	;_it
L0094C:
	CLR.L	-(A7)
	CLR.L	-(A7)
	PEA	-$52CA(A4)	;_player + 0
	MOVE.L	$0008(A5),-(A7)
	JSR	_roll_em(PC)
	LEA	$0010(A7),A7
	TST.W	D0
	BEQ.W	L00974

	CLR.L	-(A7)
	MOVE.L	A2,-(A7)
	JSR	_hit(PC)
	ADDQ.W	#8,A7
	CMPI.W	#$0000,-$52A8(A4)	;_player + 34 (hp)
	BGT.B	L0094D

	MOVEA.L	$0008(A5),A6
	MOVE.B	$000F(A6),D3
;	EXT.W	D3
	MOVE.W	D3,-(A7)
	JSR	_death
	ADDQ.W	#2,A7
L0094D:
	MOVEA.L	$0008(A5),A6
	MOVE.W	$0016(A6),D3
	AND.W	#C_ISCANC,D3	;C_ISCANC
	BNE.W	L00973

;	MOVEA.L	$0008(A5),A6
	MOVE.B	$000F(A6),D0
	EXT.W	D0
;	EXT.L	D0
	BRA.W	L00972

; aquator

L0094E:
	TST.L	-$5294(A4)	;_cur_armor
	BEQ.B	L00952

	MOVEA.L	-$5294(A4),A6	;_cur_armor
	CMPI.W	#$0009,$0026(A6)	;dont go lower than 2 (11-9)
	BGE.B	L00952

	CMP.W	#A_LEATHER,$0020(A6)
	BEQ.B	L00952

	TST.L	-$5190(A4)	;_cur_ring_1
	BEQ.B	L0094F

	MOVEA.L	-$5190(A4),A6	;_cur_ring_1
	CMPI.W	#R_SUSTARM,$0020(A6)
	BEQ.B	L00950
L0094F:
	TST.L	-$518C(A4)	;_cur_ring_2
	BEQ.B	L00951

	MOVEA.L	-$518C(A4),A6	;_cur_ring_2
	CMPI.W	#R_SUSTARM,$0020(A6)
	BNE.B	L00951
L00950:
	PEA	L00977(PC)	;"the rust vanishes instantly"
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L00952
L00951:
	PEA	L00978(PC)	;"your armor weakens, oh my!"
	JSR	_msg
	ADDQ.W	#4,A7
	MOVEA.L	-$5294(A4),A6	;_cur_armor
	ADDQ.W	#1,$0026(A6)	;lower is better
	MOVE.W	#$0001,-(A7)
	MOVE.L	-$5294(A4),-(A7)	;_cur_armor
	JSR	_pack_name
	ADDQ.W	#6,A7
L00952:
	BRA.W	L00973

; ice monster

L00953:
	CMPI.W	#$0001,-$60AC(A4)	;_no_command
	BLE.B	L00954

	SUBQ.W	#1,-$60AC(A4)	;_no_command
L00954:
	BRA.W	L00973

; rattlesnake

L00955:
	CLR.W	-(A7)
	JSR	_save(PC)
	ADDQ.W	#2,A7
	TST.W	D0
	BNE.B	L00959

	TST.L	-$5190(A4)	;_cur_ring_1
	BEQ.B	L00956

	MOVEA.L	-$5190(A4),A6	;_cur_ring_1
	CMPI.W	#R_SUSTSTR,$0020(A6)
	BEQ.B	L00958
L00956:
	TST.L	-$518C(A4)	;_cur_ring_2
	BEQ.B	L00957

	MOVEA.L	-$518C(A4),A6	;_cur_ring_2
	CMPI.W	#R_SUSTSTR,$0020(A6)
	BEQ.B	L00958
L00957:
	MOVE.W	#$FFFF,-(A7)
	JSR	_chg_str
	ADDQ.W	#2,A7

	LEA	L0097A(PC),a0	;" and now feel weaker"
	JSR	_noterse

	MOVE.L	D0,-(A7)
	PEA	L00979(PC)	;"you feel a bite in your leg%s"
	JSR	_msg
	ADDQ.W	#8,A7

	BRA.B	L00959
L00958:
	PEA	L0097B(PC)	;"a bite momentarily weakens you"
	JSR	_msg
	ADDQ.W	#4,A7
L00959:
	BRA.W	L00973

; vampire/wraith

L0095A:
	MOVEq	#$0064,D0
	JSR	_rnd
	MOVEA.L	$0008(A5),A6
	MOVE.B	$000F(A6),D3
;	EXT.W	D3
	CMP.b	#$57,D3		;'W' wraith
	BNE.B	L0095B

	MOVEQ	#$0F,D3		;15% chance
	BRA.B	L0095C
L0095B:
	MOVEQ	#$1E,D3		;vampire has %30 chance
L0095C:
	CMP.W	D3,D0
	BGE.W	L00964

	MOVEA.L	$0008(A5),A6
	MOVE.B	$000F(A6),D3
;	EXT.W	D3
	CMP.b	#$57,D3		;'W' wraith
	BNE.B	L00960

	TST.L	-$52B0(A4)	;_player + 26 (EXP)
	BNE.B	L0095D

	MOVE.W	#$0057,-(A7)	;'W' killed by a wraith
	JSR	_death
	ADDQ.W	#2,A7
L0095D:
	SUBQ.W	#1,-$52AC(A4)	;_player + 30 (rank)
;	TST.W	-$52AC(A4)	;_player + 30 (rank)
	BNE.B	L0095E

	CLR.L	-$52B0(A4)	;_player + 26 (EXP)
	MOVE.W	#$0001,-$52AC(A4)	;_player + 30 (rank)
	BRA.B	L0095F
L0095E:
	MOVE.W	-$52AC(A4),D3	;_player + 30 (rank)
	SUBQ.W	#1,D3
;	EXT.L	D3
	ASL.w	#2,D3
	MOVEA.L	-$51AC(A4),A6	;_e_levels
	MOVE.L	$00(A6,D3.w),D2
	ADDQ.L	#1,D2
	MOVE.L	D2,-$52B0(A4)	;_player + 26 (EXP)
L0095F:
	MOVE.W	#$000A,-(A7)	;1d10
	MOVE.W	#$0001,-(A7)
	JSR	_roll
	ADDQ.W	#4,A7
	MOVE.W	D0,D4
	BRA.B	L00961
L00960:
	MOVE.W	#$0005,-(A7)	;1d5
	MOVE.W	#$0001,-(A7)
	JSR	_roll
	ADDQ.W	#4,A7
	MOVE.W	D0,D4
L00961:
	SUB.W	D4,-$52A8(A4)	;_player + 34 (hp)
	SUB.W	D4,-$52A2(A4)	;_player + 40 (max hp)
	CMPI.W	#$0001,-$52A8(A4)	;_player + 34 (hp)
	BGE.B	L00962

	MOVE.W	#$0001,-$52A8(A4)	;_player + 34 (hp)
L00962:
	CMPI.W	#$0001,-$52A2(A4)	;_player + 40 (max hp)
	BGE.B	L00963

	MOVEA.L	$0008(A5),A6
	MOVE.B	$000F(A6),D3
;	EXT.W	D3
	MOVE.W	D3,-(A7)
	JSR	_death
	ADDQ.W	#2,A7
L00963:
	PEA	L0097C(PC)	;"you suddenly feel weaker"
	JSR	_msg
	ADDQ.W	#4,A7
L00964:
	BRA.W	L00973

; venus flytrap

L00965:
	ORI.W	#C_ISHELD,-$52B4(A4)	;C_ISHELD,_player + 22 (flags)
	ADDQ.W	#1,-$60A2(A4)	;_fung_hit
	MOVE.W	-$60A2(A4),-(A7)	;_fung_hit
	PEA	L0097D(PC)	;"%dd1"
	MOVEA.L	$0008(A5),A6
	MOVE.L	$0024(A6),-(A7)
	JSR	_sprintf
	LEA	$000A(A7),A7
	BRA.W	L00973

; leprechaun

L00966:
	move.w	-$60B2(A4),D4	;_purse

	bsr	goldcalc
	sub.w	D0,D4

	MOVE.W	#VS_MAGIC,-(A7)
	JSR	_save(PC)
	ADDQ.W	#2,A7
	TST.W	D0
	BNE.B	L00967

	bsr	goldcalc
	sub.w	D0,D4
	bsr	goldcalc
	sub.w	D0,D4
	bsr	goldcalc
	sub.w	D0,D4
	bsr	goldcalc
	sub.w	D0,D4

L00967:
;	tst.W	-$60B2(A4)	;_purse
;	BGE.B	L00968
;	CLR.W	-$60B2(A4)	;_purse

	tst.w	D4
	bge	L00968
	clr.l	D4

L00968:
	CLR.L	-(A7)
	MOVE.L	$0008(A5),-(A7)
	MOVEA.L	$0008(A5),A6
	PEA	$000A(A6)
	JSR	_remove(PC)
	LEA	$000C(A7),A7

	MOVE.W	-$60B2(A4),D3	;_purse
	CMP.w	D3,D4
	BEQ.B	L00969

	move.w	D4,-$60B2(A4)
	PEA	L0097E(PC)	;"your purse feels lighter"
	JSR	_msg
	ADDQ.W	#4,A7
L00969:
	BRA.W	L00973

; nymph

L0096A:
	LEA	L0097F(PC),A6	;"she stole %s!"
	MOVE.L	A6,-$0004(A5)
	MOVEQ	#$00,D4
	MOVEQ	#$00,D5
	MOVEA.L	-$529C(A4),A3	;_player + 46 (pack)
	BRA.B	L0096D
L0096B:
	CMPA.L	-$5294(A4),A3	;_cur_armor
	BEQ.B	L0096C
	CMPA.L	-$5298(A4),A3	;_cur_weapon
	BEQ.B	L0096C
	CMPA.L	-$5190(A4),A3	;_cur_ring_1
	BEQ.B	L0096C
	CMPA.L	-$518C(A4),A3	;_cur_ring_2
	BEQ.B	L0096C

	MOVE.L	A3,-(A7)
	JSR	_is_magic(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L0096C

	ADDQ.W	#1,D5
	MOVE.W	D5,D0
	JSR	_rnd
	TST.W	D0
	BNE.B	L0096C

	MOVE.L	A3,D4
L0096C:
	MOVEA.L	(A3),A3
L0096D:
	MOVE.L	A3,D3
	BNE.B	L0096B
	TST.L	D4
	BEQ.W	L00970

	CLR.L	-(A7)
	MOVE.L	$0008(A5),-(A7)
	MOVEA.L	$0008(A5),A6
	PEA	$000A(A6)
	JSR	_remove(PC)
	LEA	$000C(A7),A7
	MOVEA.L	D4,A6
	CMPI.W	#$0001,$001E(A6)
	BLE.B	L0096F

	MOVEA.L	D4,A6
	TST.W	$002C(A6)
	BNE.B	L0096F

	MOVE.W	#$0001,-(A7)
	MOVE.L	D4,-(A7)
	JSR	_unpack
	ADDQ.W	#6,A7
	MOVE.L	D0,D4
;	TST.L	D0
	BEQ.B	L0096E

	MOVE.W	#$001E,-(A7)
	MOVE.L	D4,-(A7)
	JSR	_nameof
	ADDQ.W	#6,A7
	MOVE.L	D0,-(A7)
	MOVE.L	-$0004(A5),-(A7)
	JSR	_msg
	ADDQ.W	#8,A7
	MOVE.L	D4,-(A7)
	JSR	_discard
	ADDQ.W	#4,A7
L0096E:
	BRA.B	L00970
L0096F:
	CLR.L	-(A7)
	MOVE.L	D4,-(A7)
	JSR	_unpack
	ADDQ.W	#8,A7
	MOVE.W	#$001E,-(A7)
	MOVE.L	D4,-(A7)
	JSR	_nameof
	ADDQ.W	#6,A7
	MOVE.L	D0,-(A7)
	MOVE.L	-$0004(A5),-(A7)
	JSR	_msg
	ADDQ.W	#8,A7
	MOVE.L	D4,-(A7)
	JSR	_discard
	ADDQ.W	#4,A7
L00970:
	BRA.B	L00973
L00972:
	SUB.w	#$0041,D0	;'A' aquator, rusts armor
	BEQ.W	L0094E
	SUBQ.w	#5,D0		;'F' venus flytrap, traps the player
	BEQ.W	L00965
	SUBQ.w	#3,D0		;'I' ice monster, shoots frost bolts
	BEQ.W	L00953
	SUBQ.w	#3,D0		;'L' leprechaun, steals money
	BEQ.W	L00966
	SUBQ.w	#2,D0		;'N' nymph, steals an item not used
	BEQ.W	L0096A
	SUBQ.w	#4,D0		;'R' rattlesnake, weakens the player
	BEQ.W	L00955
	SUBQ.w	#4,D0		;'V' vampire, drains life
	BEQ.W	L0095A
	SUBQ.w	#1,D0		;'W' wraith, drains experience
	BEQ.W	L0095A
L00973:
	BRA.B	L00976
L00974:
	MOVEA.L	$0008(A5),A6
	MOVE.B	$000F(A6),D3

	CMP.B	#$49,D3		;'I' ice monster
	BEQ.B	L00976

	CMP.B	#$46,D3		;'F' venus flytrap
	BNE.B	L00975

	MOVE.W	-$60A2(A4),D3	;_fung_hit
	SUB.W	D3,-$52A8(A4)	;_player + 34 (hp)
	CMPI.W	#$0000,-$52A8(A4)	;_player + 34 (hp)
	BGT.B	L00975

;	MOVEA.L	$0008(A5),A6
	MOVE.B	$000F(A6),D3
;	EXT.W	D3
	MOVE.W	D3,-(A7)
	JSR	_death
	ADDQ.W	#2,A7
L00975:
	CLR.L	-(A7)
	MOVE.L	A2,-(A7)
	JSR	_miss(PC)
	ADDQ.W	#8,A7
L00976:
	JSR	_flush_type
	CLR.W	-$60A4(A4)	;_count
	JSR	_status

	MOVEM.L	(A7)+,D4/D5/A2/A3
	UNLK	A5
	RTS

L00977:	dc.b	"the rust vanishes instantly",0
L00978:	dc.b	"your armor weakens, oh my!",0
L00979:	dc.b	"you feel a bite in your leg%s",0
L0097A:	dc.b	" and now feel weaker",0
L0097B:	dc.b	"a bite momentarily weakens you",0
L0097C:	dc.b	"you suddenly feel weaker",0
L0097D:	dc.b	"%dd1",0
L0097E:	dc.b	"your purse feels lighter",0
L0097F:	dc.b	"she stole %s!",0

;/*
; * swing:
; *  Returns true if the swing hits
; */

_swing:
	MOVEq	#20,D0
	JSR	_rnd

	MOVEQ	#20,D3
	SUB.W	$0004(A7),D3	;creature/player rank
	SUB.W	$0006(A7),D3	;armor
	ADD.W	$0008(A7),D0	;hplus
	CMP.W	D3,D0
	BLT.B	1$

	MOVEq	#$0001,D0
	BRA.B	2$

1$	CLR.W	D0		;zero means swing did miss

2$	RTS

;/*
; * check_level:
; *  Check to see if the guy has gone up a level.
; */

_check_level:
;	LINK	A5,#-$0000
	MOVEM.L	D4-D6,-(A7)

	MOVEQ	#$00,D4
	MOVEA.L	-$51AC(A4),A6	;_e_levels
	MOVE.L	-$52B0(A4),D3
	BRA.B	L00983
L00982:
	CMP.L	D3,D2	;_player + 26 (EXP)
	BGT.B	L00984

	ADDQ.W	#1,D4
L00983:
	MOVE.L	(A6)+,D2
	BNE.B	L00982
L00984:
	ADDQ.W	#1,D4		;level of the player
	MOVE.W	-$52AC(A4),D6	;_player + 30 (rank)
	MOVE.W	D4,-$52AC(A4)	;_player + 30 (rank)
	CMP.W	D6,D4		;compare old with new
	BLE.B	L00986

	MOVE.W	#$000A,-(A7)	;10
	MOVE.W	D4,D3
	SUB.W	D6,D3		;difference in level (mostly one)
	MOVE.W	D3,-(A7)
	JSR	_roll		;so mostly it is 1d10
	ADDQ.W	#4,A7

	MOVE.W	D0,D5
	ADD.W	D5,-$52A2(A4)	;_player + 40 (max hp)
	ADD.W	D5,-$52A8(A4)	;_player + 34 (hp)
	MOVE.W	-$52A8(A4),D3	;_player + 34 (hp)
	CMP.W	-$52A2(A4),D3	;_player + 40 (max hp)
	BLE.B	L00985

	MOVE.W	-$52A2(A4),-$52A8(A4)	;_player + 40 (max hp),_player + 34 (hp)
L00985:
	MOVE.W	D4,D3
	SUBQ.W	#1,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$6D28(A4),A6	;_he_man
	MOVE.L	$00(A6,D3.w),-(A7)
	PEA	L00987(PC)	;'and achieve the rank of "%s"'
	JSR	_msg
	ADDQ.W	#8,A7
	MOVE.W	D4,D3
	SUBQ.W	#1,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$6D28(A4),A6	;_he_man
	MOVE.L	$00(A6,D3.w),-(A7)
	JSR	_NewRank(PC)
	ADDQ.W	#4,A7
L00986:
	MOVEM.L	(A7)+,D4-D6
;	UNLK	A5
	RTS

L00987:	dc.b	'and achieve the rank of "%s"',0,0

;/*
; * roll_em:
; *  Roll several attacks
; */

_roll_em:
	LINK	A5,#-$000C
	MOVEM.L	D4-D7/A2/A3,-(A7)
	MOVEQ	#$00,D4
	MOVEA.L	$0008(A5),A2	;player
	ADDA.L	#$00000018,A2
	MOVEA.L	$000C(A5),A3	;monster
	ADDA.L	#$00000018,A3

	TST.L	$0010(A5)	;test for weapon
	BNE.B	1$

	MOVE.L	$000C(A2),-$0004(A5)
	MOVEQ	#$00,D6
	MOVEQ	#$00,D5
	BRA.W	L00994

1$	MOVEA.L	$0010(A5),A6
	MOVE.W	$0022(A6),D5	;hplus from weapon
	MOVE.W	$0024(A6),D6	;dplus from weapon

	MOVEA.L	$000C(A5),A6
	MOVE.B	$000F(A6),D3	;monster ID

	MOVEA.L	$0010(A5),A6
	MOVE.B	$002A(A6),D2
	CMP.B	D2,D3		;do we have a vorpalized monster slayer?
	BNE.B	L0098E

	MOVE.W	$0028(A6),D3
	AND.W	#O_SLAYERUSED,D3	;first time? then 100% chance
	BEQ.B	L00989

	MOVEq	#100,D0		;1% chance the monster slayer works
	JSR	_rnd
	CMP.W	#23,D0
	BNE.B	L0098D
L00989:
	MOVEA.L	$0010(A5),A6
	ORI.W	#O_SLAYERUSED,$0028(A6)	;mark as used

	TST.B	-$66B2(A4)	;_terse
	BNE.B	L0098A
	TST.B	-$66AB(A4)	;_expert
	BEQ.B	L0098B
L0098A:
	LEA	L0099F(PC),A6	; $0
	MOVE.L	A6,D3
	BRA.B	L0098C
L0098B:
	MOVE.L	-$69C6(A4),D3	;_intense
L0098C:
	MOVE.L	D3,-(A7)
	MOVEA.L	$0010(A5),A6
	MOVE.W	$0020(A6),D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$6F5C(A4),A6	;_w_names
	MOVE.L	$00(A6,D3.w),-(A7)
	MOVE.L	-$69C2(A4),-(A7)	;_flash
	JSR	_msg
	LEA	$000C(A7),A7

	ADD.W	#20,D5		;+20 hit
	ADD.W	#100,D6		;+100 damage
	BRA.B	L0098E
L0098D:
	ADDQ.W	#4,D5		;+4 hit
	ADDQ.W	#4,D6		;+4 damage
L0098E:
	MOVEA.L	$0010(A5),A6
	CMPA.L	-$5298(A4),A6	;check _cur_weapon
	BNE.B	L00992

	TST.L	-$5190(A4)	;check for _cur_ring_1
	BEQ.B	L00990

	MOVEA.L	-$5190(A4),A6	;get _cur_ring_1
	CMPI.W	#R_ADDDAM,$0020(A6)
	BNE.B	L0098F

	ADD.W	$0026(A6),D6	;add damage from ring
	BRA.B	L00990
L0098F:
	CMPI.W	#R_ADDHIT,$0020(A6)
	BNE.B	L00990

	ADD.W	$0026(A6),D5	;add hit from ring

L00990:
	TST.L	-$518C(A4)	;check for _cur_ring_2
	BEQ.B	L00992

	MOVEA.L	-$518C(A4),A6	;get _cur_ring_2
	CMPI.W	#R_ADDDAM,$0020(A6)
	BNE.B	L00991

	ADD.W	$0026(A6),D6	;add damage from ring
	BRA.B	L00992
L00991:
	CMPI.W	#R_ADDHIT,$0020(A6)
	BNE.B	L00992

	ADD.W	$0026(A6),D5	;add hit from ring
L00992:
	MOVEA.L	$0010(A5),A6
	MOVE.L	$0016(A6),-$0004(A5)	;get wield damage
	TST.B	$0015(A5)
	BEQ.B	L00993

;	MOVEA.L	$0010(A5),A6
	MOVE.W	$0028(A6),D3
	AND.W	#O_ISMISL,D3	;O_ISMISL
	BEQ.B	L00993

	TST.L	-$5298(A4)	;check _cur_weapon
	BEQ.B	L00993

;	MOVEA.L	$0010(A5),A6
	MOVE.B	$0014(A6),D3	;get baseweapon
	EXT.W	D3

	MOVEA.L	-$5298(A4),A6	;_cur_weapon
	CMP.W	$0020(A6),D3
	BNE.B	L00993

	MOVEA.L	$0010(A5),A6
	MOVE.L	$001A(A6),-$0004(A5)	;get throw damage

	MOVEA.L	-$5298(A4),A6	;_cur_weapon
	ADD.W	$0022(A6),D5	;hplus
	ADD.W	$0024(A6),D6	;dplus
L00993:
	MOVEA.L	$0010(A5),A6
	CMPI.W	#$002F,$000A(A6)	;'/' wand
	BNE.B	L00994

	CMPI.W	#WS_STRIKING,$0020(A6)
	BNE.B	L00994

	SUBQ.W	#1,$0026(A6)		;consume one charge
;	CMPI.W	#$0000,$0026(A6)
	BGE.B	L00994

	MOVE.L	-$69AE(A4),$0016(A6)	;_no_damage
	MOVE.L	$0016(A6),-$0004(A5)

	CLR.W	$0024(A6)	;0 hit
	CLR.W	$0022(A6)	;0 damage

	CLR.W	$0026(A6)
L00994:
	MOVEA.L	$000C(A5),A6
	MOVE.W	$0016(A6),D3
	AND.W	#C_ISRUN,D3	;C_ISRUN
	BNE.B	L00995
	ADDQ.W	#4,D5		;hplus += 4
L00995:
	MOVE.W	$0008(A3),-$000A(A5)
	LEA	-$52B2(A4),A6	;_player + 24 (strength)
	CMPA.L	A6,A3
	BNE.B	L00998

	TST.L	-$5294(A4)	;_cur_armor
	BEQ.B	L00996

	MOVEA.L	-$5294(A4),A6	;_cur_armor
	MOVE.W	$0026(A6),-$000A(A5)
L00996:
	TST.L	-$5190(A4)	;_cur_ring_1
	BEQ.B	L00997

	MOVEA.L	-$5190(A4),A6	;_cur_ring_1
	CMP.W	#R_PROTECT,$0020(A6)	;test for R_PROTECT
	BNE.B	L00997

	MOVE.W	$0026(A6),D3
	SUB.W	D3,-$000A(A5)	;add extra armor from ring 1
L00997:
	TST.L	-$518C(A4)	;_cur_ring_2
	BEQ.B	L00998

	MOVEA.L	-$518C(A4),A6	;_cur_ring_2
	CMP.W	#R_PROTECT,$0020(A6)	;test for R_PROTECT
	BNE.B	L00998

	MOVE.W	$0026(A6),D3	;add extra armor from ring 2
	SUB.W	D3,-$000A(A5)
L00998:
	MOVE.L	-$0004(A5),-(A7)
	JSR	_atoi(PC)
	ADDQ.W	#4,A7

	MOVE.W	D0,-$0006(A5)	;ndice

	MOVE.W	#100,-(A7)
	MOVE.L	-$0004(A5),-(A7)
	JSR	_index
	ADDQ.W	#6,A7

	MOVE.L	D0,-$0004(A5)	;cp
;	TST.L	D0
	BEQ.W	L0099E

	ADDQ.L	#1,-$0004(A5)	;cp
	MOVE.L	-$0004(A5),-(A7)
	JSR	_atoi(PC)
	ADDQ.W	#4,A7

	MOVE.W	D0,-$0008(A5)	;nsides

	MOVE.W	(A2),-(A7)
	JSR	_str_plus(PC)
	ADDQ.W	#2,A7

	ADD.W	D5,D0			;hplus += str_hit
	MOVE.W	D0,-(A7)
	MOVE.W	-$000A(A5),-(A7)	;AC
	MOVE.W	$0006(A2),-(A7)		;rank
	JSR	_swing(PC)
	ADDQ.W	#6,A7
	TST.W	D0
	BEQ.B	L0099D

	MOVE.W	-$0008(A5),-(A7)
	MOVE.W	-$0006(A5),-(A7)
	JSR	_roll
	ADDQ.W	#4,A7

	MOVE.W	D0,-$000C(A5)		;get damage from strength
	MOVE.W	(A2),-(A7)
	JSR	_add_dam(PC)
	ADDQ.W	#2,A7

	MOVEM.L	D0/D4-D6/A0-A3,-(A7)	;DEBUG here
	move.w	$000A(A3),-(a7)
	moveq	#11,d1
	sub.w	-$000A(A5),d1
	move.w	d1,-(a7)		;def_arm
	move.w	d0,-(a7)		;add_dam
	move.w	d6,-(a7)		;dplus
	move.w	-$000c(A5),-(a7)	;proll
	move.w	-$0008(A5),-(a7)	;nsides
	move.w	-$0006(A5),-(a7)	;ndice
	pea	debugtext
	jsr	_db_print
	LEA	$0012(A7),A7
	MOVEM.L	(A7)+,D0/D4-D6/A0-A3

	ADD.W	D6,D0
	MOVE.W	D0,D7
	ADD.W	-$000C(A5),D7
	LEA	-$52CA(A4),A6	;_player + 0
	CMPA.L	$000C(A5),A6	;same as creature who is fighting here?
	BNE.B	L00999

	CMPI.W	#$0001,-$60BA(A4)	;_ntraps
	BNE.B	L00999

	ADDQ.W	#1,D7		;divide damage by half, if level == 1
	EXT.L	D7
	DIVS.W	#$0002,D7
L00999:
	MOVEQ	#$00,D3
	CMP.W	D7,D3
	BLE.B	L0099B

;	MOVEQ	#$00,D3
	BRA.B	L0099C
L0099B:
	SUB.W	D7,$000A(A3)
L0099C:
	MOVEQ	#$01,D4		;did_hit = TRUE

L0099D:
	MOVE.W	#$002F,-(A7)	;'/'	;get next attack from creature/player
	MOVE.L	-$0004(A5),-(A7)
	JSR	_index
	ADDQ.W	#6,A7

	MOVE.L	D0,-$0004(A5)	;test cp for NULL
;	TST.L	D0
	BEQ.B	L0099E

	ADDQ.L	#1,-$0004(A5)	;cp++
	BRA.W	L00998
L0099E:
;	MOVEQ	#$00,D0
	MOVE.L	D4,D0		;return did_hit
	MOVEM.L	(A7)+,D4-D7/A2/A3
	UNLK	A5
	RTS

L0099F:
	dc.w	$0000

debugtext:	dc.b	"Damage for %dd%d came out %2d, dplus = %d, add_dam = %d, def_arm = %d, def_hp = %2d",10,0,0

;/*
; * prname:
; *  The print name of a combatant
; */

_prname:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVEA.L	-$51A8(A4),A6	;_tbuf
	CLR.B	(A6)
	MOVE.L	A2,D3
	BNE.B	L009A0

	MOVE.L	-$69BA(A4),-(A7)	;_you
	MOVE.L	-$51A8(A4),-(A7)	;_tbuf
	JSR	_strcpy
	ADDQ.W	#8,A7
	BRA.B	L009A2
L009A0:
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BEQ.B	L009A1

	MOVE.L	-$69BE(A4),-(A7)	;_it
	MOVE.L	-$51A8(A4),-(A7)	;_tbuf
	JSR	_strcpy
	ADDQ.W	#8,A7
	BRA.B	L009A2
L009A1:
	PEA	L009A4(PC)
	MOVE.L	-$51A8(A4),-(A7)	;_tbuf
	JSR	_strcpy
	ADDQ.W	#8,A7
	MOVE.L	A2,-(A7)
	MOVE.L	-$51A8(A4),-(A7)	;_tbuf
	JSR	_strcat
	ADDQ.W	#8,A7
L009A2:
	TST.B	$000D(A5)
	BEQ.B	L009A3

	MOVEA.L	-$51A8(A4),A6	;_tbuf
	MOVE.L	A6,-(A7)
	MOVE.B	(A6),D3
	MOVE.W	D3,-(A7)
	JSR	_toupper
	ADDQ.W	#2,A7
	MOVEA.L	(A7)+,A6
	MOVE.B	D0,(A6)
L009A3:
	MOVE.L	-$51A8(A4),D0	;_tbuf

	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L009A4:	dc.b	"the ",0,0

;/*
; * hit:
; *  Print a message to indicate a succesful hit
; */

_hit:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2/A3,-(A7)
	MOVEA.L	$0008(A5),A2
	MOVEA.L	$000C(A5),A3
	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_prname(PC)
	ADDQ.W	#6,A7
	MOVE.L	D0,-(A7)
	JSR	_addmsg
	ADDQ.W	#4,A7
	TST.B	-$66B2(A4)	;_terse
	BNE.B	L009A5
	TST.B	-$66AB(A4)	;_expert
	BEQ.B	L009A6
L009A5:
	MOVEQ	#$01,D0
	BRA.B	L009A7
L009A6:
	MOVEq	#$0004,D0
	JSR	_rnd
L009A7:
;	EXT.L	D0
	BRA.B	L009B1
L009A8:
	LEA	L009B4(PC),A6	;"scored an excellent hit on"
	BRA.B	L009B3
L009A9:
	LEA	L009B5(PC),A6	;"hit"
	BRA.B	L009B3
L009AA:
	MOVE.L	A2,D3
	BNE.B	1$
	LEA	L009B6(PC),A6	;"have injured"
	BRA.B	L009B3
1$	LEA	L009B7(PC),A6	;"has injured"
	BRA.B	L009B3

L009AD:
	MOVE.L	A2,D3
	BNE.B	1$
	LEA	L009B8(PC),A6	;"swing and hit"
	BRA.B	L009B3
1$	LEA	L009B9(PC),A6	;"swings and hits"
	BRA.B	L009B3

L009B0:
	dc.w	L009A8-L009B2	;"scored an excellent hit on"
	dc.w	L009A9-L009B2	;"hit"
	dc.w	L009AA-L009B2	;"have injured"
	dc.w	L009AD-L009B2	;"swing and hit"
L009B1:
	CMP.w	#$0004,D0
	BCC.B	L009B3
	ASL.w	#1,D0
	MOVE.W	L009B0(PC,D0.W),D0
L009B2:	JMP	L009B2(PC,D0.W)
L009B3:
	MOVE.L	A6,D4
	CLR.L	-(A7)
	MOVE.L	A3,-(A7)
	JSR	_prname(PC)
	ADDQ.W	#8,A7
	MOVE.L	D0,-(A7)
	MOVE.L	D4,-(A7)
	PEA	L009BA(PC)	;"%s %s "
	JSR	_msg
	LEA	$000C(A7),A7
	MOVEM.L	(A7)+,D4/A2/A3
	UNLK	A5
	RTS

L009B4:	dc.b	"scored an excellent hit on",0
L009B5:	dc.b	"hit",0
L009B6:	dc.b	"have injured",0
L009B7:	dc.b	"has injured",0
L009B8:	dc.b	"swing and hit",0
L009B9:	dc.b	"swings and hits",0
L009BA:	dc.b	" %s %s",0,0

;/*
; * miss:
; *  Print a message to indicate a poor swing
; */

_miss:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2/A3,-(A7)
	MOVEA.L	$0008(A5),A2
	MOVEA.L	$000C(A5),A3
	MOVE.W	#$0001,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_prname(PC)
	ADDQ.W	#6,A7
	MOVE.L	D0,-(A7)
	JSR	_addmsg
	ADDQ.W	#4,A7
	TST.B	-$66B2(A4)	;_terse
	BNE.B	L009BB
	TST.B	-$66AB(A4)	;_expert
	BEQ.B	L009BC
L009BB:
	MOVEQ	#$01,D0
	BRA.B	L009BD
L009BC:
	MOVEq	#$0004,D0
	JSR	_rnd
L009BD:
;	EXT.L	D0
	BRA.B	L009CB
L009BE:
	MOVE.L	A2,D3
	BNE.B	L009BF
	LEA	L009CE(PC),A6	;"swing and miss"
	BRA.B	L009CD
L009BF:
	LEA	L009CF(PC),A6	;"swings and misses"
	BRA.B	L009CD

L009C1:
	MOVE.L	A2,D3
	BNE.B	L009C2
	LEA	L009D0(PC),A6	;"miss"
	BRA.B	L009CD
L009C2:
	LEA	L009D1(PC),A6	;"misses"
	BRA.B	L009CD

L009C4:
	MOVE.L	A2,D3
	BNE.B	L009C5
	LEA	L009D2(PC),A6	;"barely miss"
	BRA.B	L009CD
L009C5:
	LEA	L009D3(PC),A6	;"barely misses"
	BRA.B	L009CD
L009C7:
	MOVE.L	A2,D3
	BNE.B	L009C8
	LEA	L009D4(PC),A6	;"don't hit"
	BRA.B	L009CD
L009C8:
	LEA	L009D5(PC),A6	;"doesn't hit"
	BRA.B	L009CD
L009CA:
	dc.w	L009BE-L009CC	;"swing and miss"
	dc.w	L009C1-L009CC	;"miss"
	dc.w	L009C4-L009CC	;"barely miss"
	dc.w	L009C7-L009CC	;"don't hit"
L009CB:
	CMP.w	#$0004,D0
	BCC.B	L009CD
	ASL.w	#1,D0
	MOVE.W	L009CA(PC,D0.W),D0
L009CC:	JMP	L009CC(PC,D0.W)

L009CD:	MOVE.L	A6,D4
	CLR.L	-(A7)
	MOVE.L	A3,-(A7)
	JSR	_prname(PC)
	ADDQ.W	#8,A7
	MOVE.L	D0,-(A7)
	MOVE.L	D4,-(A7)
	PEA	L009D6(PC)	;" %s %s"
	JSR	_msg
	LEA	$000C(A7),A7
	MOVEM.L	(A7)+,D4/A2/A3
	UNLK	A5
	RTS

L009CE:	dc.b	"swing and miss",0
L009CF:	dc.b	"swings and misses",0
L009D0:	dc.b	"miss",0
L009D1:	dc.b	"misses",0
L009D2:	dc.b	"barely miss",0
L009D3:	dc.b	"barely misses",0
L009D4:	dc.b	"don't hit",0
L009D5:	dc.b	"doesn't hit",0
L009D6:	dc.b	" %s %s",0

;/*
; * save_throw:
; *  See if a creature is save against something
; */

_save_throw:
	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)

	moveq	#14,D3
	ADD.W	$0008(A5),D3
	MOVEA.L	$000A(A5),A6
	MOVE.W	$001E(A6),D2	;rank of player/creature
	EXT.L	D2
	DIVS.W	#$0002,D2
	MOVE.W	D3,D4
	SUB.W	D2,D4

	MOVE.W	#20,-(A7)	;1d20
	MOVE.W	#1,-(A7)
	JSR	_roll
	ADDQ.W	#4,A7

	CMP.W	D4,D0
	BLT.B	L009D7

	MOVEq	#$0001,D0
	BRA.B	L009D8
L009D7:
	CLR.W	D0
L009D8:
	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

;/*
; * save:
; *  See if he is save against various nasty things
; */

_save:
	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)
	MOVE.W	$0008(A5),D4

	CMP.W	#VS_MAGIC,D4	;VS_MAGIC
	BNE.B	L009DA

	TST.L	-$5190(A4)	;_cur_ring_1
	BEQ.B	L009D9
	MOVEA.L	-$5190(A4),A6	;_cur_ring_1
	CMP.W	#R_PROTECT,$0020(A6)
	BNE.B	L009D9
	SUB.W	$0026(A6),D4
L009D9:
	TST.L	-$518C(A4)	;_cur_ring_2
	BEQ.B	L009DA
	MOVEA.L	-$518C(A4),A6	;_cur_ring_2
	CMP.W	#R_PROTECT,$0020(A6)
	BNE.B	L009DA
	SUB.W	$0026(A6),D4
L009DA:
	PEA	-$52CA(A4)	;_player + 0
	MOVE.W	D4,-(A7)
	JSR	_save_throw(PC)
	ADDQ.W	#6,A7

	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

;/*
; * adjustments to hit probabilities due to strength
; */

_str_plus:
;	LINK	A5,#-$0000

	MOVE.W	$0004(A7),D3
	CMP.W	#$0008,D3
	BCC.B	L009DC

	MOVE.L	D3,D0
	SUBQ.W	#7,D0
L009DB:
;	UNLK	A5
	RTS

L009DC:
	MOVEQ	#$00,D0

	CMP.W	#17,D3
	BLT.B	L009E0
	ADDQ.W	#1,D0
L009DD:
	CMP.W	#19,D3
	BLT.B	L009E0
	ADDQ.W	#1,D0
L009DE:
	CMP.W	#21,D3
	BLT.B	L009E0
	ADDQ.W	#1,D0
L009DF:
	CMP.W	#31,D3
	BLT.B	L009E0
	ADDQ.W	#1,D0
L009E0:
	BRA.B	L009DB

;/*
; * adjustments to damage done due to strength
; */

_add_dam:
;	LINK	A5,#-$0000

	MOVE.W	$0004(A7),D3
	CMP.W	#$0008,D3
	BCC.B	L009E2

	MOVE.W	D3,D0
	SUBQ.W	#7,D0
L009E1:
;	UNLK	A5
	RTS

L009E2:
	moveq	#0,d0

	CMP.W	#16,D3
	BLT.B	L009E1
	ADDQ.W	#1,D0
L009E3:
	CMP.W	#17,D3
	BLT.B	L009E1
	ADDQ.W	#1,D0
L009E4:
	CMP.W	#18,D3
	BLT.B	L009E1
	ADDQ.W	#1,D0
L009E5:
	CMP.W	#20,D3
	BLT.B	L009E1
	ADDQ.W	#1,D0
L009E6:
	CMP.W	#22,D3
	BLT.B	L009E1
	ADDQ.W	#1,D0
L009E7:
	CMP.W	#31,D3
	BLT.B	L009E1
	ADDQ.W	#1,D0
L009E8:
	BRA.B	L009E1

;/*
; * raise_level:
; *  The guy just magically went up a level.
; */

_raise_level:
;	LINK	A5,#-$0000

	MOVE.W	-$52AC(A4),D3	;_player + 30 (rank)
	SUBQ.W	#1,D3
;	EXT.L	D3
	ASL.w	#2,D3
	MOVEA.L	-$51AC(A4),A6	;_e_levels
	MOVE.L	$00(A6,D3.w),D2
	ADDQ.L	#1,D2
	MOVE.L	D2,-$52B0(A4)	;_player + 26 (EXP)
	JSR	_check_level(PC)

;	UNLK	A5
	RTS

;/*
; * thunk:
; *  A missile hits a monster
; */

_thunk:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5/A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVEA.L	$000C(A5),A3
	MOVE.L	$0010(A5),D4
	MOVE.L	$0014(A5),D5
	MOVE.L	A2,-(A7)
	JSR	_typeof
	ADDQ.W	#4,A7
	CMP.W	#$006D,D0
	BNE.B	L009E9

	MOVE.L	D4,-(A7)
	MOVE.W	$0020(A2),D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$6F5C(A4),A6	;_w_names
	MOVE.L	$00(A6,D3.w),-(A7)
	PEA	L009ED(PC)	;"the %s %s "
	JSR	_addmsg
	LEA	$000C(A7),A7
	BRA.B	L009EA
L009E9:
	MOVE.L	D5,-(A7)
	PEA	L009EE(PC)	;"you %s "
	JSR	_addmsg
	ADDQ.W	#8,A7
L009EA:
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BEQ.B	L009EB

	MOVE.L	-$69BE(A4),-(A7)	;_it
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L009EC
L009EB:
	MOVE.L	A3,-(A7)
	PEA	L009EF(PC)	;"the %s"
	JSR	_msg
	ADDQ.W	#8,A7
L009EC:
	MOVEM.L	(A7)+,D4/D5/A2/A3
	UNLK	A5
	RTS

L009ED:	dc.b	"the %s %s ",0
L009EE:	dc.b	"you %s ",0
L009EF:	dc.b	"the %s",0

;/*
; * remove_mon:
; *  Remove a monster from the screen
; */

_remove:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2/A3,-(A7)
	MOVEA.L	$0008(A5),A2
	TST.L	$000C(A5)
	BNE.B	L009F1
L009F0:
	MOVEM.L	(A7)+,D4/A2/A3
	UNLK	A5
	RTS

L009F1:
	MOVEA.L	$000C(A5),A6
	MOVEA.L	$002E(A6),A3
	BRA.B	L009F5
L009F2:
	MOVE.L	(A3),D4
	MOVEA.L	A3,A6
	ADDA.L	#$0000000C,A6
	MOVEA.L	$000C(A5),A1
	ADDA.L	#$0000000A,A1
	MOVE.L	(A1)+,(A6)+
	MOVE.L	A3,-(A7)
	MOVEA.L	$000C(A5),A6
	PEA	$002E(A6)
	JSR	__detach
	ADDQ.W	#8,A7
	TST.B	$0011(A5)
	BEQ.B	L009F3

	CLR.L	-(A7)
	MOVE.L	A3,-(A7)
	JSR	_fall
	ADDQ.W	#8,A7
	BRA.B	L009F4
L009F3:
	MOVE.L	A3,-(A7)
	JSR	_discard
	ADDQ.W	#4,A7
L009F4:
	MOVEA.L	D4,A3
L009F5:
	MOVE.L	A3,D3
	BNE.B	L009F2

	MOVE.W	(A2),d0
	MOVE.W	$0002(A2),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	CMP.b	#'#',$00(A6,D0.W)
	BNE.B	L009F6

;	JSR	_standout
L009F6:
	MOVEA.L	$000C(A5),A6
	CMP.b	#$2E,$0011(A6)	;'.' FLOOR
	BNE.B	L009F7

	MOVE.W	(A2),-(A7)
	MOVE.W	$0002(A2),-(A7)
	JSR	_cansee
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.B	L009F7

	MOVEq	#$0020,d2	;' ' SPACE
	MOVE.W	(A2),d1
	MOVE.W	$0002(A2),d0
	JSR	_mvaddchquick

	BRA.B	L009F8
L009F7:
	MOVEA.L	$000C(A5),A6
	CMP.b	#$22,$0011(A6)	;'"'
	BEQ.B	L009F8

	MOVE.B	$0011(A6),D2
	MOVE.W	(A2),d1
	MOVE.W	$0002(A2),d0
	JSR	_mvaddchquick

L009F8:
;	JSR	_standend
	MOVE.L	$000C(A5),-(A7)
	PEA	-$6CAC(A4)	;_mlist
	JSR	__detach
	ADDQ.W	#8,A7
	MOVE.L	$000C(A5),-(A7)
	JSR	_discard
	ADDQ.W	#4,A7
	BRA.W	L009F0

;/*
; * is_magic:
; *  Returns true if an object radiates magic (the nymph wants to know!)
; */

_is_magic:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)
	MOVEA.L	$0008(A5),A2
	MOVE.L	A2,-(A7)
	JSR	_typeof
	ADDQ.W	#4,A7
;	EXT.L	D0
	BRA.B	L00A01
L009F9:
	MOVE.W	$0020(A2),D3
;	EXT.L	D3
	ASL.w	#1,D3
	LEA	-$6F00(A4),A6	;_a_class
	MOVE.W	$00(A6,D3.w),D2
	CMP.W	$0026(A2),D2
	BEQ.B	L009FA

	MOVEq	#$0001,D0
	BRA.B	L009FB
L009FA:
	CLR.W	D0
L009FB:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L009FC:
	TST.W	$0022(A2)
	BNE.B	L009FD
	TST.W	$0024(A2)
	BEQ.B	L009FA
L009FD:
	MOVEq	#$0001,D0
	BRA.B	L009FB
L00A01:
	SUB.w	#$0021,D0	;'!' potions
	BEQ.B	L009FD
	SUB.w	#$000B,D0	;',' amulet of yendor
	BEQ.B	L009FD
	SUBQ.w	#3,D0		;'/' wands/staffs
	BEQ.B	L009FD
	SUB.w	#$000E,D0	;'=' rings
	BEQ.B	L009FD
	SUBQ.w	#2,D0		;'?' scrolls
	BEQ.B	L009FD
	SUB.w	#$0022,D0	;'a' armor type
	BEQ.B	L009F9
	SUB.w	#$000C,D0	;'m' weapon type
	BEQ.B	L009FC
	BRA.B	L009FA

;
; goldcalc
;

goldcalc:
	MOVE.W	-$60B4(A4),D3	;_level
	MULU.W	#$000A,D3
	ADD.W	#$0032,D3
	MOVE.W	D3,D0
	JSR	_rnd
	ADDQ.W	#2,D0
	RTS

;/*
; * killed:
; *  Called to put a monster to death
; */

_killed:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)
	MOVEA.L	$0008(A5),A6
	MOVE.L	$001A(A6),D3
	ADD.L	D3,-$52B0(A4)	;_player + 26 (EXP)
	MOVEA.L	$0008(A5),A6
	MOVE.B	$000F(A6),D0
	EXT.W	D0
;	EXT.L	D0
	BRA.W	L00A07

; killed a venus flytrap

L00A02:
	ANDI.W	#~C_ISHELD,-$52B4(A4)	;clear C_ISHELD, _player + 22 (flags)
	JSR	_f_restor
	BRA.W	L00A08

; killed a leprechaun

L00A03:
	JSR	_new_item
	MOVEA.L	D0,A2
	TST.L	D0
	BNE.B	L00A05
L00A04:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L00A05:
	MOVE.W	#$002A,$000A(A2)	;'*'

	bsr	goldcalc
	move.W	D0,D4

	MOVE.W	#VS_MAGIC,-(A7)
	JSR	_save(PC)
	ADDQ.W	#2,A7
	TST.W	D0
	BEQ.B	L00A06

	bsr	goldcalc
	ADD.W	D0,D4
	bsr	goldcalc
	ADD.W	D0,D4
	bsr	goldcalc
	ADD.W	D0,D4
	bsr	goldcalc
	ADD.W	D0,D4

L00A06:
	move.w	D4,$0026(A2)

	MOVE.L	A2,-(A7)
	MOVEA.L	$0008(A5),A6
	PEA	$002E(A6)
	JSR	__attach
	ADDQ.W	#8,A7
	BRA.B	L00A08
L00A07:
	SUB.w	#$0046,D0	;'F' Venus Flytrap
	BEQ.W	L00A02
	SUBQ.w	#6,D0		;'L' Leprechaun
	BEQ.W	L00A03
L00A08:
	MOVE.W	#$0001,-(A7)
	MOVE.L	$0008(A5),-(A7)
	MOVEA.L	$0008(A5),A6
	PEA	$000A(A6)
	JSR	_remove(PC)
	LEA	$000A(A7),A7
	TST.B	$000D(A5)
	BEQ.B	L00A0A

	PEA	L00A0B(PC)	;"you have defeated "
	JSR	_addmsg
	ADDQ.W	#4,A7
	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;C_ISBLIND
	BEQ.B	L00A09

	MOVE.L	-$69BE(A4),-(A7)	;_it
	JSR	_msg
	ADDQ.W	#4,A7
	BRA.B	L00A0A
L00A09:
	MOVEA.L	$0008(A5),A6
	MOVE.B	$000F(A6),D3
	EXT.W	D3
	SUB.W	#$0041,D3	;'A'
	MULU.W	#26,D3
	LEA	-$6CA8(A4),A6	;_monsters
	MOVE.L	$00(A6,D3.L),-(A7)
	PEA	L00A0C(PC)	;"the %s"
	JSR	_msg
	ADDQ.W	#8,A7
L00A0A:
	JSR	_check_level(PC)
	BRA.W	L00A04

L00A0B:	dc.b	"you have defeated ",0
L00A0C:	dc.b	"the %s",0

L00A0D:	dc.b	"K BHISOR LCA NYTWFP GMXVJD",0	;lvl_mons[] to generate
L00A0E:	dc.b	"KEBHISORZ CAQ YTW PUGM VJ ",0	;wand_mons[] to polymorph

;/*
; * randmonster:
; *  Pick a monster to show up.  The lower the level,
; *  the meaner the monster.
; */

_randmonster:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2,-(A7)

	TST.B	$0009(A5)	;wandering sets one here
	BEQ.B	L00A0F

	MOVEA.L	-$6992(A4),A2	;normal monster list
	BRA.B	L00A10
L00A0F:
	MOVEA.L	-$6996(A4),A2	;wandering monster list
L00A10:
	MOVEq	#$0005,D0
	JSR	_rnd
	MOVE.W	D0,-(A7)

	MOVEq	#6,D0
	JSR	_rnd

	MOVE.W	(A7)+,D4
	ADD.W	D0,D4		;0-4 + 0-5
	ADD.W	-$60B4(A4),D4	;_level
	SUBQ.W	#5,D4
	CMP.W	#$0001,D4
	BGE.B	L00A11

	MOVEq	#$0005,D0
	JSR	_rnd

	MOVE.W	D0,D4
	ADDQ.W	#1,D4
L00A11:
	CMP.W	#26,D4
	BLE.B	L00A12

; dragon has only 20% chance to appear

	MOVEq	#$0005,D0
	JSR	_rnd
	moveq	#22,D4
	ADD.W	D0,D4
L00A12:
	SUBQ.W	#1,D4
	MOVE.B	$00(A2,D4.W),D0
;	EXT.W	D0
	CMP.b	#$20,D0		;' '
	BEQ.B	L00A10

	EXT.W	D0
	MOVEM.L	(A7)+,D4/A2
	UNLK	A5
	RTS

;/*
; * new_monster:
; *  Pick a new monster and add it to the list
; */

_new_monster:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVE.B	#$01,$0008(A2)
	MOVE.W	-$60B4(A4),D4	;dungeon _level
	SUB.W	#26,D4
;	CMP.W	#$0000,D4
	BGE.B	1$

	MOVEQ	#$00,D4

1$	MOVE.L	A2,-(A7)
	PEA	-$6CAC(A4)	;_mlist
	JSR	__attach
	ADDQ.W	#8,A7

	MOVE.B	$000D(A5),$000F(A2)	; monster type ABC...
	MOVE.B	$000D(A5),$0010(A2)	; xerox puts his disguise type here
	MOVEA.L	A2,A6
	ADDA.L	#$0000000A,A6
	MOVEA.L	$000E(A5),A1
	MOVE.L	(A1)+,(A6)+
	MOVE.B	#$22,$0011(A2)	;'"'

	MOVE.L	$000E(A5),-(A7)
	JSR	_roomin
	ADDQ.W	#4,A7

	MOVE.L	D0,$002A(A2)	;room
	MOVE.B	$000F(A2),D3
	EXT.W	D3
	SUB.W	#$0041,D3	;'A'
	MULU.W	#26,D3
	LEA	-$6CA8(A4),A3	;_monsters
	ADDA.L	D3,A3
	MOVE.W	$000E(A3),D3	; number for xd8 HP
	ADD.W	D4,D3
	MOVE.W	D3,$001E(A2)	;rank

	MOVE.W	#$0008,-(A7)	;xd8
	MOVE.W	D3,-(A7)
	JSR	_roll
	ADDQ.W	#4,A7
	MOVE.W	D0,$0022(A2)	;hp
	MOVE.W	D0,$0028(A2)	;max hp
	MOVE.W	$0010(A3),D3	; AC (lower is better)
	SUB.W	D4,D3
	MOVE.W	D3,$0020(A2)	;base armor class
	MOVE.L	$0014(A3),$0024(A2)	;pointer to "1d8" or "1d8/1d8/3d10"
	MOVE.W	$0008(A3),$0018(A2)	;all monster have strength of 10
	MOVE.W	D4,D3
	MULU.W	#10,D3
	EXT.L	D3
	MOVE.L	D3,-(A7)

	MOVE.L	A2,-(A7)
	JSR	_exp_add(PC)
	ADDQ.W	#4,A7
	EXT.L	D0

	MOVE.L	(A7)+,D3
	ADD.L	D0,D3
	ADD.L	$000A(A3),D3		;add monsters EXP value
	MOVE.L	D3,$001A(A2)		;experience
	MOVE.W	$0006(A3),$0016(A2)	;copy the flags (mean,greedy...)
	MOVE.B	#$01,$000E(A2)
	CLR.L	$002E(A2)	;start with empty pack

	TST.L	-$5190(A4)	;_cur_ring_1
	BEQ.B	L00A14

	MOVEA.L	-$5190(A4),A6	;_cur_ring_1
	CMPI.W	#R_AGGR,$0020(A6)	;aggravate monster
	BEQ.B	L00A15
L00A14:
	TST.L	-$518C(A4)	;_cur_ring_2
	BEQ.B	L00A16

	MOVEA.L	-$518C(A4),A6	;_cur_ring_2
	CMPI.W	#R_AGGR,$0020(A6)	;aggravate monster
	BNE.B	L00A16
L00A15:
	MOVE.L	$000E(A5),-(A7)
	JSR	_start_run
	ADDQ.W	#4,A7
L00A16:
	MOVE.B	$000D(A5),D3
	CMP.b	#$46,D3		; 'F' flytrap
	BNE.B	1$

	LEA	-$6735(A4),A6	;_f_damage
	MOVE.L	A6,$0024(A2)

1$	CMP.b	#$58,D3		; 'X' xerox
	BNE.W	L00A26

	MOVEQ	#$08,D3
	CMPI.W	#25,-$60B4(A4)	;_level
	BLE.B	L00A18

	ADDQ.w	#$01,D3		;disguise as amulet only from level 25 onwards
L00A18:
	MOVE.W	D3,D0
	JSR	_rnd
;	EXT.L	D0
	BRA.B	L00A24
L00A1A:
	MOVE.B	#$2A,$0010(A2)	;'*' gold
	BRA.B	L00A26
L00A1B:
	MOVE.B	#$21,$0010(A2)	;'!' potion
	BRA.B	L00A26
L00A1C:
	MOVE.B	#$3F,$0010(A2)	;'?' scroll
	BRA.B	L00A26
L00A1D:
	MOVE.B	#$25,$0010(A2)	;'%' exit
	BRA.B	L00A26
L00A1E:
	MOVEq	#$000A,D0
	JSR	_rnd
	ADD.W	#$006D,D0	;m weapon type
	MOVE.B	D0,$0010(A2)
	BRA.B	L00A26
L00A1F:
	MOVEq	#$0008,D0
	JSR	_rnd
	ADD.W	#$0061,D0	;a armor type
	MOVE.B	D0,$0010(A2)
	BRA.B	L00A26
L00A20:
	MOVE.B	#$3D,$0010(A2)	;'=' ring
	BRA.B	L00A26
L00A21:
	MOVE.B	#$2F,$0010(A2)	;'/' wand/staff
	BRA.B	L00A26
L00A22:
	MOVE.B	#$2C,$0010(A2)	;',' amulet of yendor
	BRA.B	L00A26
L00A23:
	dc.w	L00A1A-L00A25	; * gold
	dc.w	L00A1B-L00A25	; ! potion
	dc.w	L00A1C-L00A25	; ? scroll
	dc.w	L00A1D-L00A25	; % exit
	dc.w	L00A1E-L00A25	; mnopqrstuv weapon
	dc.w	L00A1F-L00A25	; abcdefgh armor
	dc.w	L00A20-L00A25	; = ring
	dc.w	L00A21-L00A25	; / wand/staff
	dc.w	L00A22-L00A25	; , amulet of yendor
L00A24:
	CMP.w	#$0009,D0
	BCC.B	L00A26
	ASL.w	#1,D0
	MOVE.W	L00A23(PC,D0.W),D0
L00A25:	JMP	L00A25(PC,D0.W)
L00A26:
	MOVEM.L	(A7)+,D4/A2/A3
	UNLK	A5
	RTS

_f_restor:
;	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)
	CLR.W	-$60A2(A4)	;_fung_hit
	LEA	-$6C26(A4),A2	;venus flytrap struct
	MOVE.L	$0014(A2),-(A7)	;"%%%d0"
	PEA	-$6735(A4)	;_f_damage
	JSR	_strcpy
	ADDQ.W	#8,A7
	MOVEA.L	(A7)+,A2
;	UNLK	A5
	RTS

;/*
; * expadd:
; *  Experience to add for this monster's level/hit points
; */

_exp_add:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2,-(A7)
	MOVEA.L	$0008(A5),A2

	MOVE.W	$001E(A2),D0	;creature level

	MOVE.W	$0028(A2),D4	;maxhp
	EXT.L	D4

	CMPI.W	#$0001,D0	;lvl
	BNE.B	L00A27

	LSR.L	#3,D4		;divide by 8 if level is one
	BRA.B	L00A28
L00A27:
	DIVU.W	#6,D4		;divide by 6 otherwise
L00A28:
	CMPI.W	#9,D0		;lvl
	BLE.B	L00A29

	MULU.W	#20,D4		;from level 10 and more
	BRA.B	L00A2A
L00A29:
	CMPI.W	#6,D0		;lvl
	BLE.B	L00A2A

	MULU.W	#4,D4		;from level 6 to 9
L00A2A:
	MOVE.W	D4,D0

	MOVEM.L	(A7)+,D4/A2
	UNLK	A5
	RTS

;/*
; * wanderer:
; *  Create a new wandering monster and aim it at the player
; */

_wanderer:
	LINK	A5,#-$0004
	MOVEM.L	D4/A2/A3,-(A7)

	TST.B	-$66FA(A4)	;_no_more_fears
	BNE.B	L00A2B

	JSR	_new_item
	MOVEA.L	D0,A3
	TST.L	D0
	BNE.B	L00A2C
L00A2B:
	MOVEM.L	(A7)+,D4/A2/A3
	UNLK	A5
	RTS

L00A2C:
	JSR	_rnd_room
	MOVE.W	D0,D4
	MOVE.W	D4,D3
	MULU.W	#$0042,D3
	LEA	-$6088(A4),A6	;_rooms
	MOVEA.L	D3,A2
	ADDA.L	A6,A2
	CMPA.L	-$52A0(A4),A2	;_player + 42 (proom)
	BEQ.B	L00A2D
	PEA	-$0004(A5)
	MOVE.L	A2,-(A7)
	JSR	_rnd_pos
	ADDQ.W	#8,A7
L00A2D:
	CMPA.L	-$52A0(A4),A2	;_player + 42 (proom)
	BEQ.B	L00A2C
	MOVE.W	-$0004(A5),-(A7)
	MOVE.W	-$0002(A5),-(A7)
	JSR	_winat
	ADDQ.W	#4,A7
	MOVE.W	D0,-(A7)
	JSR	_step_ok
	ADDQ.W	#2,A7
	TST.W	D0
	BEQ.B	L00A2C
	PEA	-$0004(A5)
	MOVE.W	#$0001,-(A7)
	JSR	_randmonster(PC)
	ADDQ.W	#2,A7
	MOVE.W	D0,-(A7)
	MOVE.L	A3,-(A7)
	JSR	_new_monster(PC)
	LEA	$000A(A7),A7
	TST.B	-$66AE(A4)	;_wizard
	BEQ.B	L00A2E

	MOVE.B	$000F(A3),D3
	EXT.W	D3
	SUB.W	#$0041,D3	;'A'
	MULU.W	#26,D3
	LEA	-$6CA8(A4),A6	;_monsters
	MOVE.L	$00(A6,D3.L),-(A7)
	PEA	L00A2F(PC)	;"started a wandering %s"
	JSR	_msg
	ADDQ.W	#8,A7
L00A2E:
	PEA	$000A(A3)
	JSR	_start_run
	ADDQ.W	#4,A7
	BRA.W	L00A2B

L00A2F:	dc.b	"started a wandering %s",0,0

;/*
; * wake_monster:
; *  What to do when the hero steps next to a monster
; */

_wake_monster:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5/A2/A3,-(A7)

	MOVE.W	$000A(A5),d1
	MOVE.W	$0008(A5),d0
	JSR	_moatquick

	MOVEA.L	D0,A2
	TST.L	D0
	BNE.B	L00A31

	MOVE.L	A2,D0
L00A30:
	MOVEM.L	(A7)+,D4/D5/A2/A3
	UNLK	A5
	RTS

L00A31:
	MOVE.B	$000F(A2),D4
	MOVE.W	$0016(A2),D3
	AND.W	#C_ISRUN,D3	;C_ISRUN
	BNE.B	L00A34

	MOVEq	#$0003,D0
	JSR	_rnd
	TST.W	D0
	BEQ.B	L00A34

	MOVE.W	$0016(A2),D3
	AND.W	#C_ISMEAN,D3	;C_ISMEAN
	BEQ.B	L00A34

	MOVE.W	$0016(A2),D3
	AND.W	#C_ISHELD,D3	;C_ISHELD
	BNE.B	L00A34

	TST.L	-$5190(A4)	;_cur_ring_1
	BEQ.B	L00A32
	MOVEA.L	-$5190(A4),A6	;_cur_ring_1
	CMPI.W	#R_STEALTH,$0020(A6)	; ring of stealth
	BEQ.B	L00A34
L00A32:
	TST.L	-$518C(A4)	;_cur_ring_2
	BEQ.B	L00A33
	MOVEA.L	-$518C(A4),A6	;_cur_ring_2
	CMPI.W	#R_STEALTH,$0020(A6)	; ring of stealth
	BEQ.B	L00A34
L00A33:
	LEA	-$52C0(A4),A6	;_player + 10
	MOVE.L	A6,$0012(A2)
	ORI.W	#C_ISRUN,$0016(A2)	;C_ISRUN
L00A34:
	CMP.B	#$4D,D4		;'M' medusa
	BNE.W	L00A39

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISBLIND,D3	;we are blind, so we can't see the medusas gaze
	BNE.W	L00A39

	MOVE.W	$0016(A2),D3
	AND.W	#C_ISFOUND,D3	;she saw us already
	BNE.W	L00A39

	MOVE.W	$0016(A2),D3
	AND.W	#C_ISCANC,D3	;her abilities are canceled
	BNE.W	L00A39

	MOVE.W	$0016(A2),D3
	AND.W	#C_ISRUN,D3	;shes coming at us
	BEQ.W	L00A39

	MOVEA.L	-$52A0(A4),A3	;_player + 42 (proom)
	MOVE.W	-$52C0(A4),-(A7)	;_player + 10
	MOVE.W	-$52BE(A4),-(A7)	;_player + 12
	MOVE.W	$000A(A5),-(A7)
	MOVE.W	$0008(A5),-(A7)
	JSR	_DISTANCE
	ADDQ.W	#8,A7
	MOVE.W	D0,D5
	MOVE.L	A3,D3
	BEQ.B	L00A35

	MOVE.L	A3,-(A7)
	JSR	_is_dark
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00A36
L00A35:
	CMP.W	#$0003,D5
	BGE	L00A39
L00A36:
	ORI.W	#C_ISFOUND,$0016(A2)	;C_ISFOUND
	MOVE.W	#VS_MAGIC,-(A7)
	JSR	_save
	ADDQ.W	#2,A7
	TST.W	D0
	BNE.B	L00A39

	MOVEq	#$0014,D0
	JSR	_rnd
	MOVE.W	D0,-(A7)

	MOVEq	#$0014,D0
	JSR	_spread

	MOVE.W	(A7)+,D3
	ADD.W	D0,D3
	MOVE.W	D3,-(A7)

	MOVE.W	-$52B4(A4),D3	;_player + 22 (flags)
	AND.W	#C_ISHUH,D3	;C_ISHUH
	BEQ.B	1$

	PEA	_unconfuse(PC)
	JSR	_lengthen(PC)
	ADDQ.W	#6,A7
	BRA.B	2$

1$	CLR.W	-(A7)
	PEA	_unconfuse(PC)
	JSR	_fuse(PC)
	ADDQ.W	#8,A7
2$
	ORI.W	#C_ISHUH,-$52B4(A4)	;set C_ISHUH,_player + 22 (flags)
	PEA	L00A3C(PC)	;"the medusa's gaze has confused you"
	JSR	_msg
	ADDQ.W	#4,A7
L00A39:
	MOVE.W	$0016(A2),D3
	AND.W	#C_ISGREED,D3	;C_ISGREED
	BEQ.B	L00A3B

	MOVE.W	$0016(A2),D3
	AND.W	#C_ISRUN,D3	;C_ISRUN
	BNE.B	L00A3B

	ORI.W	#C_ISRUN,$0016(A2)	;C_ISRUN
	MOVEA.L	-$52A0(A4),A6	;_player + 42 (proom)
	TST.W	$000C(A6)
	BEQ.B	L00A3A

	MOVE.L	-$52A0(A4),D3	;_player + 42 (proom)
	ADDQ.L	#8,D3
	MOVE.L	D3,$0012(A2)
	BRA.B	L00A3B
L00A3A:
	LEA	-$52C0(A4),A6	;_player + 10
	MOVE.L	A6,$0012(A2)
L00A3B:
	MOVE.L	A2,D0
	BRA.W	L00A30

L00A3C:	dc.b	"the medusa's gaze has confused you",0,0

;/*
; * give_pack:
; *  Give a pack to a monster if it deserves one
; */

_give_pack:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)
	MOVEA.L	$0008(A5),A2
	CMPI.W	#$0053,-$60A8(A4)	;'S' with _total
	BGE.B	L00A3D

	MOVEq	#100,D0
	JSR	_rnd
	MOVE.B	$000F(A2),D3
	EXT.W	D3
	SUB.W	#$0041,D3	;'A'
	MULU.W	#26,D3
	LEA	-$6CA4(A4),A6	;_monsters + 4
	CMP.W	$00(A6,D3.L),D0
	BGE.B	L00A3D

	JSR	_new_thing(PC)
	MOVE.L	D0,-(A7)
	PEA	$002E(A2)
	JSR	__attach
	ADDQ.W	#8,A7
L00A3D:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

_pick_mons:
;	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVE.L	-$6996(A4),A0	;lvl_mons[]
	JSR	_strlenquick

	EXT.L	D0
	MOVEA.L	D0,A2
	ADDA.L	-$6996(A4),A2

1$	SUBQ.L	#1,A2
	CMPA.L	-$6996(A4),A2
	BCS.B	2$
	MOVEq	#10,D0		;10% chance monster, starting with the hardest
	JSR	_rnd
	TST.W	D0
	BNE.B	1$

2$	CMPA.L	-$6996(A4),A2	;not one match, it will be against a medusa
	BCC.B	4$
	MOVEQ	#$4D,D0		;'M' medusa

3$	MOVEA.L	(A7)+,A2
;	UNLK	A5
	RTS

4$	CMP.b	#$20,(A2)	;' '
	BNE.B	5$

	SUBA.L	-$6996(A4),A2
	ADDA.L	-$6992(A4),A2

5$	MOVE.B	(A2),D0
;	EXT.W	D0
	BRA.B	3$

_moatquick:
	MOVE.L	A2,-(A7)

	MOVEA.L	-$6CAC(A4),A2	;_mlist
	BRA.B	L00A46
L00A43:
	MOVE.W	$000A(A2),D3	;moster x pos
	CMP.W	D1,D3
	BNE.B	L00A45

	MOVE.W	$000C(A2),D3	;monster y pos
	CMP.W	D0,D3
	BNE.B	L00A45

	MOVE.L	A2,D0		;return found monster
L00A44:
	MOVE.L	(A7)+,A2
	RTS

L00A45:
	MOVEA.L	(A2),A2		;get a monster
L00A46:
	MOVE.L	A2,D3
	BNE.B	L00A43

	MOVEQ	#$00,D0		;no monster found
	BRA.B	L00A44

L00A47:	dc.b	"> Go Down Stairs",0
L00A48:	dc.b	"< Go Up Stairs",0
L00A49:	dc.b	"d Drop",0
L00A4A:	dc.b	"e Eat",0
L00A4B:	dc.b	"w Wield",0
L00A4C:	dc.b	"r Read",0
L00A4D:	dc.b	"q Quaff",0
L00A4E:	dc.b	"P Put on ring",0
L00A4F:	dc.b	"R Take ring off",0
L00A50:	dc.b	"W Put on armor",0
L00A51:	dc.b	"T Take armor off",0
L00A52:	dc.b	"t Throw",0
L00A53:	dc.b	"z Zap",0

L00A54:	dc.b	"><dewrqPRWTtz",0

L00A55:	dc.b	"About Rogue",0
L00A56:	dc.b	"Save",0
L00A57:	dc.b	"Restore",0
L00A58:	dc.b	"Quit",0

L00A59:	dc.b	"Disabled",0
L00A5A:	dc.b	"Enabled",0,0

L00A5B:	dc.b	"Off",0
L00A5C:	dc.b	"On",0

L00A5D:	dc.b	"Manual",0
L00A5E:	dc.b	"Automatic",0
L00A5F:	dc.b	"Selective",0,0

L00A60:	dc.b	"Fast Play",0
L00A61:	dc.b	"Inventory Style",0

L00A62:	dc.b	"Game",0
L00A63:	dc.b	"Options",0
L00A64:	dc.b	"Use",0
L00A65:	dc.b	"Command",0

_ctointui:
	MOVEA.L	$0008(A7),A6
	CLR.B	(A6)
	MOVE.B	#$01,$0001(A6)
	MOVE.B	#$01,$0002(A6)
	MOVE.W	$000C(A7),$0004(A6)
	CLR.W	$0006(A6)
	CLR.L	$0008(A6)
	MOVE.L	$0004(A7),$000C(A6)
	CLR.L	$0010(A6)

	MOVE.L	A6,D0
	RTS

_UseItems:
	LINK	A5,#-$001E
	TST.L	$0008(A5)
	BNE.B	L00A67

	MOVEQ	#$00,D0
L00A66:
	UNLK	A5
	RTS

L00A67:
	CLR.L	-$0008(A5)
	CLR.L	-$0004(A5)
	CLR.W	-$0016(A5)
	CLR.W	-$001C(A5)
	CLR.W	-$001A(A5)
	MOVE.L	$0008(A5),-$0010(A5)
	BRA.B	L00A6C
L00A68:
	MOVEA.L	-$0010(A5),A6
	MOVE.L	(A6),-(A7)
	JSR	_scrlen
	ADDQ.W	#4,A7

	MOVE.W	D0,-$0018(A5)
	CMP.W	-$0016(A5),D0
	BLE.B	L00A69

	MOVE.W	-$0018(A5),-$0016(A5)
L00A69:
	MOVEA.L	-$0010(A5),A6
	MOVE.W	$0004(A6),D3
;	EXT.L	D3
	AND.w	#$0004,D3
	BEQ.B	L00A6A

	MOVE.W	#$0001,-$001C(A5)
L00A6A:
	MOVEA.L	-$0010(A5),A6
	MOVE.W	$0004(A6),D3
;	EXT.L	D3
	AND.w	#$0001,D3
	BEQ.B	L00A6B

	MOVE.W	#$0001,-$001A(A5)
L00A6B:
	ADDI.L	#$00000010,-$0010(A5)
L00A6C:
	MOVEA.L	-$0010(A5),A6
	TST.L	(A6)
	BNE.B	L00A68

	moveq	#$13,D1		;19
	MULU.W	-$001A(A5),D1
	MOVE.W	D1,-$001A(A5)

	moveq	#$28,d3		;40
	MULU.W	-$001C(A5),D3
	MOVE.W	D3,-$001C(A5)

	ADD.W	D1,D3
	ADD.W	D3,-$0016(A5)

	CLR.W	-$001E(A5)
L00A6D:
	MOVEA.L	$0008(A5),A6
	TST.L	(A6)
	BEQ.W	L00A70

	MOVE.W	#$0022,-(A7)
	JSR	_malloc
	ADDQ.W	#2,A7

	MOVE.L	D0,-$000C(A5)
	TST.L	-$0004(A5)
	BEQ.B	L00A6E

	MOVEA.L	-$0004(A5),A6
	MOVE.L	-$000C(A5),(A6)
	BRA.B	L00A6F
L00A6E:
	MOVE.L	-$000C(A5),-$0008(A5)
L00A6F:
	MOVE.L	-$000C(A5),-$0004(A5)
	MOVEA.L	-$0004(A5),A6
	MOVE.W	$000C(A5),$0004(A6)
;	MOVEA.L	-$0004(A5),A6
	MOVE.W	-$001E(A5),$0006(A6)
;	MOVEA.L	-$0004(A5),A6
	MOVE.W	-$0016(A5),$0008(A6)
;	MOVEA.L	-$0004(A5),A6
	MOVE.W	#$0008,$000A(A6)
;	MOVEA.L	-$0004(A5),A6
	MOVEA.L	$0008(A5),A1
	MOVE.W	$0004(A1),D3
	EXT.L	D3
	OR.L	#$00000052,D3
	MOVE.W	D3,$000C(A6)
;	MOVEA.L	-$0004(A5),A6
	MOVEA.L	$0008(A5),A1
	MOVE.L	$0008(A1),$000E(A6)
	MOVE.W	#$0014,-(A7)
	JSR	_malloc
	ADDQ.W	#2,A7
	MOVE.L	D0,-$0014(A5)
	MOVE.W	-$001A(A5),-(A7)
	MOVE.L	-$0014(A5),-(A7)
	MOVEA.L	$0008(A5),A6
	MOVE.L	(A6),-(A7)
	JSR	_ctointui(PC)
	LEA	$000A(A7),A7
	MOVEA.L	-$0004(A5),A6
	MOVE.L	-$0014(A5),$0012(A6)
;	MOVEA.L	-$0004(A5),A6
	CLR.L	$0016(A6)
;	MOVEA.L	-$0004(A5),A6
	MOVEA.L	$0008(A5),A1
	MOVE.B	$0006(A1),$001A(A6)
;	MOVEA.L	-$0004(A5),A6
	MOVE.L	A6,-(A7)
;	MOVEA.L	-$0004(A5),A6
	MOVE.W	$0008(A6),D3
	SUBQ.W	#1,D3
	SUB.W	-$001C(A5),D3
	MOVE.W	D3,-(A7)
	MOVEA.L	$0008(A5),A6
	MOVE.L	$000C(A6),-(A7)
	JSR	_UseItems(PC)
	ADDQ.W	#6,A7
	MOVEA.L	(A7)+,A6
	MOVE.L	D0,$001C(A6)
	MOVEA.L	-$0004(A5),A6
	CLR.W	$0020(A6)
	ADDQ.W	#8,-$001E(A5)
	ADDI.L	#$00000010,$0008(A5)
	BRA.W	L00A6D
L00A70:
	MOVEA.L	-$0004(A5),A6
	CLR.L	(A6)
	MOVE.L	-$0008(A5),D0
	BRA.W	L00A66

_BuildMenu:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5/A2/A3,-(A7)
	SUBA.L	A3,A3
	MOVEA.L	A3,A2
	MOVEQ	#$00,D5
L00A71:
	MOVEA.L	$0008(A5),A6
	TST.L	(A6)
	BEQ.B	L00A74
	MOVE.W	#$001E,-(A7)
	JSR	_malloc
	ADDQ.W	#2,A7
	MOVE.L	D0,D4
	MOVE.L	A2,D3
	BEQ.B	L00A72
	MOVE.L	D4,(A2)
	BRA.B	L00A73
L00A72:
	MOVEA.L	D4,A3
L00A73:
	MOVEA.L	D4,A2
	MOVE.W	#$0001,$000C(A2)
	MOVEA.L	$0008(A5),A6
	MOVE.L	(A6),$000E(A2)
;	MOVEA.L	$0008(A5),A6
	MOVE.L	$0006(A6),-(A7)
	JSR	_UseItems(PC)
	ADDQ.W	#4,A7
	MOVE.L	D0,$0012(A2)
	MOVE.W	D5,$0004(A2)
	MOVEA.L	$0008(A5),A6
	MOVE.L	(A6),-(A7)
	JSR	_scrlen
	ADDQ.W	#4,A7
	ADD.W	#$0014,D0
	MOVE.W	D0,$0008(A2)
	CLR.W	$0006(A2)
	MOVE.W	#$000A,$000A(A2)
	ADD.W	$0008(A2),D5
	ADDI.L	#$0000000A,$0008(A5)
	BRA.B	L00A71
L00A74:
	CLR.L	(A2)
	MOVE.L	A3,D0
	MOVEM.L	(A7)+,D4/D5/A2/A3
	UNLK	A5
	RTS

_InstallMenus:
;	LINK	A5,#-$0000

	PEA	-$678A(A4)	;_menu_bar
	JSR	_BuildMenu(PC)
	ADDQ.W	#4,A7
	MOVE.L	D0,-$53A2(A4)

	MOVE.L	-$53A2(A4),-(A7)
	MOVE.L	-$5148(A4),-(A7)	;_RogueWin
	JSR	_SetMenuStrip(PC)
	ADDQ.W	#8,A7

;	UNLK	A5
	RTS

_DoMenu:
	LINK	A5,#-$0000
	MOVEM.L	D4-D6/A2/A3,-(A7)
	MOVE.L	$0008(A5),D4
	SUBA.L	A2,A2
	MOVEQ	#$00,D6
	MOVEA.L	-$53A2(A4),A3
L00A75:
	MOVE.L	D4,D5
	MOVE.L	#$0000FFFF,D4
	MOVE.L	D5,-(A7)
	MOVE.L	A3,-(A7)
	JSR	_ItemAddress(PC)
	ADDQ.W	#8,A7
	MOVEA.L	D0,A2
	MOVE.L	D5,D0
	AND.w	#$001F,D0
	BRA.W	L00A88
L00A76:
	MOVE.L	D5,D0
	ASR.w	#5,D0
	AND.w	#$003F,D0
	BRA.B	L00A7C
L00A77:
	JSR	_about_rogue(PC)
	BRA.B	L00A7E
L00A78:
	JSR	_save_game
	BRA.B	L00A7E
L00A79:
	JSR	_restore_game(PC)
	SUBA.L	A2,A2
	BRA.B	L00A7E
L00A7A:
	JSR	_quit(PC)
	BRA.B	L00A7E
L00A7B:
	dc.w	L00A77-L00A7D	;about
	dc.w	L00A78-L00A7D	;save game
	dc.w	L00A79-L00A7D	;restore game
	dc.w	L00A7A-L00A7D	;quit
L00A7C:
	CMP.w	#$0004,D0
	BCC.B	L00A7E
	ASL.w	#1,D0
	MOVE.W	L00A7B(PC,D0.W),D0
L00A7D:	JMP	L00A7D(PC,D0.W)
L00A7E:
	BRA.W	L00A8A
L00A7F:
	MOVE.L	D5,D0
	ASR.w	#5,D0
	AND.w	#$003F,D0
	BRA.B	L00A82
L00A80:
	MOVEQ	#$0B,D2
	ASR.L	D2,D5
	AND.B	#$1F,D5
	MOVE.B	D5,-$66B9(A4)	;_faststate
	BRA.B	L00A8A
L00A81:
	MOVEQ	#$0B,D2
	ASR.L	D2,D5
	AND.B	#$1F,D5
	MOVE.B	D5,-$66AA(A4)	;_menu_style
	BRA.B	L00A8A
L00A82:
	TST.w	D0
	BEQ.B	L00A80
	SUBQ.w	#1,D0
	BEQ.B	L00A81
	BRA.B	L00A8A
L00A84:
	PEA	L00A8C(PC)	;"",0
	JSR	_msg
	ADDQ.W	#4,A7

	MOVE.L	D5,D3
	ASR.L	#5,D3
	AND.w	#$003F,D3
	ASL.w	#2,D3
	LEA	-$539A(A4),A6
	MOVE.L	$00(A6,D3.w),-(A7)
	JSR	_use_obj(PC)
	ADDQ.W	#4,A7
	MOVEQ	#$7F,D6
	BRA.B	L00A8A
L00A85:
	MOVE.L	D5,D3
	ASR.L	#5,D3
	AND.w	#$003F,D3
	MOVEA.L	-$68AE(A4),A6
	MOVE.B	$00(A6,D3.w),D2
	EXT.W	D2
	MOVE.W	D2,D6
	BRA.B	L00A8A
L00A87:
	dc.w	L00A76-L00A89	;Game menu
	dc.w	L00A7F-L00A89	;Options Menu
	dc.w	L00A84-L00A89	;Use menu
	dc.w	L00A85-L00A89	;Command menu
L00A88:
	CMP.w	#$0004,D0
	BCC.B	L00A86
	ASL.w	#1,D0
	MOVE.W	L00A87(PC,D0.W),D0
L00A89:	JMP	L00A89(PC,D0.W)
L00A86:
	SUBA.L	A2,A2
L00A8A:
	MOVE.L	A2,D3
	BEQ.B	L00A8B
	MOVEQ	#$00,D3
	MOVE.W	$0020(A2),D3
	MOVE.L	D3,D4
L00A8B:
	CMP.L	#$0000FFFF,D4
	BNE.W	L00A75
	MOVE.W	D6,D0

	MOVEM.L	(A7)+,D4-D6/A2/A3
	UNLK	A5
	RTS

L00A8C:	dc.w	$0000

_want_a_menu:
	LINK	A5,#-$000A
	MOVEM.L	D4-D7/A2/A3,-(A7)

	MOVE.L	-$53A2(A4),-$0006(A5)
	BRA.B	L00A8E
L00A8D:
	MOVEA.L	-$0006(A5),A6
	MOVE.L	(A6),-$0006(A5)
L00A8E:
	TST.L	-$0006(A5)
	BEQ.B	L00A8F

	PEA	L00A9B(PC)	;"Use"
	MOVEA.L	-$0006(A5),A6
	MOVE.L	$000E(A6),-(A7)
	JSR	_strcmp
	ADDQ.W	#8,A7

	TST.W	D0
	BNE.B	L00A8D
L00A8F:
	TST.L	-$0006(A5)
	BNE.B	L00A91
L00A90:
	MOVEM.L	(A7)+,D4-D7/A2/A3
	UNLK	A5
	RTS

L00A91:
	MOVE.L	-$5148(A4),-(A7)	;_RogueWin
	JSR	_ClearMenuStrip
	ADDQ.W	#4,A7
	MOVEA.L	-$0006(A5),A6
	MOVEA.L	$0012(A6),A2
	BRA.B	L00A93
L00A92:
	MOVEA.L	(A2),A3
	MOVEA.L	$0012(A2),A6
	MOVE.L	$000C(A6),-(A7)
	JSR	_free
	ADDQ.W	#4,A7
	MOVE.L	$0012(A2),-(A7)
	JSR	_free
	ADDQ.W	#4,A7
	MOVE.L	A2,-(A7)
	JSR	_free
	ADDQ.W	#4,A7
	MOVEA.L	A3,A2
L00A93:
	MOVE.L	A2,D3
	BNE.B	L00A92

	MOVEQ	#$00,D6
	MOVE.W	D6,D7
	MOVE.W	D6,-$0002(A5)
	MOVE.L	-$529C(A4),-$000A(A5)	;_player + 46 (pack)
	BRA.W	L00A98
L00A94:
	MOVE.W	-$0002(A5),D3
	ADDQ.W	#1,-$0002(A5)
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$539A(A4),A6
	MOVE.L	-$000A(A5),$00(A6,D3.w)

	MOVE.W	#$0022,-(A7)
	JSR	_malloc
	ADDQ.W	#2,A7

	MOVEA.L	D0,A3
	MOVE.L	A2,D3
	BEQ.B	L00A95

	MOVE.L	A3,(A2)
	BRA.B	L00A96
L00A95:
	MOVEA.L	-$0006(A5),A6
	MOVE.L	A3,$0012(A6)
L00A96:
	MOVEA.L	A3,A2
	CLR.W	$0004(A2)
	MOVE.W	D6,$0006(A2)
	MOVEA.L	-$000A(A5),A6
	MOVE.L	$0010(A6),-(A7)
	JSR	_scrlen
	ADDQ.W	#4,A7
	MOVE.W	D0,$0008(A2)
	MOVE.W	$0008(A2),D3
	CMP.W	D7,D3
	BLE.B	L00A97

	MOVE.W	$0008(A2),D7
L00A97:
	MOVE.W	#$0008,$000A(A2)
	MOVE.W	#$0052,$000C(A2)
	CLR.L	$000E(A2)

	MOVE.W	#$0014,-(A7)
	JSR	_malloc
	ADDQ.W	#2,A7

	MOVE.L	D0,D5
	CLR.W	-(A7)
	MOVE.L	D5,-(A7)
	MOVEA.L	-$000A(A5),A6
	MOVE.L	$0010(A6),-(A7)
	MOVE.L	$0010(A6),A0
	JSR	_strlenquick

	ADDQ.W	#1,D0

	MOVE.W	D0,-(A7)
	JSR	_malloc
	ADDQ.W	#2,A7

	MOVE.L	D0,-(A7)
	JSR	_strcpy
	ADDQ.W	#8,A7
	MOVE.L	D0,-(A7)
	JSR	_ctointui(PC)
	LEA	$000A(A7),A7
	MOVE.L	D5,$0012(A2)
	CLR.L	$0016(A2)
	CLR.B	$001A(A2)
	CLR.L	$001C(A2)
	CLR.W	$0020(A2)
	ADDQ.W	#8,D6
	MOVEA.L	-$000A(A5),A6
	MOVE.L	(A6),-$000A(A5)
L00A98:
	TST.L	-$000A(A5)
	BNE.W	L00A94

	CLR.L	(A2)
	MOVEA.L	-$0006(A5),A6
	MOVEA.L	$0012(A6),A2
	BRA.B	L00A9A
L00A99:
	MOVE.W	D7,$0008(A2)
	MOVEA.L	(A2),A2
L00A9A:
	MOVE.L	A2,D3
	BNE.B	L00A99
	MOVE.L	-$53A2(A4),-(A7)
	MOVE.L	-$5148(A4),-(A7)	;_RogueWin
	JSR	_SetMenuStrip(PC)
	ADDQ.W	#8,A7
	BRA.W	L00A90

L00A9B:	dc.b	"Use",0

_use_obj:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVE.L	A2,-(A7)
	JSR	_typeof
	ADDQ.W	#4,A7

;	EXT.L	D0
	BRA	L00AA9
L00A9C:
	JSR	_get_dir(PC)
	TST.W	D0
	BEQ.B	L00A9D

	MOVE.L	A2,-(A7)
	JSR	_do_zap
	ADDQ.W	#4,A7
L00A9D:
	BRA.W	L00AAA
L00A9E:
	MOVE.L	A2,-(A7)
	JSR	_eat(PC)
	ADDQ.W	#4,A7
	BRA.W	L00AAA
L00A9F:
	MOVE.L	A2,-(A7)
	JSR	_quaff
	ADDQ.W	#4,A7
	BRA.W	L00AAA
L00AA0:
	MOVE.L	A2,-(A7)
	JSR	_read_scroll
	ADDQ.W	#4,A7
	BRA.B	L00AAA
L00AA1:
	MOVE.L	A2,-(A7)
	JSR	_wield(PC)
	ADDQ.W	#4,A7
	BRA.B	L00AAA
L00AA2:
	CMPA.L	-$5294(A4),A2	;_cur_armor
	BNE.B	L00AA3
	JSR	_take_off
	BRA.B	L00AA4
L00AA3:
	MOVE.L	A2,-(A7)
	JSR	_wear
	ADDQ.W	#4,A7
L00AA4:
	BRA.B	L00AAA
L00AA5:
	MOVEA.L	-$5190(A4),A6	;_cur_ring_1
	CMPA.L	A2,A6
	BEQ.B	L00AA6

	MOVEA.L	-$518C(A4),A6	;_cur_ring_2
	CMPA.L	A2,A6
	BNE.B	L00AA7
L00AA6:
	MOVE.L	A2,-(A7)
	JSR	_ring_off(PC)
	ADDQ.W	#4,A7
	BRA.B	L00AA8
L00AA7:
	MOVE.L	A2,-(A7)
	JSR	_ring_on(PC)
	ADDQ.W	#4,A7
L00AA8:
	BRA.B	L00AAA
L00AA9:
	SUB.w	#$0021,D0	;'!' potions
	BEQ.B	L00A9F
	SUB.w	#$000E,D0	;'/' wand/staff
	BEQ.W	L00A9C
	SUB.w	#$000B,D0	;':' food
	BEQ	L00A9E
	SUBQ.w	#3,D0		;'=' rings
	BEQ.B	L00AA5
	SUBQ.w	#2,D0		;'?' scrolls
	BEQ.B	L00AA0
	SUB.w	#$0022,D0	;'a' armor type
	BEQ.B	L00AA2
	SUB.w	#$000C,D0	;'m' weapon type
	BEQ.B	L00AA1
L00AAA:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

_fix_menu:
	LINK	A5,#-$0000

	MOVE.L	-$5148(A4),-(A7)	;_RogueWin
	JSR	_ClearMenuStrip
	ADDQ.W	#4,A7

	MOVEQ	#$00,D3
	MOVE.B	-$66B9(A4),D3	;_faststate
	MOVE.W	D3,-(A7)
	CLR.W	-(A7)
	MOVE.W	#$0001,-(A7)
	BSR.B	_SetCheck
	ADDQ.W	#6,A7

	MOVEQ	#$00,D3
	MOVE.B	-$66AA(A4),D3	;_menu_style
	MOVE.W	D3,-(A7)
	MOVE.W	#$0001,-(A7)
	MOVE.W	#$0001,-(A7)
	BSR.B	_SetCheck
	ADDQ.W	#6,A7

	MOVE.L	-$53A2(A4),-(A7)
	MOVE.L	-$5148(A4),-(A7)	;_RogueWin
	JSR	_SetMenuStrip(PC)
	ADDQ.W	#8,A7

	UNLK	A5
	RTS

_SetCheck:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	moveq	#$0000001F,D3
	AND.W	$0008(A5),D3
	moveq	#$0000003F,D2
	AND.W	$000A(A5),D2
	ASL.L	#5,D2
	OR.L	D2,D3

	MOVE.L	D3,-(A7)
	MOVE.L	-$53A2(A4),-(A7)
	JSR	_ItemAddress(PC)
	ADDQ.W	#8,A7

	MOVEA.L	D0,A2
	MOVEQ	#$00,D2
	MOVE.W	$000C(A5),D1
L00AAB:
	MOVE.L	A2,D3
	BEQ.B	L00AAE

	CMP.W	D1,D2
	BNE.B	L00AAC

	ORI.W	#$0100,$000C(A2)
	BRA.B	L00AAD
L00AAC:
	ANDI.W	#$FEFF,$000C(A2)
L00AAD:
	ADDQ.W	#1,D2
	MOVEA.L	(A2),A2
	BRA.B	L00AAB
L00AAE:
	MOVE.L	(A7)+,A2
	UNLK	A5
	RTS

_about_rogue:
;	LINK	A5,#-$0000
	JSR	_wtext
	JSR	_black_out
	CLR.L	-(A7)
	MOVE.L	-$5144(A4),-(A7)	;_TextWin
	PEA	L00AAF(PC)	; "Credits"
	JSR	_show_ilbm
	LEA	$000C(A7),A7
	JSR	_flush_type
	JSR	_readchar
	JSR	_clear
	CLR.L	-(A7)
	PEA	-$705E(A4)	;_my_palette
	JSR	_fade_in
	ADDQ.W	#8,A7
	JSR	_wmap
;	UNLK	A5
	RTS

L00AAF:	dc.b	"Credits.lz4",0

_mouse_go:
	LINK	A5,#-$0000
	MOVE.W	$0008(A5),-$533A(A4)
	MOVE.W	$000A(A5),-$5338(A4)
	ST	-$66AF(A4)	;_mouse_run
	MOVE.W	-$5338(A4),-(A7)
	MOVE.W	-$533A(A4),-(A7)
	BSR.B	_mouse_dir
	ADDQ.W	#4,A7
	UNLK	A5
	RTS

_mouse_adjust:
;	LINK	A5,#-$0000
	MOVE.W	-$533C(A4),D3
	CMP.W	-$52C0(A4),D3	;_player + 10
	BNE.B	L00AB0
	MOVE.W	-$533E(A4),D3
	CMP.W	-$52BE(A4),D3	;_player + 12
	BNE.B	L00AB0
	CLR.B	-$66B6(A4)	;_running
	CLR.B	-$66AF(A4)	;_mouse_run
L00AB0:
	MOVE.W	-$5338(A4),-(A7)
	MOVE.W	-$533A(A4),-(A7)
	BSR.B	_mouse_dir
	ADDQ.W	#4,A7
;	UNLK	A5
	RTS

_mouse_dir:
	LINK	A5,#-$0002
	MOVEM.L	D4-D7/A2/A3,-(A7)

	MOVE.W	-$52C0(A4),d1	;_player + 10
	MOVE.W	-$52BE(A4),d0	;_player + 12
	JSR	_movequick

	MOVE.W	-$5152(A4),D4	;_p_col
	ADDQ.W	#5,D4
	MOVE.W	-$5154(A4),D5	;_p_row
	ADDQ.W	#4,D5
	MOVE.W	$000A(A5),D6
	SUB.W	D4,D6
	MOVE.W	$0008(A5),D7
	SUB.W	D5,D7
	MOVE.W	#$0005,-$0002(A5)
L00AB1:
	MOVE.W	D6,D3
	EXT.L	D3
	DIVS.W	-$0002(A5),D3

	MOVE.W	D3,-(A7)
	JSR	_sign
	ADDQ.W	#2,A7

	MOVEA.W	D0,A2
	MOVE.W	D7,D3
	EXT.L	D3
	DIVS.W	-$0002(A5),D3

	MOVE.W	D3,-(A7)
	JSR	_sign
	ADDQ.W	#2,A7

	MOVEA.W	D0,A3
	MOVE.W	A2,D3
	BNE.B	L00AB2

	MOVE.W	A3,D3
	BNE.B	L00AB2

	ASR.W	-$0002(A5)
	CMPI.W	#$0002,-$0002(A5)
	BGT.B	L00AB1
L00AB2:
	MOVE.W	A2,D3
	BNE.B	L00AB3

	MOVE.W	A3,D3
	BNE.B	L00AB3

	MOVEA.W	#$0001,A2
L00AB3:
	MOVE.W	$000A(A5),D3
	EXT.L	D3
	DIVU.W	#$000A,D3
	MOVE.W	D3,-$533C(A4)

	MOVE.W	$0008(A5),D3
	EXT.L	D3
	DIVU.W	#$0009,D3
	MOVE.W	D3,-$533E(A4)

	MOVE.W	A2,-(A7)
	MOVE.W	A3,-(A7)
	BSR.B	_mouse_char
	ADDQ.W	#4,A7

	MOVEM.L	(A7)+,D4-D7/A2/A3
	UNLK	A5
	RTS

_mouse_char:
	LINK	A5,#-$0006
	MOVEM.L	D4-D7/A2/A3,-(A7)

	MOVE.W	$0008(A5),D4
	MOVE.W	$000A(A5),D5
	MOVE.W	-$52C0(A4),D3	;_player + 10
	ADD.W	D5,D3
	MOVE.W	D3,-(A7)
	MOVE.W	-$52BE(A4),D3	;_player + 12
	ADD.W	D4,D3
	MOVE.W	D3,-(A7)
	JSR	_one_step(PC)
	ADDQ.W	#4,A7
	TST.W	D0
	BNE.W	L00AB8

	MOVE.W	-$533C(A4),-(A7)
	MOVE.W	-$533E(A4),-(A7)
	MOVE.W	-$52C0(A4),-(A7)	;_player + 10
	MOVE.W	-$52BE(A4),-(A7)	;_player + 12
	JSR	_DISTANCE
	ADDQ.W	#8,A7
	MOVEA.W	D0,A2
	MOVE.W	D0,-$0002(A5)
	MOVEQ	#-$01,D6
L00AB4:
	MOVEQ	#-$01,D7
L00AB5:
	TST.W	D7
	BNE.B	L00AB6

	TST.W	D6
	BEQ.B	L00AB7
L00AB6:
	MOVE.W	-$52C0(A4),D3	;_player + 10
	ADD.W	D6,D3
	MOVE.W	D3,-(A7)
	MOVE.W	-$52BE(A4),D3	;_player + 12
	ADD.W	D7,D3
	MOVE.W	D3,-(A7)
	BSR.B	_one_step
	ADDQ.W	#4,A7
	TST.W	D0
	BEQ.B	L00AB7

	MOVE.W	-$533C(A4),-(A7)
	MOVE.W	-$533E(A4),-(A7)
	MOVE.W	-$52C0(A4),D3	;_player + 10
	ADD.W	D6,D3
	MOVE.W	D3,-(A7)
	MOVE.W	-$52BE(A4),D3	;_player + 12
	ADD.W	D7,D3
	MOVE.W	D3,-(A7)
	JSR	_DISTANCE
	ADDQ.W	#8,A7
	MOVEA.W	D0,A3
	CMPA.W	A2,A3
	BGE.B	L00AB7

	MOVE.W	D7,-$0006(A5)
	MOVE.W	D6,-$0004(A5)
	MOVEA.W	A3,A2
L00AB7:
	ADDQ.W	#1,D7
	CMP.W	#$0001,D7
	BLE.B	L00AB5

	ADDQ.W	#1,D6
	CMP.W	#$0001,D6
	BLE.B	L00AB4

	CMPA.W	-$0002(A5),A2
	BGE.B	L00AB8

	MOVE.W	-$0006(A5),D4
	MOVE.W	-$0004(A5),D5
L00AB8:
	ADDQ.W	#1,D4
	MULU.W	#$0003,D4
	ADDQ.W	#1,D5
	ADD.w	D5,D4
	LEA	-$6758(A4),A6	;_mvt "ykuhllbjn"
	MOVE.B	$00(A6,D4.w),D0
	EXT.W	D0

	MOVEM.L	(A7)+,D4-D7/A2/A3
	UNLK	A5
	RTS

_one_step:
	LINK	A5,#-$0004

	MOVE.W	$000A(A5),d0
	MOVE.W	$0008(A5),d1
	JSR	_INDEXquick

	MOVEA.L	-$519C(A4),A6	;__level
	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	MOVE.W	D3,-(A7)
	JSR	_step_ok
	ADDQ.W	#2,A7
	TST.W	D0
	BNE.B	L00ABA

	MOVEQ	#$00,D0
L00AB9:
	UNLK	A5
	RTS

L00ABA:
	MOVE.W	$0008(A5),-$0002(A5)
	MOVE.W	$000A(A5),-$0004(A5)
	PEA	-$0004(A5)
	PEA	-$52C0(A4)	;_player + 10
	JSR	_diag_ok
	ADDQ.W	#8,A7
	BRA.B	L00AB9

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
	MOVE.L	-$5258(A4),-$5336(A4)	;_prbuf
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
	LEA	-$656A(A4),A6	;_s_guess
	TST.B	$00(A6,D3.L)
	BEQ.B	L00ABD

	MOVE.W	D5,D3
	MULU.W	#21,D3
;	LEA	-$656A(A4),A6	;_s_guess
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
	LEA	-$642E(A4),A6	;_p_guess
	TST.B	$00(A6,D3.L)
	BEQ.B	L00AC3

	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$5290(A4),A6	;_p_colors
	MOVE.L	$00(A6,D3.w),-(A7)
	MOVE.W	D5,D3
	MULU.W	#21,D3
	LEA	-$642E(A4),A6	;_p_guess
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

	MOVE.L	-$5258(A4),-$5336(A4)	;_prbuf
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

	MOVE.W	$0028(A2),D3	;monster slayer already used?
	AND.W	#O_SPECKNOWN,D3
	BEQ.B	L00AD2

	MOVE.B	$002A(A2),D3
	EXT.W	D3
	SUB.W	#$0041,D3	;'A'
	MULU.W	#26,D3
	LEA	-$6CA8(A4),A6	;_monsters
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
	LEA	-$61E2(A4),A6	;_ws_guess
	TST.B	$00(A6,D3.L)
	BEQ.B	L00ADC

	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$51E4(A4),A6	;_ws_made
	MOVE.L	$00(A6,D3.w),-(A7)
	MOVE.W	D5,D3
	MULU.W	#21,D3
	LEA	-$61E2(A4),A6	;_ws_guess
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
	LEA	-$6308(A4),A6	;_r_guess
	TST.B	$00(A6,D3.L)
	BEQ.B	L00AE7

	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$5254(A4),A6	;_r_stones
	MOVE.L	$00(A6,D3.w),-(A7)
	MOVE.W	D5,D3
	MULU.W	#21,D3
	LEA	-$6308(A4),A6	;_r_guess
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

	CMPA.L	-$5294(A4),A2	;_cur_armor
	BNE.B	L00AEC

	PEA	L00B0D(PC)	;"(being worn)"
	JSR	_nmadd
	ADDQ.W	#4,A7
L00AEC:
	CMPA.L	-$5298(A4),A2	;_cur_weapon
	BNE.B	L00AED

	PEA	L00B0E(PC)	;"(weapon in hand)"
	JSR	_nmadd
	ADDQ.W	#4,A7
L00AED:
	CMPA.L	-$5190(A4),A2	;_cur_ring_1
	BNE.B	L00AEE

	PEA	L00B0F(PC)	;"(on left hand)"
	JSR	_nmadd
	ADDQ.W	#4,A7
	BRA.B	L00AEF
L00AEE:
	CMPA.L	-$518C(A4),A2	;_cur_ring_2
	BNE.B	L00AEF

	PEA	L00B10(PC)	;"(on right hand)"
	JSR	_nmadd
	ADDQ.W	#4,A7
L00AEF:
	MOVE.W	D4,D3
	AND.W	#$0020,D3	;should we capitalize the word
	BNE.B	L00AF0

	MOVEA.L	-$5258(A4),A6	;_prbuf
	MOVE.B	(A6),D0
	JSR	_isupper

	TST.W	D0
	BEQ.B	L00AF0

	MOVEA.L	-$5258(A4),A6	;_prbuf
	MOVE.L	A6,-(A7)
	MOVEA.L	-$5258(A4),A6	;_prbuf
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

	MOVEA.L	-$5258(A4),A6	;_prbuf
	MOVE.B	(A6),D0
	JSR	_islower

	TST.W	D0
	BEQ.B	L00AF1

	MOVEA.L	-$5258(A4),A6	;_prbuf
	MOVE.L	A6,-(A7)
	MOVEA.L	-$5258(A4),A6	;_prbuf
	MOVE.B	(A6),D3
	MOVE.W	D3,-(A7)
	JSR	_toupper
	ADDQ.W	#2,A7

	MOVEA.L	(A7)+,A6
	MOVE.B	D0,(A6)
L00AF1:
	MOVE.L	-$5258(A4),D0	;_prbuf
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

_nmadd:
	LINK	A5,#-$0000

	MOVEA.L	-$5336(A4),A6
	CMPA.L	-$5258(A4),A6	;_prbuf
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
	AND.W	#$0010,D3	;O_ISMISL or O_ISMANY ???
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

lz4_frame_error:
;	illegal
	PEA	blub1(PC)	;"lz4_frame_error"
	JSR	_db_print
	ADDQ.W	#4,A7
	MOVEQ	#-$01,D0

	BRA	L00B1A

blub1:	dc.b	"lz4_frame_error",10,0,0

lz4_frame_depack:
	cmpi.l	#$04224d18,(a0)+	; LZ4 frame MagicNb
	bne.s	lz4_frame_error

	move.b	(a0),d0
	andi.b	#%11000001,d0		; check version, no depacked size, and no DictID
	cmpi.b	#%01000000,d0
	bne.s	lz4_frame_error

	btst	#3,(a0)	;skip 8 bytes if content-size bit is set
	beq	1$
	addq.l	#8,a0

1$	; read 32bits block size without movep (little endian)
	; even faster byte order reversal

	move.b	4(a0),d0	;0004
	swap	d0		;0400	4
	move.b	6(a0),d0	;0406
	lsl.l	#8,d0		;4060	8 + 16
	move.b	5(a0),d0	;4065
	swap	d0		;6540	4
	move.b	3(a0),d0	;6543

	lea	7(a0),a0	; skip LZ4 block header + packed data size

; input: a0.l : packed buffer
;		 a1.l : output buffer
;		 d0.l : LZ4 packed block size (in bytes)

lz4_depack:	lea	0(a0,d0.l),a2	; packed buffer end
		moveq	#0,d0
		moveq	#0,d2
		moveq	#15,d4

.tokenLoop:	move.b	(a0)+,d0	;read the token
		move.l	d0,d1
		lsr.b	#4,d1
		beq.s	.lenOffset	;have we literals to copy?

		bsr.s	.readLen

		subq.w	#1,d1

.litcopy:	move.b	(a0)+,(a1)+	; block could be > 64KiB
		dbra	d1,.litcopy

		; end test is always done just after literals
		cmpa.l	a0,a2
		ble.s	.readEnd

		and.b	d4,d0

.lenOffset:	move.b	(a0)+,d2	; read 16bits offset, little endian, unaligned
		move.b	(a0)+,-(a7)
		move.w	(a7)+,d1
		move.b	d2,d1
		movea.l	a1,a3
		sub.l	d1,a3		; d1 bits 31..16 are always 0 here

		move.w	d0,d1

		bsr.s	.readLen

		addq.l	#4-1,d1		;-1 because of dbra

.copy:		move.b	(a3)+,(a1)+	; block could be > 64KiB
		dbra	d1,.copy

		bra.s	.tokenLoop

.readLen:	cmp.b	d1,d4
		bne.s	.readEnd
.readLoop:	move.b	(a0)+,d2
		add.l	d2,d1		; final len could be > 64KiB
		not.b	d2
		beq.s	.readLoop
.readEnd:	rts

tmpbuf:		dc.l	0

_show_ilbm:
	LINK	A5,#-$0000
	MOVEM.L	D4-D7/a2-a3,-(A7)

	CLR.W	-(A7)
	MOVE.L	$0008(A5),-(A7)	;filename
	JSR	_AmigaOpen(PC)
	ADDQ.W	#6,A7
	MOVE.W	D0,D6		;filehandle
	BGE.B	L00B1B

	MOVE.L	$0008(A5),-(A7)	;filename
	PEA	L00B1D(PC)	;"Couldn't open %s"
	JSR	_db_print
	ADDQ.W	#8,A7
	MOVEQ	#-$01,D0
L00B1A
	move.l	tmpbuf,-(a7)
	jsr	_free
	ADDQ.W	#4,A7

	MOVEM.L	(A7)+,D4-D7/a2-a3
	UNLK	A5
	RTS

L00B1B:
	move.w	#45000,-(a7)
	JSR	_newmem
	ADDQ.W	#2,A7
	move.l	d0,d7

	MOVE.W	#45000,-(A7)
	move.l	d0,-(a7)
	MOVE.W	D6,-(A7)	;filehandle
	JSR	_read
	ADDQ.W	#8,A7

	MOVE.W	D6,-(A7)	;filehandle
	JSR	_close
	ADDQ.W	#2,A7

	move.l	#64064,-(a7)
	JSR	_lmalloc
	ADDQ.W	#4,A7
	move.l	d0,tmpbuf

	move.l	d0,a1
	move.l	d7,a0
	bsr	lz4_frame_depack

	move.l	d7,-(a7)
	jsr	_free
	ADDQ.W	#4,A7

	move.l	tmpbuf,a0
	bsr	reversetitle

	MOVE.l	#16000,D5	;load 16kb at once
	MOVEQ	#4-1,D4

	MOVEA.L	$000C(A5),A3	;screen
	MOVEA.L	$0032(A3),A3	;get the rastport
	MOVEA.L	$0004(A3),A3	;get the bitmap
	addq.l	#8,A3

	add.l	#64,tmpbuf
loop2$
	; we load the data directly into the bitmap planes

	MOVE.l	D5,d0	;length
	move.l	(a3)+,a1	;get the planes
	move.l	tmpbuf,a0

	MOVEA.L	$0004,A6
	jsr	_LVOCopyMemQuick(a6)
	add.l	d5,tmpbuf

	DBRA	D4,loop2$

	sub.l	#64064,tmpbuf

	MOVE.W	$0010(A5),-(A7)
	move.l	tmpbuf,-(a7)
	BSR	_fade_in
	ADDQ.W	#6,A7

	BRA.B	L00B1A

reversetitle:
	tst.b	-$47AA(A4)	;_all_clear
	beq	1$

	moveq	#16-1,d2	;turn the color for the title.screen
loop$	move.b	(a0),d1
	move.b	2(a0),(a0)
	move.b	d1,2(a0)
	addq.l	#4,a0
	dbra	d2,loop$

	clr.b	-$47AA(A4)	;_all_clear
1$	rts

L00B1D:	dc.b	"Couldn't open %s",10,0

_black_out:
;	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)

	MOVEQ	#16-1,D4

1$	CLR.L	d1	;r
	CLR.L	d2	;g
	CLR.L	d3	;b
	MOVE.W	D4,D0
	MOVEA.L	-$5150(A4),A6	;_StdScr
	LEA	$002C(A6),a0
	MOVEA.L	-$5184(A4),A6	;_GfxBase
	JSR	_LVOSetRGB4(A6)

	DBRA	D4,1$

	MOVE.L	(A7)+,D4
;	UNLK	A5
	RTS

_setRGB4colors:
	MOVE.W	D0,D6
	ASL.w	#2,D6

	add.w	d6,a0

	MOVE.B	(A0)+,D1	;red
	MOVE.B	(A0)+,D2	;green
	MOVE.B	(A0),D3		;blue

	MOVEA.L	-$5150(A4),A1	;_StdScr
	LEA	$002C(A1),a0

	MOVEA.L	-$5184(A4),A6	;_GfxBase
	JSR	_LVOSetRGB4(A6)

	rts

_fade_in:
	LINK	A5,#-$0040
	MOVEM.L	D4/D5,-(A7)

	TST.W	$000C(A5)
	BEQ.W	L00B24

	CLR.W	d1
	MOVEq	#64,d0
	LEA	-$0040(A5),a0
	JSR	_memset

	MOVEQ	#16-1,D4
L00B1F:
	MOVEQ	#16-1,D5
L00B20:
	move.w	d5,d0
	lea	-$0040(A5),a0
	bsr	_setRGB4colors

	MOVEA.L	$0008(A5),A1
	MOVE.W	D5,D3
	ASL.w	#2,D3
	LEA	-$0040(A5),A6

	moveq	#2,d1
2$	MOVE.B	$00(A6,D3.w),D2
	CMP.B	$00(A1,D3.w),D2
	BCC.B	1$

	ADDQ.B	#1,$00(A6,D3.w)

1$	addq	#1,d3
	dbra	d1,2$

	DBRA	D5,L00B20

	JSR	_tick_pause
	DBRA	D4,L00B1F

	BRA.B	L00B26

L00B24:	MOVEQ	#16-1,D5
1$	MOVEA.L	$0008(A5),A0
	move.w	d5,d0
	bsr	_setRGB4colors
	DBRA	D5,1$

L00B26:
	MOVEM.L	(A7)+,D4/D5
	UNLK	A5
	RTS

_save_game:
	LINK	A5,#-$0056
	PEA	-$672B(A4)	;_whoami
	PEA	L00B2E(PC)
	MOVE.L	-$5258(A4),-(A7)	;_prbuf
	JSR	_sprintf
	LEA	$000C(A7),A7
	MOVE.L	-$5258(A4),-(A7)	;_prbuf
	CLR.W	-(A7)
	CLR.W	-(A7)
	JSR	_mvaddstr
	ADDQ.W	#8,A7
	JSR	_clrtoeol
	MOVE.L	-$5258(A4),A0	;_prbuf
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
	PEA	-$672B(A4)	;_whoami
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
	MOVE.W	D0,-$532C(A4)
;	CMP.W	#$0000,D0
	BLE.B	L00B2B
	MOVE.W	-$532C(A4),-(A7)
	JSR	_AmigaClose(PC)
	ADDQ.W	#2,A7
	JSR	_WBenchToBack(PC)
	PEA	-$0050(A5)
	PEA	L00B32(PC)
	MOVE.L	-$5258(A4),-(A7)	;_prbuf
	JSR	_sprintf
	LEA	$000C(A7),A7
	PEA	L00B34(PC)
	PEA	L00B33(PC)
	MOVE.L	-$5258(A4),-(A7)	;_prbuf
	JSR	_ask_him
	LEA	$000C(A7),A7
	TST.W	D0
	BEQ.B	L00B2A
	BRA.W	L00B27
L00B2A:
	JSR	_WBenchToFront
	BRA.B	L00B2C
L00B2B:
	MOVE.W	-$532C(A4),-(A7)
	JSR	_AmigaClose(PC)
	ADDQ.W	#2,A7
L00B2C:
	MOVE.W	#$2710,-(A7)
	PEA	-$0050(A5)
	JSR	_AmigaCreat(PC)
	ADDQ.W	#6,A7
	MOVE.W	D0,-$532C(A4)
;	CMP.W	#$0000,D0
	BGE.B	L00B2D
	JSR	_WBenchToBack(PC)
	PEA	-$0050(A5)
	PEA	L00B35(PC)
	JSR	_msg
	ADDQ.W	#8,A7
	BRA.W	L00B27
L00B2D:
	MOVE.W	#$0001,-$532E(A4)
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
	PEA	-$672B(A4)	;_whoami
	PEA	L00B3D(PC)
	MOVE.L	-$5258(A4),-(A7)	;_prbuf
	JSR	_sprintf
	LEA	$000C(A7),A7
	MOVE.L	-$5258(A4),-(A7)	;_prbuf
	CLR.W	-(A7)
	CLR.W	-(A7)
	JSR	_mvaddstr
	ADDQ.W	#8,A7
	JSR	_clrtoeol
	MOVE.L	-$5258(A4),A0	;_prbuf
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
	PEA	-$672B(A4)	;_whoami
	PEA	L00B3F(PC)
	PEA	-$0050(A5)
	JSR	_sprintf
	LEA	$000C(A7),A7
L00B39:
	MOVE.W	-$52C0(A4),d1	;_player + 10
	MOVE.W	-$52BE(A4),d0	;_player + 12
	JSR	_movequick

	PEA	-$0050(A5)
	PEA	L00B40(PC)
	JSR	_WBprint
	ADDQ.W	#8,A7
	CLR.W	-(A7)
	PEA	-$0050(A5)
	JSR	_AmigaOpen(PC)
	ADDQ.W	#6,A7
	MOVE.W	D0,-$532C(A4)
;	CMP.W	#$0000,D0
	BGE.B	L00B3A
	JSR	_WBenchToBack(PC)
	PEA	-$0050(A5)
	PEA	L00B41(PC)
	JSR	_msg
	ADDQ.W	#8,A7
	BRA.B	L00B37
L00B3A:
	CLR.W	-$532E(A4)
	JSR	_xfer_all(PC)
	PEA	-$0050(A5)
	JSR	_unlink(PC)
	ADDQ.W	#4,A7
	JSR	_WBenchToBack(PC)
	JSR	_redraw
	ST	-$66FB(A4)	;_new_stats
	JSR	_status
	PEA	L00B42(PC)
	JSR	_msg
	ADDQ.W	#4,A7
	JSR	_InitGadgets
	PEA	-$672B(A4)	;_whoami
	PEA	L00B43(PC)
	JSR	_msg
	ADDQ.W	#8,A7
	MOVEA.L	-$529C(A4),A2	;_player + 46 (pack)
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
	PEA	-$672B(A4)	;_whoami
	JSR	_xfer
	ADDQ.W	#6,A7
	LEA	-$5ADC(A4),A6	;_SV_END
	LEA	-$674E(A4),A1
	SUBA.L	A1,A6
	MOVE.W	A6,-(A7)
	PEA	-$674E(A4)
	JSR	_xfer
	ADDQ.W	#6,A7
	MOVE.W	#$000F,-(A7)
	PEA	-$66A6(A4)
	JSR	_xfer_strs(PC)
	ADDQ.W	#6,A7
	MOVE.W	#$000F,-(A7)
	PEA	-$656A(A4)	;_s_guess
	JSR	_xfer_strs(PC)
	ADDQ.W	#6,A7
	MOVE.W	#$000E,-(A7)
	PEA	-$642E(A4)	;_p_guess
	JSR	_xfer_strs(PC)
	ADDQ.W	#6,A7
	MOVE.W	#$000E,-(A7)
	PEA	-$6308(A4)	;_r_guess
	JSR	_xfer_strs(PC)
	ADDQ.W	#6,A7
	MOVE.W	#$000E,-(A7)
	PEA	-$61E2(A4)	;_ws_guess
	JSR	_xfer_strs(PC)
	ADDQ.W	#6,A7
	JSR	_xfer_choice(PC)
	CLR.L	-(A7)
	PEA	-$48C0(A4)	;_oldrp
	JSR	_xfer_proom(PC)
	ADDQ.W	#8,A7
	CLR.L	-(A7)
	PEA	-$6CB0(A4)	;_lvl_obj
	JSR	_xfer_pthing
	ADDQ.W	#8,A7
	CLR.L	-(A7)
	PEA	-$6CAC(A4)	;_mlist
	JSR	_xfer_pthing
	ADDQ.W	#8,A7
	CLR.L	-(A7)
	PEA	-$5298(A4)	;_cur_weapon
	JSR	_xfer_pthing
	ADDQ.W	#8,A7
	CLR.L	-(A7)
	PEA	-$5294(A4)	;_cur_armor
	JSR	_xfer_pthing
	ADDQ.W	#8,A7
	CLR.L	-(A7)
	PEA	-$5190(A4)	;_cur_ring_1
	JSR	_xfer_pthing
	ADDQ.W	#8,A7
	CLR.L	-(A7)
	PEA	-$518C(A4)	;_cur_ring_2
	JSR	_xfer_pthing
	ADDQ.W	#8,A7
	TST.W	-$532E(A4)
	BNE.B	L00B44
	MOVE.W	#$0032,-(A7)
	PEA	-$52CA(A4)	;_player + 0
	BSR.B	_xfer
	ADDQ.W	#6,A7
L00B44:
	PEA	-$52CA(A4)	;_player + 0
	JSR	_xfer_monster(PC)
	ADDQ.W	#4,A7
	MOVE.W	#$00A6,-(A7)
	MOVE.L	-$52CE(A4),-(A7)	;__t_alloc
	BSR.B	_xfer
	ADDQ.W	#6,A7
	JSR	_xfer_things(PC)
	MOVE.W	#$04EC,-(A7)
	MOVE.L	-$519C(A4),-(A7)	;__level
	BSR.B	_xfer
	ADDQ.W	#6,A7
	MOVE.W	#$04EC,-(A7)
	MOVE.L	-$5198(A4),-(A7)	;__flags
	BSR.B	_xfer
	ADDQ.W	#6,A7
	LEA	-$7062(A4),A6
	LEA	-$76F8(A4),A1
	SUBA.L	A1,A6
	MOVE.W	A6,-(A7)
	PEA	-$76F8(A4)
	BSR.B	_xfer
	ADDQ.W	#6,A7
	JSR	_dm_xfer
	JSR	_XferKeys(PC)
	MOVE.W	-$532C(A4),-(A7)
	JSR	_AmigaClose(PC)
	ADDQ.W	#2,A7
	MOVEM.L	(A7)+,D4/D5/A2/A3
	UNLK	A5
	RTS

_xfer:
	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)
	MOVE.W	$000C(A5),-$60A4(A4)	;_count
	TST.W	-$532E(A4)
	BEQ.B	L00B45

	MOVE.W	$000C(A5),-(A7)
	MOVE.L	$0008(A5),-(A7)
	MOVE.W	-$532C(A4),-(A7)
	JSR	_write
	ADDQ.W	#8,A7
	MOVE.W	D0,D4
	BRA.B	L00B46
L00B45:
	MOVE.W	$000C(A5),-(A7)
	MOVE.L	$0008(A5),-(A7)
	MOVE.W	-$532C(A4),-(A7)
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
	TST.W	-$532E(A4)
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

	LEA	-$5290(A4),A6	;_p_colors
	MOVEA.L	A6,A2
L00B4F:
	TST.W	-$532E(A4)
	BEQ.B	L00B52

	LEA	-$7A46(A4),A6	;_rainbow
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
	LEA	-$7A46(A4),A6	;_rainbow
	SUB.L	A6,D3
	LSR.L	#2,D3
	MOVE.W	D3,-$0002(A5)
L00B52:
	MOVE.W	#$0002,-(A7)
	PEA	-$0002(A5)
	JSR	_xfer
	ADDQ.W	#6,A7
	TST.W	-$532E(A4)
	BNE.B	L00B53

	MOVE.W	-$0002(A5),D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	-$7A46(A4),A6	;_rainbow
	MOVE.L	$00(A6,D3.w),(A2)
L00B53:
	ADDQ.L	#4,A2
	LEA	-$5258(A4),A6	;_prbuf
	CMPA.L	A6,A2
	BCS.B	L00B4F

	LEA	-$5254(A4),A6	;_r_stones
	MOVEA.L	A6,A2
L00B54:
	TST.W	-$532E(A4)
	BEQ.B	L00B57

	LEA	-$79D2(A4),A6	;_stones
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
	LEA	-$79D2(A4),A6	;_stones
	SUB.L	A6,D0
	MOVEQ	#$06,D1
	JSR	_divu
	MOVE.W	D0,-$0002(A5)
L00B57:
	MOVE.W	#$0002,-(A7)
	PEA	-$0002(A5)
	JSR	_xfer
	ADDQ.W	#6,A7
	TST.W	-$532E(A4)
	BNE.B	L00B58

	MOVE.W	-$0002(A5),D3
	MULU.W	#$0006,D3
	LEA	-$79D2(A4),A6	;_stones
	MOVE.L	$00(A6,D3.L),(A2)
	MOVE.L	A2,D3
	LEA	-$5254(A4),A6	;_r_stones
	SUB.L	A6,D3
	LSR.L	#2,D3
	ASL.L	#3,D3
	LEA	-$6E02(A4),A6	;_r_magic + 6
	MOVE.W	-$0002(A5),D2
	MULU.W	#$0006,D2
	LEA	-$79CE(A4),A1	;_stones + 4
	MOVE.W	$00(A1,D2.L),D1
	ADD.W	D1,$00(A6,D3.L)
L00B58:
	ADDQ.L	#4,A2
	LEA	-$521C(A4),A6	;_ws_type
	CMPA.L	A6,A2
	BCS.W	L00B54

;	LEA	-$521C(A4),A6	;_ws_type
	MOVE.L	A6,D4
	LEA	-$51E4(A4),A6	;_ws_made
	MOVEA.L	A6,A2
	BRA.W	L00B65
L00B59:
	TST.W	-$532E(A4)
	BEQ.B	L00B60

	MOVEA.L	D4,A6
	MOVEA.L	(A6),A1
	CMPA.L	-$7A4E(A4),A1	;_ws_wand
	SEQ	D3
	AND.W	#$0001,D3
	MOVE.W	D3,-$0004(A5)
	MOVE.W	#$0002,-(A7)
	PEA	-$0004(A5)
	JSR	_xfer
	ADDQ.W	#6,A7
	TST.W	-$0004(A5)
	BEQ.B	L00B5A

	LEA	-$78B2(A4),A6	;_wood
	MOVEA.L	A6,A3
	BRA.B	L00B5B
L00B5A:
	LEA	-$7936(A4),A6	;_wood
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
	LEA	-$78B2(A4),A6	;_wood
	MOVE.L	A6,D2
	BRA.B	L00B5F
L00B5E:
	LEA	-$7936(A4),A6	;_wood
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
	TST.W	-$532E(A4)
	BNE.B	L00B64
	MOVE.W	#$0002,-(A7)
	PEA	-$0004(A5)
	JSR	_xfer
	ADDQ.W	#6,A7
	MOVEA.L	D4,A6
	TST.W	-$0004(A5)
	BEQ.B	L00B61
	MOVE.L	-$7A4E(A4),(A6)	;_ws_wand
	BRA.B	L00B62
L00B61:
	MOVE.L	-$7A4A(A4),(A6)	;_ws_staff
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
	LEA	-$78B2(A4),A6	;_wood
	MOVE.L	$00(A6,D3.L),(A2)
	BRA.B	L00B64
L00B63:
	MOVE.W	-$0002(A5),D3
	EXT.L	D3
	ASL.L	#2,D3
	LEA	-$7936(A4),A6	;_wood
	MOVE.L	$00(A6,D3.L),(A2)
L00B64:
	ADDQ.L	#4,D4
	ADDQ.L	#4,A2
L00B65:
	MOVE.L	A2,D3
	LEA	-$51E4(A4),A6	;_ws_made
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
	TST.W	-$532E(A4)
	BEQ.B	L00B6A

	MOVEA.L	$0008(A5),A6
	TST.L	(A6)
	BEQ.B	L00B67

	MOVEA.L	$0008(A5),A6
	LEA	-$6088(A4),A1	;_rooms
	MOVEA.L	(A6),A0
	CMPA.L	A1,A0
	BCS.B	L00B66

	MOVEA.L	$0008(A5),A6
	LEA	-$5E36(A4),A1	;_passages
	MOVEA.L	(A6),A0
	CMPA.L	A1,A0
	BCC.B	L00B66

	MOVEA.L	$0008(A5),A6
	MOVE.L	(A6),D0
	LEA	-$6088(A4),A6	;_rooms
	SUB.L	A6,D0
	MOVEQ	#$42,D1
	JSR	_divu
	ADD.W	#$2000,D0
	MOVE.W	D0,-$0002(A5)
	BRA.B	L00B67
L00B66:
	MOVEA.L	$0008(A5),A6
	MOVE.L	(A6),D0
	LEA	-$5E36(A4),A6	;_passages
	SUB.L	A6,D0
	MOVEQ	#$42,D1
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
	LEA	-$5E36(A4),A1	;_passages
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
	LEA	-$6088(A4),A1	;_rooms
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
	TST.W	-$532E(A4)
	BEQ.B	L00B73

	MOVEA.L	$0008(A5),A6
	TST.L	(A6)
	BEQ.B	L00B70

	MOVEA.L	$0008(A5),A6
	MOVE.L	(A6),D0
	SUB.L	-$52D2(A4),D0
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
	MULU.W	#$0032,D3
	ADD.L	-$52D2(A4),D3
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
	MOVEA.L	-$52CE(A4),A6	;__t_alloc
	TST.W	$00(A6,D3.L)
	BEQ.B	L00B7B

	MOVE.W	D4,D3
	MULS.W	#$0032,D3
	MOVEA.L	D3,A2
	ADDA.L	-$52D2(A4),A2
	TST.W	-$532E(A4)
	BNE.B	L00B79

	MOVE.W	#$0032,-(A7)
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
	CMP.W	#$0053,D4	;'S'
	BLT.B	L00B78

	MOVEM.L	(A7)+,D4/A2
	UNLK	A5
	RTS

_xfer_monster:
	LINK	A5,#-$0002
	MOVE.L	A2,-(A7)

	MOVEA.L	$0008(A5),A2
	TST.W	-$532E(A4)
	BNE.W	L00B84

	LEA	-$52CA(A4),A6	;_player + 0
	CMPA.L	A6,A2
	BNE.B	L00B7C

	MOVE.L	-$69AA(A4),$0024(A2)
	BRA.B	L00B7E
L00B7C:
	MOVE.B	$000F(A2),D3
	EXT.W	D3
	CMP.W	#$0046,D3
	BNE.B	L00B7D

	LEA	-$6735(A4),A6	;_f_damage
	MOVE.L	A6,$0024(A2)
	BRA.B	L00B7E
L00B7D:
	MOVE.B	$000F(A2),D3
	EXT.W	D3
	SUB.W	#$0041,D3	;'A'
	MULU.W	#26,D3
	LEA	-$6C94(A4),A6
	MOVE.L	$00(A6,D3.L),$0024(A2)
L00B7E:
	MOVE.W	$0014(A2),-$0002(A5)
	MOVE.W	-$0002(A5),D3
	AND.W	#$F000,D3
	MOVEQ	#$00,D0
	MOVE.W	D3,D0
	BRA.B	L00B83
L00B7F:
	LEA	-$52C0(A4),A6	;_player + 10
	MOVE.L	A6,$0012(A2)
	BRA.B	L00B84
L00B80:
	MOVE.W	-$0002(A5),D3
	AND.W	#$0FFF,D3
	MULU.W	#$0032,D3
	ADD.L	-$52D2(A4),D3
	ADD.L	#$0000000C,D3
	MOVE.L	D3,$0012(A2)
	BRA.B	L00B84
L00B81:
	MOVE.W	-$0002(A5),D3
	AND.W	#$0FFF,D3
	MULU.W	#66,D3
	LEA	-$6080(A4),A6	;_rooms + 8
	ADD.L	A6,D3
	MOVE.L	D3,$0012(A2)
	BRA.B	L00B84
L00B82:
	MOVE.W	-$0002(A5),D3
	AND.W	#$0FFF,D3
	MULU.W	#66,D3
	LEA	-$5E2E(A4),A6
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
	TST.W	-$532E(A4)
	BEQ.W	L00B89

	LEA	-$52C0(A4),A6	;_player + 10
	MOVEA.L	$0012(A2),A1
	CMPA.L	A6,A1
	BNE.B	L00B85

	MOVE.L	#$00004000,$0012(A2)
	BRA.W	L00B88
L00B85:
	MOVE.L	$0012(A2),D0
	SUB.L	-$52D2(A4),D0
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
	LEA	-$6088(A4),A6	;_rooms
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
	LEA	-$5E36(A4),A6	;_passages
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
	TST.W	-$532E(A4)
	BNE.B	L00B8D

	MOVEA.L	$0008(A5),A6

	TST.L	$0016(A6)
	BNE.B	1$

	MOVE.L	-$69AE(A4),$0016(A6)	;_no_damage
1$
	TST.L	$001A(A6)
	BNE.B	2$

	MOVE.L	-$69AE(A4),$001A(A6)	;_no_damage
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

	TST.W	-$532E(A4)
	BEQ.B	3$

	MOVEA.L	$0008(A5),A6

	MOVEA.L	$0016(A6),A1
	CMPA.L	-$69AE(A4),A1	;_no_damage
	BNE.B	1$

	CLR.L	$0016(A6)
1$
	MOVEA.L	$001A(A6),A1
	CMPA.L	-$69AE(A4),A1	;_no_damage
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

_XferKeys:
	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)

	MOVEQ	#$00,D4
L00B95:
	MOVE.W	#$0020,-(A7)
	MOVE.W	D4,D3
	EXT.L	D3
	ASL.L	#2,D3
	MOVEA.L	-$5898(A4),A6	;_FuncKeys
	MOVE.L	$00(A6,D3.L),-(A7)
	JSR	_xfer
	ADDQ.W	#6,A7
	ADDQ.W	#1,D4
	CMP.W	#$000A,D4
	BLT.B	L00B95

	MOVE.L	(A7)+,D4
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

_InitGadgets:
	LINK	A5,#-$0000
	TST.W	-$5810(A4)
	BEQ.B	L00B9C
	CLR.L	-(A7)
	MOVE.L	-$5148(A4),-(A7)	;_RogueWin
	PEA	-$5894(A4)
	JSR	_RefreshGadgets(PC)
	LEA	$000C(A7),A7
L00B9B:
	UNLK	A5
	RTS

L00B9C:
	MOVE.W	#$0001,-$5810(A4)
	CLR.W	-(A7)
	MOVE.W	#$0014,-(A7)
	JSR	_malloc
	ADDQ.W	#2,A7

	MOVE.L	D0,-(A7)
	PEA	L00B9D(PC)
	JSR	_ctointui
	LEA	$000A(A7),A7

	MOVE.L	D0,-$584E(A4)
	CLR.W	-(A7)
	MOVE.W	#$0014,-(A7)
	JSR	_malloc
	ADDQ.W	#2,A7

	MOVE.L	D0,-(A7)
	PEA	L00B9E(PC)
	JSR	_ctointui
	LEA	$000A(A7),A7

	MOVE.L	D0,-$587A(A4)
	CLR.W	-(A7)
	MOVE.W	#$0014,-(A7)
	JSR	_malloc
	ADDQ.W	#2,A7

	MOVE.L	D0,-(A7)
	PEA	L00B9F(PC)
	JSR	_ctointui
	LEA	$000A(A7),A7

	MOVE.L	D0,-$5822(A4)
	MOVE.W	#$FFFF,-(A7)
	PEA	-$5894(A4)
	MOVE.L	-$5148(A4),-(A7)	;_RogueWin
	JSR	_AddGadget(PC)
	LEA	$000A(A7),A7

	MOVE.W	#$FFFF,-(A7)
	PEA	-$5868(A4)
	MOVE.L	-$5148(A4),-(A7)	;_RogueWin
	JSR	_AddGadget(PC)
	LEA	$000A(A7),A7

	MOVE.W	#$FFFF,-(A7)
	PEA	-$583C(A4)
	MOVE.L	-$5148(A4),-(A7)	;_RogueWin
	JSR	_AddGadget(PC)
	LEA	$000A(A7),A7

	CLR.L	-(A7)
	MOVE.L	-$5148(A4),-(A7)	;_RogueWin
	PEA	-$5894(A4)
	JSR	_OnGadget(PC)
	LEA	$000C(A7),A7

	CLR.L	-(A7)
	MOVE.L	-$5148(A4),-(A7)	;_RogueWin
	PEA	-$5868(A4)
	JSR	_OnGadget(PC)
	LEA	$000C(A7),A7

	CLR.L	-(A7)
	MOVE.L	-$5148(A4),-(A7)	;_RogueWin
	PEA	-$583C(A4)
	JSR	_OnGadget(PC)
	LEA	$000C(A7),A7

	BRA.W	L00B9B

L00B9D:	dc.b	"Rest",0
L00B9E:	dc.b	"Search",0
L00B9F:	dc.b	"Down",0,0

_AmigaCreat:
	LINK	A5,#-$0200
	MOVEM.L	D4-D6,-(A7)
	TST.W	-$580E(A4)
	BEQ.B	L00BA0
	JSR	_OffVerify
L00BA0:
	CLR.W	-$580E(A4)
	MOVE.W	#$01B6,-(A7)
	MOVE.L	$0008(A5),-(A7)
	JSR	_creat(PC)
	ADDQ.W	#6,A7
	MOVE.W	D0,D4
;	CMP.W	#$0000,D4
	BLT.B	L00BA8
	MOVE.W	$000C(A5),D5

	CLR.W	d1
	MOVE.W	#$0200,d0
	LEA	-$0200(A5),a0
	JSR	_memset

L00BA1:
	TST.W	D5
	BEQ.B	L00BA6

	CMP.W	#$0200,D5
	BLS.B	L00BA2

	MOVE.W	#$0200,D6
	BRA.B	L00BA3
L00BA2:
	MOVE.W	D5,D6
L00BA3:
	MOVE.W	D6,-(A7)
	PEA	-$0200(A5)
	MOVE.W	D4,-(A7)
	JSR	_write
	ADDQ.W	#8,A7
	CMP.W	D6,D0
	BNE.B	L00BA6

	SUB.W	D6,D5
	BRA.B	L00BA1
L00BA6:
	TST.W	D5
	BEQ.B	L00BA7

	MOVE.W	D4,-(A7)
	BSR.B	_AmigaClose
	ADDQ.W	#2,A7
	MOVEQ	#-$01,D4
	MOVE.L	$0008(A5),-(A7)
	JSR	_unlink(PC)
	ADDQ.W	#4,A7
	BRA.B	L00BA8
L00BA7:
	CLR.W	-(A7)
	CLR.L	-(A7)
	MOVE.W	D4,-(A7)
	JSR	_lseek(PC)
	ADDQ.W	#8,A7
L00BA8:
	CMP.W	#$0000,D4
	BGE.B	L00BA9

	JSR	_OnVerify
L00BA9:
	MOVE.W	D4,D0

	MOVEM.L	(A7)+,D4-D6
	UNLK	A5
	RTS

_AmigaOpen:
	LINK	A5,#-$0002
	TST.W	-$580E(A4)
	BEQ.B	L00BAA

	JSR	_OffVerify
L00BAA:
	CLR.W	-$580E(A4)
	MOVE.W	$000C(A5),-(A7)
	MOVE.L	$0008(A5),-(A7)
	JSR	_open
	ADDQ.W	#6,A7
	MOVE.W	D0,-$0002(A5)
	CMPI.W	#$0000,-$0002(A5)
	BLE.B	L00BAB

	JSR	_OnVerify
L00BAB:
	MOVE.W	-$0002(A5),D0
	UNLK	A5
	RTS

_AmigaClose:
	LINK	A5,#-$0000
	TST.W	-$580E(A4)
	BNE.B	L00BAC

	JSR	_OnVerify
L00BAC:
	MOVE.W	#$0001,-$580E(A4)
	MOVE.W	$0008(A5),-(A7)
	JSR	_close
	ADDQ.W	#2,A7
	UNLK	A5
	RTS

L00BDD:	dc.b	"Here is a brief list of some of the keyboard commands "
	dc.b	"in Rogue. For more",0
L00BDE:	dc.b	"information on these, as well as instructions on how "
	dc.b	"to use the mouse and",0
L00BDF:	dc.b	"the menus, see the instruction manual.",0
L00BE0:	dc.b	$00
L00BE1:	dc.b	"a    Repeat last throw/zap           "
	dc.b	"D    Show a list of magic discovered",0
L00BE2:	dc.b	"c    Relabel a magic item            "
	dc.b	"P    Put on a ring",0
L00BE3:	dc.b	"d    Drop an object                  "
	dc.b	"Q    Quit",0
L00BE4:	dc.b	"e    Eat some food                   "
	dc.b	"R    Remove (take off) a ring",0
L00BE5:	dc.b	"i    Show inventory                  "
	dc.b	"S    Save the game",0
L00BE6:	dc.b	"q    Quaff (drink) a potion          "
	dc.b	"T    Take off armor",0
L00BE7:	dc.b	"r    Read a scroll                   "
	dc.b	"W    Wear armor",0
L00BE8:	dc.b	"s    Seach each adjacent position    "
	dc.b	".    Rest",0
L00BE9:	dc.b	"t    Throw an object                 "
	dc.b	">    Go down a staircase",0
L00BEA:	dc.b	"w    Wield a weapon                  "
	dc.b	"<    Go up a staircase",0
L00BEB:	dc.b	"z    Zap a magic wand/staff",0
L00BEC:	dc.b	$00
L00BED:	dc.b	"To move around in the dungeon, use the numeric keypad."
	dc.b	"  Pressing the CTRL",0
L00BEE:	dc.b	"key before a move, will repeat the move until you "
	dc.b	"encounter something inter-",0
L00BEF:	dc.b	"esting.  Pressing the SHIFT key before a move will "
	dc.b	"repeat the move until",0
L00BF0:	dc.b	"you run into something.",0
L00BF1:	dc.b	"-------- Press space when you are finished "
	dc.b	"viewing the instructions --------",0

_help:
;	LINK	A5,#-$0000
	MOVEM.L	D4/A2,-(A7)

	JSR	_wtext
	MOVEQ	#$00,D4
	LEA	-$580C(A4),A6
	MOVEA.L	A6,A2
	BRA.B	L00BF3

L00BF2:	MOVE.L	(A2),-(A7)
	CLR.W	-(A7)
	MOVE.W	D4,-(A7)
	JSR	_mvaddstr
	ADDQ.W	#8,A7
	ADDQ.L	#4,A2
	ADDQ.W	#1,D4
L00BF3:
	TST.L	(A2)
	BNE.B	L00BF2

	MOVE.W	#$0020,-(A7)	;SPACE
	JSR	_wait_for
	ADDQ.W	#2,A7
	JSR	_wmap

	MOVEM.L	(A7)+,D4/A2
;	UNLK	A5
	RTS

_atoi:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5/A2,-(A7)
	MOVEA.L	$0008(A5),A2
L00BF4:
	MOVE.B	(A2)+,D3
	CMP.b	#$20,D3		;' '
	BEQ.B	L00BF4
	CMP.b	#$09,D3		;TAB
	BEQ.B	L00BF4
L00BF6:
	MOVEQ	#$00,D5
	CMP.b	#$2D,D3		;'-'
	BNE.B	L00BF7

	MOVEQ	#$01,D5
	BRA.B	L00BF8
L00BF7:
	CMP.b	#$2B,D3		;'+'
	BEQ.B	L00BF8
	SUBQ.L	#1,A2
L00BF8:
	MOVEQ	#$00,D4
	LEA	-$55CA(A4),A6		;_ctp_
	BRA.B	L00BFA

L00BF9:
	SUB.W	#$0030,D3
	MULU.W	#10,D4
	ADD.W	D3,D4
L00BFA:
	MOVE.B	(A2)+,D3
	EXT.W	D3
	moveq	#$0004,D2
	AND.B	$00(A6,D3.W),D2
	BNE.B	L00BF9

	TST.W	D5		;had minus?
	BEQ.B	L00BFB
	MOVE.W	D4,D0
	NEG.W	D0
	BRA.B	L00BFC
L00BFB:
	MOVE.W	D4,D0
L00BFC:
	MOVEM.L	(A7)+,D4/D5/A2
	UNLK	A5
	RTS

_memset:
	TST.B	D1
	BEQ	4$
	BRA.B	2$

1$	MOVE.B	D1,(A0)+
2$	DBF	D0,1$

	RTS

3$	CLR.B	(A0)+
4$	DBF	D0,3$

	RTS

begin:
;	MOVEA.L	(A7)+,A1
;	SUBA.W	#$000A,A1
;	MOVE.L	(A1),D1
;	ADD.L	D1,D1
;	ADD.L	D1,D1
;	MOVEA.L	D1,A4
;	ADDA.L	#$00008002,A4

;	lea	__Dorg+$7FFE,a4
	lea	_MathTransBase+$46d4,a4

	LEA	-$5546(A4),A1	;__Uorg
	LEA	-$5546(A4),A2	;__Uorg
	CMPA.L	A1,A2
	BNE.B	L00C00

	MOVE.W	#((__Uend-__Uorg-2)/4),D1
	BMI.B	L00C00
1$
	CLR.L	(A1)+
	DBF	D1,1$
L00C00:
	MOVE.L	A7,-$4760(A4)		;__savsp
	MOVEA.L	$0004,A6
	MOVE.L	A6,-$475C(A4)		;_SysBase

	MOVEM.L	D0/A0,-(A7)
	JSR	__main(PC)
	ADDQ.W	#8,A7
	RTS

_index:
	MOVEA.L	$0004(A7),A0
	MOVE.W	$0008(A7),D0
L00C01:
	MOVE.B	(A0)+,D1
	BEQ.B	L00C02
	CMP.B	D0,D1
	BNE.B	L00C01
	MOVE.L	A0,D0
	SUBQ.L	#1,D0
	RTS

L00C02:
	MOVEQ	#$00,D0
	RTS

_strcmp:
	MOVE.W	#$7fff,D0
	BRA.B	L00C03

_strncmp:
	MOVE.W	$000C(A7),D0
L00C03:
	SUBQ.W	#1,D0
	BMI.B	L00C05

	MOVEA.L	$0004(A7),A0
	MOVEA.L	$0008(A7),A1
L00C04:
	CMPM.B	(A1)+,(A0)+
	BNE.B	L00C06

	SUBQ.W	#1,A0
	TST.B	(A0)+
	DBEQ	D0,L00C04
L00C05:
	MOVEQ	#$00,D0
	RTS

L00C06:
	BLS.B	L00C07
	MOVEQ	#$01,D0
	RTS

L00C07:
	MOVEQ	#-$01,D0
	RTS

_lseek:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5/A2,-(A7)

	MOVE.W	$0008(A5),D4
	JSR	_Chk_Abort(PC)
	MOVE.W	D4,D3
	BLT.B	L00C08

	MULS.W	#$0006,D3
	LEA	-$4758(A4),A2		;__devtab
	ADDA.L	D3,A2

	CMP.W	#$0013,D4
	BGT.B	L00C08

	TST.L	(A2)
	BNE.B	L00C0A
L00C08:
	MOVE.W	#$0003,-$46E0(A4)	;_errno
	MOVEQ	#-$01,D0
L00C09:
	MOVEM.L	(A7)+,D4/D5/A2
	UNLK	A5
	RTS

L00C0A:
	MOVE.W	$000E(A5),D3
	EXT.L	D3
	MOVEA.L	D3,A6
	PEA	-$0001(A6)
	MOVE.L	$000A(A5),-(A7)
	MOVE.L	(A2),-(A7)
	JSR	_Seek(PC)
	LEA	$000C(A7),A7
	MOVE.L	D0,D5
	CMP.L	#$FFFFFFFF,D0
	BNE.B	L00C0B

	JSR	_IoErr(PC)
	MOVE.W	D0,-$46E0(A4)	;_errno
	MOVEQ	#-$01,D0
	BRA.B	L00C09
L00C0B:
	CLR.L	-(A7)
	CLR.L	-(A7)
	MOVE.L	(A2),-(A7)
	JSR	_Seek(PC)
	LEA	$000C(A7),A7
	BRA.B	L00C09

_creat:
	LINK	A5,#-$0000

	MOVE.W	$000C(A5),-(A7)
	MOVE.W	#$0301,-(A7)
	MOVE.L	$0008(A5),-(A7)
	BSR.B	_open
	ADDQ.W	#8,A7

	UNLK	A5
	RTS

_open:
	LINK	A5,#-$0000
	MOVEM.L	D4-D6/A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	JSR	_Chk_Abort(PC)
	LEA	-$4758(A4),A3		;__devtab
	MOVEQ	#$00,D5
L00C0C:
	MOVE.W	D5,D3
	MULS.W	#$0006,D3
	TST.L	$00(A3,D3.L)
	BEQ.B	L00C0D

	ADDQ.W	#1,D5
	CMP.W	#$0014,D5
	BLT.B	L00C0C

	MOVEQ	#$08,D6
	BRA.W	L00C12
L00C0D:
	MOVE.W	$000C(A5),D3
	AND.W	#$0200,D3
	BEQ.B	L00C0E

	PEA	-$1
	MOVE.L	A2,-(A7)
	JSR	_Lock(PC)
	ADDQ.W	#8,A7
	MOVE.L	D0,D4
;	TST.L	D0
	BEQ.B	L00C0E

	MOVE.L	D4,-(A7)
	JSR	_UnLock(PC)
	ADDQ.W	#4,A7
	MOVE.L	A2,-(A7)
	JSR	_DeleteFile(PC)
	ADDQ.W	#4,A7
	TST.L	D0
	BNE.B	L00C0E

	JSR	_IoErr(PC)
	MOVE.W	D0,D6
	CMP.W	#$00CD,D0
	BNE.B	L00C12
L00C0E:
	PEA	$03ED
	MOVE.L	A2,-(A7)
	JSR	_Open(PC)
	ADDQ.W	#8,A7
	MOVE.L	D0,D4
;	TST.L	D4
	BNE.B	L00C11

	MOVE.W	$000C(A5),D3
	AND.W	#$0100,D3
	BNE.B	L00C0F

	MOVEQ	#$01,D6
	BRA.B	L00C12
L00C0F:
	PEA	$03EE
	MOVE.L	A2,-(A7)
	JSR	_Open(PC)
	ADDQ.W	#8,A7
	MOVE.L	D0,D4
;	TST.L	D0
	BNE.B	L00C10

	JSR	_IoErr(PC)
	MOVE.W	D0,D6
	BRA.B	L00C12
L00C10:
	PEA	$0001
	PEA	L00C16(PC)
	MOVE.L	D4,-(A7)
	JSR	_Write(PC)
	LEA	$000C(A7),A7
	PEA	-$1
	CLR.L	-(A7)
	MOVE.L	D4,-(A7)
	JSR	_Seek(PC)
	LEA	$000C(A7),A7
	BRA.B	L00C14
L00C11:
	MOVE.W	$000C(A5),D3
	AND.W	#$0500,D3
	CMP.W	#$0500,D3
	BNE.B	L00C14

	MOVE.L	D4,-(A7)
	JSR	_Close(PC)
	ADDQ.W	#4,A7
	MOVEQ	#$05,D6
L00C12:
	MOVE.W	D6,-$46E0(A4)	;_errno
	MOVEQ	#-$01,D0
L00C13:
	MOVEM.L	(A7)+,D4-D6/A2/A3
	UNLK	A5
	RTS

L00C14:
	MOVE.W	D5,D3
	MULS.W	#$0006,D3
	MOVE.L	D4,$00(A3,D3.L)
;	MOVE.W	D5,D3
;	MULS.W	#$0006,D3
	MOVEA.L	D3,A6
	ADDA.L	A3,A6
	MOVE.W	$000C(A5),$0004(A6)
	MOVE.W	$000C(A5),D3
	AND.W	#$0800,D3
	BEQ.B	L00C15

	PEA	$0001
	CLR.L	-(A7)
	MOVE.L	D4,-(A7)
	JSR	_Seek(PC)
	LEA	$000C(A7),A7
L00C15:
	MOVE.W	D5,D0
	BRA.B	L00C13
L00C16:
	dc.w	$0000

_read:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5/A2,-(A7)
	MOVE.W	$0008(A5),D4
	JSR	_Chk_Abort(PC)
	MOVE.W	D4,D3
	BLT.B	L00C17

	MULS.W	#$0006,D3
	LEA	-$4758(A4),A2		;__devtab
	ADDA.L	D3,A2

	CMP.W	#$0013,D4
	BGT.B	L00C17
	TST.L	(A2)
	BNE.B	L00C19
L00C17:
	MOVE.W	#$0003,-$46E0(A4)	;_errno
	MOVEQ	#-$01,D0
L00C18:
	MOVEM.L	(A7)+,D4/D5/A2
	UNLK	A5
	RTS

L00C19:
	MOVE.W	$0004(A2),D3
	AND.W	#$0003,D3
	CMP.W	#$0001,D3
	BNE.B	L00C1A

	MOVE.W	#$0006,-$46E0(A4)	;_errno
	MOVEQ	#-$01,D0
	BRA.B	L00C18
L00C1A:
	MOVEQ	#$00,D3
	MOVE.W	$000E(A5),D3
	MOVE.L	D3,-(A7)
	MOVE.L	$000A(A5),-(A7)
	MOVE.L	(A2),-(A7)
	JSR	_Read(PC)
	LEA	$000C(A7),A7

	MOVE.L	D0,D5
	CMP.L	#$FFFFFFFF,D0
	BNE.B	L00C1B

	JSR	_IoErr(PC)
	MOVE.W	D0,-$46E0(A4)	;_errno
	MOVEQ	#-$01,D0
	BRA.B	L00C18
L00C1B:
	MOVE.L	D5,D0
	BRA.B	L00C18

_mulu:
	MOVEM.L	D2/D3,-(A7)
	MOVE.W	D1,D2
	MULU.W	D0,D2
	MOVE.L	D1,D3
	SWAP	D3
	MULU.W	D0,D3
	SWAP	D3
	CLR.W	D3
	ADD.L	D3,D2
	SWAP	D0
	MULU.W	D1,D0
	SWAP	D0
	CLR.W	D0
	ADD.L	D2,D0
	MOVEM.L	(A7)+,D2/D3
	RTS

_sprintf:
	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)

	MOVE.L	$0008(A5),-$532A(A4)

	PEA	$0010(A5)
	MOVE.L	$000C(A5),-(A7)
	PEA	L00C1C(PC)
	JSR	_format(PC)
	LEA	$000C(A7),A7

	MOVE.W	D0,D4
	MOVEA.L	-$532A(A4),A6
	CLR.B	(A6)
	MOVE.W	D4,D0

	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

L00C1C:
	LINK	A5,#-$0000
	MOVEA.L	-$532A(A4),A6
	ADDQ.L	#1,-$532A(A4)
	MOVE.B	$0009(A5),D0
	MOVE.B	D0,(A6)
;	EXT.W	D0
	AND.W	#$00FF,D0
	UNLK	A5
	RTS

_gmtime:
;	LINK	A5,#-$0000
;	MOVE.L	$0008(A5),-(A7)
;	BSR.B	_localtime
;	ADDQ.W	#4,A7
;	UNLK	A5
;	RTS

_localtime:
	LINK	A5,#-$0000
	MOVEM.L	D4-D6,-(A7)

	MOVEA.L	$0008(A5),A6
	MOVE.L	(A6),D4
	MOVE.L	D4,D0
	MOVEQ	#60,D1
	JSR	_mods
	MOVE.W	D0,-$5326(A4)
	MOVE.L	D4,D0
	MOVEQ	#60,D1
	JSR	_divu
	MOVE.L	D0,D4
	MOVE.L	D4,D0
	MOVEQ	#60,D1
	JSR	_mods
	MOVE.W	D0,-$5324(A4)
	MOVE.L	D4,D0
	MOVEQ	#60,D1
	JSR	_divu
	MOVE.L	D0,D4
	MOVE.L	D4,D0
	MOVEQ	#24,D1
	JSR	_mods
	MOVE.W	D0,-$5322(A4)
	MOVE.L	D4,D0
	MOVEQ	#24,D1
	JSR	_divu
	MOVE.L	D0,D4
	MOVE.L	D4,D0
	MOVEQ	#$07,D1
	JSR	_mods
	MOVE.W	D0,-$531A(A4)
	MOVE.L	D4,D0
	MOVE.L	#$000005B5,D1	;4 years in days + one day for leap year
	JSR	_divu
	ASL.L	#2,D0
	ADD.L	#$0000004E,D0	;78
	MOVE.W	D0,-$531C(A4)
	MOVE.L	D4,D0
	MOVE.L	#$000005B5,D1
	JSR	_mods
	MOVE.L	D0,D4
L00C1D:
	TST.L	D4
	BEQ.B	L00C1F
	MOVE.L	#$0000016D,D5
	MOVE.W	-$531C(A4),D3
	AND.W	#$0003,D3
	BNE.B	L00C1E
	ADDQ.L	#1,D5
L00C1E:
	CMP.L	D5,D4
	BLT.B	L00C1F

	SUB.L	D5,D4
	ADDQ.W	#1,-$531C(A4)
	BRA.B	L00C1D
L00C1F:
	ADDQ.L	#1,D4
	MOVE.W	D4,-$5318(A4)
	MOVEQ	#$00,D6
L00C20:
	MOVE.W	D6,D3
	EXT.L	D3
	ASL.L	#1,D3
	LEA	-$57B4(A4),A6
	MOVE.W	$00(A6,D3.L),D2
	EXT.L	D2
	MOVE.L	D2,D5
	CMP.W	#$0001,D6
	BNE.B	L00C21

	MOVE.W	-$531C(A4),D3
	AND.W	#$0003,D3
	BNE.B	L00C21

	ADDQ.L	#1,D5
L00C21:
	CMP.L	D5,D4
	BLT.B	L00C22

	SUB.L	D5,D4
	ADDQ.W	#1,D6
	CMP.W	#$000C,D6
	BLT.B	L00C20
L00C22:
	MOVE.W	D6,-$531E(A4)
	MOVE.W	D4,-$5320(A4)
	LEA	-$5326(A4),A6
	MOVE.L	A6,D0

	MOVEM.L	(A7)+,D4-D6
	UNLK	A5
	RTS

_time:
	LINK	A5,#-$002C
	CLR.L	-(A7)

	PEA	-$002C(A5)
	PEA	$0001
	PEA	L00C25(PC)	;"timer.device"
	JSR	_OpenDevice
	LEA	$0010(A7),A7

	TST.W	D0
	BEQ.B	L00C23

	PEA	L00C26(PC)	;"timer is not available"
	JSR	_printf
	ADDQ.W	#4,A7

	MOVE.W	#$0001,-(A7)
	JSR	_exit
	ADDQ.W	#2,A7
L00C23:
	CLR.L	-(A7)
	CLR.L	-(A7)
	JSR	_CreatePort(PC)
	ADDQ.W	#8,A7

	MOVE.L	D0,-$001E(A5)
	MOVE.W	#$000A,-$0010(A5)

	PEA	-$002C(A5)
	JSR	_DoIO(PC)
	ADDQ.W	#4,A7

	MOVE.L	-$0008(A5),D0
	ADD.L	#$0007A120,D0	;500000
	MOVE.L	#$000F4240,D1	;1000000
	JSR	_divu
	ADD.L	-$000C(A5),D0
	MOVE.L	D0,-$0004(A5)

	PEA	-$002C(A5)
	JSR	_CloseDevice(PC)
	ADDQ.W	#4,A7

	MOVE.L	-$001E(A5),-(A7)
	JSR	_DeletePort(PC)
	ADDQ.W	#4,A7

	TST.L	$0008(A5)
	BEQ.B	L00C24

	MOVEA.L	$0008(A5),A6
	MOVE.L	-$0004(A5),(A6)
L00C24:
	MOVE.L	-$0004(A5),D0
	UNLK	A5
	RTS

L00C25:	dc.b	"timer.device",0
L00C26:	dc.b	"timer is not available",10,0,0

_printf:
	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)

	LEA	-$530E(A4),A6
	MOVE.L	A6,-$5312(A4)
	PEA	$000C(A5)
	MOVE.L	$0008(A5),-(A7)
	PEA	L00C29(PC)
	JSR	_format(PC)
	LEA	$000C(A7),A7
	MOVE.W	D0,D4
	CMPI.W	#$0001,-$5764(A4)
	BNE.B	L00C27

	LEA	-$530E(A4),A6
	MOVE.L	-$5312(A4),D3
	SUB.L	A6,D3
	MOVE.W	D3,-(A7)
	PEA	-$530E(A4)
	MOVE.B	-$5767(A4),D3
	EXT.W	D3
	MOVE.W	D3,-(A7)
	JSR	_write
	ADDQ.W	#8,A7
	BRA.B	L00C28
L00C27:
	PEA	-$5774(A4)
	LEA	-$530E(A4),A6
	MOVE.L	-$5312(A4),D3
	SUB.L	A6,D3
	MOVE.W	D3,-(A7)
	MOVE.W	#$0001,-(A7)
	PEA	-$530E(A4)
	JSR	_fwrite(PC)
	LEA	$000C(A7),A7
L00C28:
	MOVE.W	D4,D0
	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

L00C29:
	LINK	A5,#-$0000
	MOVEA.L	-$5312(A4),A6
	ADDQ.L	#1,-$5312(A4)
	MOVE.B	$0009(A5),(A6)
	LEA	-$530E(A4),A6
	MOVE.L	-$5312(A4),D3
	SUB.L	A6,D3
	CMP.W	#$0028,D3
	BNE.B	L00C2C
	CMPI.W	#$0001,-$5764(A4)
	BNE.B	L00C2A
	LEA	-$530E(A4),A6
	MOVE.L	-$5312(A4),D3
	SUB.L	A6,D3
	MOVE.W	D3,-(A7)
	PEA	-$530E(A4)
	MOVE.B	-$5767(A4),D3
	EXT.W	D3
	MOVE.W	D3,-(A7)
	JSR	_write
	ADDQ.W	#8,A7
	BRA.B	L00C2B
L00C2A:
	PEA	-$5774(A4)
	LEA	-$530E(A4),A6
	MOVE.L	-$5312(A4),D3
	SUB.L	A6,D3
	MOVE.W	D3,-(A7)
	MOVE.W	#$0001,-(A7)
	PEA	-$530E(A4)
	JSR	_fwrite(PC)
	LEA	$000C(A7),A7
L00C2B:
	LEA	-$530E(A4),A6
	MOVE.L	A6,-$5312(A4)
L00C2C:
	MOVE.W	$0008(A5),D0
	AND.W	#$00FF,D0
	UNLK	A5
	RTS

L00C2D:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2,-(A7)
	MOVEA.L	$000E(A5),A2
	CMPI.W	#$0004,$0012(A5)
	BNE.B	L00C2E
	MOVEA.L	$0008(A5),A6
	MOVE.L	(A6),D4
	BRA.B	L00C30
L00C2E:
	CMPI.W	#$0000,$000C(A5)
	BLE.B	L00C2F
	MOVEA.L	$0008(A5),A6
	MOVEQ	#$00,D3
	MOVE.W	(A6),D3
	MOVE.L	D3,D4
	BRA.B	L00C30
L00C2F:
	MOVEA.L	$0008(A5),A6
	MOVE.W	(A6),D3
	EXT.L	D3
	MOVE.L	D3,D4
L00C30:
	CLR.W	$0012(A5)
	CMPI.W	#$0000,$000C(A5)
	BGE.B	L00C31
	NEG.W	$000C(A5)
	CMP.L	#$00000000,D4
	BGE.B	L00C31
	NEG.L	D4
	MOVE.W	#$0001,$0012(A5)
L00C31:
	SUBQ.L	#1,A2
	MOVE.L	D4,D0
	MOVE.W	$000C(A5),D1
	EXT.L	D1
	JSR	_modu(PC)
	LEA	-$579C(A4),A6
	MOVE.B	$00(A6,D0.W),(A2)
	MOVE.L	D4,D0
	MOVE.W	$000C(A5),D1
	EXT.L	D1
	JSR	_divu
	MOVE.L	D0,D4
;	TST.L	D0
	BNE.B	L00C31
	TST.W	$0012(A5)
	BEQ.B	L00C32
	SUBQ.L	#1,A2
	MOVE.B	#$2D,(A2)
L00C32:
	MOVE.L	A2,D0
	MOVEM.L	(A7)+,D4/A2
	UNLK	A5
	RTS

_format:
	LINK	A5,#-$00DE
	MOVEM.L	D4/A2/A3,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVEA.L	$000C(A5),A3
	CLR.W	-$0006(A5)
	MOVE.L	$0010(A5),-$0004(A5)
L00C33:
	MOVEA.L	A3,A6
	ADDQ.L	#1,A3
	MOVE.B	(A6),D3
	EXT.W	D3
	MOVE.W	D3,D4
;	TST.W	D3
	BEQ.W	L00C5E

	CMP.W	#$0025,D4
	BNE.W	L00C5B

	CLR.B	-$00D0(A5)
	MOVE.W	#1,-$0008(A5)
	MOVE.W	#32,-$000A(A5)
	MOVE.W	#10000,-$000C(A5)
	MOVEA.L	A3,A6
	ADDQ.L	#1,A3
	MOVE.B	(A6),D3
	EXT.W	D3
	MOVE.W	D3,D4
	CMP.W	#$002D,D3
	BNE.B	L00C34

	CLR.W	-$0008(A5)
	MOVEA.L	A3,A6
	ADDQ.L	#1,A3
	MOVE.B	(A6),D3
	EXT.W	D3
	MOVE.W	D3,D4
L00C34:
	CMP.W	#$0030,D4	;'0'
	BNE.B	L00C35

	MOVE.W	#$0030,-$000A(A5)
	MOVEA.L	A3,A6
	ADDQ.L	#1,A3
	MOVE.B	(A6),D3
	EXT.W	D3
	MOVE.W	D3,D4
L00C35:
	CMP.W	#$002A,D4	;'*'
	BNE.B	L00C36

	MOVEA.L	-$0004(A5),A6
	ADDQ.L	#2,-$0004(A5)
	MOVE.W	(A6),-$000E(A5)
	MOVEA.L	A3,A6
	ADDQ.L	#1,A3
	MOVE.B	(A6),D3
	EXT.W	D3
	MOVE.W	D3,D4
	BRA.B	L00C39
L00C36:
	CLR.W	-$000E(A5)
	BRA.B	L00C38
L00C37:
	MOVE.W	-$000E(A5),D3
	MULU.W	#$000A,D3
	ADD.W	D4,D3
	SUB.W	#$0030,D3
	MOVE.W	D3,-$000E(A5)
	MOVEA.L	A3,A6
	ADDQ.L	#1,A3
	MOVE.B	(A6),D3
	EXT.W	D3
	MOVE.W	D3,D4
L00C38:
	LEA	-$55CA(A4),A6		;_ctp_
	moveq	#$0004,D2
	AND.B	$00(A6,D4.W),D2
	BNE.B	L00C37
L00C39:
	CMP.W	#$002E,D4	;'.'
	BNE.B	L00C3D

	MOVEA.L	A3,A6
	ADDQ.L	#1,A3
	MOVE.B	(A6),D3
	EXT.W	D3
	MOVE.W	D3,D4
	CMP.W	#$002A,D3	;'*'
	BNE.B	L00C3A

	MOVEA.L	-$0004(A5),A6
	ADDQ.L	#2,-$0004(A5)
	MOVE.W	(A6),-$000C(A5)
	MOVEA.L	A3,A6
	ADDQ.L	#1,A3
	MOVE.B	(A6),D3
	EXT.W	D3
	MOVE.W	D3,D4
	BRA.B	L00C3D
L00C3A:
	CLR.W	-$000C(A5)
	BRA.B	L00C3C
L00C3B:
	MOVE.W	-$000C(A5),D3
	MULU.W	#$000A,D3
	ADD.W	D4,D3
	SUB.W	#$0030,D3
	MOVE.W	D3,-$000C(A5)
	MOVEA.L	A3,A6
	ADDQ.L	#1,A3
	MOVE.B	(A6),D3
	EXT.W	D3
	MOVE.W	D3,D4
L00C3C:
	LEA	-$55CA(A4),A6		;_ctp_
	moveq	#$0004,D2
	AND.B	$00(A6,D4.W),D2
	BNE.B	L00C3B
L00C3D:
	MOVE.W	#$0002,-$0010(A5)
	CMP.W	#$006C,D4		;'l' long
	BNE.B	L00C3E

	MOVEA.L	A3,A6
	ADDQ.L	#1,A3
	MOVE.B	(A6),D3
	EXT.W	D3
	MOVE.W	D3,D4
	MOVE.W	#$0004,-$0010(A5)
	BRA.B	L00C3F
L00C3E:
	CMP.W	#$0068,D4	;'h' hex
	BNE.B	L00C3F

	MOVEA.L	A3,A6
	ADDQ.L	#1,A3
	MOVE.B	(A6),D3
	EXT.W	D3
	MOVE.W	D3,D4
L00C3F:
	MOVE.W	D4,D0
;	EXT.L	D0
	BRA.B	L00C48
L00C40:
	MOVE.W	#$0008,-$0012(A5)
	BRA.B	L00C44
L00C41:
	MOVE.W	#$000A,-$0012(A5)
	BRA.B	L00C44
L00C42:
	MOVE.W	#$0010,-$0012(A5)
	BRA.B	L00C44
L00C43:
	MOVE.W	#$FFF6,-$0012(A5)
L00C44:
	MOVE.W	-$0010(A5),-(A7)
	PEA	-$00D0(A5)
	MOVE.W	-$0012(A5),-(A7)
	MOVE.L	-$0004(A5),-(A7)
	JSR	L00C2D(PC)
	LEA	$000C(A7),A7
	MOVE.L	D0,-$0016(A5)
	MOVE.W	-$0010(A5),D3
	EXT.L	D3
	ADD.L	D3,-$0004(A5)
	BRA.B	L00C49
L00C45:
	MOVEA.L	-$0004(A5),A6
	ADDQ.L	#4,-$0004(A5)
	MOVE.L	(A6),-$0016(A5)
	MOVE.L	-$0016(A5),A0
	JSR	_strlenquick

	MOVE.W	D0,-$0010(A5)
	BRA.B	L00C4A
L00C46:
	MOVEA.L	-$0004(A5),A6
	ADDQ.L	#2,-$0004(A5)
	MOVE.W	(A6),D4
L00C47:
	LEA	-$00D1(A5),A6
	MOVE.L	A6,-$0016(A5)
	MOVE.B	D4,(A6)
	BRA.B	L00C49
L00C48:
	SUB.w	#$0063,D0	;'c' char
	BEQ.B	L00C46
	SUBQ.w	#1,D0		;'d' decimal
	BEQ.B	L00C43
	SUB.w	#$000B,D0	;'p' pointer
	BEQ.W	L00C40
	SUBQ.w	#4,D0		;'u' unsigned word
	BEQ.B	L00C45
	SUBQ.w	#2,D0		;'w' word
	BEQ.W	L00C41
	SUBQ.w	#3,D0		;'z' long?
	BEQ.W	L00C42
	BRA.B	L00C47
L00C49:
	LEA	-$00D0(A5),A6
	SUBA.L	-$0016(A5),A6
	MOVE.W	A6,-$0010(A5)
L00C4A:
	MOVE.W	-$0010(A5),D3
	CMP.W	-$000C(A5),D3
	BLE.B	L00C4B
	MOVE.W	-$000C(A5),-$0010(A5)
L00C4B:
	TST.W	-$0008(A5)
	BEQ.B	L00C52

	MOVEA.L	-$0016(A5),A6
	MOVE.B	(A6),D3
	EXT.W	D3

	CMP.W	#$002D,D3	;'-'
	BEQ.B	L00C4C

	CMP.W	#$002B,D3	;'+'
	BNE.B	L00C4E
L00C4C:
	CMPI.W	#$0030,-$000A(A5)	;'0'
	BNE.B	L00C4E

	SUBQ.W	#1,-$000E(A5)
	MOVEA.L	-$0016(A5),A6
	ADDQ.L	#1,-$0016(A5)
	MOVE.B	(A6),D3
	EXT.W	D3
	MOVE.W	D3,-(A7)
	JSR	(A2)
	ADDQ.W	#2,A7
	CMP.W	#$FFFF,D0
	BNE.B	L00C4E

	MOVEQ	#-$01,D0
L00C4D:
	MOVEM.L	(A7)+,D4/A2/A3
	UNLK	A5
	RTS

L00C4E:
	BRA.B	L00C51
L00C4F:
	MOVE.W	-$000A(A5),-(A7)
	JSR	(A2)
	ADDQ.W	#2,A7
	CMP.W	#$FFFF,D0
	BNE.B	L00C50

	MOVEQ	#-$01,D0
	BRA.B	L00C4D
L00C50:
	ADDQ.W	#1,-$0006(A5)
L00C51:
	MOVE.W	-$000E(A5),D3
	SUBQ.W	#1,-$000E(A5)
	CMP.W	-$0010(A5),D3
	BGT.B	L00C4F
L00C52:
	CLR.W	-$0012(A5)
	BRA.B	L00C55
L00C53:
	MOVEA.L	-$0016(A5),A6
	ADDQ.L	#1,-$0016(A5)
	MOVE.B	(A6),D3
	EXT.W	D3
	MOVE.W	D3,-(A7)
	JSR	(A2)
	ADDQ.W	#2,A7
	CMP.W	#$FFFF,D0
	BNE.B	L00C54
	MOVEQ	#-$01,D0
	BRA.B	L00C4D
L00C54:
	ADDQ.W	#1,-$0012(A5)
L00C55:
	MOVEA.L	-$0016(A5),A6
	TST.B	(A6)
	BEQ.B	L00C56
	MOVE.W	-$0012(A5),D3
	CMP.W	-$000C(A5),D3
	BLT.B	L00C53
L00C56:
	MOVE.W	-$0012(A5),D3
	ADD.W	D3,-$0006(A5)
	TST.W	-$0008(A5)
	BNE.B	L00C5A
	BRA.B	L00C59
L00C57:
	MOVE.W	#$0020,-(A7)
	JSR	(A2)
	ADDQ.W	#2,A7
	CMP.W	#$FFFF,D0
	BNE.B	L00C58
	MOVEQ	#-$01,D0
	BRA.W	L00C4D
L00C58:
	ADDQ.W	#1,-$0006(A5)
L00C59:
	MOVE.W	-$000E(A5),D3
	SUBQ.W	#1,-$000E(A5)
	CMP.W	-$0010(A5),D3
	BGT.B	L00C57
L00C5A:
	BRA.B	L00C5D
L00C5B:
	MOVE.W	D4,-(A7)
	JSR	(A2)
	ADDQ.W	#2,A7
	CMP.W	#$FFFF,D0
	BNE.B	L00C5C
	MOVEQ	#-$01,D0
	BRA.W	L00C4D
L00C5C:
	ADDQ.W	#1,-$0006(A5)
L00C5D:
	BRA.W	L00C33
L00C5E:
	MOVE.W	-$0006(A5),D0
	BRA.W	L00C4D

_mods:
	MOVE.L	D4,-(A7)
	CLR.L	D4
	TST.L	D0
	BPL.B	L00C63
	NEG.L	D0
	ADDQ.W	#1,D4
L00C63:
	TST.L	D1
	BPL.B	L00C64
	NEG.L	D1
	EORI.W	#$0001,D4
L00C64:
	BSR.B	_divu
	MOVE.L	D1,D0
	TST.W	D4
	BEQ.B	L00C62
	NEG.L	D0
L00C62:
	MOVE.L	(A7)+,D4
	RTS

_modu:
	BSR.B	_divu
	MOVE.L	D1,D0
	RTS

_divu:
	MOVEM.L	D2/D3,-(A7)
	SWAP	D1
	TST.W	D1
	BNE.B	L00C66
	SWAP	D1
	CLR.W	D3
	DIVU.W	D1,D0
	BVC.B	L00C65
	MOVE.W	D0,D2
	CLR.W	D0
	SWAP	D0
	DIVU.W	D1,D0
	MOVE.W	D0,D3
	MOVE.W	D2,D0
	DIVU.W	D1,D0
L00C65:
	MOVE.L	D0,D1
	SWAP	D0
	MOVE.W	D3,D0
	SWAP	D0
	CLR.W	D1
	SWAP	D1
	MOVEM.L	(A7)+,D2/D3
	RTS

L00C66:
	SWAP	D1
	CLR.L	D2
	MOVEQ	#$1F,D3
L00C67:
	ASL.L	#1,D0
	ROXL.L	#1,D2
	SUB.L	D1,D2
	BMI.B	L00C6A
L00C68:
	ADDQ.L	#1,D0
	DBF	D3,L00C67
	BRA.B	L00C6B
L00C69:
	ASL.L	#1,D0
	ROXL.L	#1,D2
	ADD.L	D1,D2
	BPL.B	L00C68
L00C6A:
	DBF	D3,L00C69
	ADD.L	D1,D2
L00C6B:
	MOVE.L	D2,D1
	MOVEM.L	(A7)+,D2/D3
	RTS

_fwrite:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5/A2,-(A7)
	MOVEA.L	$0008(A5),A2
	MOVE.W	$000C(A5),D5
	MULU.W	$000E(A5),D5
	MOVEQ	#$00,D4
	BRA.B	L00C6F
L00C6C:
	MOVE.L	$0010(A5),-(A7)
	MOVEA.L	A2,A6
	ADDQ.L	#1,A2
	MOVE.B	(A6),D3
	EXT.W	D3
	MOVE.W	D3,-(A7)
	JSR	_putc(PC)
	ADDQ.W	#6,A7
	CMP.W	#$FFFF,D0
	BNE.B	L00C6E

	MOVEQ	#$00,D0
L00C6D:
	MOVEM.L	(A7)+,D4/D5/A2
	UNLK	A5
	RTS

L00C6E:
	ADDQ.W	#1,D4
L00C6F:
	CMP.W	D5,D4
	BCS.B	L00C6C
	MOVE.W	$000E(A5),D0
	BRA.B	L00C6D

_putc:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVEA.L	$000A(A5),A2
	MOVEA.L	(A2),A6
	CMPA.L	$0004(A2),A6
	BCS.B	L00C71

	MOVE.W	$0008(A5),D3
	AND.W	#$00FF,D3
	MOVE.W	D3,-(A7)
	MOVE.L	A2,-(A7)
	JSR	_flsh_(PC)
	ADDQ.W	#6,A7
L00C70:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L00C71:
	MOVEA.L	(A2),A6
	ADDQ.L	#1,(A2)
	MOVE.B	$0009(A5),D0
	MOVE.B	D0,(A6)
;	EXT.W	D0
	AND.W	#$00FF,D0
	BRA.B	L00C70

; callback for flsh

L00C72:
;	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	LEA	-$578A(A4),A2	;_Cbuffs
L00C73:
	MOVE.L	A2,-(A7)
	BSR.B	_fclose
	ADDQ.W	#4,A7

	ADDA.L	#$00000016,A2

	LEA	-$55D2(A4),A6	;_cls_
	CMPA.L	A6,A2
	BCS.B	L00C73

	MOVEA.L	(A7)+,A2
;	UNLK	A5
	RTS

_fclose:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2,-(A7)

	MOVEA.L	$0008(A5),A2
	MOVEQ	#$00,D4
	MOVE.L	A2,D3
	BNE.B	L00C75

	MOVEQ	#-$01,D0
L00C74:
	MOVEM.L	(A7)+,D4/A2
	UNLK	A5
	RTS

L00C75:
	TST.B	$000C(A2)
	BEQ.B	L00C78

	MOVE.B	$000C(A2),D3
;	EXT.W	D3
	AND.W	#$0004,D3
	BEQ.B	L00C76

	MOVE.W	#$FFFF,-(A7)
	MOVE.L	A2,-(A7)
	BSR.B	_flsh_
	ADDQ.W	#6,A7
	MOVE.W	D0,D4
L00C76:
	MOVE.B	$000D(A2),D3
	EXT.W	D3
	MOVE.W	D3,-(A7)
	JSR	_close
	ADDQ.W	#2,A7
	OR.W	D0,D4
	MOVE.B	$000C(A2),D3
;	EXT.W	D3
	AND.W	#$0002,D3
	BEQ.B	L00C77

	MOVE.L	$0008(A2),-(A7)
	JSR	_free
	ADDQ.W	#4,A7
L00C77:
	MOVE.B	$000C(A2),D3
;	EXT.W	D3
	AND.W	#$0020,D3
	BEQ.B	L00C78

	MOVE.L	$0012(A2),-(A7)
	JSR	_unlink(PC)
	ADDQ.W	#4,A7
	MOVE.L	$0012(A2),-(A7)
	JSR	_free
	ADDQ.W	#4,A7
L00C78:
	CLR.L	(A2)
	CLR.L	$0004(A2)
	CLR.L	$0008(A2)
	CLR.B	$000C(A2)
	MOVE.W	D4,D0
	BRA.B	L00C74

_flsh_:
	LINK	A5,#-$0002
	MOVEM.L	D4/A2,-(A7)

	MOVEA.L	$0008(A5),A2
	LEA	L00C72(PC),A6
	MOVE.L	A6,-$55D2(A4)	;_cls_
	MOVE.B	$000C(A2),D3
;	EXT.W	D3
	AND.W	#$0010,D3
	BEQ.B	L00C7A

	MOVEQ	#-$01,D0
L00C79:
	MOVEM.L	(A7)+,D4/A2
	UNLK	A5
	RTS

L00C7A:
	MOVE.B	$000C(A2),D3
;	EXT.W	D3
	AND.W	#$0004,D3
	BEQ.B	L00C7C

	MOVE.L	(A2),D3
	SUB.L	$0008(A2),D3
	MOVE.W	D3,D4

	MOVE.W	D4,-(A7)
	MOVE.L	$0008(A2),-(A7)
	MOVE.B	$000D(A2),D3
	EXT.W	D3
	MOVE.W	D3,-(A7)
	JSR	_write
	ADDQ.W	#8,A7

	CMP.W	D4,D0
	BEQ.B	L00C7C
L00C7B:
	ORI.B	#$10,$000C(A2)
	CLR.L	(A2)
	CLR.L	$0004(A2)
	MOVEQ	#-$01,D0
	BRA.B	L00C79
L00C7C:
	CMPI.W	#$FFFF,$000C(A5)
	BNE.B	L00C7D

	ANDI.B	#$FB,$000C(A2)
	CLR.L	(A2)
	CLR.L	$0004(A2)
	MOVEQ	#$00,D0
	BRA.B	L00C79
L00C7D:
	TST.L	$0008(A2)
	BNE.B	L00C7E

	MOVE.L	A2,-(A7)
	JSR	_getbuff(PC)
	ADDQ.W	#4,A7
L00C7E:
	CMPI.W	#$0001,$0010(A2)
	BNE.B	L00C7F

	MOVE.B	$000D(A5),-$0001(A5)
	MOVE.W	#$0001,-(A7)
	PEA	-$0001(A5)
	MOVE.B	$000D(A2),D3
	EXT.W	D3
	MOVE.W	D3,-(A7)
	JSR	_write
	ADDQ.W	#8,A7
	CMP.W	#$0001,D0
	BNE.B	L00C7B

	MOVE.W	$000C(A5),D0
	BRA.W	L00C79
L00C7F:
	MOVE.L	$0008(A2),(A2)
	MOVE.W	$0010(A2),D3
	EXT.L	D3
	ADD.L	$0008(A2),D3
	MOVE.L	D3,$0004(A2)
	ORI.B	#$04,$000C(A2)
	MOVEA.L	(A2),A6
	ADDQ.L	#1,(A2)
	MOVE.B	$000D(A5),D0
	MOVE.B	D0,(A6)
;	EXT.W	D0
	AND.W	#$00FF,D0
	BRA.W	L00C79

;_newstream:
;;	LINK	A5,#-$0000
;	MOVE.L	A2,-(A7)
;	LEA	-$578A(A4),A2	;_Cbuffs
;	LEA	-$55D2(A4),A6	;_cls_
;
;1$	TST.B	$000C(A2)
;	BEQ.B	3$
;	ADDA.L	#$00000016,A2
;	CMPA.L	A6,A2
;	BCS.B	1$
;
;	MOVEQ	#$00,D0
;2$
;	MOVEA.L	(A7)+,A2
;;	UNLK	A5
;	RTS
;
;3$	MOVE.L	A2,D0
;	CLR.L	(A2)+
;	CLR.L	(A2)+
;	CLR.L	(A2)+
;	BRA.B	2$

_getbuff:
	LINK	A5,#-$0004
	MOVE.L	A2,-(A7)
	MOVEA.L	$0008(A5),A2
	MOVE.B	$000D(A2),D3
	EXT.W	D3
	MOVE.W	D3,-(A7)
	JSR	_isatty(PC)
	ADDQ.W	#2,A7
	TST.W	D0
	BEQ.B	L00C86
L00C84:
	MOVE.W	#$0001,$0010(A2)
	MOVE.L	A2,D3
	ADD.L	#$0000000E,D3
	MOVE.L	D3,$0008(A2)
L00C85:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L00C86:
	MOVE.W	#$0400,-(A7)
	JSR	_malloc
	ADDQ.W	#2,A7
	MOVE.L	D0,-$0004(A5)
;	TST.L	D0
	BEQ.B	L00C84
	MOVE.W	#$0400,$0010(A2)
	ORI.B	#$02,$000C(A2)
	MOVE.L	-$0004(A5),$0008(A2)
	BRA.B	L00C85

; callback routine for freemem?

L00C87:
	LINK	A5,#-$0000
	MOVEM.L	A2/A3,-(A7)
	MOVEA.L	-$52E6(A4),A2
	BRA.B	L00C89
L00C88:
	MOVEA.L	(A2),A3
	MOVEA.L	$0004(A2),A6
	PEA	$0008(A6)
	MOVE.L	A2,-(A7)
	JSR	_FreeMem(PC)
	ADDQ.W	#8,A7
	MOVEA.L	A3,A2
L00C89:
	MOVE.L	A2,D3
	BNE.B	L00C88
	CLR.L	-$52E6(A4)
	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

; 32bit memory allocation

_lmalloc2:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	LEA	L00C87(PC),A6
	MOVE.L	A6,-$55CE(A4)	;__cln
	move.l	#2,-(a7)	; chip memory

	MOVEA.L	$0008(A5),A6
	PEA	$0008(A6)
	JSR	_AllocMem(PC)
	ADDQ.W	#8,A7

	MOVEA.L	D0,A2
	TST.L	D0
	BNE.B	L00C8B

	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

_lmalloc:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	LEA	L00C87(PC),A6
	MOVE.L	A6,-$55CE(A4)	;__cln
	CLR.L	-(A7)		; any sort of memory

	MOVEA.L	$0008(A5),A6
	PEA	$0008(A6)
	JSR	_AllocMem(PC)
	ADDQ.W	#8,A7

	MOVEA.L	D0,A2
	TST.L	D0
	BNE.B	L00C8B

L00C8A:
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

L00C8B:
	MOVE.L	-$52E6(A4),(A2)
	MOVE.L	$0008(A5),$0004(A2)
	MOVE.L	A2,-$52E6(A4)
	MOVE.L	A2,D0
	ADDQ.L	#8,D0
	BRA.B	L00C8A

; 16bit memory allocation

_malloc:
;	LINK	A5,#-$0000
	MOVEQ	#$00,D3
;	MOVE.W	$0008(A5),D3
	move.w	$0004(A7),D3

	MOVE.L	D3,-(A7)
	BSR.B	_lmalloc
	ADDQ.W	#4,A7
;	UNLK	A5
	RTS

_free:
	LINK	A5,#-$0000
	MOVEM.L	A2/A3,-(A7)
	SUBA.L	A3,A3
	MOVEA.L	-$52E6(A4),A2
	BRA.B	L00C8D
L00C8C:
	MOVEA.L	$0008(A5),A6
	SUBQ.L	#8,A6
	CMPA.L	A2,A6
	BEQ.B	L00C8F

	MOVEA.L	A2,A3
	MOVEA.L	(A2),A2
L00C8D:
	MOVE.L	A2,D3
	BNE.B	L00C8C

	MOVEQ	#-$01,D0
L00C8E:
	MOVEM.L	(A7)+,A2/A3
	UNLK	A5
	RTS

L00C8F:
	MOVE.L	A3,D3
	BEQ.B	L00C90
	MOVE.L	(A2),(A3)
	BRA.B	L00C91
L00C90:
	MOVE.L	(A2),-$52E6(A4)
L00C91:
	MOVEA.L	$0004(A2),A6
	PEA	$0008(A6)
	MOVE.L	A2,-(A7)
	JSR	_FreeMem(PC)
	ADDQ.W	#8,A7
	MOVEQ	#$00,D0
	BRA.B	L00C8E

_isatty:
	LINK	A5,#-$0000
	MOVE.W	$0008(A5),D3
	MULS.W	#$0006,D3
	LEA	-$4758(A4),A6		;__devtab
	MOVE.L	$00(A6,D3.L),-(A7)
	JSR	_IsInteractive(PC)
	ADDQ.W	#4,A7
;	TST.L	D0
;	BEQ.B	L00C92
;	MOVE.W	#$0001,D0
;	BRA.B	L00C93
;L00C92:
;	CLR.W	D0
;L00C93:
	UNLK	A5
	RTS

_unlink:
;	LINK	A5,#-$0000
	MOVE.L	$0004(A7),-(A7)
	JSR	_DeleteFile(PC)
	ADDQ.W	#4,A7
	TST.L	D0
	BNE.B	L00C95
	JSR	_IoErr(PC)
	MOVE.W	D0,-$46E0(A4)	;_errno
	MOVEQ	#-$01,D0
L00C94:
;	UNLK	A5
	RTS

L00C95:
	MOVEQ	#$00,D0
	BRA.B	L00C94

_write:
	LINK	A5,#-$0000
	MOVEM.L	D4/D5/A2,-(A7)
	MOVE.W	$0008(A5),D4
	JSR	_Chk_Abort(PC)
	MOVE.W	D4,D3
	BLT.B	L00C96

	MULS.W	#$0006,D3
	LEA	-$4758(A4),A2		;__devtab
	ADDA.L	D3,A2

	CMP.W	#$0013,D4
	BGT.B	L00C96

	TST.L	(A2)
	BNE.B	L00C98
L00C96:
	MOVE.W	#$0003,-$46E0(A4)	;_errno
L00C97b:
	MOVEQ	#-$01,D0
L00C97:
	MOVEM.L	(A7)+,D4/D5/A2
	UNLK	A5
	RTS

L00C98:
	MOVE.W	$0004(A2),D3
	AND.W	#$0003,D3
	BNE.B	L00C99

	MOVE.W	#$0006,-$46E0(A4)	;_errno
	BRA.B	L00C97b
L00C99:
	MOVEQ	#$00,D3
	MOVE.W	$000E(A5),D3
	MOVE.L	D3,-(A7)
	MOVE.L	$000A(A5),-(A7)
	MOVE.L	(A2),-(A7)
	JSR	_Write(PC)
	LEA	$000C(A7),A7
	CMP.L	#$FFFFFFFF,D0
	BNE.B	L00C97

	JSR	_IoErr(PC)
	MOVE.W	D0,-$46E0(A4)	;_errno
	BRA.B	L00C97b

_Chk_Abort:
	LINK	A5,#-$0004

	PEA	$1000
	CLR.L	-(A7)
	JSR	_SetSignal(PC)
	ADDQ.W	#8,A7

	MOVE.L	D0,-$0004(A5)
	AND.L	#$00001000,D0
	BNE.B	L00C9C

	MOVEQ	#$00,D0
L00C9B:
	UNLK	A5
	RTS

L00C9C:
	TST.W	-$46DE(A4)
	BNE.B	L00C9D
	MOVE.L	-$0004(A5),D0
	BRA.B	L00C9B
L00C9D:
	PEA	$0004
	PEA	L00C9E(PC)
	JSR	_Output(PC)
	MOVE.L	D0,-(A7)
	JSR	_Write(PC)
	LEA	$000C(A7),A7
	MOVE.W	#$0001,-(A7)
	JSR	_exit
	ADDQ.W	#2,A7
	BRA.B	L00C9B
L00C9E:
	dc.b	"^C",10,0

_exit:
	LINK	A5,#-$0000
	TST.L	-$55D2(A4)	;_cls_
	BEQ.B	L00C9F
	MOVEA.L	-$55D2(A4),A6	;_cls_
	JSR	(A6)
L00C9F:
	MOVE.W	$0008(A5),-(A7)
	JSR	__exit(PC)
	ADDQ.W	#2,A7
	UNLK	A5
	RTS

__main:
	LINK	A5,#-$0004
	MOVEM.L	D4-D6/A2/A3,-(A7)
	PEA	$001F			;version 31
	PEA	L00CAF(PC)		; dos.library
	JSR	_OpenLibrary(PC)
	ADDQ.W	#8,A7
	MOVE.L	D0,-$46DC(A4)		;_DOSBase
;	TST.L	D0
;	BNE.B	L00CA1
	bne	L00CA2		; no need for mathffp.library

	CLR.L	-(A7)
	PEA	$00038007
	JSR	_Alert(PC)
	ADDQ.W	#8,A7
L00CA0:
	MOVEA.L	-$4760(A4),A7		;__savsp
	RTS

;L00CA1:
;	PEA	$001F			;version 31
;	PEA	L00CB0(PC)		;mathffp.library
;	JSR	__OpenLibrary(PC)
;	ADDQ.W	#8,A7
;	MOVE.L	D0,-$46D8(A4)
;;	TST.L	D0
;	BNE.B	L00CA2
;	CLR.L	-(A7)
;	PEA	$00038005
;	JSR	_Alert(PC)
;	ADDQ.W	#8,A7
;	BRA.B	L00CA0
L00CA2:
	CLR.L	-(A7)
	JSR	_FindTask(PC)
	ADDQ.W	#4,A7
	MOVEA.L	D0,A3
	TST.L	$00AC(A3)
	BEQ.W	L00CAB

	MOVE.L	$00AC(A3),D3
	ASL.L	#2,D3
	MOVE.L	D3,D5
	MOVEA.L	D5,A6
	MOVE.L	$0010(A6),D3
	ASL.L	#2,D3
	MOVEA.L	D3,A2
	MOVE.B	(A2),D3
	EXT.W	D3
	EXT.L	D3
	ADD.L	$0008(A5),D3
	ADDQ.L	#2,D3
	MOVE.W	D3,-$52E0(A4)
	CLR.L	-(A7)
	MOVE.W	-$52E0(A4),D3
	EXT.L	D3
	MOVE.L	D3,-(A7)
	JSR	_AllocMem(PC)
	ADDQ.W	#8,A7
	MOVE.L	D0,-$52DA(A4)
	MOVE.B	(A2),D3
	EXT.W	D3
	MOVE.W	D3,-(A7)
	PEA	$0001(A2)
	MOVE.L	-$52DA(A4),-(A7)
	JSR	_strncpy
	LEA	$000A(A7),A7
	PEA	L00CB1(PC)
	MOVE.B	(A2),D3
	EXT.W	D3
	EXT.L	D3
	ADD.L	-$52DA(A4),D3
	MOVE.L	D3,-(A7)
	JSR	_strcpy
	ADDQ.W	#8,A7
	MOVE.W	$000A(A5),D3
	ADDQ.W	#1,D3
	MOVE.W	D3,-(A7)
	MOVE.L	$000C(A5),-(A7)
	MOVE.L	-$52DA(A4),-(A7)
	JSR	_strncat(PC)
	LEA	$000A(A7),A7
	CLR.W	-$52E2(A4)
	MOVEA.L	-$52DA(A4),A2
L00CA3:
	moveq	#0,d3
	LEA	-$55CA(A4),A6		;_ctp_

1$	MOVE.B	(A2),D3
	moveq	#$0010,D2
	AND.B	$00(A6,D3.W),D2
	BEQ.B	L00CA4
	ADDQ.L	#1,A2
	BRA.B	1$
L00CA4:
	MOVE.B	(A2),D3
;	EXT.W	D3
	CMP.b	#$20,D3		;' '
	BLT.B	L00CA7

	LEA	-$55CA(A4),A6		;_ctp_
	moveq	#0,d4
1$
	MOVE.B	(A2),D4
	BEQ.B	L00CA6
	moveq	#$0010,D2
	AND.B	$00(A6,D4.W),D2
	BNE.B	L00CA6
	ADDQ.L	#1,A2
	BRA.B	1$
L00CA6:
	MOVEA.L	A2,A6
	ADDQ.L	#1,A2
	CLR.B	(A6)
	TST.W	D4
	BEQ.B	L00CA7
	ADDQ.W	#1,-$52E2(A4)
	BRA.B	L00CA3
L00CA7:
	CLR.B	(A2)
	CLR.L	-(A7)
	MOVE.W	-$52E2(A4),D3
	ADDQ.W	#1,D3
	EXT.L	D3
	ASL.L	#2,D3
	MOVE.L	D3,-(A7)
	JSR	_AllocMem
	ADDQ.W	#8,A7
	MOVE.L	D0,-$52DE(A4)
	MOVEQ	#$00,D4
	MOVEA.L	-$52DA(A4),A2
	BRA.B	L00CAA

L00CA8:
	moveq	#0,d3
	LEA	-$55CA(A4),A6		;_ctp_

1$	MOVE.B	(A2),D3
	moveq	#$0010,D2
	AND.B	$00(A6,D3.W),D2
	BEQ.B	L00CA9
	ADDQ.L	#1,A2
	BRA.B	1$
L00CA9:
	MOVEQ	#$00,D3
	MOVE.W	D4,D3
	ASL.L	#2,D3
	MOVEA.L	-$52DE(A4),A6
	MOVE.L	A2,$00(A6,D3.L)
	MOVE.L	A2,A0
	JSR	_strlenquick

	ADDQ.W	#1,D0
	EXT.L	D0
	ADDA.L	D0,A2
	ADDQ.W	#1,D4
L00CAA:
	CMP.W	-$52E2(A4),D4
	BCS.B	L00CA8
	MOVEQ	#$00,D3
	MOVE.W	D4,D3
	ASL.L	#2,D3
	MOVEA.L	-$52DE(A4),A6
	CLR.L	$00(A6,D3.L)
	JSR	_Input
	MOVE.L	D0,-$4758(A4)		;__devtab
	MOVE.W	#$8000,-$4754(A4)
	JSR	_Output(PC)
	MOVE.L	D0,-$4752(A4)
	MOVE.W	#$8001,-$474E(A4)
	JSR	_Output
	MOVE.L	D0,-$474C(A4)
	MOVE.W	#$8001,-$4748(A4)
	MOVE.W	#$0001,-$46DE(A4)	;_Enable_Abort
	MOVE.L	-$52DE(A4),-(A7)
	MOVE.W	-$52E2(A4),-(A7)
	JSR	_main
	ADDQ.W	#6,A7
	CLR.W	-(A7)
	JSR	__exit
	ADDQ.W	#2,A7
	BRA.W	L00CAE
L00CAB:
	PEA	$005C(A3)
	JSR	_WaitPort
	ADDQ.W	#4,A7
	PEA	$005C(A3)
	JSR	_GetMsg
	ADDQ.W	#4,A7
	MOVE.L	D0,-$52D6(A4)
	MOVEA.L	-$52D6(A4),A6
	TST.L	$0024(A6)
	BEQ.B	L00CAC
	MOVEA.L	-$52D6(A4),A6
	MOVEA.L	$0024(A6),A1
	MOVE.L	(A1),-(A7)
	JSR	_CurrentDir
	ADDQ.W	#4,A7
L00CAC:
	MOVEA.L	-$52D6(A4),A6
	TST.L	$0020(A6)
	BEQ.B	L00CAD

	PEA	$03ED
	MOVEA.L	-$52D6(A4),A6
	MOVE.L	$0020(A6),-(A7)
	JSR	_Open
	ADDQ.W	#8,A7
	MOVE.L	D0,-$4758(A4)		;__devtab
;	TST.L	D0
	BEQ.B	L00CAD

	MOVE.L	D0,D3
	MOVE.L	D3,-$474C(A4)
	MOVE.L	D3,-$4752(A4)
	MOVE.W	#$8000,-$4754(A4)
	MOVE.W	#$8001,-$4748(A4)
	MOVE.W	#$8001,-$474E(A4)
	ASL.L	#2,D3
	MOVE.L	D3,-$0004(A5)
	MOVEA.L	-$0004(A5),A6
	MOVE.L	$0008(A6),$00A4(A3)
L00CAD:
	MOVE.L	-$52D6(A4),-(A7)
	CLR.W	-(A7)
	JSR	_main
	ADDQ.W	#6,A7
	CLR.W	-(A7)
	BSR.B	__exit
	ADDQ.W	#2,A7
L00CAE:
	MOVEM.L	(A7)+,D4-D6/A2/A3
	UNLK	A5
	RTS

L00CAF:	dc.b	"dos.library",0
;L00CB0:	dc.b	"mathffp.library",0
L00CB1:	dc.b	" ",0

__exit:
	LINK	A5,#-$0002
	CLR.W	-$0002(A5)
L00CB2:
	MOVE.W	-$0002(A5),-(A7)
	JSR	_close
	ADDQ.W	#2,A7
	ADDQ.W	#1,-$0002(A5)
	CMPI.W	#$000A,-$0002(A5)
	BLT.B	L00CB2

	TST.L	-$55CE(A4)	;__cln
	BEQ.B	L00CB3

	MOVEA.L	-$55CE(A4),A6	;__cln
	JSR	(A6)
L00CB3:
;	TST.L	-$46D4(A4)		;_MathTransBase
;	BEQ.B	L00CB4
;	MOVE.L	-$46D4(A4),-(A7)
;	JSR	_CloseLibrary(PC)
;	ADDQ.W	#4,A7
L00CB4:
;	TST.L	-$46D8(A4)		;_MathBase
;	BEQ.B	L00CB5
;	MOVE.L	-$46D8(A4),-(A7)
;	JSR	_CloseLibrary(PC)
;	ADDQ.W	#4,A7
L00CB5:
	TST.L	-$52D6(A4)
	BNE.B	L00CB6

	MOVE.W	-$52E0(A4),D3
	EXT.L	D3
	MOVE.L	D3,-(A7)
	MOVE.L	-$52DA(A4),-(A7)
	JSR	_FreeMem
	ADDQ.W	#8,A7

	MOVE.W	-$52E2(A4),D3
	ADDQ.W	#1,D3
	EXT.L	D3
	ASL.L	#2,D3
	MOVE.L	D3,-(A7)
	MOVE.L	-$52DE(A4),-(A7)
	JSR	_FreeMem(PC)
	ADDQ.W	#8,A7

	MOVE.W	$0008(A5),D3
	EXT.L	D3
	MOVE.L	D3,-(A7)
	JSR	_Exit
	ADDQ.W	#4,A7
	BRA.B	L00CB7
L00CB6:
	JSR	_Forbid
	MOVE.L	-$52D6(A4),-(A7)
	JSR	_ReplyMsg
	ADDQ.W	#4,A7
	MOVE.L	$0008(A5),D0
	MOVEA.L	-$4760(A4),A7		;__savsp
	RTS

L00CB7:
	UNLK	A5
	RTS

_strcat:
	MOVEq	#-1,D0
	BRA.B	L00CB8
_strncat:
	MOVE.W	$000C(A7),D0
L00CB8:
	MOVEA.L	$0004(A7),A0

1$	TST.B	(A0)+
	BNE.B	1$

	SUBQ.W	#1,A0
	MOVEA.L	$0008(A7),A1
	SUBQ.W	#1,D0

2$	MOVE.B	(A1)+,(A0)+
	DBEQ	D0,2$

	CLR.B	-(A0)
	MOVE.L	$0004(A7),D0
	RTS

_strcpy:
	MOVEA.L	$0004(A7),A0
	MOVEA.L	$0008(A7),A1
	moveq	#-1,d0

1$	MOVE.B	(A1)+,(A0)+
	DBEQ	d0,1$

	MOVE.L	$0004(A7),D0
	RTS

_strlenquick:
	moveq	#-1,d0

1$	tst.b	(a0)+
	dbeq	d0,1$

	neg.w	d0
	subq.w	#1,d0
	rts

;_strlen:
;	MOVEA.L	$0004(A7),A0
;	MOVE.L	A0,D0
;
;1$	TST.B	(A0)+
;	BNE.B	1$
;
;	SUBA.L	D0,A0
;	MOVE.L	A0,D0
;	SUBQ.L	#1,D0
;	RTS

_strncpy:
	MOVEM.L	$0004(A7),A0/A1
	MOVE.L	A0,D0
	MOVE.W	$000C(A7),D1
	BRA.B	L00CBE
L00CBD:
	MOVE.B	(A1)+,(A0)+
L00CBE:
	DBEQ	D1,L00CBD
	ADDQ.W	#1,D1
	BRA.B	L00CC0
L00CBF:
	CLR.B	(A0)+
L00CC0:
	DBF	D1,L00CBF
	RTS

_close:
	LINK	A5,#-$0000
	MOVEM.L	D4-D6/A2,-(A7)

	MOVE.W	$0008(A5),D4
	MOVE.W	D4,D3
	BLT.B	L00CC1

	MULS.W	#$0006,D3
	LEA	-$4758(A4),A2		;__devtab
	ADDA.L	D3,A2

	CMP.W	#$0013,D4
	BGT.B	L00CC1

	TST.L	(A2)
	BNE.B	L00CC3
L00CC1:
	MOVE.W	#$0003,-$46E0(A4)	;_errno
	MOVEQ	#-$01,D0
L00CC2:
	MOVEM.L	(A7)+,D4-D6/A2
	UNLK	A5
	RTS

L00CC3:
	MOVE.W	$0004(A2),D3
	AND.W	#$8000,D3
	BNE.B	L00CC4

	MOVE.L	(A2),-(A7)
	JSR	_Close
	ADDQ.W	#4,A7
L00CC4:
	CLR.L	(A2)
	MOVEQ	#$00,D0
	BRA.B	L00CC2

_Close:
	MOVE.L	$0004(A7),D1
	MOVEA.L	-$46DC(A4),A6	;_DOSBase
	JMP	_LVOClose(A6)
_CurrentDir:
	MOVE.L	$0004(A7),D1
	MOVEA.L	-$46DC(A4),A6	;_DOSBase
	JMP	_LVOCurrentDir(A6)
_DateStamp:
	MOVE.L	$0004(A7),D1
	MOVEA.L	-$46DC(A4),A6	;_DOSBase
	JMP	_LVODateStamp(A6)
_DeleteFile:
	MOVE.L	$0004(A7),D1
	MOVEA.L	-$46DC(A4),A6	;_DOSBase
	JMP	_LVODeleteFile(A6)
_Exit:
	MOVE.L	$0004(A7),D1
	MOVEA.L	-$46DC(A4),A6	;_DOSBase
	JMP	_LVOExit(A6)
_Input:
	MOVEA.L	-$46DC(A4),A6	;_DOSBase
	JMP	_LVOInput(A6)
_IoErr:
	MOVEA.L	-$46DC(A4),A6	;_DOSBase
	JMP	_LVOIoErr(A6)
_IsInteractive:
	MOVE.L	$0004(A7),D1
	MOVEA.L	-$46DC(A4),A6	;_DOSBase
	JMP	_LVOIsInteractive(A6)
_Lock:
	MOVEM.L	$0004(A7),D1/D2
	MOVEA.L	-$46DC(A4),A6	;_DOSBase
	JMP	_LVOLock(A6)
_Open:
	MOVEM.L	$0004(A7),D1/D2
	MOVEA.L	-$46DC(A4),A6	;_DOSBase
	JMP	_LVOOpen(A6)
_Output:
	MOVEA.L	-$46DC(A4),A6	;_DOSBase
	JMP	_LVOOutput(A6)
_Read:
	MOVEM.L	$0004(A7),D1-D3
	MOVEA.L	-$46DC(A4),A6	;_DOSBase
	JMP	_LVORead(A6)
_Seek:
	MOVEM.L	$0004(A7),D1-D3
	MOVEA.L	-$46DC(A4),A6	;_DOSBase
	JMP	_LVOSeek(A6)
_UnLock:
	MOVE.L	$0004(A7),D1
	MOVEA.L	-$46DC(A4),A6	;_DOSBase
	JMP	_LVOUnLock(A6)
_Write:
	MOVEM.L	$0004(A7),D1-D3
	MOVEA.L	-$46DC(A4),A6	;_DOSBase
	JMP	_LVOWrite(A6)

_Alert:
	MOVEM.L	D7/A5,-(A7)
	MOVEM.L	$000C(A7),D7/A5
	MOVEA.L	-$475C(A4),A6		;_SysBase
	JSR	_LVOAlert(A6)
	MOVEM.L	(A7)+,D7/A5
	RTS
_CloseDevice:
	MOVEA.L	$0004(A7),A1
	MOVEA.L	-$475C(A4),A6		;_SysBase
	JMP	_LVOCloseDevice(A6)
_CloseLibrary:
	MOVEA.L	$0004(A7),A1
	MOVEA.L	-$475C(A4),A6		;_SysBase
	JMP	_LVOCloseLibrary(A6)

_CreatePort:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2,-(A7)
	PEA	-$1
	JSR	_AllocSignal(PC)
	ADDQ.W	#4,A7
	MOVE.L	D0,D4
	CMP.L	#$FFFFFFFF,D0
	BNE.B	L00CC6
	MOVEQ	#$00,D0
L00CC5:
	MOVEM.L	(A7)+,D4/A2
	UNLK	A5
	RTS

L00CC6:
	PEA	$00010001
	PEA	$0022
	JSR	_AllocMem(PC)
	ADDQ.W	#8,A7
	MOVEA.L	D0,A2
	TST.L	D0
	BNE.B	L00CC7
	MOVE.L	D4,-(A7)
	JSR	_FreeSignal(PC)
	ADDQ.W	#4,A7
	MOVEQ	#$00,D0
	BRA.B	L00CC5
L00CC7:
	MOVE.L	$0008(A5),$000A(A2)
	MOVE.B	$000F(A5),$0009(A2)
	MOVE.B	#$04,$0008(A2)
	CLR.B	$000E(A2)
	MOVE.B	D4,$000F(A2)
	CLR.L	-(A7)
	JSR	_FindTask(PC)
	ADDQ.W	#4,A7
	MOVE.L	D0,$0010(A2)
	TST.L	$0008(A5)
	BEQ.B	L00CC8
	MOVE.L	A2,-(A7)
	JSR	_AddPort(PC)
	ADDQ.W	#4,A7
	BRA.B	L00CC9
L00CC8:
	PEA	$0014(A2)
	JSR	_NewList(PC)
	ADDQ.W	#4,A7
L00CC9:
	MOVE.L	A2,D0
	BRA.B	L00CC5

_DeletePort:
	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)
	MOVEA.L	$0008(A5),A2
	TST.L	$000A(A2)
	BEQ.B	L00CCA
	MOVE.L	A2,-(A7)
	JSR	_RemPort(PC)
	ADDQ.W	#4,A7
L00CCA:
	MOVE.B	#$FF,$0008(A2)
	MOVE.L	#$FFFFFFFF,$0014(A2)
	MOVEQ	#$00,D3
	MOVE.B	$000F(A2),D3
	MOVE.L	D3,-(A7)
	JSR	_FreeSignal(PC)
	ADDQ.W	#4,A7
	PEA	$0022
	MOVE.L	A2,-(A7)
	JSR	_FreeMem(PC)
	ADDQ.W	#8,A7
	MOVEA.L	(A7)+,A2
	UNLK	A5
	RTS

_AddPort:
	MOVEA.L	$0004(A7),A1
	MOVEA.L	-$475C(A4),A6		;_SysBase
	JMP	_LVOAddPort(A6)
_AllocSignal:
	MOVE.L	$0004(A7),D0
	MOVEA.L	-$475C(A4),A6		;_SysBase
	JMP	_LVOAllocSignal(A6)
_AllocMem:
	MOVEM.L	$0004(A7),D0/D1
	MOVEA.L	-$475C(A4),A6		;_SysBase
	JMP	_LVOAllocMem(A6)
_DoIO:
	MOVEA.L	$0004(A7),A1
	MOVEA.L	-$475C(A4),A6		;_SysBase
	JMP	_LVODoIO(A6)
_FindTask:
	MOVEA.L	$0004(A7),A1
	MOVEA.L	-$475C(A4),A6		;_SysBase
	JMP	_LVOFindTask(A6)
_Forbid:
	MOVEA.L	-$475C(A4),A6		;_SysBase
	JMP	_LVOForbid(A6)
_FreeMem:
	MOVEA.L	$0004(A7),A1
	MOVE.L	$0008(A7),D0
	MOVEA.L	-$475C(A4),A6		;_SysBase
	JMP	_LVOFreeMem(A6)
_FreeSignal:
	MOVE.L	$0004(A7),D0
	MOVEA.L	-$475C(A4),A6		;_SysBase
	JMP	_LVOFreeSignal(A6)
_GetMsg:
	MOVEA.L	$0004(A7),A0
	MOVEA.L	-$475C(A4),A6		;_SysBase
	JMP	_LVOGetMsg(A6)

_NewList:
	MOVEA.L	$0004(A7),A0
	MOVE.L	A0,(A0)
	ADDQ.L	#4,(A0)
	CLR.L	$0004(A0)
	MOVE.L	A0,$0008(A0)
	RTS

_OpenDevice:
	MOVEA.L	$0004(A7),A0
	MOVEM.L	$0008(A7),D0/A1
	MOVE.L	$0010(A7),D1
	MOVEA.L	-$475C(A4),A6		;_SysBase
	JMP	_LVOOpenDevice(A6)
_OpenLibrary:
	MOVEA.L	-$475C(A4),A6		;_SysBase
	MOVEA.L	$0004(A7),A1
	MOVE.L	$0008(A7),D0
	JMP	_LVOOpenLibrary(A6)
_Permit:
	MOVEA.L	-$475C(A4),A6		;_SysBase
	JMP	_LVOPermit(A6)
_Remove:
	MOVEA.L	$0004(A7),A1
	MOVEA.L	-$475C(A4),A6		;_SysBase
	JMP	_LVORemove(A6)
_RemPort:
	MOVEA.L	$0004(A7),A1
	MOVEA.L	-$475C(A4),A6		;_SysBase
	JMP	_LVORemPort(A6)
_ReplyMsg:
	MOVEA.L	$0004(A7),A1
	MOVEA.L	-$475C(A4),A6		;_SysBase
	JMP	_LVOReplyMsg(A6)
_SetSignal:
	MOVEM.L	$0004(A7),D0/D1
	MOVEA.L	-$475C(A4),A6		;_SysBase
	JMP	_LVOSetSignal(A6)
_WaitPort:
	MOVEA.L	$0004(A7),A0
	MOVEA.L	-$475C(A4),A6		;_SysBase
	JMP	_LVOWaitPort(A6)

;_BltBitMap:
;	MOVEM.L	D4-D7/A2,-(A7)
;	MOVEA.L	$0018(A7),A0
;	MOVEM.L	$001C(A7),D0/D1/A1
;	MOVEM.L	$0028(A7),D2-D7/A2
;	MOVEA.L	-$5184(A4),A6	;_GfxBase
;	JSR	_LVOBltBitMap(A6)
;	MOVEM.L	(A7)+,D4-D7/A2
;	RTS
_ClearEOL:
	MOVEA.L	$0004(A7),A1
	MOVEA.L	-$5184(A4),A6	;_GfxBase
	JMP	_LVOClearEOL(A6)
_ClearScreen:
	MOVEA.L	$0004(A7),A1
	MOVEA.L	-$5184(A4),A6	;_GfxBase
	JMP	_LVOClearScreen(A6)
_InitBitMap:
	MOVEA.L	$0004(A7),A0
	MOVEM.L	$0008(A7),D0-D2
	MOVEA.L	-$5184(A4),A6	;_GfxBase
	JMP	_LVOInitBitMap(A6)
_GfxMove:
	MOVEA.L	$0004(A7),A1
	MOVEM.L	$0008(A7),D0/D1
	MOVEA.L	-$5184(A4),A6	;_GfxBase
	JMP	_LVOMove(A6)

_RectFill:
	MOVEA.L	$0004(A7),A1
	MOVEM.L	$0008(A7),D0-D3
	MOVEA.L	-$5184(A4),A6	;_GfxBase
	JMP	_LVORectFill(A6)

_SetAPen:
	MOVEA.L	$0004(A7),A1
	MOVE.L	$0008(A7),D0
	MOVEA.L	-$5184(A4),A6	;_GfxBase
	JMP	_LVOSetAPen(A6)

_SetDrMd:
	MOVEA.L	$0004(A7),A1
	MOVE.L	$0008(A7),D0
	MOVEA.L	-$5184(A4),A6	;_GfxBase
	JMP	_LVOSetDrMd(A6)

_SetRGB4:
;	MOVEA.L	$0004(A7),A0
;	MOVEM.L	$0008(A7),D0-D3
;	MOVEA.L	-$5184(A4),A6	;_GfxBase
;	JMP	_LVOSetRGB4(A6)

_TextLength:
	MOVEA.L	$0004(A7),A1
	MOVEA.L	$0008(A7),A0
	MOVE.L	$000C(A7),D0
	MOVEA.L	-$5184(A4),A6	;_GfxBase
	JMP	_LVOTextLength(A6)

_AddGadget:
	MOVEM.L	$0004(A7),A0/A1
	MOVE.L	$000C(A7),D0
	MOVEA.L	-$5188(A4),A6	;_IntuitionBase
	JMP	_LVOAddGadget(A6)

_AutoRequest:
	MOVEM.L	A2/A3,-(A7)
	MOVEM.L	$000C(A7),A0-A3
	MOVEM.L	$001C(A7),D0-D3
	MOVEA.L	-$5188(A4),A6	;_IntuitionBase
	JSR	_LVOAutoRequest(A6)
	MOVEM.L	(A7)+,A2/A3
	RTS

_ClearMenuStrip:
	MOVEA.L	$0004(A7),A0
	MOVEA.L	-$5188(A4),A6	;_IntuitionBase
	JMP	_LVOClearMenuStrip(A6)

_CloseScreen:
	MOVEA.L	$0004(A7),A0
	MOVEA.L	-$5188(A4),A6	;_IntuitionBase
	JMP	_LVOCloseScreen(A6)

_CloseWindow:
	MOVEA.L	$0004(A7),A0
	MOVEA.L	-$5188(A4),A6	;_IntuitionBase
	JMP	_LVOCloseWindow(A6)

_CurrentTime:
	MOVEM.L	$0004(A7),A0/A1
	MOVEA.L	-$5188(A4),A6	;_IntuitionBase
	JMP	_LVOCurrentTime(A6)

_ItemAddress:
	MOVEA.L	$0004(A7),A0
	MOVE.L	$0008(A7),D0
	MOVEA.L	-$5188(A4),A6	;_IntuitionBase
	JMP	_LVOItemAddress(A6)

_ModifyIDCMP:
	MOVEA.L	$0004(A7),A0
	MOVE.L	$0008(A7),D0
	MOVEA.L	-$5188(A4),A6	;_IntuitionBase
	JMP	_LVOModifyIDCMP(A6)

_OnGadget:
	MOVE.L	A2,-(A7)
	MOVEM.L	$0008(A7),A0-A2
	MOVEA.L	-$5188(A4),A6	;_IntuitionBase
	JSR	_LVOOnGadget(A6)
	MOVEA.L	(A7)+,A2
	RTS

_OpenScreen:
	MOVEA.L	$0004(A7),A0
	MOVEA.L	-$5188(A4),A6	;_IntuitionBase
	JMP	_LVOOpenScreen(A6)

_OpenWindow:
	MOVEA.L	$0004(A7),A0
	MOVEA.L	-$5188(A4),A6	;_IntuitionBase
	JMP	_LVOOpenWindow(A6)

;_PrintIText:
;	MOVEM.L	$0004(A7),A0/A1
;	MOVEM.L	$000C(A7),D0/D1
;	MOVEA.L	-$5188(A4),A6	;_IntuitionBase
;	JMP	_LVOPrintIText(A6)

_RefreshGadgets:
	MOVE.L	A2,-(A7)
	MOVEM.L	$0008(A7),A0-A2
	MOVEA.L	-$5188(A4),A6	;_IntuitionBase
	JSR	_LVORefreshGadgets(A6)
	MOVEA.L	(A7)+,A2
	RTS

_SetMenuStrip:
	MOVEM.L	$0004(A7),A0/A1
	MOVEA.L	-$5188(A4),A6	;_IntuitionBase
	JMP	_LVOSetMenuStrip(A6)

_SetWindowTitles:
	MOVE.L	A2,-(A7)
	MOVEM.L	$0008(A7),A0-A2
	MOVEA.L	-$5188(A4),A6	;_IntuitionBase
	JSR	_LVOSetWindowTitles(A6)
	MOVEA.L	(A7)+,A2
	RTS

_WBenchToBack:
	MOVEA.L	-$5188(A4),A6	;_IntuitionBase
	JMP	_LVOWBenchToBack(A6)

_WBenchToFront:
	MOVEA.L	-$5188(A4),A6	;_IntuitionBase
	JMP	_LVOWBenchToBack(A6)

_RawKeyConvert:
	MOVE.L	A2,-(A7)
	MOVEM.L	$0008(A7),A0/A1
	MOVEM.L	$0010(A7),D1/A2
	MOVEA.L	-$48B6(A4),A6	;_ConsoleDevice
	JSR	-$0030(A6)
	MOVEA.L	(A7)+,A2
	RTS

	SECTION "",DATA       ;001 014640

__Dorg:

_ws_wand:
	dc.l	L00000		; wand
_ws_staff:
	dc.l	L00001		; staff
_rainbow:
	dc.l	L00003		; amber
	dc.l	L00004		; aquamarine
	dc.l	L00005		; black
	dc.l	L00006		; blue
	dc.l	L00007		; brown
	dc.l	L00008		; clear
	dc.l	L00009		; crimson
	dc.l	L0000A		; cyan
	dc.l	L0000B		; ecru
	dc.l	L0000C		; gold
	dc.l	L0000D		; gree
	dc.l	L0000E		; grey
	dc.l	L0000F		; magenta
	dc.l	L00010		; orange
	dc.l	L00011		; pink
	dc.l	L00012		; plaid
	dc.l	L00013		; purple
	dc.l	L00014		; red
	dc.l	L00015		; silver
	dc.l	L00016		; tan
	dc.l	L00017		; tangerine
	dc.l	L00018		; topaz
	dc.l	L00019		; turqoise
	dc.l	L0001A		; vermillion
	dc.l	L0001B		; violet
	dc.l	L0001C		; white
	dc.l	L0001D		; yellow

	ds.l	1		; UNUSED
	ds.l	1		; UNUSED

_stones:
	dc.l	L00020		; agate
	dc.w	$0019
	dc.l	L00021		; alexandrite
	dc.w	$0028
	dc.l	L00022		; amethyst
	dc.w	$0032
	dc.l	L00023		; carnelian
	dc.w	$0028
	dc.l	L00024		; diamond
	dc.w	$012C
	dc.l	L00025		; emerald
	dc.w	$012C
	dc.l	L00026		; germanium
	dc.w	$00E1
	dc.l	L00027		; granite
	dc.w	$0005
	dc.l	L00028		; garnet
	dc.w	$0032
	dc.l	L00029		; jade
	dc.w	$0096
	dc.l	L0002A		; kryptonite
	dc.w	$012C
	dc.l	L0002B		; lapis lazuli
	dc.w	$0032
	dc.l	L0002C		; moonstone
	dc.w	$0032
	dc.l	L0002D		; obsidian
	dc.w	$000F
	dc.l	L0002E		; onyx
	dc.w	$003C
	dc.l	L0002F		; opal
	dc.w	$00C8
	dc.l	L00030		; pearl
	dc.w	$00DC
	dc.l	L00031		; peridot
	dc.w	$003F
	dc.l	L00032		; ruby
	dc.w	$015E
	dc.l	L00033		; sapphire
	dc.w	$011D
	dc.l	L00034		; stibotantalite
	dc.w	$00C8
	dc.l	L00035		; tiger eye
	dc.w	$0032
	dc.l	L00036		; topaz
	dc.w	$003C
	dc.l	L00037		; turqoise
	dc.w	$0046
	dc.l	L00038		; taaffeite
	dc.w	$012C
	dc.l	L00039		; zircon
	dc.w	$0050
_wood:
	dc.l	L0003A		; avocado wood
	dc.l	L0003B		; balsa
	dc.l	L0003C		; bambo
	dc.l	L0003D		; banyan
	dc.l	L0003E		; birch
	dc.l	L0003F		; cedar
	dc.l	L00040		; cherry
	dc.l	L00041		; cinnibar
	dc.l	L00042		; cypress
	dc.l	L00043		; dogwood
	dc.l	L00044		; driftwood
	dc.l	L00045		; ebony
	dc.l	L00046		; elm
	dc.l	L00047		; eucalyptus
	dc.l	L00048		; fall
	dc.l	L00049		; hemlock
	dc.l	L0004A		; holly
	dc.l	L0004B		; ironwood
	dc.l	L0004C		; kukui wood
	dc.l	L0004D		; mahogany
	dc.l	L0004E		; manzanita
	dc.l	L0004F		; maple
	dc.l	L00050		; oaken
	dc.l	L00051		; persimmon wood
	dc.l	L00052		; pecan
	dc.l	L00053		; pine
	dc.l	L00054		; poplar
	dc.l	L00055		; redwood
	dc.l	L00056		; rosewood
	dc.l	L00057		; spruce
	dc.l	L00058		; teak
	dc.l	L00059		; walnut
	dc.l	L0005A		; zebrawood
_metal:
	dc.l	L0005B		; aluminum
	dc.l	L0005C		; beryllium
	dc.l	L0005D		; bone
	dc.l	L0005E		; brass
	dc.l	L0005F		; bronze
	dc.l	L00060		; copper
	dc.l	L00061		; electrum
	dc.l	L00062		; gold
	dc.l	L00063		; iron
	dc.l	L00064		; lead
	dc.l	L00065		; magnesium
	dc.l	L00066		; mercury
	dc.l	L00067		; nickel
	dc.l	L00068		; pewter
	dc.l	L00069		; platinum
	dc.l	L0006A		; steel
	dc.l	L0006B		; silver
	dc.l	L0006C		; silicon
	dc.l	L0006D		; tin
	dc.l	L0006E		; titanium
	dc.l	L0006F		; tungsten
	dc.l	L00070		; zinc
_MyFont:
	dc.l	L000FA
	dc.l	$00080001

_NewScreen:
	dc.w	0,0		;LeftEdge, TopEdge
	dc.w	640,200		;Width, Height
	dc.w	$0004		;Depth
	dc.b	$00,$01		;DetailPen, BlockPen
	dc.w	$8000		;ViewModes
	dc.w	$000F		;Type
	dc.l	_MyFont		;*Font
	dc.l	L000FB		;*DefaultTitle
	dc.l	$00000000	;*Gadgets
	dc.l	$00000000	;*CustomBitMap

_Window1:
	dc.w	0,12		;LeftEdge, TopEdge
	dc.w	640,188		;Width, Height
	dc.b	$00,$01		;DetailPen, BlockPen
	dc.l	$00002558	;IDCMPFlags
	dc.l	$00001A00	;Flags
	dc.l	$00000000	;*FirstGadget
	dc.l	$00000000	;*CheckMark
	dc.l	$00000000	;*Title
	dc.l	$00000000	;*Screen
	dc.l	$00000000	;*Bitmap
	dc.w	640,188		;MinWidth, MinHeight
	dc.w	640,188		;MaxWidth, MaxHeight
	dc.w	$000F		;Type

_Window2:
	dc.w	0,0		;LeftEdge, TopEdge
	dc.w	640,200		;Width, Height
	dc.b	$00,$01		;DetailPen, BlockPen
	dc.l	$00002558	;IDCMPFlags
	dc.l	$00001A00	;Flags
	dc.l	$00000000	;*FirstGadget
	dc.l	$00000000	;*CheckMark
	dc.l	$00000000	;*Title
	dc.l	$00000000	;*Screen
	dc.l	$00000000	;*Bitmap
	dc.w	640,200		;MinWidth, MinHeight
	dc.w	640,200		;MaxWidth, MaxHeight
	dc.w	$000F		;Type

	dc.l	$00000000

; struct IntuiText

_addch_text:
	dc.b	$01,$00		;FrontPen, BackPen
	dc.b	$01,$00		;DrawMode
	dc.w	$0000,$0000	;LeftEdge,TopEdge
	dc.l	_MyFont		;*ITextFont
	dc.l	$00000000	;*IText
	dc.l	$00000000	;*NextText

	dc.w	$0000

_laugh:		dc.l	L001A3		;"you hear maniacal laughter%s."
_in_dist:	dc.l	L001A4		;" in the distance"

	dc.l	$00000000
	dc.l	$00010001
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$01000100
	dc.l	$01000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00010000
	dc.l	$00010000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$01000000
	dc.l	$01000100
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00010001
	dc.l	$00010001
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000100
	dc.l	$01000000
	dc.l	$01000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000001
	dc.l	$00000001
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$01000100
	dc.l	$01000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00010001
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000

_CURSES_START:
	dc.w	$0000

_screen_map:	ds.b	1680

_c_row:	ds.b	1
_c_col:	ds.b	1

_map_up:
	dc.b	$01
_graphics_disabled:
	dc.b	$00		;disables itself if Rogue.Char file not present
_CURSES_END:
	dc.l	$0000FFFF

_my_palette:
	dc.l	$00000000	;black
	dc.l	$0F0F0F00	;white
	dc.l	$0C000000	;red
	dc.l	$0F060000
	dc.l	$00090000	;green
	dc.l	$030F0B00
	dc.l	$00000F00	;blue
	dc.l	$07020000
	dc.l	$0F000C00
	dc.l	$0A000F00
	dc.l	$0A030000
	dc.l	$0F0C0A00
	dc.l	$0F0E0000
	dc.l	$06090F00
	dc.l	$08080800	;light grey
	dc.l	$04040400	;dark grey

_hungry_state_texts:
	dc.l	L0051C		;"",0
	dc.l	L0051D		;"Hungry"
	dc.l	L0051E		;"Weak"
	dc.l	L0051F		;"Faint"

	dc.l	_dm_null
	dc.l	_foolish
	dc.l	_lose_vision
	dc.l	_doctor
	dc.l	_swander
	dc.l	_rollwand
	dc.l	_unconfuse
	dc.l	_unsee
	dc.l	_sight
	dc.l	_nohaste
	dc.l	_stomach
	dc.l	_runners
	dc.l	$00000000

_w_magic:
	dc.l	L005E8,L005E9	; mace
	dc.w	$6400,$0000

	dc.l	L005EA,L005EB	; broad sword
	dc.w	$6400,$0000

	dc.l	L005EC,L005ED	; short bow
	dc.w	$6400,$0000

	dc.l	L005EE,L005EF	; arrow (better with bow)
	dc.w	$0200,O_ISMANY|O_ISMISL

	dc.l	L005F0,L005F1	; dagger
	dc.w	$6400,O_ISMISL

	dc.l	L005F2,L005F3	; two handed sword
	dc.w	$6400,$0000

	dc.l	L005F4,L005F5	; dart
	dc.w	$6400,O_ISMANY|O_ISMISL

	dc.l	L005F6,L005F7	; crossbow
	dc.w	$6400,$0000

	dc.l	L005F8,L005F9	; crossbow bolts (better with crossbow)
	dc.w	$0700,O_ISMANY|O_ISMISL

	dc.l	L005FA,L005FB	; flail
	dc.w	$6400,$0000

_between:	dc.w	$0000

_revno:	dc.w	1
_verno:	dc.w	48

_w_names:
	dc.l	L006F8	; mace
	dc.l	L006F9	; broad sword
	dc.l	L006FA	; short bow
	dc.l	L006FB	; arrow
	dc.l	L006FC	; dagger
	dc.l	L006FD	; two handed sword
	dc.l	L006FE	; dart
	dc.l	L006FF	; crossbow
	dc.l	L00700	; crossbow bolt
	dc.l	L00701	; flail
	dc.l	$00000000

_a_names:
	dc.l	L00702	; leather armor
	dc.l	L00703	; ring mail
	dc.l	L00704	; studded leather armor
	dc.l	L00705	; scale mail
	dc.l	L00706	; chain mail
	dc.l	L00707	; splint mail
	dc.l	L00708	; banded mail
	dc.l	L00709	; plate mail

_a_chances:
	dc.w	20	; leather armor
	dc.w	35	; ring mail
	dc.w	50	; studded leather armor
	dc.w	63	; scale mail
	dc.w	75	; chain mail
	dc.w	85	; splint mail
	dc.w	95	; banded mail
	dc.w	100	; plate mail

_a_class:
	dc.w	$0008	; 3 leather armor
	dc.w	$0007	; 4 ring mail
	dc.w	$0007	; 4 studded leather armor
	dc.w	$0006	; 5 scale mail
	dc.w	$0005	; 6 chain mail
	dc.w	$0004	; 7 splint mail
	dc.w	$0004	; 7 banded mail
	dc.w	$0003	; 8 plate mail

_s_magic:
	dc.l	L0070A		; monster confusion
	dc.w	$0008,140
	dc.l	L0070B		; magic mapping
	dc.w	$0005,150
	dc.l	L0070C		; hold monster
	dc.w	$0003,180
	dc.l	L0070D		; sleep
	dc.w	$0005,5
	dc.l	L0070E		; enchant armor
	dc.w	$0008,160
	dc.l	L0070F		; identify
	dc.w	$001B,100
	dc.l	L00710		; scare monster
	dc.w	$0004,200
	dc.l	L00711		; wild magic
	dc.w	$0004,50
	dc.l	L00712		; teleportation
	dc.w	$0007,165
	dc.l	L00713		; enchant weapon
	dc.w	$000A,150
	dc.l	L00714		; create monster
	dc.w	$0005,75
	dc.l	L00715		; remove curse
	dc.w	$0008,105
	dc.l	L00716		; aggravate monster
	dc.w	$0004,20
	dc.l	L00717		; blank paper
	dc.w	$0001,5
	dc.l	L00718		; vorpalize weapon
	dc.w	$0001,300

_p_magic:
	dc.l	L00719		; confusion
	dc.w	$0008,5
	dc.l	L0071A		; paralysis
	dc.w	$000A,5
	dc.l	L0071B		; poison
	dc.w	$0008,5
	dc.l	L0071C		; gain strength
	dc.w	$000F,150
	dc.l	L0071D		; see invisible
	dc.w	$0002,100
	dc.l	L0071E		; healing
	dc.w	$000F,130
	dc.l	L0071F		; night vision
	dc.w	$0006,130
	dc.l	L00720		; discernment
	dc.w	$0006,105
	dc.l	L00721		; raise level
	dc.w	$0002,250
	dc.l	L00722		; extra healing
	dc.w	$0005,200
	dc.l	L00723		; haste self
	dc.w	$0004,190
	dc.l	L00724		; restore strength
	dc.w	$000E,130
	dc.l	L00725		; blindness
	dc.w	$0004,5
	dc.l	L00726		; thirst quenching
	dc.w	$0001,5

_r_magic:
	dc.l	L00727		; protection
	dc.w	$0009,400
	dc.l	L00728		; add strength
	dc.w	$0009,400
	dc.l	L00729		; sustain strength
	dc.w	$0005,280
	dc.l	L0072A		; searching
	dc.w	$000A,420
	dc.l	L0072B		; see invisible
	dc.w	$000A,310
	dc.l	L0072C		; adornment
	dc.w	$0001,10
	dc.l	L0072D		; aggravate monster
	dc.w	$000A,10
	dc.l	L0072E		; dexterity
	dc.w	$0008,440
	dc.l	L0072F		; increase damage
	dc.w	$0008,400
	dc.l	L00730		; regeneration
	dc.w	$0004,460
	dc.l	L00731		; slow digestion
	dc.w	$0009,240
	dc.l	L00732		; teleportation
	dc.w	$0005,30
	dc.l	L00733		; stealth
	dc.w	$0007,470
	dc.l	L00734		; maintain armor
	dc.w	$0005,380

_ws_magic:
	dc.l	L00735		; light
	dc.w	$000C,250
	dc.l	L00736		; striking
	dc.w	$0009,75
	dc.l	L00737		; lightning
	dc.w	$0003,330
	dc.l	L00738		; fire
	dc.w	$0003,330
	dc.l	L00739		; cold
	dc.w	$0003,330
	dc.l	L0073A		; polymorph
	dc.w	$000F,310
	dc.l	L0073B		; magic missile
	dc.w	$000A,170
	dc.l	L0073C		; haste monster
	dc.w	$0009,5
	dc.l	L0073D		; slow monster
	dc.w	$000B,350
	dc.l	L0073E		; drain life
	dc.w	$0009,300
	dc.l	L0073F		; nothing
	dc.w	$0001,5
	dc.l	L00740		; teleport away
	dc.w	$0005,340
	dc.l	L00741		; teleport to
	dc.w	$0005,50
	dc.l	L00742		; cancellation
	dc.w	$0005,280

_he_man:
	dc.l	L00743		; 0 ""
	dc.l	L00744		; 10 Guild Novice
	dc.l	L00745		; 20 Apprentice
	dc.l	L00746		; 40 Journeyman
	dc.l	L00747		; 80 Adventurer
	dc.l	L00748		; 160 Fighter
	dc.l	L00749		; 320 Warrior
	dc.l	L0074A		; 640 Rogue
	dc.l	L0074B		; 1280 Champion
	dc.l	L0074C		; 2560 Master Rogue
	dc.l	L0074D		; 5120 Warlord
	dc.l	L0074E		; 10240 Hero
	dc.l	L0074F		; 20480 Guild Master
	dc.l	L00750		; 40960 Dragonlord
	dc.l	L00751		; 81960 Wizard
	dc.l	L00752		; 163840 Rogue Geek
	dc.l	L00753		; 327680 Rogue Addict
	dc.l	L00754		; 655360 Schmendrick
	dc.l	L00755		; 1310720 Gunfighter
	dc.l	L00756		; 2621440 Time Waster
	dc.l	L00757		; 5242880 Bug Chaser
	dc.l	L00758		; 10485760 Penultimate Rogue
	dc.l	L00759		; 20971520 Ultimate Rogue

_nlevels:
	dc.w	$0017		; 23 user level
_your_na:
	dc.l	L0075A		; Software Pirate
_kild_by:
	dc.l	L0075B		; Copy Protection Mafia
_max_stats:
	dc.w	$0010		;24 start with 16 as strength
	dc.l	$0000		;26 experience points
	dc.w	$0001		;30 rank starts with 1
	dc.w	$000A		;32 base AC for swing calculation, seems not to change at all
	dc.w	$000C		;34 start with 12 hp
	dc.l	L0075C		;36 1d4
	dc.w	$000C		;40 max hp
_lvl_obj:
	dc.l	$00000000
_mlist:
	dc.l	$00000000

; 4=treasure, 6=flags, 8=strength, 10=EXP, 14=xd8 HP, 16=AC, 18=$1

_monsters:
	dc.l	L0075D		; #12 aquator, 7-17
	dc.w	$0000
	dc.w	C_ISMEAN	;flags
	dc.w	$000A
	dc.l	20		;EXP
	dc.w	5		;5d8
	dc.w	2		;AC 9
	dc.w	1
	dc.l	L0075E		;0d0/0d0
	dc.w	$0000

	dc.l	L0075F		; #3 bat, 0-8
	dc.w	$0000
	dc.w	C_ISFLY		;flags
	dc.w	$000A
	dc.l	1		;EXP
	dc.w	1		;1d8
	dc.w	3		;AC 8
	dc.w	1
	dc.l	L00760		;1d2
	dc.w	$0000

	dc.l	L00761		; #11 centaur, 6-15
	dc.w	$000F
	dc.w	0		;flags
	dc.w	$000A
	dc.l	25		;EXP
	dc.w	4		;4d8
	dc.w	4		;AC 7
	dc.w	1
	dc.l	L00762		;1d6/1d6
	dc.w	$0000

	dc.l	L00763		; #26 dragon, 21-...
	dc.w	$0064
	dc.w	C_ISMEAN	;flags
	dc.w	$000A
	dc.l	6800		;EXP
	dc.w	10		;10d8
	dc.w	-1		;AC 12
	dc.w	1
	dc.l	L00764		; 1d8/1d8/3d10
	dc.w	$0000

	dc.l	L00765		; #2 emu, 0-8
	dc.w	$0000
	dc.w	C_ISMEAN	;flags
	dc.w	$000A
	dc.l	2		;EXP
	dc.w	1		;1d8
	dc.w	7		;AC 4
	dc.w	1
	dc.l	L00766		; 1d2
	dc.w	$0000

	dc.l	L00767		; #18 venus flytrap, 13-23
	dc.w	$0000
	dc.w	C_ISMEAN	;flags
	dc.w	$000A
	dc.l	80		;EXP
	dc.w	8		;8d8
	dc.w	3		;AC 8
	dc.w	1
	dc.l	L00768		; %%%d0
	dc.w	$0000

	dc.l	L00769		; #21 griffin, 16-26
	dc.w	$0014
	dc.w	C_ISMEAN|C_ISFLY|C_ISREGEN	;flags
	dc.w	$000A
	dc.l	2000		;EXP
	dc.w	13		;13d8
	dc.w	2		;AC 9
	dc.w	1
	dc.l	L0076A		; 4d3/3d5/4d3
	dc.w	$0000

	dc.l	L0076B		; #4 hobgoblin, 0-9
	dc.w	$0000
	dc.w	C_ISMEAN	;flags
	dc.w	$000A
	dc.l	3		;EXP
	dc.w	1		;1d8
	dc.w	5		;AC 6
	dc.w	1
	dc.l	L0076C		; 1d8
	dc.w	$0000

	dc.l	L0076D		; #5 ice monster, 0-10
	dc.w	$0000
	dc.w	C_ISMEAN	;flags
	dc.w	$000A
	dc.l	15		;EXP
	dc.w	1		;1d8
	dc.w	9		;AC 2
	dc.w	1
	dc.l	L0076E		; 1d2
	dc.w	$0000

	dc.l	L0076F		; #25 jabberwock, 20-...
	dc.w	$0046
	dc.w	0		;flags
	dc.w	$000A
	dc.l	4000		;EXP
	dc.w	15		;15d8
	dc.w	6		;AC 5
	dc.w	1
	dc.l	L00770		; 2d12/2d4
	dc.w	$0000

	dc.l	L00771		; #1 kestral, 0-8
	dc.w	$0000
	dc.w	C_ISMEAN|C_ISFLY	;flags
	dc.w	$000A
	dc.l	1		;EXP
	dc.w	1		;1d8
	dc.w	7		;AC 4
	dc.w	1
	dc.l	L00772		; 1d4
	dc.w	$0000

	dc.l	L00773		; #10 leprechaun, 5-15
	dc.w	$0040
	dc.w	0		;flags
	dc.w	$000A
	dc.l	10		;EXP
	dc.w	3		;3d8
	dc.w	8		;AC 3
	dc.w	1
	dc.l	L00774		; 1d2
	dc.w	$0000

	dc.l	L00775		; #21 medusa, 17-...
	dc.w	$0028
	dc.w	C_ISMEAN	;flags
	dc.w	$000A
	dc.l	200		;EXP
	dc.w	8		;8d8
	dc.w	2		;AC 9
	dc.w	1
	dc.l	L00776		; 3d4/3d4
	dc.w	$0000

	dc.l	L00777		; #14 nymph, 9-19
	dc.w	$0064
	dc.w	0		;flags
	dc.w	$000A
	dc.l	37		;EXP
	dc.w	3		;3d8
	dc.w	9		;AC 2
	dc.w	1
	dc.l	L00778		; 0d0
	dc.w	$0000

	dc.l	L00779		; #7 orc, 2-12
	dc.w	$000F
	dc.w	C_ISGREED	;flags
	dc.w	$000A
	dc.l	5		;EXP
	dc.w	1		;1d8
	dc.w	6		;AC 5
	dc.w	1
	dc.l	L0077A		; 1d8
	dc.w	$0000

	dc.l	L0077B		; #19 phantom, 14-24
	dc.w	$0000
	dc.w	C_ISINVIS	;flags
	dc.w	$000A
	dc.l	120		;EXP
	dc.w	8		;8d8
	dc.w	3		;AC 8
	dc.w	1
	dc.l	L0077C		; 4d4
	dc.w	$0000

	dc.l	L0077D		; #13 quagga, 8-18
	dc.w	$001E
	dc.w	C_ISMEAN	;flags
	dc.w	$000A
	dc.l	32		;EXP
	dc.w	3		;3d8
	dc.w	2		;AC 9
	dc.w	1
	dc.l	L0077E		; 1d2/1d2/1d4
	dc.w	$0000

	dc.l	L0077F		; #8 rattlesnake, 4-14
	dc.w	$0000
	dc.w	C_ISMEAN	;flags
	dc.w	$000A
	dc.l	9		;EXP
	dc.w	2		;2d8
	dc.w	3		;AC 8
	dc.w	1
	dc.l	L00780		; 1d6
	dc.w	$0000

	dc.l	L00781		; #6 slime, 1-11
	dc.w	$0000
	dc.w	C_ISMEAN	;flags
	dc.w	$000A
	dc.l	1		;EXP
	dc.w	2		;2d8
	dc.w	8		;AC 3
	dc.w	1
	dc.l	L00782		; 1d3
	dc.w	$0000

	dc.l	L00783		; #16 troll, 11-21
	dc.w	$0032
	dc.w	C_ISMEAN|C_ISREGEN	;flags
	dc.w	$000A
	dc.l	120		;EXP
	dc.w	6		;6d8
	dc.w	4		;AC 7
	dc.w	1
	dc.l	L00784		; 1d8/1d8/2d6
	dc.w	$0000

	dc.l	L00785		; #20 ur-vile, 15-25
	dc.w	$0000
	dc.w	C_ISMEAN	;flags
	dc.w	$000A
	dc.l	190		;EXP
	dc.w	7		;7d8
	dc.w	-2		;AC 13
	dc.w	1
	dc.l	L00786		; 1d3/1d3/1d3/4d6
	dc.w	$0000

	dc.l	L00787		; #24 vampire, 19-...
	dc.w	$0014
	dc.w	C_ISMEAN|C_ISREGEN	;flags
	dc.w	$000A
	dc.l	350		;EXP
	dc.w	8		;8d8
	dc.w	1		;AC 10
	dc.w	1
	dc.l	L00788		; 1d10
	dc.w	$0000

	dc.l	L00789		; #17 wraith, 12-22
	dc.w	$0000
	dc.w	0		;flags
	dc.w	$000A
	dc.l	55		;EXP
	dc.w	5		;5d8
	dc.w	4		;AC 7
	dc.w	1
	dc.l	L0078A		; 1d6
	dc.w	$0000

	dc.l	L0078B		; #23 xeroc, 18-...
	dc.w	$001E
	dc.w	0		;flags
	dc.w	$000A
	dc.l	100		;EXP
	dc.w	7		;7d8
	dc.w	7		;AC 4
	dc.w	1
	dc.l	L0078C		; 3d4
	dc.w	$0000

	dc.l	L0078D		; #15 yeti, 10-20
	dc.w	$001E
	dc.w	0		;flags
	dc.w	$000A
	dc.l	50		;EXP
	dc.w	4		;4d8
	dc.w	6		;AC 5
	dc.w	1
	dc.l	L0078E		; 1d6/1d6
	dc.w	$0000

	dc.l	L0078F		; #9 zombie, 4-14
	dc.w	$0000
	dc.w	C_ISMEAN	;flags
	dc.w	$000A
	dc.l	6		;EXP
	dc.w	2		;2d8
	dc.w	8		;AC 3
	dc.w	1
	dc.l	L00790		; 1d8
	dc.w	$0000

_things:
	dc.l	$00000000
	dc.l	$001B0000
	dc.l	$00000000
	dc.l	$001E0000
	dc.l	$00000000
	dc.l	$00110000
	dc.l	$00000000
	dc.l	$00080000
	dc.l	$00000000
	dc.l	$00080000
	dc.l	$00000000
	dc.l	$00050000
	dc.l	$00000000
	dc.l	$00050000
_nullstr:
	dc.w	$0000
_typeahead:
	dc.l	_nullstr
_intense:
	dc.l	L00791		;" of intense white light"
_flash:
	dc.l	L00792		;"your %s gives off a flash%s"
_it:
	dc.l	L00793		;"it"
_you:
	dc.l	L00794		;"you"
_no_mem:
	dc.l	L00795		;"Not enough Memory"
_smsg:
	dc.l	L00796		;"  *** Stack Overflow ***",$d,10,"$"
_no_damage:
	dc.l	L00797		;"0d0"
_hero_damage:
	dc.l	L00798		;"1d4"
	dc.l	$FFFF0000
	dc.l	$00000001
	dc.l	$00010000
	dc.l	$0000FFFF
	dc.l	L00A0D
	dc.l	L00A0E
_commands:
	dc.l	L00A47		; Go Down Stairs
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	L00A48		; Go Up Stairs
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	L00A49		; Drop
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	L00A4A		; Eat
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	L00A4B		; Wield
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	L00A4C		; Read
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	L00A4D		; Quaf
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	L00A4E		; Put on ring
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	L00A4F		; Take ring off
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	L00A50		; Put armor on
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	L00A51		; Take armor off
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	L00A52		; Throw
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	L00A53		; Zap
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	L00A54
_game_items:
	dc.l	L00A55		; About Rogue
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	L00A56		; Save
	dc.l	$00045300	;"  S "
	dc.l	$00000000
	dc.l	$00000000
	dc.l	L00A57		; Restore
	dc.l	$00045200	;"  R "
	dc.l	$00000000
	dc.l	$00000000
	dc.l	L00A58		; Quit
	dc.l	$00045100	;"  Q "
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
_play_sub:
	dc.l	L00A59		; Disabled
	dc.l	$01054400	;"  D "
	dc.l	$00000002
	dc.l	$00000000
	dc.l	L00A5A		; Enabled
	dc.l	$00054500	;"  E "
	dc.l	$00000001
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
_on_off:
	dc.l	L00A5B		; Off
	dc.l	$01010000
	dc.l	$00000002
	dc.l	$00000000
	dc.l	L00A5C		; On
	dc.l	$00010000
	dc.l	$00000001
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
_inv_sub:
	dc.l	L00A5D		; Manual
	dc.l	$00054D00	;"  M "
	dc.l	$00000006
	dc.l	$00000000
	dc.l	L00A5E		; Automatic
	dc.l	$01054100	;"  A "
	dc.l	$00000005
	dc.l	$00000000
	dc.l	L00A5F		; Selective
	dc.l	$00055A00	;"  Z "
	dc.l	$00000003
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
_opt_items:
	dc.l	L00A60		; Fast Play
	dc.l	$00000000
	dc.l	$00000000
	dc.l	_play_sub
	dc.l	L00A61		; Inventory Style
	dc.l	$00000000
	dc.l	$00000000
	dc.l	_inv_sub
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
_menu_bar:
	dc.l	L00A62		; Game
	dc.w	$0000
	dc.l	_game_items
	dc.l	L00A63		; Options
	dc.w	$0000
	dc.l	_opt_items
	dc.l	L00A64		; Use
	dc.l	$00000000
	dc.w	$0000
	dc.l	L00A65		; Command
	dc.w	$0000
	dc.l	_commands
	dc.l	$00000000
	dc.l	$00000000
	dc.w	$0000

_mvt:	dc.b	"ykuhllbjn",0

_SV_START:
	dc.b	$00
_macro:
	dc.b	"v",0
	ds.b	22
_f_damage:
	ds.b	10
_whoami:
	dc.b	"Rodney",0
	ds.b	17
_fruit:
	dc.b	"Mango",0
	ds.b	18
_new_stats:
	dc.b	$00
_no_more_fears:
	dc.b	$00
_after:
	dc.b	$00
_noscore:
	dc.b	$00
_again:
	dc.b	$00

_s_know:	ds.b	15
_p_know:	ds.b	14
_r_know:	ds.b	14
_ws_know:	ds.b	14

_amulet:
	dc.b	$00
_saw_amulet:
	dc.b	$00
_door_stop:
	dc.b	$00
_fastmode:
	dc.b	$00
_faststate:
	dc.b	$00
_firstmove:
	dc.b	$00
_playing:
	dc.b	$01
_running:
	dc.b	$00
_save_msg:
	dc.b	$01
_was_trapped:
	dc.b	$00
_is_wizard:
	dc.b	$00
_terse:
	dc.b	$00
_com_from_menu:
	dc.b	$00
_want_click:
	dc.b	$00
_mouse_run:
	dc.b	$00
_wizard:
	dc.b	$00
_bailout:
	dc.b	$00
_db_enabled:
	dc.b	$01
_expert:
	dc.b	$00
_menu_style:
	dc.b	$01
_take:
	dc.b	$00
_runch:
	dc.w	$0000

_s_names:	ds.b	15*21
		dc.b	0

_s_guess:	ds.b	15*21
		dc.b	0

_p_guess:	ds.b	14*21
_r_guess:	ds.b	14*21
_ws_guess:	ds.b	14*21

_maxrow:
	dc.w	$0000
_max_level:
	dc.w	$0000
_ntraps:
	dc.w	$0000
_dnum:
	dc.w	$0000
_level:
	dc.w	$0001
_purse:
	dc.w	$0000
_mpos:
	dc.w	$0000
_no_move:
	dc.w	$0000
_no_command:
	dc.w	$0000
_inpack:
	dc.w	$0000
_total:
	dc.w	$0000
_no_food:
	dc.w	$0000
_count:
	dc.w	$0000
_fung_hit:
	dc.w	$0000
_quiet:
	dc.w	$0000
_food_left:
	dc.w	$0000
_group:
	dc.w	$0002
_hungry_state:
	dc.w	$0000
_maxitems:
	dc.w	$0000
_fall_level:
	dc.w	$0000
_seed:
	dc.l	$00000000
_oldpos:
	dc.l	$00000000
_delta:
	dc.l	$00000000

_rooms:	ds.b	9*66	;room struct is 66 bytes, 9 rooms per level
_passages:

; for 13 passages, last one is different

	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03
	ds.b	50

	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03
	ds.b	50

	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03
	ds.b	50

	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03
	ds.b	50

	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03
	ds.b	50

	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03
	ds.b	50

	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03
	ds.b	50

	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03
	ds.b	50

	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03
	ds.b	50

	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03
	ds.b	50

	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03
	ds.b	50

	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03
	ds.b	50

	ds.b	66

_SV_END:
	dc.w	$0000
_LowKeyTypes:
	dc.l	$07070707
	dc.l	$07070707
	dc.l	$07070707
	dc.l	$07078007
	dc.l	$07070707
	dc.l	$07070707
	dc.l	$07070707
	dc.l	$80070707
	dc.l	$07070707
	dc.l	$07070707
	dc.l	$07070780
	dc.l	$80070107
	dc.l	$80070707
	dc.l	$07070707
	dc.l	$07070780
	dc.l	$07070707
_LowKeyMap:
	dc.l	$FEE07E60	;"  ~`"
	dc.l	$A1B12131	;"  !1"
	dc.l	$C0B24032	;"  @2"
	dc.l	$A3B32333	;"  #3"
	dc.l	$A4B42434	;"  $4"
	dc.l	$A5B52535	;"  %5"
	dc.l	$DEB65E36	;"  ^6"
	dc.l	$A6B72637	;"  &7"
	dc.l	$AAB82A38	;"  *8"
	dc.l	$A8B92839	;"  (9"
	dc.l	$A9B02930	;"  )0"
	dc.l	$DFAD5F2D	;"  _-"
	dc.l	$ABBD2B3D	;"  +="
	dc.l	$FCDC7C5C	;"  |\"
	dc.l	$00000000
	dc.l	$D3F37373	;"  ss"
	dc.l	$D1F15171	;"  Qq"
	dc.l	$D7F75777	;"  Ww"
	dc.l	$C5E54565	;"  Ee"
	dc.l	$D2F25272	;"  Rr"
	dc.l	$D4F45474	;"  Tt"
	dc.l	$D9F95979	;"  Yy"
	dc.l	$D5F55575	;"  Uu"
	dc.l	$C9E94969	;"  Ii"
	dc.l	$CFEF4F6F	;"  Oo"
	dc.l	$D0F05070	;"  Pp"
	dc.l	$FBDB7B5B	;"  {["
	dc.l	$FDDD7D5D	;"  }]"
	dc.l	$00000000
	dc.l	$C2E24262	;"  Bb"
	dc.l	$CAEA4A6A	;"  Jj"
	dc.l	$CEEE4E6E	;"  Nn"
	dc.l	$C1E14161	;"  Aa"
	dc.l	$D3F35373	;"  Ss"
	dc.l	$C4E44464	;"  Dd"
	dc.l	$C6E64666	;"  Ff"
	dc.l	$C7E74767	;"  Gg"
	dc.l	$C8E84868	;"  Hh"
	dc.l	$CAEA4A6A	;"  Jj"
	dc.l	$CBEB4B6B	;"  Kk"
	dc.l	$CCEC4C6C	;"  Ll"
	dc.l	$BABB3A3B	;"  :;"
	dc.l	$A2A72227	;"  "'"
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$C8E84868	;"  Hh"
	dc.l	$0000732E	;"  s."
	dc.l	$CCEC4C6C	;"  Ll"
	dc.l	$00000000
	dc.l	$DAFA5A7A	;"  Zz"
	dc.l	$D8F85878	;"  Xx"
	dc.l	$C3E34363	;"  Cc"
	dc.l	$D6F65676	;"  Vv"
	dc.l	$C2E24262	;"  Bb"
	dc.l	$CEEE4E6E	;"  Nn"
	dc.l	$CDED4D6D	;"  Mm"
	dc.l	$BCAC3C2C	;"  <,"
	dc.l	$BEAE3E2E	;"  >."
	dc.l	$BFAF3F2F	;"  ?/"
	dc.l	$00000000
	dc.l	$D4F45474	;"  Tt"
	dc.l	$D9F95979	;"  Yy"
	dc.l	$CBEB4B6B	;"  Kk"
	dc.l	$D5F55575	;"  Uu"
_LowCaps:
	dc.l	$0000FF03
	dc.l	$FF01FE00
_LowReps:
	dc.l	$FFBFFFEF
	dc.l	$FFEFFFF7
_HiKeyTypes:
	dc.l	$02000101
	dc.l	$04020080
	dc.l	$80800780
	dc.l	$07070707
	dc.l	"AAAA"
	dc.l	"AAAA"
	dc.l	$41418080	;"AA  "
	dc.l	$80808080
	dc.l	$80808080
	dc.l	$80808080
_HiKeyMap:
	dc.l	$0000A020	;"    "
	dc.l	$00000008
	dc.l	$00000909
	dc.l	$00003C3E	;"  <>"
	dc.l	$00000A0D
	dc.l	$00009B1B
	dc.l	$0000007F
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$DAFA7A7A	;"  zz"
	dc.l	$00000000
	dc.l	$CBEB4B6B	;"  Kk"
	dc.l	$CAEA4A6A	;"  Jj"
	dc.l	$CCEC4C6C	;"  Ll"
	dc.l	$C8E84868	;"  Hh"
L00CCB:
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00FE86A3
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
_HiCaps:
	dc.l	$00000000
	dc.b	$00
_HiReps:
	dc.b	"G"
	dc.l	$F4FF0300
_KeyMap:
	dc.l	_LowKeyTypes
	dc.l	_LowKeyMap
	dc.l	_LowCaps
	dc.l	_LowReps
	dc.l	_HiKeyTypes
	dc.l	_HiKeyMap
	dc.l	_HiCaps
	dc.l	_HiReps
_FuncKeys:
	dc.l	L00CCB
_SearchGadget:
	dc.l	$00000000
	dc.l	$020000B4
	dc.l	$00300009
	dc.l	$00000001
	dc.l	$00010000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000073
	dc.l	$00000000
_RestGadget:
	dc.l	$00000000
	dc.l	$023800B4
	dc.l	$00200009
	dc.l	$00000001
	dc.l	$00010000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$0000002E
	dc.l	$00000000
_DownGadget:
	dc.l	$00000000
	dc.l	$026000B4
	dc.l	$00200009
	dc.l	$00000001
	dc.l	$00010000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$0000003E
	dc.l	$00000000
	dc.l	$00000001
_help_text:
	dc.l	L00BDD
	dc.l	L00BDE
	dc.l	L00BDF
	dc.l	L00BE0
	dc.l	L00BE1
	dc.l	L00BE2
	dc.l	L00BE3
	dc.l	L00BE4
	dc.l	L00BE5
	dc.l	L00BE6
	dc.l	L00BE7
	dc.l	L00BE8
	dc.l	L00BE9
	dc.l	L00BEA
	dc.l	L00BEB
	dc.l	L00BEC
	dc.l	L00BED
	dc.l	L00BEE
	dc.l	L00BEF
	dc.l	L00BF0
	dc.l	L00BF1
	dc.l	$00000000

	dc.l	$001F001C
	dc.l	$001F001E
	dc.l	$001F001E
	dc.l	$001F001F
	dc.l	$001E001F
	dc.l	$001E001F
	dc.l	"0123"
	dc.l	"4567"
	dc.l	"89ab"
	dc.l	"cdef"
	dc.w	$0000

_Cbuffs:
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$01000000
	dc.l	$00010000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000101
	dc.l	$00000001
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$01020000
	dc.l	$00010000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000
	dc.l	$00000000

_cls_:	dc.l	$00000000
__cln:	dc.l	$00000000

; $01 uppercase
; $02 lowercase
; $04 digits
; $08 hexdigits
; $10 invisible
; $20 control characters
; $40 special chars
; $80 space

_ctp_:	dc.b	$20,$20,$20,$20
	dc.b	$20,$20,$20,$20
	dc.b	$20,$30,$30,$30
	dc.b	$30,$30,$20,$20

	dc.b	$20,$20,$20,$20
	dc.b	$20,$20,$20,$20
	dc.b	$20,$20,$20,$20
	dc.b	$20,$20,$20,$20

	dc.b	$90,$40,$40,$40 ;space,!,",#
	dc.b	$40,$40,$40,$40
	dc.b	$40,$40,$40,$40
	dc.b	$40,$40,$40,$40

	dc.b	$0C,$0C,$0C,$0C	;0,1,2,3
	dc.b	$0C,$0C,$0C,$0C	;4,5,6,7
	dc.b	$0C,$0C,$40,$40	;8,9,:,;
	dc.b	$40,$40,$40,$40	;<,=,>,?

	dc.b	$40,$09,$09,$09	;@,A,B,C
	dc.b	$09,$09,$09,$01	;D,E,F,G
	dc.b	$01,$01,$01,$01
	dc.b	$01,$01,$01,$01

	dc.b	$01,$01,$01,$01
	dc.b	$01,$01,$01,$01
	dc.b	$01,$01,$01,$40	;X,Y,Z,[
	dc.b	$40,$40,$40,$40

	dc.b	$40,$0A,$0A,$0A	;`,a,b,c
	dc.b	$0A,$0A,$0A,$02	;d,e,f,g
	dc.b	$02,$02,$02,$02
	dc.b	$02,$02,$02,$02

	dc.b	$02,$02,$02,$02
	dc.b	$02,$02,$02,$02
	dc.b	$02,$02,$02,$40
	dc.b	$40,$40,$40,$20

	dc.b	$00,$00,$00,$00

__Dend:

__Uorg:	ds.b	628

__things:
	dc.l	$00000000
__t_alloc:
	dc.l	$00000000

_player:	dc.l	0	;$00 0
		dc.l	0	;$04 4
		dc.w	0	;$08 8
		dc.w	0	;$0A 10 position
		dc.w	0	;$0C 12 position
		dc.w	0	;$0E 14
		dc.w	0	;$10 16 disguise
		dc.w	0	;$12 18 maybe the runto destination for the monster
		dc.w	0	;$14 20
		dc.w	0	;$16 22 flags
		dc.w	0	;$18 24 strength
		dc.l	0	;$1A 26 experience
		dc.w	0	;$1E 30 rank
		dc.w	0	;$20 32 base armor class or something (read only)
		dc.w	0	;$22 34 hp
		dc.l	0	;$24 36 pointer to "1d8" or "1d8/1d8/3d10"
		dc.w	0	;$28 40 max hp
		dc.l	0	;$2A 42 *proom
		dc.l	0	;$2E 46 *pack

_cur_weapon:	ds.l	1
_cur_armor:	ds.l	1
_p_colors:	ds.l	14

_prbuf:
	dc.l	$00000000

_r_stones:	ds.l	14
_ws_type:	ds.l	14
_ws_made:	ds.l	14

_e_levels:
	dc.l	$00000000
_tbuf:
	dc.l	$00000000
_msgbuf:
	dc.l	$00000000
_ring_buf:
	dc.l	$00000000
__level:
	dc.l	$00000000
__flags:
	dc.l	$00000000
_nh:
	dc.l	$00000000

_cur_ring:	ds.l	2

_IntuitionBase:	ds.l	1
_GfxBase:	ds.l	1
_LayersBase:	ds.l	1

_chbm:	ds.w	1	;BytesPerRow
	ds.w	1	;Rows
	ds.w	1	;Flags
	ds.w	1	;pad
	ds.l	8	;planes[8]

_p_row:
	dc.w	$0000
_p_col:
	dc.w	$0000

_StdScr:	dc.l	$00000000
_StdWin:	dc.l	$00000000
_RogueWin:	dc.l	$00000000
_TextWin:	dc.l	$00000000

_char_data:	ds.b	256	;we only need this
		ds.b	1792	;this is now unused

_huh:		ds.b	128

_oldrp:
	dc.l	$00000000
_ch_ret:
	dc.l	$00000000
_menu_on:
	dc.b	$00
_looking:
	dc.b	$00
_ConsoleDevice:
	dc.l	0

_kb_buffer:	ds.b	256

_kb_head:
	dc.l	$00000000
_kb_tail:
	dc.l	$00000000
_all_clear:
	dc.w	0
__whoami:	ds.l	1

_want:	ds.b	64	;color palette of the images is loaded to here

_sverr:
	dc.w	0
_mega_frob:
	dc.w	$0000

__savsp:	ds.l	1
_SysBase:	ds.l	1
__devtab:	ds.b	120
_errno:		ds.w	1
_Enable_Abort:	ds.w	1

_DOSBase:	ds.l	1
_MathBase:	ds.l	1
_MathTransBase:	ds.l	1

	ds.w	1

__Uend:
