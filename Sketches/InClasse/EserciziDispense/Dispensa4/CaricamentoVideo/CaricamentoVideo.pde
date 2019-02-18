import processing.video.*;
Movie filmato;

void setup()
{
  size(500, 500);
  filmato=new Movie(this, "Micro-dance.avi");
  filmato.loop();
}

void draw()
{
  if(filmato.available())
  {
    filmato.read();
  }
  PImage img = filmato;
  int w2 = width;
  int h2 = height;
  // aspect ratio = w/h  --> w2:w=h2:h 
  if(1.0*width/height <= 1.0*img.width/img.height)
  {
    // --> h2=w2*h/w 
    h2 = w2 * img.height / img.width;
  }
  else
  {
    // --> w2=h2*w/h 
    w2 = h2 * img.width / img.height;
  }
  int x2 = (width - w2) / 2;
  int y2 = (height - h2) / 2;
  image(img, x2, y2, w2, h2);
  println(x2 + ";" + y2 + "  " + w2+ "x" + h2);
}