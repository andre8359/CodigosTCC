import sys
import os
import time

def mensure(name):
    #print "powertop  --html=" + name + ".html"
    os.system("powertop  --html=" + name + ".html")
def encode(video, W, H, d):
    time.sleep(3)
    #os.system("python codificacao_resolucao_mista.py akiyo 288 352 ../videos/ 0 0.5")
    #os.system("rm *.yuv *.avi")
    os.system("python codificacao_resolucao_original.py " + video + " " +H + " " + W+ "  ../videos/ " + q.__str__() +" " + d.__str__())
    os.system("rm *.yuv *.avi")

downsampleFactor = [1]#[2.0/8, 4.0/8]
qscale = [1]#range(2,32)


with open('../videos/catalogo.txt') as fp:
    for line in fp:
        [video, W, H, nFrames] = line.split()
        for num in downsampleFactor:
            for q in qscale:
                newpid = os.fork()
                if newpid == 0:
                    mensure(video+"_original_"+num.__str__()+"_"+q.__str__())
                else:
                    encode(video, W, H, nFrames)
        break
        os.system("( speaker-test -t sine -f 1000 )& pid=$! ; sleep 1s ; kill -9 $pid")