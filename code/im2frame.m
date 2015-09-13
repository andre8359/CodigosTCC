function [frame] = im2frame (x, map = [])
 
  if (nargin < 1 || nargin > 2)
   print_usage ();
  elseif (ndims (x) > 4)
   error ('im2frame: X and RGB must be a single image');
  endif

  nchannels = size (x, 3);
  if (nchannels == 3)
   
  elseif (nchannels == 1)
   if (nargin < 2)
     error ('im2frame: MAP required for indexed images');
   endif
   [x, map] = ind2x ('im2frame', x, map);
  else
   error ('im2frame: first argument must be indexed or RGB image');
  endif

  
  if (ndims (x) == 4)
   x = reshape (num2cell (x, [1 2 3]), 1, size (x, 4));
  endif

  frame = struct ('cdata', x, 'colormap', map);
endfunction