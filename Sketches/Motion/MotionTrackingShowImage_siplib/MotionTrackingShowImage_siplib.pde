import processing.video.*;

Capture video;
SIPLib siplib;

int TrackX = 0, TrackY = 0;
int threshold = 40;

PImage img;
color colTrack;

void setup()
{
  String[] cameras = Capture.list();
  printArray(cameras);
  size(640, 480);
  video = new Capture(this, 640, 480);
  siplib = new SIPLib(this, 640, 480);

  video.start();
  
  img = loadImage("traffic.jpg");
  
  //size (600, 200);
  smooth();

  background (0);
  frameRate (30);  
}


// SegmentationMode:  
//                    0=ShadowSegmentation
//                    1=SingleDifference
//                    2=BackgroundSuppression
//                    3=ColorSegmentation
int SegmentationMode = 4;

void draw() 
{
  // Visualizzazione
  background(0);
  image(video, 0, 0);

  // Get mouse Color
  if(SegmentationMode >= 3)
  {
    if(mousePressed)
    {
      //colTrack = Color.HSBtoRGB((float)mouseX / width,1,1);
      colTrack = video.get(mouseX * video.width / width, mouseY * video.height / height);
      println("col=" + colTrack + " hue=" + hue(colTrack));
    }
    fill(colTrack);
    rect(0, height-50, 50, 50);
  }
  
  TrackX = (int)siplib.cog.x;
  TrackY = (int)siplib.cog.y;
  //if(siplib.cogs.size() > 0)
    image(siplib.imgSegment, 0, 0, siplib.imgSegment.width/2, siplib.imgSegment.height/2);

  fill(128);
  textSize(18);
  siplib.drawInfo(20, 20);
  
  if(siplib.cog.x > width/2)
    image(img, width/2, height/2, width, height);


  // Draw a large, yellow circle at the brightest pixel
  fill(255, 204, 0, 128);
  ellipse(TrackX, TrackY, 50, 50);

  //noStroke();
}

void captureEvent(Capture c)
{
  c.read();
  if(SegmentationMode == 0)
    siplib.shadowSegmentation(c, threshold, 50);
  else if(SegmentationMode == 1)
    siplib.singleDifference(c, threshold, 50);
  else if(SegmentationMode == 2)
    siplib.backgroundSuppression(c, threshold, 50, true, 40, 50);
  else if(SegmentationMode == 3)
    siplib.colorSegmentation(c, (int)hue(colTrack) - threshold/2, (int)hue(colTrack) + threshold/2, 50);
  else if(SegmentationMode == 4)
    siplib.colorSegmentationPixel(c, colTrack, threshold, 50);
}

void keyPressed ()
{
  if(key == '+')
    threshold += 10;
  else if(key == '-')
    threshold -= 10;
  else if(key == 'p')
    threshold += 1;
  else if(key == 'o')
    threshold -= 1;
  else if(key == ' ' && SegmentationMode == 2)
    siplib.storeBackground();
  if(threshold < 0)
    threshold = 0;
  if(threshold > 255)
    threshold = 255;
}

void mousePressed ()
{
  if (mouseButton == LEFT)
  {
  }
}