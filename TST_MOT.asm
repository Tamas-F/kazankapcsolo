;+------------------------------------------------------------------+
;|     GetMotPos                                                   |
;+------------------------------------------------------------------+
;|     rontott regiszterek :                                        |
;+------------------------------------------------------------------+
;|     funkcio:  MotorCím->I2C_W,FSR0:ahova rakni kell az adatokat  |
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
		call	TransData		;Cím

		movlw	COMMOT_SETMOT		;Parancs: Motor beállítás
		movwf	I2C_W
		call	TransData

		movff	POSTINC1,I2C_W
		call	TransData		;Sebesség L byte
		movff	POSTINC1,I2C_W
		call	TransData		;Sebesség H byte
		movff	POSTINC1,I2C_W
		call	TransData		;Pozíció L byte
		movff	POSTINC1,I2C_W
		call	TransData		;Pozíció M byte
		movff	POSTINC1,I2C_W
		call	TransData		;Pozíció H byte

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
		call	TransData		;Cím

		movlw	COMMOT_SETMPOS		;Parancs: MotorPos beállítás
		movwf	I2C_W
		call	TransData

		movff	POSTINC1,I2C_W
		call	TransData		;L byte
		movff	POSTINC1,I2C_W
		call	TransData		;M byte
		movff	POSTINC1,I2C_W
		call	TransData		;H byte
		clrf	I2C_W
		call	TransData		;Ez csak azért, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak azért, hogy meglegyen az 5 byte

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
		call	TransData		;Cím

		movlw	COMMOT_SETHOME		;Parancs: Home, adatban a pozíciója
		movwf	I2C_W
		call	TransData

		movff	POSTINC1,I2C_W
		call	TransData		;L byte
		movff	POSTINC1,I2C_W
		call	TransData		;M byte
		movff	POSTINC1,I2C_W
		call	TransData		;H byte
		clrf	I2C_W
		call	TransData		;Ez csak azért, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak azért, hogy meglegyen az 5 byte

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
		call	TransData		;Cím

		movlw	COMMOT_SETGO		;Parancs: Home, adatban a pozíciója
		movwf	I2C_W
		call	TransData

		movff	POSTINC1,I2C_W
		call	TransData		;MOTCOM
		movff	POSTINC1,I2C_W
		call	TransData		;MOTSPEED
		clrf	I2C_W
		call	TransData		;Ez csak azért, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak azért, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak azért, hogy meglegyen az 5 byte

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
		call	TransData		;Cím

		movlw	COMMOT_SETSTOP		;Motor Stop parancsot adunk
		movwf	I2C_W
		call	TransData

		clrf	I2C_W
		call	TransData		;Ez csak azért, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak azért, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak azért, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak azért, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak azért, hogy meglegyen az 5 byte

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
		call	TransData		;Cím

		movlw	COMMOT_SETSTOPRN	;Motor Stop azonnal parancsot adunk
		movwf	I2C_W
		call	TransData

		clrf	I2C_W
		call	TransData		;Ez csak azért, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak azért, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak azért, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak azért, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak azért, hogy meglegyen az 5 byte

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
		call	TransData		;Cím

		movlw	COMMOT_SETBEGEND	;Parancs: Motor beállítás
		movwf	I2C_W
		call	TransData

		movlw	SetMaxCom_DW
		movwf	I2C_W
		call	TransData		;a parancs, hogy milyen módban kell menni
		clrf	I2C_W
		call	TransData		;Ez csak azért, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak azért, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak azért, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak azért, hogy meglegyen az 5 byte

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
		call	TransData		;Cím

		movlw	COMMOT_SETBEGEND	;Parancs: Motor beállítás
		movwf	I2C_W
		call	TransData

		movlw	SetMaxCom_UP
		movwf	I2C_W
		call	TransData		;a parancs, hogy milyen módban kell menni
		clrf	I2C_W
		call	TransData		;Ez csak azért, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak azért, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak azért, hogy meglegyen az 5 byte
		clrf	I2C_W
		call	TransData		;Ez csak azért, hogy meglegyen az 5 byte

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
		call	TransData		;Cím

		movlw	COMMOT_SETBEGEND	;Parancs: Motor beállítás
		movwf	I2C_W
		call	TransData

		movlw	SetMaxCom_PDW
		movwf	I2C_W
		call	TransData		;a parancs, hogy milyen módban kell menni
		movff	POSTINC1,I2C_W
		call	TransData		;Az új érték L
		movff	POSTINC1,I2C_W
		call	TransData		;Az új érték M
		movff	POSTINC1,I2C_W
		call	TransData		;Az új érték H
		clrf	I2C_W
		call	TransData		;Ez csak azért, hogy meglegyen az 5 byte

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
		call	TransData		;Cím

		movlw	COMMOT_SETBEGEND	;Parancs: Motor beállítás
		movwf	I2C_W
		call	TransData

		movlw	SetMaxCom_PUP
		movwf	I2C_W
		call	TransData		;a parancs, hogy milyen módban kell menni
		movff	POSTINC1,I2C_W
		call	TransData		;Az új érték L
		movff	POSTINC1,I2C_W
		call	TransData		;Az új érték M
		movff	POSTINC1,I2C_W
		call	TransData		;Az új érték H
		clrf	I2C_W
		call	TransData		;Ez csak azért, hogy meglegyen az 5 byte

		call	SetStop

		return
