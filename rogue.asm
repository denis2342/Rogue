;$VER: D68k 2.1.3 (11.01.2023)

;Disassembled File  : Rogue
;FileSize in Bytes  : 0109976

; vasmm68k_mot -m68010 -Fhunkexe rogue.asm -o rogue -I include -esc -databss -nosym -opt-allbra

 include 'exec/exec_lib.i'
 include 'dos/dos_lib.i'
 include 'intuition/intuition_lib.i'
 include 'graphics/graphics_lib.i'

 include 'rogue.i'

BASE equ _MathTransBase+$46d4

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
	LEA	_max_stats+0-BASE(A4),A1	;_max_stats + 0 (max strength)
	MOVE.L	(A1)+,(A6)+
	MOVE.L	(A1)+,(A6)+
	MOVE.L	(A1)+,(A6)+
	MOVE.L	(A1)+,(A6)+
	MOVE.W	(A1)+,(A6)+

	MOVE.W	#$0514,D0	; we get 1300 food +-10%
	JSR	_spread
	MOVE.W	D0,_food_left-BASE(A4)	;_food_left

	CLR.W	d1
	MOVE.W	#$1036,d0	;4150
	MOVE.L	__things-BASE(A4),a0	;__things
	JSR	_memset

	CLR.W	d1
	MOVE.W	#$00A6,d0	;166
	MOVE.L	__t_alloc-BASE(A4),a0	;__t_alloc
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
	MOVE.L	A2,_cur_weapon-BASE(A4)	;_cur_weapon
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
	MOVE.W	_a_class+2-BASE(A4),D3		;_a_class + 2
	SUBQ.W	#1,D3			;make the ring mail +1
	MOVE.W	D3,$0026(A2)
	ORI.W	#O_ISKNOW,$0028(A2)
	MOVE.W	#$0001,$001E(A2)	;one armor
	CLR.W	$002C(A2)	;group 0
	MOVE.L	A2,_cur_armor-BASE(A4)	;_cur_armor
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
	MOVE.L	A2,-(A7)

	LEA	-$69FC(A4),A2	;_things + 8
	LEA	-$69D4(A4),A6	;_things + 48

1$	MOVE.W	-$0004(A2),D3
	ADD.W	D3,$0004(A2)
	ADDQ.L	#8,A2
	CMPA.L	A6,A2
	BLS.B	1$

	MOVEA.L	(A7)+,A2
	RTS

;/*
; * init_colors:
; *  Initialize the potion color scheme for this time
; */

_init_colors:
	LINK	A5,#-$001C
	MOVE.L	D4,-(A7)

	MOVEQ	#27-1,D4	;-1 so no jump to dbra needed
	LEA	-$001B(A5),A6

1$	CLR.B	(A6)+
	DBRA	D4,1$

	MOVEQ	#$00,D4
L00074:
	MOVEq	#$001B,D0
	JSR	_rnd

;	LEA	-$001B(A5),A6
;	TST.B	$00(A6,D0.W)
	TST.B	-$1B(A5,D0.W)

	BNE.B	L00074

	LEA	-$001B(A5),A6
	ST	$00(A6,D0.W)
	MOVE.W	D4,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	_p_colors-BASE(A4),A6	;_p_colors
	MOVE.W	D0,D2
;	EXT.L	D2
	ASL.w	#2,D2
	LEA	_rainbow-BASE(A4),A1	;_rainbow
	MOVE.L	$00(A1,D2.w),$00(A6,D3.w)
	LEA	_p_know-BASE(A4),A6	;_p_know
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

	MOVE.L	(A7)+,D4
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

	LEA	__Uorg-BASE(A4),A3
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
	MOVEA.L	_prbuf-BASE(A4),A2	;_prbuf
	TST.B	_terse-BASE(A4)	;_terse
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
	MOVEA.L	_prbuf-BASE(A4),A6	;_prbuf
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

1$	MOVEA.L	_prbuf-BASE(A4),A6	;_prbuf
	CLR.B	$0014(A6)
	MOVE.W	-$0004(A5),D3

	LEA	_s_know-BASE(A4),A6	;_s_know
	CLR.B	$00(A6,D3.W)	;mark as unknown

	MOVE.L	_prbuf-BASE(A4),-(A7)	;_prbuf

	MOVE.W	-$0004(A5),D3
	MULU.W	#21,D3
	LEA	_s_names-BASE(A4),A6	;_s_names
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
	LEA	_r_stones-BASE(A4),A6	;_r_stones
	MOVE.W	D5,D2
	MULU.W	#$0006,D2
	LEA	_stones-BASE(A4),A1	;_stones
	MOVE.L	$00(A1,D2.L),$00(A6,D3.w)
	LEA	_r_know-BASE(A4),A6	;_r_know
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
	LEA	_r_magic+6-BASE(A4),A6	;_r_magic + 6
	MOVE.W	D5,D2
	MULU.W	#6,D2
	LEA	_stones+4-BASE(A4),A1	;_stones + 4
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
	LEA	_ws_type-BASE(A4),A6	;_ws_type
	MOVE.L	_ws_wand-BASE(A4),$00(A6,D3.w)	;_ws_wand
	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	_metal-BASE(A4),A6	;_metal
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
	LEA	_ws_type-BASE(A4),A6	;_ws_type
	MOVE.L	_ws_staff-BASE(A4),$00(A6,D3.w)	;_ws_staff
	MOVE.W	D5,D3
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	_wood-BASE(A4),A6	;_wood
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
	LEA	_ws_made-BASE(A4),A6	;_ws_made
	MOVE.L	A2,$00(A6,D3.w)
	LEA	_ws_know-BASE(A4),A6	;_ws_know
	CLR.B	$00(A6,D4.W)
	CMP.W	#$0000,D4
	BLE.B	L0008D

	MOVE.W	D4,D3
