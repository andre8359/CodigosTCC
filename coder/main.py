#! /usr/bin/env python

from coder import *

#fileD = open("../videos/catalogo.txt","r")
#downsampleFactor = [2.0/8, 4.0/8]
#line = fileD.readline()

# while line  :
#     line = fileD.readline()
#     data = line.split()
#     for x in downsampleFactor:
#         print(data[0] + data[2] + data[1] + x.__str__() + "../videos/")
#         cod = coder(data[0], int(data[2]), int(data[1]), x,"../videos/" )
#         cod.coderJPEG()
#         cod.calcBitRate()
        #cod.deleteVideoFiles()
cod = coder("foreman",288,352,0.5,"../videos/",1)
cod.coderJPEG()
cod.calcBitRate()
#foreman 352     288     300