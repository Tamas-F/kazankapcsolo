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
;|     funkcio: Inicializálja az Rc körpuffert                      |
;+------------------------------------------------------------------+
Init_RC_Variable

		movlw	RC_MODE_ESC
		movwf	SIO_Rc_Mode		;Kezetben az ESC-et várjuk
		clrf	SIO_Rc_ModeSave
		clrf	SIO_Rc_Status,0
		clrf	SIO_Rc_CHKSUM
		clrf	SIO_Rc_Length
		clrf	SIO_Rc_SAddr,0
		clrf	SIO_Rc_pWRTmp,0
		clrf	SIO_Rc_pWR,0
		clrf	SIO_Rc_pRD,0

		movlw	TX_MODE_ESC
		movwf	SIO_Tx_Mode		;Kezetben az ESC-et várjuk
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
;|     funkcio: Amit beleírtunk a Tx_Buf-ba, azt most kiviszi IT-bõl|
;+------------------------------------------------------------------+
Start_SendTx	
		movff	SIO_Tx_pWRTmp,SIO_Tx_pWR;Áttesszük a pWR pointert, hogy menjen az adat
		bsf	PIE1,TXIE		;Engedélyezzük az IT kérését
		return

;+------------------------------------------------------------------+
;|     SIO_IT_FUN                                                   |
;+------------------------------------------------------------------+
;|     rontott regiszterek :                                        |
;+------------------------------------------------------------------+
;|     funkcio: 
;+------------------------------------------------------------------+
SIO_IT
		btfsc	PIR1,RCIF		;jött a soros vonalon valami?
		goto	SIO_IT_RC		;Igen, elvesszük, rögton vissza is térünk, 
						;nehogy kifussunk az IT idejébõl
		btfsc	PIR1,TXIF		;Lehet pakolni a következõt TX-be?
		goto	SIO_IT_TX		;igen

		return

;==============
SIO_IT_TX		
		bcf	PIR1,RCIF		;Töröljük az IT Flag-et
		bsf	SIO_TX1EN		;Igen, Nem csinálunk semmit

SIO_IT_TX_Table
		movlw	TX_MODE_ESC
		xorwf	SIO_Tx_Mode,w
		bz	TX_Mode_ESC		;0:escape szekvencia varasa

		movlw	TX_MODE_LENGTH
		xorwf	SIO_Tx_Mode,w
		bz	TX_RC_Mode_Length		;1:Adat hossz várás

		movlw	TX_MODE_TADDR
		xorwf	SIO_Tx_Mode,w
		bz	TX_Mode_TAddr		;2:A cim akinek küldték

		movlw	TX_MODE_SADDR
		xorwf	SIO_Tx_Mode,w
		bz	TX_Mode_SAddr		;3:A cim aki küldte

		movlw	TX_MODE_ID
		xorwf	SIO_Tx_Mode,w
		bz	TX_Mode_ID		;4:A cim aki küldte

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
		goto	TX_Mode_CHKSUM		;7:Ha a CHKSUM-ot kell vizsgálni

		goto	start_reset
;--------------
TX_Mode_ESC	movlw	TX_ESC_BYTE		;0:escape szekvencia küldünk
		movwf	SIO_Tx_CHKSUM		;A CHKSUM kezdõértéke
		movwf	TXREG

		movlw	TX_MODE_LENGTH		;Áttérünk a hossz küldésre
		movwf	SIO_Tx_Mode
		return
;--------------
TX_RC_Mode_Length				;1:Adat hosszát küldjük
		call	Tx_Buf_Rd		;Olvassuk a hosszt
		addlw	2			;A CHKSUM és az SADDR is benne lesz
		movwf	SIO_Tx_Length		;Elmentjük
		addwf	SIO_Tx_CHKSUM,f		;A CHKSUM-ot roptiben számoljuk
		movwf	TXREG			;kiküldjük

		movlw	TX_MODE_TADDR
		movwf	SIO_Tx_Mode

		decf	SIO_Tx_Length,f		;A CHKSUM-ot nem kell számolnunk, az mindíg kimegy!
		decf	SIO_Tx_Length,f		;Egy adat kiment
		return
