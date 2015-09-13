#include ".\ContentImResize.h"
#using <mscorlib.dll>
#include <iostream>
#include <math.h>
#include <algorithm>
#include <sstream>
using namespace std;

ContentImResize::ContentImResize(void)
: FractionOfEnlarge(0.5)
, FractionOfShrink(0.5)
, DeleteByVertivalSeams(-1)
{
}

ContentImResize::~ContentImResize(void)
{
}

void ContentImResize::ContentAwareImResize(CFloatImage& src, CFloatImage& mask, CFloatImage& dst)
{
	CShape maskSh = mask.Shape(), srcSh = src.Shape(), dstSh = dst.Shape();
	if(maskSh != srcSh)
	{
		cout<<"mask image is supposed to have the same size as src image"<<endl;
		exit(0);
	}

	CShape sh = maskSh;
	sh.nBands = 1;
	m_weight.ReAllocate(sh);
	m_weight.ClearPixels();
	string supv("");
	
	Rectangle rec;
	rec.left = LargeNum; rec.right = -LargeNum; rec.top = LargeNum; rec.bottom = -LargeNum;
	Loop_Image(x,y,maskSh.width,maskSh.height)
	{
		if(isEqual(mask.Pixel(x,y,0),1.0f) && isEqual(mask.Pixel(x,y,1),0.0f) && isEqual(mask.Pixel(x,y,2),0.0f))
		{
			m_weight.Pixel(x,y,0) = -LargeNum;	//remove
			if(supv.empty())
				supv = "remove";
			else if(supv.compare("retain") == 0)
				supv = "both";
			rec.left = min(x,rec.left);
			rec.top = min(y,rec.top);
			rec.right = max(x,rec.right);
			rec.bottom = max(y,rec.bottom);
		}
		else if(isEqual(mask.Pixel(x,y,0),0.0f) && isEqual(mask.Pixel(x,y,1),1.0f) && isEqual(mask.Pixel(x,y,2),0.0f))
		{
			m_weight.Pixel(x,y,0) = LargeNum;	//retain
			if(supv.empty())
				supv = "retain";
			else if(supv.compare("remove") == 0)
				supv = "both";
		}
	}

	if(supv.compare("retain") == 0)
	{
		ContentAwareImResize(src,dst,false);
		return;
	}

	CFloatImage tmpImg;
	sh = srcSh;	
	switch(DeleteByVertivalSeams)
	{
	case 1:
		RemoveByVertSeams(tmpImg, src, sh, srcSh, rec);
		break;
	case 0:
		RemoveByHorizonSeams(src, sh, srcSh, rec, tmpImg);
		break;
	default:
		if(rec.bottom - rec.top < rec.right - rec.left)
		{
			RemoveByHorizonSeams(src, sh, srcSh, rec, tmpImg);
		}
		else
		{
			RemoveByVertSeams(tmpImg, src, sh, srcSh, rec);
		}
		break;

	}
	ContentAwareImResize(src,dst);
}

void ContentImResize::SetParameters(double fractionOfEnlarge, double fractionOfShrink, int deleteByVertivalSeams)
{
	FractionOfEnlarge = fractionOfEnlarge;
	FractionOfShrink = fractionOfShrink;
	DeleteByVertivalSeams = deleteByVertivalSeams;
}

void ContentImResize::RemoveByVertSeams(CFloatImage &tmpImg, CFloatImage& src, CShape &sh, CShape &srcSh, struct Rectangle& rec )
{
	m_vertOrHoriz = "VertSeams";
	ImageTranspose(m_weight,tmpImg);
	ImageClone(tmpImg,m_weight);
	ImageTranspose(src,tmpImg);
	ImageClone(tmpImg,src);

	sh.width = srcSh.width - (rec.right - rec.left);	
	int t = sh.width;
	sh.width = sh.height;
	sh.height = t;
	tmpImg.ReAllocate(sh);

	Initialization(src);
	ShrinkImage(src,tmpImg);

	m_weight.ClearPixels();
	Initialization(tmpImg);
	EnlargeImage(tmpImg,src);

	ImageTranspose(src,tmpImg);
	ImageClone(tmpImg,src);
}

