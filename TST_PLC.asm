;+=========================================================================+
;|                                                                         |
;|                                                                         |
;+=========================================================================+
Init_PLC	
		movlw	0xe
		movwf	System_State		;Nem ismert az állapotunk


		movlw	COMM_TMO		;Felhúzzuk a COMM TimeOutját
		movwf	Comm_Timer,1
		
;		clrf	PLC_Out8Reg	;**TEST FUNKCIÓ**
;		movlw	200
;		movwf	PLC_TstTimer	;timert felhúzzuk

		return
;--------------------------------------------------------------------------
Init_Kazan
		movlw	0
		movff	WREG, Kazan_Status
		movlw	0
		movff	WREG, Kazan_Phase
		return
;--------------------------------------------------------------------------
Init_Villany
		movlw	INIT_VILLANY_TIMER_1S
		movff	WREG, Villany_Timer
		movlw	0
		movff	WREG, Villany_Status
		movlw	0
		movff	WREG, Villany_Status1
		movlw	0
		movff	WREG, Villany_Phase
		movlw	0
		movff	WREG, Villany_TC_Phase
		movlw	0
		movff	WREG, Villany_TC_Status
		movlw	0
		movff	WREG, Villany_TC_Timer
		movlw	0
		movff	WREG, Villany_TC_Timer_State
		movlw	0
		movff	WREG, Villany_TC_Counter
		movlw	0
		movff	WREG, Villany_TC_OFF_Timer
		movlw	0
		movff	WREG, Villany_TC_OFF_Phase
		return
;--------------------------------------------------------------------------
Init_Idozito
		movlw	INIT_IDOZITO_TIMER_1S
		movff	WREG, Idozito_Timer
		movlw	0
		movff	WREG, Idozito_Status	
		return
;--------------------------------------------------------------------------
;Init_Sziv
;		movlw	0
;		movff	WREG, Sziv_Status
;		movlw	INIT_SZIV_TIMO_TIMER1
;		movff	WREG, Sziv_TIMO_Timer
;		movlw	INIT_SZIV_TIMO_TIMER2
;		movff	WREG, Sziv_TIMO_Timer+1
;		movlw	INIT_SZIV_FIGYEL_TIMER1
;		movff	WREG, Sziv_Figyel_Timer
;		movlw	INIT_SZIV_FIGYEL_TIMER2
;		movff	WREG, Sziv_Figyel_Timer+1
;		movlw	0
;		movff	WREG, Sziv_TIMO_Timer_Counter
;		movlw	0
;		movff	WREG, Sziv_TC_Phase
;		movlw	0
;		movff	WREG, Sziv_TC_Timer
;		movlw	0
;		movff	WREG, Sziv_TC_Counter
;		return		
;--------------------------------------------------------------------------
Init_Villany_TIMO
		movlw	INIT_VILLANY_TIMO_TIMER1
		movff	WREG, Villany_TIMO_Timer
		movlw	INIT_VILLANY_TIMO_TIMER2
		movff	WREG, Villany_TIMO_Timer+1

		clrf	Villany_TIMO_Timer_Counter
		return
;--------------------------------------------------------------------------
Init_Futes_TIMO
		movlw	INIT_FUTES_TIMO_TIMER1
		movff	WREG, Futes_TIMO_Timer
		movlw	INIT_FUTES_TIMO_TIMER2
		movff	WREG, Futes_TIMO_Timer+1

		clrf	Futes_TIMO_Timer_Counter
		return
;--------------------------------------------------------------------------
Init_Gomb0
		clrf	Gomb0_Phase
		clrf	Gomb0_Timer
		clrf	Gomb0_Timer_b
		clrf	Gomb0_Status
		return
;--------------------------------------------------------------------------
Init_Gomb1
		clrf	Gomb1_Phase
		clrf	Gomb1_Timer
		clrf	Gomb1_Timer_b
		clrf	Gomb1_Status
		return
;+=========================================================================+
;|                                                                         |
;|                                                                         |
;+=========================================================================+
Gomb0_Proc
		movlw	0
		xorwf	Gomb0_Phase,w
		bz	Gomb0_Proc0
		movlw	1
		xorwf	Gomb0_Phase,w
		bz	Gomb0_Proc1
		movlw	2
		xorwf	Gomb0_Phase,w
		bz	Gomb0_Proc2
		movlw	3
		xorwf	Gomb0_Phase,w
		bz	Gomb0_Proc3

		clrf	Gomb0_Phase
		return
;-----------------------
Gomb0_Proc0
		Skip_Gomb0
		return
		movlw	2
		movff	WREG, Gomb0_Phase
		movlw	GOMB_PRELL
		movff	WREG, Gomb0_Timer
		return
;--------------
Gomb0_Proc1
		Next_Gomb0
		bra	Gomb0_Proc1_L_2S
		movlw	3
		movff	WREG, Gomb0_Phase
		movlw	GOMB_PRELL
		movff	WREG, Gomb0_Timer
		return
;---
Gomb0_Proc1_L_2S
		tstfsz	Gomb0_Timer_b
		return
		bsf	B_Gomb0_PressL
		movlw	GOMB_L
		movff	WREG, Gomb0_Timer_b
		return
;--------------
Gomb0_Proc2
		Next_Gomb0
		bra 	Gomb0_Proc2_Press
		movlw	0
		movff	WREG, Gomb0_Phase
		return
