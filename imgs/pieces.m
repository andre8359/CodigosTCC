img1 = imread('lena.png');
img = img1(:,:,1);
x = 25;
piece = img(x:x+10,x:x+10);
img(x-5:x+15,x-5:x+15) = 0;
img(x:x+10,x:x+10) = piece;
imwrite(img,'lena_quadrado.png');
imwrite(piece,'quadrado.png');
figure;imshow(piece,[])
figure; imshow(img,[])
