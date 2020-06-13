;+=========================================================================+
;|                                                                         |
;|                                                                         |
;+=========================================================================+
Init_Szivattyu
		movlw	0
		movff	WREG,Sziv_Timer
		movlw	0
		movff	WREG,Sziv_Status
		movlw	0
		movff	WREG,Sziv_Phase
		return
;+=========================================================================+
;|                                                                         |
;|                                                                         |
;+=========================================================================+
Szivattyu_Proc
		movff	Sziv_Phase,WREG
		xorlw	0
		bz	Szivattyu_Proc0_

		movff	Sziv_Phase,WREG
		xorlw	1
		bz	Szivattyu_Proc1_

		movff	Sziv_Phase,WREG
		xorlw	2
		bz	Szivattyu_Proc2_

		movff	Sziv_Phase,WREG
		xorlw	3
		bz	Szivattyu_Proc3_

		movlw	0
		movff	WREG,Sziv_Phase

		return

Szivattyu_Proc0_	goto	Szivattyu_Proc0	;Tétlen
Szivattyu_Proc1_	goto	Szivattyu_Proc1	;Kérte, de még várunk a bekapccsal
Szivattyu_Proc2_	goto	Szivattyu_Proc2	;Kéri a bekapcsolást, meg is kapta
Szivattyu_Proc3_	goto	Szivattyu_Proc3	;Timer-rel leállt

		return
;--------------
Szivattyu_Proc0
		Skip_Sziv			;Kérnek szivattyút?
		return				;nem
		;SET_SZIV_EN			;igen, várunk majd picit és bekapcsoljuk
		movlw	INIT_SZIV_WAIT_TIMER	;felhúzzuk a timert a várakozásra
		movff	WREG,Sziv_Timer
		movlw	1			;másik módba megyünk
		movff	WREG,Sziv_Phase
		return
;--------------
Szivattyu_Proc1
		Skip_Sziv			;még mindig kérik?
		bra	Szivattyu_Proc1_next0	;nem, vissza 0-ba
		movff	Sziv_Timer,WREG		;igen
		tstfsz	WREG			;timer lejárt?
		return				;nem, visszatértünk

		SET_SZIV_EN			;engedjük a szivattyút
		movlw	2
		movff	WREG,Sziv_Phase		;bekapcs módba megyünk
		movlw	INIT_SZIV_TIMER
		movff	WREG,Sziv_Timer		;felhúzzuk a timert (ha ez lejár kikapcs)
		return

Szivattyu_Proc1_next0
		RST_SZIV_EN
		movlw	0
		movff	WREG,Sziv_Phase
		return
;--------------
Szivattyu_Proc2
		Skip_Sziv			;még mindig kérik?
		bra	Szivattyu_Proc2_next0	;nem, kilépünk
		movff	Sziv_Timer,WREG		;igen
		tstfsz	WREG			;timer lejárt?
		return				;nem, visszatértünk
		RST_SZIV_EN			;igen, letiltjuk a szivattyút
		movlw	3			;3-as módba megyünk (timerrel letiltva)
		movff	WREG,Sziv_Phase
		return
;---
Szivattyu_Proc2_next0
		RST_SZIV_EN			;kikapcs
		movlw	0			;alapállapot
		movff	WREG,Sziv_Phase
		return
;--------------
Szivattyu_Proc3
		Next_Sziv			;még mindig kérik?
		bra	Szivattyu_Proc3_a	;igen, nincs semmi

		RST_SZIV_EN			;nem, lekapcs (nem muszáj, de hátha)
		movlw	0			;alapállapot
		movff	WREG,Sziv_Phase
		return
;---
Szivattyu_Proc3_a
		return
;--------------
		return