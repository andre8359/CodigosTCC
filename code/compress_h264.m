function ret = compress_h264(argument_list,flag_delete_dat_files)
	%ret = compress_h264(argument_list);
	%argument_list -> with all the arguments for the compression
	% example of argument_list's list : argument_list  = ['lencod.exe ' '-d encoder.cfg' ' -p InputFile = "tst.yuv" ' ...
	%						' -p SourceWidth = 512' ' -p SourceHeight = 512' ' -p SourceResize = 0' ...
	%						' -p OutputWidth = 512' ' -p OutputHeight = 512' ' -p ReconFile = "recon_tst.yuv"' ...
	%						' -p OutputFile = "tst.264"' ];
	%flag -> Delete .dat files  0 = yes other = no
	if nargin < 2
		argument_list  = ['lencod ', '-d "JM\bin\encoder.cfg"' ,' -p InputFile = "tst.yuv" ' ...
							' -p SourceWidth = 512' ,' -p SourceHeight = 512' ,' -p SourceResize = 0' ...
							' -p OutputWidth = 512' ,' -p OutputHeight = 512', ' -p ReconFile = "recon_tst.yuv"' ...
							' -p OutputFile = "tst.264"' ];
		flag_delete_dat_files = 0;
    end
    
	[ret,a] = system(argument_list);
	if(not(flag_delete_dat_files))
		[a,b] = system('del *.dat');
        disp('### CODIFICADO COM SUCESSO ###');
	end
	

