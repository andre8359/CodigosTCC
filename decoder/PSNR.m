function  [dB] = PSNR(image1,image2, H,W,nFrames)

    if nargin < 5
        nFrames = 1;
    end

    MSE  = size(nFrames,1);

    for i = 1:1:nFrames
        MSE(i)  = (sum(sum((image1(:,:,i) - image2(:,:,i)).^2))) / (H*W);

    end

    PSNR = 10*log10((255^2)./MSE);
    dB = mean(PSNR);