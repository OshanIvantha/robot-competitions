
_M:

;R2D2 X PID.c,12 :: 		void M(int LM, int RM)
;R2D2 X PID.c,14 :: 		if (LM > 0)
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      FARG_M_LM+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__M32
	MOVF       FARG_M_LM+0, 0
	SUBLW      0
L__M32:
	BTFSC      STATUS+0, 0
	GOTO       L_M0
;R2D2 X PID.c,16 :: 		PORTC.F0 = 1;		//Left forward			PWM1
	BSF        PORTC+0, 0
;R2D2 X PID.c,17 :: 		PORTC.F3 = 0;		//Left reverse			PWM1
	BCF        PORTC+0, 3
;R2D2 X PID.c,18 :: 		if (LM > 255)
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      FARG_M_LM+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__M33
	MOVF       FARG_M_LM+0, 0
	SUBLW      255
L__M33:
	BTFSC      STATUS+0, 0
	GOTO       L_M1
;R2D2 X PID.c,20 :: 		PWM1_Set_Duty(255);
	MOVLW      255
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;R2D2 X PID.c,21 :: 		}
	GOTO       L_M2
L_M1:
;R2D2 X PID.c,24 :: 		PWM1_Set_Duty(LM);
	MOVF       FARG_M_LM+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;R2D2 X PID.c,25 :: 		}
L_M2:
;R2D2 X PID.c,26 :: 		}
	GOTO       L_M3
L_M0:
;R2D2 X PID.c,27 :: 		else if (LM == 0)
	MOVLW      0
	XORWF      FARG_M_LM+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__M34
	MOVLW      0
	XORWF      FARG_M_LM+0, 0
L__M34:
	BTFSS      STATUS+0, 2
	GOTO       L_M4
;R2D2 X PID.c,29 :: 		PORTC.F0 = 1;		//Left forward			PWM1
	BSF        PORTC+0, 0
;R2D2 X PID.c,30 :: 		PORTC.F3 = 1;		//Left reverse			PWM1
	BSF        PORTC+0, 3
;R2D2 X PID.c,31 :: 		PWM1_Set_Duty(230);
	MOVLW      230
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;R2D2 X PID.c,32 :: 		}
	GOTO       L_M5
L_M4:
;R2D2 X PID.c,33 :: 		else if (LM < 0)
	MOVLW      128
	XORWF      FARG_M_LM+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__M35
	MOVLW      0
	SUBWF      FARG_M_LM+0, 0
L__M35:
	BTFSC      STATUS+0, 0
	GOTO       L_M6
;R2D2 X PID.c,35 :: 		PORTC.F0 = 0;		//Left forward			PWM1
	BCF        PORTC+0, 0
;R2D2 X PID.c,36 :: 		PORTC.F3 = 1;		//Left reverse			PWM1
	BSF        PORTC+0, 3
;R2D2 X PID.c,37 :: 		if (LM < -255)
	MOVLW      128
	XORWF      FARG_M_LM+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORLW      255
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__M36
	MOVLW      1
	SUBWF      FARG_M_LM+0, 0
L__M36:
	BTFSC      STATUS+0, 0
	GOTO       L_M7
;R2D2 X PID.c,39 :: 		PWM1_Set_Duty(255);
	MOVLW      255
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;R2D2 X PID.c,40 :: 		}
	GOTO       L_M8
L_M7:
;R2D2 X PID.c,43 :: 		LM = -LM;
	MOVF       FARG_M_LM+0, 0
	SUBLW      0
	MOVWF      R0+0
	MOVF       FARG_M_LM+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       R0+1
	SUBWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      FARG_M_LM+0
	MOVF       R0+1, 0
	MOVWF      FARG_M_LM+1
;R2D2 X PID.c,44 :: 		PWM1_Set_Duty(LM);
	MOVF       R0+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;R2D2 X PID.c,45 :: 		}
