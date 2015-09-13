#include <FL/Fl.H>
#include <FL/Fl_Window.H>
#include <FL/Fl_Menu_Bar.H>
#include <Fl/Fl_Menu_Item.H>
#include <FL/Fl_File_Chooser.H>
#include <FL/fl_ask.H>
#include "ImageView.h"
#include "PROJECT1Doc.h"
#include "PROJECT1UI.h"

// Create and initialize the UI.
PROJECT1UI::PROJECT1UI() {
	// Create the main window.
	mainWindow = new Fl_Window(600, 300, "Project 1");
	mainWindow->user_data((void *)this);

	// Create the menu bar.
	menuBar = new Fl_Menu_Bar(0, 0, 600, 25);
	menuBar->menu(menuItems);

	// Create the subwindows for viewing the query and result images.
	queryView = new ImageView(0, 25, 600, 275, "query view");
	queryView->box(FL_DOWN_FRAME);

	resultView = new ImageView(300, 25, 0, 275, "result view");
	resultView->box(FL_DOWN_FRAME);

	// Tell resultView not to take any events.
	resultView->set_output();

	mainWindow->end();
}

// Begin displaying the UI windows.
void PROJECT1UI::show() {
	mainWindow->show();
	queryView->show();
	resultView->show();
}

// Refresh the window.
void PROJECT1UI::refresh() {
	mainWindow->redraw();
	queryView->redraw();
	resultView->redraw();
}

// Resize the query and result image windows.
void PROJECT1UI::resize_windows(int w1, int w2, int h) {
	mainWindow->resize(mainWindow->x(), mainWindow->y(), w1+w2, h+25);
	menuBar->resize(menuBar->x(), menuBar->y(), w1+w2, 25);
	queryView->resize(queryView->x(), queryView->y(), w1, h);
	resultView->resize(queryView->x()+w1, queryView->y(), w2, h);
}

// Set the document pointer.
void PROJECT1UI::set_document(PROJECT1Doc *doc) {
	this->doc = doc;
}

// Set the query and result image pointers.
void PROJECT1UI::set_images(Fl_Image *queryImage, Fl_Image *resultImage) {
	queryView->setImage(queryImage);
	resultView->setImage(resultImage);
}

// Identify the UI from a menu item.
PROJECT1UI* PROJECT1UI::who_am_i(Fl_Menu_ *o) {
	return (PROJECT1UI *)(o->parent()->user_data());
}

// Called when the user chooses the "Load Query Image" menu item.
void PROJECT1UI::cb_load_query_image(Fl_Menu_ *o, void *v) {
	PROJECT1Doc *doc = who_am_i(o)->doc;

	char *name = fl_file_chooser("Open File", "*.bmp|*.p[gp]m", NULL);

	if (name != NULL) {
		doc->load_query_image(name);
	}
}

// Called when the user chooses the "Exit" menu item.
void PROJECT1UI::cb_exit(Fl_Menu_ *o, void *v) {
	who_am_i(o)->mainWindow->hide();
}

// Called when the user chooses the "Run Algorithm" menu item.
// In this project, same as choose Step 4
void PROJECT1UI::cb_perform_edge_detection(Fl_Menu_ *o, void *v) {
	who_am_i(o)->doc->set_algorithm_step(4);
	who_am_i(o)->doc->perform_edge_detection();
}

// Called when the user selects "Step 1: Pre-smooth".
void PROJECT1UI::cb_algorithm_step_1(Fl_Menu_ *o, void *v) {
	who_am_i(o)->doc->set_algorithm_step(1);
	who_am_i(o)->doc->perform_edge_detection();
}

// Called when the user selects "Step 2: Gradient Magnitude".
void PROJECT1UI::cb_algorithm_step_2(Fl_Menu_ *o, void *v) {
	who_am_i(o)->doc->set_algorithm_step(2);
	who_am_i(o)->doc->perform_edge_detection();
}

// Called when the user selects "Step 3: Non-Maximum Suppression".
void PROJECT1UI::cb_algorithm_step_3(Fl_Menu_ *o, void *v) {
	who_am_i(o)->doc->set_algorithm_step(3);
	who_am_i(o)->doc->perform_edge_detection();
}

// Called when the user selects "Step 4: Hysteresis Thresholding".
void PROJECT1UI::cb_algorithm_step_4(Fl_Menu_ *o, void *v) {
	who_am_i(o)->doc->set_algorithm_step(4);
	who_am_i(o)->doc->perform_edge_detection();
}

// Called when the user clicks the "About" menu item.
void PROJECT1UI::cb_about(Fl_Menu_ *o, void *v) {
	fl_message("Project 1: Edge Detection");
}

// Once again, you can add any extra menu items you like.
Fl_Menu_Item PROJECT1UI::menuItems[] = {
	{"&File", 0, 0, 0, FL_SUBMENU},
		{"&Load Image", 0, (Fl_Callback *)PROJECT1UI::cb_load_query_image},
		{"&Exit", 0, (Fl_Callback *)PROJECT1UI::cb_exit},
		{0},
	{"&Options", 0, 0, 0, FL_SUBMENU},
		{"&Select Step", 0, 0, 0, FL_SUBMENU},
			{"&Pre-Smooth", 0, (Fl_Callback *)PROJECT1UI::cb_algorithm_step_1},
			{"&Gradient Magnitude", 0, (Fl_Callback *)PROJECT1UI::cb_algorithm_step_2},
			{"&Non-Maximum Suppression", 0, (Fl_Callback *)PROJECT1UI::cb_algorithm_step_3},
			{"&Hysteresis Thresholding", 0, (Fl_Callback *)PROJECT1UI::cb_algorithm_step_4},
			{0},
		{"&Run Algorithm", 0, (Fl_Callback *)PROJECT1UI::cb_perform_edge_detection},
		{0},
	{"&Help", 0, 0, 0, FL_SUBMENU},
		{"&About", 0, (Fl_Callback *)PROJECT1UI::cb_about},
		{0},
	{0}
};