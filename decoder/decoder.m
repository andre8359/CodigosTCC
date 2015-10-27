%% decoder: function description
function [evenFramesCalc , dists] = decoder(evenFramesID, oddFramesID, H,W,downsampleFactor, ...
                                                                                nEvenFrames,nOddFrames,bSize,wSize)

    printf('### LOAD IMAGES ###\n');fflush(stdout);
    evenFrameDownY = read_yuv(evenFramesID, W*downsampleFactor, H*downsampleFactor, [1:1:nEvenFrames]);
    oddFramesY = read_yuv(oddFramesID, W, H, [1:1:nOddFrames]);

    printf('###  CREATE A LOW FRE REF IMAGES ###\n');fflush(stdout);
    [oddFramesLowFreDownY] = ffmpeg_resize(oddFramesID,H,W,H*downsampleFactor,W*downsampleFactor,nOddFrames);

    printf('###  CREATE SCALING LOW FRE REF IMAGES ###\n');fflush(stdout);
    oddFramesLowFreY  = zeros(H,W,nOddFrames);
    evenFrameY = zeros(H,W,nOddFrames);

    oddFramesLowFreY =  ffmpeg_resize(oddFramesLowFreDownY,H*downsampleFactor,W*downsampleFactor, H, W,nOddFrames);
    evenFrameY = ffmpeg_resize(evenFrameDownY,H*downsampleFactor,W*downsampleFactor, H, W,nOddFrames);


    printf('###  CREATE COMPENSATION IMAGES ###\n');fflush(stdout);
    evenFramesCalc = zeros(H,W,nOddFrames);
    for i =1:nOddFrames
        [evenFramesCalc(:,:,i), dists] = Motion_Est_n_Comp(evenFrameY(:,:,i), oddFramesLowFreY(:,:,i), oddFramesY(:,:,i), wSize, wSize, bSize, bSize);
    end


    temp = ffmpeg_resize(evenFramesCalc,H,W,H*downsampleFactor,W*downsampleFactor,nOddFrames);
    evenFramesCalcDownFreqY = zeros(H,W,nOddFrames);
    evenFramesCalcDownFreqY = ffmpeg_resize(temp,H*downsampleFactor,W*downsampleFactor,H,W,nOddFrames);
    evenFramesCalc = evenFramesCalc -  evenFramesCalcDownFreqY;
