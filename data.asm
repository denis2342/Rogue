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
_do_passages_tmp:
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
	dc.w	$0000

_choose_row_tmp:
	dc.w	$FFFF

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

dm_callbacks:
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
missile_name:
	dc.l	$00000000	;missile is the tenth weapon with dynamic name

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

_venus_flytrap:
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

_lvl_monster_ptr:	dc.l	L00A0D
_wnd_monster_ptr:	dc.l	L00A0E

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
	dc.b	$00
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
	dc.w	$0000
	dc.w	$0000
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

__Uorg:

_getsyl_tmp:
	ds.b	4

_ScreenTitle_tmp:
	ds.b	76

_unctrl_tmp:
	ds.b	1

_unctrl_tmp2:
	ds.b	9

_lp_hp			dc.w	0
_lp_max_hp		dc.w	0
_lp_strength		dc.w	0
_lp_max_strength	dc.w	0
_lp_purse		dc.w	0
_lp_armor_class		dc.w	0

_slime_split_tmp:
	ds.w	1
_slime_split_tmp1:
	ds.w	1
_slime_split_tmp2:
	ds.b	1

	dc.b	0	;padding?

charge_string:	ds.b	20

_again_num:	ds.w	1
_is_again:	ds.b	1
_is_pickup:	ds.b	1
_is_pickup_tmp:	ds.b	1

	dc.b	0

_numpass_tmp:	ds.w	2	;$54C0

add_line_tmp:	ds.w	1
add_line_tmp2:	ds.b	2
add_line_tmp3:	ds.l	1
add_line_tmp4:	ds.l	1

disc0:	ds.w	5
disc1:	ds.w	10		;used by _print_disc()
disc2:	ds.w	1
disc3:	ds.w	4
disc4:	ds.w	5
disc_table:	ds.w	15

sel_chr_table:	ds.b	22

dm_list:	ds.b	120
dm_list_end:

_fall_pos:
_fall_posx:	ds.w	1	;used by _fall() and _fallpos
_fall_posy:	ds.w	1	;used by _fall() and _fallpos

monster_pos:
monster_posx:	ds.w	1	;used by _hit_monster
monster_posy:	ds.w	1

_num_storage:	ds.l	1

	ds.b	6

r_score_fd:
	ds.w	1

maze_tmp:
	ds.w	9	;$53be

maze_tmp2:
	ds.l	1	;$53ac

create_object_tmp:
	ds.b	5
	dc.b	0

installmenus_tmp:
	ds.l	1
	ds.l	1

do_menus_tmp:
	ds.l	1

	ds.b	104

_restore_bool:
	dc.w	0	;bool

	ds.b	30

_printf_tmp:
	ds.b	60

__things:
	dc.l	$00000000
__t_alloc:
	dc.l	$00000000

_player:	dc.l	0	;$00 0	next item in list
		dc.l	0	;$04 4	previous item in list
		dc.w	0	;$08 8
		dc.w	0	;$0A 10 position
		dc.w	0	;$0C 12 position
		dc.b	0	;$0E 14 set to 1 at monster creation
		dc.b	0	;$0F 15 xerox stuff
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
_nh1:	dc.w	$0000
_nh2:	dc.w	$0000

_cur_ring:
_cur_ring_1:	ds.l	1
_cur_ring_2:	ds.l	1

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

_want:	ds.b	64	;color palette of the images is loaded to here (unused now)

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

