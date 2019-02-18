import gab.opencv.*;
import java.awt.*;

class SIPLib
{
  OpenCV opencv;
 
  // List of cog (center of gravity detected)
  ArrayList<PVector> cogs = new ArrayList<PVector>();
  // Current cog
  PVector cog = new PVector(0, 0);
  // Binary image
  PImage imgSegment = new PImage();
  // Current image
  PImage imgCurrent = new PImage();
  // Reference image (background)
  PImage imgReference;
  // Previous image
  PImage imgFramePrev;
  // List of blobs
  ArrayList<Contour> blobs;
  int nFrame = 0;
  int threshold = 40;
  int threshold_H = 50;
  int th_areamin = 100;
  int area_pixel = 0;
  float autoUpdateBkgNoMotionDelay_sec = 15.0;
  float area = 0;
  float area_motion = 0;
  float elapsedUpdate = 0;
  boolean OnUpdate = false;
  private String version = "1.0.02";
  int closingPass = 0;
  int openingPass = 1;
  
  SIPLib(PApplet parent, int w, int h)
  {
    println("SIPLib Sistemi Interattivi Processing Library " + version + " (" + w + "x" + h + "), 2017 by Rudy Melli http://www.vision-e.it/si");
    opencv = new OpenCV(parent, w, h);
    blobs = new ArrayList<Contour>();
  }
  
  void drawInfo(int xtext, int ytext)
  {
    text("Area=" + this.area, xtext, ytext); ytext += 20;
    String szMsg = "Motion=" + this.area_motion;
    if(OnUpdate)
      szMsg += "  (update in " + (int)(autoUpdateBkgNoMotionDelay_sec - (millis() - elapsedUpdate) / 1000.0) + " sec)";
    text(szMsg, xtext, ytext); ytext += 20;
    text("Cog " + this.cog.x + " y =" + this.cog.y, xtext, ytext); ytext += 20;
    ytext += 20;
    text("Threshold=" + this.threshold, xtext, ytext); ytext += 20;
  }
  
  void newFrameEvent(PImage imgFrame, int thSeg, int thSeg_H, int thAreaMin)
  {
    ++nFrame;
    this.threshold = thSeg;
    this.threshold_H = thSeg_H;
    this.th_areamin = thAreaMin;
    imgCurrent = imgFrame.copy();
  }
  
  float singleDifference(PImage imgFrame, int thSeg, int thAreaMin)
  {
    newFrameEvent(imgFrame, thSeg, thSeg, thAreaMin);
    if(imgFramePrev != null)
    {
      // Store frame into opencv class
      opencv.loadImage(imgFrame);
      // Difference with Previous frame
      opencv.diff(imgFramePrev);
      area_motion = analize(thSeg, thAreaMin, true);
    }
    imgFramePrev = imgFrame.copy();
    return area;
  }
    
  float shadowSegmentation(PImage imgFrame, int thSeg, int thAreaMin)
  {
    newFrameEvent(imgFrame, thSeg, thSeg, thAreaMin);
    // Store frame into opencv class
    opencv.loadImage(imgFrame);
    // The Shadow is black, invert the image to have it in white
    opencv.invert();
    analize(thSeg, thAreaMin, true);
    
    return area;
  }

  float lightSegmentation(PImage imgFrame, int thSeg, int thAreaMin)
  {
    newFrameEvent(imgFrame, thSeg, thSeg, thAreaMin);
    // Store frame into opencv class
    opencv.loadImage(imgFrame);
    analize(thSeg, thAreaMin, true);
    
    return area;
  }

  
  float colorSegmentation(PImage imgFrame, int thSegMin, int thSegMax, int thAreaMin)
  {
    newFrameEvent(imgFrame, thSegMin, thSegMax, thAreaMin);
    // Tell OpenCV to use color information
    //opencv.useColor();
    opencv.useColor(HSB);
    // Store frame into opencv class
    opencv.loadImage(imgFrame);
    // Get only Hue channel
    opencv.setGray(opencv.getH().clone());

    analize(thSegMin, thSegMax, thAreaMin, true);
    
    return area;    
  }

  float colorSegmentationPixel(PImage imgFrame, color colTrack, float th_color, int thAreaMin)
  {
    newFrameEvent(imgFrame, (int)th_color, (int)th_color, thAreaMin);
    PImage imgCol = ExtractColor(imgFrame, colTrack, th_color);
    // Store frame into opencv class
    opencv.loadImage(imgCol);
    analize(128, thAreaMin, true);
    
    return area;    
  }
    
  void storeBackground()
  {
    // Background storing
    imgReference = imgCurrent.copy();
    OnUpdate = false;
    elapsedUpdate = 0;
    println("Background updated");
  }
  