;	EXT.L	D3
	ASL.w	#3,D3
	LEA	_ws_magic+4-BASE(A4),A6	;_ws_magic + 4
	MOVE.W	D4,D2
	SUBQ.W	#1,D2
;	EXT.L	D2
	ASL.w	#3,D2
	LEA	_ws_magic+4-BASE(A4),A1	;_ws_magic + 4
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
	MOVE.L	D0,__flags-BASE(A4)	;__flags

	MOVE.W	#$06E0,-(A7)	;1760
	JSR	_newmem
	ADDQ.W	#2,A7
	MOVE.L	D0,__level-BASE(A4)	;__level

	MOVE.W	#$1036,-(A7)	;4150
	JSR	_newmem
	ADDQ.W	#2,A7
	MOVE.L	D0,__things-BASE(A4)	;__things

	MOVE.W	#$00A6,-(A7)
	JSR	_newmem
	ADDQ.W	#2,A7
	MOVE.L	D0,__t_alloc-BASE(A4)	;__t_alloc

	MOVE.W	#$0050,-(A7)
	JSR	_newmem
	ADDQ.W	#2,A7
	MOVE.L	D0,_tbuf-BASE(A4)	;_tbuf

	MOVE.W	#$0080,-(A7)
	JSR	_newmem
	ADDQ.W	#2,A7
	MOVE.L	D0,_msgbuf-BASE(A4)	;_msgbuf

	MOVE.W	#$0050,-(A7)
	JSR	_newmem
	ADDQ.W	#2,A7
	MOVE.L	D0,_prbuf-BASE(A4)	_prbuf

	MOVE.W	#$0006,-(A7)
	JSR	_newmem
	ADDQ.W	#2,A7
	MOVE.L	D0,_ring_buf-BASE(A4)	;_ring_buf

	MOVE.W	_nlevels-BASE(A4),D3	;_nlevels 23
	ADDQ.W	#1,D3
	ASL.W	#2,D3
	MOVE.W	D3,-(A7)
	JSR	_newmem
	ADDQ.W	#2,A7
	MOVE.L	D0,_e_levels-BASE(A4)	;_e_levels
	MOVEA.L	D0,A2

;	MOVE.L	#$000000A,(A2)+	; start with 10 xp
;	BRA.B	L0008F

	moveq	#10,D0		; start with 10 xp
	move.w	_nlevels-BASE(A4),D3	;_nlevels 23 (means player ranks)
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
;	MOVE.W	_nlevels-BASE(A4),D3	;_nlevels 23
;	ASL.w	#2,D3
;	EXT.L	D3
;	ADD.L	_e_levels-BASE(A4),D3	;_e_levels
;	add.l	d0,d3
;	CMPA.L	D3,A2
;	BCS.B	L0008E

	CLR.L	(A2)
	MOVEA.L	(A7)+,A2
;	UNLK	A5
	RTS

 include 'move.asm'

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

	TST.B	_map_up-BASE(A4)	;_map_up
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
	MOVE.W	D3,_p_col-BASE(A4)	;_p_col

	MULU.W	#$0009,D4
	ADD.W	-$77D2(A4),D4	;_Window2 + 48
	MOVE.W	D4,_p_row-BASE(A4)	;_p_row

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
	CLR.B	_addch_text+0-BASE(A4)	;_addch_text + 0
	MOVE.B	#$01,_addch_text+1-BASE(A4)	;_addch_text + 1
;	UNLK	A5
	RTS

_standend:
;	LINK	A5,#-$0000
	MOVE.B	#$01,_addch_text+0-BASE(A4)	;_addch_text + 0
	CLR.B	_addch_text+1-BASE(A4)	;_addch_text + 1
;	UNLK	A5
	RTS

_wtext:
;	LINK	A5,#-$0000

	TST.B	_map_up-BASE(A4)	;_map_up
	BEQ.B	L00100

	MOVE.L	_StdScr-BASE(A4),-$77E4(A4)	;_StdScr,_Window2+30
	PEA	_Window2-BASE(A4)		;_Window2
	JSR	_OpenWindow
	ADDQ.W	#4,A7
	MOVE.L	D0,_TextWin-BASE(A4)	;_TextWin
;	TST.L	D0
	BNE.B	L000FF

	PEA	L00101(PC)	;"No Alternate Window"
	JSR	_fatal
	ADDQ.W	#4,A7
L000FF:
	CLR.B	_map_up-BASE(A4)	;_map_up
	MOVE.L	_TextWin-BASE(A4),_StdWin-BASE(A4)	;_TextWin,_StdWin
	JSR	_intui_sync(PC)
