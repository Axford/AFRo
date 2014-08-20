#include <ax12.h>

#define Z_STEP_PIN         A0
#define Z_DIR_PIN          A1
#define Z_ENABLE_PIN       38


void enable_z() {
   //WRITE(Z_ENABLE_PIN, LOW);
   digitalWrite(Z_ENABLE_PIN, LOW);
}

void disable_z() {
   //WRITE(Z_ENABLE_PIN, HIGH); 
}

void setup() {
 

  Serial.begin (115200);  // inicializa el Serial a 115,2 Kb/s
  ax12Init(1000000);   // inicializa los AX12 a 1 Mb/s

  pinMode(Z_ENABLE_PIN, OUTPUT);
  pinMode(Z_STEP_PIN, OUTPUT);  
  pinMode(Z_DIR_PIN, OUTPUT);
  
  pinMode(13, OUTPUT);

  enable_z();    
}

void step_z() {
   digitalWrite(Z_STEP_PIN, true);
   digitalWrite(Z_STEP_PIN, false);
}

int vel = 1;
int maxVel = 200;
int i = 0;

void loop() {
  
    //digitalWrite(13, true);

    step_z();  
   
    
    //digitalWrite(13, false);
   delay(1);    
   
   i++;

   if (i>1000) {
       i = 0;
 
       
       
       motor2.setVel(100);
       motor2.setPos(random(300,800));
       
       motor1.setVel(100);
       motor1.setPos(random(300,800));
   }   
}