void ContentImResize::RemoveByHorizonSeams(CFloatImage& src, CShape &sh, CShape &srcSh, struct Rectangle &rec, CFloatImage &tmpImg )
{
	Initialization(src);
	sh.height = srcSh.height - (rec.bottom - rec.top);
	tmpImg.ReAllocate(sh);
	ShrinkImage(src,tmpImg);

	m_weight.ClearPixels();
	Initialization(tmpImg);
	EnlargeImage(tmpImg,src);
}

void ContentImResize::ContentAwareImResize(CFloatImage& src, CFloatImage& dst, bool needInitWeight /* = true */)
{
	if((src.Shape().width == dst.Shape().width) && (src.Shape().height == dst.Shape().height))
	{
		ImageClone(src,dst);
		return;
	}

	if(needInitWeight)
	{
		CShape sh = src.Shape();
		sh.nBands = 1;
		m_weight.ReAllocate(sh);
		m_weight.ClearPixels();
	}

	Initialization(src);
	m_vertOrHoriz = "HorizSeams";

	CFloatImage tmpImg(src.Shape().width,dst.Shape().height,src.Shape().nBands);
	if(dst.Shape().height < src.Shape().height)
	{
		ShrinkImage(src,tmpImg);
	}
	else if(dst.Shape().height > src.Shape().height)
	{
		EnlargeImage(src,tmpImg);
	}
	else
		ImageClone(src,tmpImg);

	if(dst.Shape().width != src.Shape().width)
	{
		ImageTranspose(tmpImg,src);
		ImageTranspose(m_weight,tmpImg);
		ImageClone(tmpImg,m_weight);
		Initialization(src);
		CShape sh = dst.Shape();
		int t = sh.height;
		sh.height = sh.width;
		sh.width = t;
		tmpImg.ReAllocate(sh);
		m_vertOrHoriz = "VertSeams";
	}
	else
	{
		ImageClone(tmpImg,dst);
		return;
	}
	if(tmpImg.Shape().height < src.Shape().height)
	{
		ShrinkImage(src,tmpImg);
	}
	else if(tmpImg.Shape().height > src.Shape().height)
	{
		EnlargeImage(src,tmpImg);
	}
	
	ImageTranspose(tmpImg,dst);
}

void ContentImResize::ShrinkImage(CFloatImage& src, CFloatImage& dst)
{
#ifdef Content_Debug
	SeamSet seamSet;
	CFloatImage tmpImg;
	ImageClone(src,tmpImg);
#endif

	Seam hseam;
	int maxStep = (int)(src.Shape().height * FractionOfShrink);
	int r = src.Shape().height - dst.Shape().height;
	for(int i = 0; i < r; i++)
	{
		hseam.clear();
		FindHorizSeam(hseam);
		DeleteOneHorizSeam(hseam);
#ifdef Content_Debug
		seamSet.push_back(hseam);
#endif
		if((i > 0) && (i % maxStep == 0))
		{
			Initialization(m_intermImage.SubImage(0,0,m_validSh.width,m_validSh.height));
#ifdef Content_Debug
			stringstream stream;
			stream.clear();
			string st, name;
			stream<<(i / maxStep);
			stream>>st;
			name = "Shrink" + m_vertOrHoriz + st + ".bmp";
			SaveImageWithSeams(tmpImg,name,seamSet);
			seamSet.clear();
			ImageClone(m_intermImage.SubImage(0,0,m_validSh.width,m_validSh.height),tmpImg);
			SaveFloatImage(tmpImg,"ShrinkFor" + m_vertOrHoriz + st + ".bmp");
#endif
		}
	}
	dst = m_intermImage.SubImage(0,0,m_validSh.width,m_validSh.height);
#ifdef Content_Debug
	SaveImageWithSeams(tmpImg,"Shrink" + m_vertOrHoriz + ".bmp", seamSet);
	SaveFloatImage(dst,"ShrinkFor" + m_vertOrHoriz + ".bmp");
#endif
}

