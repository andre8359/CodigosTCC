function msd_value = MSD(a,b)

%a = clip(a(:),[0 255]);
%b = clip(b(:),[0 255]);
a(a<0) = 0;
a(a>255) = 255;
b(b<0) = 0;
b(b>255) = 255;

msd_value = mean(mean((a-b).^2));