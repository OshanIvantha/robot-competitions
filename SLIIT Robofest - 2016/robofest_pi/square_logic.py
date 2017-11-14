import cv2
import numpy as np
import common
from time import sleep


class Square:
    def __init__(self, robot, control):
        self.robot = robot
        self.control = control

        self.points = None
        self.center_accuracy = 100  # is used when checking the box is in the center or not
        self.variance = 0.2  # Variance for right-square
        self.line = None
        self.thresh_frame = None
        self.img_height = robot.current_frame.shape[0]
        self.img_width = robot.current_frame.shape[1]
        self.closest_point = None
        self.img_center = (self.img_width / 2, self.img_height / 2)
        self.line_center = None
        self.finish_line = self.img_height - 50

    def position_the_robot(self):
        sleep_out = 0.1

        # Center the robot
        if self.is_left_shifted():
            while not self.is_centered():
                if self.is_square_seen():
                    self.control.drive(100, 150, 100, 150)
                    sleep(sleep_out)
                else:
                    self.control.drive(100, 120, 100, 120)
                    sleep(sleep_out)
        elif self.is_right_shifted():
            while not self.is_centered():
                if self.is_square_seen():
                    self.control.drive(150, 100, 150, 100)
                    sleep(sleep_out)
                else:
                    self.control.drive(120, 100, 120, 100)
                    sleep(sleep_out)

        # Drive until the target distance is met
        while self.distance_to_finish_line() > self.center_accuracy:
            self.control.drive(120, 120, 120, 120)
        self.control.drive(0, 0, 0, 0)

    def is_square_seen(self):
        masked = common.apply_mask(self.robot.current_frame, self.robot.color)
        gray_img = cv2.cvtColor(masked, cv2.COLOR_BGR2GRAY)
        thresh = common.get_otsu_gaussian_threshold(gray_img)
        self.thresh_frame = cv2.cvtColor(thresh, cv2.COLOR_GRAY2BGR)
        contours = common.get_contours(thresh)
        return self.find_square(contours, self.variance)

    def find_square(self, contours, varience):
        for c in contours:
            moments = cv2.moments(c)
            if moments["m00"] > 10000:  # make 1000 if it didnt work
                r = cv2.minAreaRect(c)
                r = ((r[0][0], r[0][1]), (r[1][0], r[1][1]), r[2])
                (width, height) = (r[1][0], r[1][1])
                box = cv2.boxPoints(r)

                box = np.int0(box)
                if (1 - varience) * width < height < (1 + varience) * width:
                    self.points = box
                    # self.center_x = int((min(box[:, 0]) + max(box[:, 0])) / 2)
                    # self.center_y = int((min(box[:, 1]) + max(box[:, 1])) / 2)

                    return True
        return False

    def pickline(self):
        square = np.copy(self.points)
        y1 = np.argmax(square[:, 1])
        p1 = (square[y1, 0], square[y1, 1])

        y_max = np.argmin(square[:, 1])
        square[y1, 1] = square[y_max, 1]
        y2 = np.argmax(square[:, 1])
        p2 = (square[y2, 0], square[y2, 1])

        self.closest_point = p1
        self.line = (p1, p2)
        self.line_center = (int((p1[0] + p2[0]) / 2), int((p1[1] + p2[1]) / 2))

    def check(self):
        if self.is_square_seen():
            self.pickline()
        else:
            self.line = None
            self.line_center = None
            self.closest_point = None

    def is_centered(self):  # Check whether the box is centered or not
        return abs(self.img_center[0] - self.line_center[0]) <= self.center_accuracy

    def is_left_shifted(self):
        return self.get_left_shift() > self.center_accuracy

    def is_right_shifted(self):
        return self.get_right_shift() > self.center_accuracy

    def get_left_shift(self):  # Distance to the left from the center
        shifting = (self.img_center[0] - self.center_accuracy) - self.line_center[0]
        return shifting if shifting > 0 else 0

    def get_right_shift(self):  # Distance to the right from the center
        shifting = self.line_center[0] - (self.img_center[0] + self.center_accuracy)
        return shifting if shifting > 0 else 0

    def distance_to_finish_line(self):
        return self.finish_line - self.closest_point[1]

    def show_details(self):
        frame = self.thresh_frame
        text_list = []

        if self.line is not None:
            cv2.drawContours(frame, [self.points], -1, (0, 0, 255), 2)
            cv2.circle(frame, self.line[0], 7, (0, 255, 0), 2)
            cv2.circle(frame, self.line[1], 7, (0, 255, 0), 2)
            cv2.circle(frame, self.line_center, 7, (0, 255, 0), 2)
            cv2.circle(frame, self.closest_point, 14, (0, 255, 0), 2)
            cv2.line(frame, self.line[0], self.line[1], (255, 0, 0), 1)

            ls = self.get_left_shift()
            rs = self.get_right_shift()

            if ls > 0:
                text_list.append("LEFT SHIFTED | " + str(ls))
            elif rs > 0:
                text_list.append("RIGHT SHIFTED | " + str(rs))
            else:
                text_list.append("CENTERED")

            text_list.append("COLOR: " + self.robot.color)
            text_list.append("PID DISTANCE VALUE : " + str(self.distance_to_finish_line()))

        else:
            text_list.append("SQUARE NOT FOUND")

        text_list.append("CENTER ACCURACY : " + str(self.center_accuracy))

        pos = 30
        for i in text_list:
            cv2.putText(frame, i, (10, pos), cv2.FONT_HERSHEY_COMPLEX_SMALL, 0.8, (255, 0, 0))
            pos += 20

        cv2.line(frame, (self.img_center[0] - self.center_accuracy, 50),
                 (self.img_center[0] - self.center_accuracy, self.img_height - 50), (128, 128, 128), 1)
        cv2.line(frame, (self.img_center[0] + self.center_accuracy, 50),
                 (self.img_center[0] + self.center_accuracy, self.img_height - 50), (128, 128, 128), 1)
        cv2.line(frame, (50, self.finish_line), (self.img_width - 50, self.finish_line), (128, 128, 128), 1)

        cv2.imshow("Square View", frame)
