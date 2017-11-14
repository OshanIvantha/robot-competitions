//#include <NewPing.h>
//
//#define TRIGGER_PIN_LEFT 22
//#define ECHO_PIN_LEFT 23
//#define MAX_LEFT 200
//NewPing left_sonar(TRIGGER_PIN_LEFT, ECHO_PIN_LEFT, MAX_LEFT);
//
//#define TRIGGER_PIN_FRONT 26
//#define ECHO_PIN_FRONT 27
//#define MAX_FRONT 200
//NewPing front_sonar(TRIGGER_PIN_FRONT, ECHO_PIN_FRONT, MAX_FRONT);
//
//#define TRIGGER_PIN_RIGHT 24
//#define ECHO_PIN_RIGHT 25
//#define MAX_RIGHT 200
//NewPing right_sonar(TRIGGER_PIN_RIGHT, ECHO_PIN_RIGHT, MAX_RIGHT);


double getLeftSonar() {
  return getDistance(34,35);
}

double getRightSonar() {
  return getDistance(36,37);
}

double getFrontSonar() {
  return getDistance(38,39);
}

double getDistance(int trigPin, int echoPin){
   pinMode(trigPin, OUTPUT);
   pinMode(echoPin, INPUT);

  long duration, inches, cm;
  
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(5);
  digitalWrite(trigPin, LOW);

  duration = pulseIn(echoPin, HIGH);
  cm = microsecondsToCentimeters(duration);
  return cm;
}

long microsecondsToCentimeters(long microseconds) {
  return microseconds / 29 / 2;
}
