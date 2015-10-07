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
    [evenFramesCalc(:,:,i)] = Motion_Est_n_Comp(evenFrameY(:,:,i), oddFramesLowFreY(:,:,i), oddFramesY(:,:,i), wSize, wSize, bSize, bSize);
end


create_yuv(evenFramesCalc,U,V,filename,numfrm,typeOpen)

%for i = 1:32
%    err = err + sum(sum((evenFramesCalc(:,:,i) - evenFrameY(:,:,i)).^2));
%end
err
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