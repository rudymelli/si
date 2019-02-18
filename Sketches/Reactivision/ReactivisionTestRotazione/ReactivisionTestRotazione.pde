import processing.video.*;
import TUIO.*;

TuioProcessing tuioClient;
Movie filmato[] = new Movie[2];

int countMarkers = 0;

void setup()
{
  size(640, 480);
  
  tuioClient = new TuioProcessing(this);
  filmato[0] = new Movie(this, "E:\\media\\Micro-dance.avi");
  filmato[0].loop();
  filmato[1] = new Movie(this, "E:\\media\\A111_04.DoppioVeloce_ds.mov");
  filmato[1].loop();
}

void draw()
{
  // Aggiornamento dei frame dei filmati
  if(filmato[0].available())
    filmato[0].read();
  if(filmato[1].available())
    filmato[1].read();
    
  // Coloro lo sfondo di bianco  
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
     
     if(objID == 8)
     {
       pushMatrix(); // inizio sezione di rototraslazione
       translate(objXScreen, objYScreen);
       rotate(objRot / 180.0 * PI);
       image(filmato[0], -width/12, -height/12, width/6, height/6);
       popMatrix();  // fine sezione di rototralazione
     }
     else if(objID == 1)
     {
       pushMatrix(); // inizio sezione di rototraslazione
       translate(objXScreen, objYScreen);
       rotate(objRot / 180.0 * PI);
       image(filmato[1], -width/12, -height/12, width/6, height/6);
       popMatrix();  // fine sezione di rototralazione
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