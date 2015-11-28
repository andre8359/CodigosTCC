import sys
import os

class coder():

    def __init__(self,video,H,W,downsampleFactor,dir_,nFrames,number):
        self.video  = video
        self.H = H
        self.W = W
        self.downsampleFactor = downsampleFactor
        self.newH = int(float(H*downsampleFactor))
        self.newW = int(float(W*downsampleFactor))
        self.qscale = 1
        self.dir_ = dir_
        self.video_odd = video + "_odd_" + self.downsampleFactor.__str__()
        self.video_even = video +"_" + number.__str__() +"_even"
        self.nFrames = int(nFrames)
        self.number = number

    def atualizaDim(self):
        self.newH = int(float(self.H*self.downsampleFactor))
        self.newW = int(float(self.W*self.downsampleFactor))

    def  coderJPEG(self):
        self.atualizaDim()
        ffmpeg_ = "ffmpeg "
        rate_ = "-r 2 -s "
        filter_ = " -filter:v select=\"mod(n-1\,2)\" "
        jpeg_ = "-r 1 -vcodec mjpeg "

        #CODING EVEN FRAMES WITH DOWNSAMPLING
        qscale_ =  " -q " + self.number.__str__() + " "
        self.video_even = self.video + "_even_" + self.downsampleFactor.__str__() + "_" + self.number.__str__()
        filter_ = " -filter:v select=\"not(mod(n-1\,2))\" "

        returnEven = os.system(ffmpeg_ + rate_ + self.W.__str__() + "x" + self.H.__str__() + " -i " + self.dir_+ \
                                                                self.video + ".yuv"+ filter_ + jpeg_ + qscale_ + " -s "+ self.newW.__str__()\
                                                                + "x" + self.newH.__str__() +" " + self.video_even + ".avi")
        #DECODING EVEN FRAMES
        os.system(ffmpeg_ + " -i " +self.video_even + ".avi"+ " -c:v rawvideo -pix_fmt yuv420p "+self.video_even + ".yuv")



        if  returnEven > 0:
            print("### ERRO!!!! ###")
            quit()

    def codingJPEGOriginalEvenFrames(self):

        ffmpeg_ = "ffmpeg "
        rate_ = "-r 2 -s "
        filter_ = " -filter:v select=\"not(mod(n-1\,2))\" "
        jpeg_ = "-r 1 -vcodec mjpeg "
        #CODING ORIGINAL EVEN FRAMES
        outputFIle_=    self.video + "_even_original_" + self.number.__str__()
        qscale_ =  " -q " + self.number.__str__() + " "
        os.system(ffmpeg_ + rate_ + self.W.__str__() + "x" + self.H.__str__() + " -i " + self.dir_+ \
                                                                self.video + ".yuv"+ filter_ + jpeg_ + qscale_ +  \
                                                                " " + outputFIle_ + ".avi")
        os.system(ffmpeg_ + " -i " + outputFIle_ + ".avi" " -c:v rawvideo -pix_fmt yuv420p "+ outputFIle_+ ".yuv")

    def codingJPEGOddFrames(self):

        ffmpeg_ = "ffmpeg "
        rate_ = "-r 2 -s "
        filter_ = " -filter:v select=\"mod(n-1\,2)\" "
        jpeg_ = "-r 1 -vcodec mjpeg "

        self.video_odd = self.video + "_odd_" + self.downsampleFactor.__str__()

        # CODING ODD FRAMES WITH NO DOWNSAMPLING
        qscale_ = " -q:v 1 "
        #print(ffmpeg_ + rate_ + self.W.__str__() + "x" + self.H.__str__() + " -i " + self.dir_+self.video + ".yuv"+ filter_ + jpeg_ + qscale_ + outputFIle_ )

        returnOdd = os.system(ffmpeg_ + rate_ + self.W.__str__() + "x" + self.H.__str__() + " -i " + self.dir_+ \
                                                                self.video + ".yuv"+ filter_ + jpeg_ + qscale_ + self.video_odd + ".avi")
        #DECODING ODD FRAMES
        os.system(ffmpeg_ + " -i " + self.video_odd + ".avi"+ " -c:v rawvideo -pix_fmt yuv420p "+ self.video_odd + ".yuv")
        if  returnOdd > 0:
            print("### ERRO!!!! ###")
            quit()

    def coderH264(self):
         self.atualizaDim()
         ffmpeg_ = "ffmpeg "
         rate_ = "-r 2 -s "
         filter_ = " -filter:v select=\"mod(n-1\,2)\" "
         h264_ = "-r 1 -vcodec libx264 -intra   "

        #CODING EVEN FRAMES WITH DOWNSAMPLING
         qscale_ =  " -crf " + self.number.__str__() + " "
         self.video_even = self.video + "_even_" + self.downsampleFactor.__str__() + "_" + self.number.__str__()
         filter_ = " -filter:v select=\"not(mod(n-1\,2))\" "

         returnEven = os.system(ffmpeg_ + rate_ + self.W.__str__() + "x" + self.H.__str__() + " -i " + self.dir_+ \
                                                                self.video + ".yuv"+ filter_ + h264_ + qscale_ + " -s "+ self.newW.__str__()\
                                                                + "x" + self.newH.__str__() +" " + self.video_even + ".h264")
         #DECODING EVEN FRAMES
         os.system(ffmpeg_ + " -i " +self.video_even + ".h264"+ " -c:v rawvideo -pix_fmt yuv420p "+self.video_even + ".yuv")

         if  returnEven > 0:
            print("### ERRO!!!! ###")
            quit()

    def codingH264OriginalEvenFrames(self):
        ffmpeg_ = "ffmpeg "
        rate_ = "-r 2 -s "
        filter_ = " -filter:v select=\"not(mod(n-1\,2))\" "
        h264_ = "-r 1 -vcodec libx264 -intra "
        #CODING ORIGINAL EVEN FRAMES
        outputFIle_=    self.video + "_even_original_" + self.number.__str__()
        qscale_ =  " -crf " + self.number.__str__() + " "
        os.system(ffmpeg_ + rate_ + self.W.__str__() + "x" + self.H.__str__() + " -i " + self.dir_+ \
                                                                self.video + ".yuv"+ filter_ + h264_ + qscale_ +  \
                                                                " " + outputFIle_ + ".h264")
        os.system(ffmpeg_ + " -i " + outputFIle_ + ".h264" " -c:v rawvideo -pix_fmt yuv420p "+ outputFIle_+ ".yuv")

    def codingH264OddFrames(self):
        ffmpeg_ = "ffmpeg "
        rate_ = "-r 2 -s "
        filter_ = " -filter:v select=\"mod(n-1\,2)\" "
        h264_ = "-r 1 -vcodec libx264 -intra "

        self.video_odd = self.video + "_odd_" + self.downsampleFactor.__str__()

        # CODING ODD FRAMES WITH NO DOWNSAMPLING
        qscale_ = " -crf  0 "
        #print(ffmpeg_ + rate_ + self.W.__str__() + "x" + self.H.__str__() + " -i " + self.dir_+self.video + ".yuv"+ filter_ + jpeg_ + qscale_ + outputFIle_ )

        returnOdd = os.system(ffmpeg_ + rate_ + self.W.__str__() + "x" + self.H.__str__() + " -i " + self.dir_+ \
                                                                self.video + ".yuv"+ filter_ + h264_ + qscale_ + self.video_odd + ".h264")
        #DECODING ODD FRAMES
        os.system(ffmpeg_ + " -i " + self.video_odd + ".h264"+ " -c:v rawvideo -pix_fmt yuv420p "+ self.video_odd + ".yuv")
        if  returnOdd > 0:
            print("### ERRO!!!! ###")
            quit()

    def calcBitRate(self, standard):
        if standard == "jpeg":
            ext = ".avi"
        elif standard == "h264":
            ext = ".h264"

        self.video_odd = self.video + "_odd_" + self.downsampleFactor.__str__()
        self.video_even = self.video + "_even_" + self.downsampleFactor.__str__() + "_" + self.number.__str__()
        fileR = open("bitrates_" + self.video + ".txt","a+")

        if  fileR == 0 :
            print("### NAO FOI POSSIVEL ABRIR bitrates.txt !!! ###")
            quit()

        odd = os.stat(self.video_odd + ext)
        even = os.stat(self.video_even + ext)

        length_odd = float(odd.st_size)
        length_even = float(even.st_size)
        print (8.0*self.H*self.W)
        bitrate_odd = length_odd*8.0 /(self.H*self.W*self.nFrames*1.5)
        bitrate_even = length_even*8.0/(self.H*self.W*self.nFrames*1.5)
        fileR.write(self.downsampleFactor.__str__() + \
                "  " + bitrate_odd.__str__() + " " + bitrate_even.__str__() + " " +self.number.__str__()+"\n")
        fileR.close()


    def calcBitRateOriginal(self,standard):
        if standard == "jpeg":
            ext = ".avi"
        elif standard == "h264":
            ext = ".h264"
        video =   self.video + "_even_original_" + self.number.__str__()
        fileR = open("bitrates_" + self.video + "_original.txt","a+")

        if  fileR == 0 :
            print("### NAO FOI POSSIVEL ABRIR bitrates.txt !!! ###")
            quit()

        original = os.stat( video + ext)

        length_original = float(original.st_size)

        bitrate = length_original*8.0/(self.H*self.W*self.nFrames*1.5   )

        fileR.write(self.number.__str__()+ " " + bitrate.__str__() +"\n")
        fileR.close()

    def deleteAviFiles(self):
        os.system("rm -irf *.avi ")

    def deleteH264Files(self):
        os.system("rm -irf *.h264 ")

    def getOriginalEvenFrames(self):

        ffmpeg_ = "ffmpeg "
        rate_ = "-r 2 -s "
        filter_ = " -filter:v select=\"not(mod(n-1\,2))\" "

        #GETING ORIGINAL EVEN FRAMES
        outputFIle_=    self.video + "_even_original"
        os.system(ffmpeg_ + rate_ + self.W.__str__() +  "x" + self.H.__str__() + " -i " + self.dir_+ self.video + ".yuv" \
            + filter_ + " -r 1  -pix_fmt yuv420p -s "+ self.W.__str__() +  "x" + self.H.__str__() +" " + outputFIle_ + ".yuv" )

