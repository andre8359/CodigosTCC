#include <stdio.h>
#include <string.h>
#include "mex.h"   

/* Definitions to keep compatibility with earlier versions of ML */
#ifndef MWSIZE_MAX
typedef int mwSize;
typedef int mwIndex;
typedef int mwSignedIndex;

#if (defined(_LP64) || defined(_WIN64)) && !defined(MX_COMPAT_32)
/* Currently 2^48 based on hardware limitations */
# define MWSIZE_MAX    281474976710655UL
# define MWINDEX_MAX   281474976710655UL
# define MWSINDEX_MAX  281474976710655L
# define MWSINDEX_MIN -281474976710655L
#else
# define MWSIZE_MAX    2147483647UL
# define MWINDEX_MAX   2147483647UL
# define MWSINDEX_MAX  2147483647L
# define MWSINDEX_MIN -2147483647L
#endif
#define MWSIZE_MIN    0UL
#define MWINDEX_MIN   0UL
#endif

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

//declare variables
    mxArray *img_out_m;
    double *img_out;
    char *name; 
   
    int i,j,W,H,frame, temp, length_name, status;
    FILE * fp;
        
//associate inputs
	
    length_name = (mxGetM(prhs[0]) * mxGetN(prhs[0])) + 1;
    name = mxCalloc(length_name, sizeof(char));
    status = mxGetString(prhs[0], name, length_name);

    W = mxGetScalar(prhs[1]);
	H = mxGetScalar(prhs[2]);
    frame = mxGetScalar(prhs[3]);


    img_out_m = plhs[0] = mxCreateDoubleMatrix(W,H,mxREAL);
//associate pointers
   
    img_out = mxGetPr(img_out_m);
 
    fp = fopen(name,"r+");
    fseek(fp,1.5*H*W*frame,SEEK_SET);

    if(!fp){
        mexPrintf("Imposivel abrir o arquivo!");
        exit(0);
    }
    
//do something
    
    for(i=0;i<W;i++)
    {
        for(j=0;j<H;j++)
        {
            temp = fgetc(fp);
            
            //mexPrintf("element[%d][%d] = %f\n",j,i,a[i*dimy+j]);
            img_out[i*H+j] = temp; //adds 5 to every element in a
            //d[i*dimy+j] = b[i*dimy+j]*b[i*dimy+j]; //squares b
        }
    }
    
    fclose(fp);

    return;
}
