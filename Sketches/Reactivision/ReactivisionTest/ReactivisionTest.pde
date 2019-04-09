/*
 TUIO 1.1 Console for Processing
 Copyright (c) 2005-2014 Martin Kaltenbrunner <martin@tuio.org>

 Permission is hereby granted, free of charge, to any person obtaining
 a copy of this software and associated documentation files
 (the "Software"), to deal in the Software without restriction,
 including without limitation the rights to use, copy, modify, merge,
 publish, distribute, sublicense, and/or sell copies of the Software,
 and to permit persons to whom the Software is furnished to do so,
 subject to the following conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
 ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

// import the TUIO library
import TUIO.*;
// declare a TuioProcessing client
TuioProcessing tuioClient;

int countMarkers = 0;

//PImage []imgs = new PImage[2];
PImage img0, img1;

void setup()
{
  // minimize GUI
  size(640, 480);
  
  // we create an instance of the TuioProcessing client
  // since we add "this" class as an argument the TuioProcessing class expects
  // an implementation of the TUIO callback methods in this class (see below)
  tuioClient = new TuioProcessing(this);
  
  //for(int i=0; i<2; i = i + 1)
  //{
  //  imgs[i] = loadImage(i + ".jpg");
  //}
  img0 = loadImage("0.jpg");
  img1 = loadImage("1.jpg");
  
}

void draw()
{
  background(255);
  
  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
  for (int i=0;i<tuioObjectList.size();i++) 
  {
     TuioObject tobj = tuioObjectList.get(i);
     int objID = tobj.getSymbolID();
     float objX = tobj.getX();
     float objY = tobj.getY();
     float objRot = tobj.getAngleDegrees();
     int objXScreen = tobj.getScreenX(width);
     int objYScreen = tobj.getScreenY(height);
     println("ID=" + objID + " x;y=" + objX + ";" + objY + " Rot=" + objRot + "°", objXScreen, objYScreen);
     
     // Your code start here
     //for(int j=0; j<2; j = j+1)
     //{
     //  if(objID == j)
     //    image(imgs[j], 0, 0);
     //}
     if(objID == 0)
       image(img0, 0, 0);
     else if(objID == 1)
       image(img1, 0, 0);
   }
   
   fill(255, 0, 0);
   text(countMarkers, 20, 20);
}

// --------------------------------------------------------------
// these callback methods are called whenever a TUIO event occurs
// there are three callbacks for add/set/del events for each object/cursor/blob type
// the final refresh callback marks the end of each TUIO frame

// called when an object is added to the scene
void addTuioObject(TuioObject tobj) {
  countMarkers = countMarkers + 1;
  println("add obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle());
}

// called when an object is moved
void updateTuioObject (TuioObject tobj) {
  println("set obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle()
          +" "+tobj.getMotionSpeed()+" "+tobj.getRotationSpeed()+" "+tobj.getMotionAccel()+" "+tobj.getRotationAccel());
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
  countMarkers = countMarkers - 1;
  println("del obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+")");
}


// --------------------------------------------------------------
// called at the end of each TUIO frame
void refresh(TuioTime frameTime) { 
  println("frame #"+frameTime.getFrameID()+" ("+frameTime.getTotalMilliseconds()+")");
}
