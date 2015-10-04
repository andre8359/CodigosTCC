clc; clear all; close all;

addpath ../imgs;
addpath ../code;



bSize = 8;
wSize = 24;

disp(' ###    LOAD IMAGE       ###');

%temp = double(imread('Lena256.bmp'));
ImRef = zeros(64);

ImRef( bSize: 2*bSize, bSize: 2*bSize ) = 255;
[H,W] = size(ImRef);


figure; imshow(ImRef,[]);

disp('### CREATE IMAGE TEST ###')
ImLowFre = zeros(64);

ImLowFre( 2*bSize:3*bSize, 2*bSize:3*bSize) = 255.0;
figure;imshow(ImLowFre,[]);
disp('### MOTION ESTIMATION ###')

[full0to1 dists] = Motion_Est_n_Comp(ImLowFre, ImRef, ImRef, wSize, wSize, bSize, bSize);

figure;imshow(full0to1,[]);