L00100:
;	UNLK	A5
	RTS

L00101:	dc.b	"No Alternate Window",0

_wmap:
;	LINK	A5,#-$0000

	TST.B	_map_up-BASE(A4)	;_map_up
	BNE.B	L00102

	TST.L	_TextWin-BASE(A4)	;_TextWin
	BEQ.B	L00102

	MOVE.L	_TextWin-BASE(A4),-(A7)	;_TextWin
	JSR	_CloseWindow
	ADDQ.W	#4,A7
	CLR.L	_TextWin-BASE(A4)	;_TextWin
	ST	_map_up-BASE(A4)	;_map_up
	MOVE.L	_RogueWin-BASE(A4),_StdWin-BASE(A4)	;_RogueWin,_StdWin
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
	LEA	_char_data-BASE(A4),A1	;_char_data
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
	lea	_chbm-BASE(A4),a0	;_chbm = srcbitmap

	moveq	#0,d0

	MOVEA.L	_StdWin-BASE(A4),A6	;_StdWin
	MOVEA.L	$0032(A6),A1
	move.l	$0004(A1),a1	;dstbitmap
	MOVE.W	_p_col-BASE(A4),D2	;_p_col ;dstx
	MOVE.W	_p_row-BASE(A4),D3	;_p_row = dsty

	TST.B	_map_up-BASE(A4)	;_map_up
	BEQ.B	L00106
	ADD.W	#$000C,D3	;dsty + 12
L00106:

	moveq	#$000A,d4	;sizex
	moveq	#$0009,d5	;sizey

	moveq	#-$40,d6	;we need $c0, minterm
	moveq	#-1,d7		;we need $ff, mask
	sub.l	a2,a2		;tempA

	MOVEA.L	_GfxBase-BASE(A4),A6	;_GfxBase
	JSR	_LVOBltBitMap(A6)

;	CLR.L	-(A7)	;tempA
;	PEA	$00FF	;mask
;	PEA	$00C0	;minterm, is a vanilla copy
;	PEA	$0009	;sizey
;	PEA	$000A	;sizex
;	MOVE.L	D6,-(A7)	;dsty
;	MOVE.W	_p_col-BASE(A4),D3	;_p_col
;	EXT.L	D3
;	MOVE.L	D3,-(A7)	;dstx
;	MOVEA.L	_StdWin-BASE(A4),A6	;_StdWin
;	MOVEA.L	$0032(A6),A1
;	MOVE.L	$0004(A1),-(A7)	;dstbitmap
;	CLR.L	-(A7)		;srcy
;	CLR.L	-(A7)		;srcx
;	PEA	_chbm-BASE(A4)	;scrbitmap, _chbm
;	JSR	_BltBitMap
;	LEA	$002C(A7),A7
	BRA.W	L00103

__addch:
	LINK	A5,#-$0000
	MOVEM.L	D4/A2,-(A7)

	LEA	L00107(PC),A2
	MOVE.B	$0009(A5),(A2)
	MOVEA.L	_StdWin-BASE(A4),A6	;_StdWin
	MOVEA.L	$0032(A6),A1
	MOVE.B	$0018(A1),D4
	MOVE.B	#$01,$0018(A1)
	MOVE.L	A2,-$77C2(A4)	_addch_text + 12

	MOVE.W	_p_col-BASE(A4),D0	;_p_col
	MOVE.W	_p_row-BASE(A4),D1	;_p_row
	lea	_addch_text+0-BASE(A4),a1	;_addch_text + 0
	MOVE.L	$0032(A6),a0

	MOVEA.L	_IntuitionBase-BASE(A4),A6	;_IntuitionBase
	JSR	_LVOPrintIText(A6)

;	MOVE.W	_p_row-BASE(A4),D3	;_p_row
;	EXT.L	D3
;	MOVE.L	D3,-(A7)
;	MOVE.W	_p_col-BASE(A4),D3	;_p_col
;	EXT.L	D3
;	MOVE.L	D3,-(A7)
;	PEA	_addch_text+0-BASE(A4)	;_addch_text + 0
;	MOVE.L	$0032(A6),-(A7)
;	JSR	_PrintIText
;	LEA	$0010(A7),A7

	MOVEA.L	_StdWin-BASE(A4),A6	;_StdWin
	MOVEA.L	$0032(A6),A1
	MOVE.B	D4,$0018(A1)

	MOVEM.L	(A7)+,D4/A2
	UNLK	A5
	RTS

L00107:
	dc.w	$5800		;"X",0

__clearbot:
;	LINK	A5,#-$0000
	MOVE.W	_p_row-BASE(A4),D3	;_p_row
	EXT.L	D3
	MOVEA.L	D3,A6

	PEA	$0006(A6)
	MOVE.W	_p_col-BASE(A4),D3	;_p_col
	EXT.L	D3
	MOVE.L	D3,-(A7)
	MOVEA.L	_StdWin-BASE(A4),A6	;_StdWin
	MOVE.L	$0032(A6),-(A7)
	JSR	_GfxMove
	LEA	$000C(A7),A7

	MOVEA.L	_StdWin-BASE(A4),A6	;_StdWin
	MOVE.L	$0032(A6),-(A7)
	JSR	_ClearScreen
	ADDQ.W	#4,A7
