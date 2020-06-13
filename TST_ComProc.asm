;+------------------------------------------------------------------+
;|     Init_ComProc                                                 |
;+------------------------------------------------------------------+
;|     rontott regiszterek :                                        |
;+------------------------------------------------------------------+
;|     funkcio: A parancsfeldolgozo inicializalasa                  |
;|              ComProc_Phase=0                                     |
;+------------------------------------------------------------------+

Init_Command_Proc
		clrf	ComProc_Phase
		return

;+------------------------------------------------------------------+
;|     ComProc                                                      |
;+------------------------------------------------------------------+
;|     rontott regiszterek :                                        |
;+------------------------------------------------------------------+
;|     funkcio:                                                     |
;|                                                                  |
;+------------------------------------------------------------------+
Command_Proc
            	btfsc	RCBUF_EMPTY		;Rx_Buf-ban van valami?
		return				;Nincs
;----
		call	Rc_Buf_GetLength	
		movwf	ComProc_DataNum		;A hosszt elmentettük	

		call	Rc_Buf_Rd		;A Forrás címét elmentjük
		movwf	ComProc_SADDR

		call	Rc_Buf_Rd		;Az ID-t elmentjük
		movwf	ComProc_ID

		call	Rc_Buf_Rd
		movwf	ComProc_Command		;A parancsot elmentjük

		Skip_JPClose
		goto	ComProc_1

		movlw	COM_GetAddr
		xorwf	i,w
		snz
		goto	COM_GetAddr_fun

;		movlw	Com_SetBR
;		xorwf	i,w
;		snz
;		goto	Com_SetBR_fun
ComProc_1
 		movlw	COM_SetAddr
		xorwf	i,w
		snz
		goto	COM_GetAddr_fun

		movlw	COM_SWReset
		xorwf	ComProc_Command,w
		snz
		goto	COM_SWReset_Fun

		movlw	COM_RdFrom
		xorwf	ComProc_Command,w
		snz
		goto	COM_RdFrom_Fun

		movlw	COM_WrTo
		xorwf	ComProc_Command,w
		snz
		goto	COM_WrTo_Fun

		movlw	Com_SetOut
		xorwf	i,w
		snz
		goto	Com_SetOut_fun

		movlw	Com_SetReset
		xorwf	i,w
		snz
		goto	Com_SetReset_fun

		movlw	Com_GetConfig		
		xorwf	i,w
		snz
		goto	Com_GetConfig_fun

		movlw	Com_GetStatus
		xorwf	i,w
		snz
		goto	Com_GetStatus_fun

		movlw	Com_GetStatus2
		xorwf	i,w
		snz
		goto	Com_GetStatus2_fun

		movlw	Com_SetQual
		xorwf	i,w
		snz
		goto	Com_SetQual_fun

		movlw	Com_Semafor
		xorwf	i,w
		snz
		goto	Com_Semafor_fun

ComProc_End	call	Rc_Buf_NextBlock
		return
;==============
COM_SWReset_Fun
		reset
;==============
COM_RdFrom_Fun
		movlw	7			;Megvannak a paraméterek?
		cpfseq	ComProc_DataNum
		goto	ComProc_End		;Nincsenek, Nem foglalkozunk vele tovább

		call	Rc_Buf_Rd		;A cimbyte H,
		movwf	FSR1H
		call	Rc_Buf_Rd		;A cimbyte L,
		movwf	FSR1L
		call	Rc_Buf_Rd		;Darabszám
		movwf	ComProc_DataNum		;A ennyi adatot kérnek
		addlw	4	
		call	Tx_Buf_Wr		;A hosszt belerakjuk a kiviendõ pufferba

		movf	ComProc_SADDR,w
		call	Tx_Buf_Wr		;A target cimet belerakjuk a pufferba

		movf	ComProc_ID,w
		call	Tx_Buf_Wr		;Az ID-t belerakjuk a pufferba

		movf	ComProc_Command,w		
		call	Tx_Buf_Wr		;A parancs azonosítót belerakjuk a pufferba

