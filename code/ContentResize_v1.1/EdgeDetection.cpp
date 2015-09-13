#include <math.h>
#include <FL/Fl.H>
#include <FL/Fl_Image.H>
#include "edgedetection.h"
#include <windows.h>

void dummyConvertToGrayScale(CFloatImage &src, CFloatImage &dst) {
	
	// Modify the following code to convert color image to GrayScale when NECCESSARY!
	
	CShape sh = src.Shape();
	Loop_Image(x,y,sh.width,sh.height)		
		dst.Pixel(x,y,0) = src.Pixel(x,y,0);	
}


void dummyPreSmooth(CFloatImage &src, CFloatImage &dst) {

	// Modify the following code to perform pre-smoothing

	CShape sh = src.Shape();
	Loop_Image(x,y,sh.width,sh.height)		
		dst.Pixel(x,y,0) = src.Pixel(x,y,0);	
}

void dummyComputeGradient(CFloatImage &src, CFloatImage &dx, CFloatImage &dy, CFloatImage &mag, CFloatImage &theta) {

	// Modify the following code to compute gradient

	CShape sh = src.Shape();
	Loop_Image(x,y,sh.width,sh.height)
	{
		dx.Pixel(x,y,0) = src.Pixel(x,y,0);
		dy.Pixel(x,y,0) = src.Pixel(x,y,0);
		mag.Pixel(x,y,0) = src.Pixel(x,y,0);
		theta.Pixel(x,y,0) = src.Pixel(x,y,0);
	}
}

void dummyNonMaximumSupp(CFloatImage &mag, CFloatImage &theta, CFloatImage &dst) {

	// Modify the following code to perform NonMaximumSupp

	CShape sh = mag.Shape();
	Loop_Image(x,y,sh.width,sh.height)		
		dst.Pixel(x,y,0) = mag.Pixel(x,y,0);	
}

void dummyHysteresis(CFloatImage &src, CFloatImage &dst) {

	// Modify the following code to perform Hysteresis

	CShape sh = src.Shape();
	Loop_Image(x,y,sh.width,sh.height)		
		dst.Pixel(x,y,0) = src.Pixel(x,y,0);	
}

void performEdgeDetection(CFloatImage &image, CFloatImage &result, int step) {

	CShape sh = image.Shape();
	int width = sh.width;
	int height = sh.height;
	int band = sh.nBands;

	CFloatImage grayimg1(width,height,1), grayimg2(width,height,1);
	dummyConvertToGrayScale(image,grayimg1);

	if(step>=1)
		dummyPreSmooth(grayimg1,grayimg2);
	
	CFloatImage dx(width,height,1), dy(width,height,1), mag(width,height,1), theta(width,height,1);
	if(step>=2)
		dummyComputeGradient(grayimg2,dx,dy,mag,theta);

	CFloatImage nonmax(width,height,1);
	if(step>=3)
		dummyNonMaximumSupp(mag,theta,nonmax);
	
	CFloatImage edge(width,height,1);
	if(step>=4)
		dummyHysteresis(nonmax,edge); 
	

	result.ReAllocate(sh,false);
	for (int ih=0 ; ih<height;ih++ ) {
		for (int iw=0 ; iw<width;iw++) {
			for (int ib=0; ib<band;ib++) {
				switch(step){
				case 1: 
					result.Pixel(iw,ih,ib) = grayimg2.Pixel(iw,ih,0);				
					break;
				case 2:
					// you need to scale it for visualization	
					result.Pixel(iw,ih,ib) = mag.Pixel(iw,ih,0);				
					break;
				case 3:
					// you need to scale it for visualization		
					result.Pixel(iw,ih,ib) = nonmax.Pixel(iw,ih,0); 			
					break;
				case 4:
					result.Pixel(iw,ih,ib) = edge.Pixel(iw,ih,0);				
					break;
				default:
					result.Pixel(iw,ih,ib) = edge.Pixel(iw,ih,0);	
				}
			}
		}
	}
}

// ------------------------------------------------------------------ 
// Image Utilities, You need not to modify this part
// ------------------------------------------------------------------

// Convert Fl_Image to CFloatImage.
bool convertImage(const Fl_Image *image, CFloatImage &convertedImage) {
	if (image == NULL) {
		return false;
	}

	// Let's not handle indexed color images.
	if (image->count() != 1) {
		return false;
	}

	int w = image->w();
	int h = image->h();
	int d = image->d();

	convertedImage.ReAllocate(CShape(w,h,d));
	// Get the image data.
	const char *const *data = image->data();

	int index = 0;

	for (int y=0; y<h; y++) {
		for (int x=0; x<w; x++) {
			if (d < 3) {
				// If there are fewer than 3 channels, just use the
				// first one for all colors.
				convertedImage.Pixel(x,y,0) = ((uchar) data[0][index]) / 255.0f;
				convertedImage.Pixel(x,y,1) = ((uchar) data[0][index]) / 255.0f;
				convertedImage.Pixel(x,y,2) = ((uchar) data[0][index]) / 255.0f;
			}
			else {
				// Otherwise, use the first 3.
				convertedImage.Pixel(x,y,0) = ((uchar) data[0][index]) / 255.0f;
				convertedImage.Pixel(x,y,1) = ((uchar) data[0][index+1]) / 255.0f;
				convertedImage.Pixel(x,y,2) = ((uchar) data[0][index+2]) / 255.0f;
			}

			index += d;
		}
	}
	return true;
}