;	UNLK	A5
	RTS

__clrtoeol:
;	LINK	A5,#-$0000

	MOVE.W	_p_row-BASE(A4),D3	;_p_row
	EXT.L	D3
	MOVEA.L	D3,A6
	PEA	$0006(A6)
	MOVE.W	_p_col-BASE(A4),D3	;_p_col
	EXT.L	D3
	MOVE.L	D3,-(A7)
	MOVEA.L	_StdWin-BASE(A4),A6	;_StdWin
	MOVE.L	$0032(A6),-(A7)
	JSR	_GfxMove
	LEA	$000C(A7),A7

	MOVEA.L	_StdWin-BASE(A4),A6	;_StdWin
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
	MOVE.L	D0,_GfxBase-BASE(A4)	;_GfxBase
;	TST.L	_GfxBase-BASE(A4)
	BNE.B	L00108

	PEA	L00112(PC)
	JSR	_fatal
	ADDQ.W	#4,A7
L00108:
	PEA	$001D		;version 29
	PEA	L00113(PC)	;"intuition.library"
	JSR	_OpenLibrary
	ADDQ.W	#8,A7
	MOVE.L	D0,_IntuitionBase-BASE(A4)	;_IntuitionBase
;	TST.L	_IntuitionBase-BASE(A4)
	BNE.B	L00109

	PEA	L00114(PC)
	JSR	_fatal
	ADDQ.W	#4,A7
L00109:
;	PEA	$001D		;version 29
;	PEA	L00115(PC)	;"layers.library"
;	JSR	_OpenLibrary
;	ADDQ.W	#8,A7
;	MOVE.L	D0,_LayersBase-BASE(A4)	;_LayersBase
;	TST.L	_LayersBase-BASE(A4)
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
	ST	_graphics_disabled-BASE(A4)	;_graphics_disabled
	BRA	readCharEnd

L0010B2:
	LEA	_char_data-BASE(A4),A0	;_char_data
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

	LEA	_char_data-BASE(A4),A6	;_char_data
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

	PEA	_NewScreen-BASE(A4)	;_NewScreen
	JSR	_OpenScreen
	ADDQ.W	#4,A7

	MOVE.L	D0,_StdScr-BASE(A4)	;_StdScr
;	TST.L	D0
	BNE.B	L0010F

	PEA	L0011A(PC)	;"No Screen"
	JSR	_fatal
	ADDQ.W	#4,A7
L0010F:
	PEA	9*72		;height
	PEA	10		;width
	PEA	$0004		;number of planes (bits per color)
	PEA	_chbm-BASE(A4)	;_chbm
	JSR	_InitBitMap
	LEA	$0010(A7),A7

	MOVE.L	_StdScr-BASE(A4),-$7814(A4)	;_StdScr
	PEA	_Window1-BASE(A4)		;_Window1
	JSR	_OpenWindow
	ADDQ.W	#4,A7

	MOVE.L	D0,_RogueWin-BASE(A4)	;_RogueWin
	MOVE.L	D0,_StdWin-BASE(A4)	;_StdWin
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

	TST.L	_StdScr-BASE(A4)	;_StdScr
	BEQ.B	L0011C
	JSR	_black_out
L0011C:
	TST.L	_TextWin-BASE(A4)	;_TextWin
	BEQ.B	L0011D
	MOVE.L	_TextWin-BASE(A4),-(A7)	;_TextWin
	JSR	_ClearMenuStrip
	ADDQ.W	#4,A7
	MOVE.L	_TextWin-BASE(A4),-(A7)	;_TextWin
	JSR	_CloseWindow
	ADDQ.W	#4,A7
L0011D:
	TST.L	_RogueWin-BASE(A4)	;_RogueWin
	BEQ.B	L0011E

	MOVE.L	_RogueWin-BASE(A4),-(A7)	;_RogueWin
	JSR	_ClearMenuStrip
	ADDQ.W	#4,A7

	MOVE.L	_RogueWin-BASE(A4),-(A7)	;_RogueWin
	JSR	_CloseWindow
	ADDQ.W	#4,A7
L0011E:
	TST.L	_StdScr-BASE(A4)	;_StdScr
	BEQ.B	L0011F
	MOVE.L	_StdScr-BASE(A4),-(A7)	;_StdScr
	JSR	_CloseScreen
	ADDQ.W	#4,A7
L0011F:
	TST.L	_GfxBase-BASE(A4)	;_GfxBase
	BEQ.B	L00120
	MOVE.L	_GfxBase-BASE(A4),-(A7)	;_GfxBase
	JSR	_CloseLibrary
	ADDQ.W	#4,A7
L00120:
	TST.L	_IntuitionBase-BASE(A4)	;_IntuitionBase
	BEQ.B	L00121
	MOVE.L	_IntuitionBase-BASE(A4),-(A7)	;_IntuitionBase
	JSR	_CloseLibrary
	ADDQ.W	#4,A7
