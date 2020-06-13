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
