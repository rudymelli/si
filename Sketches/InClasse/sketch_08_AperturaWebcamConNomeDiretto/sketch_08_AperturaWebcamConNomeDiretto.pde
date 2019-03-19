import processing.video.*;
Capture webcam;
void setup()
{
  //size(640, 480);
  String []webcamlist = Capture.list();
  printArray(webcamlist);
  webcam = new Capture(this, "name=Integrated Webcam,size=1280x720,fps=10");
  webcam.start();
  frameRate(1);
  fullScreen();
}
void draw()
{
  if(webcam.available() == true)
  {
    webcam.read();
    image(webcam, 0, 0, width, height);
  }
}
