;+------------------------------------------------------------------+
;|     INIT_SIO	                                                    |
;+------------------------------------------------------------------+
;|     rontott regiszterek : w,i,STATUS,SIO_Phase,ITCON,            |
;+------------------------------------------------------------------+
;|     funkcio: A SIO inicializalasa.                               |
;+------------------------------------------------------------------+
Init_SIO	
		call	Init_RC_Variable
		call	Init_SIO_Tx
		call	Init_SIO_Rc
		return
		
;+------------------------------------------------------------------+
;|     INIT_SIO_TX	                                                    |
;+------------------------------------------------------------------+
;|     rontott regiszterek : w,i,STATUS,SIO_Phase,ITCON,            |
;+------------------------------------------------------------------+
;|     funkcio: A SIO inicializalasa.                               |
;|              Visszatereskor a GIE visszaallitva az eredetire.    |
;+------------------------------------------------------------------+
Init_SIO_Tx	clrf	i,0
		btfsc	INTCON,GIEH,0	;High Priority IT engedelyezve?
		bsf	i,7,0		;igen,  ezert megjegyezzuk
		btfsc	INTCON,GIEH,0	;Low Priority IT engedelyezve?
		bsf	i,6,0		;igen,  ezert megjegyezzuk

		bcf	INTCON,GIEH,0	;High IT disabled.
		bcf	INTCON,GIEL,0	;Low IT disabled.
;--------------
		bcf	SIO_TX_TRIS,0

		bcf	SIO_TX1EN_TRIS,0
		bcf	SIO_TX2EN_TRIS,0
		bsf	SIO_TX1EN,0
		bcf	SIO_TX2EN,0
	
		movlw	INIT_SPBRG_REG
		movwf	SPBRG,0		;Baud rate reg.

		movlw	INIT_TXSTA_REG
		movwf	TXSTA		;Transmit controll reg.


		bcf	PIE1,TXIE,0	;Tx IT disabled.
		bcf	IPR1,TXIP


		clrf	SIO_Tx_pWR,0
		clrf	SIO_Tx_pRD,0

		clrf	SIO_Tx_Status,0
		bsf	TXBUF_EMPTY,0		
		bsf	TX_END_DISAB,0
;--------------
		btfsc	i,7,0		;High IT a rutin elott ??
		bsf	INTCON,GIEH,0	;engedelyezve volt, 
		btfsc	i,6,0		;Low IT a rutin elott ??
		bsf	INTCON,GIEL,0	;engedelyezve volt, 
		return

;+------------------------------------------------------------------+
;|     INIT_SIO_RC                                                  |
;+------------------------------------------------------------------+
;|     rontott regiszterek : w,                                     |
;+------------------------------------------------------------------+
;|     funkcio: A SIO inicializalasa.                               |
;|              Visszatereskor a GIE visszaallitva az eredetire.    |
;+------------------------------------------------------------------+
Init_SIO_Rc	clrf	i,0
		btfsc	INTCON,GIEH,0	;High Priority IT engedelyezve?
		bsf	i,7,0		;igen,  ezert megjegyezzuk
		btfsc	INTCON,GIEH,0	;Low Priority IT engedelyezve?
		bsf	i,6,0		;igen,  ezert megjegyezzuk

		bcf	INTCON,GIEH,0	;High IT disabled.
		bcf	INTCON,GIEL,0	;Low IT disabled.
;--------------

		bsf	SIO_RC_TRIS,0

		bcf	SIO_RC1EN_TRIS,0
		bcf	SIO_RC2EN_TRIS,0
		bsf	SIO_RC1EN,0
		bcf	SIO_RC2EN,0

		movlw	INIT_RCSTA_REG0
		movwf	RCSTA,0		;Receive controll reg.
		movlw	INIT_RCSTA_REG
		movwf	RCSTA,0		;Receive controll reg.

		bcf	PIE1,RCIE,0	;Rc IT disabled.
		bcf	IPR1,RCIP
		movf	RCREG,w,0		;eldobhato.

		
		bsf	PIE1,RCIE,0	;Rc IT Enabled
;--------------
		btfsc	i,7,0		;High IT a rutin elott ??
		bsf	INTCON,GIEH,0	;engedelyezve volt, 
		btfsc	i,6,0		;Low IT a rutin elott ??
		bsf	INTCON,GIEL,0	;engedelyezve volt, 
		return
