;+------------------------------------------------------------------+
;|     Init_JP                                                      |
;+------------------------------------------------------------------+
;|     rontott regiszterek :   i,j                                  |
;+------------------------------------------------------------------+
;|     funkcio:                                                     |
;|                                                                  |
;+------------------------------------------------------------------+

Init_JP 	bsf	JP_IN_TRIS
		clrf	JP_Timer
		return
;+------------------------------------------------------------------+
;|     JP_Proc                                                      |
;+------------------------------------------------------------------+
;|     rontott regiszterek :   i,j                                  |
;+------------------------------------------------------------------+
;|     funkcio:                                                     |
;|                                                                  |
;+------------------------------------------------------------------+
JP_Proc
		Skip_JPOpen		;A jumper �ssze van k�tve
		goto	JP_Proc_1	;Igen
					;Nem,
		clrf	JP_Timer
		decf	JP_Timer,f	;belerakjuk az FF-et
		return

JP_Proc_1	decf	JP_Timer,f
		
		clrf	PLC_Out8Reg	;**TEST FUNKCI�**
		movlw	100
		movwf	PLC_TstTimer	;timert felh�zzuk

		
		movlw	1
		xorwf	JP_Timer,w	;letelt az �ra
		sz
		goto	JP_Proc_2	;M�g nem, vagy m�r r�gen

;		movlw	0
;		call	Init_SIO_GETSPBRG
;		movwf	SPBRG		;Baud rate reg.
		movlw	0xff
		movwf	SIO_TAddr

;		clrf	JP_Timer
		LED1_ON
		return

JP_Proc_2	movlw	0
		xorwf	JP_Timer,w	;letelt az �ra
		sz
		return			;M�g nem
		incf	JP_Timer,f
		LED1_ON
		return			;
		
