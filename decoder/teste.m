clc; clear all; close all;
addpath ../code;


% Seting parameters
evenFramesID = '../coder/even.yuv';
oddFramesID = '../coder/odd.yuv';
H = 288;
W = 352;
downsampleFactor = 0.5;
nEvenFrames  = number_frames(evenFramesID,H*downsampleFactor,W*downsampleFactor);
nOddFrames  = number_frames(oddFramesID,H,W);

disp('### LOAD IMAGES ###');
evenFrames = read_yuv(evenFramesID, W*downsampleFactor, H*downsampleFactor, [1:1:nEvenFrames]);
oddFrames = read_yuv(oddFramesID, W, H, [1:1:nOddFrames]);


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


create_yuv(Y,U,V,'sequence_test.yuv',64,'w+')

%Exports YUV sequence
system('ffplay -f rawvideo -pix_fmt yuv420p -s 64x64 -i sequence_test.yuv');