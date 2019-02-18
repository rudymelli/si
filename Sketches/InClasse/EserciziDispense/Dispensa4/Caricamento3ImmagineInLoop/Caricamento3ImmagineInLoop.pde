PImage img;
PImage img2;
PImage img3;

void setup()
{
  size(900, 500);
  img=loadImage("traffic.jpg");
  img2=loadImage("dancer.JPG");
  img3=loadImage("fractal.jpg");
  frameRate(3);
}

void draw()
{
  int indice = frameCount % 3;
  if(indice == 0)
    image(img, 0, 0, width, height);
  else if(indice == 1)
    image(img2, 0, 0, width, height);
  else
    image(img3, 0, 0, width, height);
}