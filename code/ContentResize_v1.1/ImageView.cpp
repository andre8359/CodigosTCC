#include <FL/Fl.H>
#include <FL/Fl_Image.H>
#include <FL/fl_draw.h>
#include "ImageView.h"
#include <vector>
using namespace std;

// Create a new ImageView object.
ImageView::ImageView(int x, int y, int w, int h, const char *l) : Fl_Double_Window(x,y,w,h,l) {
	image = NULL;
	features = NULL;
	// This call is necessary to prevent any additional UI widgets
	// from becoming subcomponents of this window.
	end();
}

// Draw the image and features.
void ImageView::draw() {
	if (image != NULL) {
		image->draw(0, 0);
	}	
}

// Refresh the window.
void ImageView::refresh() {
	redraw();
}


// Set the pointer to the image.
void ImageView::setImage(Fl_Image *image) {
	this->image = image;
}



