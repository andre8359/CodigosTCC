function [y,cb,cr] = read_yuv(yuv,height,width,format)
    %[y,cr,cb] = read_yuv(yuv,height,width) 
    %yuv --> Nome arquivo de entrada 
    %height --> Num de linhas 
    %width --> Num de colunas 	
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
	file = fopen(yuv,'r');

   
    Ystream = fread(file,height*width);
    Crstream = fread(file,round(height/upsample_factor)*round(width/upsample_factor));
    Cbstream = fread(file,round(height/upsample_factor)*round(width/upsample_factor));

    fclose(file);

    Y = zeros(height,width);
    L = 1;
    C = 1;

    for f=1:1:height*width
      
        Y(L,C) = Ystream(f);
        C = C + 1;
        
        if C > width
            C = 1;
            L = L + 1;
        end
        
    end

    Cr = zeros(height/upsample_factor,width/upsample_factor);
    Cb = zeros(height/upsample_factor,width/upsample_factor);
    
	L = 1;
    C = 1;
    for f=1:1:height*width/(2*upsample_factor)
        Cr(L,C) = Crstream(f);
        Cb(L,C) = Cbstream(f);
        C = C + 1;
        if C > width/upsample_factor
            C = 1;
            L = L + 1;
        end
    end

    y = double(Y);
    cr = double(Cr);
    cb = double(Cb);


