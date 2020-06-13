;********************************************************************
;*			Initek					    *
;********************************************************************
Init_Locsolo
		movlw	Locsologomb0_PRELL
		movff	WREG,Locsologomb0_Timer

		bcf	B_Locsologomb0_10	;1->0 t�rl�se
		bcf	B_Locsolo1_L
		bcf	B_Locsolo1_kor_1
		bcf	B_Locsolo1_kor_2
		bcf	B_Locsolo1_kor_3
		movlw	0
		movff	WREG,Locsologomb0_Phase
		movff	WREG,Locsologomb0_Timer_b

		movff	WREG,Locsolo1_Phase	;Phase = 0
		movff	WREG,Locsolo1_korok	;H�tralev� k�r�k t�rl�se
		movff	WREG,Locsolo1_Timer	;V�rakoz�si id� t�rl�se

		movff	WREG,LocsoloLED0_Phase
		movff	WREG,LocsoloLED0_vill
		movff	WREG,LocsoloLED0_korok
		movff	WREG,LocsoloLED0_Timer

		return

;********************************************************************
;			Locsolo gomb				    *
;********************************************************************
Locsologomb0_Proc
		movff	Locsologomb0_Phase,WREG
		xorlw	0
		bz	Locsologomb0_Proc0_

		movff	Locsologomb0_Phase,WREG
		xorlw	1
		bz	Locsologomb0_Proc1_

		movlw	0
		movff	WREG,Locsologomb0_Phase

		return
;---
Locsologomb0_Proc0_	goto	Locsologomb0_Proc0
Locsologomb0_Proc1_	goto	Locsologomb0_Proc1
;---


;--------------	Gombot nem nyomj�k
Locsologomb0_Proc0
		movlw	Locsologomb0_PRELL		;PRELL Time
		Skip_Locsologomb0			;Nyomj�k a gomtot?
		movff	WREG, Locsologomb0_Timer	;Nem nyomj�k, PRELL felh�z�sa
;---
		movff	Locsologomb0_Timer,WREG
		tstfsz	WREG				;PRELL Timer lej�rt?
		return					;Nem
;---							;Igen
		movlw	1
		movff	WREG, Locsologomb0_Phase	;K�vetkez� Phase

		movlw	Locsologomb0_L
		movff	WREG, Locsologomb0_Timer_b	;Long Timer felh�z�sa
 
		movlw	Locsologomb0_PRELL
		movff	WREG, Locsologomb0_Timer	;PRELL Time INIT

		bsf	B_Locsologomb0_Press		;Jelezz�k, hogy a gomb nyomva van
		bsf	B_Locsologomb0_01		;0->1 jelz�se
		return
;--------------	Gombot nyomj�k
Locsologomb0_Proc1
		movlw	Locsologomb0_PRELL		;PRELL Time
		Next_Locsologomb0			;Elengedt�k a gombot
		movff	WREG, Locsologomb0_Timer	;Nem (m�g nyomj�k), PRELL Time felh�z�sa
;---
		movff	Locsologomb0_Timer,WREG
		tstfsz	WREG
		bra	Locsologomb0_Proc1_b
;---	M�r nem nyomj�k a gombot
		movlw	0
		movff	WREG, Locsologomb0_Phase	;Vissza 0 Phase-be
		bsf	B_Locsologomb0_10		;1->0 jelz�se
		bcf	B_Locsologomb0_Press		;Press bit t�rl�s
		bcf	B_Locsologomb0_L		;Long bit t�rl�s
		return
;---	M�g nyomj�k a gombot
Locsologomb0_Proc1_b
		movff	Locsologomb0_Timer_b,WREG
		tstfsz	WREG				;Long Timer lej�rt?
		return					;Nem
		bsf	B_Locsologomb0_L		;Igen, Long biten jelezz�k
		return

