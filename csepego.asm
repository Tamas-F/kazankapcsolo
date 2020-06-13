;********************************************************************
;*			Init					    *
;********************************************************************
Init_Csepego
		movlw	100
		movff	WREG, Csepegogomb0_Timer

		clrf	WREG
		movff	WREG,Csepegogomb0_Timer_b
		movff	WREG,Csepegogomb0_Phase

		movff	WREG,CsepegoLED0_Phase
		movff	WREG,CsepegoLED0_vill
		movff	WREG,CsepegoLED0_korok
		movff	WREG,CsepegoLED0_Timer

		movff	WREG,Csepego1_Phase	;Phase = 0
		movff	WREG,Csepego1_korok	;H�tralev� k�r�k t�rl�se
		movff	WREG,Csepego1_Timer+0
		movff	WREG,Csepego1_Timer+1	;Timer t�rl�se

		return


;********************************************************************
;			Csepeg� gomb				    *
;********************************************************************
Csepegogomb0_Proc
		movff	Csepegogomb0_Phase,WREG
		xorlw	0
		bz	Csepegogomb0_Proc0_

		movff	Csepegogomb0_Phase,WREG
		xorlw	1
		bz	Csepegogomb0_Proc1_

		movlw	0
		movff	WREG,Csepegogomb0_Phase

		return
;---
Csepegogomb0_Proc0_	goto	Csepegogomb0_Proc0
Csepegogomb0_Proc1_	goto	Csepegogomb0_Proc1
;---


;--------------	Gombot nem nyomj�k
Csepegogomb0_Proc0
		movlw	Csepegogomb0_PRELL		;PRELL Time
		Skip_Csepegogomb0			;Nyomj�k a gomtot?
		movff	WREG, Csepegogomb0_Timer	;Nem nyomj�k, PRELL felh�z�sa
;---
		movff	Csepegogomb0_Timer,WREG
		tstfsz	WREG				;PRELL Timer lej�rt?
		return					;Nem
;---							;Igen
		movlw	1
		movff	WREG, Csepegogomb0_Phase	;K�vetkez� Phase
		movlw	Csepegogomb0_L
		movff	WREG, Csepegogomb0_Timer_b	;Long Timer felh�z�sa
		movlw	Csepegogomb0_PRELL
		movff	WREG, Csepegogomb0_Timer	;PRELL Time INIT
		bsf	B_Csepegogomb0_Press		;Jelezz�k, hogy a gomb nyomva van
		bsf	B_Csepegogomb0_01		;0->0 jelz�se
		return
;--------------	Gombot nyomj�k
Csepegogomb0_Proc1
		movlw	Csepegogomb0_PRELL		;PRELL Time
		Next_Csepegogomb0			;Elengedt�k a gombot
		movff	WREG, Csepegogomb0_Timer	;Nem (m�g nyomj�k)
;---
		movff	Csepegogomb0_Timer,WREG
		tstfsz	WREG
		bra	Csepegogomb0_Proc1_b
;---	M�r nem nyomj�k a gombot
		movlw	0
		movff	WREG, Csepegogomb0_Phase	;Vissza 0 Phase-be
		bsf	B_Csepegogomb0_10		;1->0 jelz�se
		bcf	B_Csepegogomb0_Press		;Press bit t�rl�s
		bcf	B_Csepegogomb0_L		;Long bit t�rl�s
		return
;---	M�g nyomj�k a gombot
Csepegogomb0_Proc1_b
		movff	Csepegogomb0_Timer_b,WREG
		tstfsz	WREG				;Long Timer lej�rt?
		return					;Nem
		bsf	B_Csepegogomb0_L		;Igen, Long biten jelezz�k
		return

;********************************************************************
;			Locsol� LED				    *
;********************************************************************
CsepegoLED0_Proc
		movlw	4
		btfsc	B_Csepegogomb0_L
		movff	WREG,CsepegoLED0_Phase		;Long Time

		movff	CsepegoLED0_korok,WREG
		movff	Csepego1_korok,i
		xorwf	i,w
		bnz	CsepegoLED0_Proc_b		;Ha t�bbet kel villogni megy�nk a Proc0_b-be

		movff	CsepegoLED0_Phase,WREG
		xorlw	0
		bz	CsepegoLED0_Proc0_

		movff	CsepegoLED0_Phase,WREG
		xorlw	1
		bz	CsepegoLED0_Proc1_

		movff	CsepegoLED0_Phase,WREG
		xorlw	2
		bz	CsepegoLED0_Proc2_

		movff	CsepegoLED0_Phase,WREG
		xorlw	3
		bz	CsepegoLED0_Proc3_

		movff	CsepegoLED0_Phase,WREG
		xorlw	4
		bz	CsepegoLED0_Proc4_

		movlw	0
		movff	WREG,CsepegoLED0_Phase

		return
