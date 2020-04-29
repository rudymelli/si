import TUIO.*;
TuioProcessing tuioClient;

int countMarkers = 0;

PImage img1, img2;

void setup()
{
  size(800, 600);
  tuioClient = new TuioProcessing(this);
  
  img1 = loadImage("http://www.comefunziona.net/images/telefono_01.jpg");
  img2 = loadImage("https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Gluehlampe_01_KMJ.jpg/150px-Gluehlampe_01_KMJ.jpg");
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
     if(objID == 0)
     {
       pushMatrix();
       translate(objXScreen, objYScreen);
       rotate(objRot / 180.0 * PI);
       translate(-objXScreen, -objYScreen);
       //------------ inizio disegno
       image(img1, objXScreen-60, objYScreen-40, 120, 80);
       //------------ fine disegno
       popMatrix();
     }
     else if(objID == 1)
     {
       pushMatrix();
       translate(objXScreen, objYScreen);
       rotate(objRot / 180.0 * PI);
       translate(-objXScreen, -objYScreen);       
       image(img2, objXScreen-40, objYScreen-120, 80, 120);
       popMatrix();
     }    
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