void ContentImResize::EnlargeImage(CFloatImage& src, CFloatImage& dst)
{
	SeamSet seamSet;
	CFloatImage srcCopy,weiCopy;
	ImageClone(src,srcCopy);
	ImageClone(m_weight,weiCopy);

	Seam hseam;
	int maxStep = (int)(src.Shape().height * FractionOfEnlarge);
	int r = dst.Shape().height - src.Shape().height;
	for(int i = 0; i < r; i++)
	{
		hseam.clear();
		FindHorizSeam(hseam);
		DeleteOneHorizSeam(hseam);
		seamSet.push_back(hseam);

		if((i > 0) && (i % maxStep == 0))
		{
#ifdef Content_Debug
			stringstream stream;
			stream.clear();
			string st, name;
			stream<<(i/maxStep);
			stream>>st;
			name = "Enlarge" + m_vertOrHoriz + st + ".bmp";
			SaveImageWithSeams(srcCopy,name,seamSet);
#endif
			CFloatImage tmpImg(srcCopy.Shape().width,srcCopy.Shape().height+(int)seamSet.size(),srcCopy.Shape().nBands);
			CShape tmpSh = tmpImg.Shape();
			tmpSh.nBands = 1;
			m_weight.ReAllocate(tmpSh);
			AddHorizonSeams(srcCopy, seamSet, tmpImg);
			AddHorizonSeams(weiCopy,seamSet,m_weight);
			ImageClone(tmpImg,srcCopy);
			ImageClone(m_weight,weiCopy);
			seamSet.clear();
			Initialization(tmpImg);
#ifdef Content_Debug
			name = "EnlargeFor" + m_vertOrHoriz + st + ".bmp";
			SaveFloatImage(srcCopy,name);
#endif
		}
	}

#ifdef Content_Debug
	SaveImageWithSeams(srcCopy,"Enlarge" + m_vertOrHoriz + ".bmp",seamSet);
#endif

	AddHorizonSeams(srcCopy, seamSet, dst);
	CShape dstSh = dst.Shape();
	dstSh.nBands = 1;
	m_weight.ReAllocate(dstSh);
	AddHorizonSeams(weiCopy,seamSet,m_weight);

#ifdef Content_Debug
	SaveFloatImage(dst,"EnlargeFor" + m_vertOrHoriz + ".bmp");
#endif
}

void ContentImResize::AddHorizonSeams(CFloatImage &src, SeamSet &seamSet, CFloatImage &dst)
{
	if(seamSet.empty())
	{
		ImageClone(src,dst);
		return;
	}
	int seamNum = (int)seamSet.size();
	for(int x = 0; x < dst.Shape().width; x++)
	{
		vector<int> labelPoints;
		labelPoints.clear();
		for(int i = 0; i < seamNum; i++)
			labelPoints.push_back(seamSet[i][x].y);
		sort(labelPoints.begin(), labelPoints.end());

		int beginIndex = 0;
		for(int i = 0; i < seamNum; i++)
		{
			int y;
			for(y = beginIndex; y <= labelPoints[i]+i; y++)
				for(int c = 0; c < src.Shape().nBands; c++)
					dst.Pixel(x,y,c) = src.Pixel(x,y-i,c);
			for(int c = 0; c < src.Shape().nBands; c++)
				dst.Pixel(x,y,c) = 0.5f * (src.Pixel(x,y-i-1,c) + src.Pixel(x,y-i,c));
			beginIndex = labelPoints[i] + i + 2;
		}
		for(int y = beginIndex; y < dst.Shape().height; y++)
			for(int c = 0; c < src.Shape().nBands; c++)
				dst.Pixel(x,y,c) = src.Pixel(x,y-seamNum,c);
	}
 }

double ContentImResize::SqDistOfSeams(const Seam& s1, const Seam& s2)
{
	double sqDist = 0;
	int seamLength = (int)s1.size();
	for(int i = 0; i < seamLength; i++)
		sqDist += pow(s1[i].y - s2[i].y, 2);
	
	return sqDist / seamLength;
}

void ContentImResize::PixelClone(CFloatImage &src, CFloatImage &dst, int x, int y )
{
	//make sure src and dst have the same bands
	for(int c = 0; c < src.Shape().nBands; c++)
		dst.Pixel(x,y,c) = src.Pixel(x,y,c);
}

