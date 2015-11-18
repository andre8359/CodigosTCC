function [evenFramesCalcHighFre , dists] = decoder(evenFramesID, oddFramesID, H,W,downsampleFactor, ...
                                                                                frame, bSize,wSize)

    %printf('### LOAD IMAGES ###\n');fflush(stdout);
    evenFramesID = [evenFramesID '.yuv'];
    oddFramesID = [oddFramesID '.yuv'];
    evenFramesCalcHighFre = zeros(H,W);

    evenFrameDownY = read_yuv(evenFramesID  , W*downsampleFactor, H*downsampleFactor, frame)';
    oddFramesY = read_yuv(oddFramesID, W, H, frame)';

    %printf(['### FRAME '   num2str(frame) ' ###\n']);fflush(stdout);
    %printf('###  CREATE A LOW FRE REF IMAGES ###\n');fflush(stdout);
    [oddFramesLowFreDownY] = ffmpeg_resize(oddFramesID,H,W,H*downsampleFactor,W*downsampleFactor,frame);
    %printf('###  CREATE SCALING LOW FRE REF IMAGES ###\n');fflush(stdout);

    oddFramesLowFreY  = zeros(H,W);
    evenFrameY = zeros(H,W);

    oddFramesLowFreY =  ffmpeg_resize(oddFramesLowFreDownY,H*downsampleFactor,W*downsampleFactor, H, W,frame);

    evenFrameY = ffmpeg_resize(evenFrameDownY,H*downsampleFactor,W*downsampleFactor, H, W,frame);

    %printf('###  CREATE COMPENSATION IMAGES ###\n');fflush(stdout);
    evenFramesCalc = zeros(H,W);
    [evenFramesCalc, dists] = Motion_Est_n_Comp(evenFrameY, oddFramesLowFreY, oddFramesY, wSize, wSize, bSize, bSize);


    temp = ffmpeg_resize(evenFramesCalc,H,W,H*downsampleFactor,W*downsampleFactor,frame);

    evenFramesCalcDownFreqY = zeros(H,W);
    evenFramesCalcDownFreqY = ffmpeg_resize(temp,H*downsampleFactor,W*downsampleFactor,H,W,frame);


    evenFramesCalcHighFre = evenFramesCalc -  evenFramesCalcDownFreqY;

