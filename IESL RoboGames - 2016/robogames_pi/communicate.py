import serial
# import serial.tools.list_ports
import traceback


class Port:
    # def __init__(self):
    #     try:
    #         print 'Initializing port communication....'
    #         self.arduino = serial.Serial('/dev/ttyACM0', 9600, timeout=1)
    #         print 'Initializing port completed'
    #         self.arduino.write('[D]')
    #         self.arduino.readline()
    #     except serial.serialutil.SerialException:
    #         traceback.print_exc()
    #         print "No such serial port"
    #         # for port in serial.tools.list_ports.comports():
    #         #     print port

    def change_speed(self, left_speed, right_speed):
        # try:
        #     command = 'M' + str(left_speed + 355) + str(right_speed + 355)
        #     self.arduino.write(command)
        # except:
        #     traceback.print_exc()
        print str(left_speed) + '  ' + str(right_speed)

    def get_distance(self):
        try:
            self.arduino.write('S')
            distance = self.arduino.readline()
            distance = float(distance)
            return distance
        except:
            traceback.print_exc()

    def lift(self):
        self.arduino.write('L')

    def place(self):
        self.arduino.write('P')

    def arm_up(self):
        self.arduino.write('U')

    def arm_down(self):
        self.arduino.write('D')

    def arm_contract(self):
        self.arduino.write('C')

    def arm_expand(self):
        self.arduino.write('E')