;********************************************************************
;			Locsol� LED				    *
;********************************************************************
LocsoloLED0_Proc
		movlw	4
		btfsc	B_Locsologomb0_L
		movff	WREG,LocsoloLED0_Phase		;Long Time

		movff	LocsoloLED0_korok,WREG
		movff	Locsolo1_korok,i
		xorwf	i,w
		bnz	LocsoloLED0_Proc_b		;Ha t�bbet kel villogni megy�nk a Proc0_b-be

		movff	LocsoloLED0_Phase,WREG
		xorlw	0
		bz	LocsoloLED0_Proc0_

		movff	LocsoloLED0_Phase,WREG
		xorlw	1
		bz	LocsoloLED0_Proc1_

		movff	LocsoloLED0_Phase,WREG
		xorlw	2
		bz	LocsoloLED0_Proc2_

		movff	LocsoloLED0_Phase,WREG
		xorlw	3
		bz	LocsoloLED0_Proc3_

		movff	LocsoloLED0_Phase,WREG
		xorlw	4
		bz	LocsoloLED0_Proc4_

		movlw	0
		movff	WREG,LocsoloLED0_Phase

		return
;---
LocsoloLED0_Proc0_	goto	LocsoloLED0_Proc0
LocsoloLED0_Proc1_	goto	LocsoloLED0_Proc1
LocsoloLED0_Proc2_	goto	LocsoloLED0_Proc2
LocsoloLED0_Proc3_	goto	LocsoloLED0_Proc3
LocsoloLED0_Proc4_	goto	LocsoloLED0_Proc4
;---


;---	Megv�ltozott a k�r�k sz�ma
LocsoloLED0_Proc_b
		movlw	0
		movff	WREG,LocsoloLED0_Phase
		RST_OUT_LocsoloLED0
		movff	Locsolo1_korok,WREG
		movff	WREG,LocsoloLED0_korok
		movff	WREG,LocsoloLED0_vill		;Villog�sok sz�ma felh�z�sa
		return


;--------------	V�runk
LocsoloLED0_Proc0
		movff	Locsolo1_korok,WREG	
		tstfsz	WREG				;K�r�k sz�ma 0?
		bra	LocsoloLED0_Proc0_b
		return					 ;Igen
LocsoloLED0_Proc0_b					 ;Nem
		movlw	3;1
		movff	WREG,LocsoloLED0_Phase		 ;Phase = 3 (Hosszabbb v�rakoz�sa)

		movff	Locsolo1_korok,WREG
		movff	WREG,LocsoloLED0_korok
		movff	WREG,LocsoloLED0_vill		;Villog�sok sz�ma felh�z�sa

		movlw	LocsoloLED0_L
		movff	WREG,LocsoloLED0_Timer		;Long Timer felh�z�sa
;		SET_OUT_LocsoloLED0			;LED felkapcsol�sa
		return
;-------------- Vil�g�tunk
LocsoloLED0_Proc1
		TMR_DEC_FSR	LocsoloLED0_Timer
		movff	LocsoloLED0_Timer,WREG
		tstfsz	WREG				;Letelt a vil�g�t�si Timer?
		return					 ;Nem
							 ;Igen
		RST_OUT_LocsoloLED0			;LED lekapcsol�sa
		TMR_DEC_FSR	LocsoloLED0_vill	;Villog�sok cs�kkent�se
		movff	LocsoloLED0_vill,WREG
		tstfsz	WREG				;Van m�g villog�sunk?
		bra	LocsoloLED0_Proc1_b		 ;Van

		movlw	3
		movff	WREG,LocsoloLED0_Phase		;Phase = 3

		movlw	LocsoloLED0_L
		movff	WREG,LocsoloLED0_Timer		;Long Timer felh�z�sa
		return
LocsoloLED0_Proc1_b
		movlw	2
		movff	WREG,LocsoloLED0_Phase		;Phase = 2

		movlw	LocsoloLED0_S
		movff	WREG,LocsoloLED0_Timer		;Short Timer felh�z�sa
		return
;--------------	R�vid v�rakoz�si id�
LocsoloLED0_Proc2
		TMR_DEC_FSR	LocsoloLED0_Timer
		movff	LocsoloLED0_Timer,WREG
		tstfsz	WREG				;Letelt a Short Timer?
		return					 ;Nem
			 				 ;Igen
		SET_OUT_LocsoloLED0			;LED felkapcsol�sa
		movlw	1
		movff	WREG,LocsoloLED0_Phase		;Phase = 0

		movlw	LocsoloLED0_li
		movff	WREG,LocsoloLED0_Timer		;Vil�g�t�si Timer felh�z�sa
		return
