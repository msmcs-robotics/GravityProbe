> Board Selection In Arduino Through Expressif Board Manager
> DOIT ESP32 DevKit V1

## Connect to WPA2 Enterprise Protected EAP

[WiFi.h library github](https://github.com/espressif/arduino-esp32/tree/master/libraries/WiFi), [direct download](https://download-directory.github.io/?url=https%3A%2F%2Fgithub.com%2Fespressif%2Farduino-esp32%2Ftree%2Fmaster%2Flibraries%2FWiFi)

## I2C OLED Display 0.91

U8G2 Library [found here](https://github.com/olikraus/u8g2/) or arduino library manager "U8G2 by oliver"
U8G2 [Reference wiki](https://github.com/olikraus/u8g2/wiki/u8g2reference)

> using wire for i2c communication and u8g2 for graphics
> SSD1306 driver

* GND - GND
* VCC - 3v
* SCL - 39 - GPIO 22
* SDA - 42 - GPIO 21

```cpp
#include <U8g2lib.h>
#include <Wire.h>
```

the proper constructor for *dsd tech i2c oled 0.91* and using normal scl (gpio 22) and sda (18) pins for the teensy

```cpp
U8G2_SSD1306_128X32_UNIVISION_F_SW_I2C u8g2(U8G2_R0, /* clock=*/ SCL, /* data=*/ SDA);
```

### SD Card HW 125

https://github.com/arduino-libraries/SD

https://www.electronicwings.com/esp32/microsd-card-interfacing-with-esp32

* GND - GND
* 3V3 - 3.3V
* MISO - GPIO 19
* MOSI - GPIO 23
* SCK - GPIO 18
* CS - GPIO 5 or GPIO 2

## MPU6050

* GND - GND
* VCC - 5v / vin
* SCL - 39 - GPIO 22
* SDA - 42 - GPIO 21

## GY-271 QMC5883L Magnetometer

* GND - GND
* VCC - 5v / vin
* SCL - 39 - GPIO 22
* SDA - 42 - GPIO 21

[A library](https://github.com/jarzebski/Arduino-HMC5883L) for HMC5883L
[A simple library](https://github.com/sleemanj/HMC5883L_Simple) for the HMC5883L

> The I2C address for a GY-271 QMC5883L module is typically 0x0D

The GY-271 is supposed to have an HMC5883L, but some knockoff boards have a QMC5883L which has the same basic capability, but is not compatible with the H.

If you have a GY-271 board and observe an I2C address of 0x0C and read back nothing but zeros from the board, then you probably have a QMC5883L chip!

[QMC library github](https://github.com/dthain/QMC5883L/releases)