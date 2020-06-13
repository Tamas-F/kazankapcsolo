;+=========================================================================+
;|                                                                         |
;|                                                                         |
;+=========================================================================+
Init_Lefolyo
		movlw	0
		movff	WREG, LefolyoSW_Timer
		movff	WREG, LefolyoSW_Phase
		movff	WREG, Lefolyo_Timer
		movff	WREG, Lefolyo_Phase
		movff	WREG, Lefolyo_Status

		bsf	Lefolyo_Timer_Kesz
		movlw	INIT_LEFOLYO_TIMER_ON_0
		movff	WREG,Lefolyo_Timer
		movlw	INIT_LEFOLYO_TIMER_ON_1
		movff	WREG,Lefolyo_Timer+1
		movlw	INIT_LEFOLYO_TIMER_ON_2
		movff	WREG,Lefolyo_Timer+2
		return
;+=========================================================================+
;|                                                                         |
;|                                                                         |
;+=========================================================================+
LefolyoSW_Proc	;1ms-onként  (nem kell plusz timer csökkentés)
		TMR_DEC_FSR	LefolyoSW_Timer

		movff	LefolyoSW_Phase,WREG
		xorlw	0
		bz	LefolyoSW_Proc0
		movff	LefolyoSW_Phase,WREG
		xorlw	1
		bz	LefolyoSW_Proc1
		movff	LefolyoSW_Phase,WREG
		xorlw	2
		bz	LefolyoSW_Proc2
		movff	LefolyoSW_Phase,WREG
		xorlw	3
		bz	LefolyoSW_Proc3

		movlw	0
		movff	WREG,LefolyoSW_Phase
		return

;-----------------------
LefolyoSW_Proc0	;kapcsoló 0-ban
		bcf	LefolyoSW_State
		btfss	IN_SWLefolyo		;kapcsoló 1-ben?
		return				;nem, maradunk
		movlw	INIT_LEFOLYOSW_PRELL_TIMER	;igen
		movff	WREG,LefolyoSW_Timer	;felhúzzuk a prell timert
		movlw	1			;következõ phase
		movff	WREG,LefolyoSW_Phase
		return
;-----------------------
LefolyoSW_Proc1	;prellmentesítés (kapcsoló 1-be került)
		btfss	IN_SWLefolyo		;kapcsoló még mindig 1-ben?
		bra	LefolyoSW_Proc1_Next0	;nem (prellegés), vissza

		movff	LefolyoSW_Timer,WREG
		tstfsz	WREG			;timer lejárt?
		return				;nem, még várunk

		bsf	LefolyoSW01		;igen, beállítjuk a ->
		bsf	LefolyoSW_State		;biteket
		movlw	2			;elmegyünk 2-be (stabil 1)
		movff	WREG,LefolyoSW_Phase
		return
;---
LefolyoSW_Proc1_Next0
		movlw	0			;vissza 0-ba
		movff	WREG,LefolyoSW_Phase
		return
;-----------------------
LefolyoSW_Proc2 ;kapcsoló 1-ben van stabilan
		bsf	LefolyoSW_State
		btfsc	IN_SWLefolyo		;kapcsoló 0-ban?
		return				;nem, maradunk
		movlw	INIT_LEFOLYOSW_PRELL_TIMER	;igen
		movff	WREG,LefolyoSW_Timer	;felhúzzuk a prell timert
		movlw	3			;következõ phase
		movff	WREG,LefolyoSW_Phase
		return
;-----------------------
LefolyoSW_Proc3 ;prellmentesítés (kapcsoló 0-ba került)
		btfsc	IN_SWLefolyo		;kapcsoló még mindig 0-ban?
		bra	LefolyoSW_Proc3_Next2	;nem (prellegés), vissza

		movff	LefolyoSW_Timer,WREG
		tstfsz	WREG			;timer lejárt?
		return				;nem, még várunk

		bsf	LefolyoSW10		;igen, beállítjuk a ->
		bcf	LefolyoSW_State		;biteket
		movlw	0			;elmegyünk 0-ba (stabil 0)
		movff	WREG,LefolyoSW_Phase
		return
;---
LefolyoSW_Proc3_Next2
		movlw	2			;vissza 2-be
		movff	WREG,LefolyoSW_Phase
		return
;+=========================================================================+
;| Lefolyo_Proc: 100 ms-enként                                             |
;|		 timerek: nincs                                            |
;|		                                                           |
;+=========================================================================+
Lefolyo_Proc
		btfsc	LefolyoSW01		;kapcsolót felkapcsolták?
		bra	Lefolyo_Proc_BE		;igen, ugrunk
		btfsc	LefolyoSW10		;kapcsolót lekapcsolták?
		bra	Lefolyo_Proc_KI		;igen, ugrunk
		btfss	LefolyoSW_State
		CLR_OUT_Lefolyo

		movff	Lefolyo_Phase,WREG
		xorlw	0
		bz	Lefolyo_Proc0
		movff	Lefolyo_Phase,WREG
		xorlw	1
		bz	Lefolyo_Proc1
		movff	Lefolyo_Phase,WREG
		xorlw	2
		bz	Lefolyo_Proc2

		movlw	0
		movff	WREG,Lefolyo_Phase
		return
