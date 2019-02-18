int numero_immagini = 20;
PImage img[] = new PImage[numero_immagini];

void setup()
{
  size(900, 500);
  for(int i=0; i<numero_immagini; i=i+1)
  {
    img[i] = loadImage(i + ".jpg");
  }
  frameRate(3);
}

void draw()
{
  int indice = frameCount % numero_immagini;
  image(img[indice], 0, 0, width, height);
}