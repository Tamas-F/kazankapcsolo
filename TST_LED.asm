;+------------------------------------------------------------------+
;|     LED0_ON_fun                                                  |
;+------------------------------------------------------------------+
;|     rontott regiszterek :                                        |
;+------------------------------------------------------------------+
;|     funkcio:                                                     |
;|                                                                  |
;+------------------------------------------------------------------+
Init_LED0
                movlw   LED0_INIT_TIMER1
                movwf   LED0_Timer+1,0
		bcf	LED0_TRIS
		bcf	LED0
                return
Init_LED1
                movlw   LED1_INIT_TIMER1
                movwf   LED1_Timer+1,0
		bcf	LED1_TRIS
		bcf	LED1
                return

;+------------------------------------------------------------------+
;|     LED0_ON_fun                                                  |
;+------------------------------------------------------------------+
;|     rontott regiszterek :                                        |
;+------------------------------------------------------------------+
;|     funkcio:                                                     |
;|                                                                  |
;+------------------------------------------------------------------+
LED0_ON_Fun    
		movlw	LED0_INIT_TIMER
               	movwf	LED0_Timer,0
                movlw   LED0_INIT_TIMER1
                movwf   LED0_Timer+1,0
		bcf	LED0_TRIS
		LED0_ON
                return
LED1_ON_Fun     
		movlw	LED1_INIT_TIMER
               	movwf	LED1_Timer,0
                movlw   LED1_INIT_TIMER1
                movwf   LED1_Timer+1,0
		LED1_ON
                return

;+------------------------------------------------------------------+
;|     Led0_Proc                                                     |
;+------------------------------------------------------------------+
;|     rontott regiszterek :   i,j                                  |
;+------------------------------------------------------------------+
;|     funkcio:                                                     |
;|                                                                  |
;+------------------------------------------------------------------+
LED0_Proc       tstfsz  LED0_Timer,0
                return
;--------------
		movlw	LED0_INIT_TIMER
               	movwf	LED0_Timer,0

                movlw   LED0_INIT_TIMER1
                SkipLED0_ON             ;Bekapcsolva a LED0?
                movwf   LED0_Timer+1,0  ;Nem, inicializ�ljuk a timert

                SkipLED0_ON             ;Bekapcsolva a LED0?
                return                  ;Nem, nem csin�lunk semmit

;--------------                         ;Igen, elkezdjuk az id�z�t�st
                decf    LED0_Timer+1,f,0
                sz                      ;Ki kell mostm�r kapcsolni?
                return                  ;Meg nem telt le az id�, NEM
                LED0_OFF                ;Letelt, most m�r kikapcsolhat�
                return

LED1_Proc       tstfsz  LED1_Timer,0
                return
;--------------
		movlw	LED1_INIT_TIMER
               	movwf	LED1_Timer,0

                movlw   LED1_INIT_TIMER1
                SkipLED1_ON             ;Bekapcsolva a LED1?
                movwf   LED1_Timer+1,0  ;Nem, inicializ�ljuk a timert

                SkipLED1_ON             ;Bekapcsolva a LED1?
                return                  ;Nem, nem csin�lunk semmit

;--------------                         ;Igen, elkezdjuk az id�z�t�st
                decf    LED1_Timer+1,f,0
                sz                      ;Ki kell mostm�r kapcsolni?
                return                  ;Meg nem telt le az id�, NEM
                LED1_OFF                ;Letelt, most m�r kikapcsolhat�
                return

