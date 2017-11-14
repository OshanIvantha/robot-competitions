class seekBox:
    def __init__(self, box_logic, robot):
        self.box_logic = box_logic
        self.movement = movement
        self.robot =robot
        self.speed_factor = 1
        self.distance_to_pick = 6
        
    def goToBox(self):
        while True:
            self.box_logic.check()
            if not box_logic.is_centered():
                ls = box_logic.get_left_shift()
                rs = box_logic.get_right_shift()
                if ls > 0:
                    speed = self.speed_factor * ls
                    self.rotate_left(speed)
                elif rs > 0:
                    speed = self.speed_factor * rs
                    self.rotate_right(speed)
            else:
                self.stop_rotations()
                self.robot.update_sonar_data()
                distError = distance - self.robot.front_sonar
                while distError != 0:
                    if distError > 0:
                        self.go_forward(self.speed_factor * distError)
                    else:
                        self.go_backword(self.speed_factor * distError)
                    self.robot.update_sonar_data()
                    distError = distance - self.robot.front_sonar


    def rotate_left(self, speed):
        robot.drive(-1*speed, speed, -1*speed, speed)

    def rotate_right(self, speed):
        robot.drive(speed, -1*speed, speed, -1*speed)            

    def stop_rotations(self):
        robot.drive(0,0,0,0)

    def go_forward(self, speed):
        robot.drive(speed, speed, speed, speed)

    def go_backword(self, speed):
        robot.drive(-1*speed, -1*speed, -1*speed, -1*speed)    
