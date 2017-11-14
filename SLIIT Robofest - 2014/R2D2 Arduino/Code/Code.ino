//Line following sensors
int s1, s2, s3, s4, s5, s6, s7, s8, s9;

//PID variables
short lSpeed = 0, rSpeed = 0, baseSpeed = 150;
float error = 0.0, preError = 0.0;
double P = 0.0, I = 0.0, D = 0.0;
float kP = 20.0, kI = 0.0, kD = 0.0;
float turn;

int reverse = 0.0;

byte const ps1 = 1;
byte const ps2 = 2;
byte const ps3 = 3;
byte const ps4 = 4;
byte const ps5 = 5;
byte const ps6 = 6;
byte const ps7 = 7;
byte const ps8 = 8;
byte const ps9 = 9;

byte const rf = 10;
byte const rb = 11;
byte const lf = 12;
byte const lb = 13;

void setup() {
  Serial.begin(9600);

  pinMode(rf, OUTPUT);
  pinMode(rb, OUTPUT);
  pinMode(lf, OUTPUT);
  pinMode(lb, OUTPUT);
 
  pinMode(ps1, INPUT);
  pinMode(ps2, INPUT);
  pinMode(ps3, INPUT);
  pinMode(ps4, INPUT);
  pinMode(ps5, INPUT);
  pinMode(ps6, INPUT);
  pinMode(ps7, INPUT);
  pinMode(ps8, INPUT);
  pinMode(ps9, INPUT);
}

void drive(short lMotor, short rMotor){
  if (lMotor >= 0){
    analogWrite(lf, lMotor); 
    analogWrite(lb, 0);
  }
  else{
    analogWrite(lf, 0);
    analogWrite(lb, abs(lMotor));
  }

  if (rMotor >= 0){
    analogWrite(rf, rMotor);
    analogWrite(rb, 0);
  }
  else{
    analogWrite(rf, 0);
    analogWrite(rb, abs(rMotor));
  }
}

void loop() {
  s1 = 0;
  s2 = 0;
  s3 = 0;
  s4 = 0;
  s5 = 0;
  s6 = 0;
  s7 = 0;
  
  if (digitalRead(ps1) == 0){
    s1 = 1;
  }
  if (digitalRead(ps2) == 0){
    s2 = 1;
  }
  if (digitalRead(ps3) == 0){
    s3 = 1;
  }
  if (digitalRead(ps4) == 0){
    s4 = 1;
  }
  if (digitalRead(ps5) == 0){
    s5 = 1;
  }
  if (digitalRead(ps6) == 0){
    s6 = 1;
  }
  if (digitalRead(ps7) == 0){
    s7 = 1;
  }
  
  preError = error;		//Previous error
  error = ((s1 * 1) + (s2 * 2) + (s3 * 3) + (s4 * 4) + (s5 * 5) + (s6 * 6) + (s7 * 7) + (s8 * 8) + (s9 * 9)) / (s1 + s2 + s3 + s4 + s5 + s6 + s7 +s8 + s9);    //Current error
  error = error - 5;
  
  //PID
  P = kP * error;
  if(error == 0.0){
     I = 0.0; 
  }
  I = (I + error) * kI;
  D = (error - preError) * kD;
  turn = P + I + D;
  lSpeed = baseSpeed + turn;
  rSpeed = baseSpeed - turn;

  if (lSpeed > 255){
    lSpeed = 255;
  }
  else if (lSpeed < -255){
    lSpeed = -255;
  }
  if (rSpeed > 255){
    rSpeed = 255;
  }
  else if (rSpeed < -255){
    rSpeed = -255;
  }

  if (s1 == 0 && s2 == 0 && s3 == 0 && s4 == 0 && s5 == 0 && s6 == 0 && s7 == 0 && s8 == 0 && s9 == 0){
    if (reverse > 5){
      drive(-180, -180);
    }
    else{
      drive(100, 100);
    }
    reverse++;
  }
  else if (s1 == 1 && s2 == 1 && s3 == 1 && s4 == 1){     //Left 90
    drive(-180, 180);
    reverse = 0;
  }
  else if (s6 == 1 && s7 == 1 && s8 == 1 && s9 == 1){     //Right 90
    drive(180, -180);
    reverse = 0;
  }
  else{
    drive(lSpeed, rSpeed);
    reverse = 0;
  } 
  
  /*Serial.print(s1);
  Serial.print(s2);
  Serial.print(s3);
  Serial.print(s4);
  Serial.print(s5);
  Serial.print(s6);
  Serial.print(s7);
  Serial.print(s8);
  Serial.print(s9);
  Serial.print("--");
  Serial.print(error);
  Serial.print("--");
  Serial.print("[");
  Serial.print(lPower);
  Serial.print(",");
  Serial.println(rPower);
  Serial.print("]");*/
}
