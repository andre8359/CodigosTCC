clc; clear all; close all;
addpath ../code;


videoID = 'foreman';
evenFramesID = ['videos/' videoID '_even'];
evenOrigialFramesID = ['videos/' videoID '_even_original'];
oddFramesID = ['videos/' videoID '_odd'];
H = 288;s
W = 352;
%system(['python  ../coder/main.py "' videoID '" ' num2str(H) ' ' num2str(W) ' "../videos"   > /dev/null']);

downsampleFactor =  [4.0/8  2.0/8];
qscale = [2:1:31];


printf('### SETING PARAMETERS ###\n');
fflush(stdout);
bSize = 8;
wSize = 24;
nFrames  = 150;
%evenFrameOriginalY = read_yuv([evenOrigialFramesID '.yuv'], W, H, [1:1:nFrames]);
PSNR1 = zeros(nFrames,1);

for i = 1 : length(downsampleFactor)
    for k = 1:length(qscale)
        for frame = 1 : 1 : nFrames
            evenFrameOriginalY = read_yuv([evenOrigialFramesID '.yuv'], W, H, frame);

            [evenFramesCalc , dists] = decoder([evenFramesID '_' num2str(downsampleFactor(i)) '_' num2str(qscale(k))] , ...
                                            [oddFramesID '_' num2str(downsampleFactor(i))], H,W,downsampleFactor(i),frame,bSize,wSize);

            evenFrameY = ffmpeg_resize([evenFramesID '_' num2str(downsampleFactor(i)) '_' num2str(qscale(k)) '.yuv'], ...
                                                                                            H*downsampleFactor(i), W*downsampleFactor(i), H, W,nFrames);

            evenFrameYSP = evenFrameY + evenFramesCalc;

            PSNR1(i,k)  = PSNR(evenFrameOriginalY, evenFrameYSP,H,W);
            %fileD = fopen (['PSNR_' videoID '_SP.txt'],'a');
            %fdisp(fileD, [downsampleFactor(i) qscale(k) PSNR1]);
           %fclose(fileD);
        end
    end
end

for i = 1 : length(downsampleFactor)
    for k = 1:length(qscale)
        evenFrameY = read_yuv([evenOrigialFramesID '_coding_' num2str(downsampleFactor(i)) '_' ...
                num2str(qscale(k)) '.yuv'], W, H, [1:1:nFrames]);
        PSNR1  = PSNR(evenFrameOriginalY, evenFrameY,H,W,nFrames);
        fileD = fopen (['PSNR_' videoID '_down_sem_SP.txt'],'a');
        fdisp(fileD, [downsampleFactor(i) qscale(k) PSNR1]);
    fclose(fileD);
    end
end

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