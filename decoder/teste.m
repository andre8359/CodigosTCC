clc; clear all; close all;
addpath ../code;

[videoIDs, w,h,nFrames] = textread('../videos/catalogo.txt','%s %d %d %d');

for x=1:1:length(w)

    videoID = videoIDs{x};
    evenFramesID = ['videos/' videoID '_even'];
    evenOrigialFramesID = ['videos/' videoID '_even_original'];
    oddFramesID = ['videos/' videoID '_odd'];
    H = h(x);
    W = w(x);
    nFrames  =nFrames/2.0 ;


    system(['python  ../coder/main.py "' videoID '" ' num2str(H) ' ' num2str(W) ' ' num2str(150) ' "../videos"   > /dev/null']);

    downsampleFactor =  [4.0/8  2.0/8];
    qscale = [2:1:31];


    printf('### SETING PARAMETERS ###\n');
    fflush(stdout);
    bSize = 8;
    wSize = 24;
    nFrames  = nFrames/2.0 ;
    %evenFrameOriginalY = read_yuv([evenOrigialFramesID '.yuv'], W, H, [1:1:nFrames]);


    for i = 1 : 1 : length(downsampleFactor)
        for k = 1: 1 :length(qscale)

            printf(['### downsampleFactor ' num2str(downsampleFactor(i)) ' qscale ' num2str(qscale(k)) ' ###\n']);fflush(stdout);

           for frame = 0 : 1 : nFrames-1

                evenFrameOriginalY = read_yuv([evenOrigialFramesID '.yuv'], W, H, frame)';

                evenID = [evenFramesID '_' num2str(downsampleFactor(i)) '_' num2str(qscale(k))];
                oddID =  [oddFramesID '_' num2str(downsampleFactor(i))];
                [evenFramesCalc , dists] = decoder(evenID,oddID, H,W,downsampleFactor(i),frame,bSize,wSize);

                evenFrameY = ffmpeg_resize([evenFramesID '_' num2str(downsampleFactor(i)) '_' num2str(qscale(k)) '.yuv'], ...
                                                                                         H*downsampleFactor(i), W*downsampleFactor(i), H, W,frame);

                evenFrameYSP = evenFrameY + evenFramesCalc;

                PSNR1(i,k,frame+1)  = PSNR(evenFrameOriginalY, evenFrameYSP,H,W);

                %evenFrameY = read_yuv([evenID  '.yuv'], W, H,frame)';


                PSNR2(i,k,frame+1)   = PSNR(evenFrameOriginalY, evenFrameY,H,W);

                evenFrameYOrigial = read_yuv([evenOrigialFramesID '_' num2str(qscale(k)) '.yuv'], W, H,frame)';
                PSNR3(i,k,frame+1)   = PSNR(evenFrameOriginalY, evenFrameYOrigial,H,W);

            end
        end
    end

    for i = 1 : length(downsampleFactor)
        for k = 1:length(qscale)
            PSNR_M_1(i,k ) = mean(PSNR1(i,k,1:end));
            PSNR_M_2(i,k ) = mean(PSNR2(i,k,1:end));
            PSNR_M_3(i,k ) = mean(PSNR3(i,k,1:end));
        end
    end
    save(['PSNR_' videoID '_SP.dat' ], 'PSNR_M_1');
    save(['PSNR_' videoID '_original_com_down.dat' ], 'PSNR_M_2');
    save(['PSNR_' videoID '_original_sem_down.dat' ], 'PSNR_M_3');
    system('rm -irf videos/');
    plot_cur(videoID);
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