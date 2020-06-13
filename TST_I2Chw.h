	byte	I2C_PDATA,0
	byte	I2C_PDATA2,0
	byte	I2C_SDASCL,0
	byte	I2C_ADDR,0
	byte	I2C_W,0
	byte	I2C_i,0
	byte	I2C_j,0

#define		I2C_SDA			PORTC,4
#define		I2C_SCL			PORTC,3
#define		I2C_SDA_TRIS		PORTC+dTRISx,4
#define		I2C_SCL_TRIS		PORTC+dTRISx,3

#define		INIT_SSPSTAT	B'10000000'
						;bit 7 SMP: Slew Rate Control bit
						;In Master or Slave mode:
						;1 = Slew rate control disabled for Standard Speed mode (100 kHz and 1 MHz)
						;0 = Slew rate control enabled for High Speed mode (400 kHz)
						;bit 6 CKE: SMBus Select bit
						;In Master or Slave mode:
						;1 = Enable SMBus specific inputs
						;0 = Disable SMBus specific inputs
						;bit 5 D/A: Data/Address bit
						;In Master mode:
						;Reserved
						;In Slave mode:
						;1 = Indicates that the last byte received or transmitted was data
						;0 = Indicates that the last byte received or transmitted was address
						;bit 4 P: STOP bit
						;1 = Indicates that a STOP bit has been detected last
						;0 = STOP bit was not detected last
						;Note: This bit is cleared on RESET and when SSPEN is cleared.
						;bit 3 S: START bit
						;1 = Indicates that a start bit has been detected last
						;0 = START bit was not detected last
						;Note: This bit is cleared on RESET and when SSPEN is cleared.
						;bit 2 R/W: Read/Write bit Information (I2C mode only)
						;In Slave mode:
						;1 = Read
						;0 = Write
						;Note: This bit holds the R/W bit information following the last address match. This bit is only
						;valid from the address match to the next START bit, STOP bit, or not ACK bit.
						;In Master mode:
						;1 = Transmit is in progress
						;0 = Transmit is not in progress
						;Note: ORing this bit with SEN, RSEN, PEN, RCEN, or ACKEN will indicate if the MSSP is
						;in IDLE mode.
						;bit 1 UA: Update Address (10-bit Slave mode only)
						;1 = Indicates that the user needs to update the address in the SSPADD register
						;0 = Address does not need to be updated
						;bit 0 BF: Buffer Full Status bit
						;In Transmit mode:
						;1 = Receive complete, SSPBUF is full
						;0 = Receive not complete, SSPBUF is empty
						;In Receive mode:
						;1 = Data transmit in progress (does not include the ACK and STOP bits), SSPBUF is full
						;0 = Data transmit complete (does not include the ACK and STOP bits), SSPBUF is empty

#define		INIT_SSPADD	40;25;15               ; Setup 1000 kHz I2C clock
#define		INIT_SSPCON1 	b'00101000'	;SSPEN,Master mode
						;bit 7 WCOL: Write Collision Detect bit
						;In Master Transmit mode:
						;1 = A write to the SSPBUF register was attempted while the I2C conditions were not valid for
						;a transmission to be started (must be cleared in software)
						;0 = No collision
						;bit 6 SSPOV: Receive Overflow Indicator bit
						;In Receive mode:
						;1 = A byte is received while the SSPBUF register is still holding the previous byte (must
						;be cleared in software)
						;0 = No overflow
						;In Transmit mode:
						;This is a “don’t care” bit in Transmit mode
						;bit 5 SSPEN: Synchronous Serial Port Enable bit
						;1 = Enables the serial port and configures the SDA and SCL pins as the serial port pins
						;0 = Disables serial port and configures these pins as I/O port pins
						;Note: When enabled, the SDA and SCL pins must be properly configured as input or output.
						;bit 4 CKP: SCK Release Control bit
						;In Master mode:
						;Unused in this mode
						;bit 3-0 SSPM3:SSPM0: Synchronous Serial Port Mode Select bits
						;1111 = I2C Slave mode, 10-bit address with START and STOP bit interrupts enabled
						;1110 = I2C Slave mode, 7-bit address with START and STOP bit interrupts enabled
						;1011 = I2C Firmware Controlled Master mode (Slave IDLE)
						;1000 = I2C Master mode, clock = FOSC / (4 * (SSPADD+1))
						;0111 = I2C Slave mode, 10-bit address
						;0110 = I2C Slave mode, 7-bit address
