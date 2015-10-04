function vector = motion_estimation(ImRef,ImLowFre,wSize,bSize)

	%vector = motion_estimatio(Im1,Im2,wSize,bSize)
	%Reaaliza a estimação de movimento entre a ImRef e a ImLowFreq.
	%ImRef=> Imagem com alta frequência, ou seja, possui o bloco a ser procurado;
	%ImLowFre => Imagem com baixa frequência;
	%wSize => Tamanho da janela de busca;
	%bSize => Tamanho do bloco;

            [H,W] = size(ImRef);
            vector = zeros((H*W)/(bSize^2),2);
	k = 1;
	for i1 = 1:bSize:H - mod(H,bSize) - bSize
    		for j1 = 1:bSize:W - mod( W , bSize) - bSize
         		[vector(k,1),vector(k,2)] = ME(ImRef,ImLowFre,wSize,bSize,i1,j1);
       	 	k=k+1;
    		end
	end

endfunction

function [X,Y] = ME(ImRef,ImLowFre,wSize,bSize,i1,j1)

	%[X,Y] => Par ordenado referente a um bloco;
	%ImRef => Imagem com alta frequência, ou seja, possui o bloco a ser procurado;
	%Im2 => Imagem com baixa frequência;
	%wSize => Tamanho da janela de busca;
	%bSize => Tamanho do bloco;
	%i1,j1 => posição do primeiro pixel do bloco.

	errorMin=inf;
	err = 0;
	x_error=0;
	y_error=0;
            [H,W] = size(ImRef);

	%limites do bloco - tratamento de borda
	limS = max(i1 - bSize * wSize , 1);
	limI = min(i1+bSize*wSize, H - bSize);
	limS2 = max(j1-bSize*wSize,1);
	limI2 = min(j1+bSize*wSize, W - bSize);

	for i2 = limS:1:limI
	    for j2 = limS2:1:limI2
	        %MSE entre os blocos
		    err = sum(sum(( ImLowFre(i1:i1+bSize,j1:j1+bSize) - ImRef(i2:i2+bSize,j2:j2+bSize)).^2));
		    if err < errorMin
		   	errorMin = err;
		    	x_error = i2 ;
		    	y_error = j2;
		    end

	     end
	end
	X = x_error;
	Y = y_error;
endfunction
