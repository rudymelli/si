import processing.video.*;
PImage img;
Capture cam;

void setup() {
  size(640, 480);
  //String[] cameras = Capture.list();
  //printArray(cameras);    
  cam = new Capture(this, "name=Logitech QuickCam Fusion,size=640x480,fps=30");
  cam.start();
  img = new PImage(640, 480);
}

void draw() 
{
  if(cam.available())
  {
    img = cam.copy();
    cam.read();
  }
  float soglia = (float)mouseY / height;
  image(cam, 0, 0);
  blend(img, 0, 0, width, height, 0, 0, width, height, DIFFERENCE);
  filter(THRESHOLD, soglia);
  fill(0,255,0);
  text(soglia, 20, 20);
}