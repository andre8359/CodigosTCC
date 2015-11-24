% test Bjontegaard metric

R1 = [686.760000000000;309.580000000000;157.110000000000;85.9500000000000];
R2 = [893.340000000000;407.800000000000;204.930000000000;112.750000000000];
PSNR1 = [40.2800000000000;37.1800000000000;34.2400000000000;31.4200000000000];
PSNR2 = [40.3900000000000;37.2100000000000;34.1700000000000;31.2400000000000];


avg_diff = bjontegaard(R1,PSNR1,R2,PSNR2,'dsnr')
avg_diff = bjontegaard(R1,PSNR1,R2,PSNR2,'rate')