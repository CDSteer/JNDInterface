import processing.serial.*;
import java.sql.Timestamp;
import java.util.Random;
import java.util.Scanner;

Serial prototypeConnection1;
Serial prototypeConnection2;

Session m_Session;

Button whiteBtn = new Button(150, 300, 200, 100, "White");
Button blackBtn =  new Button(450, 300, 200, 100, "Black");

void setup(){
  size(800, 600);
  System.out.println(Serial.list()[2]);
  System.out.println(Serial.list()[3]);
  prototypeConnection1 = new Serial(this, Serial.list()[2], 9600);
  prototypeConnection2 = new Serial(this, Serial.list()[3], 9600);
  String m_pNum = getString("Participant Number?");
  int m_startValue = getInt("Starting Stimuli?");
  int m_staircaseOrder = getInt("Up (0) or Down (1)?");
  m_Session = new Session(m_pNum, m_startValue, m_staircaseOrder);

  delay(1000);

  // sendValues();
  delay(1000);
}

void draw(){
  background(0);
  blackBtn.drawBtn();
  whiteBtn.drawBtn();

  if (m_Session.getCurrentTrail().getRefPrototype().getOrder() == 0) {
    text("Reference: " + String.valueOf(m_Session.getCurrentTrail().getRefPrototype().getServoValue()), 200, 300);
    text("Contol: " + String.valueOf(m_Session.getCurrentTrail().getControlPrototype().getServoValue()), 500, 300);
  } else {
    text("Contol: " + String.valueOf(m_Session.getCurrentTrail().getControlPrototype().getServoValue()), 200, 300);
    text("Reference: " + String.valueOf(m_Session.getCurrentTrail().getRefPrototype().getServoValue()), 500, 300);
  }

  while (m_Session.getUpdatePrototypes()){
    background(0);
    text("updating", 400, 300);
    sendValues();
    m_Session.setUpdatePrototypes(false);
    delay(1000);
  }
}

void mousePressed() {
  if (whiteBtn.overBtn(mouseX, mouseY)) {
    m_Session.newAnswer(0);
    background(0);
  } else if (blackBtn.overBtn(mouseX, mouseY)) {
    m_Session.newAnswer(1);
    background(0);
  }
}

void sendValues(){
  m_Session.setUpdatePrototypes(true);
  if (m_Session.getCurrentTrail().getRefPrototype().getOrder() == 0) {
    prototypeConnection1.write(String.valueOf(m_Session.getCurrentTrail().getRefPrototype().getServoValue()));
    delay(100);
    prototypeConnection2.write(String.valueOf(m_Session.getCurrentTrail().getControlPrototype().getServoValue()));
    delay(100);
  } else {
    prototypeConnection2.write(String.valueOf(m_Session.getCurrentTrail().getRefPrototype().getServoValue()));
    delay(100);
    prototypeConnection1.write(String.valueOf(m_Session.getCurrentTrail().getControlPrototype().getServoValue()));
    delay(100);
  }
  m_Session.setUpdatePrototypes(false);
}
