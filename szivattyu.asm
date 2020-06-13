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

Szivattyu_Proc0_	goto	Szivattyu_Proc0	;T�tlen
Szivattyu_Proc1_	goto	Szivattyu_Proc1	;K�rte, de m�g v�runk a bekapccsal
Szivattyu_Proc2_	goto	Szivattyu_Proc2	;K�ri a bekapcsol�st, meg is kapta
Szivattyu_Proc3_	goto	Szivattyu_Proc3	;Timer-rel le�llt

		return
;--------------
Szivattyu_Proc0
		Skip_Sziv			;K�rnek szivatty�t?
		return				;nem
		;SET_SZIV_EN			;igen, v�runk majd picit �s bekapcsoljuk
		movlw	INIT_SZIV_WAIT_TIMER	;felh�zzuk a timert a v�rakoz�sra
		movff	WREG,Sziv_Timer
		movlw	1			;m�sik m�dba megy�nk
		movff	WREG,Sziv_Phase
		return
;--------------
Szivattyu_Proc1
		Skip_Sziv			;m�g mindig k�rik?
		bra	Szivattyu_Proc1_next0	;nem, vissza 0-ba
		movff	Sziv_Timer,WREG		;igen
		tstfsz	WREG			;timer lej�rt?
		return				;nem, visszat�rt�nk

		SET_SZIV_EN			;engedj�k a szivatty�t
		movlw	2
		movff	WREG,Sziv_Phase		;bekapcs m�dba megy�nk
		movlw	INIT_SZIV_TIMER
		movff	WREG,Sziv_Timer		;felh�zzuk a timert (ha ez lej�r kikapcs)
		return

Szivattyu_Proc1_next0
		RST_SZIV_EN
		movlw	0
		movff	WREG,Sziv_Phase
		return
;--------------
Szivattyu_Proc2
		Skip_Sziv			;m�g mindig k�rik?
		bra	Szivattyu_Proc2_next0	;nem, kil�p�nk
		movff	Sziv_Timer,WREG		;igen
		tstfsz	WREG			;timer lej�rt?
		return				;nem, visszat�rt�nk
		RST_SZIV_EN			;igen, letiltjuk a szivatty�t
		movlw	3			;3-as m�dba megy�nk (timerrel letiltva)
		movff	WREG,Sziv_Phase
		return
;---
Szivattyu_Proc2_next0
		RST_SZIV_EN			;kikapcs
		movlw	0			;alap�llapot
		movff	WREG,Sziv_Phase
		return
;--------------
Szivattyu_Proc3
		Next_Sziv			;m�g mindig k�rik?
		bra	Szivattyu_Proc3_a	;igen, nincs semmi

		RST_SZIV_EN			;nem, lekapcs (nem musz�j, de h�tha)
		movlw	0			;alap�llapot
		movff	WREG,Sziv_Phase
		return
;---
Szivattyu_Proc3_a
		return
;--------------
		return