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
  int area_pixel = 0;
  float area = 0;
  float area_motion = 0;
  float elapsedUpdate = 0;
  boolean OnUpdate = false;
  private String version = "0.0.1"; 
  
  SIPLib(PApplet parent, int w, int h)
  {
    println("SIPLib Sistemi Interattivi Processing Library " + version + ", 2017 by Rudy Melli http://www.vision-e.it/si");
    opencv = new OpenCV(parent, w, h);
  }
  
  void drawInfo(int xtext, int ytext)
  {
    text("Area=" + this.area, xtext, ytext); ytext += 20;
    text("Motion=" + this.area_motion, xtext, ytext); ytext += 20;
    text("Cog " + this.cog.x + " y =" + this.cog.y, xtext, ytext); ytext += 20;
    ytext += 20;
    text("Threshold=" + threshold, xtext, ytext); ytext += 20;
  }
  
  float singleDifference(PImage imgFrame, int thSeg, int thAreaMin)
  {
    ++nFrame;
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
    ++nFrame;
    // Store frame into opencv class
    opencv.loadImage(imgFrame);
    // The Shadow is black, invert the image to have it in white
    opencv.invert();
    analize(thSeg, thAreaMin, true);
    
    return area;
  }
  
  float colorSegmentation(PImage imgFrame, int thSegMin, int thSegMax, int thAreaMin)
  {
    ++nFrame;
    // Tell OpenCV to use color information
    opencv.useColor();
    //if(opencv.colorSpace != HSB)
      opencv.useColor(HSB);
    // Store frame into opencv class
    opencv.loadImage(imgFrame);
    // Get only Hue channel
    opencv.setGray(opencv.getH().clone());

    analize(thSegMin, thSegMax, thAreaMin, true);
    
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
    ++nFrame;
    imgCurrent = imgFrame.copy();
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
          else if(millis() - elapsedUpdate > 15000)
          {
            storeBackground();
            OnUpdate = false;
          }
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
    opencv.erode();
    //opencv.erode();
    //opencv.dilate();
    opencv.dilate();
    
    if(bStoreData)
      imgSegment = opencv.getSnapshot();
    
    ArrayList<Contour> contours;
    contours = opencv.findContours();
    
    if(bStoreData)
      blobs = contours;
    
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
        cogs.add(new PVector(TrackX, TrackY)); //<>// //<>//
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
}