from time import sleep


class PID:
    def __init__(self, robot):
        self.robot = robot
        self.base_speed = 150                               # Speed when moving straight :- affect the average speed
        self.pVar, self.iVar, self.dVar = 0.0, 0.0, 0.0     # Proportional, Integral and Derivative values

        self.kp = 10.0  # Proportional constant
        self.ki = 0.0   # Integral constant
        self.kd = 0.0   # Derivative constant

        self.error = 0.0        # -10 <= Current error <= 10
        self.pre_error = 0.0    # Previous error
        self.turn = 0.0

        self.frame_width = float(self.robot.get_frame_width())

    def calculate_error_from_offset(self, line_color):
        ###############################
        # Calculate error from offset #
        ###############################
        print 'Error from offset'

    def run_pid(self, line_color):
        self.calculate_error_from_offset(line_color)

        # Calculate P
        self.pVar = self.kp * self.error

        # Calculate I
        if self.error == 0.0:
            self.iVar = 0.0
        else:
            self.iVar = (self.iVar + self.error) * self.ki

        # Calculate D
        self.dVar = (self.error - self.pre_error) * self.kd

        self.turn = self.pVar + self.iVar + self.dVar
        self.robot.l_motor = self.base_speed + self.turn
        self.robot.r_motor = self.base_speed + self.turn


class Control:
    def __init__(self, robot, comm):
        self.robot = robot
        self.comm = comm
        self.positive_thresh = 110  # Minimum forward power level which the dc motors work
        self.negative_thresh = -110  # Minimum reverse power level which the dc motors work

    # Control the motor speeds
    def drive(self, l_motor=None, r_motor=None):
        if l_motor is not None:
            self.robot.l_motor = l_motor
        if r_motor is not None:
            self.robot.r_motor = r_motor

        # Change the power level if motors are in stall state
        # diff = (self.positive_thresh - self.negative_thresh)
        # if (self.robot.l_motor < self.positive_thresh) & (self.robot.l_motor > self.negative_thresh):
        #     self.robot.l_motor -= diff
        # if (self.robot.r_motor < self.positive_thresh) & (self.robot.r_motor > self.negative_thresh):
        #     self.robot.r_motor -= diff

        # Verify whether motor power values are in range of -255 and 255
        if self.robot.l_motor > 255:
            self.robot.l_motor = 255
        elif self.robot.l_motor < -255:
            self.robot.l_motor = -255

        if self.robot.r_motor > 255:
            self.robot.r_motor = 255
        elif self.robot.r_motor < -255:
            self.robot.r_motor = -255

        self.comm.change_speed(self.robot.l_motor, self.robot.r_motor)

    def forward(self, speed=150, t=0.01):
        speed = abs(speed)
        self.drive(speed, speed)
        sleep(t)

    def reverse(self, speed=130, t=0.1):
        speed = abs(speed)
        self.drive(-1 * speed, -1 * speed)
        sleep(t)

    def turn_left(self, speed=170, t=0.5):
        speed = abs(speed)
        self.drive(-1 * speed, speed)
        sleep(t)

    def turn_right(self, speed=170, t=0.5):
        speed = abs(speed)
        self.drive(speed, -1 * speed)
        sleep(t)

    def turn_back(self, speed=180, t=1):
        speed = abs(speed)
        self.drive(speed, -1 * speed)
        sleep(t)

    def brake(self):
        self.drive(0, 0)
        sleep(5)

    def stop(self):
        self.drive(0, 0)
        sleep(1000000)

    def lift_the_box(self):
        self.comm.lift()

    def place_the_box(self):
        self.comm.place()
