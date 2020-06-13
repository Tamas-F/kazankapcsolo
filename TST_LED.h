	word	LED0_Timer,0
	word	LED1_Timer,0


#define		LED0_HWREG		PORTA
#define		LED0_BIT		1
#define		LED0			LED0_HWREG,LED0_BIT
#define		LED0_TRIS		LED0_HWREG+dTRISx,LED0_BIT

#define		LED0_ON			bcf LED0,0
#define		LED0_OFF 		bsf LED0,0
#define		LED0_TOGGLE		btg LED0,0


#define		SkipLED0_ON		btfsc LED0,0	;
#define		SkipLED0_OFF 		btfss LED0,0


#define		LED0_INIT_TIMER		2
#define		LED0_INIT_TIMER1	2


#define		LED1_HWREG		PORTA
#define		LED1_BIT		2
#define		LED1			LED1_HWREG,LED1_BIT
#define		LED1_TRIS		LED1_HWREG+dTRISx,LED1_BIT

#define		LED1_ON			bcf LED1,0
#define		LED1_OFF 		bsf LED1,0
#define		LED1_TOGGLE		btg LED1,0


#define		SkipLED1_ON		btfsc LED1,0	;
#define		SkipLED1_OFF 		btfss LED1,0


#define		LED1_INIT_TIMER		2
#define		LED1_INIT_TIMER1	2
