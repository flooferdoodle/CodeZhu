/*
BLUETOOTH CONNECTION CODE

HC05 Test - Works! - 12.13.20

idk what BT does or why it's there but it would seem that in my attempts to remove it, the code breaks


Steps to get working:

(if you need to upload new code follow steps 1-6. else, skip to 7)
1. plug arduino in using serial cable
2. select correct com
3. remove rx and tx and upload
4. open serial monitor and check if it works
5. close monitor, replug rx and tx, and unplug serial cord
6. turn on battery

7. go to settings>bluetooth/devices, find HC05, and remove it
8. go to add bluetooth device - click HC05 and insert 1234 as password
9. once connected, the light on the hc05 should go from rapid blinking to a short blink followed by a long pause
10. go to control panel>devices and hardware and find the HC05
11. right click>properties>hardware and check what serial port it is on. If there's no option for "Standard serial over bluetooth port," you probably want to restart the computer

12. go back to arduino and select com port the hc05 is on
13. open serial monitor and it should work

*/


//code write by Moz for YouTube changel LogMaker360, 27-10-2015
//code belongs to this video: https://www.youtube.com/watch?v=6jZMJ7DFCY0

#include <SoftwareSerial.h>
SoftwareSerial BT(1, 0);
// creates a "virtual" serial port/UART
// connect BT module TX to 0
// connect BT module RX to 1
// connect BT Vcc to 5V, GND to GND
void setup()
{
  // set digital pin to control as an output
  pinMode(13, OUTPUT);
  // set the data rate for the SoftwareSerial port
  BT.begin(9600);
  Serial.begin(9600);
  // Send test message to other device
  BT.println("Hello from Arduino");
  Serial.println("sHello from Arduino");
}
char a; // stores incoming character from other device
void loop()

if (Serial.available())
  // if text arrived in from BT serial...
{
  a = (Serial.read());
  if (a == '1')
  {
    digitalWrite(13, HIGH);
    Serial.println("s LED on");
  }
  if (a == '2')
  {
    digitalWrite(13, LOW);
    Serial.println("s LED off");
  }
  if (a == '?')
  {
    Serial.println("s Send '1' to turn LED on");
    Serial.println("s Send '2' to turn LED on");
  }
  // you can add more "if" statements with other characters to add more commands
}
}

