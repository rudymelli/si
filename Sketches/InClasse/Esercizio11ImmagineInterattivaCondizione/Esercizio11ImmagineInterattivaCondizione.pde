PImage immagine;

void setup()
{
  size(300, 200);
  immagine = loadImage("C:\\Users\\melli\\Pictures\\Immagine.png");
}

void draw()
{
  background(#FF3351);
  for(int i=0; i<5; i=i+1)
  {
    image(immagine, 50 * i, 25 * i, width/4, height/4);
  }
  
  // Codice ripetitivo
  //image(immagine, 0, 0, width/4, height/4);
  //image(immagine, 100, 50, width/4, height/4);
  //image(immagine, 200, 100, width/4, height/4);
  //image(immagine, 200, 0, width/4, height/4);
  //image(immagine, 100, 100, width/4, height/4);
  //image(immagine, 0, 100, width/4, height/4);
  
}