;+------------------------------------------------------------------+
;|     Init_RC_Variable                                             |
;+------------------------------------------------------------------+
;|     rontott regiszterek : w,STATUS                               |
;+------------------------------------------------------------------+
;|     funkcio: Inicializ�lja az Rc k�rpuffert                      |
;+------------------------------------------------------------------+
Init_RC_Variable

		movlw	RC_MODE_ESC
		movwf	SIO_Rc_Mode		;Kezetben az ESC-et v�rjuk
		clrf	SIO_Rc_ModeSave
		clrf	SIO_Rc_Status,0
		clrf	SIO_Rc_CHKSUM
		clrf	SIO_Rc_Length
		clrf	SIO_Rc_SAddr,0
		clrf	SIO_Rc_pWRTmp,0
		clrf	SIO_Rc_pWR,0
		clrf	SIO_Rc_pRD,0

		movlw	TX_MODE_ESC
		movwf	SIO_Tx_Mode		;Kezetben az ESC-et v�rjuk
		clrf	SIO_Tx_ModeSave
		clrf	SIO_Tx_Status,0
		clrf	SIO_Tx_CHKSUM
		clrf	SIO_Tx_Length
		clrf	SIO_Tx_SAddr,0
		clrf	SIO_Tx_pWRTmp,0
		clrf	SIO_Tx_pWR,0
		clrf	SIO_Tx_pRD,0

		movlw	0
		call	EEPROM_Read
		movwf	SIO_TAddr

		bsf	RCBUF_EMPTY,0
		bsf	RC_ENABLE,0
		return

;+------------------------------------------------------------------+
;|     Start_SendTx                                                 |
;+------------------------------------------------------------------+
;|     rontott regiszterek : w,i,STATUS                             |
;+------------------------------------------------------------------+
;|     funkcio: Amit bele�rtunk a Tx_Buf-ba, azt most kiviszi IT-b�l|
;+------------------------------------------------------------------+
Start_SendTx	
		movff	SIO_Tx_pWRTmp,SIO_Tx_pWR;�ttessz�k a pWR pointert, hogy menjen az adat
		bsf	PIE1,TXIE		;Enged�lyezz�k az IT k�r�s�t
		return

;+------------------------------------------------------------------+
;|     SIO_IT_FUN                                                   |
;+------------------------------------------------------------------+
;|     rontott regiszterek :                                        |
;+------------------------------------------------------------------+
;|     funkcio: 
;+------------------------------------------------------------------+
SIO_IT
		btfsc	PIR1,RCIF		;j�tt a soros vonalon valami?
		goto	SIO_IT_RC		;Igen, elvessz�k, r�gton vissza is t�r�nk, 
						;nehogy kifussunk az IT idej�b�l
		btfsc	PIR1,TXIF		;Lehet pakolni a k�vetkez�t TX-be?
		goto	SIO_IT_TX		;igen

		return

;==============
SIO_IT_TX		
		bcf	PIR1,RCIF		;T�r�lj�k az IT Flag-et
		bsf	SIO_TX1EN		;Igen, Nem csin�lunk semmit

SIO_IT_TX_Table
		movlw	TX_MODE_ESC
		xorwf	SIO_Tx_Mode,w
		bz	TX_Mode_ESC		;0:escape szekvencia varasa

		movlw	TX_MODE_LENGTH
		xorwf	SIO_Tx_Mode,w
		bz	TX_RC_Mode_Length		;1:Adat hossz v�r�s

		movlw	TX_MODE_TADDR
		xorwf	SIO_Tx_Mode,w
		bz	TX_Mode_TAddr		;2:A cim akinek k�ldt�k

		movlw	TX_MODE_SADDR
		xorwf	SIO_Tx_Mode,w
		bz	TX_Mode_SAddr		;3:A cim aki k�ldte

		movlw	TX_MODE_ID
		xorwf	SIO_Tx_Mode,w
		bz	TX_Mode_ID		;4:A cim aki k�ldte

		movlw	TX_MODE_COMM
		xorwf	SIO_Tx_Mode,w
		bz	TX_Mode_Comm		;5:A parancs

		movlw	TX_MODE_DATA
		xorwf	SIO_Tx_Mode,w
		bz	TX_Mode_Data		;6:adat varas

		movlw	TX_MODE_DESC
		xorwf	SIO_Tx_Mode,w
		bz	TX_Mode_DEsc		;7:adad kozben escape jott

		movlw	TX_MODE_CHKSUM
		xorwf	SIO_Tx_Mode,w
		goto	TX_Mode_CHKSUM		;7:Ha a CHKSUM-ot kell vizsg�lni

		goto	start_reset
;--------------
TX_Mode_ESC	movlw	TX_ESC_BYTE		;0:escape szekvencia k�ld�nk
		movwf	SIO_Tx_CHKSUM		;A CHKSUM kezd��rt�ke
		movwf	TXREG

		movlw	TX_MODE_LENGTH		;�tt�r�nk a hossz k�ld�sre
		movwf	SIO_Tx_Mode
		return
;--------------
TX_RC_Mode_Length				;1:Adat hossz�t k�ldj�k
		call	Tx_Buf_Rd		;Olvassuk a hosszt
		addlw	2			;A CHKSUM �s az SADDR is benne lesz
		movwf	SIO_Tx_Length		;Elmentj�k
		addwf	SIO_Tx_CHKSUM,f		;A CHKSUM-ot roptiben sz�moljuk
		movwf	TXREG			;kik�ldj�k

		movlw	TX_MODE_TADDR
		movwf	SIO_Tx_Mode

		decf	SIO_Tx_Length,f		;A CHKSUM-ot nem kell sz�molnunk, az mind�g kimegy!
		decf	SIO_Tx_Length,f		;Egy adat kiment
		return
