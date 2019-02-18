/**
* Mix videos
*
* by OlivierL.
*
* Play two video files in parallel.
* Mix the two stream by adjusting transparency
* of each image. The transparecny depends on the
* horizontal position of the mouse
*
*/
 
import processing.video.*;

Movie myLeftMovie, myRightMovie;
float ratioLeft, ratioRight;
int InMouseX;

void setup() {
 size(640, 480, P3D);
 background(0);
 // Load and play the videos in a loop
 myLeftMovie = new Movie(this, "..\\..\\..\\..\\..\\media\\A111_04.DoppioVeloce_ds.mov");
 myRightMovie = new Movie(this, "..\\..\\..\\..\\..\\media\\Micro-dance.mov");
 myLeftMovie.loop();
 myRightMovie.loop();
}

void movieEvent(Movie m) {
 // just continue to play each frame of each video
 m.read();
}

void draw() { 
 
 // The 'left' video is totally transparent if mouse is on the right
 ratioLeft = (255 * (width - mouseX)) / width;
 tint(255, int(ratioLeft)); // set transparency
 image(myLeftMovie, 0, 0);
 
 // The 'right' video is totally transparent if mouse is on the left
 ratioRight = (255 * mouseX) / width;
 tint(255, int(ratioRight)); // set transparency
 image(myRightMovie, 0, 0);
 
 // display some values in the console, for checking, can be removed
 println("mx " + mouseX + " rl " + ratioLeft + " rr " + ratioRight);
 
}