L00121:
;	TST.L	_LayersBase-BASE(A4)	;_LayersBase
;	BEQ.B	L00122
;	MOVE.L	_LayersBase-BASE(A4),-(A7)	;_LayersBase
;	JSR	_CloseLibrary
;	ADDQ.W	#4,A7
;L00122:
	MOVEM.L	(A7)+,D4/D5
;	UNLK	A5
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
	MOVE.L	_RogueWin-BASE(A4),-(A7)	;_RogueWin
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
	MOVEA.L	_StdWin-BASE(A4),A6	;_StdWin
	MOVE.L	$0032(A6),-(A7)
	JSR	_SetDrMd
	ADDQ.W	#8,A7
	PEA	$000F
	MOVEA.L	_StdWin-BASE(A4),A6	;_StdWin
	MOVE.L	$0032(A6),-(A7)
	JSR	_SetAPen
	ADDQ.W	#8,A7
	MOVEA.L	D4,A6
	PEA	$0009(A6)
	PEA	$027F
	MOVE.L	D4,-(A7)
	CLR.L	-(A7)
	MOVEA.L	_StdWin-BASE(A4),A6	;_StdWin
	MOVE.L	$0032(A6),-(A7)
	JSR	_RectFill
	LEA	$0014(A7),A7
	CLR.L	-(A7)
	MOVEA.L	_StdWin-BASE(A4),A6	;_StdWin
	MOVE.L	$0032(A6),-(A7)
	JSR	_SetDrMd
	ADDQ.W	#8,A7
	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

__zapstr:
	LINK	A5,#-$0000
	MOVE.L	D4,-(A7)

	MOVEA.L	_StdWin-BASE(A4),A6	;_StdWin
	MOVEA.L	$0032(A6),A1
	MOVE.B	$0018(A1),D4
	MOVE.B	#$01,$0018(A1)
	MOVE.L	$0008(A5),-$77C2(A4)	;_addch_text + 12

	MOVE.W	_p_col-BASE(A4),D0	;_p_col
	MOVE.W	_p_row-BASE(A4),D1	;_p_row
	lea	_addch_text+0-BASE(A4),a1	;_addch_text + 0
	MOVE.L	$0032(A6),a0

	MOVEA.L	_IntuitionBase-BASE(A4),A6	;_IntuitionBase
	JSR	_LVOPrintIText(A6)

;	MOVE.W	_p_row-BASE(A4),D3	;_p_row
;	EXT.L	D3
;	MOVE.L	D3,-(A7)
;	MOVE.W	_p_col-BASE(A4),D3	;_p_col
;	EXT.L	D3
;	MOVE.L	D3,-(A7)
;	PEA	_addch_text+0-BASE(A4)
;	MOVEA.L	_StdWin-BASE(A4),A6	;_StdWin
;	MOVE.L	$0032(A6),-(A7)
;	JSR	_PrintIText
;	LEA	$0010(A7),A7

	MOVEA.L	_StdWin-BASE(A4),A6	;_StdWin
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

 include 'armor.asm'

_ifterse:
	LINK	A5,#-$0000

	MOVE.W	$0018(A5),-(A7)
	MOVE.W	$0016(A5),-(A7)
	MOVE.W	$0014(A5),-(A7)
	MOVE.W	$0012(A5),-(A7)
	MOVE.W	$0010(A5),-(A7)

	TST.B	_expert-BASE(A4)	;_expert
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

 include 'io.asm'

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
	TST.B	_terse-BASE(A4)	;_terse
	BNE.B	1$

	TST.B	_expert-BASE(A4)	;_expert
	BEQ.B	2$

1$	LEA	_nullstr-BASE(A4),A0	;_nullstr
2$	MOVE.L	A0,D0
	RTS

 include 'new_level.asm'

 include 'scrolls.asm'

 include 'chase.asm'

 include 'pack.asm'

 include 'sticks.asm'

 include 'command.asm'

 include 'passages.asm'

 include 'list.asm'

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
	LEA	_ctp_-BASE(A4),A6		;_ctp_
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

 include 'potions.asm'

_clear:
;	LINK	A5,#-$0000
	MOVEM.L	D4/D5,-(A7)
	TST.B	_map_up-BASE(A4)	;_map_up
	BEQ.B	L004D5

	MOVEq	#$0020,d1
	MOVE.W	#1680,d0
	lea	_screen_map-BASE(A4),a0	;_screen_map
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

	LEA	_screen_map-BASE(A4),A6	;_screen_map
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
	MOVE.B	_graphics_disabled-BASE(A4),D0	;_graphics_disabled
	MOVE.B	$0005(A7),_graphics_disabled-BASE(A4)	;_graphics_disabled
;	UNLK	A5
	RTS

_clrtoeol:
;	LINK	A5,#-$0000

	TST.B	_map_up-BASE(A4)	;_map_up
	BEQ.B	1$

	MOVEq	#32,d1		;space for memset

	MOVEQ	#$00,D3
	MOVE.B	_c_col-BASE(A4),D3	;_c_col

	MOVEQ	#$00,D2
	MOVE.B	_c_row-BASE(A4),D2	;_c_row

	MOVEQ	#80,D0
	mulu.w	D0,d2
	SUB.W	D3,D0

	ADD.L	D3,D2
	LEA	_screen_map-BASE(A4),A0	;_screen_map
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
	LEA	_screen_map-BASE(A4),A6	;_screen_map
	MOVEQ	#$00,D0
	MOVE.B	$00(A6,D3.L),D0

	MOVEM.L	(A7)+,D4/D5
	UNLK	A5
	RTS

