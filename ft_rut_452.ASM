;====================================================================
;=                                                                  =
;=              RENDSZER RUTINOK                                    =
;=                                                                  =
;====================================================================
	NOEXPAND
wait15          nop
wait14          nop
wait13          nop
wait12          nop
wait11          nop
wait10          nop
wait9           nop
wait8           nop
wait7           nop
wait6           nop
wait5           nop
wait4           return
;-------
wait_2us	nop			;az elozo mov i,#lit utasitassal
		nop                     ;egyutt i*2 usec !
		decf	i,f		;20MHz-es oraval
		snz
		return
		nop
		nop
		nop
		goto	wait_2us
;-------
wait_1ms
                movlw   D'250'
                movwf   i
                call    wait_2us
                movlw   D'250'
                movwf   i
                call    wait_2us
                return
;-------
wait_200ms
                movlw   D'100'
                movwf   j
wait_200ms_1    call    wait_1ms
                decf    j,f
                sz
                goto    wait_200ms_1
                return
	EXPAND

;+------------------------------------------------------------------+
;|     INIT_RAMS                                                    |
;+------------------------------------------------------------------+
;|     rontott regiszterek :all general purpose RAM                 |
;+------------------------------------------------------------------+
;|     funkcio: Az osszes RAM mezo feltoltese 0-val,                |
;|                                                                  |
;+------------------------------------------------------------------+
	NOEXPAND
Init_RAMs
	lfsr	FSR0,0	;a memoria kezdocime
	movlw	5
init_1
	clrf	POSTINC0,0	;iras a memoriaba

	movlw	0x5
	cpfseq	FSR0H
	goto	init_1 
	movlw	0xf3
	cpfseq	FSR0L
	goto	init_1 

	return

	EXPAND
