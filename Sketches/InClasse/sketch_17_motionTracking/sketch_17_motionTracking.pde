import processing.video.*;

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
  
  //size (600, 200);
  smooth();

  background (0);
  frameRate (30);  
}


void draw() {
  image(video, 0, 0, width, height);
  fill(255, 0, 0);
  //if(siplib.area_motion > 0.01)
  {
    ellipse(siplib.cog.x, siplib.cog.y, 50, 50);
    text(siplib.area_motion, 30, 30);
    PImage img = video;
    loadPixels();
    img.loadPixels();
    for (int x = 0; x < img.width; x++) {
      for (int y = 0; y < img.height; y++ ) {
        // Calculate the 1D location from a 2D grid
        int loc = x + y*img.width;
        // Get the R,G,B values from image
        float r,g,b;
        r = red (img.pixels[loc]);
        //g = green (img.pixels[loc]);
        //b = blue (img.pixels[loc]);
        // Calculate an amount to change brightness based on proximity to the mouse
        float maxdist = 200;//dist(0,0,width,height);
        float d = dist(x, y, siplib.cog.x, siplib.cog.y);
        float adjustbrightness = 255*(maxdist-d)/maxdist;
        r += adjustbrightness;
        //g += adjustbrightness;
        //b += adjustbrightness;
        // Constrain RGB to make sure they are within 0-255 color range
        r = constrain(r, 0, 255);
        //g = constrain(g, 0, 255);
        //b = constrain(b, 0, 255);
        // Make a new color and set pixel in the window
        //color c = color(r, g, b);
        color c = color(r);
        pixels[y*width + x] = c;
      }
    }
    updatePixels();
  }
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
