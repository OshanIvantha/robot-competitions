#line 1 "J:/R2D2 X PID/R2D2 X PID.c"


int s1, s2, s3, s4, s5, s6, s7;


int lpower, rpower, basespeed = 200;
float error = 0, perror = 0;
float Propotional, Integral, Derivative;
float Kp = 127.5, Ki, Kd, Turn;

float count = 0;
void M(int LM, int RM)
{
 if (LM > 0)
 {
 PORTC.F0 = 1;
 PORTC.F3 = 0;
 if (LM > 255)
 {
 PWM1_Set_Duty(255);
 }
 else
 {
 PWM1_Set_Duty(LM);
 }
 }
 else if (LM == 0)
 {
 PORTC.F0 = 1;
 PORTC.F3 = 1;
 PWM1_Set_Duty(230);
 }
 else if (LM < 0)
 {
 PORTC.F0 = 0;
 PORTC.F3 = 1;
 if (LM < -255)
 {
 PWM1_Set_Duty(255);
 }
 else
 {
 LM = -LM;
 PWM1_Set_Duty(LM);
 }
 }

 if (RM > 0)
 {
 PORTC.F5 = 1;
 PORTC.F6 = 0;
 if (RM > 255)
 {
 PWM2_Set_Duty(255);
 }
 else
 {
 PWM1_Set_Duty(RM);
 }
 }
 else if (RM == 0)
 {
 PORTC.F5 = 1;
 PORTC.F6 = 1;
 PWM2_Set_Duty(230);
 }
 else if (RM < 0)
 {
 PORTC.F5 = 0;
 PORTC.F6 = 1;
 if (RM < -255)
 {
 PWM2_Set_Duty(255);
 }
 else
 {
 RM = -RM;
 PWM1_Set_Duty(RM);
 }
 }
}

void main()
{
 TRISA = 0x00;
 TRISB = 0xFF;
 TRISC = 0x00;
 TRISD = 0x00;
 TRISE = 0xFF;

 PWM1_Init(5000);
 PWM2_Init(5000);

 PORTC.F0 = 1;
 PORTC.F3 = 0;
 PORTC.F5 = 1;
 PORTC.F6 = 0;

 PWM1_Start();
 PWM2_Start();

 PWM1_Set_Duty(200);
 PWM2_Set_Duty(200);

 PortB.F1 = 0;
 PortB.F2 = 0;
 PortB.F3 = 0;
 PortB.F4 = 0;
 PortB.F5 = 0;

 PORTC.F4 = 0;

 while (1)
 {
 PORTC.F4 = 0;


 s1 = !(PORTB.F1);
 s2 = !(PORTB.F2);
 s3 = !(PORTB.F3);
 s4 = !(PORTB.F4);
 s5 = !(PORTB.F5);


 if ( s1 == 1 && s2 == 1 && s3 == 1 && s4 == 1 && s5 == 1 )

 {
 while(1)
 {
 M(0,0);
 while (1)
 {
 PORTC.F4 = 1;
 Delay_ms(250);
 PORTC.F4 = 0;
 Delay_ms(250);
 }
 }
 }

 perror = error;


 error = ( (s1 * 2) + (s2 * 1) + (s3 * 0) + (s4 * -1) + (s5 * -2) ) / (s1 + s2 + s3 + s4 + s5);


 Propotional = Kp * error;
 if (error == 0)
 {
 Integral = 0;
 }
 Integral = (Integral + error) * Ki;
 Derivative = (error - perror) * Kd;
 Turn = Propotional + Integral + Derivative;
 lpower = basespeed - Turn;
 rpower = basespeed + Turn;
 M(lpower,rpower);

 count += 1;

 }

}