L_M8:
;R2D2 X PID.c,46 :: 		}
L_M6:
L_M5:
L_M3:
;R2D2 X PID.c,48 :: 		if (RM > 0)
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      FARG_M_RM+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__M37
	MOVF       FARG_M_RM+0, 0
	SUBLW      0
L__M37:
	BTFSC      STATUS+0, 0
	GOTO       L_M9
;R2D2 X PID.c,50 :: 		PORTC.F5 = 1;		//Right forward			PWM1
	BSF        PORTC+0, 5
;R2D2 X PID.c,51 :: 		PORTC.F6 = 0;		//Right reverse			PWM1
	BCF        PORTC+0, 6
;R2D2 X PID.c,52 :: 		if (RM > 255)
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      FARG_M_RM+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__M38
	MOVF       FARG_M_RM+0, 0
	SUBLW      255
L__M38:
	BTFSC      STATUS+0, 0
	GOTO       L_M10
;R2D2 X PID.c,54 :: 		PWM2_Set_Duty(255);
	MOVLW      255
	MOVWF      FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;R2D2 X PID.c,55 :: 		}
	GOTO       L_M11
L_M10:
;R2D2 X PID.c,58 :: 		PWM1_Set_Duty(RM);
	MOVF       FARG_M_RM+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;R2D2 X PID.c,59 :: 		}
L_M11:
;R2D2 X PID.c,60 :: 		}
	GOTO       L_M12
L_M9:
;R2D2 X PID.c,61 :: 		else if (RM == 0)
	MOVLW      0
	XORWF      FARG_M_RM+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__M39
	MOVLW      0
	XORWF      FARG_M_RM+0, 0
L__M39:
	BTFSS      STATUS+0, 2
	GOTO       L_M13
;R2D2 X PID.c,63 :: 		PORTC.F5 = 1;		//Right forward			PWM1
	BSF        PORTC+0, 5
;R2D2 X PID.c,64 :: 		PORTC.F6 = 1;		//Right reverse			PWM1
	BSF        PORTC+0, 6
;R2D2 X PID.c,65 :: 		PWM2_Set_Duty(230);
	MOVLW      230
	MOVWF      FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;R2D2 X PID.c,66 :: 		}
	GOTO       L_M14
L_M13:
;R2D2 X PID.c,67 :: 		else if (RM < 0)
	MOVLW      128
	XORWF      FARG_M_RM+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__M40
	MOVLW      0
	SUBWF      FARG_M_RM+0, 0
L__M40:
	BTFSC      STATUS+0, 0
	GOTO       L_M15
;R2D2 X PID.c,69 :: 		PORTC.F5 = 0;		//Right forward			PWM1
	BCF        PORTC+0, 5
;R2D2 X PID.c,70 :: 		PORTC.F6 = 1;		//Right reverse			PWM1
	BSF        PORTC+0, 6
;R2D2 X PID.c,71 :: 		if (RM < -255)
	MOVLW      128
	XORWF      FARG_M_RM+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORLW      255
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__M41
	MOVLW      1
	SUBWF      FARG_M_RM+0, 0
L__M41:
	BTFSC      STATUS+0, 0
	GOTO       L_M16
;R2D2 X PID.c,73 :: 		PWM2_Set_Duty(255);
	MOVLW      255
	MOVWF      FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;R2D2 X PID.c,74 :: 		}
	GOTO       L_M17
L_M16:
;R2D2 X PID.c,77 :: 		RM = -RM;
	MOVF       FARG_M_RM+0, 0
	SUBLW      0
	MOVWF      R0+0
	MOVF       FARG_M_RM+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       R0+1
	SUBWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      FARG_M_RM+0
	MOVF       R0+1, 0
	MOVWF      FARG_M_RM+1
;R2D2 X PID.c,78 :: 		PWM1_Set_Duty(RM);
	MOVF       R0+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;R2D2 X PID.c,79 :: 		}