_inch:
;	LINK	A5,#-$0000

	MOVEQ	#$00,D0
	MOVE.B	_c_row-BASE(A4),D0	;_c_row

;	MOVEQ	#80,D1
;	JSR	_mulu
	mulu.w	#80,d0

	MOVEQ	#$00,D3
	MOVE.B	_c_col-BASE(A4),D3	;_c_col
	ADD.L	D0,D3
	LEA	_screen_map-BASE(A4),A6	;_screen_map
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
	MOVE.B	_c_row-BASE(A4),D0	;_c_row
	JSR	_movequick

L004DB:
	MOVE.L	(A7)+,D4
	UNLK	A5
	RTS

L004DC:
	MOVEQ	#$00,D1
	MOVE.B	_c_row-BASE(A4),D0	;_c_row
	ADDQ.W	#1,D0
	JSR	_movequick

	BRA.B	L004DB
L004DD:
	TST.B	_map_up-BASE(A4)	;_map_up
	BNE.B	L004DE

	MOVE.W	D4,-(A7)
	JSR	__addch
	ADDQ.W	#2,A7
	BRA.W	L004E1
L004DE:
	MOVEQ	#$00,D0
	MOVE.B	_c_row-BASE(A4),D0	;_c_row

;	MOVEQ	#80,D1
;	JSR	_mulu
	mulu.w	#80,d0

	MOVEQ	#$00,D2
	MOVE.B	_c_col-BASE(A4),D2	;_c_col
	ADD.L	D2,D0
	LEA	_screen_map-BASE(A4),A6	;_screen_map
	MOVE.B	$00(A6,D0.L),D2
	CMP.B	D2,D4
	BEQ.B	L004E1

	TST.B	_c_row-BASE(A4)	;_c_row
	BLS.B	L004DF

	MOVE.B	_c_row-BASE(A4),D3	;_c_row
	CMP.B	#$14,D3
	BCC.B	L004DF

	TST.B	_graphics_disabled-BASE(A4)	;_graphics_disabled
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
	MOVE.B	_c_col-BASE(A4),D3	;_c_col
	CMP.B	#$3C,D3
	BCC.B	L004E1

	MOVEQ	#$00,D0
	MOVE.B	_c_row-BASE(A4),D0	;_c_row

;	MOVEQ	#80,D1
;	JSR	_mulu
	mulu.w	#80,d0

	MOVEQ	#$00,D3
	MOVE.B	_c_col-BASE(A4),D3	;_c_col
	ADD.L	D3,D0
	LEA	_screen_map-BASE(A4),A6	;_screen_map
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
	MOVE.B	_c_col-BASE(A4),D1	;_c_col
	ADDQ.W	#1,D1
	MOVE.B	_c_row-BASE(A4),D0	;_c_row
	JSR	_movequick

	BRA.W	L004DB

_addstr:
	LINK	A5,#-$0002
	MOVE.B	_graphics_disabled-BASE(A4),-$0001(A5)	;backup _graphics_disabled
	ST	_graphics_disabled-BASE(A4)	;_graphics_disabled

	MOVE.L	$0008(A5),-(A7)
	JSR	__zapstr(PC)
	ADDQ.W	#4,A7

	MOVE.L	$0008(A5),A0
	JSR	_strlenquick

	MOVE.B	_c_col-BASE(A4),D1	;_c_col
	ADD.B	D0,D1
	MOVE.B	_c_row-BASE(A4),D0	;_c_row
	JSR	_movequick

	MOVE.B	-$0001(A5),_graphics_disabled-BASE(A4)	;_graphics_disabled
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
	MOVE.B	D0,_c_row-BASE(A4)	;_c_row
	MOVE.B	D1,_c_col-BASE(A4)	;_c_col

	MOVEQ	#$00,D3
	MOVE.B	_graphics_disabled-BASE(A4),D3	;_graphics_disabled
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
	MOVEQ	#$00,D3
	MOVE.B	_c_row-BASE(A4),D3	;_c_row
	MOVEA.L	$0004(A7),A0
	MOVE.W	D3,(A0)
;	MOVEQ	#$00,D3
	MOVE.B	_c_col-BASE(A4),D3	;_c_col
	MOVEA.L	$0008(A7),A0
	MOVE.W	D3,(A0)

	RTS

_initscr:
;	LINK	A5,#-$0000
	JSR	_winit(PC)
;	UNLK	A5
	RTS

_endwin:
;	LINK	A5,#-$0000
	JSR	_wclose(PC)
;	UNLK	A5
	RTS

