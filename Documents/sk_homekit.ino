/*
   ESP8266 HTTP Lock by Yan
   Make a Siri HomeKit enabled lock with ESPea (https://blog.aprbrother.com/product/espea)
   This example code is in the public domain
*/

#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>

#define RELAY_PIN 2     // wire D2 to relay 

const char* ssid        = "Remit_STAFF";
const char* password    = "t1mf0rW3st";
const long  lockTimeout = 3000;
const int on = 1;
const int off = 0;

ESP8266WebServer server(80);
long unlockedTime = 0;

void handleStatus() {
  char rsp[255];
  sprintf(rsp, "{\"state\":\"%d\",\"statusCode\":200}", digitalRead(RELAY_PIN) ? on : off);
  server.send(200, "text/plain", rsp);
  Serial.println(rsp);
}

void handleOn() {
  digitalWrite(RELAY_PIN, on);
  digitalWrite(4, on);
  handleStatus();
}

void handleOff() {
  digitalWrite(RELAY_PIN, off);
  digitalWrite(4, off);
  handleStatus();
}

void setup() {
  Serial.begin(115200);
  pinMode(RELAY_PIN, OUTPUT);
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);

  Serial.println("");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  server.on("/on", HTTP_GET, handleOn);
  server.on("/off", HTTP_GET, handleOff);
  server.on("/status", HTTP_GET, handleStatus);

  server.begin();

  digitalWrite(RELAY_PIN, off);
  handleStatus();
}

void loop() {
  server.handleClient();
}