L_M17:
;R2D2 X PID.c,80 :: 		}
L_M15:
L_M14:
L_M12:
;R2D2 X PID.c,81 :: 		}
L_end_M:
	RETURN
; end of _M

_main:

;R2D2 X PID.c,83 :: 		void main()
;R2D2 X PID.c,85 :: 		TRISA = 0x00;				//Not used															-output[Default]
	CLRF       TRISA+0
;R2D2 X PID.c,86 :: 		TRISB = 0xFF;				//Line following sensors											-input
	MOVLW      255
	MOVWF      TRISB+0
;R2D2 X PID.c,87 :: 		TRISC = 0x00;				//Motor controller  & Box detecting sensors' indicators				-output
	CLRF       TRISC+0
;R2D2 X PID.c,88 :: 		TRISD = 0x00;				//Line following sensors' indicators								-output
	CLRF       TRISD+0
;R2D2 X PID.c,89 :: 		TRISE = 0xFF;				//Box detecting sensors												-input
	MOVLW      255
	MOVWF      TRISE+0
;R2D2 X PID.c,91 :: 		PWM1_Init(5000);			//Initialize PWM1 module at 5KHz
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      99
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;R2D2 X PID.c,92 :: 		PWM2_Init(5000);			//Initialize PWM2 module at 5KHz
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      99
	MOVWF      PR2+0
	CALL       _PWM2_Init+0
;R2D2 X PID.c,94 :: 		PORTC.F0 = 1;				//Left forward			PWM1
	BSF        PORTC+0, 0
;R2D2 X PID.c,95 :: 		PORTC.F3 = 0;				//Left reverse			PWM1
	BCF        PORTC+0, 3
;R2D2 X PID.c,96 :: 		PORTC.F5 = 1;				//Right forward			PWM2
	BSF        PORTC+0, 5
;R2D2 X PID.c,97 :: 		PORTC.F6 = 0;				//Right reverse			PWM2
	BCF        PORTC+0, 6
;R2D2 X PID.c,99 :: 		PWM1_Start();				// Start PWM1
	CALL       _PWM1_Start+0
;R2D2 X PID.c,100 :: 		PWM2_Start();				// Start PWM2
	CALL       _PWM2_Start+0
;R2D2 X PID.c,102 :: 		PWM1_Set_Duty(200);			//Starting PWM1 with 78.431% duty ratio
	MOVLW      200
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;R2D2 X PID.c,103 :: 		PWM2_Set_Duty(200);			//Starting PWM2 with 78.431% duty ratio
	MOVLW      200
	MOVWF      FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;R2D2 X PID.c,105 :: 		PortB.F1 = 0;				//Setting the value of Line following sensors to 0
	BCF        PORTB+0, 1
;R2D2 X PID.c,106 :: 		PortB.F2 = 0;
	BCF        PORTB+0, 2
;R2D2 X PID.c,107 :: 		PortB.F3 = 0;
	BCF        PORTB+0, 3
;R2D2 X PID.c,108 :: 		PortB.F4 = 0;
	BCF        PORTB+0, 4
;R2D2 X PID.c,109 :: 		PortB.F5 = 0;
	BCF        PORTB+0, 5
;R2D2 X PID.c,111 :: 		PORTC.F4 = 0;				//Method test
	BCF        PORTC+0, 4
;R2D2 X PID.c,113 :: 		while (1)
L_main18:
;R2D2 X PID.c,115 :: 		PORTC.F4 = 0;
	BCF        PORTC+0, 4
;R2D2 X PID.c,118 :: 		s1 = !(PORTB.F1);
	BTFSC      PORTB+0, 1
	GOTO       L__main43
	BSF        3, 0
	GOTO       L__main44
L__main43:
	BCF        3, 0
L__main44:
	MOVLW      0
	BTFSC      3, 0
	MOVLW      1
	MOVWF      _s1+0
	CLRF       _s1+1
;R2D2 X PID.c,119 :: 		s2 = !(PORTB.F2);
	BTFSC      PORTB+0, 2
	GOTO       L__main45
	BSF        3, 0
	GOTO       L__main46
