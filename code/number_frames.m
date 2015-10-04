function [nFrames,ret]=number_frames(fileName,height,width)

    fileId = fopen(fileName, 'r');
    ret = 1;
    nFrames = 0;
    while not(isempty(ret))
         ret = fread(fileId, [height , width], 'uchar');
         fread(fileId, width / 2 * height / 2, 'uchar');
         fread(fileId, width / 2 * height / 2, 'uchar');
         nFrames = nFrames + 1;
    end
    nFrames = nFrames - 1;
    fclose(fileId);