;--------------
TX_Mode_TAddr					;2:A cim akinek k�ld�nk
		call	Tx_Buf_Rd		;Olvassuk a Target c�met (val�j�ban adatk�nt)
		addwf	SIO_Tx_CHKSUM,f		;A CHKSUM-ot roptiben sz�moljuk

		movwf	TXREG			;kik�ldj�k

		decf	SIO_Tx_Length,f		;M�g egy adat kiment
		snz				;Itt a v�ge?
		goto	TX_Mode_Comm_1		;Igen

		movlw	TX_MODE_SADDR
		movwf	SIO_Tx_Mode

		return

;--------------
TX_Mode_SAddr					;3:A saj�t c�m�nket elk�ldj�k
		movf	SIO_TAddr,w		;A 
		addwf	SIO_Tx_CHKSUM,f		;A CHKSUM-ot roptiben sz�moljuk

		movwf	TXREG			;kik�ldj�k

		decf	SIO_Tx_Length,f		;M�g egy adat kiment
		snz				;Itt a v�ge?
		goto	TX_Mode_Comm_1		;Igen

		movlw	TX_MODE_ID		;�tt�r�nk a Parancs k�ld�sre
		movwf	SIO_Tx_Mode
		return
;--------------
TX_Mode_ID					;4:A cim akinek k�ld�nk
		call	Tx_Buf_Rd		;Olvassuk az ID-t (val�j�ban adatk�nt)
		addwf	SIO_Tx_CHKSUM,f		;A CHKSUM-ot roptiben sz�moljuk

		movwf	TXREG			;kik�ldj�k
;---------
		decf	SIO_Tx_Length,f		;M�g egy adat kiment
		snz				;Itt a v�ge?
		goto	TX_Mode_ID_1		;Igen

		xorlw	TX_ESC_BYTE		;ESC byte-ot kell kikuldeni
		snz
		goto	TX_Mode_ID_2		;Igen, teh�t legk�zelebb kik�lj�k m�g egyszer
						;Nem

		movlw	TX_MODE_COMM		;Ide kell visszat�rni
		movwf	SIO_Tx_Mode
		return
TX_Mode_ID_2					;Ki kell vinni m�gegyszer az ESC-et
		movlw	TX_MODE_COMM		;Ide kell visszat�rni
		movwf	SIO_Tx_ModeSave
		
		movlw	TX_MODE_DESC		;�tt�r�nk az ESC byte kik�ld�s�re
		movwf	SIO_Tx_Mode
		return

TX_Mode_ID_1
		movlw	TX_MODE_COMM		;�tt�r�nk majd a Parancs k�ld�sre
		movwf	SIO_Tx_ModeSave
		movlw	TX_MODE_DESC		;�tt�r�nk az ESC byte k�ld�sre
		movwf	SIO_Tx_Mode
		return

;---------
;		decf	SIO_Tx_Length,f		;M�g egy adat kiment
;		snz				;Itt a v�ge?
;		goto	TX_Mode_Comm_1		;Igen
;
;		movlw	TX_MODE_COMM		;�tt�r�nk a Parancs k�ld�sre
;		movwf	SIO_Tx_Mode
;
;		return
;--------------
TX_Mode_Comm					;4:A parancs
		call	Tx_Buf_Rd		;Olvassuk a parancsot (val�j�ban adatk�nt)
		addwf	SIO_Tx_CHKSUM,f		;A CHKSUM-ot roptiben sz�moljuk

		movwf	TXREG			;kik�ldj�k

		decf	SIO_Tx_Length,f		;M�g egy adat kiment
		snz				;Itt a v�ge?
		goto	TX_Mode_Comm_1		;Igen

		movlw	TX_MODE_DATA		;�tt�r�nk ADAT k�ld�sre
		movwf	SIO_Tx_Mode
		return

TX_Mode_Comm_1
		movlw	TX_MODE_CHKSUM		;�tt�r�nk a CHKSUM k�ld�sre
		movwf	SIO_Tx_Mode
		return
;--------------
TX_Mode_Data					;5:adat varas
		call	Tx_Buf_Rd		;Olvassuk az adatot
		addwf	SIO_Tx_CHKSUM,f		;A CHKSUM-ot roptiben sz�moljuk

		movwf	TXREG			;kik�ldj�k

		decf	SIO_Tx_Length,f		;M�g egy adat kiment
	
		xorlw	TX_ESC_BYTE		;ESC byte-ot kell kikuldeni
		snz
		goto	TX_Mode_Data_1		;Igen, teh�t legk�zelebb kik�lj�k m�g egyszer
						;Nem
		movlw	TX_MODE_CHKSUM		;Ha nincs t�bb adat, akkor CHKSUM-ba kell menni
		tstfsz	SIO_Tx_Length		;Az adatok v�g�n vagyunk?
		movlw	TX_MODE_DATA		;Nem, teh�t maradunk itt
		movwf	SIO_Tx_Mode
		return