;---
Gomb0_Proc2_Press
		tstfsz	Gomb0_Timer
		return
		bsf	B_Gomb0_Press
		movlw	1
		movff	WREG, Gomb0_Phase
		movlw	GOMB_L
		movff	WREG, Gomb0_Timer_b
		return
;--------------
Gomb0_Proc3
		Skip_Gomb0
		bra	Gomb0_Proc3_NoPress
		movlw	1
		movff	WREG, Gomb0_Phase
		return
;---
Gomb0_Proc3_NoPress
		tstfsz	Gomb0_Timer
		return
		bcf	B_Gomb0_Press
		bsf	B_Gomb0_Press10
		movlw	0
		movff	WREG, Gomb0_Phase
		return

;+=========================================================================+
;|                                                                         |
;|                                                                         |
;+=========================================================================+
Gomb1_Proc
		movlw	0
		xorwf	Gomb1_Phase,w
		bz	Gomb1_Proc0
		movlw	1
		xorwf	Gomb1_Phase,w
		bz	Gomb1_Proc1
		movlw	2
		xorwf	Gomb1_Phase,w
		bz	Gomb1_Proc2
		movlw	3
		xorwf	Gomb1_Phase,w
		bz	Gomb1_Proc3

		clrf	Gomb1_Phase
		return
;-----------------------
Gomb1_Proc0
		Skip_Gomb1
		return
		movlw	2
		movff	WREG, Gomb1_Phase
		movlw	GOMB_PRELL
		movff	WREG, Gomb1_Timer
		return
;--------------
Gomb1_Proc1
		Next_Gomb1
		bra	Gomb1_Proc1_L_2S
		movlw	3
		movff	WREG, Gomb1_Phase
		movlw	GOMB_PRELL
		movff	WREG, Gomb1_Timer
		return
;---
Gomb1_Proc1_L_2S
		tstfsz	Gomb1_Timer_b
		return
		bsf	B_Gomb1_PressL
		movlw	GOMB_L
		movff	WREG, Gomb1_Timer_b
		return
;--------------
Gomb1_Proc2
		Next_Gomb1
		bra 	Gomb1_Proc2_Press
		movlw	0
		movff	WREG, Gomb1_Phase
		return
;---
Gomb1_Proc2_Press
		tstfsz	Gomb1_Timer
		return
		bsf	B_Gomb1_Press
		movlw	1
		movff	WREG, Gomb1_Phase
		movlw	GOMB_L
		movff	WREG, Gomb1_Timer_b
		return
;--------------
Gomb1_Proc3
		Skip_Gomb1
		bra	Gomb1_Proc3_NoPress
		movlw	1
		movff	WREG, Gomb1_Phase
		return
;---
Gomb1_Proc3_NoPress
		tstfsz	Gomb1_Timer
		return
		bcf	B_Gomb1_Press
		bsf	B_Gomb1_Press10
		movlw	0
		movff	WREG, Gomb1_Phase
		return

;+=========================================================================+
;|                                                                         |
;|                                                                         |
;+=========================================================================+
Kazan_Proc
		movlw	0
		xorwf	Kazan_Phase,w
		bz	Kazan_Proc0
		movlw	1
		xorwf	Kazan_Phase,w
		bz	Kazan_Proc1

		clrf	Kazan_Phase
		return
;------------------------
Kazan_Proc0
		Skip_Kazan
		return
		bsf	B_Kazan_BE
		incf	Kazan_Phase
		return
;--------------
Kazan_Proc1
		Next_Kazan
		return
		bsf	B_Kazan_KI
		decf	Kazan_Phase
		return
;+=========================================================================+
;|                                                                         |
;|                                                                         |
;+=========================================================================+
Villany_Proc
		movlw	0
		xorwf	Villany_Phase,w
		bz	Villany_Proc0
		movlw	1
		xorwf	Villany_Phase,w
		bz	Villany_Proc1
		movlw	2
		xorwf	Villany_Phase,w
		bz	Villany_Proc2
		movlw	3
		xorwf	Villany_Phase,w
		bz	Villany_Proc3

		movlw	0
		movff	WREG,Villany_Phase
		return
;-----------------------
Villany_Proc0
		Next_SWVillany
		bra	Villlany_Proc0_Next1
		bsf	VillanySW00
		movlw	INIT_VILLANY_TIMER_1S
		movff	WREG, Villany_Timer
		return
;-----
Villlany_Proc0_Next1
		bsf	VillanySW01
		movlw	1
		movff	WREG,Villany_Phase
		return
;--------------
Villany_Proc1
		Skip_SWVillany
		bra	Villany_Proc1_Next0
		tstfsz	Villany_Timer
		return
		bsf	VillanySW1
		movlw	2
		movff	WREG,Villany_Phase
		return
;-----
Villany_Proc1_Next0
		bsf	VillanySW010
		movlw	0
		movff	WREG,Villany_Phase
		return
;--------------
Villany_Proc2
		Skip_SWVillany
		bra	Villany_Proc2_Next3
		bsf	VillanySW11
		movlw	INIT_VILLANY_TIMER_1S
		movff	WREG,Villany_Timer
		return
;-----
Villany_Proc2_Next3
		bsf	VillanySW10
		movlw	3
		movff	WREG,Villany_Phase
		return
;--------------
Villany_Proc3
		Next_SWVillany
		bra	Villany_Proc3_Next2
		tstfsz	Villany_Timer
		return
		bsf	VillanySW0
		movlw	0
		movff	WREG,Villany_Phase
		return
;-----
Villany_Proc3_Next2
		bsf	VillanySW101
		movlw	2
		movff	WREG,Villany_Phase
		return

