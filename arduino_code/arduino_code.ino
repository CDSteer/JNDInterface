#include <AnalogSmooth.h>
// Window size can range from 1 - 100
AnalogSmooth as100 = AnalogSmooth(10);

int fsrAnalogPin = 0; // FSR is connected to analog 0
int LEDpin = 11;      // connect Red LED to pin 11 (PWM pin)
int fsrReading;       // the analog reading from the FSR resistor divider
int LEDbrightness;

int actNeg  = 5;  // Pin 14 of L293
int actPos  = 6;  // Pin 10 of L293

int actuation;
int incomingByte;
int hall;

int lastPos;

void setActuatorPos(int pos){
  lastPos = pos;
  actuation = analogRead(A1);
  while (actuation != pos){
    if (actuation > pos) {
      digitalWrite(actNeg, HIGH);
      digitalWrite(actPos, LOW);
    }
    if (actuation < pos) {
      digitalWrite(actNeg, LOW);
      digitalWrite(actPos, HIGH);
    }
    actuation = analogRead(A1);
    // Serial.println(actuation);
    digitalWrite(actNeg, LOW);
    digitalWrite(actPos, LOW);
  }
  Serial.print("p: ");
  Serial.println(actuation);
  float mm = map(actuation, 0.0, 1013.0, 0.0, 51.0);
  Serial.print("mm: ");
  Serial.println(mm, 2);

}
 
void setup(void) {
  Serial.begin(9600);   // We'll send debugging information via the Serial monitor
  pinMode(LEDpin, OUTPUT);

  //Set pins as outputs
  pinMode(actNeg, OUTPUT);
  pinMode(actPos, OUTPUT);  

  pinMode(A0, INPUT);
  pinMode(A1, INPUT);
  actuation = analogRead(A1); 
    
  
  //full retraction
  while (actuation != 0){
    digitalWrite(actNeg, HIGH);
    digitalWrite(actPos, LOW);
    actuation = analogRead(A1);
    // Serial.println(actuation);
  }
  
  //And this code will stop motors
  digitalWrite(actNeg, LOW);
  digitalWrite(actPos, LOW);
  Serial.println("ready!");
}

void loop(void) {
  actuation = analogRead(A1);
  // Serial.println(actuation);
  
  if (Serial.available() > 0) {
    // read the incoming byte:
    incomingByte = Serial.parseInt();
    Serial.flush();

    // say what you got:
    Serial.print("Pos: ");
    Serial.println(incomingByte);
  }
  if (incomingByte>0) setActuatorPos(incomingByte);
  // if (actuation != lastPos) setActuatorPos(lastPos);
  delay(100);
}
