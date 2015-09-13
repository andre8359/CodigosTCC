function [RGB] = ycbcr2rgb(Y,Cb,Cr,format)
	%[RGB] = ycrcb2rgb(Y,Cb,Cr)
	%RGB --> matriz da imagem de tres camadas (RGB)
	%Y --> matriz com luminancias
	%Cb --> matriz com crominancias
	%Cr --> matriz com crominancias
	%format -> tipo de yuv (exemplo 4:2:0)
	%opções de formato : '420' (default),'444' 

	if nargin < 4
		format = '420'
	end 
	if format=='444'
		upsample_factor = 1;
    elseif format=='420'
		upsample_factor = 2;
	else
		disp('### O FORMATO INFORMADO ESTA INCORRETO! (PARA MAIS INFORMAÇÃOES VEJA O HELP) ###')
		return;
	end
	
	[height width]=size(Y);

	Cb1 = imresize(Cb,upsample_factor);
	Cr1 = imresize(Cr,upsample_factor);
	 
	rgb = zeros(height,width,3);

	R = Y + 1.402*(Cr1 - 128);
	G = Y - 0.344*(Cb1 - 128) - 0.714*(Cr1 - 128);
	B = Y + 1.772*(Cb1 - 128);

	
	R(R<0) = 0;
	R(R>255) = 255;
	G(G<0) = 0;
	G(G>255) = 255;
	B(B<0) = 0;
	B(B>255)=255;

	
	rgb(:,:,1) = R;
	rgb(:,:,2) = G;
	rgb(:,:,3) = B;

	RGB = rgb;
	%imwrite(rgb,'Paisagem-f.jpg');