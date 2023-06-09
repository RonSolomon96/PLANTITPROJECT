#include<ESP8266WiFi.h>
#include <WiFiUdp.h>
#include <Adafruit_Sensor.h>
//set pins
int ledPin = D6;

float humidity;
float temp;
int moistPin = A0;
int moistRead;

//set wifi
WiFiUDP Udp;
int x = 2;
void setup() {

  Serial.begin(9600);
  WiFi.mode(WIFI_STA);
  WiFi.begin("Galaxyron","xlue5552");
Serial.print("connecting...");
while(WiFi.status() != WL_CONNECTED){
Serial.print(WiFi.status());
delay(1000);

}
pinMode(moistPin,INPUT);
pinMode(ledPin,OUTPUT);
digitalWrite(ledPin,HIGH);
Serial.print("IP:");
Serial.println(WiFi.localIP());
Serial.print("Mac");
Serial.println(WiFi.macAddress());
//begin udp
Udp.begin(12346);


}

void loop() {
moistRead = analogRead(moistPin);

 char buffer[50];
 sprintf(buffer, "moist:%d:id:1", moistRead);
Serial.println(buffer);

    Udp.beginPacket("255.255.255.255", 5002);
    Udp.write(buffer);
    Udp.endPacket();

    delay(1000);

}
