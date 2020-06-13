;******************************************************************************
;*									      *
;*		PIC type	= PIC17F452				      *
;*		PIC clock	= 20 MHz				      *
;*		DATE		= 2004, 02.14.				      *
;*		MAKE BY		= (Frakk)				      *
;*									      *
;******************************************************************************
;
;
;-------------- Device data ---------------------------------------------------
;
;
		list	p=PIC18f4525, r=DEC
		include	"p18f4525.inc"
		include "ft_macro.asm"
;

;------------------------------------------------------------------------------
;-------------- REDSZER PARAMÉTEREK -------------------------------------------
;------------------------------------------------------------------------------
RAM_B0_BEG	=	0x0000		;Bank0 RAM inicializalasok kezdete
RAM_B0_END	=	0x0080		;Bank0 RAM inicializalasok vege
RAM_B1_BEG	=	0x0100		;Bank1 RAM inicializalasok kezdete
RAM_B1_END	=	0x01FF		;Bank1 RAM inicializalasok vege
RAM_B2_BEG	=	0x0200		;Bank2 RAM inicializalasok kezdete
RAM_B2_END	=	0x02FF		;Bank2 RAM inicializalasok vege
RAM_B3_BEG	=	0x0300		;Bank3 RAM inicializalasok kezdete
RAM_B3_END	=	0x03FF		;Bank3 RAM inicializalasok vege
RAM_B4_BEG	=	0x0400		;Bank4 RAM inicializalasok kezdete
RAM_B4_END	=	0x04FF		;Bank4 RAM inicializalasok vege
RAM_B5_BEG	=	0x0500		;Bank5 RAM inicializalasok kezdete
RAM_B5_END	=	0x05FF		;Bank5 RAM inicializalasok vege

        variable        _RAM_B0=RAM_B0_BEG
        variable        _RAM_B1=RAM_B1_BEG
        variable        _RAM_B2=RAM_B2_BEG
        variable        _RAM_B3=RAM_B3_BEG
        variable        _RAM_B4=RAM_B4_BEG
        variable        _RAM_B5=RAM_B5_BEG
;-----------------------------------------------
#define		INIT_SYSTEM_TIMER 	10
;******************************************************************************
;*                                                                            *
;*              CONFIGURATION WORD                                            *
;*                                                                            *
;******************************************************************************
;
;__config	_HS_OSC & _CP_OFF & _WDT_OFF & _PWRTE_OFF & _LVP_OFF & _DEBUG_ON
;
;******************************************************************************
;*                                                                            *
;*              RESET ADDRESS                                                 *
;*                                                                            *
;******************************************************************************
		org	0
		nop
		nop
		goto	start_reset

;******************************************************************************
;*                                                                            *
;*              IT ADDRESS                                                    *
;*                                                                            *
;******************************************************************************
;====================================================================
;=                                                                  =
;=              IT ROUTINES                                         =
;=                                                                  =
;====================================================================
		org	0x08		;Hight Priority Addr
		goto	Start_IT_H		
		org	0x18		;Low Priority Addr
;--------------
Start_IT_L	movff	WREG,SL_W
		movff	STATUS,SL_STATUS
		movff	BSR,SL_BSR
		movff	i,SL_i
		movff	i+1,SL_i+1
		movff	j,SL_j
		movff	j+1,SL_j+1
		movff	FSR0L,SL_FSR0L
		movff	FSR0H,SL_FSR0H
;-----
		call	SIO_IT	
;-----
		movff	SL_FSR0L,FSR0L
		movff	SL_FSR0H,FSR0H
		movff	SL_i+1,i+1
		movff	SL_i,i
		movff	SL_j+1,j+1
		movff	SL_j,j
		movff	SL_BSR,BSR
		movff	SL_W,WREG
		movff	SL_STATUS,STATUS
		retfie			;1->GIE !
;--------------
Start_IT_H
		movff	WREG,SH_W
		movff	STATUS,SH_STATUS
		movff	BSR,SH_BSR
;		movff	i+1,SH_i+1
;		movff	i,SH_i
;		movff	j+1,SH_j+1
;		movff	j,SH_j
;-----
		call	Tmr1_IT
