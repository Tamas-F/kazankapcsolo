#define		SIO_HWREG		PORTC
#define		SIO_TX_BIT		6
#define		SIO_RC_BIT		7
#define		SIO_TX			SIO_HWREG,SIO_TX_BIT
#define		SIO_RC			SIO_HWREG,SIO_RC_BIT
#define		SIO_TX_TRIS		SIO_HWREG+dTRISx,SIO_TX_BIT
#define		SIO_RC_TRIS		SIO_HWREG+dTRISx,SIO_RC_BIT
#define		SIO_TX_LAT		SIO_HWREG+dLATx,SIO_TX_BIT
#define		SIO_RC_LAT		SIO_HWREG+dLATx,SIO_RC_BIT

#define		SIOEN_HWREG		PORTB
#define		SIO_TX1EN		SIOEN_HWREG,4
#define		SIO_TX1EN_TRIS		SIOEN_HWREG+dTRISx,4
#define		SIO_TX2EN		SIOEN_HWREG,2
#define		SIO_TX2EN_TRIS		SIOEN_HWREG+dTRISx,2
#define		SIO_RC1EN		SIOEN_HWREG,5
#define		SIO_RC1EN_TRIS		SIOEN_HWREG+dTRISx,5
#define		SIO_RC2EN		SIOEN_HWREG,3
#define		SIO_RC2EN_TRIS		SIOEN_HWREG+dTRISx,3

INIT_RCSTA_REG0	=	B'00000000'	;SPEN=1	  :Serial Rec. port enabled
					;RC8/9=0  :Data length 8 bit
					;SREN=0   :Don't care
					;CREN=0   :Continuous Rec. enab
					;FERR,OERR,RCD8 : csak olvashato

INIT_RCSTA_REG	=	B'10010000'	;SPEN=1	  :Serial Rec. port enabled
					;RC8/9=0  :Data length 8 bit
					;SREN=0   :Don't care
					;CREN=1   :Continuous Rec. enab
					;FERR,OERR,RCD8 : csak olvashato

INIT_TXSTA_REG	=	B'00100100'	;CSRC=0   :Don't care
					;TX8/9=0  :Data length 8 bit
					;TXEN=1   :Transmit enab.
					;SYNC=0	  :Asyncronous mode
					;Unimplemented
					;BRGH=1   :Baud rate hi(\16)
					;TRMT     :csak olvashato
					;TXD8=0   :Parity bit=don't care

INIT_SPBRG_REG	=	D'20'		;Baud rate generator <-  115200 (113.636 -1.36%)
;INIT_SPBRG_REG	=	D'43'		;Baud rate generator <-  57600 (56818,18 -1.36%)
;INIT_SPBRG_REG	=	D'42'		;Baud rate generator <-  57600 (58139,53 0,9%)

;--------
	byte	SIO_TAddr,0		;Ez az én címem
;--------
					;Mindkét puffer, körpuffer!!!
	byte	SIO_Tx_Mode,0
	byte	SIO_Tx_ModeSave,0
	byte	SIO_Tx_Timer,0		;
	byte	SIO_Tx_Status,0		;
	byte	SIO_Tx_CHKSUM,0
	byte	SIO_Tx_Length,0		;Átmenetileg ide rakjuk be a hosszt.
	byte	SIO_Tx_SAddr,0		;Átmenetileg ide rakjuk be a cél címet.
	byte	SIO_Tx_pWRTmp,0		;A Tx_buf beiro pointere, Ide irhatjuk amit akarunk
	byte	SIO_Tx_pWR,0		;Idáig raktunk bele jó adatokat
	byte	SIO_Tx_pRD,0		;Innen kell olvasni a következõt, ha ITbõl kivisszük

	byte	SIO_Rc_Mode,0
	byte	SIO_Rc_ModeSave,0
	byte	SIO_Rc_Status,0
	byte	SIO_Rc_CHKSUM,0
	byte	SIO_Rc_Length,0		;Átmenetileg ide rakjuk be a hosszt.
	byte	SIO_Rc_SAddr,0		;Átmenetileg ide rakjuk be a cél címet.

	byte	SIO_Rc_pWRTmp,0		;Ide kell berakni, ha ITbõl jött valami,Lehet, hogy a CHKSUM lesz jó
					;Ezért csak ezt használjuk átmenetileg
	byte	SIO_Rc_pWR,0		;Idáig raktunk bele jó adatokat.
	byte	SIO_Rc_pRD,0		;Az Rc_Buf olvasó pointere. Innen olvashatunk, ha jött valami.

;--------
SIO_TX_LEN_BUF	=	256
SIO_RC_LEN_BUF	=	256

	array	Tx_Buf,SIO_TX_LEN_BUF,1	;Ha adatot kuld az inen megy
	array	Rc_Buf,SIO_RC_LEN_BUF,3	;Ha adatot kapott az ide kerul


  if (Tx_Buf & (SIO_TX_LEN_BUF-1)) == 0 
	messg "Tx Buffer OK"
  else
	error "Tx Buffer ERROR"
  endif
  if (Rc_Buf & (SIO_RC_LEN_BUF-1)) == 0 
	messg "Rc Buffer OK"
  else
	error "Rc Buffer ERROR"
  endif

;--------
#define		TXBUF_FULL	SIO_Tx_Status,0
#define		TXBUF_EMPTY	SIO_Tx_Status,1
;#define	TX_ENABLE	SIO_Tx_Status,7
#define		TX_END_DISAB	SIO_Tx_Status,6
#define		TX_WAIT_ENABLE	SIO_Tx_Status,5

#define		RCBUF_FULL	SIO_Rc_Status,0
#define		RCBUF_EMPTY	SIO_Rc_Status,1
#define		RC_ENABLE	SIO_Rc_Status,7

;SIO_RC_Mode állapotváltozó értékei (csak az alsó 3 it számít!!!)
RC_MODE_ESC	equ	0
RC_MODE_LENGTH	equ	4
RC_MODE_TADDR	equ	8
RC_MODE_SADDR	equ	12
RC_MODE_ID	equ	16
RC_MODE_COMM	equ	20
RC_MODE_DATA	equ	24
RC_MODE_DESC	equ	28
RC_MODE_CHKSUM	equ	32

;SIO_TX_Mode állapotváltozó értékei (csak az alsó 3 it számít!!!)
TX_MODE_ESC	equ	0
TX_MODE_LENGTH	equ	4
TX_MODE_TADDR	equ	8
TX_MODE_SADDR	equ	12
TX_MODE_ID	equ	16
TX_MODE_COMM	equ	20
TX_MODE_DATA	equ	24
TX_MODE_DESC	equ	28
TX_MODE_CHKSUM	equ	32


;Az ESC szekvencia bevezetõ karaktere
RC_ESC_BYTE	equ	H'55'
TX_ESC_BYTE	equ	H'55'