;--------------	Hossz� v�rakoz�s
LocsoloLED0_Proc3
		TMR_DEC_FSR	LocsoloLED0_Timer	;Long Timer cs�kkent�se
		movff	LocsoloLED0_Timer,WREG
		tstfsz	WREG				;Long Timer lej�rt?
		return					 ;Nem

		SET_OUT_LocsoloLED0			;LED felkapcsol�sa
		movlw	1
		movff	WREG,LocsoloLED0_Phase
		movff	LocsoloLED0_korok,WREG
		movff	WREG,LocsoloLED0_vill		;Villog�sok sz�ma felh�z�sa
		movlw	LocsoloLED0_li
		movff	WREG,LocsoloLED0_Timer		;Vil�g�t�si Timer felh�z�sa
		return
;--------------	Long Time van
LocsoloLED0_Proc4
		SET_OUT_LocsoloLED0			;LED felkapcsol�sa (Long Time miatt)
		btfsc	B_Locsologomb0_Press		;Elengedt�k a gombot?
		return					 ;Nem
;--- Igen: Initek
		RST_OUT_LocsoloLED0			;LED lekapcsol�sa
		clrf	WREG	
		movff	WREG,LocsoloLED0_Phase
		movff	WREG,LocsoloLED0_vill
		movff	WREG,LocsoloLED0_korok
		movff	WREG,LocsoloLED0_Timer

		return

;********************************************************************
;			Locsolo rendszer 2			    *
;********************************************************************
Locsolo1_Proc
		btfsc	B_Locsologomb0_L
		bsf	B_Locsolo1_L
		btfsc	B_Locsolo1_L
		call	Locsolo1_Proc_L		;LongPress-re megh�vjuk a Proc_L (long)
		btfsc	B_Locsologomb0_10
		call	Locsolo1_Proc_K		;impulzusra megh�vjuk a Proc_K (k�r)
		call	Locsolo1_Proc_ell	;Ellen�rz� Phase

		movff	Locsolo1_Phase,WREG
		xorlw	0
		bz	Locsolo1_Proc0_		;Nem megy a locsolo

		movff	Locsolo1_Phase,WREG
		xorlw	1
		bz	Locsolo1_Proc1_		;1.Locsolo megy

		movff	Locsolo1_Phase,WREG
		xorlw	2
		bz	Locsolo1_Proc2_		;2.Locsolo megy

		movff	Locsolo1_Phase,WREG
		xorlw	3
		bz	Locsolo1_Proc3_		;3.Locsolo megy

		movff	Locsolo1_Phase,WREG
		xorlw	4
		bz	Locsolo1_Proc4_		;D�nt�s: Phase = 0v5

		movff	Locsolo1_Phase,WREG
		xorlw	5
		bz	Locsolo1_Proc5_		;Hossz� v�rakoz�s

		movff	Locsolo1_Phase,WREG
		xorlw	9
		bz	Locsolo1_Proc9_		;1. r�vid v�rakoz�s

		movff	Locsolo1_Phase,WREG
		xorlw	10
		bz	Locsolo1_Proc10_	;2. r�vid v�rakoz�s

		movff	Locsolo1_Phase,WREG
		xorlw	11
		bz	Locsolo1_Proc11_	;3. r�vid v�rakoz�s

		movlw	0
		movff	WREG,Locsolo1_Phase	

		return
;---
Locsolo1_Proc0_	goto	Locsolo1_Proc0
Locsolo1_Proc1_	goto	Locsolo1_Proc1
Locsolo1_Proc2_	goto	Locsolo1_Proc2
Locsolo1_Proc3_	goto	Locsolo1_Proc3
Locsolo1_Proc4_	goto	Locsolo1_Proc4
Locsolo1_Proc5_	goto	Locsolo1_Proc5
Locsolo1_Proc9_	goto	Locsolo1_Proc9
Locsolo1_Proc10_	goto	Locsolo1_Proc10
Locsolo1_Proc11_	goto	Locsolo1_Proc11
;---


;-------------- Impulzust kaptunk
Locsolo1_Proc_K
		lfsr	FSR2,Locsolo1_korok
		incf	INDF2			;M�g egy k�r v�grehajt�sa majd
		bsf	B_Locsolo1_kor_1
		bsf	B_Locsolo1_kor_2
		bsf	B_Locsolo1_kor_3
		bcf	B_Locsologomb0_10	;1->0 t�rl�se
		return
;--------------	Long Time
Locsolo1_Proc_L
		btfss	B_Locsologomb0_10	;Hossz� id� ut�n lekapcsolt�k
		return					;Nem
