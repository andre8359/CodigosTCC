import sys
import os

class coder():

    def __init__(self,video,H,W,downsampleFactor,dir_):
        self.video  = video
        self.H = H
        self.W = W
        self.downsampleFactor = downsampleFactor
        self.newH = int(float(H*downsampleFactor))
        self.newW = int(float(W*downsampleFactor))
        self.qscale = 1
        self.dir_ = dir_
        self.video_odd = video + "_odd.yuv"
        self.video_even = video + "_even.yuv"



    def  coderJPEG(self):
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
        filter_ = " -filter:v select=\"mod(n\,2)\" "
        returnEven = os.system(ffmpeg_ + rate_ + self.W.__str__() + "x" + self.H.__str__() + " -i " + self.dir_+ \
                                                                self.video + ".yuv"+ filter_ + jpeg_ + qscale_ + " -s "+ self.newW.__str__()\
                                                                + "x" + self.newH.__str__() +" " + outputFIle_ + ".avi")
        os.system(ffmpeg_ + " -i " +outputFIle_ + ".avi"+ " -c:v rawvideo -pix_fmt yuv420p "+outputFIle_ + ".yuv")

        if returnOdd + returnEven > 0:
            print("### ERRO!!!! ###")
            quit()

        self.deleteAviFiles()


    def coderH264(self):
        print("TRETA")

    def calcBitRate(self,):

        fileR = open("bitrates.txt","a")

        if  fileR == 0 :
            print("### NAO FOI POSSIVEL ABRIR bitrates.txt !!! ###")
            quit()

        odd = os.stat(self.video_odd)
        even = os.stat(self.video_even)

        length_odd = float(odd.st_size)
        length_even = float(even.st_size)

        bitrate_odd = length_odd / (self.H*self.W) *1.0
        bitrate_even = length_even / (self.H*self.W) *1.0
        fileR.write(self.video + "  " + self.downsampleFactor.__str__() + \
                                                "  " + bitrate_odd.__str__() + "    " + bitrate_even.__str__() + "\n")

        fileR.close()


    def deleteAviFiles(self):
        os.system("rm -irf *.avi")
    def deleteVideoFiles(self):
        os.system("rm -irf *.avi *.yuv")
