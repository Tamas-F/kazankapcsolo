;+------------------------------------------------------------------+
;|                                                                  |
;|                                                                  |
;+------------------------------------------------------------------+
Init_In8
		bsf	IN0_TRIS
		bsf	IN1_TRIS
		bsf	IN2_TRIS
		bsf	IN3_TRIS
		bsf	IN4_TRIS
		bsf	IN5_TRIS
               call    In8
		return
;+------------------------------------------------------------------+
;|                                                                  |
;|                                                                  |
;+------------------------------------------------------------------+
In8		clrf	In8Reg
		btfss	IN0
		bsf	In8Reg,0
		btfss	IN1
		bsf	In8Reg,1
		btfss	IN2
		bsf	In8Reg,2
		btfss	IN3
		bsf	In8Reg,3
		btfss	IN4
		bsf	In8Reg,4
		btfss	IN5
		bsf	In8Reg,5
		btfss	IN6
		bsf	In8Reg,6
		btfss	IN7
		bsf	In8Reg,7

		return

  
;+------------------------------------------------------------------+
;|                                                                  |
;|                                                                  |
;+------------------------------------------------------------------+
Init_Out8
                bcf     TRISE,PSPMODE,0

		bcf	OUT0_TRIS
		bcf	OUT1_TRIS
		bcf	OUT2_TRIS
		bcf	OUT3_TRIS
		bcf	OUT4_TRIS
		bcf	OUT5_TRIS
		bcf	OUT6_TRIS
		bcf	OUT7_TRIS
		clrf	Out8Reg
		call	Out8
		return
;+------------------------------------------------------------------+
;|                                                                  |
;|                                                                  |
;+------------------------------------------------------------------+
Out8		btfsc	Out8Reg,0
		bcf	OUT0
		btfss	Out8Reg,0
		bsf	OUT0

		btfsc	Out8Reg,1
		bcf	OUT1
		btfss	Out8Reg,1
		bsf	OUT1

		btfsc	Out8Reg,2
		bcf	OUT2
		btfss	Out8Reg,2
		bsf	OUT2

		btfsc	Out8Reg,3
		bcf	OUT3
		btfss	Out8Reg,3
		bsf	OUT3

		btfsc	Out8Reg,4
		bcf	OUT4
		btfss	Out8Reg,4
		bsf	OUT4

		btfsc	Out8Reg,5
		bcf	OUT5
		btfss	Out8Reg,5
		bsf	OUT5

		btfsc	Out8Reg,6
		bcf	OUT6
		btfss	Out8Reg,6
		bsf	OUT6

		btfsc	Out8Reg,7
		bcf	OUT7
		btfss	Out8Reg,7 
		bsf	OUT7

		return

;+------------------------------------------------------------------+
;|     IO_Proc                                                         |
;+------------------------------------------------------------------+
IO_Proc
		tstfsz	IO_Timer
		return
;----
		movlw	0
		xorwf	IO_Phase,w
		bz	IO_Proc_0

		movlw	1
		xorwf	IO_Phase,w
		bz	IO_Proc_1

		movlw	2
		xorwf	IO_Phase,w
		bz	IO_Proc_2

		movlw	3
		xorwf	IO_Phase,w
		bz	IO_Proc_3

		clrf	IO_Phase

		movlw	1
		movwf	IO_Timer
		return
;-------------	1. I8O8 Olvasás
IO_Proc_0
		call	SetStart
		movlw	0x11
		movwf	I2C_W
		call	TransData
		call	RecDataL
		call	SetStop
		movlw	0xff
		xorwf	I2C_PDATA,w
		movwf	InRegs+0

		incf	IO_Phase,f
		return
;-------	2. I8O8 Olvasás
IO_Proc_1	call	SetStart
		movlw	0x13
		movwf	I2C_W
		call	TransData
		call	RecDataL
		call	SetStop
		movlw	0xff
		xorwf	I2C_PDATA,w
		movwf	InRegs+1

		incf	IO_Phase,f
		return
;-------	1. I8O8 Írás
IO_Proc_2
		call	SetStart
		movlw	0x10
		movwf	I2C_W
		call	TransData
		movff	OutRegs,I2C_W
		call	TransData
		call	SetStop

		incf	IO_Phase,f
		return
;-------	2. I8O8 Írás
IO_Proc_3
		call	SetStart
		movlw	0x12
		movwf	I2C_W
		call	TransData
		movff	OutRegs+1,I2C_W
		call	TransData
		call	SetStop

		incf	IO_Phase,f
		return
	