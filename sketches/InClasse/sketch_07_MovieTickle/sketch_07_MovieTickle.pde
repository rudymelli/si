/**
 * Loop. 
 * 
 * Shows how to load and play a QuickTime movie file.  
 *
 */

import processing.video.*;

Movie movie;
float x, y; // X and Y coordinates of text

void setup() {
  size(640, 360);
  background(0);
  // Load and play the video in a loop
  movie = new Movie(this, "transit.mov");
  movie.loop();
  
  x = width / 2;
  y = height / 2;
}

void movieEvent(Movie m) {
  m.read();
}

void draw() {
  background(0);
  //if (movie.available() == true) {
  //  movie.read(); 
  //}
  // If the cursor is over the text, change the position
  if (abs(mouseX - x) < 100 &&
      abs(mouseY - y) < 60) {
    x += random(-5, 5);
    y += random(-5, 5);
  }  
  image(movie, x, y, 100, 60);
}
