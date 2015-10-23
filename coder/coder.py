import sys
import os

class coder():

    def __init__(self,video,H,W,downsampleFactor,dir_,even_original):
        self.video  = video
        self.H = H
        self.W = W
        self.downsampleFactor = downsampleFactor
        self.newH = int(float(H*downsampleFactor))
        self.newW = int(float(W*downsampleFactor))
        self.qscale = 1
        self.dir_ = dir_
        self.video_odd = video + "_odd"
        self.video_even = video + "_even"
        self.even_original = even_original



    def  coderJPEG(self):

        ffmpeg_ = "ffmpeg "
        rate_ = "-r 2 -s "
        filter_ = " -filter:v select=\"mod(n-1\,2)\" "
        jpeg_ = "-r 1 -vcodec mjpeg "
        qscale_ = "-qscale " + self.qscale.__str__() + " "
        outputFIle_ = self.video + "_odd"
        #print(ffmpeg_ + rate_ + self.W.__str__() + "x" + self.H.__str__() + " -i " + self.dir_+self.video + ".yuv"+ filter_ + jpeg_ + qscale_ + outputFIle_ )
        returnOdd = os.system(ffmpeg_ + rate_ + self.W.__str__() + "x" + self.H.__str__() + " -i " + self.dir_+ \
                                                                self.video + ".yuv"+ filter_ + jpeg_ + qscale_ + self.video_odd + ".avi")

        os.system(ffmpeg_ + " -i " + outputFIle_ + ".avi"+ " -c:v rawvideo -pix_fmt yuv420p "+ outputFIle_ + ".yuv")

        outputFIle_ = self.video + "_even"
        filter_ = " -filter:v select=\"not(mod(n-1\,2))\" "
        returnEven = os.system(ffmpeg_ + rate_ + self.W.__str__() + "x" + self.H.__str__() + " -i " + self.dir_+ \
                                                                self.video + ".yuv"+ filter_ + jpeg_ + qscale_ + " -s "+ self.newW.__str__()\
                                                                + "x" + self.newH.__str__() +" " + self.video_even + ".avi")
        os.system(ffmpeg_ + " -i " +outputFIle_ + ".avi"+ " -c:v rawvideo -pix_fmt yuv420p "+outputFIle_ + ".yuv")

        if self.even_original :
            outputFIle_=    self.video + "_even_original"
            os.system(ffmpeg_ + rate_ + self.W.__str__() +  "x" + self.H.__str__() + " -i " + self.dir_+ self.video + ".yuv" \
            + filter_ + " -c:v rawvideo -r 1 -format rawvideo -pix_fmt yuv420p -s "+ self.W.__str__() +  "x" + self.H.__str__() +" " + outputFIle_ + ".yuv" )

        if returnOdd + returnEven > 0:
            print("### ERRO!!!! ###")
            quit()

    def coderH264(self):
        print("TRETA")

    def calcBitRate(self):

        fileR = open("bitrates.txt","w")

        if  fileR == 0 :
            print("### NAO FOI POSSIVEL ABRIR bitrates.txt !!! ###")
            quit()

        odd = os.stat(self.video_odd + ".avi")
        even = os.stat(self.video_even + ".avi")

        length_odd = float(odd.st_size)
        length_even = float(even.st_size)

        bitrate_odd = length_odd / (self.H*self.W) *1.0
        bitrate_even = length_even / (self.H*self.W) *1.0
        fileR.write(self.video + "  " + self.downsampleFactor.__str__() + \
                                                "  " + bitrate_odd.__str__() + "    " + bitrate_even.__str__() + "\n")

        fileR.close()

    def deleteVideoFiles(self):
        os.system("rm -irf *.avi *.yuv")