COM_RdFrom_Fun_1
		movf	INDF1,w
		call	Tx_Buf_Wr		;Elküldjük
		incf	FSR1L,f
		snz
		incf	FSR1H,f
		decfsz	ComProc_DataNum,f
		goto	COM_RdFrom_Fun_1

		bsf	TX_WAIT_ENABLE
		goto	ComProc_End		;Vége
		
;==============
COM_WrTo_Fun
		movlw	6			;Megvannak a paraméterek?
		cpfsgt	ComProc_DataNum		;>6?
		goto	ComProc_End		;Nincsenek, Nem foglalkozunk vele tovább
;--------------
		call	Rc_Buf_Rd
		movwf	FSR1H
		call	Rc_Buf_Rd
		movwf	FSR1L
;--------------
		movlw	-6			;Az adatok hosszát számoljuk
		addwf	ComProc_DataNum,f	;
		movlw	0x3f
		andwf	ComProc_DataNum,f	;64-nél hosszabb nem lehet!!
		snz
		bsf	ComProc_DataNum,6
;--------------
		movlw	5	
		call	Tx_Buf_Wr		;A hosszt belerakjuk a kiviendõ pufferba

		movf	ComProc_SADDR,w
		call	Tx_Buf_Wr		;A target cimet belerakjuk a pufferba

		movf	ComProc_ID,w
		call	Tx_Buf_Wr		;Az ID-t belerakjuk a pufferba

		movf	ComProc_Command,w		
		call	Tx_Buf_Wr		;A parancs azonosítót belerakjuk a pufferba
;----
COM_WrTo_Fun_1
		call	Rc_Buf_Rd
		movwf	INDF1
		incf	FSR1L,f
		snz
		incf	FSR1H,f

		decfsz	ComProc_DataNum,f	;Az utólsó adatot írtuk?
		goto	COM_WrTo_Fun_1		;Nem
						;Igen

		movlw	0x0			;Status küldés
		call	Tx_Buf_Wr
		bsf	TX_WAIT_ENABLE
		goto	ComProc_End		;Vége


;==============
Com_SetOut_fun
		movlw	4+3			;Megvannak a paraméterek?
		cpfseq	ComProc_DataNum
		goto	ComProc_End		;Nincsenek, Nem foglalkozunk vele tovább
	
		call	Rc_Buf_Rd		;
		movwf	Out8Reg
		call	Rc_Buf_Rd		;
		movwf	OutRegs+0
		call	Rc_Buf_Rd		;
		movwf	OutRegs+1

		
		goto	ComProc_End		;Nincsenek, Nem foglalkozunk vele tovább
;==============
Com_SetQual_fun
		movlw	5			;Megvannak a paraméterek?
		cpfseq	ComProc_DataNum
		goto	ComProc_End		;Nincsenek, Nem foglalkozunk vele tovább
	
;		call	Rc_Buf_Rd		;
;		movwf	i
;		movwf	PLC_Out8Reg
		
;		bcf	QUAL_OK			
;		bcf	QUAL_NOK		
;		btfsc	i,0			;
;		bsf	QUAL_OK			
;		btfss	i,0			;
;		bsf	QUAL_NOK			
		
;		movlw	100			;
;		movwf	Qual_Timer		;100*20msec=2sec
;		bcf	Van_Munkadarab	
;		bcf	FoikRogzites		;??????akkor a fiókot elengedjük
		goto	ComProc_End		;Vége
		
;==============
COM_GetAddr_fun
		movlw	6			;Megvannak a paraméterek?
		cpfseq	ComProc_DataNum
		goto	ComProc_End		;Nincsenek, Nem foglalkozunk vele tovább

		call	Rc_Buf_Rd		;
		movwf	j
		call	Rc_Buf_Rd		;
		xorwf	j,w			;A kettõ paraméter megegyezik?
		sz
		goto	COM_GetAddr_fun_1

		movlw	0xff
		xorwf	SIO_TAddr,w
		sz
		goto	COM_GetAddr_fun_1

		movff	j,SIO_TAddr
                movff	j,i
		movlw	0
		call	EEPROM_Write 

