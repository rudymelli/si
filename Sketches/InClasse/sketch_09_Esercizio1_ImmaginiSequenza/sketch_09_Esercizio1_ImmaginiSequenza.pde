PImage img1, img2, img3;
int contatore = 0;
void setup()
{
  size(640, 480);
  img1 = loadImage("margherita.jpg");
  img2 = loadImage("narcisi.jpg");
  img3 = loadImage("rosa.jpg");
  frameRate(3);
}
void draw()
{
  if(contatore == 0)
    image(img1, 0, 0, width, height);
  else if(contatore == 1)
    image(img2, 0, 0, width, height);
  else
    image(img3, 0, 0, width, height);
  contatore = contatore + 1;
  if(contatore >= 3)
    contatore = 0;
}
