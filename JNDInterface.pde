import processing.serial.*;
import java.sql.Timestamp;
import java.util.Random;

import java.util.Scanner;

Serial prototypeConnection1;
Serial prototypeConnection2;


Session m_Session;

Button whiteBtn = new Button(250, 300, 100, 100, "White");
Button blackBtn =  new Button(550, 300, 100, 100, "Black");

void setup(){
  // set the window size:
  size(800, 600);
  System.out.println(Serial.list()[2]);
  // prototypeConnection1 = new Serial(this, Serial.list()[2], 9600);
  // prototypeConnection2 = new Serial(this, Serial.list()[3], 9600);


  String m_pNum = getString("Participant Number?");
  int m_startValue = getInt("Starting Stimuli?");
  int m_staircaseOrder = getInt("Up (0) or Down (1)?");

  m_Session = new Session(m_pNum, m_startValue, m_staircaseOrder);
}

void draw(){
  background(0);
  whiteBtn.drawBtn();
  blackBtn.drawBtn();

  while (m_Session.updatePrototypes){
    background(0);
    text("updating", 400, 300);
    // myPort.write("1");
    // write to Prototypes
    delay(1000);
    m_Session.setUpdatePrototypes(false);
  }
}


void serialEvent (Serial myPort) {
  String inString = myPort.readStringUntil('\n');
  System.out.println(inString);
  if (inString != null) {

  }
}

void mousePressed() {

  if (blackBtn.overBtn(mouseX, mouseY)) {
    this.m_Session.newAnswer(0);
    System.out.println("Black Btn");
  }
  if (whiteBtn.overBtn(mouseX, mouseY)){
    this.m_Session.newAnswer(1);
    System.out.println("White Btn");
  }
}
