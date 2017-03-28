import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

int barWidth = 20;
int lastBar = -1;
int TrackX = 0, TrackY = 0;
PImage previousFrame, imgSegment;
int nFrame = 0, nFramePrev = 0;

void setup() {
  size(640, 480);
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);

  video.start();
}


void draw() {
  //scale(2); 
  
  elabFrame();
  
  // Visualizzazione
  image(video, 0, 0 );
  //noFill();
  noStroke();
  //strokeWeight(3);
  
  // Draw a large, yellow circle at the brightest pixel
  fill(255, 204, 0, 128);
  ellipse(TrackX/2, TrackY, 50, 50);
  println("x=" + TrackX + " y =" + TrackY);
}

void captureEvent(Capture c) {
  if(nFrame > 0)
    previousFrame = c.copy();
  c.read();
  nFrame++;
}

void elabFrame()
{
  if(nFrame > 1 && nFrame > nFramePrev)
  {
    nFramePrev = nFrame;
    opencv.loadImage(video);
    
    opencv.diff(previousFrame);
    //opencv.gray();
    opencv.threshold(40);
    
    opencv.erode();
    opencv.erode();
    opencv.dilate();
    opencv.dilate();
    
    imgSegment = opencv.getSnapshot();
    
    ArrayList<Contour> contours;
    contours = opencv.findContours();
    
    float areamax = 0;
    int TX = 0, TY = 0, nCog = 0;
    for (int i=0; i<contours.size(); i++)
    {
      Contour contour = contours.get(i);
      Rectangle r = contour.getBoundingBox();
      if (r.width < 20 || r.height < 20)
        continue;
      float a = contour.area();
      if(a > areamax)
      {
        areamax = a;
        // Coordinate dell'oggetto i-esimo
        int iTX = (int)r.getCenterX();
        int iTY = (int)r.getCenterY();
        //cogs_x.append(TX);
        //cogs_x.append(TY);
        TX += iTX;
        TY += iTY;
        ++nCog;
      }
    }
    if(areamax >  50)
    {
      TrackX = TX * 2 / nCog;
      TrackY = TY / nCog;
/*      TrackX = TrackY = 0;
      for (int i=0; i<cogs_x.size(); i++)
      {
        TrackX += cogs_x.get(i);
        TrackY += cogs_y.get(i);
      }
      TrackX /= cogs_x.size();
      TrackY /= cogs_x.size();
      */
    }
    image(imgSegment, 320, 0);
  }

}