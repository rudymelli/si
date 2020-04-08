// Rudy Melli - Corso di Sistemi Interattivi, Brera
// Esempio di disegno a mano libera
// Tenere premuto il pulsante del mouse per disegnare
// Premendo spazio cambia colore
// Premendo +/- si cambia dimensione del pennello

color colpen = color(255, 0, 0);
PGraphics tavola;
int raggio = 10;

void setup()
{
  size(640, 480);
  tavola = createGraphics(640, 480);
  background(255);
  frameRate(100);
}

void draw()
{
  if(mousePressed)
  {
    // Per disegnare su oggetto PGraphics
    // devo sempre iniziare con beginDraw e finire con endDraw
    tavola.beginDraw();
    tavola.fill(colpen);
    tavola.stroke(colpen);
    tavola.ellipse(mouseX, mouseY, raggio, raggio); 
    tavola.endDraw();
  }
  image(tavola, 0, 0);
  fill(colpen);
  stroke(colpen);
  ellipse(raggio / 2 + 5, raggio / 2 + 5, raggio, raggio);
}

void keyPressed()
{
  if(key == ' ')
    colpen = color(random(255), random(255), random(255));
  else if(key == 'e' || key == 'E')
  {
    tavola.beginDraw();
    tavola.background(255);
    tavola.endDraw();
  }
  else if(key == '+' && raggio < 20)
    ++raggio;
  else if(key == '-' && raggio > 1)
    --raggio;
}