;+------------------------------------------------------------------+
;|     GetMotPos                                                   |
;+------------------------------------------------------------------+
;|     rontott regiszterek :                                        |
;+------------------------------------------------------------------+
;|     funkcio:  MotorC�m->I2C_W,FSR0:ahova rakni kell az adatokat  |
;|                                                                  |
;+------------------------------------------------------------------+
GetMotPos
		call	SetStart
		movwf	I2C_W
		call	TransData

		call	RecData
		movff	I2C_PDATA,POSTINC0	;Input
		call	RecData
		movff	I2C_PDATA,POSTINC0	;Output vissza
		call	RecData
		movff	I2C_PDATA,POSTINC0	;Status0
		call	RecData
		movff	I2C_PDATA,POSTINC0	;Status1
		call	RecData
		movff	I2C_PDATA,POSTINC0	;PosL
		call	RecData
		movff	I2C_PDATA,POSTINC0	;PosM
		call	RecData
		movff	I2C_PDATA,POSTINC0	;PosH
		call	RecData
		movff	I2C_PDATA,POSTINC0	;EncL
		call	RecData
		movff	I2C_PDATA,POSTINC0	;EncM
		call	RecDataL
		movff	I2C_PDATA,POSTINC0	;EncH
		call	SetStop
		return


;+------------------------------------------------------------------+
;|     ComMot_SetHome                                               |
;+------------------------------------------------------------------+
;|     funkcio:                                                     |
;+------------------------------------------------------------------+
ComMot_SetMotor

		call	SetStart

		lfsr	FSR1,MotParams
		movff	POSTINC1,I2C_W
		call	TransData		;C�m

		movlw	COMMOT_SETMOT		;Parancs: Motor be�ll�t�s
		movwf	I2C_W
		call	TransData

		movff	POSTINC1,I2C_W
		call	TransData		;Sebess�g L byte
		movff	POSTINC1,I2C_W
		call	TransData		;Sebess�g H byte
		movff	POSTINC1,I2C_W
		call	TransData		;Poz�ci� L byte
		movff	POSTINC1,I2C_W
		call	TransData		;Poz�ci� M byte
		movff	POSTINC1,I2C_W
		call	TransData		;Poz�ci� H byte

		call	SetStop

		return
;+------------------------------------------------------------------+
;|     ComMot_SetHomePos                                            |
;+------------------------------------------------------------------+
;|     funkcio:                                                     |
;+------------------------------------------------------------------+
ComMot_SetMotorPos

		call	SetStart

		lfsr	FSR1,MotParams
		movff	POSTINC1,I2C_W
		call	TransData		;C�m

		movlw	COMMOT_SETMPOS		;Parancs: MotorPos be�ll�t�s
		movwf	I2C_W
		call	TransData

		movff	POSTINC1,I2C_W
		call	TransData		;L byte
		movff	POSTINC1,I2C_W
		call	TransData		;M byte
		movff	POSTINC1,I2C_W
		call	TransData		;H byte
		clrf	I2C_W
		call	TransData		;Ez csak az�rt, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak az�rt, hogy meglegyen az 5 byte

		call	SetStop

		return
;+------------------------------------------------------------------+
;|     ComMot_SetHomePos                                            |
;+------------------------------------------------------------------+
;|     funkcio:                                                     |
;+------------------------------------------------------------------+
ComMot_SetHomePos

		call	SetStart

		lfsr	FSR1,MotParams
		movff	POSTINC1,I2C_W
		call	TransData		;C�m

		movlw	COMMOT_SETHOME		;Parancs: Home, adatban a poz�ci�ja
		movwf	I2C_W
		call	TransData

		movff	POSTINC1,I2C_W
		call	TransData		;L byte
		movff	POSTINC1,I2C_W
		call	TransData		;M byte
		movff	POSTINC1,I2C_W
		call	TransData		;H byte
		clrf	I2C_W
		call	TransData		;Ez csak az�rt, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak az�rt, hogy meglegyen az 5 byte

		call	SetStop

		return
;+------------------------------------------------------------------+
;|     ComMot_SetHomePos                                            |
;+------------------------------------------------------------------+
;|     funkcio:                                                     |
;+------------------------------------------------------------------+
ComMot_SetGo

		call	SetStart

		lfsr	FSR1,MotParams
		movff	POSTINC1,I2C_W
		call	TransData		;C�m

		movlw	COMMOT_SETGO		;Parancs: Home, adatban a poz�ci�ja
		movwf	I2C_W
		call	TransData

		movff	POSTINC1,I2C_W
		call	TransData		;MOTCOM
		movff	POSTINC1,I2C_W
		call	TransData		;MOTSPEED
		clrf	I2C_W
		call	TransData		;Ez csak az�rt, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak az�rt, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak az�rt, hogy meglegyen az 5 byte

		call	SetStop

		return
