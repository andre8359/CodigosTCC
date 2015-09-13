#include "mex.h"
#include <math.h>


int order(int v1,int v2,int flag);

void mexFunction (int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	//check inputs
	if(nrhs<8)
	{
		mexPrintf("Tretas mano!!!");
		mexAtExit(0);
	}

	//declare variables
	mxArray *ImRef_m, *ImLowFre_m,*vector_m;
	const mwSize *dims;
	double *ImRef, *ImLowFre,*c, *d, *vector;
	int dimx, dimy, numdims;
	int i=0,j=0,i1,j1,i2,j2,wSize,bSize,W,H;

	double errorMin=99999, err = 0, x_error=0, y_error=0;
    	int limS,limLE,limI,limLD;

	//associate inputs
	ImRef_m = mxDuplicateArray(prhs[0]);
	ImLowFre_m = mxDuplicateArray(prhs[1]);
	W = mxGetScalar(prhs[2]);
	H = mxGetScalar(prhs[3]);
	wSize = mxGetScalar(prhs[4]);
	bSize = mxGetScalar(prhs[5]);
	i1 = mxGetScalar(prhs[6]);
	j1 = mxGetScalar(prhs[7]);

	//associate outputs
    	nlhs = 1;
	vector_m = plhs[0] = mxCreateDoubleMatrix(1,2,mxREAL);

	//associate pointers
	ImRef = mxGetPr(ImRef_m);
	ImLowFre = mxGetPr(ImLowFre_m);
	vector = mxGetPr(vector_m);

    	//defineing bounders
	limS = order((int)(i1-0.5*wSize),0,1);
    	limI = order((int)(i1+0.5*wSize),H-bSize-1,0);
	limLE = order((int)(j1-0.5*wSize),0,1);
	limLD = order((int)(j1+0.5*wSize),W-bSize-1,0);
	//mexPrintf("limS=%d ,limI = %d,limLE = %d,limLD = %d\n",limS,limI,limLE,limLD);

	for(i2=limS; i2<=limI-bSize-1; i2++)
		for(j2=limLE; j2<=limLD-bSize-1; j2++)
		{
			//mexPrintf("i=%d \n",i2);
			//calc err
			err = 0;
			for(i=i2; i<(i2+bSize); i++)
				for(j=j2; j<(j2+bSize); j++){
					//mexPrintf("i=%d  - j=%d\n",i,j);
					err += ImRef[i*H+j] - ImLowFre[i*H+j];
				}

			if (err<errorMin){
				errorMin = err;
				x_error = i2;
				y_error = j2;
			}
		}

	//mexPrintf("teste:%lf\n",err);
	vector[0] = x_error;
	vector[1] = y_error;
}

int order(int v1,int v2,int flag)
{
	if(flag){
		if(v1>v2)
			return v1;
		else
			return v2;
	}
	else{
		if(v1<v2)
			return v1;
		else
			return v2;
	}
}

