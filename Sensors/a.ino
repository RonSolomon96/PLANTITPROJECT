#include<ESP8266WiFi.h>
#include <WiFiUdp.h>
#include <DHT.h>
#include <Adafruit_Sensor.h>
#define Type DHT11
//set pins 
int DHTPin = D5;
int ledPin = D6;
//set humidity and temperatue sensor
DHT HT(DHTPin, Type);

float humidity;
float temp;
//set lightread pin
int lightPin = A0;
int lightRead;

//set wifi
WiFiUDP Udp;
int x = 2;
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  WiFi.mode(WIFI_STA);
  WiFi.begin("Galaxyron","xlue5552");
Serial.print("connecting...");
while(WiFi.status() != WL_CONNECTED){
Serial.print(WiFi.status());
delay(1000);

}
pinMode(lightPin,INPUT);
pinMode(ledPin,OUTPUT);
//set the light to high
digitalWrite(ledPin,HIGH);
Serial.print("IP:");
Serial.println(WiFi.localIP());
Serial.print("Mac");
Serial.println(WiFi.macAddress());
// begin udp port 
Udp.begin(12346);
// begin sensor 
HT.begin();

}

void loop() {
lightRead = analogRead(lightPin);
humidity = HT.readHumidity();
temp = HT.readTemperature();
 char buffer[50];
 sprintf(buffer, "lightRead:%d:humidity:%f:temperature:%f", lightRead, humidity, temp);
Serial.println(buffer);

    Udp.beginPacket("255.255.255.255", 12345);
    Udp.write(buffer);
    Udp.endPacket();

    delay(1000);

}
