#include <WiFi.h>  // Wi-Fi library

// Replace with your network credentials
#define EAP_IDENTITY "user"  // Your Eduroam identity
#define EAP_USERNAME "user"  // Often the same as the identity
#define EAP_PASSWORD "pass"  // Your Eduroam password

const char* ssid = "ERAUStudents";  // Eduroam SSID

WiFiServer server(80);  // Web server on port 80
int counter = 0;

void setup() {
  Serial.begin(115200);  // Start serial communication for debugging
  delay(10);
  Serial.println();
  Serial.print("Connecting to network: ");
  Serial.println(ssid);

  // Disconnect and reinitialize Wi-Fi for new credentials
  WiFi.disconnect(true);
  WiFi.mode(WIFI_STA);  // Set Wi-Fi mode to Station (client)

  // Connect to Wi-Fi using WPA2-PEAP
  WiFi.begin(ssid, WPA2_AUTH_PEAP, EAP_IDENTITY, EAP_USERNAME, EAP_PASSWORD);

  // Wait for connection without using delays
  while (WiFi.status() != WL_CONNECTED) {
    counter++;
    if (counter >= 60) {  // Timeout after 30 seconds
      ESP.restart();
    }
    delay(100);  // Small delay to prevent excessive CPU usage
  }

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());  // Print ESP32 IP address

  // Start the server
  server.begin();
}

void loop() {
  // Ensure the device is still connected to Wi-Fi
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("Wi-Fi disconnected, reconnecting...");
    WiFi.begin(ssid);  // Reconnect if Wi-Fi is lost
    return;
  }

  // Listen for incoming clients
  WiFiClient client = server.available();
  if (client) {
    Serial.println("New client connected");

    // Read the client's request
    String request = client.readStringUntil('\r');
    Serial.println(request);

    // Serve a simple HTML page with "Hello World"
    if (request.indexOf("GET / ") != -1) {
      // Send HTTP response with HTML content
      client.println("HTTP/1.1 200 OK");
      client.println("Content-Type: text/html");
      client.println("Connection: close");
      client.println();  // Blank line between headers and body
      client.println("<html><body><h1>Hello World!</h1><p>Welcome to the ESP32 Web Server</p></body></html>");
    }

    // Close the connection after responding
    client.stop();
    Serial.println("Client disconnected");
  }
}
