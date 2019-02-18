PImage immagine;

void setup()
{
  size(300, 200);
  immagine = loadImage("C:\\Users\\melli\\Pictures\\Immagine.png");
}

void draw()
{
  background(#FF3351);
  image(immagine, 0, 0, width/2, height/2);
  image(immagine, mouseX, mouseY, width/4, height/4);
}