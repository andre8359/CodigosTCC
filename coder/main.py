#! /usr/bin/env python

from coder import *
import sys
import os



video = sys.argv[1]
H = int(sys.argv[2])
W = int(sys.argv[3])
downsampleFactor = [2.0/8, 4.0/8]
dir_ = sys.argv[4]
qscale = range(2,32)

cod = coder(video,H,W,0.5,"../videos/",1)
flag = 0
for i in downsampleFactor:
    cod.downsampleFactor = i
    cod.codingJpegOddFrames()
    for x in qscale:

        cod.number = x
        cod.coderJPEG()
        cod.calcBitRate()
        if flag == 0:
            cod.codingJpegOriginalEvenFrames()
            cod.calcBitRateOriginal()
    flag = 1
        #   cod.deleteAviFiles()

cod.getOriginalEvenFrames()
cod.deleteAviFiles()
os.system("mkdir videos")
os.system("mv " + video +"* videos")
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

#foreman 352     288     300