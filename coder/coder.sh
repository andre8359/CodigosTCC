#!/bin/bash

#variables
VIDEO=$1
SIZE="$3x$2"
NEW_SIZE="$5x$4"


#coding
echo "### CODING ODD FRAMES ###"
ffmpeg -s $SIZE -i ../videos/shields.yuv  -filter:v select="mod(n-1\,2)" -vcodec mjpeg -qscale 1  odd.avi
ffmpeg -i odd.avi -c:v rawvideo -pix_fmt yuv420p odd.yuv

echo "### CODING EVEN FRAMES ###"
ffmpeg -s $SIZE -i ../videos/shields.yuv   -filter:v select="not(mod(n-1\,2))" -vcodec mjpeg -qscale 1 -s $NEW_SIZE even.avi
ffmpeg -i even.avi -c:v rawvideo -pix_fmt yuv420p even.yuv

echo "###   DELETING AVI FILES   ###"
rm -irf *.avi