;+------------------------------------------------------------------+
;|     ComMot_SetMotorStop                                           |
;+------------------------------------------------------------------+
;|     funkcio:                                                     |
;+------------------------------------------------------------------+
ComMot_SetMotorStop
		call	SetStart

		lfsr	FSR1,MotParams
		movff	INDF1,I2C_W
		call	TransData		;C�m

		movlw	COMMOT_SETSTOP		;Motor Stop parancsot adunk
		movwf	I2C_W
		call	TransData

		clrf	I2C_W
		call	TransData		;Ez csak az�rt, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak az�rt, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak az�rt, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak az�rt, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak az�rt, hogy meglegyen az 5 byte

		call	SetStop

		return
;+------------------------------------------------------------------+
;|     ComMot_SetMotorStopRN                                        |
;+------------------------------------------------------------------+
;|     funkcio:                                                     |
;+------------------------------------------------------------------+
ComMot_SetMotorStopRN

		call	SetStart

		lfsr	FSR1,MotParams
		movff	INDF1,I2C_W
		call	TransData		;C�m

		movlw	COMMOT_SETSTOPRN	;Motor Stop azonnal parancsot adunk
		movwf	I2C_W
		call	TransData

		clrf	I2C_W
		call	TransData		;Ez csak az�rt, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak az�rt, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak az�rt, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak az�rt, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak az�rt, hogy meglegyen az 5 byte

		call	SetStop

		return


;+------------------------------------------------------------------+
;|     ComMot_SetMotorBeg                                           |
;+------------------------------------------------------------------+
;|     funkcio:                                                     |
;+------------------------------------------------------------------+
ComMot_SetMotorBeg
		call	SetStart

		lfsr	FSR1,MotParams
		movff	POSTINC1,I2C_W
		call	TransData		;C�m

		movlw	COMMOT_SETBEGEND	;Parancs: Motor be�ll�t�s
		movwf	I2C_W
		call	TransData

		movlw	SetMaxCom_DW
		movwf	I2C_W
		call	TransData		;a parancs, hogy milyen m�dban kell menni
		clrf	I2C_W
		call	TransData		;Ez csak az�rt, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak az�rt, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak az�rt, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak az�rt, hogy meglegyen az 5 byte

		call	SetStop

		return
;+------------------------------------------------------------------+
;|     ComMot_SetMotorEnd                                           |
;+------------------------------------------------------------------+
;|     funkcio:                                                     |
;+------------------------------------------------------------------+
ComMot_SetMotorEnd
		call	SetStart

		lfsr	FSR1,MotParams
		movff	POSTINC1,I2C_W
		call	TransData		;C�m

		movlw	COMMOT_SETBEGEND	;Parancs: Motor be�ll�t�s
		movwf	I2C_W
		call	TransData

		movlw	SetMaxCom_UP
		movwf	I2C_W
		call	TransData		;a parancs, hogy milyen m�dban kell menni
		clrf	I2C_W
		call	TransData		;Ez csak az�rt, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak az�rt, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak az�rt, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak az�rt, hogy meglegyen az 5 byte

		call	SetStop

		return

;+------------------------------------------------------------------+
;|     ComMot_SetMotorPBeg                                          |
;+------------------------------------------------------------------+
;|     funkcio:                                                     |
;+------------------------------------------------------------------+
ComMot_SetMotorPBeg
		call	SetStart

		lfsr	FSR1,MotParams
		movff	POSTINC1,I2C_W
		call	TransData		;C�m

		movlw	COMMOT_SETBEGEND	;Parancs: Motor be�ll�t�s
		movwf	I2C_W
		call	TransData

		movlw	SetMaxCom_PDW
		movwf	I2C_W
		call	TransData		;a parancs, hogy milyen m�dban kell menni
		movff	POSTINC1,I2C_W
		call	TransData		;Az �j �rt�k L
		movff	POSTINC1,I2C_W
		call	TransData		;Az �j �rt�k M
		movff	POSTINC1,I2C_W
		call	TransData		;Az �j �rt�k H
		clrf	I2C_W
		call	TransData		;Ez csak az�rt, hogy meglegyen az 5 byte

		call	SetStop

		return
;+------------------------------------------------------------------+
;|     ComMot_SetMotorPEnd                                          |
;+------------------------------------------------------------------+
;|     funkcio:                                                     |
;+------------------------------------------------------------------+
ComMot_SetMotorPEnd
		call	SetStart

		lfsr	FSR1,MotParams
		movff	POSTINC1,I2C_W
		call	TransData		;C�m

		movlw	COMMOT_SETBEGEND	;Parancs: Motor be�ll�t�s
		movwf	I2C_W
		call	TransData

		movlw	SetMaxCom_PUP
		movwf	I2C_W
		call	TransData		;a parancs, hogy milyen m�dban kell menni
		movff	POSTINC1,I2C_W
		call	TransData		;Az �j �rt�k L
		movff	POSTINC1,I2C_W
		call	TransData		;Az �j �rt�k M
		movff	POSTINC1,I2C_W
		call	TransData		;Az �j �rt�k H
		clrf	I2C_W
		call	TransData		;Ez csak az�rt, hogy meglegyen az 5 byte

		call	SetStop

		return
