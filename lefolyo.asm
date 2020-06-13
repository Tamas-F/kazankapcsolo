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
LefolyoSW_Proc	;1ms-onk�nt  (nem kell plusz timer cs�kkent�s)
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
LefolyoSW_Proc0	;kapcsol� 0-ban
		bcf	LefolyoSW_State
		btfss	IN_SWLefolyo		;kapcsol� 1-ben?
		return				;nem, maradunk
		movlw	INIT_LEFOLYOSW_PRELL_TIMER	;igen
		movff	WREG,LefolyoSW_Timer	;felh�zzuk a prell timert
		movlw	1			;k�vetkez� phase
		movff	WREG,LefolyoSW_Phase
		return
;-----------------------
LefolyoSW_Proc1	;prellmentes�t�s (kapcsol� 1-be ker�lt)
		btfss	IN_SWLefolyo		;kapcsol� m�g mindig 1-ben?
		bra	LefolyoSW_Proc1_Next0	;nem (prelleg�s), vissza

		movff	LefolyoSW_Timer,WREG
		tstfsz	WREG			;timer lej�rt?
		return				;nem, m�g v�runk

		bsf	LefolyoSW01		;igen, be�ll�tjuk a ->
		bsf	LefolyoSW_State		;biteket
		movlw	2			;elmegy�nk 2-be (stabil 1)
		movff	WREG,LefolyoSW_Phase
		return
;---
LefolyoSW_Proc1_Next0
		movlw	0			;vissza 0-ba
		movff	WREG,LefolyoSW_Phase
		return
;-----------------------
LefolyoSW_Proc2 ;kapcsol� 1-ben van stabilan
		bsf	LefolyoSW_State
		btfsc	IN_SWLefolyo		;kapcsol� 0-ban?
		return				;nem, maradunk
		movlw	INIT_LEFOLYOSW_PRELL_TIMER	;igen
		movff	WREG,LefolyoSW_Timer	;felh�zzuk a prell timert
		movlw	3			;k�vetkez� phase
		movff	WREG,LefolyoSW_Phase
		return
;-----------------------
LefolyoSW_Proc3 ;prellmentes�t�s (kapcsol� 0-ba ker�lt)
		btfsc	IN_SWLefolyo		;kapcsol� m�g mindig 0-ban?
		bra	LefolyoSW_Proc3_Next2	;nem (prelleg�s), vissza

		movff	LefolyoSW_Timer,WREG
		tstfsz	WREG			;timer lej�rt?
		return				;nem, m�g v�runk

		bsf	LefolyoSW10		;igen, be�ll�tjuk a ->
		bcf	LefolyoSW_State		;biteket
		movlw	0			;elmegy�nk 0-ba (stabil 0)
		movff	WREG,LefolyoSW_Phase
		return
;---
LefolyoSW_Proc3_Next2
		movlw	2			;vissza 2-be
		movff	WREG,LefolyoSW_Phase
		return
;+=========================================================================+
;| Lefolyo_Proc: 100 ms-enk�nt                                             |
;|		 timerek: nincs                                            |
;|		                                                           |
;+=========================================================================+
Lefolyo_Proc
		btfsc	LefolyoSW01		;kapcsol�t felkapcsolt�k?
		bra	Lefolyo_Proc_BE		;igen, ugrunk
		btfsc	LefolyoSW10		;kapcsol�t lekapcsolt�k?
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
		bcf	LefolyoSW10		;biteket t�r�lj�k
		bcf	LefolyoSW01
		movlw	1			;1-es phase (ON)
		movff	WREG,Lefolyo_Phase

		SET_OUT_Lefolyo			;kimenetet enged�lyezz�k
		bcf	Lefolyo_Timer_Kesz	;timert enged�lyezz�k
		movlw	0			;timereket felh�zzuk
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
		bcf	LefolyoSW10		;biteket t�r�lj�k
		bcf	LefolyoSW01
		movlw	0			;0-s phase (Semmi)
		movff	WREG,Lefolyo_Phase

		CLR_OUT_Lefolyo			;kimenetet t�r�lj�k
		bsf	Lefolyo_Timer_Kesz	;timert letiltjuk
		return
;---------------------------------------------------------------------------
Lefolyo_Proc0	;nem csin�lunk semmit
		return
;-----------------------
Lefolyo_Proc1
		btfss	Lefolyo_Timer_Kesz	;timerek lej�rtak?
		bra	Lefolyo_Proc_Timer	;nem, sz�molunk vissza

		CLR_OUT_Lefolyo			;igen, kimenetet t�r�lj�k
		bcf	Lefolyo_Timer_Kesz	;timert enged�lyezz�k
		movlw	0			;timereket felh�zzuk
		movff	WREG,Lefolyo_Timer_sec
		movlw	INIT_LEFOLYO_TIMER_OFF_0
		movff	WREG,Lefolyo_Timer
		movlw	INIT_LEFOLYO_TIMER_OFF_1
		movff	WREG,Lefolyo_Timer+1
		movlw	INIT_LEFOLYO_TIMER_OFF_2
		movff	WREG,Lefolyo_Timer+2

		movlw	2			;2-es f�zis (OFF)
		movff	WREG,Lefolyo_Phase
		bra	Lefolyo_Proc_Timer
		return
;-----------------------
Lefolyo_Proc2
		btfss	Lefolyo_Timer_Kesz	;timerek lej�rtak?
		bra	Lefolyo_Proc_Timer	;nem, sz�molunk vissza

		SET_OUT_Lefolyo			;igen, kimenetet enged�lyezz�k
		bcf	Lefolyo_Timer_Kesz	;timert enged�lyezz�k
		movlw	0			;timereket felh�zzuk
		movff	WREG,Lefolyo_Timer_sec
		movlw	INIT_LEFOLYO_TIMER_ON_0
		movff	WREG,Lefolyo_Timer
		movlw	INIT_LEFOLYO_TIMER_ON_1
		movff	WREG,Lefolyo_Timer+1
		movlw	INIT_LEFOLYO_TIMER_ON_2
		movff	WREG,Lefolyo_Timer+2

		movlw	1			;2-es f�zis (ON)
		movff	WREG,Lefolyo_Phase
		bra	Lefolyo_Proc_Timer
		return
;---------------------------------------------------------------------------
Lefolyo_Proc_Timer
		TMR_DEC_FSR	Lefolyo_Timer_sec	;megv�rjuk az 1 sec-et
		movff	Lefolyo_Timer_sec,WREG
		tstfsz	WREG
		return
		movlw	10			;1 sec lement
		movff	WREG,Lefolyo_Timer_sec	;felh�zzuk �jra

		lfsr	FSR1,Lefolyo_Timer	;sec sz�ml�l�t cs�kkentj�k
		call	BCD_Dec_INDF1_60
		snc
		return

		lfsr	FSR1,Lefolyo_Timer+1	;sec sz�ml�l� �tfordult
		call	BCD_Dec_INDF1_60	;min sz�ml�l�t cs�kkentj�k
		snc
		return

		movff	Lefolyo_Timer+2,WREG	;min sz�ml�l� �tfordult
		decf	WREG,w			;hour sz�ml�l�t cs�kkentj�k
		movff	WREG,Lefolyo_Timer+2
		snc
		return

		movlw	0			;lej�rtak a timerek
		movff	WREG,Lefolyo_Timer	;t�r�lj�k �ket
		movff	WREG,Lefolyo_Timer+1
		movff	WREG,Lefolyo_Timer+2
		bsf	Lefolyo_Timer_Kesz	;jelezz�k hogy k�sz van
		return













