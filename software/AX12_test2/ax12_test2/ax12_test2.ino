#include <ax12.h>

// using X driver on RAMPS 1.4....

/*
#define Z_STEP_PIN         A0
#define Z_DIR_PIN          A1
#define Z_ENABLE_PIN       38
*/

/*
// E0
#define Z_STEP_PIN         26
#define Z_DIR_PIN          28
#define Z_ENABLE_PIN       24

*/

// E1 on RAMPS 1.4
#define Z_STEP_PIN         36
#define Z_DIR_PIN          34
#define Z_ENABLE_PIN       30

// SAM-3 Servo interface



AX12 motor1;
AX12 motor2;
AX12 motor3;

int spoonTorq = 2;
int spoonID = 0;

void enable_z() {
   //WRITE(Z_ENABLE_PIN, LOW);
   digitalWrite(Z_ENABLE_PIN, LOW);
}

void disable_z() {
   //WRITE(Z_ENABLE_PIN, HIGH); 
   digitalWrite(Z_ENABLE_PIN, HIGH);
}

void setup() {
 
  motor1 = AX12();
  motor2 = AX12();
  motor3 = AX12();

  Serial.begin (115200);  // inicializa el Serial a 115,2 Kb/s
  AX12::init (1000000);   // inicializa los AX12 a 1 Mb/s

  motor1.id = 3; 
  motor1.SRL = RETURN_READ;
 
  motor2.id = 2;  
  motor2.SRL = RETURN_ALL;
  
  motor3.id = 1;  
  motor3.SRL = RETURN_ALL;
  
  pinMode(Z_ENABLE_PIN, OUTPUT);
  pinMode(Z_STEP_PIN, OUTPUT);  
  pinMode(Z_DIR_PIN, OUTPUT);
  
  pinMode(13, OUTPUT);

  enable_z();    
  //disable_z();
  
  noInterrupts();
  
  // set up Timer 1
  TCCR1A = 0;          // normal operation
  TCCR1B = bit(WGM12) | bit(CS11);   // CTC, scale / 8
  //OCR1A =  625;       // compare A register value, approx 1 RPM with 200 steps per rev and 16x microstepping
  // ORC1A =     // 1 RPM with 200 steps per rev and 2x microstepping
  OCR1A = 500;
  TIMSK1 = bit (OCIE1A);             // interrupt on Compare A Match
  
  // set up Timer 3
  TCCR3A = 0;          // normal operation
  TCCR3B = bit(WGM12) | bit(CS12) | bit(CS10);   // CTC, scale / 1024
  OCR3A =  156;       // compare A register value, approx 100 Hz
  TIMSK3 = bit (OCIE3A);             // interrupt on Compare A Match
  
  // set default velocities
  motor1.setVel(200);
  motor2.setVel(200);
  motor3.setVel(200);
  
  // set initial torques
  motor1.setTorque(500);
  motor2.setTorque(400);
  motor3.setTorque(200);
  
  // set initial positions
  motor1.setPos(512);
  motor2.setPos(512);
  motor3.setPos(512);
  
  // punch
  motor1.writeInfo(PUNCH, 60);
  motor2.writeInfo(PUNCH, 50);
  
  // compliance margins
  motor1.writeInfo(CW_COMPLIANCE_MARGIN, 0);
  motor1.writeInfo(CCW_COMPLIANCE_MARGIN, 0);
 
  // compliance slopes
  motor1.writeInfo(CW_COMPLIANCE_SLOPE, 64);
  motor1.writeInfo(CCW_COMPLIANCE_SLOPE, 64);
  
  // compliance margins
  motor2.writeInfo(CW_COMPLIANCE_MARGIN, 0);
  motor2.writeInfo(CCW_COMPLIANCE_MARGIN, 0);
 
  // compliance slopes
  motor2.writeInfo(CW_COMPLIANCE_SLOPE, 32);
  motor2.writeInfo(CCW_COMPLIANCE_SLOPE, 32);
  
  // compliance margins
  motor3.writeInfo(CW_COMPLIANCE_MARGIN, 0);
  motor3.writeInfo(CCW_COMPLIANCE_MARGIN, 0);
 
  // compliance slopes
  motor3.writeInfo(CW_COMPLIANCE_SLOPE, 16);
  motor3.writeInfo(CCW_COMPLIANCE_SLOPE, 16);

  
  
  
  Serial3.begin(115200);
  
  // spoon - set speed
   int tmp1 = 0xE0 | 0;
   int tmp2 = 0x0D;
   int tmp3 = 1;
   int tmp4 = 20;
   int checksum = (tmp1 ^ tmp2 ^ tmp3 ^ tmp4) & 0x7f;
   Serial3.write(0xff);
   Serial3.write(tmp1);
   Serial3.write(tmp2);
   Serial3.write(tmp3);
   Serial3.write(tmp4);
   Serial3.write(checksum);
  
  Serial.begin(115200);
  
  delay(1000); // give them time to get there
  
  // enable interrupts
  interrupts();
}

