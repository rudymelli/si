import processing.video.*;
ArrayList<PImage> imglist = new ArrayList<PImage>();
Capture cam;

void setup() {
  size(640, 480);
  //String[] cameras = Capture.list();
  //printArray(cameras);    
  cam = new Capture(this, "name=Logitech QuickCam Fusion,size=640x480,fps=30");
  cam.start();
}

void draw() 
{
  if(cam.available())
  {
    imglist.add(cam.copy());
    cam.read();
  }
  
  float nframe = 30 * mouseX / width + 1;
  if(imglist.size() >= nframe)
  {
    float soglia = (float)mouseY / height;
    image(cam, 0, 0);
    blend(imglist.get(0), 0, 0, width, height, 0, 0, width, height, DIFFERENCE);
    filter(THRESHOLD, soglia);
    fill(0,255,0);
    text("Soglia: " + soglia, 20, 20);
    text("Distanza frame: " + nframe, 20, 50);
    while(imglist.size() >= nframe)
      imglist.remove(0);
  }
}