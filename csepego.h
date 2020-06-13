;--------------	I/O-k
	ifdef	TESZT
#define	IN_Csepegogomb0	InRegs,0	;Bemeneti kapcsol� hely
#define	OUT_Csepego	OutRegs,0
#define	OUT_CsepegoLED0	OutRegs,6
	else
#define	IN_Csepegogomb0	InRegs,7	;Bemeneti kapcsol� hely
#define	OUT_Csepego	OutRegs,5
#define	OUT_CsepegoLED0	OutRegs,7
	endif
;------
#define	Next_Csepegogomb0	btfsc	IN_Csepegogomb0	;Kihagyja a k�v. utas�t�st, ha nem nyomj�k
#define	Skip_Csepegogomb0	btfss	IN_Csepegogomb0	;Kihagyja a k�v. utas�t�st, ha nyomj�k

#define	SET_OUT_Csepego	bsf	OUT_Csepego
#define	RST_OUT_Csepego	bcf	OUT_Csepego

#define SET_OUT_CsepegoLED0	bsf	OUT_CsepegoLED0
#define RST_OUT_CsepegoLED0	bcf	OUT_CsepegoLED0


;--------------	V�ltoz�k
	byte	Csepegogomb0_Phase,2
	byte	Csepegogomb0_Timer,2
	byte	Csepegogomb0_Timer_b,2
	byte	Csepegogomb0_Status,0

	byte	CsepegoLED0_Phase,2
	byte	CsepegoLED0_Timer,2
	byte	CsepegoLED0_korok,2	;Ennyit kell levillogni
	byte	CsepegoLED0_vill,2	;Ennyit kell M�G levillogni

	byte	Csepego1_Phase,2
	byte	Csepego1_korok,2
	byte	Csepego1_Status,0
	word	Csepego1_Timer,2


;--------------	Bitek
#define	B_Csepegogomb0_Press	Csepegogomb0_Status,0	;Nyomj�k a gombot
#define	B_Csepegogomb0_L	Csepegogomb0_Status,1	;Hossz� ideje nyomj�k (ha elengedt�k t�rl�dik)
#define	B_Csepegogomb0_01	Csepegogomb0_Status,2	;Megnyomt�k a gombot (ez nem t�rl�dik)
#define	B_Csepegogomb0_10	Csepegogomb0_Status,3	;Elengedt�k a gombot (ez nem t�rl�dik)

#define	B_Csepego1_L		Csepego1_Status,0	;Hossz� ideje nyomj�k


;--------------	�rt�kek
	ifndef	TESZT2
Csepegogomb0_PRELL = 1	;100 ms		;PRELL Time ideje, 100 ms-k�nt h�v�dik meg
Csepegogomb0_L = 20	;1 sec		;Long Time ideje,  100 ms-k�nt h�v�dik meg

CsepegoLED0_li = 1	;0,1 sec	;Light Time ideje, 100 ms-k�nt h�v�dik meg
CsepegoLED0_S = 3	;0,3 sec	;Short Time ideje, 100 ms-k�nt h�v�dik meg
CsepegoLED0_L = 15	;1,5 sec	;Long Time ideje,  100 ms-k�nt h�v�dik meg

Csepego1_TF = 180	;180 sec = 3 min	;Csepego Fut�si ideje 1000 ms-k�nt h�v�dik meg
Csepego1_TV = 27*60	;27 min		;Hossz� v�rakoz�s ideje, 1000 ms-k�nt h�v�dik meg
;------------|
	else
;------------|
Csepegogomb0_PRELL = 1	;100 ms		;PRELL Time ideje, 100 ms-k�nt h�v�dik meg
Csepegogomb0_L = 20	;1 sec		;Long Time ideje,  100 ms-k�nt h�v�dik meg

CsepegoLED0_li = 1	;0,1 sec	;Light Time ideje, 100 ms-k�nt h�v�dik meg
CsepegoLED0_S = 3	;0,3 sec	;Short Time ideje, 100 ms-k�nt h�v�dik meg
CsepegoLED0_L = 15	;1,5 sec	;Long Time ideje,  100 ms-k�nt h�v�dik meg

Csepego1_TF = 5		;5 sec		;Csepego Fut�si ideje 1000 ms-k�nt h�v�dik meg
Csepego1_TV = 10	;10 sec		;Hossz� v�rakoz�s ideje, 1000 ms-k�nt h�v�dik meg
	endif




