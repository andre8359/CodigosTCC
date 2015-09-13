function [Y CB CR] = RGB2ycbcr(RGB,format)
	% [Y CB CR] = RGB2ycrcb(RGB)
	%RGB --> matriz da imagem de tres camadas (RGB)
	%Y --> matriz com luminancias
	%CB --> matriz com crominancias
	%CR --> matriz com crominancias
	%format -> tipo de yuv (exemplo 4:2:0)
	%opções de formato : '420' (default),'444' 

	if nargin < 2
		format = '420';
    end
    
	if format=='444'
		downsample_factor = 1;
    elseif format=='420'
		downsample_factor = 0.5;
	else
		disp('### O FORMATO INFORMADO ESTA INCORRETO! (PARA MAIS INFORMAÇÃOES VEJA O HELP) ###')
		return;
	end
		

	R = double(RGB(:,:,1));
	G = double(RGB(:,:,2));
	B = double(RGB(:,:,3));

	Y = round(0.299*R + 0.587*G + 0.114*B);
	Cb = imresize(round(0.564*(B - Y) + 128),downsample_factor);
	Cr = imresize(round(0.713*(R - Y)+ 128),downsample_factor);


	%Cb = round(0.564*(B - Y) + 128);
	%Cr = round(0.713*(R - Y)+ 128);

	Y(Y<0)=0;
	Y(Y>255)=255;
	Cb(Cb<0) = 0;
	Cb(Cb>255) = 255;
	Cr(Cr<0) = 0;
	Cr(Cr>255) = 255;
	
	CB = round(Cb);
	CR = round(Cr);

