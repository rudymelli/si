// Definizione delle 3 variabili PImage per caricare le 3 immagini 
PImage img1;
PImage img2;
PImage img3;

String imagepath = "../../../media/seq3/";

void setup()
{
  // Impostazione della dimensione della finestra
  size(640,480);
  frameRate(3);
  
  // Caricamento delle 3 immagini
  img1 = loadImage(imagepath + "1.png");
  img2 = loadImage(imagepath + "2.png");
  img3 = loadImage(imagepath + "3.png");
}

void draw()
{
  int index = frameCount % 3;
  // Visualizzare l'immagine corrispondente a index
  if(index == 0)
  {
    image(img1,0,0);
  }
  else if (index == 1)
  {
    image(img2,0,0);
  }
  else
  {
    image(img3,0,0);
  }
}
