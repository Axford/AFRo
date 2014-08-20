#include <ax12.h>

#define Z_STEP_PIN         A0
#define Z_DIR_PIN          A1
#define Z_ENABLE_PIN       38

AX12 motor1;
AX12 motor2;

void enable_z() {
   //WRITE(Z_ENABLE_PIN, LOW);
   digitalWrite(Z_ENABLE_PIN, LOW);
}

void disable_z() {
   //WRITE(Z_ENABLE_PIN, HIGH); 
}

void setup() {
 
  motor1 = AX12();
  motor2 = AX12();

  Serial.begin (115200);  // inicializa el Serial a 115,2 Kb/s
  AX12::init (1000000);   // inicializa los AX12 a 1 Mb/s

  motor1.id = 1; 
  motor1.SRL = RETURN_ALL;
 
  motor2.id = 2;  
  motor2.SRL = RETURN_ALL;
  
  pinMode(Z_ENABLE_PIN, OUTPUT);
  pinMode(Z_STEP_PIN, OUTPUT);  
  pinMode(Z_DIR_PIN, OUTPUT);
  
  pinMode(13, OUTPUT);

  enable_z();    
  
  // set up Timer 1
  TCCR1A = 0;          // normal operation
  TCCR1B = bit(WGM12) | bit(CS11);   // CTC, scale / 8
  //OCR1A =  625;       // compare A register value, approx 1 RPM with 200 steps per rev and 16x microstepping
  OCR1A = 625;
  TIMSK1 = bit (OCIE1A);             // interrupt on Compare A Match
  
  // set up Timer 3
  TCCR3A = 0;          // normal operation
  TCCR3B = bit(WGM12) | bit(CS12);   // CTC, scale / 1024
  OCR3A =  521;       // compare A register value, approx 30 Hz
  TIMSK3 = bit (OCIE3A);             // interrupt on Compare A Match
  
  // set default velocities
  motor1.setVel(100);
  motor2.setVel(100);
  
  // set initial positions
  motor1.setPos(512);
  motor2.setPos(512);
  
  Serial.begin(115200);
  
  delay(1000); // give them time to get there
}

long stepCount = 0;

void step_z() {
   digitalWrite(Z_STEP_PIN, true);
   digitalWrite(Z_STEP_PIN, false);
   
   stepCount++;
   
   if (stepCount > 3200 * 10) {
      digitalWrite(Z_DIR_PIN, !digitalRead(Z_DIR_PIN)); 
      stepCount = 0;
   }
}

int vel = 1;
int maxVel = 200;
int i = 0;


volatile boolean moveDone = true;
int startPos = 512;
int endPos = 512;
int posChange = 0;
int eventCount = 30 * 2;
int events = 0;

ISR(TIMER1_COMPA_vect)
{
  step_z();
}



float v0 = 20;  // jerk velocity
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
  
  accelerateUntil = round(t1 * 30);
  decelerateAfter = round(t2 * 30);
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
  
  if (!moveDone) {
    events++;
    float t = events/30.0;
    if (t > t3 ) t = t3;
    int pos =  getTrapezoidPos(t);
    if (posChange > 0) {
       pos += startPos; 
    } else {
       pos = startPos - pos;
    }
    int vel = abs(getTrapezoidVel(t));
    
    Serial.print(t);
    Serial.print(": ");
    Serial.print(pos);
    Serial.print(", ");
    Serial.println(vel);
    motor2.setPosVel(pos,vel);
    
    if (t >= t3) {
       moveDone = true; 
    }
  }
}

void loop() {
   delay(100);
    
   if (moveDone) {
      // setup next move
      Serial.println();
      delay(500);
      
      
      startPos = motor2.getPos();
      while (startPos < 0 || startPos > 1024) {
          startPos = motor2.getPos();
      }
      endPos = random(512 - 250,  512 + 250);
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
      vmax = 300;
      a = 100;
      
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
      motor2.setVel(v0);
      
      eventCount = round(t3 * 30.0);
      
      events = 0;
      
      
     
      moveDone = false; 
   }
    
}