;-----
;		movff	SH_j+1,j+1
;		movff	SH_j,j
;		movff	SH_i+1,i+1
;		movff	SH_i,i
		movff	SH_BSR,BSR
		movff	SH_W,WREG
		movff	SH_STATUS,STATUS
		retfie			;1->GIE !
;--------------
;
;******************************************************************************
;*                                                                            *
;*              VERZIO                                                        *
;*                                                                            *
;******************************************************************************
		dt	"V1.0 01.09.22"

;
;==============================================================================
	#define		dTRISx	0x12		;A TRISx-ek ennyivel vannak nagyobb cimen
						;mint a PORTx-ek
	#define		dLATx	0x09		;A LATx-ek ennyivel vannak nagyobb cimen
						;mint a PORTx-ek
	#include	"TST_PicConf.asm"

	#include	"ft_rut_452.asm"
;	#include	"ft_rut_m452.h"

	#include	"TST_Config.h"


;			org	_ROM_P0
;******************************************************************************
;*                                                                            *
;*              Általános regiszterek                                         *
;*                                                                            *
;******************************************************************************
;

;-------------- IT rutinhoz szukseges mentesi regiszterek
	byte	SH_STATUS,2
	byte	SH_W,2
	word	SH_i,2
	word	SH_j,2
	byte	SH_BSR,2
	byte	SH_FSR0L,2
	byte	SH_FSR0H,2

	byte	SL_STATUS,2
	byte	SL_W,2
	word	SL_i,2
	word	SL_j,2
	byte	SL_BSR,2
	byte	SL_FSR0L,2
	byte	SL_FSR0H,2
	byte	SL_PCLATH,2
	byte	SL_PCLATU,2
;--------------	common regiszters
	byte	System_Timer,0
	byte	System_Timer20,0
	byte	System_Timer100,0
	byte	System_Timer1000,0
	byte	System_Timer1min,0
	word	i,0			;common register
	word	j,0
	byte	k,0

;--------------	System regiszters

	array	System_AckStatus,SYSTEM_ACKSTATUS_NUM,0	;Az elsõ kettõ byte törölhetõ biteket tartalmaz
	array	System_SStatus,SYSTEM_SSTATUS_NUM,0	;Az elsõ kettõ byte törölhetõ biteket tartalmaz
					;a további 4 nem
;-------------- System_Status bitkiosztás


#define		Motor_PosX	System_AckStatus,0	;A motor beált a megadott pozicióba
#define		Motor_PosY	System_AckStatus,1	;A motor beált a megadott pozicióba
#define		Motor_PosZ	System_AckStatus,2	;A motor beált a megadott pozicióba
#define		Motor_PosW	System_AckStatus,3	;A motor beált a megadott pozicióba


#define		Comm_Hiba	System_AckStatus+1,7	;A kommunikáció megállt

#define		GombVeszStop	System_SStatus+0,0	;Vészstop meg lett nyomva
#define		GombAuto	System_SStatus+0,1	;Auto be van kapcsolva
#define		GombStart	System_SStatus+0,2	;Start meg lett nyomva
#define		GombStop	System_SStatus+0,3	;Stop meg lett nyomva
#define		GombHibaTorles	System_SStatus+0,4	;HibaTorles meg lett nyomva
#define		Ajtok_Nyitva	System_SStatus+0,5	;Ha valamelyik ajtó nyitva
#define		Van_Munkadarab	System_SStatus+0,6	;Van munkadarab

;--------------	System State 
	byte	System_State,0
;-------------- System_State bitkiosztás
STATE_Test		=	0xf
STATE_Stop		=	0x0
STATE_AjtoNyitva	=	0x1
STATE_Kulcs		=	0x2
STATE_Meres		=	0x3
STATE_Vesz		=	0x4
STATE_VeszNyugta	=	0x5
STATE_Atfuto		=	0x6
STATE_StopBeep		=	0x8


;******************************************************************************
;*                                                                            *
;*              #include-ok                                                   *
;*                                                                            *
;******************************************************************************
	#include	"TST_Timer.h"
	#include	"TST_LED.h"
	#include	"TST_JP.h"
	#include	"TST_Sio.h"
	#include	"TST_ComProc.h"
	#include	"TST_I2Chw.h"
	#include	"TST_PLC.h"
	#include	"TST_IO.h"
	#include	"csepego.h"
	#include	"locsolo.h"
	#include	"lefolyo.h"
	#include	"szivattyu.h"