;--------------
TX_Mode_TAddr					;2:A cim akinek küldünk
		call	Tx_Buf_Rd		;Olvassuk a Target címet (valójában adatként)
		addwf	SIO_Tx_CHKSUM,f		;A CHKSUM-ot roptiben számoljuk

		movwf	TXREG			;kiküldjük

		decf	SIO_Tx_Length,f		;Még egy adat kiment
		snz				;Itt a vége?
		goto	TX_Mode_Comm_1		;Igen

		movlw	TX_MODE_SADDR
		movwf	SIO_Tx_Mode

		return

;--------------
TX_Mode_SAddr					;3:A saját címünket elküldjük
		movf	SIO_TAddr,w		;A 
		addwf	SIO_Tx_CHKSUM,f		;A CHKSUM-ot roptiben számoljuk

		movwf	TXREG			;kiküldjük

		decf	SIO_Tx_Length,f		;Még egy adat kiment
		snz				;Itt a vége?
		goto	TX_Mode_Comm_1		;Igen

		movlw	TX_MODE_ID		;Áttérünk a Parancs küldésre
		movwf	SIO_Tx_Mode
		return
;--------------
TX_Mode_ID					;4:A cim akinek küldünk
		call	Tx_Buf_Rd		;Olvassuk az ID-t (valójában adatként)
		addwf	SIO_Tx_CHKSUM,f		;A CHKSUM-ot roptiben számoljuk

		movwf	TXREG			;kiküldjük
;---------
		decf	SIO_Tx_Length,f		;Még egy adat kiment
		snz				;Itt a vége?
		goto	TX_Mode_ID_1		;Igen

		xorlw	TX_ESC_BYTE		;ESC byte-ot kell kikuldeni
		snz
		goto	TX_Mode_ID_2		;Igen, tehát legközelebb kiküljük még egyszer
						;Nem

		movlw	TX_MODE_COMM		;Ide kell visszatérni
		movwf	SIO_Tx_Mode
		return
TX_Mode_ID_2					;Ki kell vinni mégegyszer az ESC-et
		movlw	TX_MODE_COMM		;Ide kell visszatérni
		movwf	SIO_Tx_ModeSave
		
		movlw	TX_MODE_DESC		;Áttérünk az ESC byte kiküldésére
		movwf	SIO_Tx_Mode
		return

TX_Mode_ID_1
		movlw	TX_MODE_COMM		;Áttérünk majd a Parancs küldésre
		movwf	SIO_Tx_ModeSave
		movlw	TX_MODE_DESC		;Áttérünk az ESC byte küldésre
		movwf	SIO_Tx_Mode
		return

;---------
;		decf	SIO_Tx_Length,f		;Még egy adat kiment
;		snz				;Itt a vége?
;		goto	TX_Mode_Comm_1		;Igen
;
;		movlw	TX_MODE_COMM		;Áttérünk a Parancs küldésre
;		movwf	SIO_Tx_Mode
;
;		return
;--------------
TX_Mode_Comm					;4:A parancs
		call	Tx_Buf_Rd		;Olvassuk a parancsot (valójában adatként)
		addwf	SIO_Tx_CHKSUM,f		;A CHKSUM-ot roptiben számoljuk

		movwf	TXREG			;kiküldjük

		decf	SIO_Tx_Length,f		;Még egy adat kiment
		snz				;Itt a vége?
		goto	TX_Mode_Comm_1		;Igen

		movlw	TX_MODE_DATA		;Áttérünk ADAT küldésre
		movwf	SIO_Tx_Mode
		return

TX_Mode_Comm_1
		movlw	TX_MODE_CHKSUM		;Áttérünk a CHKSUM küldésre
		movwf	SIO_Tx_Mode
		return
