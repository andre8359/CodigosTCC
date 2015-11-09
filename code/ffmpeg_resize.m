function [read_imgs] = ffmpeg_resize(video,H,W,newH,newW,frame)

        if(ischar(video)==0)
             sizes = size(video);
             UV = zeros(sizes(1) *.5 , sizes(2)*.5);
             create_yuv(video,UV,UV,'original.yuv',1,'w+');
             videoID = 'original.yuv' ;
        else
             [read_frame] = read_yuv(video, W, H, frame);
             sizes = size(read_frame);
             UV = zeros(sizes(1) *.5 , sizes(2)*.5);
             create_yuv(read_frame,UV,UV,'original.yuv',1,'w+');
             videoID = 'original.yuv' ;
        end

        ret = system(['ffmpeg  -s ' num2str(W) 'x' num2str(H) ' -i ' videoID ' -s ' num2str(newW) 'x' num2str(newH)  ' -loglevel quiet resize_.yuv'   ]);

        [read_imgs] = read_yuv('resize_.yuv' , newW, newH, 1);

        system('rm -irf original.yuv resize_.yuv');
