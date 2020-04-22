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
  font = createFont("Arial Bold",48);
  noSmooth();
}

void movieEvent(Movie m) 
{
  m.read();
}

void draw() 
{
  background(0);
  PImage img = movie.copy();
  // Modificare la dimensione dell'immagine
  float scala = map(mouseY, 0, height-1, 10, 1);
  int new_width = (int)(img.width / scala);
  int new_height = (int)(img.height / scala);
  img.resize(new_width, new_height);
  image(img, 0, 0, width, height);
  
  textFont(font, width / 20);
  fill(255);
  text(img.width + "x" + img.height, 10, 30);
}
