import processing.video.*;

Movie movie;
PFont font; 

void setup() {
  //size(640, 360);
  //fullScreen();
  fullScreen(P3D);
  background(0);
  movie = new Movie(this, "../../../../media/transit.mov");
  movie.loop();
  frameRate(60);
  smooth();
  font = createFont("Arial Bold",48);
}

void movieEvent(Movie m) {
  m.read();
}

void draw() {
  textFont(font,30);
  image(movie, 0, 0, width, height);
  fill(255);
  text((int)round(frameRate),5,25);
}
