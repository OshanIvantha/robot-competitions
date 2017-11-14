import time
import cv2
import communicate
import movement
import physics
import common

comm = communicate.Port()  # Raspberry pi - Arduino serial communication interface
# robot = physics.Robot(comm, '192.168.1.4:8080')             # Define current robot state
robot = physics.Robot(comm)  # Define current robot state
pid = movement.PID(robot)  # Adjust course through pid
control = movement.Control(robot, comm)  # Robot movement controls

while True:
    start = time.time()
    robot.see(image='white.png')

    gray_img = cv2.cvtColor(robot.current_frame, cv2.COLOR_BGR2GRAY)
    threshold_img = common.get_otsu_gaussian_threshold(gray_img)

    l1y = int(robot.get_frame_height() * 0.9)
    l2y = int(robot.get_frame_height() * 0.8)
    l3y = int(robot.get_frame_height() * 0.7)
    f_width = robot.get_frame_width()
    cv2.line(robot.current_frame, (0, l1y), (f_width, l1y), (255, 0, 0))
    cv2.line(robot.current_frame, (0, l2y), (f_width, l2y), (255, 0, 0))
    cv2.line(robot.current_frame, (0, l3y), (f_width, l3y), (255, 0, 0))

    end = time.time()
    diff = end - start
    if diff == 0:
        diff = 0.0000001

    fps = 1.0 / diff

    common.draw_machine_details(robot.processed_frame, fps)
    common.draw_crosshair(robot.processed_frame)

    cv2.imshow('Feed', robot.current_frame)
    cv2.imshow('Processed feed', robot.processed_frame)

    if cv2.waitKey(1) % 256 == 27:
        break

while True:
    start = time.time()
    robot.see(image='white.png')

    if robot.state == 'outer_in':
        pid.run_pid('white')
        control.drive()
    elif robot.state == 'inner_in':
        pass
    elif robot.state == 'box_lift':
        pass
    elif robot.state == 'inner_out':
        pass
    elif robot.state == 'outer_out':
        pass
    else:
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
