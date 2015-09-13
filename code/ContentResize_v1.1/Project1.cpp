#include <fstream>
#include <FL/Fl.H>
#include <FL/Fl_Shared_Image.H>
#include "EdgeDetection.h"
#include "PROJECT1UI.h"
#include "PROJECT1Doc.h"
#include "ContentImResize.h"
#include <iostream>
#include <fstream>

PROJECT1UI *ui;
PROJECT1Doc *doc;

void SetCAIR(ContentImResize& cair)
{
	ifstream infile("config.ini");
	if(!infile)
	{
		cout<<"Cannot open config.ini, so use default parameters."<<endl;
		return;
	}

	double p1, p2;
	int p3;
	string name;
	infile>>name>>p1;
	infile>>name>>p2;
	infile>>name>>p3;
	cair.SetParameters(p1,p2,p3);

	infile.close();
	infile.clear();
}

int mainEdgeDetection(int argc, char **argv) {
	if ((argc!=4) && (argc!=5) && (argc !=6)) {
		printf("usage: %s inputfile outputfile width height \n", argv[0]);
		printf("usage: %s inputfile outputfile size width height \n", argv[0]);
		printf("usage: %s inputfile outputfile ratio width_ratio height_ratio \n", argv[0]);
		printf("usage: %s inputImage maskImage outputfile [width] [height]");
		return -1;
	}

	ContentImResize contImResize;
	SetCAIR(contImResize);

	//Load the query image.
	Fl_Shared_Image *queryImage = Fl_Shared_Image::get(argv[1]);

	if (queryImage == NULL) {
		printf("couldn't load query image\n");
		return -1;
	}

	CFloatImage srcimg, dstimg;
	// Convert the image to the CImage format.
	if (!convertImage(queryImage, srcimg)) {
		printf("couldn't convert image to RGB format\n");
		return -1;
	}


	CShape sh = srcimg.Shape();
	int height, width;

	string option1(argv[1]), option2(argv[2]), option3(argv[3]);
	if((option1.find(".bmp")!=option1.npos) && (option2.find(".bmp")!=option2.npos) && (option3.find(".bmp")!=option3.npos))
	{
		CFloatImage maskimg;

		Fl_Shared_Image *query = Fl_Shared_Image::get(argv[2]);
		if (query == NULL) {
			printf("couldn't load mask image\n");
			return -1;
		}

		// Convert the image to the CImage format.
		if (!convertImage(query, maskimg)) {
			printf("couldn't convert mask image to RGB format\n");
			return -1;
		}
		
		if(argc == 4)
			dstimg.ReAllocate(sh);
		else
		{
			width = atoi(argv[4]);
			height = atoi(argv[5]);
			sh.width = width;
			sh.height = height;
			dstimg.ReAllocate(sh);
		}
		
		contImResize.ContentAwareImResize(srcimg,maskimg,dstimg);

		CByteImage udstimg;
		convertToByteImage(dstimg, udstimg);
		//WriteFile(udstimg,argv[2]);
		writeByteImageToBMP(udstimg,argv[3]);

		return 0;
	}

	if(argc == 5)
	{
		width = atoi(argv[3]);
		height = atoi(argv[4]);
	}
	else
	{
		string option(argv[3]);
		if(option.compare("size") == 0)
		{
			width = atoi(argv[4]);
			height = atoi(argv[5]);
		}
		else if(option.compare("ratio") == 0)
		{
			width = (int)(sh.height * atof(argv[4]));
			height = (int)(sh.width * atof(argv[5]));
		}
		else
		{
			printf("usage: %s inputfile outputfile width height \n", argv[0]);
			printf("usage: %s inputfile outputfile size width height \n", argv[0]);
			printf("usage: %s inputfile outputfile ratio width_ratio height_ratio \n", argv[0]);
			return -1;
		}
	}

	sh.height = height;
	sh.width = width;
	dstimg.ReAllocate(sh);

	contImResize.ContentAwareImResize(srcimg,dstimg);

	CByteImage udstimg;
	convertToByteImage(dstimg, udstimg);
	//WriteFile(udstimg,argv[2]);
	writeByteImageToBMP(udstimg,argv[2]);

	return 0;
}


int main(int argc, char **argv) {
	// This lets us load various image formats.
	fl_register_images();

	if (argc > 1) {
		mainEdgeDetection(argc, argv);	
	}
/*	else {
		// Use the GUI.
		doc = new PROJECT1Doc();
		ui = new PROJECT1UI();
		ui->set_document(doc);
		doc->set_ui(ui);
		Fl::visual(FL_DOUBLE|FL_INDEX);
		ui->show();
		return Fl::run();
	}*/
}