;+=========================================================================+
;|                                                                         |
;|                                                                         |
;+=========================================================================+
Idozito_Proc
		movlw	0
		xorwf	Idozito_Phase,w
		bz	Idozito_Proc0
		movlw	1
		xorwf	Idozito_Phase,w
		bz	Idozito_Proc1
		movlw	2
		xorwf	Idozito_Phase,w
		bz	Idozito_Proc2
		movlw	3
		xorwf	Idozito_Phase,w
		bz	Idozito_Proc3

		movlw	0
		movff	WREG,Idozito_Phase
		return
;-----------------------
Idozito_Proc0
		Next_Idozito
		bra	Idozito_Proc0_Next1
		bsf	IdozitoSW00
		movlw	INIT_IDOZITO_TIMER_1S
		movff	WREG,Idozito_Timer
		return
;-----
Idozito_Proc0_Next1
		bsf	IdozitoSW01
		movlw	1
		movff	WREG,Idozito_Phase
		return
;--------------
Idozito_Proc1
		Skip_Idozito
		bra	Idozito_Proc1_Next0
		tstfsz	Idozito_Timer
		return
		bsf	IdozitoSW1
		movlw	2
		movff	WREG,Idozito_Phase
		return
;-----
Idozito_Proc1_Next0
		bsf	IdozitoSW010
		movlw	0
		movff	WREG,Idozito_Phase
		return
;--------------
Idozito_Proc2
		Skip_Idozito
		bra	Idozito_Proc2_Next3
		bsf	IdozitoSW11
		movlw	INIT_IDOZITO_TIMER_1S
		movff	WREG,Idozito_Timer
		return
;-----
Idozito_Proc2_Next3
		bsf	IdozitoSW10
		movlw	3
		movff	WREG,Idozito_Phase
		return
;--------------
Idozito_Proc3
		Next_Idozito
		bra	Idozito_Proc3_Next2
		tstfsz	Idozito_Timer
		return
		bsf	IdozitoSW0
		movlw	0
		movff	WREG,Idozito_Phase
		return
;-----
Idozito_Proc3_Next2
		bsf	IdozitoSW101
		movlw	2
		movff	WREG,Idozito_Phase
		return

;+=========================================================================+
;|                                                                         |
;|                                                                         |
;+=========================================================================+
PLC_Villany_Proc
		btfsc	B_Gomb0_Press		;Gomb0-át megnyomták?
		bra	PLC_Villany_Proc_G0Press	;igen

		btfsc	B_Gomb0_PressL		;nem, Gomb0-át hosszan megnyomták?
		bra	PLC_Villany_Proc_G0PressL	;igen

		btfsc	VillanySW1		;a kapcsolóval kapcsolják fel a villanyt
		bra	PLC_Villany_Proc_IncTIMO_SW ;beállítjuk a timert kevés idõre
		
		btfsc	VillanySW0		;lekapcsolták a kapcsolót?
		bra	PLC_Villany_Proc_ki	;igen, villany le
		return

;--------------
PLC_Villany_Proc_G0Press
		bcf	B_Gomb0_Press
		tstfsz	Villany_TIMO_Timer_Counter
		bra	PLC_Villany_Proc_IncTIMO
		Skip_Villany
		bra	PLC_Villany_Proc_IncTIMO
		bra	PLC_Villany_Proc_ki
		return
;--------------
PLC_Villany_Proc_G0PressL
		bcf	B_Gomb0_PressL		;töröljük a Gomb0-hosszú bitet
		clrf	Villany_TIMO_Timer_Counter	;töröljük a timer countert
		SET_VILLANY
		SET_VILLANY_JELZO
		movlw	4		;felkapcsoljuk a jelzot, hogy hosszan megnyomták
		movff	WREG, Villany_TC_Phase
		return

;-------------- Növeljük a Villany Timerét
PLC_Villany_Proc_IncTIMO
		bcf	B_Gomb0_Press
		SET_VILLANY
			;eggyel növeljük a timercounter, ha az kisebb mint a max érték
		movlw	1
		addwf	Villany_TIMO_Timer_Counter, f

		movlw	256-MAX_VILLANY_TIMO_TIMER_COUNTER
		addwf	Villany_TIMO_Timer_Counter, w
		sc
		return

		movlw	MAX_VILLANY_TIMO_TIMER_COUNTER
		movff	WREG, Villany_TIMO_Timer_Counter
		return

;--------------
PLC_Villany_Proc_ki
		bcf	VillanySW0
		RST_VILLANY				;villany le
		RST_VILLANY_JELZO
		movlw	0
		movff	WREG, Villany_TC_Phase

		movlw	INIT_VILLANY_TIMO_TIMER1	;a timerek visszaállítása...
		movff	WREG, Villany_TIMO_Timer	;eredeti helyzetbe
		movlw	INIT_VILLANY_TIMO_TIMER2
		movff	WREG, Villany_TIMO_Timer+1
		clrf	Villany_TIMO_Timer_Counter
		return

;--------------
PLC_Villany_Proc_IncTIMO_SW
		bcf	VillanySW1
			;csak akkor álítjuk be a timert ha a villany nem ég
		Next_Villany
		return

		SET_VILLANY

		movlw	INIT_VILLANY_TIMO_TIMER1	;a timerek beállítása...
		movff	WREG, Villany_TIMO_Timer	;eredeti helyzetbe
		movlw	INIT_VILLANY_TIMO_TIMER_KICSI
		movff	WREG, Villany_TIMO_Timer+1
		movlw	1
		movff	WREG, Villany_TIMO_Timer_Counter
		
		return
