
;+------------------------------------------------------------------+
;|     EEPROM_Read                                                  |
;+------------------------------------------------------------------+
;|     rontott regiszterek :   w                                    |
;+------------------------------------------------------------------+
;|     funkcio:  Az EEPROM w-ik címérõl olvas egy bytetot a w-be    |
;|                                                                  |
;+------------------------------------------------------------------+
EEPROM_Read	
		movwf	EEADR
		bcf	EECON1,EEPGD
		bcf	EECON1,CFGS
		bsf	EECON1,RD
		movf	EEDATA,w
		return

;+------------------------------------------------------------------+
;|     EEPROM_Write                                                 |
;+------------------------------------------------------------------+
;|     rontott regiszterek :   w                                    |
;+------------------------------------------------------------------+
;|     funkcio:  Az EEPROM w-ik címére beírja az i-t                |
;|                                                                  |
;+------------------------------------------------------------------+
EEPROM_Write
		bcf	PIE2,EEIP
		bcf	IPR2,EEIP

		bcf    	INTCON,GIEH	;High IT Enable	
		bcf    	INTCON,GIEL	;low IT Enable	
EEPROM_Write_1
		btfsc	EECON1,WR
		goto	EEPROM_Write_1

		movwf	EEADR
		movf	i,w
		movwf	EEDATA
		bcf	EECON1,EEPGD
		bcf	EECON1,CFGS
		bsf	EECON1,WREN

		movlw	0x55
		movwf	EECON2
		movlw	0xaa
		movwf	EECON2
		bsf	EECON1,WR
		nop
EEPROM_Write_2
		btfsc	EECON1,WR
		goto	EEPROM_Write_2

		bcf	EECON1,WREN

		bsf    	INTCON,GIEH	;High IT Enable	
		bsf    	INTCON,GIEL	;low IT Enable	

		return
;-------------
EEPROM_Wait
		btfsc	EECON1,WR
		goto	EEPROM_Wait
		return
;+------------------------------------------------------------------+
;|     FLASH_Read                                                   |
;+------------------------------------------------------------------+
;|     rontott regiszterek :   i,w                                  |
;+------------------------------------------------------------------+
;|     funkcio:  A FLASH (i,w) címérõl kilvassa az adatot a (i,w)-be|
;|                       (H,L)                              (H,L)   |
;+------------------------------------------------------------------+
FLASH_Read
		movwf	TBLPTRL
		movf	i,w
		movwf	TBLPTRH
		clrf	TBLPTRU
		TBLRD*
		movf	TABLAT,w
		return
;+------------------------------------------------------------------+
;|     FLASH_Read                                                   |
;+------------------------------------------------------------------+
;|     rontott regiszterek :   i,w                                  |
;+------------------------------------------------------------------+
;|     funkcio:  A FLASH (w,i) címére beírja a (0,INDF)-t           |
;|                       (H,L)                 (H,L)                |
;|               4 byte-ot ír!!! a w:xxxxxx00-tól xxxxxx11-ig       |
;+------------------------------------------------------------------+

FLASH_Write

		return



