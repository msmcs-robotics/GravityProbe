# Usage

Use the i2c scanner to determine the addresses for the mpu and the oled display

## MPU6050

> MPU6050 mpu(0x68); // Define the address of the mpu

## HW125 SD card module

> card.init() not SD.init()

### Teensy 4.0 pinout for HW 125

*  CS - 10
*  SCK - 13
*  MOSI - 11
*  MISO - 12
*  VCC - 5v
*  GND - GND

### File Handling

The file (dataFile) is opened once in the setup() function and remains open for the entire duration of the loop. This ensures that data can be written without closing the file prematurely.

### Flushing and Writing 

After every write, the flush() function is called to ensure the data is actually written to the SD card. This reduces the chances of data being cached and not actually written to the SD card.

### No Closing the File

Don't close dataFile.close() within the loop(), ensuring the file stays open. The file will only be closed when the program ends, so it won't disrupt data logging.


## ESP8266 wifi module

https://github.com/Hieromon/ESP8266

* Wifi Library [link](https://github.com/esp8266/Arduino/tree/master/libraries/ESP8266WiFi).
 * Download the [github folder directly](https://download-directory.github.io/?url=https%3A%2F%2Fgithub.com%2Fesp8266%2FArduino%2Ftree%2Fmaster%2Flibraries%2FESP8266Wifi).
* Web Server Library [Link](https://github.com/esp8266/Arduino/tree/master/libraries/ESP8266WebServer).
 * Download the [github folder directly](https://download-directory.github.io/?url=https%3A%2F%2Fgithub.com%2Fesp8266%2FArduino%2Ftree%2Fmaster%2Flibraries%2FESP8266WebServer).

## I2C OLED Display 0.91

using wire for i2c communication and u8g2 for graphics.

> #include <U8g2lib.h>
> #include <Wire.h>

the proper constructor for *dsd tech i2c oled 0.91* and using normal scl (19) and sda (18) pins for the teensy

```cpp
U8G2_SSD1306_128X32_UNIVISION_F_SW_I2C u8g2(U8G2_R0, /* clock=*/ SCL, /* data=*/ SDA);
```

U8G2 Library [found here](https://github.com/olikraus/u8g2/) or arduino library manager "U8G2 by oliver"
U8G2 [Reference wiki](https://github.com/olikraus/u8g2/wiki/u8g2reference)