;---
CsepegoLED0_Proc0_	goto	CsepegoLED0_Proc0
CsepegoLED0_Proc1_	goto	CsepegoLED0_Proc1
CsepegoLED0_Proc2_	goto	CsepegoLED0_Proc2
CsepegoLED0_Proc3_	goto	CsepegoLED0_Proc3
CsepegoLED0_Proc4_	goto	CsepegoLED0_Proc4
;---


;---	Megv�ltozott a k�r�k sz�ma
CsepegoLED0_Proc_b
		movlw	0
		movff	WREG,CsepegoLED0_Phase
		RST_OUT_CsepegoLED0
		movff	Csepego1_korok,WREG
		movff	WREG,CsepegoLED0_korok
		movff	WREG,CsepegoLED0_vill		;Villog�sok sz�ma felh�z�sa
		movff	WREG,CsepegoLED0_Timer
		return


;--------------	V�runk
CsepegoLED0_Proc0
		movff	Csepego1_korok,WREG	
		tstfsz	WREG				;K�r�k sz�ma 0?
		bra	CsepegoLED0_Proc0_b
		return					 ;Igen
CsepegoLED0_Proc0_b					 ;Nem
		movlw	3;1
		movff	WREG,CsepegoLED0_Phase		 ;Phase = 3 (Hosszabbb v�rakoz�sa)

		movff	Csepego1_korok,WREG
		movff	WREG,CsepegoLED0_korok
		movff	WREG,CsepegoLED0_vill		;Villog�sok sz�ma felh�z�sa

		movlw	CsepegoLED0_L
		movff	WREG,CsepegoLED0_Timer		;Long Timer felh�z�sa
;		SET_OUT_CsepegoLED0			;LED felkapcsol�sa
		return
;-------------- Vil�g�tunk
CsepegoLED0_Proc1
		TMR_DEC_FSR	CsepegoLED0_Timer
		movff	CsepegoLED0_Timer,WREG
		tstfsz	WREG				;Letelt a vil�g�t�si Timer?
		return					 ;Nem
							 ;Igen
		RST_OUT_CsepegoLED0			;LED lekapcsol�sa
		TMR_DEC_FSR	CsepegoLED0_vill	;Villog�sok cs�kkent�se
		movff	CsepegoLED0_vill,WREG
		tstfsz	WREG				;Van m�g villog�sunk?
		bra	CsepegoLED0_Proc1_b		 ;Van

		movlw	3
		movff	WREG,CsepegoLED0_Phase		;Phase = 3

		movlw	CsepegoLED0_L
		movff	WREG,CsepegoLED0_Timer		;Long Timer felh�z�sa
		return
CsepegoLED0_Proc1_b
		movlw	2
		movff	WREG,CsepegoLED0_Phase		;Phase = 2

		movlw	CsepegoLED0_S
		movff	WREG,CsepegoLED0_Timer		;Short Timer felh�z�sa
		return
;--------------	R�vid v�rakoz�si id�
CsepegoLED0_Proc2
		TMR_DEC_FSR	CsepegoLED0_Timer
		movff	CsepegoLED0_Timer,WREG
		tstfsz	WREG				;Letelt a Short Timer?
		return					 ;Nem
			 				 ;Igen
		SET_OUT_CsepegoLED0			;LED felkapcsol�sa
		movlw	1
		movff	WREG,CsepegoLED0_Phase		;Phase = 0

		movlw	CsepegoLED0_li
		movff	WREG,CsepegoLED0_Timer		;Vil�g�t�si Timer felh�z�sa
		return
;--------------	Hossz� v�rakoz�s
CsepegoLED0_Proc3
		TMR_DEC_FSR	CsepegoLED0_Timer	;Long Timer cs�kkent�se
		movff	CsepegoLED0_Timer,WREG
		tstfsz	WREG				;Long Timer lej�rt?
		return					 ;Nem

		SET_OUT_CsepegoLED0			;LED felkapcsol�sa
		movlw	1
		movff	WREG,CsepegoLED0_Phase
		movff	CsepegoLED0_korok,WREG
		movff	WREG,CsepegoLED0_vill		;Villog�sok sz�ma felh�z�sa
		movlw	CsepegoLED0_li
		movff	WREG,CsepegoLED0_Timer		;Vil�g�t�si Timer felh�z�sa
		return
;--------------	Long Time van
CsepegoLED0_Proc4
		SET_OUT_CsepegoLED0			;LED felkapcsol�sa (Long Time miatt)
		btfsc	B_Csepegogomb0_Press		;Elengedt�k a gombot?
		return					 ;Nem
