#include "DHT.h"
#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <FirebaseESP8266.h>
#define LED_PIN1 D1           // Define LED_PIN D1 (GPIO5)
#define LED_PIN2 D2           // Define the pin connected to the LED
#define DHT_PIN D5           // Define the pin connected to the DHT sensor

const char* ssid = "Marawan";  // Replace with your WiFi network name
const char* password = "Mony@2481@2525";  // Replace with your WiFi password
const char* broker = "192.168.1.3";  // Replace with your MQTT broker address
const int port = 1883;

FirebaseData fb;

const char* FIREBASE_HOST = "iot-project-582b8-default-rtdb.firebaseio.com";
const char* FIREBASE_AUTH = "wpBLXBaoBE3b03q7F4kQFWwYLKqZUmlBBeucbXL2";

const char* topic1 = "temp";
const char* topic2 = "humid";
const char* topic3 = "photo";
const char* topic4 = "time";   // New topic for publishing current time

// Define the variables
float temp;
float humid;
int photo;  // Define a that holds a the photoresistor reading
int threshold = 100; // Define a threshold variable

DHT dht(DHT_PIN, DHT11);     // Initialize DHT sensor object with pin and sensor type
WiFiClient espClient;
PubSubClient client(espClient);

void setup() {
  Serial.begin(9600);        // Start serial monitor
  pinMode(LED_PIN1, OUTPUT);   // Set LED_PIN as an output pin
  pinMode(LED_PIN2, OUTPUT);   // Set LED_PIN as an output pin

  WiFi.begin(ssid, password);  // Connect to WiFi
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH); // Initialize Firebase connection
  Firebase.reconnectWiFi(true);

  client.setServer(broker, port);
  client.connect("NodeMCU_Publisher");
  Serial.println("Connected to MQTT broker.");
}

void loop() {
  photo = analogRead(A0);  // Read the brightness of the light

  temp = dht.readTemperature();
  humid = dht.readHumidity();

  // LED control logic based on light level
  if (photo < threshold) {
    digitalWrite(LED_PIN1, HIGH);  // Turn on LED1
    digitalWrite(LED_PIN2, HIGH);   // Turn off LED2 (optional for dual LED control)
  } else {
    digitalWrite(LED_PIN1, LOW);   // Turn off LED1
    digitalWrite(LED_PIN2, LOW);   // Turn off LED2
  }

  // Convert sensor data and time to strings
  char message1[10];  // Buffer to hold the message
  char message2[10];  // Buffer to hold the message
  char message3[10];  // Buffer to hold the message
  char message4[9];   // Buffer to hold the time string
  dtostrf(temp, 4, 2, message1);
  dtostrf(humid, 4, 2, message2);
  dtostrf(photo, 4, 2, message3);
  
  // Publish data to MQTT topics
  client.publish(topic1, message1);
  client.publish(topic2, message2);
  client.publish(topic3, message3);

  // Print sensor data and time to serial monitor
  // Serial.println("Temperature: " + String(message1));
  // Serial.println(" Humidity: " + String(message2));
  // Serial.println(" photoresistor: " + String(message3));

  if(Firebase.setFloat(fb, "/photo", photo) || Firebase.setFloat(fb, "/humid", humid) || Firebase.setFloat(fb, "/temp", temp)){   // Set temperature value in the Firebase under the "/temp" path
    // Print sensor data and time to serial monitor
    Serial.println("Temperature: " + String(message1));
    Serial.println(" Humidity: " + String(message2));
    Serial.println(" photoresistor: " + String(message3));
  }
  else                                          // If Firebase operation fails,
    {Serial.println(fb.errorReason()); }        // Print the error reason

  delay(2000);  // Short
}
