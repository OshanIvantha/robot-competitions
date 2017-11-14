import cv2
import physics
import communicate
import movement
import maze_logic
import box_logic
import path_logic
import square_logic
import time
import common
from time import sleep

comm = communicate.Port()  # Raspberry pi - Arduino serial communication interface
# robot = physics.Robot(comm, '192.168.1.4:8080')             # Define current robot state
robot = physics.Robot(comm)  # Define current robot state
pid = movement.PID(robot)  # Adjust course through pid
control = movement.Control(robot, comm)  # Robot movement controls

maze = maze_logic.Maze(robot)  # Maze logic
box = box_logic.Box(robot, control)  # Box logic
path = path_logic.Path(robot, control, box)
square = square_logic.Square(robot, control)  # Path logic

control.drive(-100, -100, -100, -100)

while True:
    start = time.time()
    robot.see()

    robot.state = 'maze'

    if robot.state == 'maze':
        if box.box_seen():
            robot.state = 'box_lift'
            comm.quit_maze()

    elif robot.state == 'box_lift':
        box.position_the_robot()
        control.lift_the_box()
        robot.state = 'path'

    elif robot.state == 'path':
        if square.is_square_seen():
            robot.state = 'box_place'
        else:
            path.create_path()

    elif robot.state == 'box_place':
        square.position_the_robot()
        control.place_the_box()
        robot.state = 'stop'

    else:  # state == 'stop' or unknown state
        control.stop()

    end = time.time()
    diff = end - start
    if diff == 0:
        diff = 0.0000001

    fps = 1.0 / diff

    # common.draw_machine_details(robot.processed_frame, fps)
    # common.draw_crosshair(robot.processed_frame)
    #
    # cv2.imshow('Feed', robot.current_frame)
    # cv2.imshow('Processed feed', robot.processed_frame)
    # cv2.imshow('Threshold image', path.threshold_img)

    if cv2.waitKey(1) % 256 == 27:
        break

robot.cam.release()
cv2.destroyAllWindows()
