		byte	JP_Timer,0

#define		JP_IN			PORTA,3
#define		JP_IN_TRIS		PORTA+dTRISx,3

#define         Skip_JPOpen             btfss JP_IN
#define         Skip_JPClose            btfsC JP_IN


