#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>

// Replace with your network credentials
const char* ssid = "Brown_Bear";
const char* password = "5n!cKer*";

ESP8266WebServer server(80); // Set up the server on port 80

void setup() {
  // Start the serial communication
  Serial.begin(115200);
  delay(10);

  // Connect to Wi-Fi network
  WiFi.begin(ssid, password);
  Serial.print("Connecting to WiFi");

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("Connected!");
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP()); // Display the ESP's IP address

  // Define the route for the root URL "/"
  server.on("/", HTTP_GET, handleRoot);

  // Start the server
  server.begin();
  Serial.println("HTTP server started");
}

void loop() {
  // Handle incoming client requests
  server.handleClient();
}

// Function to handle root "/" URL and send "Hello, World!"
void handleRoot() {
  server.send(200, "text/plain", "Hello, World!");
}
