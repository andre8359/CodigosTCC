clc; clear all; close all;
addpath ../code;


printf('### SETING PARAMETERS ###\n');
fflush(stdout);
evenFramesID = '../coder/even.yuv';
oddFramesID = '../coder/odd.yuv';
H = 64;
W = 64;
downsampleFactor = 0.5;
nEvenFrames  = number_frames(evenFramesID,H*downsampleFactor,W*downsampleFactor);
nOddFrames  = number_frames(oddFramesID,H,W);

printf('### LOAD IMAGES ###\n');fflush(stdout);
evenFramesY = read_yuv(evenFramesID, W*downsampleFactor, H*downsampleFactor, [1:1:nEvenFrames]);
[oddFramesY] = read_yuv(oddFramesID, W, H, [1:1:nOddFrames]);

printf('###  CREATE A LOW FRE REF IMAGES ###\n');fflush(stdout);

ret = system(['ffmpeg  -s ' num2str(W) 'x' num2str(H) ' -i ' oddFramesID ' -s ' num2str(W*downsampleFactor) 'x' num2str(H*downsampleFactor) ' odd_low_fre_ref.yuv' ]);

[oddFramesLowFreY] = read_yuv(' odd_low_fre_ref.yuv' , W*downsampleFactor, H*downsampleFactor, [1:1:nOddFrames]);





printf('### DELETING .YUV CREATED IN THE PROCESS ###\n');fflush(stdout);
ret = system('rm *.yuv');




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