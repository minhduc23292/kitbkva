import serial
import time

from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot

import mobus


class Motor(QObject):
    def __init__(self):
        QObject.__init__(self)
        self.serial_port = None

    connectionFinished = pyqtSignal(bool, arguments = ['result'])
    errorOccurred = pyqtSignal(str, arguments = ['error'])

    @pyqtSlot(str)
    def test_connection(self, port):
        try:
            self.serial_port = serial.Serial(port)
        except:
            print('Connect failed!')
            self.connectionFinished.emit(False)
            return

        self.serial_port.baudrate = 9600
        self.serial_port.bytesize = 8
        self.serial_port.stopbits = serial.STOPBITS_ONE
        self.serial_port.parity = serial.PARITY_NONE
        self.serial_port.timeout = 2000

        mobus.read_data(self.serial_port, bytearray(b'\x30\x00'), bytearray(b'\x00\x01'))
        result = False
        if self.serial_port.is_open:
            for i in range(10):
                size = self.serial_port.inWaiting()
                if size:
                    data = self.serial_port.read(size)
                    print(data)
                    result = True
                    break

                time.sleep(0.2)
            self.serial_port.close()
        
        print('Connect successful!' if result else 'Connect failed!')
        self.connectionFinished.emit(result)
        return 
        
    @pyqtSlot(str)
    def connect(self, port):
        if not self.serial_port is None and self.serial_port.is_open:
            return

        try:
            self.serial_port = serial.Serial(port)
        except:
            print('Connect failed!')
            self.errorOccurred.emit('Connect failed!')
            return

        self.serial_port.baudrate = 9600
        self.serial_port.bytesize = 8
        self.serial_port.stopbits = serial.STOPBITS_ONE
        self.serial_port.parity = serial.PARITY_NONE
        self.serial_port.timeout = 2000
        
    @pyqtSlot()
    def disconnect(self):
        if not self.serial_port is None and self.serial_port.is_open:
            self.serial_port.close()
        
    @pyqtSlot()
    def run_manual(self):
        if not self.serial_port is None and self.serial_port.is_open:
            mobus.write_data(self.serial_port, bytearray(b'\x20\x00'), bytearray(b'\x00\x01'))
        
    @pyqtSlot()
    def pause_manual(self):
        if not self.serial_port is None and self.serial_port.is_open:
            mobus.write_data(self.serial_port, bytearray(b'\x20\x00'), bytearray(b'\x00\x06'))
        
    @pyqtSlot(str)
    def update_frequency(self, frequency):        
        if not self.serial_port is None and self.serial_port.is_open:
            frequency = int(float(frequency) * 200)
            mobus.write_data(self.serial_port, bytearray(b'\x40\x00'), frequency.to_bytes(2, byteorder='big'))
            