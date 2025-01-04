#include <SD.h>
#include <SPI.h>

// Set up variables using the SD utility library functions:
Sd2Card card;
SdVolume volume;
SdFile root;

const int chipSelect = 10;
File dataFile;

// Placeholder variables for sensor data
float ax = 0.0, ay = 0.0, az = 0.0; // Accelerometer
float gx = 0.0, gy = 0.0, gz = 0.0; // Gyroscope
float mx = 0.0, my = 0.0, mz = 0.0; // Magnetometer
unsigned long t = 0;                // Timestamp

void setup() {
  Serial.begin(9600);
  while (!Serial) {
    ; // Wait for serial port to connect.
  }

  Serial.print("\nInitializing SD card...");

  // SD card initialization
  if (!card.init(SPI_HALF_SPEED, chipSelect)) {
    Serial.println("Initialization failed. Things to check:");
    Serial.println("* is a card inserted?");
    Serial.println("* is your wiring correct?");
    Serial.println("* did you change the chipSelect pin to match your shield or module?");
    return;
  } else {
    Serial.println("Wiring is correct and a card is present.");
  }

  // Create a unique filename once in setup
  String filename = createUniqueFilename();
  dataFile = SD.open(filename.c_str(), FILE_WRITE);

  if (dataFile) {
    // Write the header row if the file is empty
    if (dataFile.size() == 0) {
      dataFile.println("t,ax,ay,az,gx,gy,gz,mx,my,mz");
      Serial.println("Headers written to file.");
    }
    Serial.print("Logging data to: ");
    Serial.println(filename);
  } else {
    Serial.println("Failed to create or open the file.");
  }
}

void loop() {
  // Simulate reading sensor data (replace with your sensor code)
  t = millis();
  ax = random(-10, 10) / 10.0;
  ay = random(-10, 10) / 10.0;
  az = random(-10, 10) / 10.0;
  gx = random(-10, 10) / 10.0;
  gy = random(-10, 10) / 10.0;
  gz = random(-10, 10) / 10.0;
  mx = random(-10, 10) / 10.0;
  my = random(-10, 10) / 10.0;
  mz = random(-10, 10) / 10.0;

  // Check if the file is still valid before writing
  if (dataFile) {
    // Attempt to write data to the file
    dataFile.print(t);
    dataFile.print(",");
    dataFile.print(ax, 2);
    dataFile.print(",");
    dataFile.print(ay, 2);
    dataFile.print(",");
    dataFile.print(az, 2);
    dataFile.print(",");
    dataFile.print(gx, 2);
    dataFile.print(",");
    dataFile.print(gy, 2);
    dataFile.print(",");
    dataFile.print(gz, 2);
    dataFile.print(",");
    dataFile.print(mx, 2);
    dataFile.print(",");
    dataFile.print(my, 2);
    dataFile.print(",");
    dataFile.println(mz, 2);

    // Ensure data is flushed to the SD card
    dataFile.flush();
    Serial.println("Data written to file.");
  } else {
    Serial.println("Failed to write to the file.");
  }

  delay(1000); // Log data every second
}

// Function to create a unique filename based on existing files
String createUniqueFilename() {
  String filename;
  int fileIndex = 0;
  while (true) {
    // Format the filename (e.g., data000.csv, data001.csv, ...)
    filename = String("data") + String(fileIndex, DEC) + ".csv";

    // Check if the file exists
    if (!SD.exists(filename.c_str())) {
      return filename; // Return the first non-existing filename
    }
    fileIndex++; // Increment the index if the file exists
  }
}
