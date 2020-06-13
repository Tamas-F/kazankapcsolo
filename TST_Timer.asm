;+------------------------------------------------------------------+
;|     INIT_TMR0                                                    |
;+------------------------------------------------------------------+
;|     rontott regiszterek : w,i,STATUS,TMR0 bitek                  |
;+------------------------------------------------------------------+
;|     funkcio:                                                     |
;+------------------------------------------------------------------+
Init_TMR0	clrf	i,0
		btfsc	INTCON,GIEH,0	;High Priority IT engedelyezve?
		bsf	i,7,0		;igen,  ezert megjegyezzuk
		btfsc	INTCON,GIEH,0	;Low Priority IT engedelyezve?
		bsf	i,6,0		;igen,  ezert megjegyezzuk

		bcf	INTCON,GIEH,0	;High IT disabled.
		bcf	INTCON,GIEL,0	;Low IT disabled.

		movlw	INIT_T0CON_REG
		movwf	T0CON,0	

		lfsr	FSR0,Init_TMR0_Reg
		movlw	Init_TMR0_L
		movwf	POSTINC0
		movlw	Init_TMR0_H
		movwf	POSTINC0
		movff	Init_TMR0_Reg,TMR0L
		movff	Init_TMR0_Reg+1,TMR0H

		bsf	INTCON2,TMR0IP,0;TMR0 High priority IT
		bcf	INTCON,TMR0IF,0	;IT flag törlése
		bsf	INTCON,TMR0IE,0	;IT engedélyezése

		btfsc	i,7,0		;High IT a rutin elott ??
		bsf	INTCON,GIEH,0	;engedelyezve volt, 
		btfsc	i,6,0		;Low IT a rutin elott ??
		bsf	INTCON,GIEL,0	;engedelyezve volt, 
		return

;+------------------------------------------------------------------+
;|     INIT_TMR1                                                    |
;+------------------------------------------------------------------+
;|     rontott regiszterek : w,i,STATUS, TMR1 bitek                  |
;+------------------------------------------------------------------+
;|     funkcio: A TMR1-es timer felprogramozasa 1ms-os idoalapra.   |
;|              Ez szolgaltatja a redszernek (taszkoknak) az orat   |
;+------------------------------------------------------------------+
Init_TMR1	clrf	i,0
		btfsc	INTCON,GIEH,0	;High Priority IT engedelyezve?
		bsf	i,7,0		;igen,  ezert megjegyezzuk
		btfsc	INTCON,GIEH,0	;Low Priority IT engedelyezve?
		bsf	i,6,0		;igen,  ezert megjegyezzuk

		bcf	INTCON,GIEH,0	;High IT disabled.
		bcf	INTCON,GIEL,0	;Low IT disabled.

		movlw	INIT_T1CON_REG                     
		movwf	T1CON,0

		lfsr	FSR0,Init_TMR1_Reg
		movlw	Init_TMR1_L
		movwf	POSTINC0
		movlw	Init_TMR1_H
		movwf	POSTINC0
		movff	Init_TMR1_Reg,TMR1L
		movff	Init_TMR1_Reg+1,TMR1H
		
		bsf	IPR1,TMR1IP,0	;TMR0 High priority IT
		bcf	PIR1,TMR1IF,0	;IT flag törlése
		bsf	PIE1,TMR1IE,0	;IT engedélyezése

		btfsc	i,7,0		;High IT a rutin elott ??
		bsf	INTCON,GIEH,0	;engedelyezve volt, 
		btfsc	i,6,0		;Low IT a rutin elott ??
		bsf	INTCON,GIEL,0	;engedelyezve volt, 
		return
;+------------------------------------------------------------------+
;|     Init_HWwatchDog                                              |
;+------------------------------------------------------------------+
;|     rontott regiszterek :                                        |
;+------------------------------------------------------------------+
;|     funkcio:                                	                    |
;|                                                                  |
;+------------------------------------------------------------------+
Init_HWwatchDog
		clrwdt
		bsf	WDTCON,SWDTEN,0
		return

;+------------------------------------------------------------------+
;|     TMR0_IT_FUN                                                  |
;+------------------------------------------------------------------+
;|     rontott regiszterek : w                                      |
;+------------------------------------------------------------------+
;|     funkcio:                                                     |
;|              IT-bol hivott fuggveny, GIE=0 !!!                   |
;+------------------------------------------------------------------+
Tmr0_IT		btfss	INTCON,TMR0IF,0	;Ha a TMR1 az IT okozo
		return

		movff	Init_TMR0_Reg,TMR0L
		movff	Init_TMR0_Reg+1,TMR0H

               
		bcf	INTCON,TMR0IF,0	;Az IT flag visszatorlese
		return

;+------------------------------------------------------------------+
;|     TMR1_IT_FUN                                                  |
;+------------------------------------------------------------------+
;|     rontott regiszterek : w                                      |
;+------------------------------------------------------------------+
;|     funkcio:                                                     |
;|              IT-bol hivott fuggveny, GIE=0 !!!                   |
;+------------------------------------------------------------------+
Tmr1_IT		btfss	PIR1,TMR1IF,0	;Ha a TMR1 az IT okozo
		return
		movff	Init_TMR1_Reg,TMR1L
		movff	Init_TMR1_Reg+1,TMR1H

		TMR_DEC System_Timer

		bcf	PIR1,TMR1IF,0	;Az IT flag visszatorlese

		return

 