TX_Mode_Data_1					;Ki kell vinni m�gegyszer az ESC-et
		movlw	TX_MODE_CHKSUM		;
		tstfsz	SIO_Tx_Length		;Az adatok v�g�n vagyunk?
		movlw	TX_MODE_DATA		;Nem, teh�t ide kell visszat�rni
		movwf	SIO_Tx_ModeSave
		
		movlw	TX_MODE_DESC		;�tt�r�nk az ESC byte mint adat kik�ld�s�re
		movwf	SIO_Tx_Mode
		return
;--------------
TX_Mode_DEsc					;6:adad kozben ESC-et kell k�ldeni
		movlw	TX_ESC_BYTE		;ESC byte-ot kell kikuldeni
		movwf	TXREG			;kik�ldj�k
		movf	SIO_Tx_ModeSave,w	;Visszat�r�nk ahov� kell
		movwf	SIO_Tx_Mode

		movlw	TX_MODE_ESC		;Ahov� menn�nk kell az az  ESC v�r�s?
		xorwf	SIO_Tx_Mode
		sz
		return				;Nem
						;Igen
		btfsc	TXBUF_EMPTY		;A buffer �res?
		bcf	PIE1,TXIE		;Igen, teh�t tiltjuk az IT-t

		return			

;--------------
TX_Mode_CHKSUM		;7:Ha a CHKSUM-ot kell vizsg�lni
		movf	SIO_Tx_CHKSUM,w
		xorlw	0xff			;Neg�lunk!!!
		movwf	TXREG			;kik�ldj�k

		xorlw	TX_ESC_BYTE		;ESC byte-ot kell kikuldeni
		snz
		goto	TX_Mode_CHKSUM_1	;Igen

		movlw	TX_MODE_ESC		;V�gezt�nk, teh�t visszat�r�nk ESC m�dba
		movwf	SIO_Tx_Mode

		btfsc	TXBUF_EMPTY		;A buffer �res?
		bcf	PIE1,TXIE		;Igen, teh�t tiltjuk az IT-t

		return			

TX_Mode_CHKSUM_1
		movlw	TX_MODE_DESC		;M�g egy ESC-et kell k�ldneni
		movwf	SIO_Tx_Mode
		movlw	TX_MODE_ESC		;Onnan ESC-be megy�nk.
		movwf	SIO_Tx_ModeSave

		return
		
;==============
SIO_IT_RC	
		bcf	PIR1,RCIF
		movf	RCREG,w			;Elvessz�k az adatot, nehogy t�lcsordul�s legyen

		btfss	RC_ENABLE		;Enged�lyezve van a v�tel
		return				;Nem, teh�t eldobunk mindent
		btfsc	RCBUF_FULL		;A v�teli buffer tele van?
		return				;Igen, teh�t eldobunk mindent, �gysem tudjuk hova rakni
		movwf	i			;Kell az adat, �s a bufferbe is elf�r, teh�t elmentj�k

SIO_IT_RC_Table
		btfsc	RCSTA,OERR		;byte feluliras volt?
		goto	rc_mode_error		;igen
;		btfsc	RCSTA,FERR		;Framing Error volt ?
;		goto	rc_mode_error		;igen

		movlw	RC_MODE_ESC
		xorwf	SIO_Rc_Mode,w
		bz	RC_Mode_ESC

		movlw	RC_MODE_LENGTH
		xorwf	SIO_Rc_Mode,w
		bz	RC_Mode_Length

		movlw	RC_MODE_TADDR
		xorwf	SIO_Rc_Mode,w
		bz	RC_Mode_TAddr		;2:A cim akinek k�ldt�k

		movlw	RC_MODE_ID
		xorwf	SIO_Rc_Mode,w
		bz	RC_Mode_ID		;3:A cim aki k�ldte

		movlw	RC_MODE_SADDR
		xorwf	SIO_Rc_Mode,w
		bz	RC_Mode_SAddr		;4:A cim aki k�ldte

		movlw	RC_MODE_COMM
		xorwf	SIO_Rc_Mode,w
		bz	RC_Mode_Comm		;5:A parancs

		movlw	RC_MODE_DATA
		xorwf	SIO_Rc_Mode,w
		bz	RC_Mode_Data		;6:adat varas

		movlw	RC_MODE_DESC
		xorwf	SIO_Rc_Mode,w
		snz
		goto	RC_Mode_DEsc		;7:adad kozben escape jott

		movlw	RC_MODE_CHKSUM
		xorwf	SIO_Rc_Mode,w
		goto	RC_Mode_CHKSUM		;8:Ha a CHKSUM-ot kell vizsg�lni


		goto	RC_Mode_SetESC

rc_mode_error	
		bcf	RCSTA,CREN		;
		bsf	RCSTA,CREN
		movf	RCREG,w			;Eldobjuk!
		return
;--------------
RC_Mode_SetESC
		movlw	RC_MODE_ESC		;Teh�t kezdj�k el�lr�l a figyel�st
		movwf	SIO_Rc_Mode
		return
