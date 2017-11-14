//O.I.Mudannayake

int s1, s2, s3, s4, s5, s6, s7, s8, s9;

//PID variables
int lpower, rpower, basespeed = 180;
float error = 0, perror = 0;
float Propotional, Integral, Derivative;
float Kp = 10, Ki = 0, Kd = 0, Turn;	
float count = 0, cOut = 0;

void M(int LM, int RM)
{
	if (LM > 0)
    {
		PORTC.F0 = 1;		//Left forward			PWM1
        PORTC.F3 = 0;		//Left reverse			PWM1
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
        PORTC.F0 = 1;		//Left forward			PWM1
        PORTC.F3 = 1;		//Left reverse			PWM1
        PWM1_Set_Duty(230);
    }
    else if (LM < 0)
    {
        PORTC.F0 = 0;		//Left forward			PWM1
        PORTC.F3 = 1;		//Left reverse			PWM1
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
		PORTC.F5 = 1;		//Right forward			PWM1
		PORTC.F6 = 0;		//Right reverse			PWM1
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
        PORTC.F5 = 1;		//Right forward			PWM1
        PORTC.F6 = 1;		//Right reverse			PWM1
        PWM2_Set_Duty(230);
	}
    else if (RM < 0)
    {
		PORTC.F5 = 0;		//Right forward			PWM1
		PORTC.F6 = 1;		//Right reverse			PWM1
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
	TRISA = 0x00;				//Not used															-output[Default]
    TRISB = 0xFF;				//Line following sensors											-input
    TRISC = 0x00;				//Motor controller  & Box detecting sensors' indicators				-output
    TRISD = 0x00;				//Line following sensors' indicators								-output
    TRISE = 0xFF;				//Box detecting sensors												-input

    PWM1_Init(5000);			//Initialize PWM1 module at 5KHz
    PWM2_Init(5000);			//Initialize PWM2 module at 5KHz

    PORTC.F0 = 1;				//Left forward			PWM1
    PORTC.F3 = 0;				//Left reverse			PWM1
    PORTC.F5 = 1;				//Right forward			PWM2
    PORTC.F6 = 0;				//Right reverse			PWM2

    PWM1_Start();				// Start PWM1
    PWM2_Start();				// Start PWM2
    
	PWM1_Set_Duty(200);			//Starting PWM1 with 78.431% duty ratio
    PWM2_Set_Duty(200);			//Starting PWM2 with 78.431% duty ratio

    PortB.F1 = 0;				//Setting the value of Line following sensors to 0
    PortB.F2 = 0;
    PortB.F3 = 0;
    PortB.F4 = 0;
    PortB.F5 = 0;

    PORTC.F4 = 0;				//Method test

	while (1)
	{
		PORTC.F4 = 0;

        //Getting the sensor data							1 - Black		0 - White
        //s1 =
        //s2 = 
        s3 = 
        s4 =

        s5 = 
		
		s6 =
		s7 = 
		//s8 =
		//s9 =

		//Treasure
		if (s3 == 1 && s4 == 1 && s5 == 1 && s6 == 1 && s7 == 1)
		{
			while (1)
			{
				M(0, 0);
				PORTC.F4 = 1;
				Delay_ms(250);
				PORTC.F4 = 0;
				Delay_ms(250);
			}
		}

		//Completely out of line
		if (s3 == 0 && s4 == 0 && s5 == 0 && s6 == 0 && s7 == 0 )
		{
			cOut = cOut + 1;
			if (cOut > 1000)
			{
				basespeed = 170;
				M(-200, -200);
				Delay_ms(100);
			}
		}


		//Error
		perror = error;						//Previous error (perror)
		error = ((s1 * 4) + (s2 * 3) + (s3 * 2) + (s4 * 1) + (s5 * 0) + (s6 * -1) + (s7 * -2) + (s8 * -3) + (s9 * -4)) / (s1 + s2 + s3 + s4 + s5 + s6 + s7 + s8 + s9);

		//PID
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

		count = count + 1;

	}

}