;+=========================================================================+
;|                                                                         |
;|                                                                         |
;+=========================================================================+
Villany_TIMO_Proc
			;ha nincs beállítva timer kilépünk
		movlw	0
		xorwf	Villany_TIMO_Timer_Counter,w
		snz
		return


		TMR_DEC	Villany_TIMO_Timer
		tstfsz	Villany_TIMO_Timer
		return
		movlw	INIT_VILLANY_TIMO_TIMER1
		movff	WREG,Villany_TIMO_Timer
		TMR_DEC	Villany_TIMO_Timer+1
		tstfsz	Villany_TIMO_Timer+1
		return
		movlw	INIT_VILLANY_TIMO_TIMER2
		movff	WREG,Villany_TIMO_Timer+1
		TMR_DEC	Villany_TIMO_Timer_Counter
		tstfsz	Villany_TIMO_Timer_Counter
		return
		
		RST_VILLANY
		movlw	0
		movff	WREG, Villany_TIMO_Timer_Counter
		return
;----
;Villany_TIMO_Proc_Kicsi
;		TMR_DEC	Villany_TIMO_Timer
;		tstfsz	Villany_TIMO_Timer
;		return
;		movlw	INIT_VILLANY_TIMO_TIMER_KICSI1
;		movff	WREG,Villany_TIMO_Timer
;		TMR_DEC	Villany_TIMO_Timer+1
;		tstfsz	Villany_TIMO_Timer+1
;		return
;		movlw	INIT_VILLANY_TIMO_TIMER_KICSI2
;		movff	WREG,Villany_TIMO_Timer+1
;		TMR_DEC	Villany_TIMO_Timer_Counter
;		tstfsz	Villany_TIMO_Timer_Counter
;		return
;		
;		RST_VILLANY
;		movlw	0
;		movff	WREG, Villany_TIMO_Timer_Counter
;
;		bcf	B_Villany_Kicsi_TIMO
;		return
;+=========================================================================+
;|                                                                         |
;|                                                                         |
;+=========================================================================+
Villany_TC_Proc
		movlw	0
		xorwf	Villany_TC_Phase,w
		bz	Villany_TC_Proc_0_
		movlw	1
		xorwf	Villany_TC_Phase,w
		bz	Villany_TC_Proc_1_
		movlw	2
		xorwf	Villany_TC_Phase,w
		bz	Villany_TC_Proc_2_
		movlw	3
		xorwf	Villany_TC_Phase,w
		bz	Villany_TC_Proc_3_
		movlw	4
		xorwf	Villany_TC_Phase,w
		bz	Villany_TC_Proc_4_

		clrf	Villany_TC_Phase
		return
;--------------
Villany_TC_Proc_0_
		goto	Villany_TC_Proc_0
Villany_TC_Proc_1_
		goto	Villany_TC_Proc_1
Villany_TC_Proc_2_
		goto	Villany_TC_Proc_2
Villany_TC_Proc_3_
		goto	Villany_TC_Proc_3
Villany_TC_Proc_4_
		goto	Villany_TC_Proc_4
;--------------
Villany_TC_Proc_0
		Next_Villany
		bra	Villany_TC_Proc_0_a
		
		movlw	0
		xorwf	Villany_TC_OFF_Phase,w
		bz	Villany_TC_Proc_0_Off_0
		movlw	1
		xorwf	Villany_TC_OFF_Phase,w
		bz	Villany_TC_Proc_0_Off_1
		nop

		clrf	Villany_TC_OFF_Phase
		return
;---
Villany_TC_Proc_0_Off_0
		TMR_DEC	Villany_TC_OFF_Timer
		tstfsz	Villany_TC_OFF_Timer
		return
		SET_VILLANY_JELZO
		movlw	1
		movff	WREG, Villany_TC_OFF_Phase
		movlw	INIT_VILLANY_TC_OFF_TIMER_ON
		movff	WREG, Villany_TC_OFF_Timer
		return
;---
Villany_TC_Proc_0_Off_1
		TMR_DEC	Villany_TC_OFF_Timer
		tstfsz	Villany_TC_OFF_Timer
		return
		RST_VILLANY_JELZO
		movlw	0
		movff	WREG, Villany_TC_OFF_Phase
		movlw	INIT_VILLANY_TC_OFF_TIMER_OFF
		movff	WREG, Villany_TC_OFF_Timer
		return
;---
Villany_TC_Proc_0_a
		clrf	Villany_TC_OFF_Timer
		clrf	Villany_TC_OFF_Phase
		SET_VILLANY_JELZO
		movff	Villany_TIMO_Timer_Counter, WREG
		movwf	Villany_TC_Counter
		movlw	1
		movff	WREG, Villany_TC_Phase

		movlw	255-1
		addwf	Villany_TC_Counter, w
		sc
		bra	Villany_TC_Proc_0_max15

		movlw	INIT_VILLANY_TC_TIMER_ON_L
		movff	WREG, Villany_TC_Timer
		movlw	2
		movff	WREG, Villany_TC_Timer_State
		return
;---
Villany_TC_Proc_0_max15
		movff	Villany_TIMO_Timer+1, WREG
		movff	WREG, Villany_TC_Counter
		movlw	0
		movff	WREG, i
		movlw	255-(INIT_VILLANY_TIMO_TIMER2/3)
		addwf	Villany_TC_Counter,w
		snc
		bra	Villany_TC_Proc_0_M
		movlw 	INIT_VILLANY_TC_TIMER_ON_S
		movff	WREG, Villany_TC_Timer
		movlw	0
		movff	WREG, Villany_TC_Timer_State
