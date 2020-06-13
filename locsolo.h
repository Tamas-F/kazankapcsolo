;--------------I/O-k
	ifdef	TESZT
#define	IN_Locsologomb0	InRegs,1	;Bemeneti kapcsol� hely
#define	OUT_Locsol1	OutRegs,1
#define	OUT_Locsol2	OutRegs,2
#define	OUT_Locsol3	OutRegs,3
#define	OUT_LocsoloLED0	OutRegs,7
	else
#define	IN_Locsologomb0	InRegs,6	;Bemeneti kapcsol� hely
#define	OUT_Locsol1	OutRegs,2
#define	OUT_Locsol2	OutRegs,3
#define	OUT_Locsol3	OutRegs,4
#define	OUT_LocsoloLED0	OutRegs,6
	endif
;------	

#define	Next_Locsologomb0		btfsc	IN_Locsologomb0	;Kihagyja a k�v. utas�t�st, ha nem nyomj�k
#define	Skip_Locsologomb0		btfss	IN_Locsologomb0	;Kihagyja a k�v. utas�t�st, ha nyomj�k

#define	SET_OUT_Locsol1 bsf	OUT_Locsol1
#define	RST_OUT_Locsol1	bcf	OUT_Locsol1

#define	SET_OUT_Locsol2 bsf	OUT_Locsol2
#define	RST_OUT_Locsol2	bcf	OUT_Locsol2

#define	SET_OUT_Locsol3 bsf	OUT_Locsol3
#define	RST_OUT_Locsol3	bcf	OUT_Locsol3

#define SET_OUT_LocsoloLED0	bsf	OUT_LocsoloLED0
#define RST_OUT_LocsoloLED0	bcf	OUT_LocsoloLED0


;--------------	V�ltoz�k
	byte	Locsologomb0_Phase,2
	byte	Locsologomb0_Timer,2
	byte	Locsologomb0_Timer_b,2
	byte	Locsologomb0_Status,0

	byte	LocsoloLED0_Phase,2
	byte	LocsoloLED0_Timer,2
	byte	LocsoloLED0_korok,2	;Ennyit kell levillogni
	byte	LocsoloLED0_vill,2	;Ennyit kell M�G levillogni

	byte	Locsolo1_Phase,2
	byte	Locsolo1_korok,2
	byte	Locsolo1_Status,0
	byte	Locsolo1_kor_Status,0
	byte	Locsolo1_Timer,2

;--------------	Bitek
#define	B_Locsologomb0_Press	Locsologomb0_Status,0	;Nyomj�k a gombot
#define	B_Locsologomb0_L	Locsologomb0_Status,1	;Hossz� ideje nyomj�k (ha elengedt�k t�rl�dik)
#define	B_Locsologomb0_01	Locsologomb0_Status,2	;Megnyomt�k a gombot (ez nem t�rl�dik)
#define	B_Locsologomb0_10	Locsologomb0_Status,3	;Elengedt�k a gombot (ez nem t�rl�dik)

#define	B_Locsolo1_kor_1	Locsolo1_kor_Status,0	;1. k�r megy
#define	B_Locsolo1_kor_2	Locsolo1_kor_Status,1	;2. k�r megy
#define	B_Locsolo1_kor_3	Locsolo1_kor_Status,2	;3. k�r megy

#define	B_Locsolo1_L		Locsolo1_Status,0	;Hossz� ideje nyomj�k



;--------------	�rt�kek
	ifndef	TESZT2
Locsologomb0_PRELL = 1	;0,1 sec	;PRELL Time ideje, 100 ms-k�nt h�v�dik meg
Locsologomb0_L = 15	;1,5 sec	;Long Time ideje, 100 ms-k�nt h�v�dik meg

LocsoloLED0_li = 1	;0,1 sec	;Light Time ideje, 100 ms-k�nt h�v�dik meg
LocsoloLED0_S = 3	;0,3 sec	;Short Time ideje, 100 ms-k�nt h�v�dik meg
LocsoloLED0_L = 15	;1,5 sec	;Long Time ideje,  100 ms-k�nt h�v�dik meg

Locsolo1_TF1 = 60	;60 sec = 1 min	;1. Locsolo Fut�si ideje (60sec)
Locsolo1_TF2 = 60	;60 sec = 1 min	;2. Locsolo Fut�si ideje (60sec)
Locsolo1_TF3 = 60	;60 sec = 1 min	;3. Locsolo Fut�si ideje (60sec)
Locsolo1_TV =  60	;60 sec		;Hossz� V�rakoz�si Timer
Locsolo1_TV1 = 5	;5 sec		;R�vid V�rakoz�si Timerek
;------------|	
	else
;------------|
Locsologomb0_PRELL = 1	;100 ms		;PRELL Time ideje, 100 ms-k�nt h�v�dik meg
Locsologomb0_L = 20	;2 sec		;Long Time ideje, 100 ms-k�nt h�v�dik meg

LocsoloLED0_li = 1	;0,1 sec	;Light Time ideje, 100 ms-k�nt h�v�dik meg
LocsoloLED0_S = 3	;0,3 sec	;Short Time ideje, 100 ms-k�nt h�v�dik meg
LocsoloLED0_L = 15	;1,5 sec	;Long Time ideje,  100 ms-k�nt h�v�dik meg

Locsolo1_TF1 = 5	;5 sec	;1. Locsolo Fut�si ideje (60sec)
Locsolo1_TF2 = 5	;5 sec	;2. Locsolo Fut�si ideje (60sec)
Locsolo1_TF3 = 5	;5 sec	;3. Locsolo Fut�si ideje (60sec)
Locsolo1_TV =  10	;10 sec		;Hossz� V�rakoz�si Timer
Locsolo1_TV1 = 3	;3 sec		;R�vid V�rakoz�si Timerek
	endif