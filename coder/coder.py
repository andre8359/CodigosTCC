import sys
import os

class coder():

    def __init__(self,video,H,W,downsampleFactor,dir_):
        self.video  = video
        self.H = H
        self.W = W
        self.newH = int(float(H*downsampleFactor))
        self.newW = int(float(W*downsampleFactor))
        self.qscale = 1
        self.dir_ = dir_

    def __DeleteAviFiles__(self):
        os.system("rm -irf *.avi")

    def __coderJPEG__(self):
        ffmpeg_ = "ffmpeg "
        rate_ = "-r 2 -s "
        filter_ = " -filter:v select=\"mod(n-1\,2)\" "
        jpeg_ = "-r 1 -vcodec mjpeg "
        qscale_ = "-qscale " + self.qscale.__str__() + " "
        outputFIle_ = self.video + "_odd"
        print(ffmpeg_ + rate_ + self.W.__str__() + "x" + self.H.__str__() + " -i " + self.dir_+self.video + ".yuv"+ filter_ + jpeg_ + qscale_ + outputFIle_ )
        returnOdd = os.system(ffmpeg_ + rate_ + self.W.__str__() + "x" + self.H.__str__() + " -i " + self.dir_+ \
                                                                self.video + ".yuv"+ filter_ + jpeg_ + qscale_ + outputFIle_ + ".avi")

        os.system(ffmpeg_ + " -i " + outputFIle_ + ".avi"+ " -c:v rawvideo -pix_fmt yuv420p "+ outputFIle_ + ".yuv")

        outputFIle_ = self.video + "_even"
        returnEven = os.system(ffmpeg_ + rate_ + self.W.__str__() + "x" + self.H.__str__() + " -i " + self.dir_+ \
                                                                self.video + ".yuv"+ filter_ + jpeg_ + qscale_ + " -s "+ self.newW.__str__()\
                                                                + "x" + self.newH.__str__() +" " + outputFIle_ + ".avi")
        os.system(ffmpeg_ + " -i " +outputFIle_ + ".avi"+ " -c:v rawvideo -pix_fmt yuv420p "+outputFIle_ + ".yuv")

        if returnOdd + returnEven > 0:
            print "### HEY MOTHER FUCKER ! SOMETHINK ARE WRONG, LOOK UP!!!! ###"
            quit()

        self.__DeleteAviFiles__()


    def __coderH264__(self):
        print("TRETA")

    def __CalcBitRate__(self):
        print("TRETA")

