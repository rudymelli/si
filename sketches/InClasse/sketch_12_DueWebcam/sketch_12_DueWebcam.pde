/**
 * Getting Started with Capture.
 * 
 * Reading and displaying an image from an attached Capture device. 
 */

import processing.video.*;

Capture cam;
Capture cam2;

void setup() {
  size(1000, 400);

  String[] cameras = Capture.list();
  
  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    cam = new Capture(this, 640, 480);
  } if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    printArray(cameras);
    
    // NB: Specificare i numeri (es cameras[19]) in relazione alle webcam installate sul vostro PC

    // The camera can be initialized directly using an element
    // from the array returned by list():
    cam = new Capture(this, cameras[19]);
    // Or, the settings can be defined based on the text in the list
    //cam = new Capture(this, 640, 480, "Logitech QuickCam Pro 5000", 30);
    
    // Start capturing the images from the camera
    cam.start();
    
    cam2 = new Capture(this, cameras[105]);
    cam2.start();
  }
}

void captureEvent(Capture c) {
  c.read();
}


void draw() {
  //if (cam.available() == true) {
  //  cam.read();
  //}
  image(cam, 0, 0, width/2, height);
  image(cam2, width/2, 0, width/2, height);
  
  // The following does the same as the above image() line, but 
  // is faster when just drawing the image without any additional 
  // resizing, transformations, or tint.
  //set(0, 0, cam);
}
