import math
import cv2
import common
import numpy as np


class Box:
    def __init__(self, robot, control):
        self.robot = robot
        self.control = control

        self.color = ""
        self.box_visible_state = ""
        self.box_points = None
        self.box_center = (0, 0)
        self.box_size = (0, 0)
        self.center_accuracy = 100  # is used when checking the box is in the center or not
        self.square_var = 0.2

        self.img_height = 0
        self.img_width = 0
        self.img_center = (0, 0)  ##### TO EDIT: get the width from a global variable #####
        self._update_img_info()
        self.thresh_frame = None

        self.detected_edge = ""
        self.check_around_range = 45            #- Half of range in degrees to check around


    def position_the_robot(self):
        while True:
            self.box_logic.check()
            if not box_logic.is_centered():
                ls = box_logic.get_left_shift()
                rs = box_logic.get_right_shift()
                if ls > 0:
                    speed = self.speed_factor * ls
                    self.robot.rotate_left(speed)
                elif rs > 0:
                    speed = self.speed_factor * rs
                    self.lrotate_right(speed)
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




    def _go_closer(self):
        pass

    def _go_to_box(self):
        pass

    def _check_around(self):
        if self.detected_edge == "LEFT":
            self.robot.turn_left(self.check_around_range)            #- Turn the robot left 45 degrees
            self.robot.turn_right(2 * self.check_around_range)
            
        pass

    def _check_around_left(self, degree):
        pass

    def _check_around_right(self, degree):
        pass









    ##--BOX-DETECTION--##
    def _update_img_info(self):
        image = self.robot.current_frame
        self.img_height = image.shape[0]
        self.img_width = image.shape[1]
        self.img_center = (self.img_width / 2, self.img_height / 2)


    def _reset_old_values(self):
        self.all_rectangles = []
        self.box_points = None
        self.box_center = (0, 0)


    def check_rectangles(self, mask):
        im, contours, hierarchy = cv2.findContours(mask, cv2.RETR_LIST, cv2.CHAIN_APPROX_SIMPLE)
        largest_contour = None
        max_area = 0
        var = 0.2  # Variance for right-square
        rects = []

        for idx, contour in enumerate(contours):
            area = cv2.contourArea(contour)
            if area > max_area:
                max_area = area
                largest_contour = contour
                if not largest_contour is None:
                    moment = cv2.moments(largest_contour)
                    if moment["m00"] > 1000:
                        rect = cv2.minAreaRect(largest_contour)
                        rect = ((rect[0][0], rect[0][1]), (rect[1][0], rect[1][1]), rect[2])
                        rects.append(rect)
        return rects


    def rect2boxpoints(self, rect):
        return np.int0(cv2.boxPoints(rect))


    def is_square(self, rect):
        width, height = rect[1][0], rect[1][1]
        return (1 - self.square_var) * width < height < (1 + self.square_var) * width


    def set_box(self, rect):
        self.box_size = (rect[1][0], rect[1][1])
        self.box_points = self.rect2boxpoints(rect)
        self.box_center = (int(self.box_points[:, 0].mean()), int(self.box_points[:, 1].mean()))


    def check_box(self, mask):

        self.thresh_frame = cv2.cvtColor(mask, cv2.COLOR_GRAY2BGR)

        rect_list = self.check_rectangles(mask)
        for rect in rect_list:
            if self.is_square(rect):
                self.set_box(rect)
                self.box_visible_state = "TOTALLY"
                return True

        if len(rect_list) > 0:
            self.set_box(rect_list[0])
            self.box_visible_state = "PARTIALLY"
        else:
            self.box_visible_state = ""

        return False


    def check(self):
        self._reset_old_values()

        # Check for the box for each color #
        frame = cv2.cvtColor(self.robot.current_frame, cv2.COLOR_BGR2HSV)
        if self.check_box(common.get_blue_mask(frame)):
            self.color = "BLUE"
        elif self.check_box(common.get_green_mask(frame)):
            self.color = "GREEN"
        elif self.check_box(common.get_red_mask(frame)):
            self.color = "RED"
        else:
            self.color = ""


    def box_seen(self):
        self.check()
        return self.box_visible_state != ""


    def is_box_totally_visible(self):
        return self.box_visible_state == "TOTALLY"


    def is_box_partially_visible(self):
        return self.box_visible_state == "PARTIALLY"


    def is_centered(self):  # Check wheather the box is centered or not
        return abs(self.img_center[0] - self.box_center[0]) <= self.center_accuracy


    def left_shifting(self):  # Distance to the left from the center
        shifting = (self.img_center[0] - self.center_accuracy) - self.box_center[0]
        return shifting if shifting > 0 else 0


    def right_shifting(self):  # Distance to the right from the center
        shifting = self.box_center[0] - (self.img_center[0] + self.center_accuracy)
        return shifting if shifting > 0 else 0


    def show(self):  # For testing
        text_list = []

        frame = self.thresh_frame
        if self.box_seen():
            sqColor = (100, 255, 0)
            if self.is_box_partially_visible():
                sqColor = (255, 0, 255)
            cv2.drawContours(frame, [self.box_points], 0, sqColor, 2)
            cv2.circle(frame, self.box_center, 2, (0, 255, 0), 1)

            shift_text = ""
            ls = self.left_shifting()
            rs = self.right_shifting()

            if ls > 0:
                text_list.append("LEFT SHIFTED | " + str(ls))
            elif rs > 0:
                text_list.append("RIGHT SHIFTED | " + str(rs))
            else:
                text_list.append("CENTERED")

            text_list.append("COLOR: " + self.color)
            text_list.append("STATE: " + self.box_visible_state)
            text_list.append("WIDTH: {0} | HEIGHT: {1}".format(int(self.box_size[0]), int(self.box_size[1])))
        else:
            text_list.append("BOX NOT FOUND")

        text_list.append("CENTER ACCURACY : " + str(self.center_accuracy))

        pos = 30
        for i in text_list:
            cv2.putText(frame, i, (10, pos), cv2.FONT_HERSHEY_COMPLEX_SMALL, 0.8, (255, 0, 0))
            pos += 20

        cv2.line(frame, (self.img_center[0] - self.center_accuracy, 50),
                 (self.img_center[0] - self.center_accuracy, self.img_height - 50), (128, 128, 128), 1)
        cv2.line(frame, (self.img_center[0] + self.center_accuracy, 50),
                 (self.img_center[0] + self.center_accuracy, self.img_height - 50), (128, 128, 128), 1)

        cv2.imshow("Box View", frame)
