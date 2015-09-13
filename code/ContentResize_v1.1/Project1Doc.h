#ifndef PROJECT1DOC_H
#define PROJECT1DOC_H

class Fl_Shared_Image;
class PROJECT1UI;

// The PROJECT1Doc class controls the functionality of the project, and
// has methods for all major operations, like loading image and performing edge detection..
class PROJECT1Doc {
private:
	Fl_Shared_Image *queryImage;
	Fl_Shared_Image *resultImage;
	int step;

public:
	PROJECT1UI *ui;

public:
	// Create a new document.
	PROJECT1Doc();

	// Destroy the document.
	~PROJECT1Doc();

	// Load an image, feature set, or database.
	void load_query_image(const char *name);
	
	// Perform edge detection.
	void perform_edge_detection();

	// Set the pointer to the UI.
	void set_ui(PROJECT1UI *ui);

	// Set the match algorithm.
	void set_algorithm_step(int step);
};

#endif