long stepCount = 0;
long stepTimer = 500;


void step_z() {
   
   if (stepCount % 30 == 0 && stepTimer > 120) {
      stepTimer--;
      //OCR1A = stepTimer; 
   }
  
   if (stepCount < (long)3200 * 15) {
  
     digitalWrite(Z_STEP_PIN, true);
     digitalWrite(Z_STEP_PIN, false);
   
   }
   
   stepCount++;
   
   if (stepCount > (long)3200 * 16) {
      digitalWrite(Z_DIR_PIN, !digitalRead(Z_DIR_PIN)); 
      stepCount = 0;
      stepTimer = 500;
   }
}

int vel = 1;
int maxVel = 200;
int i = 0;


volatile boolean moveDone = true;
int startPos = 512;
int endPos = 512;
int posChange = 0;
int eventCount = 10 * 2;
int events = 0;


ISR(TIMER1_COMPA_vect)
{
  step_z();
}



float v0 = 10;  // jerk velocity
float v2 = 0;
float v3 = v0;
float t1, t2, t3, t4;
float d1,d2;
float tplateau;
float up, plateau, down;
float distance, vmax, a;
int accelerateUntil, decelerateAfter;

void printStrFloat(char *s, float v) {
  Serial.print(s);
  Serial.print(":");
  Serial.println(v);
}

float intersectionDistance(float s1, float s2, float a, float d) {
  return (2*a*d - s1*s1 + s2*s2) / (4*a);
}

void prepTrapezoid() {
  // assumes t0=0
  t1 = (vmax-v0) / a;  // time from v0 to vmax (time to reach full speed)
  t4 = (vmax-v3) / a; // time from vmax to v3 (time to brake)
  d1 = v0*t1 + 0.5*a*t1*t1;  // distance t0-t1
  d2 = v3*t4 + 0.5*a*t4*t4;  // distance t2-t3
  
  printStrFloat("d1",d1);
  printStrFloat("d2",d2);
  

  if( d1+d2 < distance ) {
    // plateau at vmax in the middle
    tplateau = ( distance - d1 - d2 ) / vmax; // duration of plateau
    t2 = t1 + tplateau;
    t3 = t2 + t4;
  } else {
    // start breaking before reaching vmax
    Serial.println("no coasting");
    
    float id = intersectionDistance(v0,v3,a,distance);
    printStrFloat("id",id);
   
    t1 = sqrt(2*abs(id)/a);
    t2 = t1;
    t3 = t2 + sqrt(2*abs(distance-id)/a);
    /*
    t1 = ( sqrt( 2.0*a*d2 + v0*v0 ) - v0 ) / a;
    t2 = t1;
    t3 = t2 + ( sqrt( 2.0*a*(distance-d2) + v3*v3 ) - v3 ) / a;
   */
  }
  
  accelerateUntil = round(t1 * 10);
  decelerateAfter = round(t2 * 10);
}

