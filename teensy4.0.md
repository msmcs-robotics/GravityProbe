# Usage

Use the i2c scanner to determine the addresses for the mpu and the oled display

Use the mpu zero script relative to mpu name to calibrate

## MPU6050

[MPU Library Github](https://github.com/ElectronicCats/mpu6050)
[I2Cdev Library Github](https://github.com/jrowberg/i2cdevlib/tree/master/Arduino/I2Cdev), [direct download](https://download-directory.github.io/?url=https%3A%2F%2Fgithub.com%2Fjrowberg%2Fi2cdevlib%2Ftree%2Fmaster%2FArduino%2FI2Cdev)

* GND - GND
* VCC - 5v
* SCL - 19
* SDA - 18

```cpp
MPU6050 mpu(0x68); // Define the i2c address of the mpu
```

Example Offsets after running the mpu6050_zero program (calibrate and find offsets)

```
Averaging 10000 readings each time
		XAccel			YAccel				ZAccel			XGyro			YGyro			ZGyro
 [-4347,-4345] --> [-13,8]	[-351,-350] --> [-2,16]	[2620,2622] --> [16369,16388]	[43,44] --> [-2,1]	[82,83] --> [-1,1]	[29,30] --> [0,3]
 [-4347,-4346] --> [-13,5]	[-351,-350] --> [-2,16]	[2621,2622] --> [16375,16388]	[43,44] --> [-3,1]	[82,83] --> [0,1]	[29,30] --> [0,3]
 [-4347,-4346] --> [-16,5]	[-351,-351] --> [-2,3]	[2621,2622] --> [16348,16388]	[43,44] --> [-4,1]	[82,83] --> [-1,1]	[29,30] --> [0,3]
-------------- DONE --------------
```

Applying the offsets in the mpu code
```
const int accelXOffset = -4347;
const int accelYOffset = -351;
const int accelZOffset = 2620;
const int gyroXOffset = 43;
const int gyroYOffset = 82;
const int gyroZOffset = 29;
```

## GY-271 QMC5883L Magnetometer

* VCC - 5v
* GND - GND
* SCL - 19
* SDA - 18

[A library](https://github.com/jarzebski/Arduino-HMC5883L) for HMC5883L
[A simple library](https://github.com/sleemanj/HMC5883L_Simple) for the HMC5883L

> The I2C address for a GY-271 QMC5883L module is typically 0x0D

The GY-271 is supposed to have an HMC5883L, but some knockoff boards have a QMC5883L which has the same basic capability, but is not compatible with the H.

If you have a GY-271 board and observe an I2C address of 0x0C and read back nothing but zeros from the board, then you probably have a QMC5883L chip!

[QMC library github](https://github.com/dthain/QMC5883L/releases)

## HW125 SD card module

> card.init() not the function SD.init()

[SD Library Github](https://github.com/arduino-libraries/SD)

[SPI Library Github](https://github.com/arduino/ArduinoCore-avr/tree/master/libraries/SPI), [direct download](https://download-directory.github.io/?url=https%3A%2F%2Fgithub.com%2Farduino%2FArduinoCore-avr%2Ftree%2Fmaster%2Flibraries%2FSPI)

**Pinout**

*  CS - 10
*  SCK - 13
*  MOSI - 11
*  MISO - 12
*  VCC - 5v
*  GND - GND

**File Handling**

The file (dataFile) is opened once in the setup() function and remains open for the entire duration of the loop. This ensures that data can be written without closing the file prematurely.

**Flushing and Writing** 

After every write, the flush() function is called to ensure the data is actually written to the SD card. This reduces the chances of data being cached and not actually written to the SD card.

**No Closing the File**

Don't close dataFile.close() within the loop(), ensuring the file stays open. The file will only be closed when the program ends, so it won't disrupt data logging.

## I2C OLED Display 0.91

U8G2 Library [found here](https://github.com/olikraus/u8g2/) or arduino library manager "U8G2 by oliver"
U8G2 [Reference wiki](https://github.com/olikraus/u8g2/wiki/u8g2reference)

> using wire for i2c communication and u8g2 for graphics
> SSD1306 driver

* GND - GND
* VCC - 3v
* SCL - 19
* SDA - 18

```cpp
#include <U8g2lib.h>
#include <Wire.h>
```

the proper constructor for *dsd tech i2c oled 0.91* and using normal scl (19) and sda (18) pins for the teensy

```cpp
U8G2_SSD1306_128X32_UNIVISION_F_SW_I2C u8g2(U8G2_R0, /* clock=*/ SCL, /* data=*/ SDA);
```

## ESP8266 wifi module

https://github.com/Hieromon/ESP8266

* Wifi Library [link](https://github.com/esp8266/Arduino/tree/master/libraries/ESP8266WiFi).
 * Download the [github folder directly](https://download-directory.github.io/?url=https%3A%2F%2Fgithub.com%2Fesp8266%2FArduino%2Ftree%2Fmaster%2Flibraries%2FESP8266Wifi).
* Web Server Library [Link](https://github.com/esp8266/Arduino/tree/master/libraries/ESP8266WebServer).
 * Download the [github folder directly](https://download-directory.github.io/?url=https%3A%2F%2Fgithub.com%2Fesp8266%2FArduino%2Ftree%2Fmaster%2Flibraries%2FESP8266WebServer).