		array	MotParams,6,2
 
#define		COMMOT_SETSTOPRN	0x01
#define		COMMOT_SETSTOP		0x02
#define		COMMOT_SETGO		0x04
#define		COMMOT_SETHOME		0x10
#define		COMMOT_SETMPOS		0x20
#define		COMMOT_SETMOT		0x40
#define		COMMOT_SETBEGEND	0x08

#define	SetMaxCom_UP	1<<0	
#define	SetMaxCom_DW	1<<1
#define	SetMaxCom_PUP	1<<2
#define	SetMaxCom_PDW	1<<3

		byte	MotMoveCom,0
		byte	MotMoveSpeed,0

#define		MOT_X_DW	MotMoveCom,0
#define		MOT_X_UP	MotMoveCom,1
#define		MOT_Y_DW	MotMoveCom,2
#define		MOT_Y_UP	MotMoveCom,3
#define		MOT_Z_DW	MotMoveCom,4
#define		MOT_Z_UP	MotMoveCom,5
#define		MOT_W_DW	MotMoveCom,6
#define		MOT_W_UP	MotMoveCom,7
#define		MOT_UP		0
#define		MOT_DW		1


#define		MOTOR_BUSY	0	
#define		MOTOR_POS	1	;Törölhetõ lesz belõle
#define		MOTOR_PERR	2	;Pozició error
#define		MOTOR_BEG	3	;Végállás hiba
#define		MOTOR_END	4	;Végállás hiba
#define		ENC_ERROR	5	;Volt encoder lekérdezési hiba
#define		ENC_SYNC	6	;Szinkronban van az encoder

#define		MOTOR_NOTPOS	0	;Nincs Pozicióban a motor

		byte	Mot_Status,0
#define		B_Mot_PosX	Mot_Status,0
#define		B_Mot_PosY	Mot_Status,1
#define		B_Mot_PosZ	Mot_Status,2
#define		B_Mot_PosW	Mot_Status,3

#define		B_MotCom_New	Mot_Status,7
