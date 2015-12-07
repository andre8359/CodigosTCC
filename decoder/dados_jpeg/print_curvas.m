clc; clear all; close all;
addpath ../../code;

[videoIDs, w,h,nFrames] = textread('../../videos/catalogo.txt','%s %d %d %d');

for x=1:1:length(w)
    videoID = videoIDs{x};
    load(['PSNR_' videoID '_SP.dat']);
    psnr_SP = fliplr(PSNR_M_1);
    load(['PSNR_' videoID '_original_com_down.dat']);
    psnr_down =fliplr(PSNR_M_2);
    load(['PSNR_' videoID '_original_sem_down.dat']);
    psnr = fliplr(PSNR_M_3);


    temp = load(['bitrates_' videoID '.txt']);
    bitrate_SP(2,:) = fliplr(temp(1:30,3)');
    bitrate_SP(1,:) = fliplr(temp(31:60,3)');

    temp = load(['bitrates_' videoID '_original.txt']);
    bitrate_ori  = fliplr(temp(1:30,2)');


    figure; plot(bitrate_SP(1,:),psnr_SP(1,:),'b--', 'marker', 'o','markeredgecolor', 'black','markerfacecolor', 'blue', ...
            'markersize', 5, 'LineWidth',2,bitrate_SP(1,:),psnr_down(1,:),'r--','marker', '^','markeredgecolor', 'black',...
            'markerfacecolor', 'red', 'markersize',5,'LineWidth',2,bitrate_ori,psnr(1,:),'k--','marker', 's','markeredgecolor',...
             'black','markerfacecolor', 'black', 'markersize',5,'LineWidth',2);
    %figure; plot(bitrate_SP(1,:),psnr_SP(1,:),'bo-','LineWidth',2,bitrate_SP(1,:),psnr_down(1,:),'r^-','LineWidth',2,bitrate_ori,psnr(1,:),'ks-','LineWidth',2);
    axis([0 0.8 26 38 ])
    h=get (gcf, 'currentaxes');
    set(h,'fontweight','bold','linewidth',2)
    title(['JPEG ' videoID ' Fator M = 2  '],'fontweight','bold','fontsize',16);
    legend('Imgem SR','Imgem Interpolada', 'imagem Original');
    copied_legend = findobj(gcf(),'type','axes','Tag','legend');
    set(copied_legend, 'FontSize', 12);
    xlabel(['Taxa [bits/pixel]'],'fontweight','bold','fontsize',16);
    ylabel(['PSNR (dB)'],'fontweight','bold','fontsize',16);
    grid on;
    box on;
    print(['JPEG_' videoID '_Downsampling_factor_2'],'-dpng')

    figure; plot(bitrate_SP(2,:),psnr_SP(2,:),'b--', 'marker', 'o','markeredgecolor', 'black','markerfacecolor', 'blue', ...
            'markersize', 5, 'LineWidth',2,bitrate_SP(2,:),psnr_down(2,:),'r--','marker', '^','markeredgecolor', 'black',...
            'markerfacecolor', 'red', 'markersize',5,'LineWidth',2,bitrate_ori,psnr(1,:),'k--','marker', 's','markeredgecolor',...
             'black','markerfacecolor', 'black', 'markersize',5,'LineWidth',2);
    %figure; plot(bitrate_SP(2,:),psnr_SP(2,:),'bo-','LineWidth',2,bitrate_SP(2,:),psnr_down(2,:),'r^-','LineWidth',2,bitrate_ori,psnr(1,:),'ks-','LineWidth',2);
    %hold on;
     axis([0 0.6 24 34 ])
     h=get (gcf, 'currentaxes');
    set(h,'fontweight','bold','linewidth',2)
    title(['JPEG ' videoID ' Fator M = 4  '],'fontweight','bold','fontsize',16);
    legend('Imgem SR','Imgem Interpolada', 'imagem Original','location', 'southeast' );
    copied_legend = findobj(gcf(),'type','axes','Tag','legend');
    set(copied_legend, 'FontSize', 12);
    xlabel(['Taxa [bits/pixel]'],'fontweight','bold','fontsize',16);
    ylabel(['PSNR (dB)'],'fontweight','bold','fontsize',16);
    grid on;
    box on;

    print(['JPEG_' videoID '_Downsampling_factor_4'],'-dpng')
end
 close all;