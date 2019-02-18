PImage immagine;

void setup()
{
  size(400, 300);
  immagine = loadImage("C:\\Users\\melli\\Pictures\\Immagine.png");
}

void draw()
{
  background(#FF3351);
  int h=0;
  while(h<10)
  {
    image(immagine, 50 * h, 25 * h, width/4, height/4);
    h = h + 1;
  }
  
  // Codice ripetitivo
  //image(immagine, 0, 0, width/4, height/4);
  //image(immagine, 100, 50, width/4, height/4);
  //image(immagine, 200, 100, width/4, height/4);
  //image(immagine, 200, 0, width/4, height/4);
  //image(immagine, 100, 100, width/4, height/4);
  //image(immagine, 0, 100, width/4, height/4);
  
}