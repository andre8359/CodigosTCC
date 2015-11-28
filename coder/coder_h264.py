#! /usr/bin/env python

from coder import *
import sys
import os

video = sys.argv[1]
H = int(sys.argv[2])
W = int(sys.argv[3])
nFrames = int(sys.argv[4])
downsampleFactor = [2.0/8, 4.0/8]
dir_ = sys.argv[5]
qscale = range(16,52)

cod = coder(video,H,W,downsampleFactor[0],"../videos/",nFrames,1)
flag = 0
for i in downsampleFactor:
    cod.downsampleFactor = i
    cod.codingH264OddFrames()
    for x in qscale:
        cod.number = x
        cod.coderH264()
        cod.calcBitRate("h264")
        if flag == 0:
            cod.codingH264OriginalEvenFrames()
            cod.calcBitRateOriginal("h264")
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