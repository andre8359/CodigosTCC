#pragma once
#include "EdgeDetection.h"

//#define Content_Debug

#define isZero(x) (abs(x)<0.0000000001)
#define isEqual(x,y) isZero(x-y)

#define LargeNum 1000000000
#define OutOfImage(x,y,width,height) ((x<0)||(x>width-1)||(y<0)||(y>height-1))
#define minABC(a,b,c) (min(min(a,b),c))

#define VertSeams "VertSeams"
#define HorizonSeams "HorizonSeams"

struct Point 
{
	int x;
	int y;
};
typedef vector<Point> Seam;
typedef vector< Seam > SeamSet;

struct CumEnergyElement 
{
	float cumEnergy;
	int xPrevious;
	int yPrevious;
};
typedef vector< vector<CumEnergyElement> > CumEnMatrix; 

struct Rectangle
{
	int left;
	int right;
	int top;
	int bottom;
};

class ContentImResize
{
public:
	ContentImResize(void);
	~ContentImResize(void);

	void ContentAwareImResize(CFloatImage& src, CFloatImage& dst, bool needInitWeigt = true); 
	void ContentAwareImResize(CFloatImage& src, CFloatImage& mask, CFloatImage& dst);	

	void SetParameters(double fractionOfEnlarge, double fractionOfShrink, int deleteByVertivalSeams);

private:
	void ShrinkImage(CFloatImage& src, CFloatImage& dst);
	void EnlargeImage(CFloatImage& src, CFloatImage& dst);
	void RemoveByVertSeams( CFloatImage &tmpImg, CFloatImage& src, CShape &sh, CShape &srcSh, struct Rectangle& rec );
	void RemoveByHorizonSeams( CFloatImage& src, CShape &sh, CShape &srcSh, struct Rectangle& rec, CFloatImage &tmpImg );

	void AddHorizonSeams(CFloatImage &src, SeamSet &seamSet, CFloatImage &dst);	
	void FindHorizSeam(Seam& hseam);
	int ComputeHoriCumEnMap(CumEnMatrix& cumEnMap); 
	void DeleteOneHorizSeam(Seam& hseam);
	double SqDistOfSeams(const Seam& s1, const Seam& s2);	

	void PixelClone( CFloatImage &src, CFloatImage &dst, int x, int y );
	void ImageClone(CFloatImage& src, CFloatImage& dst);
	void ImageTranspose(CFloatImage& src, CFloatImage& dst);
	void Convert2GrayFloat(CFloatImage& image, CFloatImage& grayFloatImage);
	float SafePixel(CFloatImage& image, const CShape& validSh, int x, int y, int c, float backupVal);

	//Initialization
	void Initialization(CFloatImage& src);
	void MaskProcessing(CFloatImage& src, CFloatImage& dst, float *mask, int mkW, int mkH);
	void EnergyGradient(CFloatImage& Hsrc, CFloatImage& Vsrc);
	void SetShiftHistory();
	//test
	void SaveFloatImage(CFloatImage& image, const string& name, bool needNorm = false);
	void SaveImageWithSeams(CFloatImage& src, const string& name, const SeamSet& seamSet);
	void convertToByteImage(CFloatImage &floatImage, CByteImage &byteImage, bool needNorm = false);
	void NormalizeFloatImage(CFloatImage& image);

private:
	CFloatImage m_intermImage;
	CFloatImage m_ernergy;
	CShape m_validSh;
	vector< vector<int> > m_shiftHist;
	string m_vertOrHoriz;
	CFloatImage m_weight;

private:
	double FractionOfEnlarge;
	double FractionOfShrink;
	int DeleteByVertivalSeams;
};
