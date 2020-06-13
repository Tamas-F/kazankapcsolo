;================================================================
;		
;================================================================
		byte	Comm_Timer,0
#define		COMM_TMO		200

;================================================================
;================================================================
		byte	PLC_B0,0
;================================================================
		byte	ComBits,0

#define		AJTOHIBATILT	ComBits,5
#define		COMMHIBATILT	ComBits,6

;;;;#define		TEST


		;common regiszter
		word	l,0

		
		byte	PLC_Timer,0
		byte	PLC_Out8Reg,0
		byte	PLC_TstTimer,0

		byte	Kazan_Status,0
		byte	Kazan_Phase,0

		word	Futes_TIMO_Timer,0
		byte	Futes_TIMO_Timer_Counter,0

		byte	Villany_Timer,0
		byte	Villany_Phase,0
		byte	Villany_Status,0
		byte	Villany_Status1,0
		word	Villany_TIMO_Timer,0
		byte	Villany_TIMO_Timer_Counter,0
		byte	Villany_TC_Phase,0
		byte	Villany_TC_Status,0
		byte	Villany_TC_Timer,0
		byte	Villany_TC_Timer_State,0
			;0 = 0<X<6
			;1 = 6<X<15
			;2 = 15<X
		byte	Villany_TC_Counter,0
		byte	Villany_TC_OFF_Timer,0
		byte	Villany_TC_OFF_Phase,0

		byte	Idozito_Timer,0
		byte	Idozito_Phase,0
		byte	Idozito_Status,0

		byte	Gomb0_Phase,0
		byte	Gomb0_Status,0
		byte	Gomb0_Timer,0
		byte	Gomb0_Timer_b,0

		byte	Gomb1_Phase,0
		byte	Gomb1_Status,0
		byte	Gomb1_Timer,0
		byte	Gomb1_Timer_b,0

;		byte	Sziv_Status,0		;Szivattyu
;		word	Sziv_TIMO_Timer,0
;		word	Sziv_Figyel_Timer,0
;		byte	Sziv_TIMO_Timer_Counter,0
;		byte	Sziv_TC_Phase,0
;		byte	Sziv_TC_Timer,0
;		byte	Sziv_TC_Counter,0


#define		B_Gomb0_Press		Gomb0_Status,0
#define		B_Gomb0_PressL		Gomb0_Status,1
#define		B_Gomb0_Press10		Gomb0_Status,2
#define		B_Gomb1_Press		Gomb1_Status,0
#define		B_Gomb1_PressL		Gomb1_Status,1
#define		B_Gomb1_Press10		Gomb1_Status,2

#define		B_Kazan_BE		Kazan_Status,0  ;Kazánt bekapcsolták
#define		B_Kazan_KI		Kazan_Status,1  ;Kazánt kikapcsolták
#define		B_If_Cirko		Kazan_Status,2  ;A kazán bekapcsolása elõtt ment-e a cirko

#define		B_Sziv_TIMO_Lejart	Sziv_Status,0
#define		B_Sziv_TC_vege		Sziv_Statis,1

#define		VillanySW0		Villany_Status,0  ;a kapcsoló 0-ban van min. 1 sec
#define		VillanySW01		Villany_Status,1  ;a kapcsolót most kapcsolták át 1-be <1 sec
#define		VillanySW010		Villany_Status,2  ;a kapcsolót billentették 010
#define		VillanySW00		Villany_Status,3  ;a kapcsolót úgyhagyták
#define		VillanySW1		Villany_Status,4
#define		VillanySW10		Villany_Status,5
#define		VillanySW101		Villany_Status,6
#define		VillanySW11		Villany_Status,7

;#define		B_Villany_NO_TIMO	Villany_Status1,0  ;timer nem kapcsolhatja le a villanyt


#define		IdozitoSW0		Idozito_Status,0
#define		IdozitoSW01		Idozito_Status,1
#define		IdozitoSW010		Idozito_Status,2
#define		IdozitoSW00		Idozito_Status,3

#define		IdozitoSW1		Idozito_Status,4
#define		IdozitoSW10		Idozito_Status,5
#define		IdozitoSW101		Idozito_Status,6
#define		IdozitoSW11		Idozito_Status,7

;INIT_VILLANY_TIMER_3S	= 5*10*3	;3 sec

INIT_VILLANY_TIMER_1S	= 5*10		;1 sec
INIT_IDOZITO_TIMER_1S	= 5*10		;1 sec

	ifndef TEST
;---100 ms-enként
INIT_FUTES_TIMO_TIMER1 = 200
INIT_FUTES_TIMO_TIMER2 = 180		;60 min

INIT_VILLANY_TIMO_TIMER1 = 100		
INIT_VILLANY_TIMO_TIMER2 = 90		;15 min

INIT_VILLANY_TIMO_TIMER_KICSI = 30	;5 min

;INIT_SZIV_TIMO_TIMER1 = 180
;INIT_SZIV_TIMO_TIMER2 = 100		;30 min

;INIT_SZIV_FIGYEL_TIMER1 = 60
;INIT_SZIV_FIGYEL_TIMER2 = 100		;10 min	;
;---
	endif

INIT_SZIV_TC_TIMER_ON = 5		;100 ms
INIT_SZIV_TC_TIMER_OFF = 11		;220 ms
INIT_SZIV_TC_TIMER_OFF_L = 60		;1 sec

