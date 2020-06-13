	byte	ComProc_DataNum,0
	byte	ComProc_Addr,0
	byte	ComProc_Command,0
	byte	ComProc_SADDR,0
	byte	ComProc_ID,0
	byte	SIO_Rc_pRDTmp,0
	byte	ComProc_Timer,0
	byte	ComProc_Phase,0
	byte	I2C_PerAddr,0

#define         COM_StatClr             '0'
#define         COM_RdFrom              '1'      
#define         COM_WrTo                '2'     
#define         COM_SWReset             '3'

#define         COM_GetAddr             'O'	;ez a két parancs u.a
#define         COM_SetAddr             'A'	;ez a két parancs u.a, a kompatibilitás miatt van igy.
#define         Com_SetBR               'B'
#define         Com_GetConfig	        'c'

#define         Com_SetOut              'O'
#define         Com_SetQual             'Q'
#define         Com_GetStatus	        's'
#define         Com_GetStatus2	        'q'
#define         Com_SetMotor            'M'
#define         Com_SetMotorPos         'P'	;A Pos-t beállítja a paraméterre
#define         Com_SetHomePos          'H'
#define        	Com_SetMotorStop	'T'
#define        	Com_SetMotorStopRN	'N'
#define        	Com_SetReset		'R'

#define        	Com_SetVilagitas1	'V'
#define         Com_SetMotorBeg         'F'
#define         Com_SetMotorEnd         'G'

#define         Com_Semafor		','

#define         Com_FiokNyit		'X'