void ContentImResize::DeleteOneHorizSeam(Seam& hseam)
{
	Seam tmpSeam(hseam.size());
	Loop_Image(y,x,m_validSh.height-1,m_validSh.width)
	{
		if(y == hseam[x].y - 1)
		{
			if(m_ernergy.Pixel(x,y+1,0) < 0)
				continue;
			for(int c = 0; c < m_validSh.nBands; c++)
				m_intermImage.Pixel(x,y,c) = 0.5f * (m_intermImage.Pixel(x,y,c) + m_intermImage.Pixel(x,y+1,c));
			m_ernergy.Pixel(x,y,0) = 0.5f * (m_ernergy.Pixel(x,y,0) +m_ernergy.Pixel(x,y+1,0));
		}
		else if(y == hseam[x].y)
		{
			if(m_ernergy.Pixel(x,y,0) < 0)
			{
				for(int c = 0; c < m_validSh.nBands; c++)
					m_intermImage.Pixel(x,y,c) = m_intermImage.Pixel(x,y+1,c);
				m_ernergy.Pixel(x,y,0) = m_ernergy.Pixel(x,y+1,0);
			}
			else
			{
				for(int c = 0; c < m_validSh.nBands; c++)
					m_intermImage.Pixel(x,y,c) = 0.5f * (m_intermImage.Pixel(x,y,c) + m_intermImage.Pixel(x,y+1,c));
				m_ernergy.Pixel(x,y,0) = 0.5f * (m_ernergy.Pixel(x,y,0) +m_ernergy.Pixel(x,y+1,0));
			}

			tmpSeam[x].x = x;
			tmpSeam[x].y = m_shiftHist[y][x];	
			
			m_weight.Pixel(x,y,0) = m_weight.Pixel(x,y+1,0);
			m_shiftHist[y][x] = m_shiftHist[y+1][x];
		}
		else if(y > hseam[x].y)
		{
			for(int c = 0; c < m_validSh.nBands; c++)
				m_intermImage.Pixel(x,y,c) = m_intermImage.Pixel(x,y+1,c);
			m_ernergy.Pixel(x,y,0) = m_ernergy.Pixel(x,y+1,0);
			m_weight.Pixel(x,y,0) = m_weight.Pixel(x,y+1,0);
			m_shiftHist[y][x] = m_shiftHist[y+1][x];
		}
	}
	hseam = tmpSeam;
	m_validSh.height -= 1;
}

float ContentImResize::SafePixel(CFloatImage& image, const CShape& validSh, int x, int y, int c, float backupVal)
{
	if(x < 0 || x > validSh.width - 1 || y < 0 || y > validSh.height - 1 || c < 0 || c > validSh.nBands - 1)
		return image.Pixel(x,y,c);
	else
		return backupVal;
}

void ContentImResize::FindHorizSeam(Seam& hseam)
{
	CumEnMatrix cumEnMap;
	int minIndex = ComputeHoriCumEnMap(cumEnMap);
	
	CShape sh = m_validSh;
	int yPre = minIndex;
	int xPre = sh.width - 1;
	hseam.resize(sh.width);
	for (int i = sh.width - 1; i >= 0; i--)
	{
		hseam[i].x = xPre;
		hseam[i].y = yPre;
		xPre = cumEnMap[i][yPre].xPrevious;
		yPre = cumEnMap[i][yPre].yPrevious;
	}
}

int ContentImResize::ComputeHoriCumEnMap(CumEnMatrix& cumEnMap)
{
	cumEnMap.clear();

	CShape sh = m_validSh;
	CumEnergyElement enElem;
	vector<CumEnergyElement> enVec;

	int minPos = 0;
	float minEn = LargeNum;
	for(int x = 0; x < sh.width; x++)
	{
		enVec.clear();
		for(int y = 0; y < sh.height; y++)
		{
			if(x == 0)
			{
				enElem.cumEnergy = 0;
				enVec.push_back(enElem);
			}
			else
			{
				float leftTop = OutOfImage(x-1,y-1,sh.width,sh.height) ? LargeNum : cumEnMap[x-1][y-1].cumEnergy;
				float left = OutOfImage(x-1,y,sh.width,sh.height) ? LargeNum : cumEnMap[x-1][y].cumEnergy;
				float leftDown = OutOfImage(x-1,y+1,sh.width,sh.height) ? LargeNum : cumEnMap[x-1][y+1].cumEnergy;
				float tmin = minABC(leftTop,left,leftDown);
				enElem.cumEnergy = tmin + m_ernergy.Pixel(x,y,0);
				enElem.xPrevious = x - 1;
				if(isEqual(tmin,left))
				{			
					enElem.yPrevious = y;
				}
				else if (isEqual(tmin,leftTop))
				{
					enElem.yPrevious = y - 1;
				}
				else if (isEqual(tmin, leftDown))
				{
					enElem.yPrevious = y + 1;
				}
				enVec.push_back(enElem);
			}
			if(x == sh.width - 1)
			{
				if(minEn > enElem.cumEnergy)
				{
					minEn = enElem.cumEnergy;
					minPos = y;
				}
			}
		}
		cumEnMap.push_back(enVec);
	}

	return minPos;
}