;--- Igen: INIT-el�sek
		bcf	B_Locsologomb0_10	;1->0 t�rl�se
		bcf	B_Locsolo1_L
Locsolo1_Proc_INIT
		bcf	B_Locsolo1_kor_1
		bcf	B_Locsolo1_kor_2
		bcf	B_Locsolo1_kor_3
		movlw	0
		movff	WREG,Locsolo1_Phase	;Phase = 0
		movff	WREG,Locsolo1_korok	;H�tralev� k�r�k t�rl�se
		movff	WREG,Locsolo1_Timer	;V�rakoz�si id� t�rl�se
		RST_OUT_Locsol1
		RST_OUT_Locsol2
		RST_OUT_Locsol3			;Kimenetek lekapcsol�sa
		return
;--------------	Ellen�rz�sek
Locsolo1_Proc_ell
		movff	Locsolo1_kor_Status,WREG
		tstfsz	WREG			;Kellene v�grehajtani k�rt?
		bra	Locsolo1_Proc_ell2	 ;Igen
		bra	Locsolo1_Proc_INIT	 ;Nem

Locsolo1_Proc_ell2
		movff	Locsolo1_korok,WREG
		tstfsz	WREG			;Van m�g k�r�nk
		bra	Locsolo1_Proc_ell3	 ;Van
						 ;Nincs, ugr�s INITekhez
		bra	Locsolo1_Proc_INIT
		return
Locsolo1_Proc_ell3
		movff	Locsolo1_korok,WREG
		andlw	0xF0;B'11110000' = 0xF0
		snz				;F�ls� 4 biten van valami
		return				 ;Nincs
		movlw	15			 ;Van
		movff	WREG,Locsolo1_korok	;K�r�k sz�ma 15

;-------------- Nem megy a locsolo
Locsolo1_Proc0
		movff	Locsolo1_korok,WREG
		movf	WREG,f
		snz				;Van m�g k�r
		return					;Nincs
							;Van
		movlw	1
		movff	WREG, Locsolo1_Phase		;K�vetkez� Phase

		movlw	Locsolo1_TF1
		btfsc	B_Locsolo1_kor_1		
		movff	WREG,Locsolo1_Timer	;Ha az 1. k�rt v�gre kell hajtani, akkor az 1.Fut�si(F) id�(T) berak�sa a Timer-be

		btfsc	B_Locsolo1_kor_1
		SET_OUT_Locsol1			;Ha az 1. k�rt v�gre kell hajtani, bekapcsoljuk az 1. locsol�t

		return
;******************************	LOCSOL�SOK ************************************
;-------------- 1. Locsol�
Locsolo1_Proc1
		clrf	WREG
		btfss	B_Locsolo1_kor_1
		movff	WREG,Locsolo1_Timer	;Ha nem kell v�grahajtani az 1. k�rt t�r�lj�k a Timer-t

		movff	Locsolo1_Timer,WREG
		tstfsz	WREG			;Fut�si id� lej�rt
		return					;Nem
							;Igen
		RST_OUT_Locsol1			;Locsolo kikapcsol�sa

		lfsr	FSR0,Locsolo1_Phase
		bsf	INDF0,3			;Phase = 9 (0001->1001)

		movlw	Locsolo1_TV1
		btfsc	B_Locsolo1_kor_1
		movff	WREG,Locsolo1_Timer	;V�rakoz�si Timer felh�z�sa, ha volt 1. k�r

		return
;-------------- 2. Locsol�
Locsolo1_Proc2
		clrf	WREG
		btfss	B_Locsolo1_kor_2
		movff	WREG,Locsolo1_Timer	;Ha nem kell v�grahajtani az 2. k�rt t�r�lj�k a Timer-t

		movff	Locsolo1_Timer,WREG
		tstfsz	WREG			;Fut�si id� lej�rt
		return					;Nem
							;Igen
		RST_OUT_Locsol2			;Locsolo kikapcsol�sa

		lfsr	FSR0,Locsolo1_Phase
		bsf	INDF0,3			;Phase = 10 (0010->1010)

		movlw	Locsolo1_TV1
		btfsc	B_Locsolo1_kor_2
		movff	WREG,Locsolo1_Timer	;V�rakoz�si Timer felh�z�sa, ha volt 2. k�r

		return