COM_GetAddr_fun_1
		movlw	4
		call	Tx_Buf_Wr		;A hosszt belerakjuk a kiviendõ pufferba

		movf	ComProc_SADDR,w
		call	Tx_Buf_Wr		;A target cimet belerakjuk a pufferba

		movf	ComProc_Command,w		
		call	Tx_Buf_Wr		;A parancs azonosítót belerakjuk a pufferba

		movf	SIO_TAddr,w
		call	Tx_Buf_Wr		;Elküldjük
		bsf	TX_WAIT_ENABLE

		goto	ComProc_End		;Vége	

;==============
Com_GetConfig_fun
		movlw	4			;Megvannak a paraméterek?
		cpfseq	ComProc_DataNum
		goto	ComProc_End		;Nincsenek, Nem foglalkozunk vele tovább

		movlw	4*1+15			;1*H+1*SAddr+1*ID+1*C+
		call	Tx_Buf_Wr		;A hosszt belerakjuk a kiviendõ pufferba
		movf	ComProc_SADDR,w
		call	Tx_Buf_Wr		;A target cimet belerakjuk a pufferba
		movf	ComProc_ID,w
		call	Tx_Buf_Wr		;Az ID-t belerakjuk a pufferba
		movf	ComProc_Command,w		
		call	Tx_Buf_Wr		;A parancs azonosítót belerakjuk a pufferba
;----

		movlw	STATE_LEN		; 1: State hossza
		call	Tx_Buf_Wr		;
		movlw	MOTORCTRL_LEN		; 2: MotorCTRL byte hossza, ha >1, akkor van sebesség érték is!
		call	Tx_Buf_Wr		;
		movlw	SYSTEM_ACKSTATUS_NUM	; 3: ACK hossza
		call	Tx_Buf_Wr		;
		movlw	SYSTEM_SSTATUS_NUM	; 4: Status hossza
		call	Tx_Buf_Wr		;
		movlw	INPUTS_BYTE_NUM		; 5: Inputok darabszáma
		call	Tx_Buf_Wr		;
		movlw	OUTPUTS_BYTE_NUM	; 6: Outputok darabszáma
		call	Tx_Buf_Wr		;
		movlw	LIGHT_NUM		; 7: Világítás darabszáma
		call	Tx_Buf_Wr		;
		movlw	MOTOR_NUM		; 8: Motorok száma
		call	Tx_Buf_Wr		;
		movlw	MOTORSTATUS_LEN		; 9: Motor Status byteszám
		call	Tx_Buf_Wr		;
		movlw	MOTORINPUTS_LEN		;10: Motor inputok darabszáma
		call	Tx_Buf_Wr		;
		movlw	MOTOROUTPUTS_LEN	;11: Motor outputok darabszáma
		call	Tx_Buf_Wr		;
		movlw	MOTORENC_LEN		;12: Encoder byte száma
		call	Tx_Buf_Wr		;
		movlw	MOTORPOS_LEN		;13: MotorPos byte száma
		call	Tx_Buf_Wr		;
		movlw	ANALOG_LEN		;14: Analóg csatornák száma
		call	Tx_Buf_Wr		;
		movlw	ANALOGBITS_LEN		;15: Egy csatornán levõ adat bitszáma
		call	Tx_Buf_Wr		;

		bsf	TX_WAIT_ENABLE
		goto	ComProc_End		;Vége	

;==============
Com_GetStatus2_fun
		movlw	4			;Megvannak a paraméterek?
		xorwf	ComProc_DataNum,w
		bz	Com_GetStatus2_fun1	;
Com_GetStatus_fun
	if 	MOTORCTRL_LEN==0
		movlw	4+STATE_LEN+SYSTEM_ACKSTATUS_NUM			;Megvannak a paraméterek?
	else
		movlw	4+STATE_LEN+MOTORCTRL_LEN+1+SYSTEM_ACKSTATUS_NUM			;Megvannak a paraméterek?
	endif
		cpfseq	ComProc_DataNum
		goto	ComProc_End		;Nincsenek, Nem foglalkozunk vele tovább
