/**
 * Loop. 
 * 
 * Shows how to load and play a QuickTime movie file.  
 *
 */

import processing.video.*;

Movie movie;

void setup() {
  size(640, 360);
  background(0);
  // Load and play the video in a loop
  movie = new Movie(this, "transit.mov");
  movie.loop();
}

void movieEvent(Movie m) {
  m.read();
}

void draw() {
  int ncol = 12;
  int nrow = 7;
  for(int i=0; i < ncol * nrow; i = i + 1)
  {
    int w = width / ncol;
    int h = height / nrow;
    int x = (i % ncol) * w;
    int y = (i / ncol) * h;
    image(movie, x, y, w, h);
  }
  //image(movie, 0, 0,              width/2, height/2);
  //image(movie, width/2, 0,        width/2, height/2);
  //image(movie, 0, height/2,       width/2, height/2);
  //image(movie, width/2, height/2, width/2, height/2);
  
  if(mouseX == pmouseX && mouseY == pmouseY)
    movie.pause();
  else
    movie.play();
}