;-----
Lefolyo_Proc_BE
		bcf	LefolyoSW10		;biteket töröljük
		bcf	LefolyoSW01
		movlw	1			;1-es phase (ON)
		movff	WREG,Lefolyo_Phase

		SET_OUT_Lefolyo			;kimenetet engedélyezzük
		bcf	Lefolyo_Timer_Kesz	;timert engedélyezzük
		movlw	0			;timereket felhúzzuk
		movff	WREG,Lefolyo_Timer_sec
		movlw	INIT_LEFOLYO_TIMER_ON_0
		movff	WREG,Lefolyo_Timer
		movlw	INIT_LEFOLYO_TIMER_ON_1
		movff	WREG,Lefolyo_Timer+1
		movlw	INIT_LEFOLYO_TIMER_ON_2
		movff	WREG,Lefolyo_Timer+2
		return
;-----
Lefolyo_Proc_KI
		bcf	LefolyoSW10		;biteket töröljük
		bcf	LefolyoSW01
		movlw	0			;0-s phase (Semmi)
		movff	WREG,Lefolyo_Phase

		CLR_OUT_Lefolyo			;kimenetet töröljük
		bsf	Lefolyo_Timer_Kesz	;timert letiltjuk
		return
;---------------------------------------------------------------------------
Lefolyo_Proc0	;nem csinálunk semmit
		return
;-----------------------
Lefolyo_Proc1
		btfss	Lefolyo_Timer_Kesz	;timerek lejártak?
		bra	Lefolyo_Proc_Timer	;nem, számolunk vissza

		CLR_OUT_Lefolyo			;igen, kimenetet töröljük
		bcf	Lefolyo_Timer_Kesz	;timert engedélyezzük
		movlw	0			;timereket felhúzzuk
		movff	WREG,Lefolyo_Timer_sec
		movlw	INIT_LEFOLYO_TIMER_OFF_0
		movff	WREG,Lefolyo_Timer
		movlw	INIT_LEFOLYO_TIMER_OFF_1
		movff	WREG,Lefolyo_Timer+1
		movlw	INIT_LEFOLYO_TIMER_OFF_2
		movff	WREG,Lefolyo_Timer+2

		movlw	2			;2-es fázis (OFF)
		movff	WREG,Lefolyo_Phase
		bra	Lefolyo_Proc_Timer
		return
;-----------------------
Lefolyo_Proc2
		btfss	Lefolyo_Timer_Kesz	;timerek lejártak?
		bra	Lefolyo_Proc_Timer	;nem, számolunk vissza

		SET_OUT_Lefolyo			;igen, kimenetet engedélyezzük
		bcf	Lefolyo_Timer_Kesz	;timert engedélyezzük
		movlw	0			;timereket felhúzzuk
		movff	WREG,Lefolyo_Timer_sec
		movlw	INIT_LEFOLYO_TIMER_ON_0
		movff	WREG,Lefolyo_Timer
		movlw	INIT_LEFOLYO_TIMER_ON_1
		movff	WREG,Lefolyo_Timer+1
		movlw	INIT_LEFOLYO_TIMER_ON_2
		movff	WREG,Lefolyo_Timer+2

		movlw	1			;2-es fázis (ON)
		movff	WREG,Lefolyo_Phase
		bra	Lefolyo_Proc_Timer
		return
;---------------------------------------------------------------------------
Lefolyo_Proc_Timer
		TMR_DEC_FSR	Lefolyo_Timer_sec	;megvárjuk az 1 sec-et
		movff	Lefolyo_Timer_sec,WREG
		tstfsz	WREG
		return
		movlw	10			;1 sec lement
		movff	WREG,Lefolyo_Timer_sec	;felhúzzuk újra

		lfsr	FSR1,Lefolyo_Timer	;sec számlálót csökkentjük
		call	BCD_Dec_INDF1_60
		snc
		return

		lfsr	FSR1,Lefolyo_Timer+1	;sec számláló átfordult
		call	BCD_Dec_INDF1_60	;min számlálót csökkentjük
		snc
		return

		movff	Lefolyo_Timer+2,WREG	;min számláló átfordult
		decf	WREG,w			;hour számlálót csökkentjük
		movff	WREG,Lefolyo_Timer+2
		snc
		return

		movlw	0			;lejártak a timerek
		movff	WREG,Lefolyo_Timer	;töröljük õket
		movff	WREG,Lefolyo_Timer+1
		movff	WREG,Lefolyo_Timer+2
		bsf	Lefolyo_Timer_Kesz	;jelezzük hogy kész van
		return













