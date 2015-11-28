from coder import *
import sys
import os

video = sys.argv[1]
H = int(sys.argv[2])
W = int(sys.argv[3])
dir_ = sys.argv[4]
qscale = int(sys.argv[5])
downsampleFactor = float(sys.argv[6])

cod = coder(video,H,W,downsampleFactor,dir_,1,qscale)
cod.codingJPEGOddFrames()
cod.coderJPEG()