;==============
RC_Mode_ESC					;0:escape szekvencia varasa
		movlw	RC_ESC_BYTE
		cpfseq	i			;Az escape szekvencia j�tt?
		return				;Nem
						;Igen (ez m�g a hosszt�l is f�gg!!!!
RC_Mode_ESC_1
		movlw	RC_MODE_LENGTH
		movwf	SIO_Rc_Mode
		return
;--------------
RC_Mode_Length					;1:Adat hossz v�r�s
		movlw	RC_ESC_BYTE
		cpfseq	i			;Az escape szekvencia j�tt?
		goto	RC_Mode_Length_1	;Nem, teh�t rakhatjuk a puferbe
		goto	RC_Mode_SetESC		;Igen, azt jelenti, hogy csak egy adatot fogtunk el

RC_Mode_Length_1				;Itt akkor vagyunk, ha a hosszat kapjuk
		movlw	SIO_RC_LEN_BUF
		addlw	-1	
		cpfslt	i			;A hossz naygobb mint a maxhely?
		goto	RC_Mode_SetESC		;i>w, azaz tuti nem f�r bele egyszerre
						;Belef�rhet
		movlw	3
		cpfsgt	i			;A hossz nagyobb mint n�gy?
		goto	RC_Mode_SetESC		;i<4, ez nem j� hossz

		movff	SIO_Rc_pWR,SIO_Rc_pWRTmp;Ide kell �rni a byte-okat, inicializ�ljuk a Tmp-t

		movlw	RC_ESC_BYTE
		movwf	SIO_Rc_CHKSUM		;A CHKSUM ind�t�sa az ESC byte-al

		movf	i,w
		movwf	SIO_Rc_Length		;A hossz elmentj�k
		addwf	SIO_Rc_CHKSUM,f		;CHKSUM-hoz hozz�adjuka a length-t
		addlw	-2			;Kett�vel kevesebbet kell elt�rolni
						;ESC �s a CHKSUM-ot nem tessz�k le!!!
		call	Rc_Buf_Wr		;Es belarakjuk a buferbe
		snz				;Siker�lt belerakni a bufferbe?
		goto	RC_Mode_SetESC		;Nem, 

		decf	SIO_Rc_Length,f		;Cs�kkentj�k a byte sz�ml�l�t

		movlw	RC_MODE_TADDR		;Legk�zelebb v�rjuk a target cimet
		movwf	SIO_Rc_Mode
		return		
;--------------
RC_Mode_TAddr					;2:A cim akinek k�ldt�k
		movf	SIO_TAddr,w
		cpfseq	i			;A c�m egyezik a milyenkkel
		goto	RC_Mode_SetESC		;Nem (Csak a sporol�s miatt goto)
						;A c�m megegyezik!!!
		movf	i,w
		addwf	SIO_Rc_CHKSUM,f		;CHKSUM-hoz hozz�adjuka az TAddr-t
						;A buf-ba nem kell belerakni
;		call	Rc_Buf_Wr		;Es belarakjuk a buferbe
;		sz				;Siker�lt belerakni a bufferbe?
;		goto	RC_Mode_SetESC		;Nem, 
		
		decf	SIO_Rc_Length,f		;Cs�kkentj�k a byte sz�ml�l�t

;		movlw	RC_MODE_COMM		;A k�vetkez� a parancs lesz
		movlw	RC_MODE_SADDR		;A k�vetkez� a forr�s c�me
		movwf	SIO_Rc_Mode
		return
;--------------			
RC_Mode_SAddr					;3:A cim aki k�ldte
		movf	i,w
		addwf	SIO_Rc_CHKSUM,f		;CHKSUM-hoz hozz�adjuka az TAddr-t
						
		call	Rc_Buf_Wr		;Es belarakjuk a buferbe
		snz				;Siker�lt belerakni a bufferbe?
		goto	RC_Mode_SetESC		;Nem, 
		
		decf	SIO_Rc_Length,f		;Cs�kkentj�k a byte sz�ml�l�t

		movlw	RC_MODE_ID		;A k�vetkez� a parancs lesz
		movwf	SIO_Rc_Mode
		return
;--------------			
RC_Mode_ID					;4:A �zenet azonos�t�
		movf	i,w
		movwf	j			;Elmentj�k, mert k�s�bb sz�ks�g lesz r�
		addwf	SIO_Rc_CHKSUM,f		;CHKSUM-hoz hozz�adjuk az ID-t
						
		call	Rc_Buf_Wr		;Es belarakjuk a buferbe
		snz				;Siker�lt belerakni a bufferbe?
		goto	RC_Mode_SetESC		;Nem, 
;---
		decf	SIO_Rc_Length,f		;Cs�kkentj�k a byte sz�ml�l�t
		movlw	RC_MODE_COMM		;Legk�zelebb ide kellmenni(vagy nem)
		movwf	SIO_Rc_ModeSave		;Ide kell menni legk�zelebb

		movlw	RC_ESC_BYTE		;
		cpfseq	j			;Az escape szekvencia j�tt?
		goto	RC_Mode_ID_1		;Nem, teh�t mehet�nk tov�bb
						;Igen, azt jelenti, hogy 0x55-�t fogtunk el
		movlw	RC_MODE_DESC		;Mehet�nk a DESC-be, a visszat�r�s m�r felt�ltve
		movwf	SIO_Rc_Mode
		return

;---		
;		decf	SIO_Rc_Length,f		;Cs�kkentj�k a byte sz�ml�l�t
RC_Mode_ID_1
		movlw	RC_MODE_COMM		;A k�vetkez� a parancs lesz
		movwf	SIO_Rc_Mode
		return


;--------------		
RC_Mode_Comm					;4:Parancs varas
		movf	i,w
		addwf	SIO_Rc_CHKSUM,f		;CHKSUM-hoz hozz�adjuka az Commandot
		call	Rc_Buf_Wr		;Es belarakjuk a buferbe
		snz				;Siker�lt belerakni a bufferbe?
		goto	RC_Mode_SetESC		;Nem, 

		decf	SIO_Rc_Length,f		;Cs�kkentj�k a byte sz�ml�l�t
		decf	SIO_Rc_Length,f		;M�gegyet cs�kkent�nk, hogy 
		snz				;megn�zz�k, hogy a k�v.byte a CHKSUM-e
		goto	RC_Mode_Comm_1		;A k�vetkez� CHKSUM-nak kell lennie a db.sz�m miatt
		movlw	RC_MODE_DATA		;A k�vetkez� a parancs lesz
		movwf	SIO_Rc_Mode
		return
RC_Mode_Comm_1		
		movlw	RC_MODE_CHKSUM		;A k�vetkez� a parancs lesz
		movwf	SIO_Rc_Mode
		return

;--------------
RC_Mode_Data					;5:adat varas
		movf	i,w
		movwf	j			;Elmentj�k, mert k�s�bb sz�ks�g lesz r�
		addwf	SIO_Rc_CHKSUM,f		;CHKSUM-hoz hozz�adjuka az Adatot
		call	Rc_Buf_Wr		;Es belarakjuk a buferbe
		snz				;Siker�lt belerakni a bufferbe?
		goto	RC_Mode_SetESC		;Nem, 

		movlw	RC_MODE_DATA		;Legk�zelebb ide kellmenni(vagy nem)
		decf	SIO_Rc_Length,f		;Cs�kkentj�k a byte sz�ml�l�t
		snz				;megn�zz�k, hogy a k�v.byte a CHKSUM-e
		movlw	RC_MODE_CHKSUM		;Igen, teh�t nem data
		movwf	SIO_Rc_ModeSave		;Ide kell menni legk�zelebb

		movlw	RC_ESC_BYTE		;
		cpfseq	j			;Az escape szekvencia j�tt?
		goto	RC_Mode_Data_1		;Nem, teh�t mehet�nk tov�bb
						;Igen, azt jelenti, hogy 0x55-�t fogtunk el
		movlw	RC_MODE_DESC		;Mehet�nk a DESC-be, a visszat�r�s m�r felt�ltve
		movwf	SIO_Rc_Mode
		return
RC_Mode_Data_1
		movf	SIO_Rc_ModeSave,w	;A k�vetkez�re megy�nk
		movwf	SIO_Rc_Mode
		return
;--------------	
RC_Mode_DEsc					;6:adad kozben escape jott
		movlw	RC_ESC_BYTE		;
		cpfseq	i			;Az escape szekvencia j�tt?
		goto	RC_Mode_ESC_1		;Nem, teh�t blokk eleje j�tt
						;Igen, azt jelenti, hogy 0x55-�t fogtunk el

		movf	SIO_Rc_ModeSave,w	;Visszat�r�nk ahov� kell
		movwf	SIO_Rc_Mode
		xorlw	RC_MODE_ESC		;A CHKSUM-b�l kellett idej�nni?
		sz			
		return				;Nem
						;Igen
		goto	RC_Mode_CHKSUM_1
;--------------
RC_Mode_CHKSUM					;7:CHKSUM vizsg�lat
		movf	i,w			;A bej�tt CHKSUM-ot hozz�adjuk a
		addwf	SIO_Rc_CHKSUM,f		;CHKSUM-hoz
		movlw	0xff			;Neg�lunk
		xorwf	SIO_Rc_CHKSUM,f		;A CHKSUM-ot ellen�rizz�k

		movlw	RC_ESC_BYTE		;
		cpfseq	i			;Az escape szekvencia j�tt?
		goto	RC_Mode_CHKSUM_1	;Nem, teh�t blokk eleje j�tt
						;Igen, azt jelenti, hogy 0x55-�t fogtunk el

		tstfsz	SIO_Rc_CHKSUM		;A CHKSUM j� volt?
		goto	RC_Mode_SetESC		;Nem

		movlw	RC_MODE_DESC		;Igen, teh�t DEsc-be megy�nk
		movwf	SIO_Rc_Mode		;Ide kell menni legk�zelebb

		movlw	RC_MODE_ESC		;Igen, teh�t DEsc-be megy�nk
		movwf	SIO_Rc_ModeSave		;Ide kell menni legk�zelebb

		return

RC_Mode_CHKSUM_1
		tstfsz	SIO_Rc_CHKSUM		;A CHKSUM j� volt?
		goto	RC_Mode_SetESC		;Nem
;---						;IGEN
		movff	SIO_Rc_pWRTmp,SIO_Rc_pWR;Id�ig van bel�rva az adat
		bcf	RCBUF_EMPTY		;Mostm�r tuti nem �res a buffer

		call	LED0_ON_Fun

		goto	RC_Mode_SetESC		;V�rjuk a k�vetkez� csomagot (ESC-et)

;+------------------------------------------------------------------+
;|     Rc_Buf_Wr                                                    |
;+------------------------------------------------------------------+
;|     rontott regiszterek : w,i,STATUS,            |
;+------------------------------------------------------------------+
;|     funkcio: A w tartalm�t berakja az Rc_Buf-ba.                 |
;|              A Cimet a SIO_Rc_pWRTmp adja relativan az Rc_Buf-hoz|
;+------------------------------------------------------------------+
Rc_Buf_Wr	;Az w tartalm�t rakja az Rc_Buf-ba
		setz				;Ha nincs el�g hely, a Z-n jelezz�k
		btfsc	RCBUF_FULL		;A bufferben m�g van hely?
		return				;Nincs, HIBAk�ddal kil�p�nk

		movwf	i			;Elmentj�k a kiviend� adatot

		lfsr	FSR0,Rc_Buf		;FSR0-ba a buffer kezd�c�m�t rakjuk
		movf	SIO_Rc_pWRTmp,w
		addwf	FSR0L,f
		movff	i,INDF0			;A pufferbe belerakjuk az els� byte-ot
;---
		incf	SIO_Rc_pWRTmp,f		;novelj�k az ir� pointert
		movlw	SIO_RC_LEN_BUF-1	
		andwf	SIO_Rc_pWRTmp,f		;ne csorduljon t�l

		movf	SIO_Rc_pRD,w
		xorwf	SIO_Rc_pWRTmp,w
		snz				;Tele lett az Rc_Buff?
		bsf	RCBUF_FULL		;Igen, teh�t jelezz�k

;---
		clrz	
		return
;+------------------------------------------------------------------+
;|     Rc_Buf_Wr                                                    |
;+------------------------------------------------------------------+
;|     rontott regiszterek : w,i,STATUS,                            |
;+------------------------------------------------------------------+
;|     funkcio: Az Rc_Buf[SIO_Rc_pRD]->i,w                          |
;|                                                                  |
;+------------------------------------------------------------------+
Rc_Buf_Rd	;
		setz				;Ha nincs adat, a Z-n jelezz�k
		btfsc	RCBUF_EMPTY		;A bufferben van adat?
		return				;Nincs, HIBAk�ddal kil�p�nk

		lfsr	FSR0,Rc_Buf		;FSR0-ba a buffer kezd�c�m�t rakjuk
		movf	SIO_Rc_pRD,w
		addwf	FSR0L,f
		movff	INDF0,i			;Az i-be belerakjuk az adatot
;---
		incf	SIO_Rc_pRD,f		;novelj�k az ir� pointert
		movlw	SIO_RC_LEN_BUF-1	
		andwf	SIO_Rc_pRD,f		;ne csorduljon t�l

		movf	SIO_Rc_pRD,w
		xorwf	SIO_Rc_pWR,w
		snz				;�res lett az Rc_Buff?
		bsf	RCBUF_EMPTY		;Igen, teh�t jelezz�k
		bcf	RCBUF_FULL		;Ha eddig tele volt, mostm�r biztos nincs
;---
		movf	i,w			;A w-be is �tadjuk
		clrz
		return
;--------------
Rc_Buf_GetLength
		movff	SIO_Rc_pRD,SIO_Rc_pRDTmp;Az aktu�lis olvas�pointert megjegyezz�k

		call	Rc_Buf_Rd		;Kivessz�k a hosszt
		addwf	SIO_Rc_pRDTmp,f		;a Tmp-vel elmegy�nk a k�vetkez� blokkhoz
		movlw	SIO_RC_LEN_BUF-1
		andwf	SIO_Rc_pRDTmp,f		;ne csorduljon t�l
		movf	i,w			;w-ben a hossz
		return
;--------------
Rc_Buf_NextBlock
		movff	SIO_Rc_pRDTmp,SIO_Rc_pRD;A pointert a k�vetkez� blokk-ra �ll�tjuk
						;Nehogy kev�s olvas�s legyen
		movf	SIO_Rc_pWR,w
		xorwf	SIO_Rc_pRD,w
		snz
		bsf	RCBUF_EMPTY
		return

;+------------------------------------------------------------------+
;|     Tx_Buf_Wr                                                    |
;+------------------------------------------------------------------+
;|     rontott regiszterek : w,i,STATUS                             |
;+------------------------------------------------------------------+
;|     funkcio: A SIO k�rpuffer�be be�rjuk az w-ben lev� adatot     |
;+------------------------------------------------------------------+
Tx_Buf_Wr	;Az w tartalm�t rakja Tx_Buff-ba
		setz				;Ha nincs el�g hely, a Z-n jelezz�k
		btfsc	TXBUF_FULL		;A bufferben m�g van hely?
		return				;Nincs, HIBAk�ddal kil�p�nk

		movwf	i			;Elmentj�k a kiviend� adatot

		lfsr	FSR0,Tx_Buf		;FSR0-ba a buffer kezd�c�m�t rakjuk
		movf	SIO_Tx_pWRTmp,w
		addwf	FSR0L,f
		movff	i,INDF0			;A pufferbe belerakjuk az els� byte-ot
;---
		movlw	SIO_TX_LEN_BUF-1	;novelj�k az ir� pointert
		incf	SIO_Tx_pWRTmp,f
		andwf	SIO_Tx_pWRTmp,f		;ne csorduljon t�l

		bcf	TXBUF_EMPTY		;Ha �res lett volna, most m�r nem az

		movf	SIO_Tx_pRD,w
		xorwf	SIO_Tx_pWRTmp,w
		snz				;Tele lett a Tx_Buff?
		bsf	TXBUF_FULL		;Igen, teh�t jelezz�k
;---
		clrz
		return
;+------------------------------------------------------------------+
;|     Tx_Buf_Wr                                                    |
;+------------------------------------------------------------------+
;|     rontott regiszterek : w,i,STATUS,                            |
;+------------------------------------------------------------------+
;|     funkcio: Az Tx_Buf[SIO_Tx_pRD]->i,w                          |
;|                                                                  |
;+------------------------------------------------------------------+
Tx_Buf_Rd	;
		setz				;Ha nincs adat, a Z-n jelezz�k
		btfsc	TXBUF_EMPTY		;A bufferben van adat?
		return				;Nincs, HIBAk�ddal kil�p�nk

		lfsr	FSR0,Tx_Buf		;FSR0-ba a buffer kezd�c�m�t rakjuk
		movf	SIO_Tx_pRD,w
		addwf	FSR0L,f
		movff	INDF0,i			;Az i-be belerakjuk az adatot
;---
		incf	SIO_Tx_pRD,f		;novelj�k az ir� pointert
		movlw	SIO_TX_LEN_BUF-1	
		andwf	SIO_Tx_pRD,f		;ne csorduljon t�l

		movf	SIO_Tx_pRD,w
		xorwf	SIO_Tx_pWR,w
		snz				;�res lett az Rc_Buff?
		bsf	TXBUF_EMPTY		;Igen, teh�t jelezz�k
		bcf	TXBUF_FULL		;Ha eddig tele volt, mostm�r biztos nincs
;---
		movf	i,w			;A w-be is �tadjuk
		clrz
		return

;+------------------------------------------------------------------+
;|     SIO_WaitTX_Proc                                              |
;+------------------------------------------------------------------+
;|     rontott regiszterek : w,i,STATUS,                            |
;+------------------------------------------------------------------+
;|     funkcio:                                                     |
;|                                                                  |
;+------------------------------------------------------------------+
SIO_WaitTX_Proc2
		movlw	2
		btfss	TX_WAIT_ENABLE
		movwf	SIO_Tx_Timer
		
		decf	SIO_Tx_Timer,f
		sz
		return

		call	Start_SendTx
		bcf	TX_WAIT_ENABLE
		return
;Azonnal k�ldj�k a v�laszt!!!
SIO_WaitTX_Proc
		btfss	TX_WAIT_ENABLE
		return

		call	Start_SendTx
		bcf	TX_WAIT_ENABLE
		return

;+------------------------------------------------------------------+
;|     Init_SIO_GETSPBRG                                             |
;+------------------------------------------------------------------+
;|     rontott regiszterek : w,i,STATUS,                            |
;+------------------------------------------------------------------+
;|     funkcio:                                                     |
;|                                                                  |
;+------------------------------------------------------------------+
Init_SIO_GETSPBRG
		movwf	j
		movlw	upper	(Init_SIO_GETSPBRG_TBL)
		movwf	PCLATU
		movlw	high	(Init_SIO_GETSPBRG_TBL)
		movwf	PCLATH
		movlw	low	(Init_SIO_GETSPBRG_TBL)
		movwf	i
		movf	j,w
		andlw	0x7
		movwf	j
		addwf	j,w	;2szeres
		addwf	j,w	;3szoros
		addwf	j,w	;4szeres
		addwf	i,f
		snc	
		incf	PCLATH
		snc
		incf	PCLATU

		addwf	PCL
Init_SIO_GETSPBRG_TBL
		retlw	D'129'
		retlw	D'86'
		retlw	D'64'
		retlw	D'42'
		retlw	D'36'
		retlw	D'32'
		retlw	D'21'
		retlw	D'10'
