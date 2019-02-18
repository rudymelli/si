import processing.video.*;
Movie m;
void setup()
{
  //fullScreen();
  size(352, 288);
  m = new Movie(this, "..\\..\\..\\..\\..\\media\\Micro-dance.avi");
  m.loop();
}

void draw()
{
  if(m.available())
    m.read();
  if(m.width > 0)
  {
    // Per poter fare il resize di un video in tempo reale è necessario copiarlo
    // prima in un'immagine
    PImage img = m.copy();
    float th = map(mouseX, 0, width, 0, 1);
    if(th > 0)
      img.filter(THRESHOLD, th);
    float scale = map(mouseY, 0, height, 1, 10);
    scale = max(1, scale);
    img.resize(int(img.width * scale), int(img.height * scale));
    image(img, 0, 0, width, height);
    fill(255, 0, 0);
    textSize(20);
    text(img.width + "x" + img.height + "  fps=" + frameRate, 50, 50);
  }
}