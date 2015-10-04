#include "mex.h"

#define position(frame, x, y, H) (frame[(y)+(H)*(x)])

void Check_Limits(mwIndex a, mwSize min_a, mwSize max_a, mwSize delta_a, mwIndex low_hi[2]);

void mexFunction (int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[])
{
	mwIndex x, y, xx, yy, xxx, yyy;
	mwSize W, H;
	mwSize wnd_x, wnd_y, blk_x, blk_y;
	mwSize best_x, best_y;
	mwSize WW[2], HH[2]; //Window limits for the current block
	double diff, ssd, min_ssd, max_ssd;
	double *fr_tgt, *fr_ref, *in_params;
	double *mvx, *mvy, *ssd_out;

	H = mxGetM(prhs[0]);
   	W = mxGetN(prhs[0]);

    	fr_tgt = mxGetPr (prhs[0]);
	fr_ref = mxGetPr (prhs[1]);
	in_params = mxGetPr (prhs[2]);
    	blk_x = (mwSize)(in_params[0]);
	blk_y = (mwSize)(in_params[1]);
	wnd_x = (mwSize)(in_params[2]);
	wnd_y = (mwSize)(in_params[3]);
	max_ssd = ((double)(255*255*blk_x*blk_y))+1.0;
	nlhs = 3;

    	for(x=0; x<nlhs; x++)
		plhs[x] = (mxArray *) mxCreateNumericArray(mxGetNumberOfDimensions (prhs[0]),
			mxGetDimensions (prhs[0]), mxGetClassID (prhs[0]), mxIsComplex (prhs[0]));

	mvx = mxGetPr (plhs[0]);
	mvy = mxGetPr (plhs[1]);
	ssd_out = mxGetPr (plhs[2]);
	for(y=0; y<=H-blk_y; y+=blk_y)
	{
		Check_Limits(y, 0, H-blk_y, wnd_y, HH);
		for(x=0; x<=W-blk_x; x+=blk_x)
		{
			Check_Limits(x, 0, W-blk_x, wnd_x, WW);
			best_x = x;
			best_y = y;
			min_ssd = max_ssd;
			for(yy=HH[0]; yy<=HH[1]; yy++)
				for(xx=WW[0]; xx<=WW[1]; xx++)
				{
					for(ssd=0.0, yyy=0; yyy<blk_y; yyy++)
						for(xxx=0; xxx<blk_x; xxx++)
						{
							diff = position(fr_tgt, x+xxx, y+yyy, H)-position(fr_ref, xx+xxx, yy+yyy, H);
							ssd += diff*diff;
						}
					if(ssd<min_ssd)
					{
						best_x = xx;
						best_y = yy;
						min_ssd = ssd;
					}
				}
			position(mvx,x,y,H) = best_x;
			position(mvy,x,y,H) = best_y;
			position(ssd_out,x,y,H) = min_ssd;
		}
	}
}

void Check_Limits(mwIndex a, mwSize min_a, mwSize max_a, mwSize delta_a, mwIndex low_hi[2])
{
	low_hi[0] = a-delta_a;
	if(low_hi[0] < min_a)
	{
		low_hi[0] = min_a;
		low_hi[1] = min_a+2*delta_a;
	}
	else
	{
		low_hi[1] = a+delta_a;
		if(low_hi[1] > max_a)
		{
			low_hi[0] = max_a-2*delta_a;
			low_hi[1] = max_a;
		}
	}
}
