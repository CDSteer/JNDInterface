import processing.serial.*;
import java.sql.Timestamp;
import java.util.Random;
import java.util.Scanner;


Serial prototypeConnectionA;
Serial prototypeConnectionB;

Session m_Session;

Button btnA = new Button(150, 300, 200, 100, "White (A)");
Button btnB =  new Button(450, 300, 200, 100, "Black (B)");

void setup(){
  size(800, 600);
  System.out.println("A: " + Serial.list()[2]);
  System.out.println("B: " + Serial.list()[3]);
  // prototypeConnectionA = new Serial(this, Serial.list()[2], 9600);
  // prototypeConnectionB = new Serial(this, Serial.list()[3], 9600);


  setUpSession();

  delay(1000);
  // sendValues();
  delay(1000);
}

void draw(){
  background(0);
  btnA.drawBtn();
  btnB.drawBtn();

  text("Trails: " + String.valueOf(m_Session.getTrailCount())+"/"+m_Session.MAX_TRAILS, 200, 100);
  text("Reversals: " + String.valueOf(m_Session.getReversalCount())+"/"+m_Session.MAX_REVERSALS, 500, 100);


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
    // sendValues();
    m_Session.setUpdatePrototypes(false);
    delay(1000);
  }
}

void mousePressed() {
  if (btnA.overBtn(mouseX, mouseY)) {
    m_Session.newAnswer(0);
    background(0);
  } else if (btnB.overBtn(mouseX, mouseY)) {
    m_Session.newAnswer(1);
    background(0);
  }
}

void sendValues(){
  m_Session.setUpdatePrototypes(true);
  if (m_Session.getCurrentTrail().getRefPrototype().getOrder() == 0) {
    prototypeConnectionA.write(String.valueOf(m_Session.getCurrentTrail().getRefPrototype().getServoValue()));
    delay(100);
    prototypeConnectionB.write(String.valueOf(m_Session.getCurrentTrail().getControlPrototype().getServoValue()));
    delay(100);
  } else {
    prototypeConnectionB.write(String.valueOf(m_Session.getCurrentTrail().getRefPrototype().getServoValue()));
    delay(100);
    prototypeConnectionA.write(String.valueOf(m_Session.getCurrentTrail().getControlPrototype().getServoValue()));
    delay(100);
  }
  m_Session.setUpdatePrototypes(false);
}

void setUpSession(){
  String m_pNum = getString("Participant Number?");
  int m_startValue = getInt("Starting Stimuli?");
  int m_staircaseOrder = getInt("Up (0) or Down (1)?");
  m_Session = new Session(m_pNum, m_startValue, m_staircaseOrder);
}