L__main45:
	BCF        3, 0
L__main46:
	MOVLW      0
	BTFSC      3, 0
	MOVLW      1
	MOVWF      _s2+0
	CLRF       _s2+1
;R2D2 X PID.c,120 :: 		s3 = !(PORTB.F3);
	BTFSC      PORTB+0, 3
	GOTO       L__main47
	BSF        3, 0
	GOTO       L__main48
L__main47:
	BCF        3, 0
L__main48:
	MOVLW      0
	BTFSC      3, 0
	MOVLW      1
	MOVWF      _s3+0
	CLRF       _s3+1
;R2D2 X PID.c,121 :: 		s4 = !(PORTB.F4);
	BTFSC      PORTB+0, 4
	GOTO       L__main49
	BSF        3, 0
	GOTO       L__main50
L__main49:
	BCF        3, 0
L__main50:
	MOVLW      0
	BTFSC      3, 0
	MOVLW      1
	MOVWF      _s4+0
	CLRF       _s4+1
;R2D2 X PID.c,122 :: 		s5 = !(PORTB.F5);
	BTFSC      PORTB+0, 5
	GOTO       L__main51
	BSF        3, 0
	GOTO       L__main52
L__main51:
	BCF        3, 0
L__main52:
	MOVLW      0
	BTFSC      3, 0
	MOVLW      1
	MOVWF      _s5+0
	CLRF       _s5+1
;R2D2 X PID.c,125 :: 		if ( s1 == 1 && s2 == 1 && s3 == 1 && s4 == 1 && s5 == 1 )
	MOVLW      0
	XORWF      _s1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main53
	MOVLW      1
	XORWF      _s1+0, 0
L__main53:
	BTFSS      STATUS+0, 2
	GOTO       L_main22
	MOVLW      0
	XORWF      _s2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main54
	MOVLW      1
	XORWF      _s2+0, 0
L__main54:
	BTFSS      STATUS+0, 2
	GOTO       L_main22
	MOVLW      0
	XORWF      _s3+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main55
	MOVLW      1
	XORWF      _s3+0, 0
L__main55:
	BTFSS      STATUS+0, 2
	GOTO       L_main22
	MOVLW      0
	XORWF      _s4+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main56
	MOVLW      1
	XORWF      _s4+0, 0
L__main56:
	BTFSS      STATUS+0, 2
	GOTO       L_main22
	MOVLW      0
	XORWF      _s5+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main57
	MOVLW      1
	XORWF      _s5+0, 0
L__main57:
	BTFSS      STATUS+0, 2
	GOTO       L_main22
L__main30:
;R2D2 X PID.c,130 :: 		M(0,0);
	CLRF       FARG_M_LM+0
	CLRF       FARG_M_LM+1
	CLRF       FARG_M_RM+0
	CLRF       FARG_M_RM+1
	CALL       _M+0
;R2D2 X PID.c,131 :: 		while (1)
L_main25:
;R2D2 X PID.c,133 :: 		PORTC.F4 = 1;
	BSF        PORTC+0, 4
;R2D2 X PID.c,134 :: 		Delay_ms(250);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main27:
	DECFSZ     R13+0, 1
	GOTO       L_main27
	DECFSZ     R12+0, 1
	GOTO       L_main27
	DECFSZ     R11+0, 1
	GOTO       L_main27
	NOP
	NOP
;R2D2 X PID.c,135 :: 		PORTC.F4 = 0;
	BCF        PORTC+0, 4
;R2D2 X PID.c,136 :: 		Delay_ms(250);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main28:
	DECFSZ     R13+0, 1
	GOTO       L_main28
	DECFSZ     R12+0, 1
	GOTO       L_main28
	DECFSZ     R11+0, 1
	GOTO       L_main28
	NOP
	NOP
;R2D2 X PID.c,137 :: 		}
	GOTO       L_main25
