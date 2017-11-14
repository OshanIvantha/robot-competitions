

char junk;
String inputString = "";
int const s = 180;
int const t = 100;


// Declare classes for Servo connectors of the MotorShield.


void setup()
{
  Serial.begin(9600);
  Serial1.begin(9600);
  
  pinMode(52, OUTPUT);

  
  
  digitalWrite(52, HIGH);
}


void loop()
{
  if (Serial1.available()) {
    while (Serial1.available()) {
      char inChar = (char)Serial1.read(); //read the input
      inputString += inChar;        //make a string of the characters coming on serial
    }
    Serial1.println(inputString);
    while (Serial1.available() > 0) {
      junk = Serial1.read();
    }      // clear the serial buffer
    if (inputString == "f") {       //in case of 'a' turn the LED on
      drive(s,s,s,s);

      delay(t);
    }
    if (inputString == "b") {
      drive(-s,-s,-s,-s);
      delay(t);
    }
    if (inputString == "r") {
      drive(s,s,-s,-s);
      delay(t);
    }
    if (inputString == "l") {
      drive(-s,-s,s,s);
      delay(t);
    }
    if (inputString == "u") {
      
    }
    if (inputString == "d") {
      
    }
    if (inputString == "c") {
      
    }
    if (inputString == "e") {
      
    }
    inputString = "";
    if (inputString == "") {
      drive(0,0,0,0);
    }
    if (inputString == "c") {
      servo_1.write(120);
    }
    if (inputString == "e") {
      servo_1.write(55);
    }
  }
}