Villany_TC_Proc_0_max15_cikl
		movlw	6
		subwf	Villany_TC_Counter, f
		sc
		bra	Villany_TC_Proc_0_max15_folyt
		incf	i
		bra	Villany_TC_Proc_0_max15_cikl
Villany_TC_Proc_0_max15_folyt
		movff	i, Villany_TC_Counter
		return
;---
Villany_TC_Proc_0_M
		movlw	0
		movff	WREG, i
Villany_TC_Proc_0_M_cikl
		movlw	30
		subwf	Villany_TC_Counter, f
		sc
		bra	Villany_TC_Proc_0_M_folyt
		incf	i
		bra	Villany_TC_Proc_0_M_cikl
Villany_TC_Proc_0_M_folyt
		movff	i, Villany_TC_Counter
		movlw 	INIT_VILLANY_TC_TIMER_ON_M
		movff	WREG, Villany_TC_Timer
		movlw	1
		movff	WREG, Villany_TC_Timer_State
		return
;--------------
Villany_TC_Proc_1
		TMR_DEC	Villany_TC_Timer
		tstfsz	Villany_TC_Timer
		return
		RST_VILLANY_JELZO

		TMR_DEC	Villany_TC_Counter
		tstfsz	Villany_TC_Counter
		bra	Villany_TC_Proc_1_Next2
		bra	Villany_TC_Proc_1_Next3

Villany_TC_Proc_1_Next2
		movlw	2
		movff	WREG, Villany_TC_Phase

		movlw	0
		xorwf	Villany_TC_Timer_State,w
		bz	Villany_TC_Proc_1_0
		movlw	1
		xorwf	Villany_TC_Timer_State,w
		bz	Villany_TC_Proc_1_1
		movlw	2
		xorwf	Villany_TC_Timer_State,w
		bz	Villany_TC_Proc_1_2

		clrf	Villany_TC_Timer_State
		return
;---
Villany_TC_Proc_1_0
		movlw	INIT_VILLANY_TC_TIMER_OFF_S
		movff	WREG, Villany_TC_Timer
		return
;---
Villany_TC_Proc_1_1
		movlw	INIT_VILLANY_TC_TIMER_OFF_M
		movff	WREG, Villany_TC_Timer
		return
;---
Villany_TC_Proc_1_2
		movlw	INIT_VILLANY_TC_TIMER_OFF_L
		movff	WREG, Villany_TC_Timer
		return
;-----
Villany_TC_Proc_1_Next3
		movlw	INIT_VILLANY_TC_TIMER_OFF_LONG
		movff	WREG, Villany_TC_Timer
		movlw	3
		movff	WREG, Villany_TC_Phase
		return
;--------------
Villany_TC_Proc_2
		TMR_DEC	Villany_TC_Timer
		tstfsz	Villany_TC_Timer
		return
		SET_VILLANY_JELZO
		movlw	1
		movff	WREG, Villany_TC_Phase
		
		movlw	0
		xorwf	Villany_TC_Timer_State,w
		bz	Villany_TC_Proc_2_0
		movlw	1
		xorwf	Villany_TC_Timer_State,w
		bz	Villany_TC_Proc_2_1
		movlw	2
		xorwf	Villany_TC_Timer_State,w
		bz	Villany_TC_Proc_2_2

		clrf	Villany_TC_Timer_State
		return
;---
Villany_TC_Proc_2_0
		movlw	INIT_VILLANY_TC_TIMER_ON_S
		movff	WREG, Villany_TC_Timer
		return
;---
Villany_TC_Proc_2_1
		movlw	INIT_VILLANY_TC_TIMER_ON_M
		movff	WREG, Villany_TC_Timer
		return
;---
Villany_TC_Proc_2_2
		movlw	INIT_VILLANY_TC_TIMER_ON_L
		movff	WREG, Villany_TC_Timer
		return
;--------------
Villany_TC_Proc_3
		TMR_DEC	Villany_TC_Timer
		tstfsz	Villany_TC_Timer
		return
		movlw	0
		movff	WREG, Villany_TC_Phase
		return
;--------------
Villany_TC_Proc_4
		SET_VILLANY_JELZO
		return
