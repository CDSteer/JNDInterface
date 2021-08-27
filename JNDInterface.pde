import processing.serial.*;
import java.sql.Timestamp;
import java.util.Random;

import java.util.Scanner;

Serial myPort;        // The serial port

Session m_Session;

Button whiteBtn = new Button(250, 300, 100, 100, "White");
Button blackBtn =  new Button(550, 300, 100, 100, "Black");

void setup(){
  // set the window size:
  size(800, 600);  
  System.out.println(Serial.list()[2]);
  String portName = Serial.list()[2]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);  
  
  
  String m_pNum = getString("Participant Number?");
  int m_startValue = getInt("Starting Stimuli?");
  int m_staircaseOrder = getInt("Up (0) or Down (1)?");
  
  m_Session = new Session(m_pNum, m_startValue, m_staircaseOrder);
}

void draw(){
  Random rand = new Random(); //instance of random class
  int upperbound = 2;
  int int_random = rand.nextInt(upperbound);
  //System.out.println(int_random);
  
  whiteBtn.drawBtn();
  blackBtn.drawBtn();
}


void serialEvent (Serial myPort) {
  String inString = myPort.readStringUntil('\n');
  System.out.println(inString);
  if (inString != null) {
    
  }
}

void mousePressed() {
  myPort.write("1");
  if (blackBtn.overBtn(mouseX, mouseY)){
    
  } else if (whiteBtn.overBtn(mouseX, mouseY)){
    
  }
}
