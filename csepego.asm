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
		movff	WREG,Csepego1_korok	;Hátralevõ körök törlése
		movff	WREG,Csepego1_Timer+0
		movff	WREG,Csepego1_Timer+1	;Timer törlése

		return


;********************************************************************
;			Csepegõ gomb				    *
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


;--------------	Gombot nem nyomják
Csepegogomb0_Proc0
		movlw	Csepegogomb0_PRELL		;PRELL Time
		Skip_Csepegogomb0			;Nyomják a gomtot?
		movff	WREG, Csepegogomb0_Timer	;Nem nyomják, PRELL felhúzása
;---
		movff	Csepegogomb0_Timer,WREG
		tstfsz	WREG				;PRELL Timer lejárt?
		return					;Nem
;---							;Igen
		movlw	1
		movff	WREG, Csepegogomb0_Phase	;Következõ Phase
		movlw	Csepegogomb0_L
		movff	WREG, Csepegogomb0_Timer_b	;Long Timer felhúzása
		movlw	Csepegogomb0_PRELL
		movff	WREG, Csepegogomb0_Timer	;PRELL Time INIT
		bsf	B_Csepegogomb0_Press		;Jelezzük, hogy a gomb nyomva van
		bsf	B_Csepegogomb0_01		;0->0 jelzése
		return
;--------------	Gombot nyomják
Csepegogomb0_Proc1
		movlw	Csepegogomb0_PRELL		;PRELL Time
		Next_Csepegogomb0			;Elengedték a gombot
		movff	WREG, Csepegogomb0_Timer	;Nem (még nyomják)
;---
		movff	Csepegogomb0_Timer,WREG
		tstfsz	WREG
		bra	Csepegogomb0_Proc1_b
;---	Már nem nyomják a gombot
		movlw	0
		movff	WREG, Csepegogomb0_Phase	;Vissza 0 Phase-be
		bsf	B_Csepegogomb0_10		;1->0 jelzése
		bcf	B_Csepegogomb0_Press		;Press bit törlés
		bcf	B_Csepegogomb0_L		;Long bit törlés
		return
;---	Még nyomják a gombot
Csepegogomb0_Proc1_b
		movff	Csepegogomb0_Timer_b,WREG
		tstfsz	WREG				;Long Timer lejért?
		return					;Nem
		bsf	B_Csepegogomb0_L		;Igen, Long biten jelezzük
		return

;********************************************************************
;			Locsoló LED				    *
;********************************************************************
CsepegoLED0_Proc
		movlw	4
		btfsc	B_Csepegogomb0_L
		movff	WREG,CsepegoLED0_Phase		;Long Time

		movff	CsepegoLED0_korok,WREG
		movff	Csepego1_korok,i
		xorwf	i,w
		bnz	CsepegoLED0_Proc_b		;Ha többet kel villogni megyünk a Proc0_b-be

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


;---	Megváltozott a körök száma
CsepegoLED0_Proc_b
		movlw	0
		movff	WREG,CsepegoLED0_Phase
		RST_OUT_CsepegoLED0
		movff	Csepego1_korok,WREG
		movff	WREG,CsepegoLED0_korok
		movff	WREG,CsepegoLED0_vill		;Villogások száma felhúzása
		movff	WREG,CsepegoLED0_Timer
		return


;--------------	Várunk
CsepegoLED0_Proc0
		movff	Csepego1_korok,WREG	
		tstfsz	WREG				;Körök száma 0?
		bra	CsepegoLED0_Proc0_b
		return					 ;Igen
CsepegoLED0_Proc0_b					 ;Nem
		movlw	3;1
		movff	WREG,CsepegoLED0_Phase		 ;Phase = 3 (Hosszabbb várakozása)

		movff	Csepego1_korok,WREG
		movff	WREG,CsepegoLED0_korok
		movff	WREG,CsepegoLED0_vill		;Villogások száma felhúzása

		movlw	CsepegoLED0_L
		movff	WREG,CsepegoLED0_Timer		;Long Timer felhúzása
;		SET_OUT_CsepegoLED0			;LED felkapcsolása
		return