;+=========================================================================+
;|                                                                         |
;|                                                                         |
;+=========================================================================+
;PLC_Sziv_Proc
;		btfsc	B_Gomb1_Press			;Gomb1-et megnyomták?
;		bra	PLC_Sziv_Proc_G1_Press		;igen, ugrunk
;		btfsc	B_Gomb1_PressL			;Gomb1-et hosszan megnyomták?
;		bra	PLC_Sziv_Proc_G1_PressL		;igen, ugrunk
;		return
;;--------------
;PLC_Sziv_Proc_G1_Press
;			;töröljök a Gomb1 bitet
;		bcf	B_Gomb1_Press
;
;			;ha már a TIMO_Figyel-ben vagyunk leállítjuk a szivattyút
;		btfsc	B_Sziv_TIMO_Lejart
;		bra	PLC_Sziv_Proc_G1_Press_a
;
;			;bekapcsoljuk a szivattyút
;		SET_SZIV
;			;felhúzzuk a timereket
;		movlw	INIT_SZIV_FIGYEL_TIMER1
;		movff	WREG, Sziv_Figyel_Timer
;		movlw	INIT_SZIV_FIGYEL_TIMER2
;		movff	WREG, Sziv_Figyel_Timer+1
;
;			;eggyel tovább megy a szivatyú
;		movlw	1
;		addwf	Sziv_TIMO_Timer_Counter, f
;		movlw	256-MAX_SZIV_TIMO_TIMER_COUNTER
;		addwf	Sziv_TIMO_Timer_Counter, w
;		sc
;		return
;		movlw	MAX_SZIV_TIMO_TIMER_COUNTER
;		movff	WREG, Sziv_TIMO_Timer_Counter
;		return
;;-----
;PLC_Sziv_Proc_G1_Press_a
;			;felhúzzuk a timereket
;			;szivatyú le
;		bcf	B_Sziv_TIMO_Lejart
;
;		movlw	INIT_SZIV_FIGYEL_TIMER1
;		movff	WREG, Sziv_Figyel_Timer
;		movlw	INIT_SZIV_FIGYEL_TIMER2
;		movff	WREG, Sziv_Figyel_Timer+1
;
;		movlw	0
;		movff	WREG, Sziv_TIMO_Timer_Counter
;		movlw	0
;		movff	WREG, Sziv_TC_Phase
;
;		RST_SZIV
;		RST_SZIV_JELZO
;
;		return
;;--------------
;PLC_Sziv_Proc_G1_PressL
;		bcf	B_Gomb1_PressL
;		SET_SZIV
;		SET_SZIV_JELZO
;			;nincs timer
;		movlw	0
;		movff	WREG, Sziv_TIMO_Timer_Counter
;		movlw	INIT_SZIV_FIGYEL_TIMER1
;		movff	WREG, Sziv_Figyel_Timer
;		movlw	INIT_SZIV_FIGYEL_TIMER2
;		movff	WREG, Sziv_Figyel_Timer+1
;
;		movlw	INIT_SZIV_TIMO_TIMER1
;		movff	WREG, Sziv_TIMO_Timer
;		movlw	INIT_SZIV_TIMO_TIMER2
;		movff	WREG, Sziv_TIMO_Timer+1
;
;			;mindig nézzük a motort
;		bsf	B_Sziv_TIMO_Lejart
;		movlw	0
;		movff	WREG, Sziv_TC_Phase
;
;		return
;;+=========================================================================+
;;|                                                                         |
;;|                                                                         |
;;+=========================================================================+
;Sziv_TIMO_Proc
;		btfsc	B_Sziv_TIMO_Lejart	;a TIMO timer lejárt?
;		bra	Sziv_TIMO_Proc_Figyel	;igen, ugrunk
;
;			;ha nincs timer kilépünk
;		movlw	0
;		xorwf	Sziv_TIMO_Timer_Counter,w
;		snz
;		return
;
;			;várunk amíg lejár a timer
;		TMR_DEC	Sziv_TIMO_Timer
;		tstfsz	Sziv_TIMO_Timer
;		return
;		movlw	INIT_SZIV_TIMO_TIMER1
;		movff	WREG, Sziv_TIMO_Timer
;		TMR_DEC	Sziv_TIMO_Timer+1
;		tstfsz	Sziv_TIMO_Timer+1
;		return
;		movlw	INIT_SZIV_TIMO_TIMER2
;		movff	WREG, Sziv_TIMO_Timer+1
;		TMR_DEC	Sziv_TIMO_Timer_Counter
;		tstfsz	Sziv_TIMO_Timer_Counter
;		return
;
;			;timer lejárt, figyeljük a motort
;		bsf	B_Sziv_TIMO_Lejart
;		return
;;-------------
;Sziv_TIMO_Proc_Figyel
;			;ha a motor bekapcsolt, beállítjuk a timert
;		Next_Sziv_Motor
;		bra	Sziv_TIMO_Proc_Figyel_torol
;
;			;visszaszámlálás
;		TMR_DEC	Sziv_Figyel_Timer
;		tstfsz	Sziv_Figyel_Timer
;		return
;		movlw	INIT_SZIV_FIGYEL_TIMER1
;		movff	WREG, Sziv_Figyel_Timer
;		TMR_DEC	Sziv_Figyel_Timer+1
;		tstfsz	Sziv_Figyel_Timer+1
;		return
;		movlw	INIT_SZIV_FIGYEL_TIMER2
;		movff	WREG, Sziv_Figyel_Timer+1
;
;			;a motor egy ideje nem kapcsolt be
;			;lekapcsoljuk a szivattyút
;		RST_SZIV
;		RST_SZIV_JELZO
;		bcf	B_Sziv_TIMO_Lejart
;		movlw	0
;		movff	WREG, Sziv_TC_Phase
;
;		return
;;---
;Sziv_TIMO_Proc_Figyel_torol
;		movlw	INIT_SZIV_FIGYEL_TIMER1
;		movff	WREG, Sziv_Figyel_Timer
;		movlw	INIT_SZIV_FIGYEL_TIMER2
;		movff	WREG, Sziv_Figyel_Timer+1
;		return
;;+=========================================================================+
;;|                                                                         |
;;|                                                                         |
;;+=========================================================================+
;Sziv_TC_Proc
;		movlw	0
;		xorwf	Sziv_TC_Phase, w
;		bz	Sziv_TC_Proc0
;		movlw	1
;		xorwf	Sziv_TC_Phase, w
;		bz	Sziv_TC_Proc1
;		movlw	2
;		xorwf	Sziv_TC_Phase, w
;		bz	Sziv_TC_Proc2
;		movlw	3
;		xorwf	Sziv_TC_Phase, w
;		bz	Sziv_TC_Proc3
;		movlw	4
;		xorwf	Sziv_TC_Phase, w
;		bz	Sziv_TC_Proc4
;
;		movlw	0
;		movff	WREG, Sziv_TC_Phase
;		return
;;---------------------------------------------------------------------------
;Sziv_TC_Proc0
;		btfsc	B_Sziv_TIMO_Lejart
;		bra	Sziv_TC_Proc0_Next4
;		Next_Sziv
;		bra	Sziv_TC_Proc0_Next1
;		
;		return
;;---
;Sziv_TC_Proc0_Next1
;		SET_SZIV_JELZO
;		movff	Sziv_TIMO_Timer_Counter, Sziv_TC_Counter
;
;		movlw	INIT_SZIV_TC_TIMER_ON
;		movff	WREG, Sziv_TC_Timer
;		movlw	1
;		movff	WREG, Sziv_TC_Phase
;		return
;;---
;Sziv_TC_Proc0_Next4
;		movlw	4
;		movff	WREG, Sziv_TC_Phase
;		return
;;--------------
;Sziv_TC_Proc1
;		TMR_DEC	Sziv_TC_Timer
;		tstfsz	Sziv_TC_Timer
;		return
;
;		TMR_DEC Sziv_TC_Counter
;		tstfsz	Sziv_TC_Counter
;		bra	Sziv_TC_Proc1_Next2
;
;		RST_SZIV_JELZO
;		movlw	INIT_SZIV_TC_TIMER_OFF_L
;		movff	WREG, Sziv_TC_Timer
;		movlw	3
;		movff	WREG, Sziv_TC_Phase
;		return
;;---
;Sziv_TC_Proc1_Next2
;		RST_SZIV_JELZO
;		movlw	INIT_SZIV_TC_TIMER_OFF
;		movff	WREG, Sziv_TC_Timer
;		movlw	2
;		movff	WREG, Sziv_TC_Phase
;		return
;;--------------
;Sziv_TC_Proc2
;		TMR_DEC	Sziv_TC_Timer
;		tstfsz	Sziv_TC_Timer
;		return
;
;		SET_SZIV_JELZO
;		movlw	INIT_SZIV_TC_TIMER_ON
;		movff	WREG, Sziv_TC_Timer
;
;		movlw	1
;		movff	WREG, Sziv_TC_Phase
;		return
;;--------------
;Sziv_TC_Proc3
;		TMR_DEC	Sziv_TC_Timer
;		tstfsz	Sziv_TC_Timer
;		return
;
;		movlw	0
;		movff	WREG, Sziv_TC_Phase
;		return
;;--------------
;Sziv_TC_Proc4
;		SET_SZIV_JELZO
;		return
;;+=========================================================================+
;|                                                                         |
;|                                                                         |
;+=========================================================================+
PLC_Kazan_Proc
		btfsc	B_Kazan_BE		;a kazánt bekapcsolták?
		bra	PLC_Kazan_Proc_BE_egyszer	;igen, ugrunk
		Next_Kazan			;a kazán be van kapcsolva?
		bra	PLC_Kazan_Proc_BE	;igen, ugrunk
		btfsc	B_Kazan_KI		;a kazánt kikapcsolták?
		bra	PLC_Kazan_Proc_KI	;igen, ugrunk
		return