// Convert CFloatImage to CByteImage.
void convertToByteImage(CFloatImage &floatImage, CByteImage &byteImage) {
	CShape sh = floatImage.Shape();
	byteImage.ReAllocate(sh);

	for (int y=0; y<sh.height; y++) {
		for (int x=0; x<sh.width; x++) {
			for (int c=0; c<3; c++) {
				float value = floor(255*floatImage.Pixel(x,y,c) + 0.5f);

				if (value < byteImage.MinVal()) {
					value = byteImage.MinVal();
				}
				else if (value > byteImage.MaxVal()) {
					value = byteImage.MaxVal();
				}

				// We have to flip the image and reverse the color
				// channels to get it to come out right.  How silly!
				byteImage.Pixel(x,sh.height-y-1,2-c) = (uchar) value;
			}
		}
	}
}

int	writeByteImageToBMP(CByteImage &byteImage, const char* fileName) {

	FILE	*fp;
	BITMAPFILEHEADER	BmpFileHdr;
	BITMAPINFOHEADER	BmpInfoHdr;
	unsigned char *pBmpData, *pBmpRowData;
	unsigned char	*pMxData, *pMxRowData;
	unsigned int	nRows, nCols, nBmpDataSize;
	unsigned int 	i,j;
	int	Rest;

	CShape sh = byteImage.Shape();

	if(fileName==NULL) {
		return -1;
	}
	
	//
	// Initialize 
	//
	fp = NULL;
	pBmpData = NULL;

	//
	// Open file for writing
	//
	fp = fopen(fileName, "wb");
	if (!fp){
		if (fp){
			fclose(fp);
		}
		if (pBmpData){
			free(pBmpData);
		}
		return -1;
	}

	//
	// Set BMP file header
	//
	nRows = sh.height;
	nCols = sh.width;
	Rest = (nCols*3) % sizeof(int);
	if (Rest!=0)
		Rest = sizeof(int) - Rest;
	nBmpDataSize = nRows * (nCols*3 + Rest);

	BmpFileHdr.bfType = 0x4d42;
	BmpFileHdr.bfSize = sizeof(BITMAPFILEHEADER)+sizeof(BITMAPINFOHEADER)+nBmpDataSize;
	BmpFileHdr.bfOffBits = sizeof(BITMAPFILEHEADER)+sizeof(BITMAPINFOHEADER);
	BmpFileHdr.bfReserved1 = 0;
	BmpFileHdr.bfReserved2 = 0;

	//
	// Set BMP info header
	//
	BmpInfoHdr.biSize = sizeof(BITMAPINFOHEADER);
	BmpInfoHdr.biWidth = nCols;
	BmpInfoHdr.biHeight = nRows;
	BmpInfoHdr.biPlanes = 1;
	BmpInfoHdr.biBitCount = 24;
	BmpInfoHdr.biCompression = BI_RGB;
	BmpInfoHdr.biSizeImage = nBmpDataSize;
	BmpInfoHdr.biXPelsPerMeter = 0;
	BmpInfoHdr.biYPelsPerMeter = 0;
	BmpInfoHdr.biClrUsed = 0;
	BmpInfoHdr.biClrImportant = 0;

	//
	// Initialize BMP data
	// Pay attention that: the data in file we expect bottom to top by rows 
	// but in memory are top to bottom, and the color in file we expect BGR 
	// but in memory is RGB.
	//
	pBmpData = (unsigned char*)malloc(nBmpDataSize);
	if (!pBmpData){
		if (fp){
			fclose(fp);
		}
		if (pBmpData){
			free(pBmpData);
		}
		return -1;
	}

	for (i=0; i<nRows; ++i){
		pBmpRowData = pBmpData+(nRows-1-i)*(nCols*3+Rest);
		for (j=0; j<nCols; ++j){
			pBmpRowData[0] = byteImage.Pixel(j,nRows-1-i,0);
			pBmpRowData[1] = byteImage.Pixel(j,nRows-1-i,1);
			pBmpRowData[2] = byteImage.Pixel(j,nRows-1-i,2);	
			pBmpRowData += 3;
		}
	}

	//
	// Write into file
	//
	fwrite(&BmpFileHdr, sizeof(BITMAPFILEHEADER), 1, fp);
	fwrite(&BmpInfoHdr, sizeof(BITMAPINFOHEADER), 1, fp);
	fwrite(pBmpData, nRows*(nCols*3+Rest), 1, fp);
	fclose(fp);

	return 0;
}


