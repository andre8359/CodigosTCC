#ifndef PROJECT1UI_H
#define PROJECT1UI_H

class Fl_Window;
class Fl_Menu_;
class Fl_Menu_Bar;
class ImageView;
class FeatureSet;
class PROJECT1Doc;

// The PROJECT1UI class controls the UI.  Feel free to play around with
// the UI if you'd like.
class PROJECT1UI {
public:
	PROJECT1Doc *doc;

	Fl_Window *mainWindow;
	Fl_Menu_Bar *menuBar;

	ImageView *queryView;
	ImageView *resultView;

public:
	// Create the UI.
	PROJECT1UI();

	// Begin displaying the UI.
	void show();

	// Refresh the window.
	void refresh();

	// Resize the image windows.
	void resize_windows(int w1, int w2, int h);

	// Set the document pointer.
	void set_document(PROJECT1Doc *doc);

	// Set the pointers to the two images.
	void set_images(Fl_Image *queryImage, Fl_Image *resultImage);	

private:
	// Return the UI, given a menu item.
	static PROJECT1UI *who_am_i(Fl_Menu_ *o);

	// Here are the callback functions.
	static void cb_load_query_image(Fl_Menu_ *o, void *v);
	static void cb_exit(Fl_Menu_ *o, void *v);
	static void cb_perform_edge_detection(Fl_Menu_ *o, void *v);
	static void cb_algorithm_step_1(Fl_Menu_ *o, void *v);
	static void cb_algorithm_step_2(Fl_Menu_ *o, void *v);
	static void cb_algorithm_step_3(Fl_Menu_ *o, void *v);
	static void cb_algorithm_step_4(Fl_Menu_ *o, void *v);
	static void cb_about(Fl_Menu_ *o, void *v);

	// Here is the array of menu items.
	static Fl_Menu_Item menuItems[];
};

#endif