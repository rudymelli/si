import processing.video.*;
PImage img;
Capture cam;

void setup() {
  size(640, 480);
  String[] cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    cam = new Capture(this, 640, 480);
  }
  else
  {
    println("Available cameras:");
    printArray(cameras);    
    cam = new Capture(this, cameras[17]);
  }
  cam.start();
}

void draw() 
{
  if(cam.available())
    cam.read();
  float soglia = (float)mouseY / height;
  image(cam, 0, 0);
  filter(THRESHOLD, soglia);
  fill(0,255,0);
  text(soglia, 20, 20);
}