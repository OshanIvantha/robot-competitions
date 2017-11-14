#include <Servo.h>
Servo servo_1;    //Verticle movement
Servo servo_2;    //Gripping movement

double robotLength = 21.0;
double robotWidth = 16.0;
double pathWidth = 30.0;

int lastVerticlePos = 80;

boolean isOnMaze = true;

boolean lsActive = true;
boolean rsActive = true;

void setup()
{
  Serial.begin(9600);
  Serial.setTimeout(50);

  servo_1.attach(10);
  servo_2.attach(9);
}

int dist = 10;
void loop()
{ 

  if (isOnMaze) {
    if (isLeftOpen() && lsActive) {
      lsActive = false;
      turnLeft();
    }
    else if (isFrontOpen()) {
        forward();
        if(lsActive){
          if(getLeftSonar() > dist){
            lefting();
          }else if(getLeftSonar() < dist){
            righting();
          }else{
            forward();
          }
        }else if(rsActive){
          if(getRightSonar() > dist){
            righting();
          }else if(getRightSonar() < dist){
            lefting();
          }else{
            forward();
          }
        }
    }
    else if (isRightOpen() && rsActive) {
      rsActive = false;
      turnRight();
    }
    
    if ( isOnEnd()) {
      turnBack();
    }

    if  (!isLeftOpen()) {
      lsActive = true;
    }

    if  (!isRightOpen()) {
      rsActive = true;
    }

    if (Serial.available()) {
      String data = Serial.readString();
      if (data == 'Q') {
        isOnMaze = false;
        brake();
      }
    }
  } else {
    receiveCommands();
  }
}


