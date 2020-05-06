import processing.video.*;

Capture cam;

void setup()
{
  size(1280, 480);
  String[] camlist = Capture.list();
  printArray(camlist);
  cam = new Capture(this, camlist[5]);
  cam.start();
}

void draw()
{
  if(cam.available())
  {
    cam.read();
    float th = map(mouseY, 0, height, 0, 1);
    PImage img_th = cam.copy();
    img_th.filter(THRESHOLD, th);
    image(cam, 0, 0, width/2, height);
    image(img_th, width/2, 0, width/2, height);
    fill(255, 0, 0);
    text(th * 255, 10, 10);
    text(th, 10, 30);
  }
}
