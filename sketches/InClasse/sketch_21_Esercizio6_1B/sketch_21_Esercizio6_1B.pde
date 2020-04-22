import processing.video.*;

Movie movie;
PFont font; 
float fps = 30;

void setup() 
{
  size(640, 360);
  background(0);
  movie = new Movie(this, "../../../../media/transit.mov");
  movie.loop();
  frameRate(fps);
  smooth();
  font = createFont("Arial Bold",48);
}

void movieEvent(Movie m) 
{
  m.read();
}

void draw() 
{
  float fps_prec = fps;
  fps = map(mouseX, 0, width, 1, 100);
  if(fps != fps_prec)
  {
    frameRate(fps);
  }
  textFont(font,30);
  image(movie, 0, 0, width, height);
  fill(255);
  text((int)round(frameRate),5,25);
}
