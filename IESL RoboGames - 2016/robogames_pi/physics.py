import cv2
import numpy as np
from androidcamfeed import AndroidCamFeed


# from pivideostream import PiVideoStream


class Robot:
    def __init__(self, comm, ip=None):
        # Dimensions
        self.length = 0.0
        self.width = 0.0
        self.height = 0.0

        if ip is None:
            # Capture the feed from camera
            self.cam = cv2.VideoCapture(0)
            self.ret, self.current_frame = self.cam.read()
            self.processed_frame = np.zeros(self.current_frame.shape, np.uint8)

            # Capture video feed from picamera
            # self.cam = PiVideoStream(resolution=(640,480), framerate=32)
            # self.current_frame = None
            # while self.current_frame is None:
            # 	self.current_frame = self.cam.read()
            # self.processed_frame = np.zeros(self.current_frame.shape, np.uint8)
            # self.cam = PiVideoStream(resolution=(640,480), framerate=32)
            # self.current_frame = self.cam.read()
            # self.processed_frame = np.zeros(self.current_frame.shape, np.uint8)
        else:
            # Capture the feed from android phone
            self.cam = AndroidCamFeed(ip)
            self.ret, self.current_frame = self.cam.read()
            while not self.ret:
                if self.cam.isOpened():
                    self.ret, self.current_frame = self.cam.read()
        self.processed_frame = np.zeros(self.current_frame.shape, np.uint8)

        self.comm = comm

        self.state = 'outer_in'

        self.l_motor = 0  # Left motor speed
        self.r_motor = 0  # Right motor speed

        self.front_sonar = 0  # Front sonar distance
        self.color = ""

    def see(self, image=None):
        if image is None:
            ret, self.current_frame = self.cam.read()
        else:
            self.current_frame = cv2.imread('./sample/' + image)
            self.processed_frame = np.zeros(self.current_frame.shape, np.uint8)

    def update_sonar_data(self):
        self.front_sonar = self.comm.get_distance()

    def get_frame_height(self):
        height, width, channels = self.current_frame.shape
        return height

    def get_frame_width(self):
        height, width, channels = self.current_frame.shape
        return width
