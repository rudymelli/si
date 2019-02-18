import processing.video.*;
PImage img_sfondo;
Capture cam;
int ncapture = 0;

void setup() {
  size(640, 480);
  //String[] cameras = Capture.list();
  //printArray(cameras);    
  cam = new Capture(this, "name=Logitech QuickCam Fusion,size=640x480,fps=30");
  cam.start();
  img_sfondo = new PImage(width, height);
}

void draw() 
{
  if(cam.available())
  {
    cam.read();
    if(ncapture == 0)
      img_sfondo = cam.copy();
    ncapture = ncapture + 1;
  }
  
  float soglia = (float)mouseY / height;
  image(cam, 0, 0);
  blend(img_sfondo, 0, 0, width, height, 0, 0, width, height, DIFFERENCE);
  filter(THRESHOLD, soglia);
  image(cam, width * 2/3, 0, width/3, height/3);
  image(img_sfondo, 0, 0, width/3, height/3);
  fill(0,255,0);
  text("Soglia: " + soglia, 20, 20);
}

void keyPressed()
{
  if(key == ' ')
  {
    ncapture = 0;
  }
}