;--------------
PLC_Kazan_Proc_BE_egyszer
		bcf	B_Kazan_BE		;töröljük a bitet

		bcf	B_If_Cirko		;lementjüka cirko értékét
		Next_Cirko			;(ha 1 akkor a végén visszakapcsoljuk)
		bsf	B_If_Cirko

		SET_KERINGETO
		RST_CIRKO

		return
;--------------
PLC_Kazan_Proc_BE
			;a radiátort és a padlót a kapcsolóknak megfelelõen állítjuk
		RST_RADIATOR
		Next_SWRadiator
		SET_RADIATOR

		RST_PADLO
		Next_SWPadlo
		SET_PADLO

			;ha mindkettõ 0, bekapcsoljuk mindkettõt (KELL)
		Next_SWPadlo
		return
		Next_SWRadiator
		return
		SET_PADLO
		SET_RADIATOR
		return
;--------------
PLC_Kazan_Proc_KI
			;kikapcsolták a kazánt, bittörlés, keringetõ=0
		bcf	B_Kazan_KI
		RST_KERINGETO
			;cirko az eredeti állapotba
		btfsc	B_If_Cirko
		SET_CIRKO
		return
;+=========================================================================+
;|                                                                         |
;|                                                                         |
;+=========================================================================+
PLC_Futes_Proc
			;csak akkor ha a kazán NEM megy
		Next_Kazan
		return

		btfsc	VillanySW010		;billentik a kapcsolót?
		bra	PLC_Futes_Proc_Kezi	;igen, ugrunk
		btfsc	VillanySW101
		bra	PLC_Futes_Proc_Kezi	;igen, ugrunk

		btfsc	IdozitoSW1		;idõzítõ bekapcsolt?
		bra	PLC_Futes_Proc_Idozito	;igen, ugrunk

		btfsc	IdozitoSW0		;idõzítõ, bekapcsolt?
		bra	PLC_Futes_Proc_ki	;igen, ugrunk
		
