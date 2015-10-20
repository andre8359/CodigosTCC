function [read_imgs] = ffmpeg_resize(video,H,W,newH,newW,frames)


        if(ischar(video)==0)
            sizes = size(video);
             UV = zeros(sizes(1)*.5,sizes(2)*.5,sizes(3));
             create_yuv(video,UV,UV,'resize.yuv',frames,'w+');
             videoID = 'resize.yuv' ;
        else
            videoID = video
        end
        ret = system(['ffmpeg  -s ' num2str(W) 'x' num2str(H) ' -i ' videoID ' -s ' num2str(newW) 'x' num2str(newW)  ' resize_.yuv'  ]);

        [read_imgs] = read_yuv('resize_.yuv' , newW, newH, [1:1:frames]);

        system('rm -irf resize.yuv resize_.yuv');
