clc; clear all; close all;
addpath ../code;

printf('### DELETING .YUV CREATED IN THE PROCESS ###\n');fflush(stdout);
ret = system('rm *.yuv');

printf('### SETING PARAMETERS ###\n');
fflush(stdout);
bSize = 8;
wSize = 24;
evenFramesID = '../coder/even.yuv';
oddFramesID = '../coder/odd.yuv';
H = 64;
W = 64;
downsampleFactor = 0.5;
nEvenFrames  = number_frames(evenFramesID,H*downsampleFactor,W*downsampleFactor);
nOddFrames  = number_frames(oddFramesID,H,W);


[evenFramesCalc , dists] = decoder(evenFramesID, oddFramesID, H,W,downsampleFactor,nEvenFrames,nOddFrames,bSize,wSize);

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