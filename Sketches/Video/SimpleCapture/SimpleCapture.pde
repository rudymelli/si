import processing.video.*;

Capture cam;

void setup() {
  size(640, 480);
  printArray(Capture.list());
  cam = new Capture(this, 640, 480);
  // Or, the settings can be defined based on the text in the list
  //cam = new Capture(this, 640, 480, "Built-in iSight", 30);
  // Start capturing the images from the camera
  cam.start();
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  image(cam, 0, 0, width, height);
  // The following does the same as the above image() line, but 
  // is faster when just drawing the image without any additional 
  // resizing, transformations, or tint.
  //set(0, 0, cam);
}