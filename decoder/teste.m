clc; clear all; close all;
addpath ../code;

printf('### DELETING .YUV CREATED IN THE PROCESS ###\n');fflush(stdout);

test = 1
switch test
    case 1
        evenFramesID = 'foreman_even.yuv';
        evenOrigialFramesID = 'foreman_even_original.yuv';
        oddFramesID = 'foreman_odd.yuv';
        H = 288;
        W = 352;
    case 2
        evenFramesID = 'sequence_test_even.yuv';
        evenOrigialFramesID = 'sequence_test_even_original.yuv';
        oddFramesID = 'sequence_test_odd.yuv';
        H = 64;
        W = 64;
end

printf('### SETING PARAMETERS ###\n');
fflush(stdout);
bSize = 8;
wSize = 24;
downsampleFactor = 0.5;
nEvenFrames  = 2% number_frames(evenFramesID,H*downsampleFactor,W*downsampleFactor);
nOddFrames  = 2 %number_frames(oddFramesID,H,W);


[evenFramesCalc , dists] = decoder(evenFramesID, oddFramesID, H,W,downsampleFactor,nEvenFrames,nOddFrames,bSize,wSize);

evenFrameY = ffmpeg_resize(evenFramesID, H*downsampleFactor, W*downsampleFactor, H, W,nOddFrames);

evenFrameYSP = evenFrameY + evenFramesCalc;

evenFrameOriginalY = read_yuv(evenOrigialFramesID, W, H, [1:1:nOddFrames]);

PSNR1  = PSNR(evenFrameOriginalY, evenFrameYSP,H,W,nOddFrames);
fileD = fopen ('bitrates.txt','a');
fdisp(fileD, PSNR1);
fclose(fileD)
    % k=1;
% j=1;
% bSize = 8;
% a = zeros(64,64);
% for i=1:64
%     a = zeros(64,64);
%     a(j:j+bSize-1,k:k+bSize-1) = 255;

%     Y{i} = a;
%     U{i} =  DCT_Blk_Resize(a,8,4);
%     V{i} =  DCT_Blk_Resize(a,8,4);;
%         k = k + bSize;
%     if (mod(i,8)==0)
%         j=j+bSize;
%         k=1;
%     end
% end
% create_yuv(Y,U,V,'sequence_test.yuv',64,'w+')
% %Exports YUV sequence
% system('ffplay -f rawvideo -pix_fmt yuv420p -s 64x64 -i sequence_test.yuv');