;---
		Skip_Cirko			;be van kapcsolva a cirko?
		bra	PLC_Futes_Proc_a	;nem, nem kell fûteni
		Next_SWPadlo
		return
		Next_SWRadiator
		return
		bra	PLC_Futes_Proc_a
			;(nincs padló & radiátor) | nincs cirko
;--------------
PLC_Futes_Proc_a
			;lekapcs mindent, timerek visszaállítása
		RST_RADIATOR
		RST_PADLO
		RST_CIRKO
		movlw	INIT_FUTES_TIMO_TIMER1
		movff	WREG, Futes_TIMO_Timer
		movlw	INIT_FUTES_TIMO_TIMER2
		movff	WREG, Futes_TIMO_Timer+1
		movlw	0
		movff	WREG, Futes_TIMO_Timer_Counter
		return
;--------------
PLC_Futes_Proc_Idozito	
		bcf	IdozitoSW1

		RST_RADIATOR
		Next_SWRadiator
		SET_RADIATOR

		RST_PADLO
		Next_SWPadlo
		SET_PADLO

		RST_CIRKO
		Next_SWRadiator
		SET_CIRKO
		Next_SWPadlo
		SET_CIRKO

		return
;--------------
PLC_Futes_Proc_ki
		bcf	IdozitoSW0

		RST_RADIATOR
		RST_PADLO
		RST_CIRKO

		movlw	INIT_FUTES_TIMO_TIMER1
		movff	WREG, Futes_TIMO_Timer
		movlw	INIT_FUTES_TIMO_TIMER2
		movff	WREG, Futes_TIMO_Timer+1
		movlw	0
		movff	WREG, Futes_TIMO_Timer_Counter
		return
;--------------
PLC_Futes_Proc_Kezi
			;billentették a kapcsolót
		bcf	VillanySW010
		bcf	VillanySW101

		btfsc	OUT_Radiator
		bra	PLC_Futes_Proc_Kezi_Rad_vagy_padlo
		btfsc	OUT_Padlo
		bra	PLC_Futes_Proc_Kezi_Rad_vagy_padlo
		bra	PLC_Futes_Proc_Kezi_IncTimer
		

;-------
PLC_Futes_Proc_Kezi_Rad_vagy_padlo		;radiator vagy padlo be volt kapcsolva
		movlw	B'00000100'
		andwf	In8Reg, w		;ha az OUT_Radiator és
		movff	WREG, l			;az IN_SWRadiator nem egyezik meg
		movlw	B'00000100'		;akkor nem húzzuk fel a
		andwf	Out8Reg, w		;Futes_TIMO_Timer_Counter-t
		xorwf	l, w
		bz	PLC_Futes_Proc_Kezi_Egyezik
		bra	PLC_Futes_Proc_Kezi_Folytat
;---
PLC_Futes_Proc_Kezi_Egyezik
		movlw	B'00001000'
		andwf	In8Reg, w		;ha az OUT_Padlo és
		movff	WREG, l			;az IN_SWPadlo nem egyezik meg
		movlw	B'00001000'		;akkor nem húzzuk fel a
		andwf	Out8Reg, w		;Futes_TIMO_Timer_Counter-t
		xorwf	l, w
		bz	PLC_Futes_Proc_Kezi_IncTimer
		bra	PLC_Futes_Proc_Kezi_Folytat
;---
PLC_Futes_Proc_Kezi_IncTimer
		movlw	1
		addwf	Futes_TIMO_Timer_Counter, f
		movlw	256-MAX_FUTES_TIMO_TIMER_COUNTER
		addwf	Futes_TIMO_Timer_Counter, w
		sc
		bra	PLC_Futes_Proc_Kezi_Folytat

		movlw	MAX_FUTES_TIMO_TIMER_COUNTER
		movff	WREG, Futes_TIMO_Timer_Counter
		bra	PLC_Futes_Proc_Kezi_Folytat
;-------
PLC_Futes_Proc_Kezi_Folytat
		RST_RADIATOR
		Next_SWRadiator
		SET_RADIATOR

		RST_PADLO
		Next_SWPadlo
		SET_PADLO

		RST_CIRKO
		Next_SWRadiator
		SET_CIRKO
		Next_SWPadlo
		SET_CIRKO
		
		return
;+=========================================================================+
;|                                                                         |
;|                                                                         |
;+=========================================================================+
Futes_TIMO_Proc
		Next_Kazan
		return

		movlw	0
		xorwf	Futes_TIMO_Timer_Counter,w
		snz
		return

		TMR_DEC	Futes_TIMO_Timer
		tstfsz	Futes_TIMO_Timer
		return
		movlw	INIT_FUTES_TIMO_TIMER1
		movff	WREG, Futes_TIMO_Timer
		TMR_DEC	Futes_TIMO_Timer+1
		tstfsz	Futes_TIMO_Timer+1
		return
		movlw	INIT_FUTES_TIMO_TIMER2
		movff	WREG, Futes_TIMO_Timer+1
		TMR_DEC	Futes_TIMO_Timer_Counter
		tstfsz	Futes_TIMO_Timer_Counter
		return		
		
		RST_RADIATOR
		RST_PADLO
		RST_CIRKO

		return
;+=========================================================================+
;|                                                                         |
;|                                                                         |
;+=========================================================================+
CommFigyel_Proc	tstfsz	Comm_Timer,1
		decf	Comm_Timer,f,1

		tstfsz	Comm_Timer,1
		return

		movlw	COMM_TMO		;Felhúzzuk a COMM TimeOutját
		movwf	Comm_Timer,1

;		clrf	Out8Reg

		return