_ready_to_go:
;	LINK	A5,#-$0000
	MOVE.W	#$0001,-(A7)
	PEA	_my_palette-BASE(A4)	;_my_palette
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

	CLR.B	_terse-BASE(A4)	;_terse
	CLR.B	_expert-BASE(A4)	;_expert
	MOVE.W	#22,_maxrow-BASE(A4)	;_maxrow

	CLR.L	-(A7)
	PEA	-$0030(A5)
	PEA	-$1
	PEA	L004E6(PC)		;"console.device"
	JSR	_OpenDevice

	LEA	$0010(A7),A7
	MOVE.L	-$001C(A5),_ConsoleDevice-BASE(A4)	;_ConsoleDevice
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

	LEA	_kb_buffer-BASE(A4),A6
	MOVE.L	A6,_kb_tail-BASE(A4)	;_kb_tail
	MOVE.L	A6,_kb_head-BASE(A4)
	TST.L	_StdWin-BASE(A4)	;_StdWin
	BEQ.B	L004ED
L004EB:
	MOVEA.L	_StdWin-BASE(A4),A6	;_StdWin
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
	MOVE.L	_TextWin-BASE(A4),-(A7)	;_TextWin
	PEA	L00513(PC)	; "Title.Screen"
	st	_all_clear-BASE(A4)	;turn on _all_clear to reverse red/blue
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
	PEA	_whoami-BASE(A4)	;_whoami
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

	move.l	_StdScr-BASE(A4),a0	;_StdScr
	MOVEA.L	_IntuitionBase-BASE(A4),A6	;_IntuitionBase
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
	LEA	_he_man-BASE(A4),A6	;_he_man
	MOVE.L	$00(A6,D3.w),-(A7)
	PEA	L00520(PC)	;' "%s"'
	PEA	-$0078(A5)
	JSR	_sprintf
	LEA	$000C(A7),A7
L00519:
	CMPI.W	#$0001,_level-BASE(A4)	;_level
	BNE.B	L0051B

	CMPI.W	#$0002,-$52AC(A4)	;_player + 30 (rank)
	BGE.B	L0051B

	TST.W	_hungry_state-BASE(A4)	;_hungry_state
	BNE.B	L0051B
L0051A:
	UNLK	A5
	RTS

L0051B:
	MOVE.W	_hungry_state-BASE(A4),D3	;_hungry_state
;	EXT.L	D3
	ASL.w	#2,D3
	LEA	_hungry_state_texts-BASE(A4),A6	;_hungry_state_texts
	MOVE.L	$00(A6,D3.w),-(A7)
	MOVE.W	_level-BASE(A4),-(A7)	;_level
	PEA	-$0078(A5)
	PEA	_whoami-BASE(A4)	;_whoami
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
	TST.B	_db_enabled-BASE(A4)	;_db_enabled
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
	MOVE.L	_StdWin-BASE(A4),-(A7)	;_StdWin
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
	MOVEA.L	_StdWin-BASE(A4),A6	;_StdWin
	MOVE.L	$0032(A6),-(A7)
	JSR	_TextLength
	LEA	$000C(A7),A7

	UNLK	A5
	RTS

_choose_row:
	LINK	A5,#-$0000

	CMPI.W	#$FFFF,_choose_row_tmp-BASE(A4)
	BEQ.B	L00528

	MOVE.W	_choose_row_tmp-BASE(A4),D3
	CMP.W	$0008(A5),D3
	BEQ.B	L00528

	MOVE.W	D3,-(A7)
	JSR	_invert_row(PC)
	ADDQ.W	#2,A7
	MOVE.W	#$FFFF,_choose_row_tmp-BASE(A4)
L00528:
	MOVE.W	$0008(A5),-(A7)
	JSR	_sel_char(PC)
	ADDQ.W	#2,A7
	TST.b	D0
	BEQ.B	L00529

	MOVE.W	$0008(A5),D3
	CMP.W	_choose_row_tmp-BASE(A4),D3
	BEQ.B	L00529

	MOVE.W	D3,-(A7)
	JSR	_invert_row(PC)
	ADDQ.W	#2,A7
	MOVE.W	$0008(A5),_choose_row_tmp-BASE(A4)
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
	CLR.B	_after-BASE(A4)	;_after
	MOVEQ	#$00,D0
;	UNLK	A5
	RTS

L0052A:	dc.b	"%sit appears to be stuck in your pack!",0
L0052B:	dc.b	"can't drop it, ",0,0

 include 'daemon.asm'

 include 'rings.asm'

 include 'weapons.asm'

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

 include 'daemons.asm'

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
	CLR.W	_dnum-BASE(A4)	;_dnum
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
	ST	_noscore-BASE(A4)	;_noscore

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
	TST.W	_dnum-BASE(A4)	;_dnum
	BNE.B	L00661
	JSR	_srand(PC)
	MOVE.W	D0,_dnum-BASE(A4)	;_dnum
L00661:
	MOVE.W	_dnum-BASE(A4),D3	;_dnum
	EXT.L	D3
	MOVE.L	D3,_seed-BASE(A4)	;_seed
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
	PEA	_whoami-BASE(A4)	;_whoami
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
	MOVE.L	_seed-BASE(A4),D0	;_seed
	MOVEQ	#$7D,D1
	JSR	_mulu
	MOVE.L	D0,_seed-BASE(A4)	;_seed
