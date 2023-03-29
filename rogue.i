
VS_FALL		equ	1
VS_MAGIC	equ	3

; wands/staffs

WS_LIGHT	equ	0
WS_STRIKING	equ	1
WS_LIGHTNING	equ	2
WS_FIRE		equ	3
WS_COLD		equ	4
WS_POLYMORPH	equ	5
WS_MISSILE	equ	6
WS_HASTE_M	equ	7
WS_SLOW_M	equ	8
WS_DRAIN	equ	9
WS_NOP		equ	10
WS_TELAWAY	equ	11
WS_TELTO	equ	12
WS_CANCEL	equ	13
MAXSTICKS	equ	14

; potions

P_CONFUSE	equ	0
P_PARALYSIS	equ	1
P_POISON	equ	2
P_STRENGTH	equ	3
P_SEEINVIS	equ	4
P_HEALING	equ	5
P_NIGHTV	equ	6
P_WISDOM	equ	7
P_RAISE		equ	8
P_XHEAL		equ	9
P_HASTE		equ	10
P_RESTORE	equ	11
P_BLIND		equ	12
P_QUENCH	equ	13
MAXPOTIONS	equ	14

; scrolls

S_CONFUSE   	equ	0
S_MAP       	equ	1
S_HOLDM      	equ	2
S_SLEEP     	equ	3
S_EARMOR     	equ	4
S_IDENTIFY 	equ	5
S_SCAREM     	equ	6
S_WILDMAGIC	equ	7
S_TELEP     	equ	8
S_EWEAPON      	equ	9
S_CREATEM    	equ	10
S_REMOVEC    	equ	11
S_AGGRAM      	equ	12
S_BLANK   	equ	13
S_VORPAW	equ	14
MAXSCROLLS  	equ	15

; rings

R_PROTECT	equ	0
R_ADDSTR	equ	1
R_SUSTSTR	equ	2
R_SEARCH	equ	3
R_SEEINVIS	equ	4
R_NOP		equ	5
R_AGGR		equ	6
R_ADDHIT	equ	7	;add dexterity
R_ADDDAM	equ	8	;increase damage
R_REGEN		equ	9	;regeneration
R_DIGEST	equ	10	;slow digestion
R_TELEPORT	equ	11
R_STEALTH	equ	12
R_SUSTARM	equ	13
MAXRINGS	equ	14

; weapons

W_MACE		equ	0
W_SWORD		equ	1
W_BOW		equ	2
W_ARROW		equ	3
W_DAGGER	equ	4
W_TWOSWORD	equ	5
W_DART		equ	6
W_CROSSBOW	equ	7
W_CROSSBOLT	equ	8
W_FLAIL		equ	9
W_FLAME		equ	10   /* fake entry for dragon breath (ick) */
MAXWEAPONS	equ	10   /* this should equal FLAME */

; armor

A_LEATHER		equ	0
A_RING_MAIL		equ	1
A_STUDDED_LEATHER	equ	2
A_SCALE_MAIL		equ	3
A_CHAIN_MAIL		equ	4
A_SPLINT_MAIL		equ	5
A_BANDED_MAIL		equ	6
A_PLATE_MAIL		equ	7
MAXARMORS		equ	8

; flags for objects

O_ISCURSED	equ	1
O_ISKNOW	equ	2	;100% sure
O_SLAYERUSED	equ	4
O_SCAREUSED	equ	8
O_ISMISL	equ	$10	;100% sure
O_ISMANY	equ	$20	;100% sure
O_SPECKNOWN	equ	$40	;special feature known flag, used for slayer weapon

; flags for creatures and player

C_ISBLIND	equ	$0001	;creature is blind
C_WISDOM	equ	$0002	;creature has wisdom
C_ISRUN		equ	$0004	;creature is running at the player
C_ISFOUND	equ	$0008	;creature has been seen
C_ISINVIS	equ	$0010	;creature is invisible
C_ISMEAN	equ	$0020	;creature can wake when player enters room
C_ISGREED	equ	$0040	;creature runs to protect gold
C_ISHELD	equ	$0080	;creature has been held
C_ISHUH		equ	$0100	;creature is confused
C_ISREGEN	equ	$0200	;creature can regenerate
C_CANHUH	equ	$0400	;creature can confuse
C_CANSEE	equ	$0800	;creature can see invisible creatures
C_ISCANC	equ	$1000	;creature has special qualities cancelled
C_ISSLOW	equ	$2000	;creature has been slowed
C_ISHASTE	equ	$4000	;creature has been hastened
C_ISFLY		equ	$8000	;creature can fly

;object struct:

;82 38 ;$00		next item in list
;7e 34 ;$04		previous item in list
;7a 30 ;$08
;78 2e ;$0A	10	type of object (scroll/potion/weapon...)
;76 2c ;$0C	12	x
;74 2a ;$0E	14	y
;72 28 ;$10	16	pointer to packname
;6e 24 ;$14	20	baseweapon for arrows/crossbowbolts
;6c 22 ;$16	22	pointer to wield damage
;68 1e ;$1A	26	pointer to throw damage
;64 1a ;$1E	30	number of items of this object
;62 18 ;$20	32	subtype of object (which scroll/potion/weapon...)
;60 16 ;$22	34	+hit
;14 ;$24	36	+damage
;12 ;$26	38	charges for staff/wand or +hit/damage with rings or armor points
;10 ;$28	40	flags of object
;08 ;$2A	42	monster slayer
;06 ;$2C	44	group of object