;-------------- Világítunk
CsepegoLED0_Proc1
		TMR_DEC_FSR	CsepegoLED0_Timer
		movff	CsepegoLED0_Timer,WREG
		tstfsz	WREG				;Letelt a világítási Timer?
		return					 ;Nem
							 ;Igen
		RST_OUT_CsepegoLED0			;LED lekapcsolása
		TMR_DEC_FSR	CsepegoLED0_vill	;Villogások csökkentése
		movff	CsepegoLED0_vill,WREG
		tstfsz	WREG				;Van még villogásunk?
		bra	CsepegoLED0_Proc1_b		 ;Van

		movlw	3
		movff	WREG,CsepegoLED0_Phase		;Phase = 3

		movlw	CsepegoLED0_L
		movff	WREG,CsepegoLED0_Timer		;Long Timer felhúzása
		return
CsepegoLED0_Proc1_b
		movlw	2
		movff	WREG,CsepegoLED0_Phase		;Phase = 2

		movlw	CsepegoLED0_S
		movff	WREG,CsepegoLED0_Timer		;Short Timer felhúzása
		return
;--------------	Rövid várakozási idõ
CsepegoLED0_Proc2
		TMR_DEC_FSR	CsepegoLED0_Timer
		movff	CsepegoLED0_Timer,WREG
		tstfsz	WREG				;Letelt a Short Timer?
		return					 ;Nem
			 				 ;Igen
		SET_OUT_CsepegoLED0			;LED felkapcsolása
		movlw	1
		movff	WREG,CsepegoLED0_Phase		;Phase = 0

		movlw	CsepegoLED0_li
		movff	WREG,CsepegoLED0_Timer		;Világítási Timer felhúzása
		return
;--------------	Hosszú várakozás
CsepegoLED0_Proc3
		TMR_DEC_FSR	CsepegoLED0_Timer	;Long Timer csökkentése
		movff	CsepegoLED0_Timer,WREG
		tstfsz	WREG				;Long Timer lejárt?
		return					 ;Nem

		SET_OUT_CsepegoLED0			;LED felkapcsolása
		movlw	1
		movff	WREG,CsepegoLED0_Phase
		movff	CsepegoLED0_korok,WREG
		movff	WREG,CsepegoLED0_vill		;Villogások száma felhúzása
		movlw	CsepegoLED0_li
		movff	WREG,CsepegoLED0_Timer		;Világítási Timer felhúzása
		return
;--------------	Long Time van
CsepegoLED0_Proc4
		SET_OUT_CsepegoLED0			;LED felkapcsolása (Long Time miatt)
		btfsc	B_Csepegogomb0_Press		;Elengedték a gombot?
		return					 ;Nem
;--- Igen: Initek
		RST_OUT_CsepegoLED0			;LED lekapcsolása
		clrf	WREG	
		movff	WREG,CsepegoLED0_Phase
		movff	WREG,CsepegoLED0_vill
		movff	WREG,CsepegoLED0_korok
		movff	WREG,CsepegoLED0_Timer

		return


;********************************************************************
;			Csepegõ LED rossz			    *
;********************************************************************

;CsepegoLED0_Proc0
;		movff	CsepegoLED0_korok,WREG
;		movff	Csepego1_korok,i
;		xorwf	i,w
;		bnz	CsepegoLED0_Proc0_b		;Ha többet kel villogni megyünk a Proc0_b-be
;
;		TMR_DEC_FSR	CsepegoLED0_Timer1
;		movff	CsepegoLED0_Timer1,WREG
;		tstfsz	WREG				;Lejárt a villogási Timer
;		return					 ;Nem
;		RST_OUT_CsepegoLED0			 ;Igen, lekapcsoljuk a LED-et
;
;		TMR_DEC_FSR	CsepegoLED0_Timer2
;		movff	CsepegoLED0_Timer2,WREG		;Lejárt a várakozási idõ
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
;		movff	WREG,CsepegoLED0_Timer1		;Világítási Timer felhúzása		
;		movlw	CsepegoLED0_S
;		movff	WREG,CsepegoLED0_Timer2		;Short Timer felhúzása
;		SET_OUT_CsepegoLED0
;		return
;;--------------	Hosszabb várakozás
;CsepegoLED0_Proc1
;		movff	CsepegoLED0_Timer_L,WREG
;		tstfsz	WREG				;Long Timer lejárt?
;		return					 ;Nem
;		movlw	0				 ;Igen
;		movff	WREG,CsepegoLED0_Phase		;Phase = 0
;
;		movlw	CsepegoLED0_li
;		movff	WREG,CsepegoLED0_Timer1		;Világítási Timer felhúzása
;
;		movff	Csepego1_korok,WREG
;		movff	WREG,CsepegoLED0_korok
;		incf	WREG
;		movff	WREG,CsepegoLED0_vill		;Villogások száma felhúzása
;		tstfsz	WREG				;Kell majd villogni?
;		SET_OUT_CsepegoLED0			 ;Igen
;		return
;;--------------	Long Time van
;CsepegoLED0_Proc2
;		SET_OUT_CsepegoLED0			;LED felkapcsolása (Long Time miatt)
;		btfsc	B_Csepegogomb0_Press		;Elengedték a gombot?
;		return					 ;Nem
;;--- Igen: Initek
;		RST_OUT_CsepegoLED0			;LED lekapcsolása
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
;			Csepegõ rendszer 2			    *
;********************************************************************
Csepego1_Proc
		btfsc	B_Csepegogomb0_L
		bsf	B_Csepego1_L
		btfsc	B_Csepego1_L
		call	Csepego1_Proc_L		;LongPress-re meghívjuk a Proc_L (long)
		btfsc	B_Csepegogomb0_10
		call	Csepego1_Proc_K		;impulzusra meghívjuk a Proc_K (kör)
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
		incf	INDF2			;Még két kör (1 óra) végrehajtása majd
		bcf	B_Csepegogomb0_10	;1->0 törlése
		return
