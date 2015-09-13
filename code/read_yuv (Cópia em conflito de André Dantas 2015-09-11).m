function [mov,imgRgb] = read_yuv(fileName, width, height, idxFrame,typeYuv)
    %[mov,imgRgb] = read_yuv(fileName, width, height, idxFrame)
    %fileName --> Nome arquivo de entrada 
    %height --> Num de linhas 
    %width --> Num de colunas 	
	%idxFrame --> vetor com numero de frames
    %typeYuv --> tipo do yuv  420(default), 444
    %fileName = '720p50_shields_ter.y4m', width =1280 , height=720, idxFrame = 2,typeYuv='420'
    
    if nargin < 5
        typeYuv = '420';
    end

    if typeYuv == '420'
        sizeFactor = 1.5;
    elseif typeYuv == '444'
        sizeFactor = 2;
    else
        disp('### O FORMATO INFORMADO ESTA INCORRETO! (PARA MAIS INFORMAÇÃOES VEJA O HELP) ###')
        return;
    end 
        
    
    fileId = fopen(fileName, 'r');
    imgY = zeros(width, height);
    imgU = zeros(width/2, height/2);
    imgV = zeros(width/2, height/2);
    nrFrame = length(idxFrame);
    flag =0;
    for f = 1 : 1 : nrFrame
        % procura posição do frame no arquivo 
        sizeFrame = sizeFactor * width * height;
        fseek(fileId, (idxFrame(f) - 1) * sizeFrame, 'bof');
        
        % lê componemte Y 
        buf = fread(fileId, width * height, 'uchar');
        imgYUV(:,:,1) = reshape(buf, width, height).'; % reshape
        
        % lê  componemte U 
        buf = fread(fileId, width / 2 * height / 2, 'uchar');
        imgU_ = reshape(buf, width / 2, height / 2)'; % reshape and upsample
        imgYUV(:,:,2) = imresize(uint8(imgU_),2);
        % lê componente V
        buf = fread(fileId, width / 2 * height / 2, 'uchar');
        imgV_ = reshape(buf, width / 2, height / 2)'; % reshape and upsample
        imgYUV(:,:,3) = imresize(uint8(imgV_),2);
        % normalize YUV values
        clipValue(imgY, 0, 255);
        clipValue(imgU, 0, 255);
        clipValue(imgV, 0, 255);

        %

        % convert YUV to RGB
        %imgRgb = reshape(convertYuvToRgb(reshape(imgYuv, height * width, 3)), height, width, 3);
        imgRgb = ycbcr2rgb (imgYUV, standard = "601");
        imshow(imgRgb)
        %imwrite(imgRgb,'ActualBackground.bmp','bmp');
        if flag == 0
            clear('imgRgb_');

            imgRgb_(:,:,1) = DCT_Blk_Resize(double(imgRgb(:,:,1)), 8,4);
            imgRgb_(:,:,2) = DCT_Blk_Resize(double(imgRgb(:,:,2)), 8,4);
            imgRgb_(:,:,3) = DCT_Blk_Resize(double(imgRgb(:,:,3)), 8,4);
            flag = 1;
        else 
            imgRgb_ = imgRgb;
            flag = 0;
        end

        imwrite(uint8(imgRgb_),['ActualBackground' num2str(f) '.jpeg'],'jpeg');
        
        %mov(f) = im2frame(imgRgb);
        %   mov(f).cdata = uint8(imgRgb);
        %   mov(f).colormap =  [];
        %imwrite(imgRgb,'ActualBackground.bmp','bmp');
        
        %figure, imshow(imgRgb);
        %name = 'ActualBackground.bmp';
        %Image = imread(name, 'bmp');
        %figure, imshow(Image);
    end
    fclose(fileId);