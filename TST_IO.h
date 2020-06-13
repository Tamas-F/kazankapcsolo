		array	InRegsTmp,INPUTS_BYTE_NUM+1,0	;Egymás után legyen!!!
		array	OutRegsTmp,OUTPUTS_BYTE_NUM+1,0	;Egymás után legyen!!!
In8Reg	=	InRegsTmp				;Egymás után legyen!!!Gyors bemenet, másképp kezelõdik
InRegs	=	InRegsTmp+1				;Egymás után legyen!!!I8O8 kártyákon
Out8Reg	=	OutRegsTmp				;Egymás után legyen!!!Gyors kimenet, másképp kezelõdik
OutRegs	=	OutRegsTmp+1				;Egymás után legyen!!!I8O8 kártyákon

		byte	IO_Phase,0
		byte	IO_Timer,0
		byte	IOMot_Phase,0
		byte	IOMot_Timer,0

		array	LightRegs,LIGHT_NUM+1,0
	if MOTOR_NUM*MOTOR_BYTE_NUM>0
		array	MotorPos,MOTOR_NUM*MOTOR_BYTE_NUM,2	
	endif
		
					;Byte0=Input
					;Byte1=Outpu vissza
					;Byte2=Motor Status
					;     Bit0=
					;     Bit1=
					;     Bit2=
					;     Bit3=
					;     Bit4=
					;     Bit5=
					;     Bit6=
					;     Bit7=
					;Byte3=Motor Status2
					;     Bit0=
					;     Bit1=
					;     Bit2=
					;     Bit3=
					;     Bit4=
					;     Bit5=
					;     Bit6=
					;     Bit7=
					;Byte4=Motor PosL
					;Byte5=Motor PosM
					;Byte6=Motor PosH
					;Byte7=Encoder PosL
					;Byte8=Encoder PosM
					;Byte9=Encoder PosH
#define		IN0	PORTE,1
#define		IN1	PORTE,0
#define		IN2	PORTE,2
#define		IN3	PORTC,0
#define		IN4	PORTC,1
#define		IN5	PORTC,2
#define		IN6	PORTB,0
#define		IN7	PORTB,1

#define		IN0_TRIS	PORTE+dTRISx,1
#define		IN1_TRIS	PORTE+dTRISx,0
#define		IN2_TRIS	PORTE+dTRISx,3
#define		IN3_TRIS	PORTC+dTRISx,0
#define		IN4_TRIS	PORTC+dTRISx,1
#define		IN5_TRIS	PORTC+dTRISx,2
#define		IN6_TRIS	PORTB+dTRISx,0
#define		IN7_TRIS	PORTB+dTRISx,1


#define		OUT0	PORTD,0
#define		OUT1	PORTD,1
#define		OUT2	PORTD,2
#define		OUT3	PORTD,3
#define		OUT4	PORTD,4
#define		OUT5	PORTD,5
#define		OUT6	PORTD,6
#define		OUT7	PORTD,7

#define		OUT0_TRIS	PORTD+dTRISx,0
#define		OUT1_TRIS	PORTD+dTRISx,1
#define		OUT2_TRIS	PORTD+dTRISx,2
#define		OUT3_TRIS	PORTD+dTRISx,3
#define		OUT4_TRIS	PORTD+dTRISx,4
#define		OUT5_TRIS	PORTD+dTRISx,5
#define		OUT6_TRIS	PORTD+dTRISx,6
#define		OUT7_TRIS	PORTD+dTRISx,7
