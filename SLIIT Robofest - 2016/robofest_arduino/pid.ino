int baseSpeed = 80;
double P = 0.0, I = 0.0, D = 0.0;
float kP = 2.0, kI = 0.0, kD = 0.0;
float error = 0.0, preError = 0.0;
float turn;

void pid() {
  preError = error;

  double leftSonar = getLeftSonar();
  double rightSonar = getRightSonar();
  int totalWidth = leftSonar + robotWidth + rightSonar;
  error = (leftSonar / totalWidth) * 20.0 - 10.0;

  P = kP * error;
  if (error == 0.0) {
    I = 0.0;
  }
  I = (I + error) * kI;
  D = (error - preError) * kD;
  turn = P + I + D;
  int lSpeed = baseSpeed - turn;
  int rSpeed = baseSpeed + turn;

  if (lSpeed < 80) {
    lSpeed -= 160;
  }
  if (rSpeed < 80) {
    rSpeed -= 160;
  }

  drive(lSpeed, rSpeed, lSpeed, rSpeed);
  //  Serial.print(lSpeed);
  //  Serial.print(" ");
  //  Serial.println(rSpeed);
}