;R2D2 X PID.c,139 :: 		}
L_main22:
;R2D2 X PID.c,141 :: 		perror = error;						//Previous error (perror)
	MOVF       _error+0, 0
	MOVWF      _perror+0
	MOVF       _error+1, 0
	MOVWF      _perror+1
	MOVF       _error+2, 0
	MOVWF      _perror+2
	MOVF       _error+3, 0
	MOVWF      _perror+3
;R2D2 X PID.c,144 :: 		error = ( (s1 * 2) + (s2 * 1) + (s3 * 0) + (s4 * -1) + (s5 * -2) ) / (s1 + s2 + s3 + s4 + s5);
	MOVF       _s1+0, 0
	MOVWF      R0+0
	MOVF       _s1+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       _s2+0, 0
	ADDWF      R0+0, 1
	MOVF       _s2+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      FLOC__main+0
	MOVF       R0+1, 0
	MOVWF      FLOC__main+1
	MOVF       _s4+0, 0
	MOVWF      R0+0
	MOVF       _s4+1, 0
	MOVWF      R0+1
	MOVLW      255
	MOVWF      R4+0
	MOVLW      255
	MOVWF      R4+1
	CALL       _Mul_16x16_U+0
	MOVF       R0+0, 0
	ADDWF      FLOC__main+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      FLOC__main+1, 1
	MOVF       _s5+0, 0
	MOVWF      R0+0
	MOVF       _s5+1, 0
	MOVWF      R0+1
	MOVLW      254
	MOVWF      R4+0
	MOVLW      255
	MOVWF      R4+1
	CALL       _Mul_16x16_U+0
	MOVF       R0+0, 0
	ADDWF      FLOC__main+0, 0
	MOVWF      R2+0
	MOVF       FLOC__main+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 0
	MOVWF      R2+1
	MOVF       _s2+0, 0
	ADDWF      _s1+0, 0
	MOVWF      R0+0
	MOVF       _s1+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _s2+1, 0
	MOVWF      R0+1
	MOVF       _s3+0, 0
	ADDWF      R0+0, 1
	MOVF       _s3+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 1
	MOVF       _s4+0, 0
	ADDWF      R0+0, 1
	MOVF       _s4+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 1
	MOVF       _s5+0, 0
	ADDWF      R0+0, 0
	MOVWF      R4+0
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _s5+1, 0
	MOVWF      R4+1
	MOVF       R2+0, 0
	MOVWF      R0+0
	MOVF       R2+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	CALL       _Int2Double+0
	MOVF       R0+0, 0
	MOVWF      _error+0
	MOVF       R0+1, 0
	MOVWF      _error+1
	MOVF       R0+2, 0
	MOVWF      _error+2
	MOVF       R0+3, 0
	MOVWF      _error+3
;R2D2 X PID.c,147 :: 		Propotional = Kp * error;
	MOVF       _Kp+0, 0
	MOVWF      R4+0
	MOVF       _Kp+1, 0
	MOVWF      R4+1
	MOVF       _Kp+2, 0
	MOVWF      R4+2
	MOVF       _Kp+3, 0
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _Propotional+0
	MOVF       R0+1, 0
	MOVWF      _Propotional+1
	MOVF       R0+2, 0
	MOVWF      _Propotional+2
	MOVF       R0+3, 0
	MOVWF      _Propotional+3
;R2D2 X PID.c,148 :: 		if (error == 0)
	CLRF       R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       _error+0, 0
	MOVWF      R0+0
	MOVF       _error+1, 0
	MOVWF      R0+1
	MOVF       _error+2, 0
	MOVWF      R0+2
	MOVF       _error+3, 0
	MOVWF      R0+3
	CALL       _Equals_Double+0
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main29
;R2D2 X PID.c,150 :: 		Integral = 0;
	CLRF       _Integral+0
	CLRF       _Integral+1
	CLRF       _Integral+2
	CLRF       _Integral+3