Com_GetStatus2_fun1		
		movlw	4+STATE_LEN+SYSTEM_ACKSTATUS_NUM+SYSTEM_SSTATUS_NUM+INPUTS_BYTE_NUM+OUTPUTS_BYTE_NUM+MOTOR_NUM*MOTOR_BYTE_NUM+LIGHT_NUM
		call	Tx_Buf_Wr		;A hosszt belerakjuk a kiviendõ pufferba

		movf	ComProc_SADDR,w
		call	Tx_Buf_Wr		;A target cimet belerakjuk a pufferba

		movf	ComProc_ID,w
		call	Tx_Buf_Wr		;Az ID-t belerakjuk a pufferba

		movf	ComProc_Command,w		
		call	Tx_Buf_Wr		;A parancs azonosítót belerakjuk a pufferba

;--------------	Ack-t végre kéne hajtani
	if	SYSTEM_ACKSTATUS_NUM>0
		movlw	Com_GetStatus2
		xorwf	ComProc_Command,w
		bz	Com_GetStatus_fun_SetAckSt_End	;Ha a Status2-es volt, akkor nincs ilyen

		movlw	SYSTEM_ACKSTATUS_NUM+1		;Azért, mert rögtön decrement van!
		movwf	k
		lfsr	FSR1,System_AckStatus
Com_GetStatus_fun_SetAckStatus
		decf	k,f
		bz	Com_GetStatus_fun_SetAckSt_End
		call	Rc_Buf_Rd		;
		xorlw	0xff
		andwf	POSTINC1,f		;Visszatöröljük, ami kell
		bra	Com_GetStatus_fun_SetAckStatus
Com_GetStatus_fun_SetAckSt_End
	endif
;-------------- System_AckStatus: 2 byte
	if	SYSTEM_ACKSTATUS_NUM>0
		movlw	SYSTEM_ACKSTATUS_NUM+1	;Azért, mert rögtön decrement van!
		movwf	k
		lfsr	FSR1,System_AckStatus
Com_GetStatus_fun_AckStatus
		decf	k,f
		bz	Com_GetStatus_fun_AckStatus_End
		movf	POSTINC1,w
		call	Tx_Buf_Wr		;
		bra	Com_GetStatus_fun_AckStatus
Com_GetStatus_fun_AckStatus_End
	endif
;-------------- State végrehajtása
	if	STATE_LEN==1
		movlw	Com_GetStatus2
		xorwf	ComProc_Command,w
		bz	Com_GetStatus_fun_StateEnd

		call	Rc_Buf_Rd		;
		movwf	System_State
		movwf	ComBits
		movlw	0xf
		andwf	System_State,f		;Csak az alsó négy bit jön 
		movlw	0xf0
		andwf	ComBits,f,1		;Csak a felsõ négy bit jön;
Com_GetStatus_fun_StateEnd
		movlw	0x0f
		andwf	System_State,w		;Csak az alsó négy bit
		movwf	i
		movlw	0xf0
		andwf	ComBits,w
		iorwf	i,f
		movf	i,w
		call	Tx_Buf_Wr				

	else
		error	 "A State az csak 1 byte lehet!!!"
	endif
;-------------- System_SStatus: 4 byte
	if	SYSTEM_SSTATUS_NUM>0
		movlw	SYSTEM_SSTATUS_NUM+1	;Azért, mert rögtön decrement van!
		movwf	k
		lfsr	FSR1,System_SStatus
Com_GetStatus_fun_SStatus
		decf	k,f
		bz	Com_GetStatus_fun_SStatus_End
		movf	POSTINC1,w
		call	Tx_Buf_Wr		;
		bra	Com_GetStatus_fun_SStatus
Com_GetStatus_fun_SStatus_End
	endif
;-------------- Motor mozgatás, ha kell
	if	MOTORCTRL_LEN>0
		movlw	Com_GetStatus2
		xorwf	ComProc_Command,w
		bz	Com_GetStatus_fun_MotGoEnd

		call	Rc_Buf_Rd		;
		movwf	MotMoveCom		;Melyik motorral kell lépni
		call	Rc_Buf_Rd		;
		movwf	MotMoveSpeed		;Milyen sebességgel

		btfsc	MotMoveSpeed,1		;Csak 0,1,2 lehet, a 3-as sebesség meg van tiltva!!!!
		bcf	MotMoveSpeed,0

		bsf	B_MotCom_New		;Új motor parancs jött
