// --------------------------------------
// i2c_scanner
//
// Version 1
//    This program (or code that looks like it)
//    can be found in many places.
//    For example on the Arduino.cc forum.
//    The original author is not known.
// Version 2, Juni 2012, Using Arduino 1.0.1
//     Adapted to be as simple as possible by Arduino.cc user Krodal
// Version 3, Feb 26  2013
//    V3 by louarnold
// Version 4, March 3, 2013, Using Arduino 1.0.3
//    by Arduino.cc user Krodal.
//    Changes by louarnold removed.
//    Scanning addresses changed from 0...127 to 1...119,
//    according to the i2c scanner by Nick Gammon
//    http://www.gammon.com.au/forum/?id=10896
// Version 5, March 28, 2013
//    As version 4, but address scans now to 127.
//    A sensor seems to use address 120.
// 
//
// This sketch tests the standard 7-bit addresses
// Devices with higher bit address might not be seen properly.
//

/* whoami functionality added */

#include <Wire.h>

void setup() {
  Wire.begin();
  Serial.begin(9600);
  Serial.println("\nI2C Scanner");
}

void loop() {
  byte error, address;
  int nDevices;

  Serial.println("Scanning...");

  nDevices = 0;
  for (address = 1; address < 127; address++) {
    Wire.beginTransmission(address);
    error = Wire.endTransmission();

    if (error == 0) {
      Serial.print("I2C device found at address 0x");
      if (address < 16)
        Serial.print("0");
      Serial.print(address, HEX);
      Serial.println("  !");

      // Try to get more information from the device
      getDeviceInfo(address);

      nDevices++;
    }
    else if (error == 4) {
      Serial.print("Unknown error at address 0x");
      if (address < 16)
        Serial.print("0");
      Serial.println(address, HEX);
    }
  }

  if (nDevices == 0)
    Serial.println("No I2C devices found\n");
  else
    Serial.println("done\n");

  delay(5000); // wait 5 seconds for next scan
}

void getDeviceInfo(byte address) {
  byte data;
  Wire.beginTransmission(address);

  // Attempt to read the first register, 0x00, which is common in many devices
  if (Wire.requestFrom(address, (byte)1) == 1) {
    data = Wire.read();
    Serial.print("  Device info byte (register 0x00): 0x");
    Serial.println(data, HEX);
  } else {
    Serial.println("  No readable data available from register 0x00.");
  }

  // Some devices might respond to a WHO_AM_I register (like many sensors)
  Wire.beginTransmission(address);
  Wire.write(0x0F);  // Common register for WHO_AM_I, used in some sensors (e.g., accelerometers)
  if (Wire.endTransmission() == 0) {
    Wire.requestFrom(address, (byte)1);
    if (Wire.available()) {
      byte whoami = Wire.read();
      Serial.print("  WHO_AM_I register value: 0x");
      Serial.println(whoami, HEX);
    }
  } else {
    Serial.println("  No WHO_AM_I response.");
  }
}
