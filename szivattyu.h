		byte	Sziv_Timer,2	;sec
		byte	Sziv_Phase,2
		byte	Sziv_Status,0

#define		OUT_Sziv_En	OutRegs,0	;Szivattyú ténylegesen mehet (nem megy sok ideje, nem fog leégni)

#define		SET_SZIV_EN	bsf	OUT_Sziv_En
#define		RST_SZIV_EN	bcf	OUT_Sziv_En

;================================================================


#define		IN_Sziv		InRegs,0	;Szivattyú menne (alacsony a nyomás)

#define		Next_Sziv	btfsc	IN_Sziv
#define		Skip_Sziv	btfss	IN_Sziv


INIT_SZIV_WAIT_TIMER	=	2	;sec, kérés után csak ennyi idõ múlva kapcsoljuk be
INIT_SZIV_TIMER		=	240	;sec



