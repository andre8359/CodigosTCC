function plot_cur(videoID)

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


    figure; plot(bitrate_SP(1,:),psnr_SP(1,:),'b',bitrate_SP(1,:),psnr_down(1,:),'r',bitrate_ori,psnr(1,:),'k');
    hold on;
    scatter(bitrate_SP(1,:),psnr_SP(1,:),'b','filled')
    scatter(bitrate_SP(1,:),psnr_down(1,:),'r','filled')
    scatter(bitrate_ori,psnr(1,:),'k','filled');
    title(['JPEG ' videoID ' Downsampling factor 4/8']);
    legend('Imgem SR','Imgem com Downsampling', 'imagem Original');
    xlabel(['Taxa [bits/pixel]']);
    ylabel(['PSNR (dB)']);
    grid on;
    figure; plot(bitrate_SP(2,:),psnr_SP(2,:),'b',bitrate_SP(2,:),psnr_down(2,:),'r',bitrate_ori,psnr(1,:),'k');
    hold on;
    scatter(bitrate_SP(2,:),psnr_SP(2,:),'b','filled')
    scatter(bitrate_SP(2,:),psnr_down(2,:),'r','filled')
    scatter(bitrate_ori,psnr(1,:),'k','filled');
    title(['JPEG ' videoID ' Downsampling factor 2/8']);
    legend('Imgem SR','Imgem com Downsampling', 'imagem Original');
    xlabel(['Taxa [bits/pixel]']);
    ylabel(['PSNR (dB)']);
    grid on;