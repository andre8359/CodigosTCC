#!/bin/bash

#variables
VIDEO=$1
SIZE="$3x$2"
NEW_SIZE="$5x$4"

#coding
echo "### CODING ODD FRAMES ###"
ffmpeg -r 2 -s $SIZE -i $VIDEO -filter:v select="mod(n-1\,2)"  -r 1 -vcodec mjpeg -qscale 1  odd.avi
ffmpeg -i odd.avi -c:v rawvideo -pix_fmt yuv420p odd.yuv

echo "### CODING EVEN FRAMES ###"
ffmpeg -r 2 -s $SIZE -i $VIDEO   -filter:v select="not(mod(n-1\,2))" -r 1 -vcodec mjpeg -qscale 1 -s $NEW_SIZE even.avi
ffmpeg -i even.avi -c:v rawvideo -pix_fmt yuv420p even.yuv

echo "###   DELETING AVI FILES   ###"
rm -irf *.avi