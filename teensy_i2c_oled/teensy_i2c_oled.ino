#include <Wire.h>
#include <U8g2lib.h>

U8G2_SSD1306_128X32_UNIVISION_F_SW_I2C u8g2(U8G2_R0, /* clock=*/ SCL, /* data=*/ SDA);

void showLoadingBar(int percentage) {
  int barWidth = 128; // Width of the loading bar
  int barHeight = 8;  // Height of the loading bar
  int filledWidth = map(percentage, 0, 100, 0, barWidth);

  u8g2.clearBuffer();
  u8g2.setFont(u8g2_font_ncenB08_tr);

  // Draw the loading text with percentage
  u8g2.drawStr(0, 10, "Loading: ");
  u8g2.setCursor(100, 10); // Adjust the cursor position for the percentage
  u8g2.print(percentage);
  u8g2.print("%");

  // Draw the background of the loading bar (empty part)
  u8g2.drawFrame(0, 20, barWidth, barHeight);  // Use drawFrame instead of drawBox for background

  // Draw the filled portion of the loading bar
  u8g2.drawBox(0, 20, filledWidth, barHeight);

  u8g2.sendBuffer();
}

void setup() {
  u8g2.begin();
  int loadingTime = 5000; // Total loading time in milliseconds
  int steps = 100;        // Number of steps in the loading process
  int interval = loadingTime / steps;

  for (int i = 0; i <= steps; i++) {
    int percentage = map(i, 0, steps, 0, 100);
    showLoadingBar(percentage);
    delay(interval);
  }
}

void loop() {
}
