#include <AFMotor.h>

AF_DCMotor leftForwardMotor(2);
AF_DCMotor leftBackwardMotor(4);
AF_DCMotor rightForwardMotor(3);
AF_DCMotor rightBackwardMotor(1);

void drive(int lFPower, int rFPower, int lBPower, int rBPower) {
  if (lFPower > 0) {
    leftForwardMotor.run(FORWARD);
  }
  else if (lFPower < 0) {
    leftForwardMotor.run(BACKWARD);
  }
  else if (lFPower == 0) {
    leftForwardMotor.run(RELEASE);
  }

  if (lBPower > 0) {
    leftBackwardMotor.run(FORWARD);
  }
  else if (lBPower < 0) {
    leftBackwardMotor.run(BACKWARD);
  }
  else if (lBPower == 0) {
    leftBackwardMotor.run(RELEASE);
  }

  if (rFPower > 0) {
    rightForwardMotor.run(FORWARD);
  }
  else if (rFPower < 0) {
    rightForwardMotor.run(BACKWARD);
  }

  else if (rFPower == 0) {
    rightForwardMotor.run(RELEASE);
  }

  if (rBPower > 0) {
    rightBackwardMotor.run(FORWARD);
  }
  else if (rBPower < 0) {
    rightBackwardMotor.run(BACKWARD);
  }
  else if (rBPower == 0) {
    rightBackwardMotor.run(RELEASE);
  }

  leftForwardMotor.setSpeed(abs(lFPower));
  leftBackwardMotor.setSpeed(abs(lBPower));
  rightForwardMotor.setSpeed(abs(rFPower));
  rightBackwardMotor.setSpeed(abs(rBPower));
}

void forward() {
  drive(90, 90, 90, 90);
  delay(50);
  drive(0, 0, 0, 0);
}

void reverse() {
  drive(-80, -80, -80, -80);
  delay(100);
  drive(0, 0, 0, 0);
}

void turnLeft( ) {
  drive(-100, 100, -100, 100);
  delay(900);
  drive(0, 0, 0, 0);
}

void turnRight() {
  drive(100, -100, 100, -100);
  delay(900);
  drive(0, 0, 0, 0);
}

void turnBack() {
  drive(100, -100, 100, -100);
  delay(1000);
  drive(0, 0, 0, 0);
}

void lefting() {
  drive(70, 90, 70, 90);
  delay(50);
//  drive(0, 0, 0, 0);
}

void righting() {
  drive(90, 70, 90, 70);
  delay(50);
//  drive(0, 0, 0, 0);
}

void brake() {
  drive(0, 0, 0, 0);
  delay(100000);
}
