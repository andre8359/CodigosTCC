addpath code;

plot_curves = 1;
a = read_imgs(1,0);

[H W T] = size(a);
[a U V] = rgb2ycbcr(a,'420'); 
Y1{1} = a;
U1{1} = zeros(size(U));
V1{1} = zeros(size(U));
create_yuv(Y1,U1,V1,'tst.yuv',1,'w');
Quals = round(linspace(1,51,9));
rates = zeros(length(Quals),8);
dists = zeros(length(Quals),8);

for q = 1:length(Quals)
    argument_list  = ['lencod ' '-d "JM\bin\encoder.cfg"' ' -p InputFile = "tst.yuv"' ...
                        ' -p SourceWidth =' int2str(W) ' -p SourceHeight =' int2str(H) ' -p SourceResize = 0' ...
                        ' -p OutputWidth =' int2str(W) ' -p OutputHeight =' int2str(H) ' -p ReconFile = "recon_tst.yuv"' ...
                        ' -p OutputFile = "tst.264"' ' -p QPISlice=' int2str(Quals(q)) ];
	compress_h264(argument_list,0);
	[a_recon U V] = read_yuv('recon_tst.yuv',H,W,'420');
	dists(q,1) = MSD(a,a_recon);
	info = dir('tst.264');
	rates(q,1) = info.bytes*8/W/H;
end

for blk_out = 1:7
	ad = DCT_Blk_Resize(a, 8, blk_out);
	
	Y1{1} = ad;
	U1{1} = zeros(size(ad));
	V1{1} = zeros(size(ad));
	create_yuv(Y1,U1,V1,'tst.yuv',1,'w');
	%imwrite(uint8(ad), 'tst.png');
	rate_ad(9-blk_out) = 8*(W/8*blk_out*H/8*blk_out)/W/H;
	dist_ad(9-blk_out) = MSD(a,DCT_Blk_Resize(ad, blk_out, 8));

	for q = 1:length(Quals)
		%system(['convert tst.png -quality ' num2str(Quals(q)) ' tst.jpg']);
		%imwrite(uint8(ad),'tst.jpg','Quality',Quals(q));
		argument_list  = ['lencod ' '-d "JM\bin\encoder.cfg"' ' -p InputFile = "tst.yuv"' ...
							' -p SourceWidth =' int2str(W/8*blk_out) ' -p SourceHeight =' int2str(H/8*blk_out) ' -p SourceResize = 0' ...
							' -p OutputWidth =' int2str(W/8*blk_out) ' -p OutputHeight =' int2str(H/8*blk_out) ' -p ReconFile = "recon_tst.yuv"' ...
							' -p OutputFile = "tst.264"' ' -p QPISlice=' int2str(Quals(q))];
		compress_h264(argument_list,0);
		[a_recon U V] = read_yuv('recon_tst.yuv',H/8*blk_out,W/8*blk_out,'420');
		a_reconU = DCT_Blk_Resize(a_recon, blk_out, 8);
		dists(q,9-blk_out) = MSD(a,a_reconU);
		info = dir('tst.264');
		rates(q,9-blk_out) = info.bytes*8/W/H;
	end
end

n_degree = 1;
thetas = zeros(n_degree+1,8);
errs = zeros(1,8);
for j = 1:8
	x = log(dists(:,j));
	y = log(rates(:,j));
	[thetas(:,j),y_hat,errs(j)] = least_sq_fit(x,y,n_degree);
end

crossing_points = zeros(2,8);
for j=2:8
	x = exp((thetas(2,j)-thetas(2,1))/(thetas(1,1)-thetas(1,j)));
	crossing_points(:,j) = [x; exp(thetas(1,1)*log(x)+thetas(2,1))];
end
system('del tst.yuv tst.264');

% Qthetas
errs
% crossing_points

expected_rates = zeros(2,8);
for j = 2:8
	expected_rates(:,j) = [exp(polyval(thetas(:,j),log(dist_ad(j)))); rate_ad(j)];
end
expected_rates

if plot_curves
	legenda ={'Original','7/8','6/8','5/8','4/8','3/8','2/8','1/8'};
	for j = 2:8
		figure;
		subplot(211);
		plot(rates(:,1),dists(:,1), rates(:,j), dists(:,j));
		hold off; grid on;
		legend({legenda{1},legenda{j}},'Location','Northeast');
		subplot(212);
		loglog(rates(:,1),dists(:,1), rates(:,j), dists(:,j));
		hold off; grid on;
		legend({legenda{1},legenda{j}},'Location','Northeast');
	end
end