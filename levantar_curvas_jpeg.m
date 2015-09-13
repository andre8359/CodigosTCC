addpath code;

plot_curves = 0;
a = read_imgs(1,1);
[H W] = size(a);
Quals = [9:10:99];

rates = zeros(length(Quals),8);
dists = zeros(length(Quals),8);

imwrite(uint8(a), 'tst.png');
for q = 1:length(Quals)
	% Minha funcao imwrite estava com problemas para 
	% gravar arquivos JPEG, portanto eu usei o comando 'convert'.
	% Troque para imwrite() no seu computador.
	imwrite(uint8(a),'tst.jpg','Quality',Quals(q));
	%system(['convert tst.png -quality ' num2str(Quals(q)) ' tst.jpg']);
	b = double(imread('tst.jpg'));
	dists(q,1) = MSD(a,b);
	info = dir('tst.jpg');
	rates(q,1) = info.bytes*8/W/H;
	% rates(q,1) = dir('tst.jpg').bytes*8/W/H;
end

% for blk_out = 1:7
	% ad = DCT_Blk_Resize(a, 8, blk_out);
	% imwrite(uint8(ad), 'tst.png');
	% rate_ad(9-blk_out) = 8*(W/8*blk_out*H/8*blk_out)/W/H;
	% dist_ad(9-blk_out) = MSD(a,DCT_Blk_Resize(ad, blk_out, 8));
	% for q = 1:length(Quals)
		% %system(['convert tst.png -quality ' num2str(Quals(q)) ' tst.jpg']);
		% imwrite(uint8(ad),'tst.jpg','Quality',Quals(q));
		% b = double(imread('tst.jpg'));
		% bu = DCT_Blk_Resize(b, blk_out, 8);
		% dists(q,9-blk_out) = MSD(a,bu);
		% info = dir('tst.jpg');
		% rates(q,9-blk_out) = info.bytes*8/W/H;
	% end
% end

% n_degree = 5;
% thetas = zeros(n_degree+1,8);
% errs = zeros(1,8);
% for j = 1:8
	% x = (dists(:,j));
	% y = (rates(:,j));
	% [thetas(:,j),y_hat,errs(j)] = least_sq_fit(x,y,n_degree);
% end

% thetas
% errs

% %crossing_points = zeros(2,8);
% %for j=2:8
% %	x = exp((thetas(2,j)-thetas(2,1))/(thetas(1,1)-thetas(1,j)));
% %	crossing_points(:,j) = [x; exp(thetas(1,1)*log(x)+thetas(2,1))];
% %end
% %crossing_points

% system('rm tst.png tst.jpg');

% if plot_curves
	% legenda = {'Original','7/8','6/8','5/8','4/8','3/8','2/8','1/8'};
	% for j = 2:8
		% figure;
		% subplot(211);
		% plot(rates(:,1),dists(:,1), rates(:,j), dists(:,j));
		% hold off; grid on;
		% legend({legenda{1},legenda{j}},'Location','Northeast');
		% subplot(212);
		% loglog(rates(:,1),dists(:,1), rates(:,j), dists(:,j));
		% hold off; grid on;
		% legend({legenda{1},legenda{j}},'Location','Northeast');
	% end
% end