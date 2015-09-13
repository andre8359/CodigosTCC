#ifndef EDGEDETECTION_H
#define EDGEDETECTION_H

#include "ImageLib/ImageLib.h"

class Fl_Image;

#define Loop_Image(x,y,width,height) for(int y = 0; y < height; y++) for(int x = 0; x < width; x++) 

// Main function which perform the edge detection until step # 
void performEdgeDetection(CFloatImage &image, CFloatImage &result, int step);

//--------------------------------------------------------------------
// Image Utilities
// -------------------------------------------------------------------

// Convert Fl_Image to CFloatImage.
bool convertImage(const Fl_Image *image, CFloatImage &convertedImage);

// Convert CFloatImage to CByteImage.
void convertToByteImage(CFloatImage &floatImage, CByteImage &byteImage);

// Write CByteImage to a Bmp file.
int	writeByteImageToBMP(CByteImage &byteImage, const char* fileName);

#endif