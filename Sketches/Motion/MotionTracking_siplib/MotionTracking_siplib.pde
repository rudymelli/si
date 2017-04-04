Capture video;
SIPLib siplib;

int TrackX = 0, TrackY = 0;
int threshold = 40;

void setup()
{
  size(640, 480);
  video = new Capture(this, 640/2, 480/2);
  siplib = new SIPLib(this, 640/2, 480/2);

  video.start();
  
  //size (600, 200);
  smooth();

  background (0);
  frameRate (30);  
}


void draw() {
  // Visualizzazione
  image(video, 0, 0, width, height);
  
  TrackX = (int)siplib.cog.x * 2;
  TrackY = (int)siplib.cog.y * 2;
  if(siplib.cogs.size() > 0)
    image(siplib.imgSegment, 320, 0);

  fill(128);
  textSize(18);
  siplib.drawInfo(20, 20);

  // Draw a large, yellow circle at the brightest pixel
  fill(255, 204, 0, 128);
  ellipse(TrackX, TrackY, 50, 50);

  noStroke();
}

void captureEvent(Capture c) {
  c.read();
  //siplib.singleDifference(c, threshold, 50);
  //siplib.backgroundSuppression(c, threshold, 50, true, 40, 50);
  siplib.shadowSegmentation(c, threshold, 50);
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
  siplib.storeBackground();
}

void mousePressed ()
{
  if (mouseButton == LEFT)
  {
  }
}