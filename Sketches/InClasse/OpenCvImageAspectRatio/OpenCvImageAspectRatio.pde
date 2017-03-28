import gab.opencv.*;

OpenCV opencv;

void settings() {
  opencv = new OpenCV(this, "test.jpg");
  //size(opencv.width, opencv.height);
  fullScreen(2);
}

void setup()
{
  frameRate(100);
}

/*
  w      wi            wi                      hi
  --  =  --  ==> w = ( -- ) * h ==> h = w * (  -- )
  h      hi            hi                      wi
*/

void draw() {
  background(0);
  int wi = opencv.width;
  int hi = opencv.height;
  float ar = (float)wi / hi; // ==> (float) w / h
  int w = wi;
  int h = (int)(w / ar);
  image(opencv.getOutput(), 0, (height - h)/2, w, h);
  
  text(frameRate, 20, 20);
}