;--- Igen: Initek
		RST_OUT_CsepegoLED0			;LED lekapcsol�sa
		clrf	WREG	
		movff	WREG,CsepegoLED0_Phase
		movff	WREG,CsepegoLED0_vill
		movff	WREG,CsepegoLED0_korok
		movff	WREG,CsepegoLED0_Timer

		return


;********************************************************************
;			Csepeg� LED rossz			    *
;********************************************************************

;CsepegoLED0_Proc0
;		movff	CsepegoLED0_korok,WREG
;		movff	Csepego1_korok,i
;		xorwf	i,w
;		bnz	CsepegoLED0_Proc0_b		;Ha t�bbet kel villogni megy�nk a Proc0_b-be
;
;		TMR_DEC_FSR	CsepegoLED0_Timer1
;		movff	CsepegoLED0_Timer1,WREG
;		tstfsz	WREG				;Lej�rt a villog�si Timer
;		return					 ;Nem
;		RST_OUT_CsepegoLED0			 ;Igen, lekapcsoljuk a LED-et
;
;		TMR_DEC_FSR	CsepegoLED0_Timer2
;		movff	CsepegoLED0_Timer2,WREG		;Lej�rt a v�rakoz�si id�
;		tstfsz	WREG				 ;Nem
;		return					 ;Igen
;
;		TMR_DEC_FSR	CsepegoLED0_vill
;		movff	CsepegoLED0_vill,WREG
;		tstfsz	WREG
;;		bra	CsepegoLED0_Proc0_c
;
;CsepegoLED0_Proc0_b
;		movlw	1
;		movff	WREG,CsepegoLED0_Phase		
;		movlw	CsepegoLED0_L
;		movff	WREG,CsepegoLED0_Timer_L
;		RST_OUT_CsepegoLED0
;		return
;
;CsepegoLED0_Proc0_c
;		movlw	CsepegoLED0_li
;		movff	WREG,CsepegoLED0_Timer1		;Vil�g�t�si Timer felh�z�sa		
;		movlw	CsepegoLED0_S
;		movff	WREG,CsepegoLED0_Timer2		;Short Timer felh�z�sa
;		SET_OUT_CsepegoLED0
;		return
;;--------------	Hosszabb v�rakoz�s
;CsepegoLED0_Proc1
;		movff	CsepegoLED0_Timer_L,WREG
;		tstfsz	WREG				;Long Timer lej�rt?
;		return					 ;Nem
;		movlw	0				 ;Igen
;		movff	WREG,CsepegoLED0_Phase		;Phase = 0
;
;		movlw	CsepegoLED0_li
;		movff	WREG,CsepegoLED0_Timer1		;Vil�g�t�si Timer felh�z�sa
;
;		movff	Csepego1_korok,WREG
;		movff	WREG,CsepegoLED0_korok
;		incf	WREG
;		movff	WREG,CsepegoLED0_vill		;Villog�sok sz�ma felh�z�sa
;		tstfsz	WREG				;Kell majd villogni?
;		SET_OUT_CsepegoLED0			 ;Igen
;		return
;;--------------	Long Time van
;CsepegoLED0_Proc2
;		SET_OUT_CsepegoLED0			;LED felkapcsol�sa (Long Time miatt)
;		btfsc	B_Csepegogomb0_Press		;Elengedt�k a gombot?
;		return					 ;Nem
;;--- Igen: Initek
;		RST_OUT_CsepegoLED0			;LED lekapcsol�sa
;		clrf	WREG	
;		movff	WREG,CsepegoLED0_Phase
;		movff	WREG,CsepegoLED0_vill
;		movff	WREG,CsepegoLED0_korok
;		movff	WREG,CsepegoLED0_Timer1
;		movff	WREG,CsepegoLED0_Timer2
;		movff	WREG,CsepegoLED0_Timer_L
;
;		return

;********************************************************************
;			Csepeg� rendszer 2			    *
;********************************************************************
Csepego1_Proc
		btfsc	B_Csepegogomb0_L
		bsf	B_Csepego1_L
		btfsc	B_Csepego1_L
		call	Csepego1_Proc_L		;LongPress-re megh�vjuk a Proc_L (long)
		btfsc	B_Csepegogomb0_10
		call	Csepego1_Proc_K		;impulzusra megh�vjuk a Proc_K (k�r)
		call	Csepego1_Proc_ell

		movff	Csepego1_Phase,WREG
		xorlw	0
		bz	Csepego1_Proc0_

		movff	Csepego1_Phase,WREG
		xorlw	1
		bz	Csepego1_Proc1_

		movff	Csepego1_Phase,WREG
		xorlw	2
		bz	Csepego1_Proc2_

		movlw	0
		movff	WREG,Csepego1_Phase

		return
