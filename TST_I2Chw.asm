;+------------------------------------------------------------------+
;|     Init_i2cs                                                    |
;|                                                                  |
;+------------------------------------------------------------------+
Init_I2Chw
		movlw	0xf0
		movwf	I2C_ADDR
		bsf	I2C_SDA_TRIS
		bsf	I2C_SCL_TRIS

		clrf    SSPSTAT             ; Disable SMBus inputs
		movlw 	INIT_SSPSTAT
		movwf	SSPSTAT

		movlw   INIT_SSPADD
		movwf   SSPADD              ; Setup 100 kHz I2C clock

		movlw   INIT_SSPCON1
		movwf   SSPCON1             ; Enable SSP, select I2C Master mode
		clrf    SSPCON2             ; Clear control bits
		bcf     PIR1,SSPIF          ; Clear SSP interrupt flag
		bcf     PIR2,BCLIF          ; Clear Bit Collision flag

		return
;+------------------------------------------------------------------+
;|     SetStart : Start bit subroutine                                |
;|          This routine generates a Start condition                |
;|          (high-to-low transition of SDA while SCL                |
;|          is still high.                                          |
;+------------------------------------------------------------------+
SetStart
		bcf     PIR1,SSPIF          ; Clear SSP interrupt flag
		bsf     SSPCON2,SEN         ; Generate Start condition
SetStart_Wait
		btfss   PIR1,SSPIF          ; Check if operation completed
		bra     SetStart_Wait         ; If not, keep checking

		return

;+------------------------------------------------------------------+
;|     SetReStart : ReStart bit subroutine                          |
;|          This routine generates a Repeated Start                 |
;|          condition (high-to-low transition of SDA                |
;|          while SCL is still high.                                |
;+------------------------------------------------------------------+
SetReStart
		bcf     PIR1,SSPIF          ; Clear SSP interrupt flag
		bsf     SSPCON2,RSEN        ; Generate Restart condition
SetReStart_Wait
		btfss   PIR1,SSPIF          ; Check if operation completed
		bra     SetReStart_Wait     ; If not, keep checking

		return
;+------------------------------------------------------------------+
;|     SetStop : Stop bit subroutine                                |
;|          This routine generates a Stop condition                 |
;|          (low-to-high transition of SDA while SCL                |
;|          is still high.                                          |
;+------------------------------------------------------------------+
SetStop
		bcf     PIR1,SSPIF          ; Clear SSP interrupt flag
		bsf     SSPCON2,PEN         ; Generate Stop condition
SetStop_Wait
		btfss   PIR1,SSPIF          ; Check if operation completed
		bra     SetStop_Wait          ; If not, keep checking

		return
;+------------------------------------------------------------------+
;|     TransData: Data transmit subroutine                          |
;+------------------------------------------------------------------+
TransData
		bcf     PIR1,SSPIF          ; Clear SSP interrupt flag
		movff   I2C_W,SSPBUF        ; Write byte out to device 
TransData_Wait
		btfss   PIR1,SSPIF          ; Check if operation completed
		bra     TransData_Wait      ; If not, keep checking
;		btfsc   SSPCON2,ACKSTAT     ; Check if ACK bit was received
;		bra     ackfailed           ; This executes if no ACK received    
		return

;+------------------------------------------------------------------+
;|     RecDataL: Data receive subroutine                             |
;+------------------------------------------------------------------+
RecDataL
		bsf     SSPCON2,ACKDT       ; Select to send ACK bit
		bra	RecData_1
;+------------------------------------------------------------------+
;|     RecData: Data receive subroutine                             |
;+------------------------------------------------------------------+
RecData
		bcf     SSPCON2,ACKDT       ; Select to send ACK bit
RecData_1
		bcf     PIR1,SSPIF          ; Clear SSP interrupt flag
		bsf     SSPCON2,RCEN        ; Initiate reception of byte
RecData_Wait
		btfss   PIR1,SSPIF          ; Check if operation completed
		bra     RecData_Wait        ; If not, keep checking
		movff   SSPBUF,I2C_PDATA    ; Copy byte to I2C_PDATA
		bcf     PIR1,SSPIF          ; Clear SSP interrupt flag
		bsf     SSPCON2,ACKEN       ; Generate ACK/NO ACK bit    
RecData_Wait2
		btfss   PIR1,SSPIF          ; Check if operation completed
		bra     RecData_Wait2       ; If not, keep checking

		return

	

