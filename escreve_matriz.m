img = imread('lena.png');
blk = img(256:256+8,256:256+8,1);
imshow(blk)
tblk = dct2(blk)
fid = fopen('arquivo.txt','wt')
A = size(tblk);
for i=1:A(1)
    for k=1:A(2)
        fprintf(fid,'%.2f&\t',tblk(i,k));
    end
    fprintf(fid,'\n');
end
fclose(fid)