;---
Csepego1_Proc0_ goto	Csepego1_Proc0
Csepego1_Proc1_ goto	Csepego1_Proc1
Csepego1_Proc2_ goto	Csepego1_Proc2
;---


;-------------- Impulzust kaptunk
Csepego1_Proc_K
		lfsr	FSR2,Csepego1_korok
		incf	INDF2
		incf	INDF2			;M�g k�t k�r (1 �ra) v�grehajt�sa majd
		bcf	B_Csepegogomb0_10	;1->0 t�rl�se
		return
;-------------- Long Time
Csepego1_Proc_L
		btfss	B_Csepegogomb0_10	;Hossz� id� ut�n lekapcsolt�k
		return					;Nem
;--- Igen: INIT-el�sek
		bcf	B_Csepegogomb0_10	;1->0 t�rl�se
		bcf	B_Csepego1_L
Csepego1_Proc_INIT
		RST_OUT_Csepego			;Csepego le�ll�t�sa
		movlw	0
		movff	WREG,Csepego1_Phase	;Phase = 0
		movff	WREG,Csepego1_korok	;H�tralev� k�r�k t�rl�se
		movff	WREG,Csepego1_Timer+0
		movff	WREG,Csepego1_Timer+1	;Timer t�rl�se

		return
;--------------	Ellen�rz�sek
Csepego1_Proc_ell
		movff	Csepego1_korok,WREG
		xorlw	0
		sz				;Van m�g k�r?
		bra	Csepego1_Proc_ell2	 ;Van
						 ;Nincs
		bra	Csepego1_Proc_INIT
Csepego1_Proc_ell2
		movff	Csepego1_korok,WREG
		andlw	0xE0;B'11100000' = 0xE0
		snz				;F�ls� 4 biten van valami
		return				 ;Nincs
		movlw	31			 ;Van
		movff	WREG,Csepego1_korok	;K�r�k sz�ma 31

		return
;-------------- Nem megy a csepeg�
Csepego1_Proc0
		movff	Csepego1_korok,WREG
		xorlw	0			;Van m�g k�r�nk
		snz
		return				 ;Nincs
						 ;Van
		movlw	1
		movff	WREG,Csepego1_Phase	;Phase = 1

		SET_OUT_Csepego			;Csepego elind�t�sa
		movlw	Csepego1_TF
		movff	WREG,Csepego1_Timer		;Fut�si id� felt�lt�se
		movlw	0
		movff	WREG,Csepego1_Timer+1

		return
;-------------- Megy a csepeg�
Csepego1_Proc1
		movff	Csepego1_Timer,WREG
		tstfsz	WREG			;Fut�si id� lej�rt
		return				 ;Nem
						 ;Igen
		RST_OUT_Csepego			;Csepeg� le�ll�t�sa
		lfsr	FSR2,Csepego1_korok
		tstfsz	INDF2
		decf	INDF2, f		;K�r�k sz�ma cs�kkent�se, ha nem nulla

		movlw	low(Csepego1_TV)
		movff	WREG, Csepego1_Timer+0	;V�rakoz�si id� bet�lt�se
		movlw	high(Csepego1_TV)
		movff	WREG, Csepego1_Timer+1	;V�rakoz�si id� bet�lt�se

		movlw	2
		movff	WREG,Csepego1_Phase	;Phase = 3

		movff	Csepego1_korok,WREG
		tstfsz	WREG			;Van m�g k�r�nk
		return				 ;Van
						 ;Nincs
		movlw	0
		movff	WREG,Csepego1_Phase	;Phase = 0
		movff	WREG, Csepego1_Timer+0
		movff	WREG, Csepego1_Timer+1	;V�rakoz�si id� t�rl�se

		return
;--------------	V�rakozunk
Csepego1_Proc2
		lfsr	FSR2,Csepego1_Timer
		movf	POSTINC2, w
		iorwf	POSTDEC2, w
		sz				;Timer lej�rt?
		return				 ;Nem
						 ;Igen
		movlw	0
		movff	WREG,Csepego1_Phase


;---------------------------- TIMER ---------------------------------
Csepego1_Proc_Timer
		lfsr	FSR2,Csepego1_Timer
		movff	POSTINC2,WREG
		iorwf	POSTDEC2,w
		snz				;Timer = 0?
		return				 ;Igen
						 ;Nem
		movlw	0xFF
		addwf	POSTINC2,f
		addwfc	POSTDEC2, f		;Cs�kkentj�k eggyel az �rt�k�t
		return
