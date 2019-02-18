class si_pilib
{
  ArrayList<PVector> cogs = new ArrayList<PVector>();
  PVector cog = new PVector(0, 0);
  PImage imgSegment = new PImage();
  PImage imgCurrent = new PImage();
  PImage imgReference;
  PImage imgFramePrev;
  ArrayList<Contour> blobs;
  int nFrame = 0;
  int area_pixel = 0;
  float area = 0;
  float area_motion = 0;
  OpenCV opencv;
  float elapsedUpdate = 0;
  boolean OnUpdate = false;
  
  si_pilib(OpenCV ocv)
  {
    opencv = ocv; 
  }
  
  float singleDifference(PImage imgFrame, int thSeg, int thAreaMin)
  {
    ++nFrame;
    if(imgReference != null)
    {
      opencv.loadImage(imgFrame);
      opencv.diff(imgReference);
      area_motion = analize(thSeg, thAreaMin, true);
    }
    imgReference = imgFrame.copy();
    return area;
  }
  
  void storeBackground()
  {
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
      if(imgFramePrev != null && (nFrame % 3 == 0))
      {
        opencv.loadImage(imgCurrent);
        opencv.diff(imgFramePrev);
        area_motion = analize(sd_thSeg, sd_thAreaMin, false);
        if(area_motion < 0.01)
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
    //opencv.gray();
    opencv.threshold(thSeg);
    
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
        //cogs_x.append(TX);
        //cogs_x.append(TY);
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
}