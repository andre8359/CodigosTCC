#!/bin/bash

#coding
echo "### CODING ODD FRAMES ###"
ffmpeg -s 1280x720 -i 720p50_shields_ter.yuv  -filter:v select="mod(n-1\,2)" -vcodec mjpeg -qscale 1  odd.avi
echo "### CODING EVEN FRAMES ###"
ffmpeg -s 1280x720 -i 720p50_shields_ter.yuv  -filter:v select="not(mod(n-1\,2))" -vcodec mjpeg -qscale 1 -s 640x360 even.avi