;--------------	3. Locsol�
Locsolo1_Proc3		
		clrf	WREG
		btfss	B_Locsolo1_kor_3
		movff	WREG,Locsolo1_Timer	;Ha nem kell v�grahajtani az 3. k�rt t�r�lj�k a Timer-t

		movff	Locsolo1_Timer,WREG
		tstfsz	WREG			;Fut�si id� lej�rt
		return					;Nem
							;Igen
		RST_OUT_Locsol3

		lfsr	FSR0,Locsolo1_Phase
		bsf	INDF0,3			;Phase = 11 (0011->1011)

		movlw	Locsolo1_TV1
		btfsc	B_Locsolo1_kor_3
		movff	WREG,Locsolo1_Timer	;V�rakoz�si Timer felh�z�sa, ha volt 3. k�r

		return
;******************************	V�RAKOZ�SOK ***********************************
;--------------	D�nt�s
Locsolo1_Proc4
		lfsr	FSR0,Locsolo1_korok
		decf	INDF0

		movff	Locsolo1_korok,WREG
		tstfsz	WREG			;Van m�g k�r?
		bra	Locsolo1_Proc4_b	 ;Van
;--- 						 ;Nincs, teh�t INIT-ek
		bcf	B_Locsolo1_kor_1
		bcf	B_Locsolo1_kor_2
		bcf	B_Locsolo1_kor_3
		movlw	0
		movff	WREG,Locsolo1_Phase	;Phase = 0
		movff	WREG,Locsolo1_korok	;H�tralev� k�r�k t�rl�se
		movff	WREG,Locsolo1_Timer	;V�rakoz�si id� t�rl�se

		return
;---
Locsolo1_Proc4_b
		movlw	5
		movff	WREG,Locsolo1_Phase	;Phase = 5

		movlw	Locsolo1_TV
		movff	WREG,Locsolo1_Timer	;Long Timer felh�z�sa

		return

;--------------	Hossz� v�rakoz�s
Locsolo1_Proc5
		movff	Locsolo1_Timer,WREG
		tstfsz	WREG
		return

		movlw	0
		movff	WREG,Locsolo1_Phase
		return
;--------------	1. v�rakoz�s
Locsolo1_Proc9
		movff	Locsolo1_Timer,WREG
		tstfsz	WREG			;V�rakoz�si id� lej�rt?
		return				 ;Nem
						 ;Igen
		movlw	Locsolo1_TF2
		btfsc	B_Locsolo1_kor_2
		movff	WREG, Locsolo1_Timer	;Ha az 2. k�rt v�gre kell hajtani, akkor az 1.Fut�si(F) id�(T) berak�sa a Timer-be

		lfsr	FSR0,Locsolo1_Phase
		bcf	INDF0,3
		incf	INDF0			;Phase = 2 (1001->0001->0010)

		btfsc	B_Locsolo1_kor_2
		SET_OUT_Locsol2			;Ha az 2. k�rt v�gre kell hajtani, bekapcsoljuk az 2. locsol�t

		return
;--------------	2. v�rakoz�s
Locsolo1_Proc10
		movff	Locsolo1_Timer,WREG
		tstfsz	WREG			;V�rakoz�si id� lej�rt?
		return				 ;Nem
						 ;Igen
		movlw	Locsolo1_TF3
		btfsc	B_Locsolo1_kor_3
		movff	WREG, Locsolo1_Timer	;Ha az 3. k�rt v�gre kell hajtani, akkor az 3.Fut�si(F) id�(T) berak�sa a Timer-be

		lfsr	FSR0,Locsolo1_Phase
		bcf	INDF0,3
		incf	INDF0			;Phase = 3 (1010->0010->0011)

		btfsc	B_Locsolo1_kor_3
		SET_OUT_Locsol3			;Ha az 3. k�rt v�gre kell hajtani, bekapcsoljuk az 3. locsol�t

		return
;--------------	3. v�rakoz�s
Locsolo1_Proc11
		movff	Locsolo1_Timer,WREG
		tstfsz	WREG			;V�rakoz�si id� lej�rt?
		return				 ;Nem
						 ;Igen
		lfsr	FSR0,Locsolo1_Phase
		bcf	INDF0,3
		incf	INDF0			;Phase = 4 (1011->0011->0100)

		return