void ContentImResize::Initialization(CFloatImage& src)
{
	ImageClone(src,m_intermImage);
	m_validSh = m_intermImage.Shape();

	CShape sh = src.Shape();
	CFloatImage gray(sh.width,sh.height,1);
	Convert2GrayFloat(src,gray);
	
	float gxMask[9] = {-1,0,1,-1,0,1,-1,0,1};
	float gyMask[9] = {-1,-1,-1,0,0,0,1,1,1};
	CFloatImage gx(sh.width,sh.height,1), gy(sh.width,sh.height,1);
	MaskProcessing(gray,gx,gxMask,3,3);
	MaskProcessing(gray,gy,gyMask,3,3);
	EnergyGradient(gx,gy);
	SetShiftHistory();
}

void ContentImResize::SetShiftHistory()
{
	m_shiftHist.clear();
	vector<int> row;
	for(int y = 0; y < m_validSh.height; y++)
	{
		row.clear();
		for(int x = 0; x < m_validSh.width; x++)
			row.push_back(y);
		m_shiftHist.push_back(row);
	}
}

void ContentImResize::ImageClone(CFloatImage& src, CFloatImage& dst)
{
	CShape sh = src.Shape();
	dst.ReAllocate(sh);
	Loop_Image(x,y,sh.width,sh.height)
	{
		for(int c = 0; c < sh.nBands; c++)
		{
			dst.Pixel(x,y,c) = src.Pixel(x,y,c);
		}
	}
}

void ContentImResize::ImageTranspose(CFloatImage& src, CFloatImage& dst)
{
	CShape sh = src.Shape();
	int t = sh.width;
	sh.width = sh.height;
	sh.height = t;
	dst.ReAllocate(sh);
	Loop_Image(x,y,sh.width,sh.height)
	{
		for(int c = 0; c < sh.nBands; c++)
			dst.Pixel(x,y,c) = src.Pixel(y,x,c);
	}
}

void ContentImResize::Convert2GrayFloat(CFloatImage& image, CFloatImage& grayFloatImage)
{
	CShape sh = image.Shape();
	Loop_Image(x,y,sh.width,sh.height)	
	{
		if(sh.nBands < 3)
		{
			grayFloatImage.Pixel(x,y,0) = image.Pixel(x,y,0);
		}
		else
		{
			float R, G, B;
			R = image.Pixel(x,y,0);
			G = image.Pixel(x,y,1);
			B = image.Pixel(x,y,2);
			grayFloatImage.Pixel(x,y,0) = 0.2989f * R + 0.5870f * G + 0.1140f * B; 
		}
	}	
}


void ContentImResize::MaskProcessing(CFloatImage& src, CFloatImage& dst, float *mask, int mkW, int mkH)
{
	if(src.Shape().nBands != dst.Shape().nBands)
	{
		cout<<"src and dst are supposed to have the same bands!!"<<endl;
		exit(0);
	}

	CShape sh = src.Shape();
#define mask(x,y) mask[(y) * mkW + (x)]

	int dx = mkW / 2, dy = mkH / 2;
	Loop_Image(x,y,sh.width,sh.height)		
	{
		for(int c = 0; c < sh.nBands; c++)
		{
			float sum = 0.f, sumKer = 0.f;
			for(int m = -dy; m <= dy; m++)
				for(int n = -dx; n <= dx; n++)
				{
					if((x + n < 0) || (x + n > sh.width - 1) || (y + m < 0) || (y + m > sh.height - 1))
					{
						continue;
					}
					sum += src.Pixel(x + n, y + m, c) * mask(n + dx, m + dy);
					sumKer += mask(n + dx, m + dy);
				}
				dst.Pixel(x,y,c) = sum / (isZero(sumKer) ? 1.0f : sumKer);
		}
	}
}

