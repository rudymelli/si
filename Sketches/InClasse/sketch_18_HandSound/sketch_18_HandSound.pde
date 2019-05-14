import processing.sound.*;
import processing.video.*;

SoundFile soundfile;

Capture video;
SIPLib siplib;

int TrackX = 0, TrackY = 0;
int threshold = 40;
int countdown = 0;

void setup()
{
  String[] cameras = Capture.list();
  printArray(cameras);
  size(640, 480);
  video = new Capture(this, 640, 480);//640/2, 480/2);
  siplib = new SIPLib(this, 640, 480);

  video.start();
  
  // Load a soundfile
  soundfile = new SoundFile(this, "vibraphon.aiff");
  // Play the file in a loop
  soundfile.loop();

  
  //size (600, 200);
  smooth();

  background (0);
  frameRate (30);  
}


void draw() {
  
  // Map mouseX from 0.25 to 4.0 for playback rate. 1 equals original playback speed,
  // 2 is twice the speed and will sound an octave higher, 0.5 is half the speed and
  // will make the file sound one ocative lower.
  float playbackSpeed = map(siplib.cog.x, 0, width, 0.25, 4.0);
  soundfile.rate(playbackSpeed);

  // Map mouseY from 0.2 to 1.0 for amplitude
  float amplitude = map(siplib.cog.y, 0, width, 0.2, 1.0);
  soundfile.amp(amplitude);

  // Map mouseY from -1.0 to 1.0 for left to right panning
  float panning = map(siplib.cog.y, 0, height, -1.0, 1.0);
  soundfile.pan(panning);
  
  image(video, 0, 0, width, height);
  // Draw a large, yellow circle at the brightest pixel
  fill(255, 204, 0, 128);
  ellipse(siplib.cog.x, siplib.cog.y, 50, 50);
}

void captureEvent(Capture c) {
  c.read();
  siplib.singleDifference(c, threshold, 50);
  //siplib.backgroundSuppression(c, threshold, 50, true, 40, 50);
  //siplib.shadowSegmentation(c, threshold, 50);
  //siplib.lightSegmentation(c, threshold, 50);
  //siplib.colorSegmentationPixel(c,threshold,,);
}

void keyPressed ()
{
  if(key == '+')
    threshold += 10;
  if(key == '-')
    threshold -= 10;
  if(key == 'w')
    threshold += 1;
  if(key == 'q')
    threshold -= 1;
  if(threshold < 0)
    threshold = 0;
  if(threshold > 255)
    threshold = 255;
  if(key == ' ')
    siplib.storeBackground();
  countdown = 30;
}

void mousePressed ()
{
  if (mouseButton == LEFT)
  {
  }
}
