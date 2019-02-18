PImage img;

void setup()
{
  size(500, 500);
  img=loadImage("traffic.jpg");
}

void draw()
{
  int w2 = width;
  // aspect ratio = w/h  --> w2:w=h2:h --> h2=w2*h/w 
  int h2 = w2 * img.height / img.width;
  int x2 = (width - w2) / 2;
  int y2 = (height - h2) / 2;
  image(img, x2, y2, w2, h2);
}