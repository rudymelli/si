// Definizione dell'array PImage per caricare le immagini 
int nimages = 100;
// Creo un array di immagini du nome "images"
PImage []images = new PImage[nimages];

String imagepath = "../../../media/seq100/";
String image_extension = ".jpg";

void setup()
{
  // Impostazione della dimensione della finestra
  size(640,480);
  frameRate(30);
  
  // Caricamento delle immagini
  for(int i = 0; i < nimages; ++i)
  {
    images[i] = loadImage(imagepath + (i+1) + image_extension);
  }
}

void draw()
{
  int index = frameCount % nimages;
  // Visualizzare l'immagine corrispondente a index
  image(images[index],0,0,width,height);
}
