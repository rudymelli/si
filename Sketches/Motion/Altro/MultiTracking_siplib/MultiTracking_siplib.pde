import processing.video.*;

//Capture video;
Movie movie;
SIPLib siplib;

int TrackX = 0, TrackY = 0;
int threshold = 40;

PImage img;
PImage imgCurrentFrame;
color colTrack;

void setup()
{
  size(720, 576);
  
  // Camera
  //String[] cameras = Capture.list();
  //printArray(cameras);
  //video = new Movie(this, 640, 480);
  //video.start();
  
  // Video
  movie = new Movie(this, "../../../../../media/A111_06.Gruppo5EntrataSeparata_ds.mov");
  movie.loop();
  
  siplib = new SIPLib(this, 360, 288);
  siplib.closingPass = 2;

  
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
//                    3=BackgroundSuppression manuale
//                    4=ColorSegmentation
int SegmentationMode = 3;

void draw() 
{
  // Visualizzazione
  background(0);
  if(imgCurrentFrame != null)
    image(imgCurrentFrame, 0, 0);

  // Get mouse Color
  if(SegmentationMode >= 3)
  {
    if(mousePressed)
    {
      //colTrack = Color.HSBtoRGB((float)mouseX / width,1,1);
      colTrack = imgCurrentFrame.get(mouseX * imgCurrentFrame.width / width, mouseY * imgCurrentFrame.height / height);
      println("col=" + colTrack + " hue=" + hue(colTrack));
    }
    fill(colTrack);
    rect(0, height-50, 50, 50);
  }
  
  TrackX = (int)siplib.cog.x;
  TrackY = (int)siplib.cog.y;
  //if(siplib.cogs.size() > 0)
    image(siplib.imgSegment, siplib.imgSegment.width, 0, siplib.imgSegment.width, siplib.imgSegment.height);

  fill(128);
  textSize(18);
  siplib.drawInfo(20, 20);
  
  if(siplib.cog.x > width/2)
    image(img, width/2, height/2, width, height);

  // Tracking Singolo
  // Draw a large, yellow circle at the brightest pixel
  //fill(255, 204, 0, 128);
  //ellipse(TrackX, TrackY, 50, 50);
  
  // Tracking multiplo
  for(int i=0; i<siplib.blobs.size(); i++)
  {
    noFill();
    color ci = siplib.GetIndexColor(i);
    stroke(ci);
    Contour contour = siplib.blobs.get(i);
    Rectangle r = contour.getBoundingBox();
    rect(r.x, r.y, r.width, r.height);
    text(i, r.x, r.y - 1);

    // Disegno un cerchio ai piedi del blob
    fill(ci);
    ellipse(r.x + r.width/2, r.y + r.height, 5, 5);
}

  //noStroke();
}

void movieEvent(Movie m) {
  m.read();
  Elabora(m);
}

void captureEvent(Capture c)
{
  c.read();
  Elabora(c);
}

void Elabora(PImage img)
{
  imgCurrentFrame = img.copy();
  int minsize = 100;
  if(SegmentationMode == 0)
    siplib.shadowSegmentation(img, threshold, minsize);
  else if(SegmentationMode == 1)
    siplib.singleDifference(img, threshold, minsize);
  else if(SegmentationMode == 2)
    siplib.backgroundSuppression(img, threshold, minsize, true, 40, minsize);
  else if(SegmentationMode == 3)
    siplib.backgroundSuppression(img, threshold, minsize, false, 40, minsize);
  else if(SegmentationMode == 4)
    siplib.colorSegmentationPixel(img, colTrack, threshold, minsize);
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
  else if(key == ' ' && (SegmentationMode == 2 || SegmentationMode == 20))
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