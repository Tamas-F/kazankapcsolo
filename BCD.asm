
;******************************************************************************
;
;		BCD-ben növeljük a INDF1 értéket 1-el
;
;******************************************************************************
BCD_Inc_INDF1_99
		incf	INDF1,f
		movlw	0x06
		addwf	INDF1,w
		btfsc	STATUS,DC
		movwf	INDF1
		movlw	0x60
		addwf	INDF1,w
		btfsc	STATUS,C
		movwf	INDF1
		return
;--------------
BCD_Inc10_INDF1_99
		movlw	0x10
		addwf	INDF1,f
		movlw	0x60
		addwf	INDF1,w
		btfsc	STATUS,C
		movwf	INDF1
		return
;--------------
BCD_Inc_INDF1_60
		incf	INDF1,f
		movlw	0x06
		addwf	INDF1,w
		btfsc	STATUS,DC
		movwf	INDF1
		movlw	0xa0
		addwf	INDF1,w
		btfsc	STATUS,C
		movwf	INDF1
		return
;--------------
BCD_Inc10_INDF1_60
		movlw	0x10
		addwf	INDF1,f
		movlw	0xa0
		addwf	INDF1,w
		btfsc	STATUS,C
		movwf	INDF1
		return
;******************************************************************************
;
;		BCD-ben csökkentjük az INDF1 értékét 1-el
;
;******************************************************************************
BCD_Dec_INDF1_99
		movlw	1
		subwf	INDF1,w
		movff	STATUS,INDF1

		btfss	INDF1,1
		addlw	-0x06
		btfss	INDF1,0
		addlw	-0x60

		movff	INDF1,STATUS
		movwf	INDF1
		return
;--------------
BCD_Dec10_INDF1_99
		movlw	0x10
		subwf	INDF1,w

		btfss	STATUS,C
		addlw	-0x60

		movwf	INDF1
		return
;--------------
BCD_Dec_INDF1_60
		movlw	1
		subwf	INDF1,w
		movff	STATUS,INDF1

		btfss	INDF1,1
		addlw	-0x06
		btfss	INDF1,0
		addlw	-0xA0

		movff	INDF1,STATUS
		movwf	INDF1
		return
;--------------
BCD_Dec10_INDF1_60
		movlw	0x10
		subwf	INDF1,w

		btfss	STATUS,C
		addlw	-0xA0

		movwf	INDF1
		return







