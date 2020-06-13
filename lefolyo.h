		byte	LefolyoSW_Timer,2		;1ms-enkét
		byte	LefolyoSW_Phase,2

		array	Lefolyo_Timer,3,2
		byte	Lefolyo_Timer_sec,2
		byte	Lefolyo_Phase,2
		byte	Lefolyo_Status,0
		byte	Lefolyo_Timer_Phase,2


#define		IN_SWLefolyo		InRegs,1
#define		OUT_Lefolyo		OutRegs,1

;#define		IN_SWLefolyo		In8Reg,2
;#define		OUT_Lefolyo		Out8Reg,1


#define		SET_OUT_Lefolyo		bsf	OUT_Lefolyo
#define		CLR_OUT_Lefolyo		bcf	OUT_Lefolyo


#define		LefolyoSW_State		Lefolyo_Status,0  ;a kapcsoló állapota
#define		LefolyoSW01		Lefolyo_Status,1  ;a kapcsolót most kapcsolták át 1-be
#define		LefolyoSW10		Lefolyo_Status,2  ;a kapcsolót most kapcsolták át 0-ba
#define		Lefolyo_Timer_Kesz	Lefolyo_Status,3

INIT_LEFOLYOSW_PRELL_TIMER	= 5		;5 ms |1 ms|
INIT_LEFOLYO_TIMER_ON_0		= 0x00;sec	;BCD
INIT_LEFOLYO_TIMER_ON_1		= 0x03;min	;BCD
INIT_LEFOLYO_TIMER_ON_2		= 0x00;hour	;!NOT BCD!
INIT_LEFOLYO_TIMER_OFF_0	= 0x00;sec	;BCD
INIT_LEFOLYO_TIMER_OFF_1	= 0x00;min	;BCD
INIT_LEFOLYO_TIMER_OFF_2	= 0x04;hour	;!NOT BCD!








