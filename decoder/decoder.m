%% decoder: function description
function [evenFramesCalc , dists] = decoder(evenFramesID, oddFramesID, H,W,downsampleFactor,nEvenFrames,nOddFrames,bSize,wSize)

    printf('### LOAD IMAGES ###\n');fflush(stdout);
    evenFrameDownY = read_yuv(evenFramesID, W*downsampleFactor, H*downsampleFactor, [1:1:nEvenFrames]);
    [oddFramesY] = read_yuv(oddFramesID, W, H, [1:1:nOddFrames]);

    printf('###  CREATE A LOW FRE REF IMAGES ###\n');fflush(stdout);
    ret = system(['ffmpeg  -s ' num2str(W) 'x' num2str(H) ' -i ' oddFramesID ' -s ' num2str(W*downsampleFactor) 'x' num2str(H*downsampleFactor) ' odd_low_fre_ref.yuv' ]);
    [oddFramesLowFreDownY] = read_yuv('odd_low_fre_ref.yuv' , W*downsampleFactor, H*downsampleFactor, [1:1:nOddFrames]);

    printf('###  CREATE SCALING LOW FRE REF IMAGES ###\n');fflush(stdout);
    oddFramesLowFreY  = zeros(H,W,nOddFrames);
    evenFrameY = zeros(H,W,nOddFrames);
    for i = 1:nOddFrames
        oddFramesLowFreY(:,:,i) = DCT_Blk_Resize(oddFramesLowFreDownY(:,:,i), bSize , bSize/downsampleFactor);
        evenFrameY(:,:,i) = DCT_Blk_Resize(evenFrameDownY(:,:,i), bSize , bSize/downsampleFactor);
    end

    printf('###  CREATE COMPENSATION IMAGES ###\n');fflush(stdout);
    evenFramesCalc = zeros(H,W,nOddFrames);
    for i =1:nOddFrames
        [evenFramesCalc(:,:,i), dists] = Motion_Est_n_Comp(evenFrameY(:,:,i), oddFramesLowFreY(:,:,i), oddFramesY(:,:,i), wSize, wSize, bSize, bSize);
    end

    UV = zeros(H*downsampleFactor,W*downsampleFactor,nOddFrames);
    create_yuv(evenFramesCalc,UV,UV,'evenFramesCalc.yuv',nOddFrames,'w+');
    ret = system(['ffmpeg  -s ' num2str(W) 'x' num2str(H) ' -i ' oddFramesID ' -s ' num2str(W*downsampleFactor) 'x' num2str(H*downsampleFactor) ' evenFramesCalc.yuv' ]);
    [temp] = read_yuv('evenFramesCalc.yuv' , W*downsampleFactor, H*downsampleFactor, [1:1:nOddFrames]);
    evenFramesCalcDownFreqY = zeros(H,W,nOddFrames);

    for i = 1:nOddFrames
        evenFramesCalcDownFreqY (:,:,i) = DCT_Blk_Resize(temp(:,:,i), bSize , bSize/downsampleFactor);
    end

evenFramesCalc = evenFramesCalc -  evenFramesCalcDownFreqY;
