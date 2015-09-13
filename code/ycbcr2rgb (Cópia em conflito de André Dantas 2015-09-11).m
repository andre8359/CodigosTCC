%Copyright (C) 2005  Berge-Gladel

%This program is free software; you can redistribute it and/or
%modify it under the terms of the GNU General Public License
%as published by the Free Software Foundation; either version 2
%of the License, or (at your option) any later version.

%This program is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%GNU General Public License for more details.

function nouvmat2 = ycbcr2rgb(in)

%   YCBCR2RGB Convert YCbCr values to RGB color space.
%   RGBMAP = YCBCR2RGB(YCBCRMAP) converts the YCbCr values in the
%   colormap YCBCRMAP to the RGB color space. If YCBCRMAP is M-by-3 and
%   contains the YCbCr luminance (Y) and chrominance (Cb and Cr) color
%   values as columns, then RGBMAP is an M-by-3 matrix that contains
%   the red, green, and blue values equivalent to those colors.
%
%   RGB = YCBCR2RGB(YCBCR) converts the YCbCr image to the equivalent
%   truecolor image RGB
%	


	

		% cas ou on a une image (s est la taille de l'image en pixels)
		%matrice(:,:,:) = colormap(map) ; 
		% attention, on a des valeurs entre 0 et 1
		m=size(in);

		nbligmat = m(1);
		nbcolmat = m(2);

		nouvmat2 = ones(nbligmat,nbcolmat);
		
		% on multiplie par 255
		matrice = in *255;

		for i = 1 : nbligmat
			%  R = Y + 1.402*(Cr-128)
			nouvmat2(i,1) = matrice(i,1,:) + 1.402 * (matrice(i,3,:) - 128);
			%  G = Y - 0.34414 (Cb-128) - 0.71414 (Cr-128)
			nouvmat2(i,2) = matrice(i,1,:) - 0.34414 * (matrice(i,2,:) - 128) - 0.71414 * (matrice(i,3,:) - 128);
			%  B = Y + 1.772 * (Cb-128)
			nouvmat2(i,3) = matrice(i,1,:) + 1.772 * (matrice(i,2,:) - 128);
		end
		
		
		% on divise par 255 pour rendre une matrice avec des valeurs entre 0 et 1
    		nouvmat2 = nouvmat2 / 255;
		
		for i = 1 : nbligmat
			for j = 1 : nbcolmat
				if nouvmat2(i,j) < 0
					nouvmat2(i,j) = 0;
				end
			end
		end
		



	
	
	




 endfunction
