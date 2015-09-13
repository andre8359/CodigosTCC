function psnr_value = PSNR(a,b)

a = clip(a(:),[0 255]);
b = clip(b(:),[0 255]);
psnr_value = 10*log10(255*255/mean(mean((a-b).^2)));