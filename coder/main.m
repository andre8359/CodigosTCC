%function coder(videoStream,width,height,param)
	addpath ../code;	
	%yuv = '720p50_shields_ter.yuv';
	%height = 720;
	%width = 1280;
	%format = '420';
	fileName = '720p50_shields_ter.y4m';width=1280;height=720;idxFrame = [3];typeYuv='420';
	[mov,imgRgb] = read_yuv(fileName, width, height, idxFrame,typeYuv);
%mplayer -demuxer rawvideo -rawvideo w=176:h=144:format=i420 a.yuv -loop 0
