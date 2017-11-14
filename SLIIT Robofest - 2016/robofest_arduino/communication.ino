void receiveCommands() {
  if (Serial.available()) {
    String data = Serial.readString();
    char type = data.charAt(0);

    if (type == 'M') {
      String lfString = data.substring(1, 4);
      String rfString = data.substring(4, 7);
      String lbString = data.substring(7, 10);
      String rbString = data.substring(10);

      int lf = lfString.toInt() - 355;
      int rf = rfString.toInt() - 355;
      int lb = lbString.toInt() - 355;
      int rb = rbString.toInt() - 355;

      drive(lf, rf, lb, rb);
    }
    else if (type == 'S') {
      double sLeft = getLeftSonar();
      double sRight = getRightSonar();
      double sFront = getFrontSonar();

      String messaage = String(sLeft) + " " + String(sFront) + " " + String(sRight);
      Serial.println(messaage);
    }
    else if (type == 'U') {
     up();
    }
    else if (type == 'D') {
      down();
    }
    else if (type == 'C') {
      contract();
    }
    else if (type == 'E') {
      expand();
    }
    else if(type == 'L'){
      down();
      contract();
      up();
    }else if(type == 'P'){
      down();
      expand();
      up();
    }
  }
  delay(50);
}

void up(){
   int up = lastVerticlePos;
      lastVerticlePos = 80;
      while (up < 80) {
        servo_1.write(up);
        delay(25);
        up--;
      }
}

void down(){
  int down = lastVerticlePos;
      lastVerticlePos = 145;
      while (down >= 80 && down < 145) {
        servo_1.write(down);
        delay(25);
        down++;
      }
}

void contract(){
  int contractLimit = 130;
      servo_2.write(contractLimit);
}

void expand(){
 int expandLimit = 180;
      servo_2.write(expandLimit); 
}

