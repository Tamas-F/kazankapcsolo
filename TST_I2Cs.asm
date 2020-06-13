;--------------
Init_i2cs	
		movlw	0xf0
		movwf	I2C_ADDR
		call	Set_SDA
		call	Set_SCL			
		return
;--------------
Get_SDASCL
		btfsc	I2C_SCL
		bsf	I2C_SDASCL,0
		btfss	I2C_SCL
		bcf	I2C_SDASCL,0
		btfsc	I2C_SDA
		bsf	I2C_SDASCL,1
		btfss	I2C_SDA
		bcf	I2C_SDASCL,1
		return
;--------------
Set_SDA		;bank1
		bsf	I2C_SDA_TRIS
		;bank0
;		call	wait_bittime
		return
;--------------
Set_SCL		;bank1
		bsf	I2C_SCL_TRIS
		;bank0
;		call	wait_bittime
		return
;--------------
Clr_SDA		bcf	I2C_SDA
		;bank1
		bcf	I2C_SDA_TRIS
		;bank0
		bcf	I2C_SDA
;		call	wait_bittime
		return
;--------------
Clr_SCL		bcf	I2C_SCL
		;bank1
		bcf	I2C_SCL_TRIS
		;bank0
		bcf	I2C_SCL
;		call	wait_bittime
		return
;--------------
Wait_SCL	;bank0
		clrf	I2C_i
Wait_SCL_1	incf	I2C_i,f
		snz
		return	
		btfss	I2C_SCL
		goto	Wait_SCL_1
		return
;--------------
SetStart
		call	Set_SDA
		call	Set_SCL			;
		call	Clr_SDA
		call	Clr_SCL
		call	Set_SDA
		call	Get_SDASCL
		return
;--------------
SetStop
		call	Clr_SDA
		call	Clr_SCL
		call	Set_SCL
		call	Set_SDA
		call	Get_SDASCL
		return

;--------------
TransData
		;bank0
		movlw	0x80
		movwf	I2C_j

TransData_1		
		call	Clr_SCL

		movf	I2C_W,w
		andwf	I2C_j,w
		snz
		call	Clr_SDA
		movf	I2C_W,w
		andwf	I2C_j,w
		sz
		call	Set_SDA

		call	Set_SCL

		bcf	STATUS,C
		rrcf	I2C_j,f
		tstf	I2C_j,0
		sz
		goto	TransData_1

		call	Clr_SCL
		call	Set_SDA
		call	Set_SCL
		call	Get_SDASCL
		call	Clr_SCL

		return

;--------------
RecData
		;bank0
		movlw	0x80
		movwf	I2C_j
		clrf	I2C_PDATA
		call	Set_SDA
		call	Set_SCL
		call	Wait_SCL
		movf	I2C_i,w
		movwf	I2C_SDASCL
		
		tstf	I2C_i,0
		snz
		retlw	1

			
RecData_1
		call	Set_SCL

		rlcf	I2C_PDATA,f
		btfsc	I2C_SDA
		bsf	I2C_PDATA,0
		btfss	I2C_SDA
		bcf	I2C_PDATA,0

		call	Clr_SCL
		clrc
		rrcf	I2C_j,f
		tstf	I2C_j,0
		sz
		goto	RecData_1
		
		call	Clr_SDA
		call	Set_SCL
		call	Clr_SCL

		retlw	0

;--------------
RecDataL
		;bank0
		movlw	0x80
		movwf	I2C_j
		clrf	I2C_PDATA
		call	Set_SDA
		call	Set_SCL
		call	Wait_SCL
		movf	I2C_i,w
		movwf	I2C_SDASCL
		
		tstf	I2C_i,0
		snz
		retlw	1

			
RecDataL_1
		call	Set_SCL

		rlcf	I2C_PDATA,f
		btfsc	I2C_SDA
		bsf	I2C_PDATA,0
		btfss	I2C_SDA
		bcf	I2C_PDATA,0

		call	Clr_SCL
		clrc
		rrcf	I2C_j,f
		tstf	I2C_j,0
		sz
		goto	RecDataL_1
		
		call	Set_SDA
		call	Set_SCL
		call	Clr_SCL

		retlw	0
;--------------
Put_Output	;bank0
		call	SetStart
		movf	I2C_ADDR,w
		movwf	I2C_W
		bcf	I2C_W,0
		call	TransData
		movf	I2C_PDATA,w
		movwf	I2C_W
		call	TransData
		call	SetStop
		return
		;--------------
Get_Input	;bank0
		call	SetStart
		movf	I2C_ADDR,w
		movwf	I2C_W
		bsf	I2C_W,0
		call	TransData
		call	RecDataL
		call	SetStop
		return
		