;==============================================================================
;	#include	"ft_rut_m452.asm"
	#include	"TST_Timer.asm"
	#include	"TST_LED.asm"
	#include	"TST_JP.asm"
	#include	"TST_Sio.asm"
	#include	"TST_ComProc.asm"
	#include	"TST_IO.asm"
	#include	"ft_eep.asm"
	#include	"TST_I2Chw.asm"
	#include	"TST_PLC.asm"
	#include	"BCD.asm"
	#include	"csepego.asm"
	#include	"locsolo.asm"
	#include	"lefolyo.asm"
	#include	"szivattyu.asm"
;
;********************************************************************
;*                                                                  *
;*              START_RESET, INICIALIZALASOK                        *
;*                                                                  *
;********************************************************************

start_reset
;	
;+------------------------------------------------------------------+
;|     HW_Reset                                                     |
;+------------------------------------------------------------------+
;|     rontott regiszterek :                                        |
;+------------------------------------------------------------------+
;|     funkcio:	                                                    |
;|                                                                  |
;+------------------------------------------------------------------+
HW_Reset
;+------------------------------------------------------------------+
;|     SW_Reset                                                     |
;+------------------------------------------------------------------+
;|     rontott regiszterek :                                        |
;+------------------------------------------------------------------+
;|     funkcio:	Rendszer alapbeallitasok                            |
;|                                                                  |
;+------------------------------------------------------------------+
SW_Reset
		call	Init_RAMs	
;-------------- Taszkok inicializálása
		clrf	BSR
		movlw	0x0F
		movwf	ADCON1
		bcf	TRISA,4
		bcf	PORTA,4
		call 	wait_200ms
		bsf	TRISA,4

		call	Init_TMR1
		call	Init_LED0
		call	Init_LED1
		call	Init_JP

		call	Init_Out8
		call	Init_In8

		call	Init_SIO
		call	Init_Command_Proc
		call	Init_I2Chw

		call	Init_PLC
		
		call	Init_Kazan
		call	Init_Villany
		call	Init_Idozito
;		call	Init_Sziv
		call	Init_Villany_TIMO
		call	Init_Futes_TIMO
		call	Init_Gomb0
		call	Init_Gomb1

		call	Init_Csepego
		call	Init_Locsolo

		call	Init_Lefolyo
		call	Init_Szivattyu
		nop

		movlw	1
		movff	WREG,System_Timer
		movff	WREG,System_Timer20
		movff	WREG,System_Timer100
		movff	WREG,System_Timer1000
		movff	WREG,System_Timer1min

;--------------
		call 	wait_200ms

		movlw	100*LED0_INIT_TIMER1
                movwf   LED0_Timer+1,0
		movlw	30*LED1_INIT_TIMER1
                movwf   LED1_Timer+1,0

;-------------- Global IT engedélyezése
		bsf	RCON,7,0	;Enable Priority IT
		bsf    	INTCON,GIEH	;High IT Enable	
		bsf    	INTCON,GIEL	;low IT Enable	

;+------------------------------------------------------------------+
;|     MAIN LOOP                                                    |
;+------------------------------------------------------------------+
;|     rontott regiszterek :                                        |
;+------------------------------------------------------------------+
;|     funkcio:	                                                    |
;|                                                                  |
;+------------------------------------------------------------------+
main_loop	tstf	System_Timer,0
		snz
		goto	main_loop_1ms
main_loop_next		
		;--TEST
cikl

;		goto	cikl
		;--TEST END

		btfsc	TXSTA,TRMT		;A soros puffer kiürült?
		bcf	SIO_TX1EN		;Igen, tehát tiltjuk a 176-ost

		call	SIO_WaitTX_Proc
		call	Command_Proc
		call	IO_Proc
		
		goto	main_loop
;--------------
main_loop_1ms	movlw	INIT_SYSTEM_TIMER
		movwf	System_Timer,0

		TMR_DEC	System_Timer20
		snz
		goto	main_loop_20ms
