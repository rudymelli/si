import processing.video.*;

Movie movie;
PFont font; 

void setup() {
  size(640, 360);
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

void draw() 
{
  PImage img = movie.copy();  
  textFont(font,30);
  float param1 = map(mouseX, 0, width, 1, 10);
  img.filter(BLUR, (int)param1);
  image(img, 0, 0, width-1, height);
  fill(255);
  text(param1,5,25);
}
