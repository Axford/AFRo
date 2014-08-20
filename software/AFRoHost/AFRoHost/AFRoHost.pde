import processing.serial.*;
import controlP5.*;

ControlP5 cp5;
PFont f;

DropdownList dlSerialPorts;
StringList serialLog;
Serial port; 


void setup() {
  size(700, 400,P3D);
  f = createFont("Arial",11,true); 
  
  cp5 = new ControlP5(this);
  
  // Configure Serial Ports Dropdown
  // -------------------------------
  dlSerialPorts = cp5.addDropdownList("dlSerialPorts")
          .setPosition(5, 25)
          .setWidth(200)
          ;
  dlSerialPorts.captionLabel().set("Choose a Serial Port");
  customize(dlSerialPorts);
  // Get list of ports
  dlSerialPorts.addItems(Serial.list());
  
  // Connect button
  cp5.addButton("Connect")
     .setValue(0)
     .setPosition(220,5)
     .setSize(50,20)
     ;
  
  // Configure serialLog
  serialLog = new StringList();
  serialLog.append("Log");
  serialLog.append("---");
}

public void Connect(int theValue) {
   port = new Serial(this, Serial.list()[int(dlSerialPorts.getValue())], 115200);
   port.bufferUntil(10);  // line feed
}


void customize(DropdownList ddl) {
  // a convenience function to customize a DropdownList
  ddl.setBackgroundColor(color(190));
  ddl.setItemHeight(20);
  ddl.setBarHeight(20);
  ddl.captionLabel().style().marginTop = 3;
  ddl.captionLabel().style().marginLeft = 3;
  ddl.valueLabel().style().marginTop = 3;
  ddl.setColorBackground(color(60));
  ddl.setColorActive(color(255, 128));
}

void serialEvent(Serial p) { 
  String s = p.readString(); 
  serialLog.append(s);
  if (serialLog.size() > 20) serialLog.remove(0);
}


void keyPressed() {
  if (key=='1') {
    
  } 
  
}

void controlEvent(ControlEvent theEvent) {
  // DropdownList is of type ControlGroup.
  // A controlEvent will be triggered from inside the ControlGroup class.
  // therefore you need to check the originator of the Event with
  // if (theEvent.isGroup())
  // to avoid an error message thrown by controlP5.

  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
  } 
  else if (theEvent.isController()) {
    println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
  }
}

void draw() {
  background(128);
  textFont(f,11);
  
  // Draw serialLog
  fill(0);
  for (int i=0; i<serialLog.size(); i++) {
    String s = serialLog.get(i);
    text(s, 10, 40 + i*15); 
  }
}
