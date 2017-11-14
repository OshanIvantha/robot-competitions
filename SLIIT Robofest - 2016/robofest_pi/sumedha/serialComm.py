from time import sleep
import serial

class Arduino:
    def __init__(self):
        self.port = "COM1"
        self.ser = serial.Serial(self.port, 9600, timeout=2)
        
    def encode(self, arr):
        msg = ""
        sign = ""
        for i in range(len(arr)):
            num = arr[i]
            msg += str(chr(abs(num)))
            sign += "1" if num<0 else "0"
        msg += chr(int(int(sign, 2)))
        return msg

    #to update
    to update
    def decode(self, msg):
        arr = []
        sign = format(ord(msg[-1]), "08b")
        for i in range(len(msg)-1):                    #ignore last char (sign)
            num = ord(msg[i])
            if sign[(-1*(i+1))]=="1": num *= -1
            arr.append(num)
        return arr

    def setMotorData(self, valArr):
        ser.write(self.encode(valArr))

    def getSensorValues(self):
        ser.write('S')
        return self.decode(ser.readString())

#a = Arduino()
#print(a.decode(a.encode([-10, 88, 255])))

#a = Arduino()
#a.setMotorData([1,2,2,3])
#print(a.getSensorValues())


