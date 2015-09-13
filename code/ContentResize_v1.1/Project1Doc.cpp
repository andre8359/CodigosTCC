#include <Fl/Fl.H>
#include <Fl/Fl_Shared_Image.H>
#include <FL/fl_ask.H>
#include "edgedetection.h"
#include "PROJECT1UI.h"
#include "PROJECT1Doc.h"

// Create a new document.
PROJECT1Doc::PROJECT1Doc() {
	queryImage = NULL;
	resultImage = NULL;
	ui = NULL;
	step = 4;
}

// Load an image file for use as the query image.
void PROJECT1Doc::load_query_image(const char *name) {
	ui->set_images(NULL, NULL);

	// Delete the current query image.
	if (queryImage != NULL) {
		queryImage->release();
		queryImage = NULL;
	}

	// Delete the current result image.
	if (resultImage != NULL) {
		resultImage->release();
		resultImage = NULL;
	}

	// Load the image.
	queryImage = Fl_Shared_Image::get(name);

	if (queryImage == NULL) {
		fl_alert("couldn't load image file");
	}
	else {
		// Update the UI.
		ui->resize_windows(queryImage->w(), 0, queryImage->h());
		ui->set_images(queryImage, NULL);
	}

	ui->refresh();
}

// Perform edge detection 
void PROJECT1Doc::perform_edge_detection() {
	ui->set_images(queryImage, NULL);
	
	if (queryImage == NULL) {
		fl_alert("no image loaded");
	}
	else {
			
		CFloatImage srcimg, dstimg;
		
		// Convert the image to the CImage format.
		if (!convertImage(queryImage, srcimg)) {
			printf("couldn't convert image to RGB format\n");
			return;
		}
		// Perform Edge Detection
		performEdgeDetection(srcimg,dstimg,step);

		// Convert CImage back to FL_Image
		CByteImage udstimg;
		convertToByteImage(dstimg, udstimg);
		writeByteImageToBMP(udstimg,"project1_tmp.bmp");
		// Load the image.
		
		if (resultImage != NULL) {
			resultImage->release();
			resultImage = NULL;
		}
		resultImage = Fl_Shared_Image::get("project1_tmp.bmp");
		system("del project1_tmp.bmp");
		if (resultImage == NULL) {
			fl_alert("couldn't load result image");
		}
		else {
			// Update the UI.
			if (queryImage->h() > resultImage->h()) {
				ui->resize_windows(queryImage->w(), resultImage->w(), queryImage->h());
			}
			else {
				ui->resize_windows(queryImage->w(), resultImage->w(), resultImage->h());
			}
		}		
		ui->set_images(queryImage, resultImage);
	}

	ui->refresh();	
}

// Set the UI pointer.
void PROJECT1Doc::set_ui(PROJECT1UI *ui) {
	this->ui = ui;
}

// Set the match algorithm.
void PROJECT1Doc::set_algorithm_step(int step) {
	this->step = step;
}