;--------------
TX_Mode_Data					;5:adat varas
		call	Tx_Buf_Rd		;Olvassuk az adatot
		addwf	SIO_Tx_CHKSUM,f		;A CHKSUM-ot roptiben számoljuk

		movwf	TXREG			;kiküldjük

		decf	SIO_Tx_Length,f		;Még egy adat kiment
	
		xorlw	TX_ESC_BYTE		;ESC byte-ot kell kikuldeni
		snz
		goto	TX_Mode_Data_1		;Igen, tehát legközelebb kiküljük még egyszer
						;Nem
		movlw	TX_MODE_CHKSUM		;Ha nincs több adat, akkor CHKSUM-ba kell menni
		tstfsz	SIO_Tx_Length		;Az adatok végén vagyunk?
		movlw	TX_MODE_DATA		;Nem, tehát maradunk itt
		movwf	SIO_Tx_Mode
		return
TX_Mode_Data_1					;Ki kell vinni mégegyszer az ESC-et
		movlw	TX_MODE_CHKSUM		;
		tstfsz	SIO_Tx_Length		;Az adatok végén vagyunk?
		movlw	TX_MODE_DATA		;Nem, tehát ide kell visszatérni
		movwf	SIO_Tx_ModeSave
		
		movlw	TX_MODE_DESC		;Áttérünk az ESC byte mint adat kiküldésére
		movwf	SIO_Tx_Mode
		return
;--------------
TX_Mode_DEsc					;6:adad kozben ESC-et kell küldeni
		movlw	TX_ESC_BYTE		;ESC byte-ot kell kikuldeni
		movwf	TXREG			;kiküldjük
		movf	SIO_Tx_ModeSave,w	;Visszatérünk ahová kell
		movwf	SIO_Tx_Mode

		movlw	TX_MODE_ESC		;Ahová mennünk kell az az  ESC várás?
		xorwf	SIO_Tx_Mode
		sz
		return				;Nem
						;Igen
		btfsc	TXBUF_EMPTY		;A buffer üres?
		bcf	PIE1,TXIE		;Igen, tehát tiltjuk az IT-t

		return			

;--------------
TX_Mode_CHKSUM		;7:Ha a CHKSUM-ot kell vizsgálni
		movf	SIO_Tx_CHKSUM,w
		xorlw	0xff			;Negálunk!!!
		movwf	TXREG			;kiküldjük

		xorlw	TX_ESC_BYTE		;ESC byte-ot kell kikuldeni
		snz
		goto	TX_Mode_CHKSUM_1	;Igen

		movlw	TX_MODE_ESC		;Végeztünk, tehát visszatérünk ESC módba
		movwf	SIO_Tx_Mode

		btfsc	TXBUF_EMPTY		;A buffer üres?
		bcf	PIE1,TXIE		;Igen, tehát tiltjuk az IT-t

		return			

TX_Mode_CHKSUM_1
		movlw	TX_MODE_DESC		;Még egy ESC-et kell küldneni
		movwf	SIO_Tx_Mode
		movlw	TX_MODE_ESC		;Onnan ESC-be megyünk.
		movwf	SIO_Tx_ModeSave

		return
		
;==============
SIO_IT_RC	
		bcf	PIR1,RCIF
		movf	RCREG,w			;Elvesszük az adatot, nehogy túlcsordulás legyen

		btfss	RC_ENABLE		;Engedélyezve van a vétel
		return				;Nem, tehát eldobunk mindent
		btfsc	RCBUF_FULL		;A vételi buffer tele van?
		return				;Igen, tehát eldobunk mindent, úgysem tudjuk hova rakni
		movwf	i			;Kell az adat, és a bufferbe is elfér, tehát elmentjük

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
		bz	RC_Mode_TAddr		;2:A cim akinek küldték

		movlw	RC_MODE_ID
		xorwf	SIO_Rc_Mode,w
		bz	RC_Mode_ID		;3:A cim aki küldte

		movlw	RC_MODE_SADDR
		xorwf	SIO_Rc_Mode,w
		bz	RC_Mode_SAddr		;4:A cim aki küldte

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
		goto	RC_Mode_CHKSUM		;8:Ha a CHKSUM-ot kell vizsgálni


		goto	RC_Mode_SetESC

rc_mode_error	
		bcf	RCSTA,CREN		;
		bsf	RCSTA,CREN
		movf	RCREG,w			;Eldobjuk!
		return
