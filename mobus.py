def write_data(serial, address, value):
    data = bytearray(b'\x01\x06')
    data += address
    data += value
    data += calc_crc(data)
    print('send: ' + str(data))
    serial.write(data)

def read_data(serial, address, value):
    data = bytearray(b'\x01\x03')
    data += address
    data += value
    data += calc_crc(data)   
    print('send: ' + str(data))
    serial.write(data)

def calc_crc(data):
    crc = 0xFFFF
    for pos in data:
        crc ^= pos 
        for i in range(8):
            if ((crc & 1) != 0):
                crc >>= 1
                crc ^= 0xA001
            else:
                crc >>= 1
    return crc.to_bytes(2, 'little')
