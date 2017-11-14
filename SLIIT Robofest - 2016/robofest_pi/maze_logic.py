class Maze:
    def __init__(self, robot):
        self.robot = robot
        self.path_width = 30
        self.front_gap = (self.path_width - robot.length) / 2.0