int getTrapezoidPos(float t) {
  if(t<t1) {
    return round(v0*t + 0.5*a*t*t);
  } 
  else if(t<t2) {
    up = v0*t1 + 0.5*a*t1*t1;
    plateau = vmax*(t-t1);
    return round(up + plateau);
  } 
  else if(t<=t3) {
    up = v0*t1 + 0.5*a*t1*t1;  // how far we've gone whilst accelerating
    plateau = vmax*(t2-t1);   // distance travelled in plateau
    t4=t-t2;  // time into decel period
    float v2 = a * t1; // velocity at end of accel period, might be vmax
    down = v2*t4 - 0.5*a*t4*t4;  // distance travelled in decel
    return round(up + plateau + down);
  } 
}

int getTrapezoidVel(float t) {
  if(t<t1) {
    return round(v0 + 0.5*a*t);
  }
  else if(t<t2) {
    return round(vmax);
  }
  else if(t<=t3) {
    t4=t-t2;
    float v2 = a * t1;
    return round(v2 - 0.5*a*t4);
  } 
}

ISR(TIMER3_COMPA_vect)
{
 interrupts();

 int p = 512;
 
 p = p + round(300 * sin(events * 0.007));
 
 
 motor1.setPos(p);
 motor2.setPos(p);
 motor3.setPos(p);
 
 events++;
  
  if (!moveDone) {
    events++;
    float t = events/10.0;
    if (t > t3 ) t = t3;
    int pos =  getTrapezoidPos(t);
    if (posChange > 0) {
       pos += startPos; 
    } else {
       pos = startPos - pos;
    }
    int vel = abs(getTrapezoidVel(t + 1/10.0));
    
    /*
    Serial.print(t);
    Serial.print(": ");
    Serial.print(pos);
    Serial.print(", ");
    Serial.println(vel);
    */
    
    motor1.setPosVel(pos,vel);
    
    if (t >= t3) {
       moveDone = true; 
    }
  }
}

void loop() {
  
  
   //delay(100);
  
  
   //motor1.setTorque(200);
   //motor2.setTorque(200);
  
   
   // shoulder
   //motor1.setPosVel(random(400, 600), 40);
   
   // elbow
  // motor2.setPosVel(random(200, 800), 60);
   
   // wrist
   //motor3.setPosVel(random(10,1000), 200);
   
   // spoon - set pos
   int tmp1 = (spoonTorq << 5) | spoonID;
   int tmp2 = random(128 - 70, 128 + 10);
   //tmp2 = 128 + 85;
   int checksum = (tmp1 ^ tmp2) & 0x7f;
   Serial3.write(0xff);
   Serial3.write(tmp1);
   Serial3.write(tmp2);
   Serial3.write(checksum);
   
   
   delay(1000);
   
    
   if (moveDone  && false) {
      // setup next move
      Serial.println();
      delay(2000);
      
      
      startPos = motor1.getPos();
      while (startPos < 0 || startPos > 1024) {
          startPos = motor1.getPos();
      }
      endPos = random(10, 1000);
      posChange = endPos - startPos;
      
      Serial.print(startPos);
      Serial.print(",");
      Serial.print(endPos);
      Serial.print(",");
      Serial.println(posChange);
      
      /*
      int vel = abs(posChange) / 2;
      if (vel > 300) vel = 300;
      if ( vel < 1) vel = 1;
      motor2.setVel(vel);
      */
      
      /*
      motor2.setVel(100);
      eventCount = round(abs(posChange) * 30 / 100);    
      */
      
      distance = abs(posChange);
      vmax = 60;
      a = 10;
      
      prepTrapezoid();
      
      Serial.print("t[]:");
      Serial.print(t1);
      Serial.print(",");
      Serial.print(t2);
      Serial.print(",");
      Serial.print(t3);
      Serial.print(",");
      Serial.println(t4);
      
      Serial.print("d[]:");
      Serial.print(d1);
      Serial.print(",");
      Serial.print(d2);
      Serial.println(",");
      
      // set initial velocity
      motor1.setVel(v0);
      
      eventCount = round(t3 * 10.0);
      
      events = 0;
      
      
     
      moveDone = false; 
   }
    
}

