clear all; close all; clc
addpath imgs
im = imread('mandrill.png');
im_red = im;
im_green = im;
im_blue = im;
% Red channel only
im_red(:,:,2) = 0;
im_red(:,:,3) = 0;

% Green channel only
im_green(:,:,1) = 0;
im_green(:,:,3) = 0;

% Blue channel only
im_blue(:,:,1) = 0;
im_blue(:,:,2) = 0;

figure;imshow(im);
figure;imshow(im_red);
figure;imshow(im_green);
figure;imshow(im_blue);