;-------------- Long Time
Csepego1_Proc_L
		btfss	B_Csepegogomb0_10	;Hosszú idõ után lekapcsolták
		return					;Nem
;--- Igen: INIT-elések
		bcf	B_Csepegogomb0_10	;1->0 törlése
		bcf	B_Csepego1_L
Csepego1_Proc_INIT
		RST_OUT_Csepego			;Csepego leállítása
		movlw	0
		movff	WREG,Csepego1_Phase	;Phase = 0
		movff	WREG,Csepego1_korok	;Hátralevõ körök törlése
		movff	WREG,Csepego1_Timer+0
		movff	WREG,Csepego1_Timer+1	;Timer törlése

		return
;--------------	Ellenõrzések
Csepego1_Proc_ell
		movff	Csepego1_korok,WREG
		xorlw	0
		sz				;Van még kör?
		bra	Csepego1_Proc_ell2	 ;Van
						 ;Nincs
		bra	Csepego1_Proc_INIT
Csepego1_Proc_ell2
		movff	Csepego1_korok,WREG
		andlw	0xE0;B'11100000' = 0xE0
		snz				;Fölsõ 4 biten van valami
		return				 ;Nincs
		movlw	31			 ;Van
		movff	WREG,Csepego1_korok	;Körök száma 31

		return
;-------------- Nem megy a csepegõ
Csepego1_Proc0
		movff	Csepego1_korok,WREG
		xorlw	0			;Van még körünk
		snz
		return				 ;Nincs
						 ;Van
		movlw	1
		movff	WREG,Csepego1_Phase	;Phase = 1

		SET_OUT_Csepego			;Csepego elindítása
		movlw	Csepego1_TF
		movff	WREG,Csepego1_Timer		;Futási idõ feltöltése
		movlw	0
		movff	WREG,Csepego1_Timer+1

		return
;-------------- Megy a csepegõ
Csepego1_Proc1
		movff	Csepego1_Timer,WREG
		tstfsz	WREG			;Futási idõ lejárt
		return				 ;Nem
						 ;Igen
		RST_OUT_Csepego			;Csepegõ leállítása
		lfsr	FSR2,Csepego1_korok
		tstfsz	INDF2
		decf	INDF2, f		;Körök száma csökkentése, ha nem nulla

		movlw	low(Csepego1_TV)
		movff	WREG, Csepego1_Timer+0	;Várakozási idõ betöltése
		movlw	high(Csepego1_TV)
		movff	WREG, Csepego1_Timer+1	;Várakozási idõ betöltése

		movlw	2
		movff	WREG,Csepego1_Phase	;Phase = 3

		movff	Csepego1_korok,WREG
		tstfsz	WREG			;Van még körünk
		return				 ;Van
						 ;Nincs
		movlw	0
		movff	WREG,Csepego1_Phase	;Phase = 0
		movff	WREG, Csepego1_Timer+0
		movff	WREG, Csepego1_Timer+1	;Várakozási idõ törlése

		return
;--------------	Várakozunk
Csepego1_Proc2
		lfsr	FSR2,Csepego1_Timer
		movf	POSTINC2, w
		iorwf	POSTDEC2, w
		sz				;Timer lejárt?
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
		addwfc	POSTDEC2, f		;Csökkentjük eggyel az értékét
		return
