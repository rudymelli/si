import processing.video.*;

Capture cam;
Capture cam2;

void setup() {
  size(640, 480);
  String[] cameras = Capture.list();
  printArray(cameras);
  cam = new Capture(this, 640, 480, cameras[0]);
  cam2 = new Capture(this, 640, 480, cameras[1]);
  // Or, the settings can be defined based on the text in the list
  //cam = new Capture(this, 640, 480, "Built-in iSight", 30);
  // Start capturing the images from the camera
  cam.start();
  cam2.start();
}

void draw() {
  if (cam.available()) {
    cam.read();
  }
  if (cam2.available()) {
    cam2.read();
  }
  image(cam, 0, 0, width/2, height/2);
  image(cam2, width/2, 0, width/2, height/2);
  // The following does the same as the above image() line, but 
  // is faster when just drawing the image without any additional 
  // resizing, transformations, or tint.
  //set(0, 0, cam);
}