INIT_VILLANY_TC_TIMER_ON_L = 20
INIT_VILLANY_TC_TIMER_ON_M = 10
INIT_VILLANY_TC_TIMER_ON_S = 5
INIT_VILLANY_TC_TIMER_OFF_L = 33
INIT_VILLANY_TC_TIMER_OFF_M = 22
INIT_VILLANY_TC_TIMER_OFF_S = 11
INIT_VILLANY_TC_TIMER_OFF_LONG = 75
INIT_VILLANY_TC_OFF_TIMER_OFF = 145
INIT_VILLANY_TC_OFF_TIMER_ON = 5


MAX_VILLANY_TIMO_TIMER_COUNTER = 6
MAX_FUTES_TIMO_TIMER_COUNTER = 20
;MAX_SZIV_TIMO_TIMER_COUNTER = 10	;


INIT_IDOZITO_PLUSZ_FUTES = 2

GOMB_PRELL = 10		;10 ms
GOMB_L = 75		;1,5 sec

	ifdef TEST
;---TESZTELÉSRE 100 ms-enként
INIT_FUTES_TIMO_TIMER1 = 5
INIT_FUTES_TIMO_TIMER2 = 20		;10 sec

INIT_VILLANY_TIMO_TIMER1 = 10
INIT_VILLANY_TIMO_TIMER2 = 90		;90 sec

INIT_VILLANY_TIMO_TIMER_KICSI = 30	;30 sec

;INIT_SZIV_TIMO_TIMER1 = 5
;INIT_SZIV_TIMO_TIMER2 = 20		;10 sec

;INIT_SZIV_FIGYEL_TIMER1 = 5
;INIT_SZIV_FIGYEL_TIMER2 = 10		;5 sec
;---
	endif
;================================================================

#define		OUT_Villany		Out8Reg,0
#define		OUT_Keringeto		Out8Reg,1
#define		OUT_Radiator		Out8Reg,2
#define		OUT_Padlo		Out8Reg,3
;#define		OUT_Sziv		Out8Reg,4
;#define		OUT_Sziv_Jelzo		Out8Reg,5
#define		OUT_Villany_Jelzo	Out8Reg,6	;ha a gombot hosszan megnyomták
#define		OUT_Cirko		Out8Reg,7


#define		SET_VILLANY		bsf	OUT_Villany
#define		RST_VILLANY		bcf	OUT_Villany
#define		SET_KERINGETO		bsf	OUT_Keringeto
#define		RST_KERINGETO		bcf	OUT_Keringeto
#define		SET_RADIATOR		bsf	OUT_Radiator
#define		RST_RADIATOR		bcf	OUT_Radiator
#define		SET_PADLO		bsf	OUT_Padlo
#define		RST_PADLO		bcf	OUT_Padlo
;#define		SET_SZIV		bsf	OUT_Sziv
;#define		RST_SZIV		bcf	OUT_Sziv
;#define		SET_SZIV_JELZO		bsf	OUT_Sziv_Jelzo
;#define		RST_SZIV_JELZO		bcf	OUT_Sziv_Jelzo
#define		SET_VILLANY_JELZO	bsf	OUT_Villany_Jelzo
#define		RST_VILLANY_JELZO	bcf	OUT_Villany_Jelzo
#define		SET_CIRKO		bsf	OUT_Cirko
#define		RST_CIRKO		bcf	OUT_Cirko

#define		Next_Villany		btfsc	OUT_Villany
#define		Skip_Villany		btfss	OUT_Villany

#define		Next_Cirko		btfsc	OUT_Cirko
#define		Skip_Cirko		btfss	OUT_Cirko

;#define		Next_Sziv		btfsc	OUT_Sziv
;#define		Skip_Sziv		btfss	OUT_Sziv
;=========================================================================
;=========================================================================
;#define		IN_Sziv_Motor		In8Reg,0
#define		IN_SWVillany		In8Reg,1
#define		IN_SWRadiator		In8Reg,2
#define		IN_SWPadlo		In8Reg,3
#define		IN_Kazan		In8Reg,4
#define		IN_Gomb1		In8Reg,5  ;szivattyu idozito
#define		IN_Gomb0		In8Reg,6  ;Villany idõzítésének beállítása (kazánházból)
#define		IN_Idozito		In8Reg,7


#define		Next_SWVillany		btfsc	IN_SWVillany
#define		Skip_SWVillany		btfss	IN_SWVillany
#define		Next_SWPadlo		btfsc	IN_SWPadlo
#define		Skip_SWPadlo		btfss	IN_SWPadlo
#define		Next_SWRadiator		btfsc	IN_SWRadiator
#define		Skip_SWRadiator		btfss	IN_SWRadiator
#define		Next_Idozito		btfsc	IN_Idozito
#define		Skip_Idozito		btfss	IN_Idozito

#define		Next_Gomb0		btfsc	IN_Gomb0
#define		Skip_Gomb0		btfss	IN_Gomb0
#define		Next_Gomb1		btfsc	IN_Gomb1
#define		Skip_Gomb1		btfss	IN_Gomb1

#define		Next_Kazan		btfsc	IN_Kazan
#define		Skip_Kazan		btfss	IN_Kazan

;#define		Next_Sziv_Motor		btfsc	IN_Sziv_Motor
;#define		Skip_Sziv_Motor		btfss	IN_Sziv_Motor








