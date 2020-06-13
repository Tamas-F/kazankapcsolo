LSetTimer
		TMR_DEC	LSlow_Timer
		TMR_DEC	LFast_Timer

		movlw	L_SBL
		tstfsz	LSlow_Timer
		bra	$+6
		movwf	LSlow_Timer
		btg	B_LSlow

		movlw	L_FBL
		tstfsz	LFast_Timer
		bra	$+6
		movwf	LFast_Timer	
		btg	B_LFast


		return
;+=========================================================================+
;|                                                                         |
;|                                                                         |
;+=========================================================================+
LGreen_Proc	btfsc	LGreen_ON0
		bra	LGreen_Proc_X1
		btfsc	LGreen_ON1
		bra	LGreen_Proc_10
		bra	LGreen_Proc_00
LGreen_Proc_X1
		btfsc	LGreen_ON1
		bra	LGreen_Proc_11
		bra	LGreen_Proc_01
;-----
LGreen_Proc_00		;Kikapcsolva
		bcf	OUT_Zold
		return
LGreen_Proc_11
		bsf	OUT_Zold
		return

LGreen_Proc_01
		bcf	OUT_Zold
		btfsc	B_LSlow
		bsf	OUT_Zold
		return
LGreen_Proc_10
		bcf	OUT_Zold
		btfsc	B_LFast
		bsf	OUT_Zold
		return
;+=========================================================================+
;|                                                                         |
;|                                                                         |
;+=========================================================================+
LRed_Proc	btfsc	LRed_ON0
		bra	LRed_Proc_X1
		btfsc	LRed_ON1
		bra	LRed_Proc_10
		bra	LRed_Proc_00
LRed_Proc_X1
		btfsc	LRed_ON1
		bra	LRed_Proc_11
		bra	LRed_Proc_01
;-----
LRed_Proc_00		;Kikapcsolva
		bcf	OUT_Piros
		return
LRed_Proc_11
		bsf	OUT_Piros
		return

LRed_Proc_01
		bcf	OUT_Piros
		btfsc	B_LSlow
		bsf	OUT_Piros
		return
LRed_Proc_10
		bcf	OUT_Piros
		btfsc	B_LFast
		bsf	OUT_Piros
		return
;+=========================================================================+
;|                                                                         |
;|                                                                         |
;+=========================================================================+
LBlue_Proc	btfsc	LBlue_ON0
		bra	LBlue_Proc_X1
		btfsc	LBlue_ON1
		bra	LBlue_Proc_10
		bra	LBlue_Proc_00
LBlue_Proc_X1
		btfsc	LBlue_ON1
		bra	LBlue_Proc_11
		bra	LBlue_Proc_01
;-----
LBlue_Proc_00		;Kikapcsolva
		bcf	OUT_Kek
		return
LBlue_Proc_11
		bsf	OUT_Kek
		return

LBlue_Proc_01
		bcf	OUT_Kek
		btfsc	B_LSlow
		bsf	OUT_Kek
		return
LBlue_Proc_10
		bcf	OUT_Kek
		btfsc	B_LFast
		bsf	OUT_Kek
		return

;+=========================================================================+
;|                                                                         |
;|                                                                         |
;+=========================================================================+
LYellow_Proc	btfsc	LYellow_ON0
		bra	LYellow_Proc_X1
		btfsc	LYellow_ON1
		bra	LYellow_Proc_10
		bra	LYellow_Proc_00
LYellow_Proc_X1
		btfsc	LYellow_ON1
		bra	LYellow_Proc_11
		bra	LYellow_Proc_01
;-----
LYellow_Proc_00		;Kikapcsolva
		bcf	OUT_Yellow
		return
LYellow_Proc_11		;Bekapcsolva
		bsf	OUT_Yellow
		return

LYellow_Proc_01		;Lassan villog
		bcf	OUT_Yellow
		btfsc	B_LSlow
		bsf	OUT_Yellow
		return
LYellow_Proc_10		;gyorsan villog
		bcf	OUT_Yellow
		btfsc	B_LFast
		bsf	OUT_Yellow
		return