;R2D2 X PID.c,151 :: 		}
L_main29:
;R2D2 X PID.c,152 :: 		Integral = (Integral + error) * Ki;
	MOVF       _Integral+0, 0
	MOVWF      R0+0
	MOVF       _Integral+1, 0
	MOVWF      R0+1
	MOVF       _Integral+2, 0
	MOVWF      R0+2
	MOVF       _Integral+3, 0
	MOVWF      R0+3
	MOVF       _error+0, 0
	MOVWF      R4+0
	MOVF       _error+1, 0
	MOVWF      R4+1
	MOVF       _error+2, 0
	MOVWF      R4+2
	MOVF       _error+3, 0
	MOVWF      R4+3
	CALL       _Add_32x32_FP+0
	MOVF       _Ki+0, 0
	MOVWF      R4+0
	MOVF       _Ki+1, 0
	MOVWF      R4+1
	MOVF       _Ki+2, 0
	MOVWF      R4+2
	MOVF       _Ki+3, 0
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _Integral+0
	MOVF       R0+1, 0
	MOVWF      _Integral+1
	MOVF       R0+2, 0
	MOVWF      _Integral+2
	MOVF       R0+3, 0
	MOVWF      _Integral+3
;R2D2 X PID.c,153 :: 		Derivative = (error - perror) * Kd;
	MOVF       _perror+0, 0
	MOVWF      R4+0
	MOVF       _perror+1, 0
	MOVWF      R4+1
	MOVF       _perror+2, 0
	MOVWF      R4+2
	MOVF       _perror+3, 0
	MOVWF      R4+3
	MOVF       _error+0, 0
	MOVWF      R0+0
	MOVF       _error+1, 0
	MOVWF      R0+1
	MOVF       _error+2, 0
	MOVWF      R0+2
	MOVF       _error+3, 0
	MOVWF      R0+3
	CALL       _Sub_32x32_FP+0
	MOVF       _Kd+0, 0
	MOVWF      R4+0
	MOVF       _Kd+1, 0
	MOVWF      R4+1
	MOVF       _Kd+2, 0
	MOVWF      R4+2
	MOVF       _Kd+3, 0
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+0
	MOVF       R0+1, 0
	MOVWF      FLOC__main+1
	MOVF       R0+2, 0
	MOVWF      FLOC__main+2
	MOVF       R0+3, 0
	MOVWF      FLOC__main+3
	MOVF       FLOC__main+0, 0
	MOVWF      _Derivative+0
	MOVF       FLOC__main+1, 0
	MOVWF      _Derivative+1
	MOVF       FLOC__main+2, 0
	MOVWF      _Derivative+2
	MOVF       FLOC__main+3, 0
	MOVWF      _Derivative+3
;R2D2 X PID.c,154 :: 		Turn = Propotional + Integral + Derivative;
	MOVF       _Propotional+0, 0
	MOVWF      R0+0
	MOVF       _Propotional+1, 0
	MOVWF      R0+1
	MOVF       _Propotional+2, 0
	MOVWF      R0+2
	MOVF       _Propotional+3, 0
	MOVWF      R0+3
	MOVF       _Integral+0, 0
	MOVWF      R4+0
	MOVF       _Integral+1, 0
	MOVWF      R4+1
	MOVF       _Integral+2, 0
	MOVWF      R4+2
	MOVF       _Integral+3, 0
	MOVWF      R4+3
	CALL       _Add_32x32_FP+0
	MOVF       FLOC__main+0, 0
	MOVWF      R4+0
	MOVF       FLOC__main+1, 0
	MOVWF      R4+1
	MOVF       FLOC__main+2, 0
	MOVWF      R4+2
	MOVF       FLOC__main+3, 0
	MOVWF      R4+3
	CALL       _Add_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+8
	MOVF       R0+1, 0
	MOVWF      FLOC__main+9
	MOVF       R0+2, 0
	MOVWF      FLOC__main+10
	MOVF       R0+3, 0
	MOVWF      FLOC__main+11
	MOVF       FLOC__main+8, 0
	MOVWF      _Turn+0
	MOVF       FLOC__main+9, 0
	MOVWF      _Turn+1
	MOVF       FLOC__main+10, 0
	MOVWF      _Turn+2
	MOVF       FLOC__main+11, 0
	MOVWF      _Turn+3
