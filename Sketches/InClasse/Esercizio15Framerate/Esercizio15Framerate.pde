import processing.video.*;

Movie filmato;

boolean ApplyFilter = false;

void setup()
{
  fullScreen();
  //size(300, 400);
  filmato = new Movie(this, "E:\\media\\Micro-dance.avi");
  filmato.loop();
  frameRate(200);
}

void draw()
{
  if(filmato.available()) // Leggo il frame successivo
    filmato.read();
  if(ApplyFilter)
    filmato.filter(BLUR, 7);
  image(filmato, 0, 0, width, height); // Visualizzo il filmato
  fill(0, 0, 255);  // Modifico il colore del testo
  textSize(20);     // Modifico la dimensione del testo
  text(frameRate, 20, 20); // Scrivo il test a video
}

void keyPressed()
{
  if(key == ' ')
    ApplyFilter = !ApplyFilter;
}