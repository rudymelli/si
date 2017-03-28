import gab.opencv.*;
import processing.video.*;

Movie video;
OpenCV opencv;

void setup() {
  size(720, 480);
  video = new Movie(this, "street.mov");
  opencv = new OpenCV(this, 720, 480);
  
  opencv.startBackgroundSubtraction(5, 3, 0.5);
  
  video.loop();
  video.play();
}

void draw() {
  image(video, 0, 0);  
  opencv.loadImage(video);
  
  opencv.updateBackground();
  
  opencv.dilate();
  opencv.erode();

  noFill();
  stroke(255, 0, 0);
  strokeWeight(3);
  int  i=0;
  for (Contour contour : opencv.findContours()) {
    stroke((i  * 10) % 128 + 128, (255 - i * 10) % 255, (i * 10) % 255);
    ++i;
    contour.draw();
  }
}

void movieEvent(Movie m) {
  m.read();
}