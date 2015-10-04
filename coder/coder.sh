#!/bin/bash

#coding
echo "### CODING ODD FRAMES ###"
ffmpeg -s 1280x720 -i ../videos/shields.yuv  -filter:v select="mod(n-1\,2)" -vcodec mjpeg -qscale 1  odd.avi
ffmpeg -i odd.avi -c:v rawvideo -pix_fmt yuv420p odd.yuv

echo "### CODING EVEN FRAMES ###"
ffmpeg -s 1280x720 -i ../videos/shields.yuv  -filter:v select="not(mod(n-1\,2))" -vcodec mjpeg -qscale 1 -s 640x360 even.avi
ffmpeg -i even.avi -c:v rawvideo -pix_fmt yuv420p even.yuv

echo "###   DELETING AVI FILES   ###"
rm -irf *.avi