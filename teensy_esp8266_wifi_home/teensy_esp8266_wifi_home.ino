#include <ESP8266WiFi.h>

// Replace with your Wi-Fi credentials
#ifndef STASSID
#define STASSID "your-ssid"
#define STAPSK "your-password"
#endif

const char* ssid = STASSID;
const char* password = STAPSK;

// Create an instance of the server
WiFiServer server(80);

void setup() {
  Serial.begin(9600);
  delay(1000); // Allow time for the serial monitor to initialize

  // Connect to Wi-Fi
  Serial.println();
  Serial.println();
  Serial.print(F("Connecting to "));
  Serial.println(ssid);

  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(F("."));
  }

  Serial.println();
  Serial.println(F("WiFi connected"));

  // Print the ESP8266 IP address
  Serial.println(F("IP address: "));
  Serial.println(WiFi.localIP());

  // Start the server
  server.begin();
  Serial.println(F("Server started"));
}

void loop() {
  // Check if a client has connected
  WiFiClient client = server.available();
  if (!client) {
    return;
  }

  // Wait until the client sends some data
  Serial.println(F("New client connected"));
  while (!client.available()) {
    delay(1);
  }

  // Read the request
  String request = client.readStringUntil('\r');
  Serial.println(F("Client request:"));
  Serial.println(request);
  client.flush();

  // Print the client's IP address to the serial console
  Serial.print(F("Client IP address: "));
  Serial.println(client.remoteIP());

  // Send an HTTP response with "Hello, World!"
  client.println(F("HTTP/1.1 200 OK"));
  client.println(F("Content-Type: text/html"));
  client.println();
  client.println(F("<!DOCTYPE html>"));
  client.println(F("<html>"));
  client.println(F("<head><title>Hello, World!</title></head>"));
  client.println(F("<body><h1>Hello, World!</h1></body>"));
  client.println(F("</html>"));
  client.println();

  // Close the connection
  client.stop();
  Serial.println(F("Client disconnected."));
}
