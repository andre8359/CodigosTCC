clc; clear all; close all;
addpath ../../code;

[videoIDs, w,h,nFrames] = textread('../../videos/catalogo.txt','%s %d %d %d');
for x=1:1:length(w)
    videoID = videoIDs{x};
    load(['PSNR_' videoID '_SP.dat']);
    psnr_SP = fliplr(PSNR_M_1);
    load(['PSNR_' videoID '_original_com_down.dat']);
    psnr_down =fliplr(PSNR_M_2);

    temp = load(['bitrates_' videoID '.txt']);
    bitrate_SP(2,:) = fliplr(temp(1:30,3)');
    bitrate_SP(1,:) = fliplr(temp(31:60,3)');

    %pegando 4 pontos
    %tab1
    PSNR1 = [psnr_SP(1,1); psnr_SP(1,round(length(psnr_SP(1,:))/4)); psnr_SP(1,2*round(length(psnr_SP(1,:))/4)); psnr_SP(1,end)];
    bitrates = [bitrate_SP(1,1); bitrate_SP(1,round(length(psnr_SP(1,:))/4));bitrate_SP(1,2*round(length(psnr_SP(1,:))/4)); bitrate_SP(1,end)];
    PSNR2  = [psnr_down(1,1); psnr_down(1,round(length(psnr_down(1,:))/4)); psnr_down(1,2*round(length(psnr_down(1,:))/4)); psnr_down(1,end)];
    ganho(1,x) = bjontegaard(bitrates,PSNR2,bitrates,PSNR1,'dsnr');
    %tab2
    PSNR1 = [psnr_SP(2,1); psnr_SP(2,round(length(psnr_SP(2,:))/4)); psnr_SP(2,2*round(length(psnr_SP(2,:))/4)); psnr_SP(2,end)];
    bitrates = [bitrate_SP(2,1); bitrate_SP(2,round(length(psnr_SP(2,:))/4));bitrate_SP(2,2*round(length(psnr_SP(2,:))/4)); bitrate_SP(2,end)];
    PSNR2  = [psnr_down(2,1); psnr_down(2,round(length(psnr_down(2,:))/4)); psnr_down(2,2*round(length(psnr_down(2,:))/4)); psnr_down(2,end)];
    ganho(2,x) = bjontegaard(bitrates,PSNR2,bitrates,PSNR1,'dsnr');

end

