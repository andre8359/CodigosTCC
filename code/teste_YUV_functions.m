addpath code;

img = read_imgs(1,0);
[Y U V] = rgb2ycbcr(img,'444'); 
Y1{1} = Y;
U1{1} = U;
V1{1} = V;
create_yuv(Y1,U1,V1,'tst.yuv',1,'w');
[Y,Cb,Cr] = read_yuv('tst.yuv',512,512,'444');
[RGB] = ycbcr2rgb(Y,U,V,'444');
psnr_value = (uint8(img)-uint8(RGB)).^2;
errorR = 10*log10(255*255/mean(mean(psnr_value(:,:,1))))
errorG = 10*log10(255*255/mean(mean(psnr_value(:,:,2))))
errorB = 10*log10(255*255/mean(mean(psnr_value(:,:,3))))
figure;imshow(uint8(img));
figure;imshow(uint8(RGB));
%ret = compress_h264();
