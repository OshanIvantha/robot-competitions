import cv2
import contour
import common
from time import sleep


class Path:
    def __init__(self, robot, control, box):
        self.robot = robot
        self.control = control
        self.box = box

        self.frame_width = self.robot.get_frame_width()

        self.gray_img = None
        self.threshold_img = None

    def create_path(self):
        self.robot.processed_frame = self.refine_current_view()

        contours = common.get_contours(self.threshold_img.copy())
        arrow_list = self.find_arrows(contours)

        arrow_count = len(arrow_list)

        if arrow_count == 0:
            self.control.drive(130, 130, 130, 130)
            sleep(0.1)
        else:
            nearest_arrow = arrow_list[0]
            for arrow in arrow_list:
                if arrow.mid_y > nearest_arrow.mid_y:
                    nearest_arrow = arrow

            nearest_arrow.draw_initial_point(self.robot.processed_frame)
            nearest_arrow.draw_mid_base_point(self.robot.processed_frame)
            nearest_arrow.draw_head_point(self.robot.processed_frame)
            nearest_arrow.enable_lines(self.robot.processed_frame)
            nearest_arrow.enable_labels(self.robot.processed_frame)

            m = nearest_arrow.get_main_axis_gradient()
            # c = arrow.get_main_axis_intercept()
            # a = min([arrow.in2y, arrow.midy])
            # b = max([arrow.in2y, arrow.midy])
            # for y in range(a, b + 1):
            if m == 0.0:
                if nearest_arrow.in2x > nearest_arrow.midx:  # Points East
                    self.control.drive(130, 130, 130, 130)
                    sleep(0.5)
                    self.control.turn_right()
                else:  # Points West
                    self.control.drive(130, 130, 130, 130)
                    sleep(0.5)
                    self.control.turn_left()
            elif m == float('Inf') or m == float('-Inf'):
                self.control.drive(130, 130, 130, 130)
                sleep(0.1)
            else:
                # Turn robot according to the gradient
                pass

    def refine_current_view(self):
        if self.box.color == 'red':
            canvas_frame = common.apply_mask(self.robot.current_frame, color='red')
        elif self.box.color == 'green':
            canvas_frame = common.apply_mask(self.robot.current_frame, color='green')
        elif self.box.color == 'blue':
            canvas_frame = common.apply_mask(self.robot.current_frame, color='blue')
        else:
            canvas_frame = common.apply_mask(self.robot.current_frame)

        self.gray_img = cv2.cvtColor(canvas_frame, cv2.COLOR_BGR2GRAY)
        self.threshold_img = common.get_otsu_gaussian_threshold(self.gray_img)

        return canvas_frame

    def find_arrows(self, contours):
        arrow_list = []
        for cnt in contours:
            peri = cv2.arcLength(cnt, True)
            approx = cv2.approxPolyDP(cnt, 0.01 * peri, True)
            cv2.drawContours(self.robot.processed_frame, [approx], -1, (0, 255, 0), 2)

            if len(approx) == 7:
                for i in range(7):
                    arrow = contour.Arrow(approx, i)
                    if arrow.is_valid_arrow():
                        arrow_list.append(arrow)
                        break

        return arrow_list
