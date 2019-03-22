# -*- coding: utf-8 -*-
"""
Created on Wed Mar 21  2019

@author: Haiquan
"""

import socket
# import numpy as np
import pickle
import struct
import sys

# %%%%%%%%%% write the mif file %%%%%%%%%%%%%%%%%%%%%
def tcp_write_mifs(mif_data):
    #####  % % % % % % % % % % % flash erase % % % % % % % % % % % % %
    for mm in range(3, 4):
        msg = b"\xBA\x02" + chr(mm).encode(encoding='ansi') + b"\x00"
        print(msg)
        tcpCliSocket.send(msg)
        tmp = tcpCliSocket.recv(tcp_buff_size)
        print('0x{:02X} 0x{:02X}\n'.format(tmp[2], tmp[3]))

    ###### %%%%%%%%%%%%% Write all the_mifs %%%%%%%%%%%%%%%%
    offset = 16384  # \x4000 /32bits  /every 250Wd = 1000Bytes
    for nn in range(0, 25414 * 4, 250 * 4):
        # mif_addr = bin(nn/2,19)
        mif_addr = '{:019b}'.format(nn + offset)
        head = b"\xBB" + \
               struct.pack('B', int(mif_addr[-8: ], 2)) + \
               struct.pack('B', int(mif_addr[0: 3], 2)) + \
               struct.pack('B', int(mif_addr[3:-8], 2))
        print(head)

        tcpCliSocket.send(head + mif_data[nn:nn + 250 * 4])
        tmp = tcpCliSocket.recv(tcp_buff_size)
        print('0x{:02X} 0x{:02X}\n'.format(tmp[2], tmp[3]))

    tcpCliSocket.send(b"\xBA\x03\x00\x00")
    tmp = tcpCliSocket.recv(tcp_buff_size)
    print('0x{:02X} 0x{:02X}\n'.format(tmp[2], tmp[3]))

# %%%%%%%%%%%%%%%%% The main file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if __name__ == '__main__':

    tcp_host = '192.168.10.107'
    tcp_port = 3000
    tcp_buff_size = 4
    tcp_addr = (tcp_host, tcp_port)

    tcpCliSocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)  # type: socket

    tcpCliSocket.settimeout(2.0)
    print('The socket timeout has been set to {:3.2f} s'.format(tcpCliSocket.gettimeout()))

    try:
        tcpCliSocket.connect(tcp_addr)  # client
    except socket.error as err_msg:
        print("TCP socket message:", err_msg)
        sys.exit(1)
    # >>> errorTab[10054]
    # 'The connection has been reset.'

    f = open('mif.dat', 'rb')
    mif_data = pickle.load(f)
    f.close()

    tcp_write_mifs(b''.join(i for i in mif_data))

    tcpCliSocket.close()

