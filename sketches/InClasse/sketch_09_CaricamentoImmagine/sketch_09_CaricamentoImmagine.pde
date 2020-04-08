// Dichiarazione variabile che conterrà l'immagine
PImage img;

void setup()
{
  // Dimensione finestra di rendering
  size(640, 480);
  // Caricamento dell'immagine web nella variabile "img"
  img = loadImage("http://processing.org/img/processing-web.png");
}

void draw()
{
  // Visualizzazione dell'immagine contenuta nella variabile img a schermo
  image(img, 0, 0);
  println("Dimensioni immagine: " + img.width + "x" + img.height);
}
