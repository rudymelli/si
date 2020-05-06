import processing.video.*;
Capture cam;
PImage img_sfondo;

void setup()
{
  size(1280, 960);
  String[] camlist = Capture.list();
  printArray(camlist);
  cam = new Capture(this, camlist[5]);
  cam.start();
  try
  {
    img_sfondo = loadImage("sfondo.jpg");
  }
  catch(Exception e)
  {
  }
}

void draw()
{
  if(cam.available())
  {
    cam.read();
    float th = map(mouseY, 0, height, 0, 1);
    PImage img_corrente = cam.copy();
    if(img_sfondo == null)
    {
      img_sfondo = img_corrente.copy();
    }
    
    PImage img_differenza = img_corrente.copy();
    img_differenza.blend(img_sfondo, 0, 0, cam.width, cam.height, 0, 0, cam.width, cam.height, DIFFERENCE);

    PImage img_th = img_differenza.copy();
    img_th.filter(THRESHOLD, th);
    image(img_sfondo, 0, 0, width/2, height/2);           // alto  sx
    image(img_corrente, width/2, 0, width/2, height/2);   // alto  dx
    image(img_differenza, 0, height/2, width/2, height/2);// basso sx
    image(img_th, width/2, height/2, width/2, height/2);  // basso dx
    fill(255, 0, 0);
    text(th * 255, 10, 10);
    text(th, 10, 30);
  }
}

void keyPressed()
{
  img_sfondo = cam.copy();
  img_sfondo.save("sfondo.jpg");
}