Com_GetStatus_fun_MotGoEnd
	endif
;-------------- Inputok: 2 byte
	if	INPUTS_BYTE_NUM>0
		movlw	INPUTS_BYTE_NUM+1	;Azért, mert rögtön decrement van!
		movwf	k
		lfsr	FSR1,In8Reg
Com_GetStatus_fun_Inputs
		decf	k,f
		bz	Com_GetStatus_fun_Inputs_End
		movf	POSTINC1,w
		call	Tx_Buf_Wr		;
		bra	Com_GetStatus_fun_Inputs
Com_GetStatus_fun_Inputs_End
	endif
;-------------- Outputok: 2 byte
	if	OUTPUTS_BYTE_NUM
		movlw	OUTPUTS_BYTE_NUM+1	;Azért, mert rögtön decrement van!
		movwf	k
		lfsr	FSR1,Out8Reg
Com_GetStatus_fun_Outputs
		decf	k,f
		bz	Com_GetStatus_fun_Outputs_End
		movf	POSTINC1,w
		call	Tx_Buf_Wr		;
		bra	Com_GetStatus_fun_Outputs
Com_GetStatus_fun_Outputs_End
	endif
;-------------- Világítás: 2 byte
	if	LIGHT_NUM>0
		movlw	LIGHT_NUM+1		;Azért, mert rögtön decrement van!
		movwf	k
		lfsr	FSR1,LightRegs
Com_GetStatus_fun_Light
		decf	k,f
		bz	Com_GetStatus_fun_Light_End
		movf	POSTINC1,w
		call	Tx_Buf_Wr		;
		bra	Com_GetStatus_fun_Light
Com_GetStatus_fun_Light_End
	endif
;-------------- Motor és encoder: 4*(1+1+2+3+3)=4*10=40 byte
	if	MOTOR_NUM>0
		movlw	MOTOR_NUM*MOTOR_BYTE_NUM
		movwf	k
		lfsr	FSR1,MotorPos
Com_GetStatus_fun_MotorCikl
		movf	POSTINC1,w
		call	Tx_Buf_Wr		;
		decfsz	k
		bra	Com_GetStatus_fun_MotorCikl
	endif
;-------------- Analog: 0 byte
	if	ANALOG_LEN>0
		movlw	ANALOG_LEN+1		;Azért, mert rögtön decrement van!
		movwf	k
		lfsr	FSR1,
Com_GetStatus_fun_Analog
		decf	k,f
		bz	Com_GetStatus_fun_Analog_End
		movf	POSTINC1,w
		call	Tx_Buf_Wr		;
		bra	Com_GetStatus_fun_Analog
Com_GetStatus_fun_Analog_End
	endif
;--------------

;----						A nyomógombokat újra kell figyelni
		bcf	GombVeszStop
;		bcf	GombAuto
		bcf	GombStart
		bcf	GombStop
		bcf	GombHibaTorles
		bcf	Ajtok_Nyitva
;		bcf	Van_Munkadarab
;----

		movlw	COMM_TMO		;Felhúzzuk a COMM TimeOutját
		movwf	Comm_Timer,1

;----
		bsf	TX_WAIT_ENABLE

		goto	ComProc_End		;Vége
;==============
Com_SetReset_fun
		movlw	4			;Megvannak a paraméterek?
		cpfseq	ComProc_DataNum
		goto	ComProc_End		;Nincsenek, Nem foglalkozunk vele tovább

;----
		goto	ComProc_End		;Vége


;==============
Com_Semafor_fun
		movlw	6			;Megvannak a paraméterek?
		cpfseq	ComProc_DataNum
		goto	ComProc_End		;Nincsenek, Nem foglalkozunk vele tovább

		call	Rc_Buf_Rd		;
;		movff	WREG,PLC_Out8Reg
		call	Rc_Buf_Rd		;
;		iorwf	PLC_Out8Reg,f		;Csak ha mindkettõ 0, akkor villog
		
		goto	ComProc_End		;Akkor nem hajtjuk végre
