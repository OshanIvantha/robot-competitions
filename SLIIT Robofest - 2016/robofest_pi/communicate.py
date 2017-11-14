import serial
# import serial.tools.list_ports
import traceback


class Port:
    def __init__(self):
        try:
            print 'Initializing port communication....'
            self.arduino = serial.Serial('/dev/ttyACM0', 9600, timeout=1)
            print 'Initializing port completed'
            self.arduino.write('[D]')
            self.arduino.readline()
        except serial.serialutil.SerialException:
            traceback.print_exc()
            print "No such serial port"
            # for port in serial.tools.list_ports.comports():
            #     print port

    def change_speed(self, lf, rf, lb, rb):
        try:
            command = 'M' + str(lf + 355) + str(rf + 355) + str(lb + 355) + str(rb + 355)
            self.arduino.write(command)
        except:
            traceback.print_exc()

    def get_distance(self):
        try:
            self.arduino.write('S')
            distances = self.arduino.readline()
            x = map(float, distances.strip().split())
            print x
            if len(x) == 3:
                return x[0], x[1], x[2]
            else:
                return 100, 100, 100
        except:
            traceback.print_exc()

    def arm_up(self):
        self.arduino.write('U')

    def arm_down(self):
        self.arduino.write('D')

    def arm_contract(self):
        self.arduino.write('C')

    def arm_expand(self):
        self.arduino.write('E')

    def quit_maze(self):
        self.arduino.write('Q')