;R2D2 X PID.c,155 :: 		lpower = basespeed - Turn;
	MOVF       _basespeed+0, 0
	MOVWF      R0+0
	MOVF       _basespeed+1, 0
	MOVWF      R0+1
	CALL       _Int2Double+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+4
	MOVF       R0+1, 0
	MOVWF      FLOC__main+5
	MOVF       R0+2, 0
	MOVWF      FLOC__main+6
	MOVF       R0+3, 0
	MOVWF      FLOC__main+7
	MOVF       FLOC__main+8, 0
	MOVWF      R4+0
	MOVF       FLOC__main+9, 0
	MOVWF      R4+1
	MOVF       FLOC__main+10, 0
	MOVWF      R4+2
	MOVF       FLOC__main+11, 0
	MOVWF      R4+3
	MOVF       FLOC__main+4, 0
	MOVWF      R0+0
	MOVF       FLOC__main+5, 0
	MOVWF      R0+1
	MOVF       FLOC__main+6, 0
	MOVWF      R0+2
	MOVF       FLOC__main+7, 0
	MOVWF      R0+3
	CALL       _Sub_32x32_FP+0
	CALL       _Double2Int+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+0
	MOVF       R0+1, 0
	MOVWF      FLOC__main+1
	MOVF       FLOC__main+0, 0
	MOVWF      _lpower+0
	MOVF       FLOC__main+1, 0
	MOVWF      _lpower+1
;R2D2 X PID.c,156 :: 		rpower = basespeed + Turn;
	MOVF       FLOC__main+4, 0
	MOVWF      R0+0
	MOVF       FLOC__main+5, 0
	MOVWF      R0+1
	MOVF       FLOC__main+6, 0
	MOVWF      R0+2
	MOVF       FLOC__main+7, 0
	MOVWF      R0+3
	MOVF       FLOC__main+8, 0
	MOVWF      R4+0
	MOVF       FLOC__main+9, 0
	MOVWF      R4+1
	MOVF       FLOC__main+10, 0
	MOVWF      R4+2
	MOVF       FLOC__main+11, 0
	MOVWF      R4+3
	CALL       _Add_32x32_FP+0
	CALL       _Double2Int+0
	MOVF       R0+0, 0
	MOVWF      _rpower+0
	MOVF       R0+1, 0
	MOVWF      _rpower+1
;R2D2 X PID.c,157 :: 		M(lpower,rpower);
	MOVF       FLOC__main+0, 0
	MOVWF      FARG_M_LM+0
	MOVF       FLOC__main+1, 0
	MOVWF      FARG_M_LM+1
	MOVF       R0+0, 0
	MOVWF      FARG_M_RM+0
	MOVF       R0+1, 0
	MOVWF      FARG_M_RM+1
	CALL       _M+0
;R2D2 X PID.c,159 :: 		count += 1;
	MOVF       _count+0, 0
	MOVWF      R0+0
	MOVF       _count+1, 0
	MOVWF      R0+1
	MOVF       _count+2, 0
	MOVWF      R0+2
	MOVF       _count+3, 0
	MOVWF      R0+3
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      0
	MOVWF      R4+2
	MOVLW      127
	MOVWF      R4+3
	CALL       _Add_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _count+0
	MOVF       R0+1, 0
	MOVWF      _count+1
	MOVF       R0+2, 0
	MOVWF      _count+2
	MOVF       R0+3, 0
	MOVWF      _count+3
;R2D2 X PID.c,161 :: 		}
	GOTO       L_main18
;R2D2 X PID.c,163 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
