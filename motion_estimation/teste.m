clc; clear all; close all;

addpath ../imgs;
addpath ../code;

mex mexFile.c

bSize = 8;
wSize = 256;

%disp(' ###    LOAD IMAGE       ###');

ImRef = double(imread('Lena256.bmp'));
ImRef(1:10,1:10)  = zeros(10);
%figure; imshow(ImRef,[]);

%disp('### CREATE IMAGE TEST ###')
ImLowFre = double(zeros(size(ImRef)));
[H,W] = size(ImRef);
ImLowFre(H/2-100:H/2+100,W/2-100:W/2+100) = ImRef(H/2-100:H/2+100,W/2-100:W/2+100);
%figure;imshow(ImLowFre,[]);

%disp('### MOTION ESTIMATION ###');

i1=1;j1=1;
ImRef = reshape(ImRef',H*W,1);
ImLowFre = reshape(ImLowFre',H*W,1);
%vector = mexFile (ImRef,ImLowFre,W,H,wSize,bSize,i1,j1)

vector = motion_estimation(ImRef,ImLowFre,wSize,bSize);

%disp('###     COMPENSATION     ###');
[ImComp] = compensation(ImRef,vector,bSize,wSize);

%figure;imsHoW(ImComp,[]);