;--------------
RC_Mode_SetESC
		movlw	RC_MODE_ESC		;Tehát kezdjük elõlrõl a figyelést
		movwf	SIO_Rc_Mode
		return
;==============
RC_Mode_ESC					;0:escape szekvencia varasa
		movlw	RC_ESC_BYTE
		cpfseq	i			;Az escape szekvencia jött?
		return				;Nem
						;Igen (ez még a hossztól is függ!!!!
RC_Mode_ESC_1
		movlw	RC_MODE_LENGTH
		movwf	SIO_Rc_Mode
		return
;--------------
RC_Mode_Length					;1:Adat hossz várás
		movlw	RC_ESC_BYTE
		cpfseq	i			;Az escape szekvencia jött?
		goto	RC_Mode_Length_1	;Nem, tehát rakhatjuk a puferbe
		goto	RC_Mode_SetESC		;Igen, azt jelenti, hogy csak egy adatot fogtunk el

RC_Mode_Length_1				;Itt akkor vagyunk, ha a hosszat kapjuk
		movlw	SIO_RC_LEN_BUF
		addlw	-1	
		cpfslt	i			;A hossz naygobb mint a maxhely?
		goto	RC_Mode_SetESC		;i>w, azaz tuti nem fér bele egyszerre
						;Beleférhet
		movlw	3
		cpfsgt	i			;A hossz nagyobb mint négy?
		goto	RC_Mode_SetESC		;i<4, ez nem jó hossz

		movff	SIO_Rc_pWR,SIO_Rc_pWRTmp;Ide kell írni a byte-okat, inicializáljuk a Tmp-t

		movlw	RC_ESC_BYTE
		movwf	SIO_Rc_CHKSUM		;A CHKSUM indítása az ESC byte-al

		movf	i,w
		movwf	SIO_Rc_Length		;A hossz elmentjük
		addwf	SIO_Rc_CHKSUM,f		;CHKSUM-hoz hozzáadjuka a length-t
		addlw	-2			;Kettõvel kevesebbet kell eltárolni
						;ESC és a CHKSUM-ot nem tesszük le!!!
		call	Rc_Buf_Wr		;Es belarakjuk a buferbe
		snz				;Sikerült belerakni a bufferbe?
		goto	RC_Mode_SetESC		;Nem, 

		decf	SIO_Rc_Length,f		;Csökkentjük a byte számlálót

		movlw	RC_MODE_TADDR		;Legközelebb várjuk a target cimet
		movwf	SIO_Rc_Mode
		return		
;--------------
RC_Mode_TAddr					;2:A cim akinek küldték
		movf	SIO_TAddr,w
		cpfseq	i			;A cím egyezik a milyenkkel
		goto	RC_Mode_SetESC		;Nem (Csak a sporolás miatt goto)
						;A cím megegyezik!!!
		movf	i,w
		addwf	SIO_Rc_CHKSUM,f		;CHKSUM-hoz hozzáadjuka az TAddr-t
						;A buf-ba nem kell belerakni
;		call	Rc_Buf_Wr		;Es belarakjuk a buferbe
;		sz				;Sikerült belerakni a bufferbe?
;		goto	RC_Mode_SetESC		;Nem, 
		
		decf	SIO_Rc_Length,f		;Csökkentjük a byte számlálót

;		movlw	RC_MODE_COMM		;A következõ a parancs lesz
		movlw	RC_MODE_SADDR		;A következõ a forrás címe
		movwf	SIO_Rc_Mode
		return
;--------------			
RC_Mode_SAddr					;3:A cim aki küldte
		movf	i,w
		addwf	SIO_Rc_CHKSUM,f		;CHKSUM-hoz hozzáadjuka az TAddr-t
						
		call	Rc_Buf_Wr		;Es belarakjuk a buferbe
		snz				;Sikerült belerakni a bufferbe?
		goto	RC_Mode_SetESC		;Nem, 
		
		decf	SIO_Rc_Length,f		;Csökkentjük a byte számlálót

		movlw	RC_MODE_ID		;A következõ a parancs lesz
		movwf	SIO_Rc_Mode
		return
;--------------			
RC_Mode_ID					;4:A üzenet azonosító
		movf	i,w
		movwf	j			;Elmentjük, mert késõbb szükség lesz rá
		addwf	SIO_Rc_CHKSUM,f		;CHKSUM-hoz hozzáadjuk az ID-t
						
		call	Rc_Buf_Wr		;Es belarakjuk a buferbe
		snz				;Sikerült belerakni a bufferbe?
		goto	RC_Mode_SetESC		;Nem, 
;---
		decf	SIO_Rc_Length,f		;Csökkentjük a byte számlálót
		movlw	RC_MODE_COMM		;Legközelebb ide kellmenni(vagy nem)
		movwf	SIO_Rc_ModeSave		;Ide kell menni legközelebb

		movlw	RC_ESC_BYTE		;
		cpfseq	j			;Az escape szekvencia jött?
		goto	RC_Mode_ID_1		;Nem, tehát mehetünk tovább
						;Igen, azt jelenti, hogy 0x55-öt fogtunk el
		movlw	RC_MODE_DESC		;Mehetünk a DESC-be, a visszatérés már feltöltve
		movwf	SIO_Rc_Mode
		return

;---		
;		decf	SIO_Rc_Length,f		;Csökkentjük a byte számlálót
RC_Mode_ID_1
		movlw	RC_MODE_COMM		;A következõ a parancs lesz
		movwf	SIO_Rc_Mode
		return


;--------------		
RC_Mode_Comm					;4:Parancs varas
		movf	i,w
		addwf	SIO_Rc_CHKSUM,f		;CHKSUM-hoz hozzáadjuka az Commandot
		call	Rc_Buf_Wr		;Es belarakjuk a buferbe
		snz				;Sikerült belerakni a bufferbe?
		goto	RC_Mode_SetESC		;Nem, 

		decf	SIO_Rc_Length,f		;Csökkentjük a byte számlálót
		decf	SIO_Rc_Length,f		;Mégegyet csökkentünk, hogy 
		snz				;megnézzûk, hogy a köv.byte a CHKSUM-e
		goto	RC_Mode_Comm_1		;A következõ CHKSUM-nak kell lennie a db.szám miatt
		movlw	RC_MODE_DATA		;A következõ a parancs lesz
		movwf	SIO_Rc_Mode
		return
RC_Mode_Comm_1		
		movlw	RC_MODE_CHKSUM		;A következõ a parancs lesz
		movwf	SIO_Rc_Mode
		return

;--------------
RC_Mode_Data					;5:adat varas
		movf	i,w
		movwf	j			;Elmentjük, mert késõbb szükség lesz rá
		addwf	SIO_Rc_CHKSUM,f		;CHKSUM-hoz hozzáadjuka az Adatot
		call	Rc_Buf_Wr		;Es belarakjuk a buferbe
		snz				;Sikerült belerakni a bufferbe?
		goto	RC_Mode_SetESC		;Nem, 

		movlw	RC_MODE_DATA		;Legközelebb ide kellmenni(vagy nem)
		decf	SIO_Rc_Length,f		;Csökkentjük a byte számlálót
		snz				;megnézzûk, hogy a köv.byte a CHKSUM-e
		movlw	RC_MODE_CHKSUM		;Igen, tehát nem data
		movwf	SIO_Rc_ModeSave		;Ide kell menni legközelebb

		movlw	RC_ESC_BYTE		;
		cpfseq	j			;Az escape szekvencia jött?
		goto	RC_Mode_Data_1		;Nem, tehát mehetünk tovább
						;Igen, azt jelenti, hogy 0x55-öt fogtunk el
		movlw	RC_MODE_DESC		;Mehetünk a DESC-be, a visszatérés már feltöltve
		movwf	SIO_Rc_Mode
		return
RC_Mode_Data_1
		movf	SIO_Rc_ModeSave,w	;A következõre megyünk
		movwf	SIO_Rc_Mode
		return
;--------------	
RC_Mode_DEsc					;6:adad kozben escape jott
		movlw	RC_ESC_BYTE		;
		cpfseq	i			;Az escape szekvencia jött?
		goto	RC_Mode_ESC_1		;Nem, tehát blokk eleje jött
						;Igen, azt jelenti, hogy 0x55-öt fogtunk el

		movf	SIO_Rc_ModeSave,w	;Visszatérünk ahová kell
		movwf	SIO_Rc_Mode
		xorlw	RC_MODE_ESC		;A CHKSUM-ból kellett idejönni?
		sz			
		return				;Nem
						;Igen
		goto	RC_Mode_CHKSUM_1
;--------------
RC_Mode_CHKSUM					;7:CHKSUM vizsgálat
		movf	i,w			;A bejött CHKSUM-ot hozzáadjuk a
		addwf	SIO_Rc_CHKSUM,f		;CHKSUM-hoz
		movlw	0xff			;Negálunk
		xorwf	SIO_Rc_CHKSUM,f		;A CHKSUM-ot ellenõrizzük

		movlw	RC_ESC_BYTE		;
		cpfseq	i			;Az escape szekvencia jött?
		goto	RC_Mode_CHKSUM_1	;Nem, tehát blokk eleje jött
						;Igen, azt jelenti, hogy 0x55-öt fogtunk el

		tstfsz	SIO_Rc_CHKSUM		;A CHKSUM jó volt?
		goto	RC_Mode_SetESC		;Nem

		movlw	RC_MODE_DESC		;Igen, tehát DEsc-be megyünk
		movwf	SIO_Rc_Mode		;Ide kell menni legközelebb

		movlw	RC_MODE_ESC		;Igen, tehát DEsc-be megyünk
		movwf	SIO_Rc_ModeSave		;Ide kell menni legközelebb

		return

RC_Mode_CHKSUM_1
		tstfsz	SIO_Rc_CHKSUM		;A CHKSUM jó volt?
		goto	RC_Mode_SetESC		;Nem
;---						;IGEN
		movff	SIO_Rc_pWRTmp,SIO_Rc_pWR;Idáig van belírva az adat
		bcf	RCBUF_EMPTY		;Mostmár tuti nem üres a buffer

		call	LED0_ON_Fun

		goto	RC_Mode_SetESC		;Várjuk a következõ csomagot (ESC-et)

;+------------------------------------------------------------------+
;|     Rc_Buf_Wr                                                    |
;+------------------------------------------------------------------+
;|     rontott regiszterek : w,i,STATUS,            |
;+------------------------------------------------------------------+
;|     funkcio: A w tartalmát berakja az Rc_Buf-ba.                 |
;|              A Cimet a SIO_Rc_pWRTmp adja relativan az Rc_Buf-hoz|
;+------------------------------------------------------------------+
Rc_Buf_Wr	;Az w tartalmát rakja az Rc_Buf-ba
		setz				;Ha nincs elég hely, a Z-n jelezzük
		btfsc	RCBUF_FULL		;A bufferben még van hely?
		return				;Nincs, HIBAkóddal kilépünk

		movwf	i			;Elmentjük a kiviendõ adatot

		lfsr	FSR0,Rc_Buf		;FSR0-ba a buffer kezdõcímét rakjuk
		movf	SIO_Rc_pWRTmp,w
		addwf	FSR0L,f
		movff	i,INDF0			;A pufferbe belerakjuk az elsõ byte-ot
;---
		incf	SIO_Rc_pWRTmp,f		;noveljük az iró pointert
		movlw	SIO_RC_LEN_BUF-1	
		andwf	SIO_Rc_pWRTmp,f		;ne csorduljon túl

		movf	SIO_Rc_pRD,w
		xorwf	SIO_Rc_pWRTmp,w
		snz				;Tele lett az Rc_Buff?
		bsf	RCBUF_FULL		;Igen, tehát jelezzük

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
		setz				;Ha nincs adat, a Z-n jelezzük
		btfsc	RCBUF_EMPTY		;A bufferben van adat?
		return				;Nincs, HIBAkóddal kilépünk

		lfsr	FSR0,Rc_Buf		;FSR0-ba a buffer kezdõcímét rakjuk
		movf	SIO_Rc_pRD,w
		addwf	FSR0L,f
		movff	INDF0,i			;Az i-be belerakjuk az adatot
;---
		incf	SIO_Rc_pRD,f		;noveljük az iró pointert
		movlw	SIO_RC_LEN_BUF-1	
		andwf	SIO_Rc_pRD,f		;ne csorduljon túl

		movf	SIO_Rc_pRD,w
		xorwf	SIO_Rc_pWR,w
		snz				;Üres lett az Rc_Buff?
		bsf	RCBUF_EMPTY		;Igen, tehát jelezzük
		bcf	RCBUF_FULL		;Ha eddig tele volt, mostmár biztos nincs
;---
		movf	i,w			;A w-be is átadjuk
		clrz
		return
;--------------
Rc_Buf_GetLength
		movff	SIO_Rc_pRD,SIO_Rc_pRDTmp;Az aktuális olvasópointert megjegyezzük

		call	Rc_Buf_Rd		;Kivesszük a hosszt
		addwf	SIO_Rc_pRDTmp,f		;a Tmp-vel elmegyünk a következõ blokkhoz
		movlw	SIO_RC_LEN_BUF-1
		andwf	SIO_Rc_pRDTmp,f		;ne csorduljon túl
		movf	i,w			;w-ben a hossz
		return
;--------------
Rc_Buf_NextBlock
		movff	SIO_Rc_pRDTmp,SIO_Rc_pRD;A pointert a következõ blokk-ra állítjuk
						;Nehogy kevés olvasás legyen
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
;|     funkcio: A SIO körpufferébe beírjuk az w-ben levõ adatot     |
;+------------------------------------------------------------------+
Tx_Buf_Wr	;Az w tartalmát rakja Tx_Buff-ba
		setz				;Ha nincs elég hely, a Z-n jelezzük
		btfsc	TXBUF_FULL		;A bufferben még van hely?
		return				;Nincs, HIBAkóddal kilépünk

		movwf	i			;Elmentjük a kiviendõ adatot

		lfsr	FSR0,Tx_Buf		;FSR0-ba a buffer kezdõcímét rakjuk
		movf	SIO_Tx_pWRTmp,w
		addwf	FSR0L,f
		movff	i,INDF0			;A pufferbe belerakjuk az elsõ byte-ot
;---
		movlw	SIO_TX_LEN_BUF-1	;noveljük az iró pointert
		incf	SIO_Tx_pWRTmp,f
		andwf	SIO_Tx_pWRTmp,f		;ne csorduljon túl

		bcf	TXBUF_EMPTY		;Ha üres lett volna, most már nem az

		movf	SIO_Tx_pRD,w
		xorwf	SIO_Tx_pWRTmp,w
		snz				;Tele lett a Tx_Buff?
		bsf	TXBUF_FULL		;Igen, tehát jelezzük
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
		setz				;Ha nincs adat, a Z-n jelezzük
		btfsc	TXBUF_EMPTY		;A bufferben van adat?
		return				;Nincs, HIBAkóddal kilépünk

		lfsr	FSR0,Tx_Buf		;FSR0-ba a buffer kezdõcímét rakjuk
		movf	SIO_Tx_pRD,w
		addwf	FSR0L,f
		movff	INDF0,i			;Az i-be belerakjuk az adatot
;---
		incf	SIO_Tx_pRD,f		;noveljük az iró pointert
		movlw	SIO_TX_LEN_BUF-1	
		andwf	SIO_Tx_pRD,f		;ne csorduljon túl

		movf	SIO_Tx_pRD,w
		xorwf	SIO_Tx_pWR,w
		snz				;Üres lett az Rc_Buff?
		bsf	TXBUF_EMPTY		;Igen, tehát jelezzük
		bcf	TXBUF_FULL		;Ha eddig tele volt, mostmár biztos nincs
;---
		movf	i,w			;A w-be is átadjuk
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
;Azonnal küldjük a választ!!!
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