main_loop_1ms_next
;----1ms-------
		TMR_DEC Gomb0_Timer
		TMR_DEC Gomb1_Timer
		TMR_DEC	LED0_Timer
		TMR_DEC	LED1_Timer

		call	Gomb0_Proc
		call	Gomb1_Proc
		call	LED0_Proc
		call	LED1_Proc
		call	LefolyoSW_Proc

		call	Out8
;----1ms-VÉGE--
		goto	main_loop_next
;--------------
main_loop_20ms
		movlw	20
		movwf	System_Timer20

		TMR_DEC	System_Timer100
		snz
		goto	main_loop_100ms

main_loop_20ms_next
;---20ms-------
		TMR_DEC	IO_Timer
		TMR_DEC	Villany_Timer
		TMR_DEC	Idozito_Timer
		TMR_DEC	Gomb0_Timer_b
		TMR_DEC	Gomb1_Timer_b
		
		call	In8

;
		call	Kazan_Proc
		call	PLC_Kazan_Proc
		call	PLC_Futes_Proc
		call	PLC_Villany_Proc
;		call	PLC_Sziv_Proc
		nop
		nop

		call	Villany_Proc
		call	Idozito_Proc
;		call	Sziv_TC_Proc
		nop
		nop
		call	Villany_TC_Proc
;---20ms-VÉGE--
;		btfsc	LTest
;		bra	main_loop_20ms_1	
;--------------
main_loop_20ms_1

		call	CommFigyel_Proc

		call	JP_Proc


		goto	main_loop_1ms_next

;--------------
main_loop_100ms
		movlw	5
		movwf	System_Timer100

		TMR_DEC	System_Timer1000
		snz
		goto	main_loop_1000ms

main_loop_100ms_next
;--100ms-------
		TMR_DEC		PLC_TstTimer

		TMR_DEC_FSR	Csepegogomb0_Timer
		TMR_DEC_FSR	Csepegogomb0_Timer_b

		TMR_DEC_FSR	Locsologomb0_Timer
		TMR_DEC_FSR	Locsologomb0_Timer_b


		call	Villany_TIMO_Proc
		call	Futes_TIMO_Proc
;		call	Sziv_TIMO_Proc

		call	Lefolyo_Proc

		call	Csepegogomb0_Proc
		nop
		call	CsepegoLED0_Proc
		nop
		call	Csepego1_Proc
		nop

		call	Locsologomb0_Proc
		nop
		call	LocsoloLED0_Proc
		nop
		call	Locsolo1_Proc
		nop
		
		call	Szivattyu_Proc
		nop
		nop
;--100ms-VÉGE--
		goto	main_loop_20ms_next
;--------------
main_loop_1000ms
		movlw	10
		movff	WREG, System_Timer1000

		TMR_DEC	System_Timer1min
		snz
		goto	main_loop_1min

main_loop_1000ms_next
;--1sec-------
		TMR_DEC_FSR	Locsolo1_Timer
		TMR_DEC_FSR	Sziv_Timer

		call	Csepego1_Proc_Timer
;--1sec-VÉGE--
		goto	main_loop_100ms_next
;--------------
main_loop_1min
		movlw	60
		movff	WREG, System_Timer1min

main_loop_1min_next
;--1min-------
;--1min-VÉGE--
		goto	main_loop_1000ms_next
;+------------------------------------------------------------------+

		org  0xF00000          		
		de	0xff

	if _RAM_B0>RAM_B0_END+1
		error	 "Az BANK0-ba szánt változók nem férnek el!!!!"
	endif
	if _RAM_B1>RAM_B1_END+1
		error	 "Az BANK1-ba szánt változók nem férnek el!!!!"
	endif
	if _RAM_B2>RAM_B2_END+1
		error	 "Az BANK2-ba szánt változók nem férnek el!!!!"
	endif
	if _RAM_B3>RAM_B3_END+1
		error	 "Az BANK3-ba szánt változók nem férnek el!!!!"
	endif
	if _RAM_B4>RAM_B4_END+1
		error	 "Az BANK4-ba szánt változók nem férnek el!!!!"
	endif
	if _RAM_B5>RAM_B5_END+1
		error	 "Az BANK5-ba szánt változók nem férnek el!!!!"
	endif

		END

 