;	MOVE.L	_seed-BASE(A4),D0	;_seed
	MOVE.L	#$002AAAAB,D1
	JSR	_divu
	MOVE.L	#$002AAAAB,D1
	JSR	_mulu
	SUB.L	D0,_seed-BASE(A4)	;_seed
	MOVE.L	_seed-BASE(A4),D0	;_seed
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
	MOVE.L	D0,_oldrp-BASE(A4)	;_oldrp
L0066A:
	TST.B	_playing-BASE(A4)	;_playing
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
	MOVE.W	_purse-BASE(A4),-(A7)	;_purse
	JSR	_score(PC)
	ADDQ.W	#6,A7
	MOVE.W	_purse-BASE(A4),-(A7)	;_purse
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

 include 'rip.asm'

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

 include 'maze.asm'

 include 'wizard.asm'

 include 'options.asm'

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

 include 'misc.asm'

;/*
; * dist:
; *  Calculate the "distance" between to points.  Actually,
; *  this calculates d^2, not d, but that's good enough for
; *  our purposes, since it's only used comparitively.
; */

_DISTANCE:
;	LINK	A5,#-$0000

	MOVE.W	$0006(A7),D3	;X^2
	SUB.W	$000A(A7),D3
	MULU.W	D3,D3

	MOVE.W	$0004(A7),D0	;Y^2
	SUB.W	$0008(A7),D0
	MULU.W	D0,D0

	ADD.W	D3,D0		;X+Y

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
	MOVE.W	_maxrow-BASE(A4),D0	;_maxrow
	SUBQ.W	#1,D0
	MULU.W	-$52C0(A4),D0
	ADD.W	-$52BE(A4),D0
	SUBQ.W	#1,D0
	RTS

_INDEXquick:
	MOVE.W	_maxrow-BASE(A4),D2	;_maxrow
	SUBQ.W	#1,D2
	MULU.W	D2,D0
	ADD.W	D1,D0
	SUBQ.W	#1,D0
	RTS

;x_INDEX:
;	LINK	A5,#-$0000

;	MOVE.W	_maxrow-BASE(A4),D0	;_maxrow
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
	CMP.W	_maxrow-BASE(A4),D3	;_maxrow
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

	MOVEA.L	__level-BASE(A4),A6	;__level
	MOVEQ	#$00,D3
	MOVE.B	$00(A6,D0.W),D3
	MOVE.W	D3,D0
	BRA.B	L008BF

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
	JSR	_goodch
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
	LEA	_rooms-BASE(A4),A6	;_rooms
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
	MOVEA.L	__level-BASE(A4),A6	;__level
	MOVE.B	$00(A6,D5.W),D3
	CMP.b	#'.',D3		:FLOOR
	BEQ.B	L00900

;	MOVEA.L	__level-BASE(A4),A6	;__level
;	MOVE.B	$00(A6,D5.W),D3
	CMP.b	#'#',D3		;PASSAGE
	BNE.B	L008FE
L00900:
	MOVE.W	D5,D0

	MOVEM.L	(A7)+,D4/D5/A2
	UNLK	A5
	RTS

 include 'rooms.asm'

 include 'fight.asm'

;
; goldcalc
;

goldcalc:
	MOVE.W	_level-BASE(A4),D0	;_level
	MULU.W	#$000A,D0
	ADD.W	#$0032,D0
	JSR	_rnd
	ADDQ.W	#2,D0
	RTS

L00A0D:	dc.b	"K BHISOR LCA NYTWFP GMXVJD",0	;lvl_mons[] to generate
L00A0E:	dc.b	"KEBHISORZ CAQ YTW PUGM VJ ",0	;wand_mons[] to polymorph

 include 'monster.asm'

_pick_mons:
;	LINK	A5,#-$0000
	MOVE.L	A2,-(A7)

	MOVE.L	_lvl_monster_ptr-BASE(A4),A0	;lvl_mons[]
	JSR	_strlenquick

	EXT.L	D0
	MOVEA.L	D0,A2
	ADDA.L	_lvl_monster_ptr-BASE(A4),A2

1$	SUBQ.L	#1,A2
	CMPA.L	_lvl_monster_ptr-BASE(A4),A2
	BCS.B	2$
	MOVEq	#10,D0		;10% chance monster, starting with the hardest
	JSR	_rnd
	TST.W	D0
	BNE.B	1$

2$	CMPA.L	_lvl_monster_ptr-BASE(A4),A2	;not one match, it will be against a medusa
	BCC.B	4$
	MOVEQ	#$4D,D0		;'M' medusa

3$	MOVEA.L	(A7)+,A2
;	UNLK	A5
	RTS

4$	CMP.b	#$20,(A2)	;' '
	BNE.B	5$

	SUBA.L	_lvl_monster_ptr-BASE(A4),A2
	ADDA.L	_wnd_monster_ptr-BASE(A4),A2

5$	MOVE.B	(A2),D0
;	EXT.W	D0
	BRA.B	3$

_moatquick:
	MOVE.L	A2,-(A7)

	MOVEA.L	_mlist-BASE(A4),A2	;_mlist
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

 include 'menu.asm'

 include 'things.asm'

 include 'image.asm'

 include 'restore.asm'

 include 'function.asm'

 include 'amiga.asm'

 include 'data.asm'