void ContentImResize::EnergyGradient(CFloatImage& Hsrc, CFloatImage& Vsrc)
{
	CShape sh = Hsrc.Shape();
	m_ernergy.ReAllocate(sh);
	Loop_Image(x,y,sh.width,sh.height)
	{
		float t1 = Hsrc.Pixel(x,y,0), t2 = Vsrc.Pixel(x,y,0);
		m_ernergy.Pixel(x,y,0) = abs(t1) + abs(t2) + m_weight.Pixel(x,y,0);
	}
}

void ContentImResize::SaveImageWithSeams(CFloatImage& src, const string& name, const SeamSet& seamSet)
{
	CShape sh = src.Shape();
	CFloatImage image(sh.width, sh.height, 3);

	Loop_Image(x,y,sh.width,sh.height)
	for(int c = 0; c < 3; c++)
	{
		float pixelVal;
		if(sh.nBands < 3)
			pixelVal = src.Pixel(x,y,0);
		else
			pixelVal = src.Pixel(x,y,c);
		image.Pixel(x,y,c) = pixelVal;
	}

	for(SeamSet::const_iterator iter = seamSet.begin(); iter != seamSet.end(); iter++)
	for(Seam::const_iterator seamIt = iter->begin(); seamIt != iter->end(); seamIt++)
	{
		int x = seamIt->x, y = seamIt->y;
		image.Pixel(x,y,0) = 1.0f;
		image.Pixel(x,y,1) = 0.0f;
		image.Pixel(x,y,2) = 0.0f;
	}

	SaveFloatImage(image,name);
}

void ContentImResize::SaveFloatImage(CFloatImage& image, const string& name, bool needNorm /* = false*/)
{
	CByteImage byteImg;
	CFloatImage image2;
	if(m_vertOrHoriz.compare("VertSeams") == 0)
		ImageTranspose(image,image2);
	else
		image2 = image;
	convertToByteImage(image2,byteImg,needNorm);
	writeByteImageToBMP(byteImg,name.c_str());
}

void ContentImResize::NormalizeFloatImage(CFloatImage& image)
{
	float tmin[3] = {LargeNum};
	float tmax[3] = {-LargeNum};
	CShape sh = image.Shape();
	Loop_Image(x,y,sh.width,sh.height)
	{
		for(int c = 0; c < sh.nBands; c++)
		{
			if(tmin[c] > image.Pixel(x,y,c))
				tmin[c] = image.Pixel(x,y,c);
			if (tmax[c] < image.Pixel(x,y,c))
				tmax[c] = image.Pixel(x,y,c);
		}
	}

	Loop_Image(x,y,sh.width,sh.height)
	{
		for(int c = 0; c < sh.nBands; c++)
		{
			image.Pixel(x,y,c) = (image.Pixel(x,y,c) - tmin[c]) / (tmax[c] - tmin[c]);
		}
	}
}

void ContentImResize::convertToByteImage(CFloatImage &floatImage, CByteImage &byteImage, bool needNorm /*= false*/) 
{
	CFloatImage normImg;
	if(needNorm)
	{
		ImageClone(floatImage,normImg);
		NormalizeFloatImage(normImg);
	}
	else
	{
		normImg = floatImage;	//else, share pixel address
	}

	CShape sh = normImg.Shape();
	sh.nBands = 3;
	byteImage.ReAllocate(sh);

	for (int y=0; y<sh.height; y++) {
		for (int x=0; x<sh.width; x++) {
			for (int c=0; c<3; c++) {
				float value;
				if (floatImage.Shape().nBands < 3)
				{
					value = floor(255*normImg.Pixel(x,y,0) + 0.5f);
				}
				else
				{
					value = floor(255*normImg.Pixel(x,y,c) + 0.5f);
				}


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

