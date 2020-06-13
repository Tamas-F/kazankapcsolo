		word	Init_TMR0_Reg,2
		word	Init_TMR1_Reg,2

INIT_T0CON_REG	=	B'10001000'	;7,TMR0ON: 1:Enable, 0:Disable
					;6,T08BIT: 1:8bit,   0:16Bit
					;5,T0CS:   1:T0CKI   0:Internal(CLK0)
					;4,T0SE:   1:H->l    0:L->H T0CKI
					;3,PSA:    1:Prescaller OFF 0:Presceller ON
					;2,T0PS2:  Precsaler value
					;1,T0PS1:  000:1:2
					;0,T0PS0:  111:1:256

Init_TMR0_H	=	0xfe	;Az 0.1 msec-es Global orahoz
Init_TMR0_L	=	0x26	;Az elooszto 1
;+-------+-------+-------+---------+
;|  ms   |   H   |   L   | Elõoszt |    
;+-------+-------+-------+---------+
;|0.100  |  FE   |  26   | 00 (1:2)|    
;|0.100  |  FE   |  26   | 00 (1:2)|    
;+-------+-------+-------+---------+



INIT_T1CON_REG	=	B'10000001'	;7, RD16:  1:16BitMode 0:8BitMode
					;6, Unimplemented
					;5, T1CKPS1: Prescaller value
					;4, T1CKPS0 11=1:8 00=1:1
					;3, T1OSCEN 1:Enable 0:Didable
					;2, -T1SYNC 1:Not 0:Syncronized
					;1, TMR1CS 1:RC0 Clock 0: Fosc/4
					;0, TMR1ON 1:ON 0:OFF
Init_TMR1_	=	1000	;0.1 us-ben
Init_TMR1__	=	0-Init_TMR1_+15
Init_TMR1_H	=	High(Init_TMR1__)
Init_TMR1_L	=	Low(Init_TMR1__)
messg	#V(Init_TMR1_H) #V(Init_TMR1_L)
;Init_TMR1_H	=	0xfc	;Az 0.1 msec-es Global orahoz
;Init_TMR1_L	=	0x2f	;Az elooszto 1 (Osc=40MHz)

;+-------+-------+-------+-------+
;|  ms   |   H   |   L   |Elõoszt|    
;+-------+-------+-------+-------+
;|0.100  |  FC   |  32   | 00 (1)|    

