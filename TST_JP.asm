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
		Skip_JPOpen		;A jumper össze van kötve
		goto	JP_Proc_1	;Igen
					;Nem,
		clrf	JP_Timer
		decf	JP_Timer,f	;belerakjuk az FF-et
		return

JP_Proc_1	decf	JP_Timer,f
		
		clrf	PLC_Out8Reg	;**TEST FUNKCIÓ**
		movlw	100
		movwf	PLC_TstTimer	;timert felhúzzuk

		
		movlw	1
		xorwf	JP_Timer,w	;letelt az óra
		sz
		goto	JP_Proc_2	;Még nem, vagy már régen

;		movlw	0
;		call	Init_SIO_GETSPBRG
;		movwf	SPBRG		;Baud rate reg.
		movlw	0xff
		movwf	SIO_TAddr

;		clrf	JP_Timer
		LED1_ON
		return

JP_Proc_2	movlw	0
		xorwf	JP_Timer,w	;letelt az óra
		sz
		return			;Még nem
		incf	JP_Timer,f
		LED1_ON
		return			;
		