  float backgroundSuppression(PImage imgFrame, int thSeg, int thAreaMin)
  {
    return backgroundSuppression(imgFrame, thSeg, thAreaMin, false, 0, 0);
  }
  float backgroundSuppression(PImage imgFrame, int thSeg, int thAreaMin, 
    boolean bSmartBackground, int sd_thSeg, int sd_thAreaMin)
  {
    newFrameEvent(imgFrame, thSeg, thSeg, thAreaMin);
    if(imgReference != null)
    {
      opencv.loadImage(imgCurrent);
      opencv.diff(imgReference);
      analize(thSeg, thAreaMin, true);
    }
    else
      storeBackground();
    if(bSmartBackground)
    {
      // Analyzing single difference to get area motion score, if score is low (no motion) for at least 15 sec, background is updated
      if(imgFramePrev != null && (nFrame % 3 == 0))
      {
        opencv.loadImage(imgCurrent);
        opencv.diff(imgFramePrev);
        area_motion = analize(sd_thSeg, sd_thAreaMin, false);
        if(area_motion < 0.001)
        {
          if(!OnUpdate)
          {
            OnUpdate = true;
            elapsedUpdate = millis();
          }
          else if(millis() - elapsedUpdate > (int)(autoUpdateBkgNoMotionDelay_sec * 1000))
          {
            storeBackground();
            OnUpdate = false;
          }
        }
        else
        {
          OnUpdate = false;
        }
      }
      imgFramePrev = imgCurrent.copy();
    }
    else
      area_motion = area;
    return area;
  }
  
  
  float analize(int thSeg, int thAreaMin, boolean bStoreData)
  {
    opencv.threshold(thSeg);
    return analize(thAreaMin, bStoreData);
  }
    
  float analize(int thSegMin, int thSegMax, int thAreaMin, boolean bStoreData)
  {
    opencv.inRange(thSegMin, thSegMax);
    return analize(thAreaMin, bStoreData);
  }
    
  float analize(int thAreaMin, boolean bStoreData)
  {
    for(int i=0; i<openingPass; i++)
      opencv.erode();
      //opencv.erode();
      //opencv.dilate();
    for(int i=0; i<openingPass; i++)
      opencv.dilate();

    for(int i=0; i<closingPass; i++)
      opencv.dilate();
    for(int i=0; i<closingPass; i++)
      opencv.erode();

    
    if(bStoreData)
      imgSegment = opencv.getSnapshot();
    
    ArrayList<Contour> contours;
    contours = opencv.findContours();
    
    if(bStoreData)
      blobs.clear();
    
    float areatot = 0;
    float TX = 0, TY = 0;
    int nCog = 0;
    for (int i=0; i<contours.size(); i++)
    {
      Contour contour = contours.get(i);
      Rectangle r = contour.getBoundingBox();
      if (r.width < 20 || r.height < 20)
        continue;
      float a = contour.area();
      if(a >  thAreaMin)
      {
        blobs.add(contour);
      }
      if(a > areatot)
      {
        areatot += a;
        // Coordinate dell'oggetto i-esimo
        float iTX = (float)r.getCenterX();
        float iTY = (float)r.getCenterY();
        TX += iTX;
        TY += iTY;
        ++nCog;
      }
    }
    float area_perc = (float)areatot / (float)(opencv.width * opencv.height);
    if(bStoreData)
    {
      if(areatot >  thAreaMin)
      {
        float TrackX = TX / (float)nCog;
        float TrackY = TY / (float)nCog;
        cogs.add(new PVector(TrackX, TrackY)); //<>//
        if(cogs.size() > 5)
        {
          cogs.remove(0);
        }
        if(cogs.size() > 0)
        {
          cog.x = cog.y = 0;
          for(int i=0; i<cogs.size(); ++i)
          {
            cog.x += cogs.get(i).x;
            cog.y += cogs.get(i).y;
          }
          cog.x /= (float)cogs.size();
          cog.y /= (float)cogs.size();
        }
      }
      area_pixel = (int)areatot;
      area = area_perc;
    }
    return area_perc;
  }
  
  PImage ExtractColor(PImage imgIn, color trackingColor, float th_color)
  {
    PImage img = imgIn.copy();
    float r2 = trackingColor >> 16 & 0xFF;//red(trackingColor);
    float g2 = trackingColor >> 8 & 0xFF;//green(trackingColor);
    float b2 = trackingColor & 0xFF;//blue(trackingColor);
    
    int iscale = 1;
    img.loadPixels();
    // Begin loop to walk through every pixel
    for (int y = 0; y < img.height; y+=iscale )
    {
      for (int x = 0; x < img.width; x+=iscale )
      {
        int loc = x + y*img.width;
        // What is current color
        color currentColor = img.pixels[loc];
        float r1 = currentColor >> 16 & 0xFF;//red(currentColor); slow //c >> 16 & 0xFF;  // Very fast to calculate
        float g1 = currentColor >> 8 & 0xFF;//green(currentColor);
        float b1 = currentColor & 0xFF;//blue(currentColor);
  
        // Using euclidean distance to compare colors
        float d = dist(r1,g1,b1,r2,g2,b2); // We are using the dist( ) function to compare the current color with the color we are tracking.
  
        // If current color is more similar to tracked color than
        // closest color, save current location and current difference
        if(d < th_color)
          img.pixels[loc] = 0xffffff;
        else
          img.pixels[loc] = 0;
      }
    }
    
    img.updatePixels();
    return img; 
  }
  
  float GetRectMotion(Rectangle rc)
  {
    float area_motion_rc = 0;
    if(imgSegment != null)
    {
      PImage imgRc = imgSegment.get(rc.x, rc.y, rc.width, rc.height);
      imgRc.loadPixels();
      // Begin loop to walk through every pixel
      int area_rc = 0;
      for (int y = 0; y < imgRc.height; y+=1 )
      {
        for (int x = 0; x < imgRc.width; x+=1 )
        {
          int loc = x + y*imgRc.width;
          if(imgRc.pixels[loc] > 0)
            ++area_rc;
        }
      }
      area_motion_rc = (float)area_rc / (imgRc.width * imgRc.height);
    }
    return area_motion_rc;
  }
  
  color GetIndexColor(int i)
  {
        color ci = color((16 * (i + 1) << i) % 255, (32 * (i + 1) << i) % 255, (8 * (i + 1) << i) % 255);
        return ci;
  }
}