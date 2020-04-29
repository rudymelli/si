import processing.video.*;
import TUIO.*;
TuioProcessing tuioClient;

Movie filmato[] = new Movie[2];
PVector marker_posizione[] = new PVector[2];
float marker_rotazione[] = new float[2];
int marker_ultimoframe[] = new int[2];

int countMarkers = 0;

void setup()
{
  size(640, 480);
  
  tuioClient = new TuioProcessing(this);
  filmato[0] = new Movie(this, "../../../../../media/Micro-dance.avi");
  filmato[0].loop();
  filmato[1] = new Movie(this, "../../../../../media/A111_04.DoppioVeloce_ds.mov");
  filmato[1].loop();
  
  marker_ultimoframe[0] = -1;
  marker_ultimoframe[1] = -1;
}

void draw()
{
  if(filmato[0].available())
    filmato[0].read();
  if(filmato[1].available())
    filmato[1].read();
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
     
     if(objID == 7)
     {
       marker_posizione[0] = new PVector(objXScreen, objYScreen);
       marker_rotazione[0] = objRot / 180.0 * PI;
       marker_ultimoframe[0] = frameCount;
     }
     else if(objID == 2)
     {
       marker_posizione[1] = new PVector(objXScreen, objYScreen);
       marker_rotazione[1] = objRot / 180.0 * PI;
       marker_ultimoframe[1] = frameCount;
     }
   }
   
   for(int i=0; i<2; i++)
   {
     if(marker_ultimoframe[i] >= 0 && 
       frameCount - marker_ultimoframe[i] < 30)
     {
       pushMatrix(); // inizio sezione di rototraslazione
       translate(marker_posizione[i].x, marker_posizione[i].y);
       rotate(marker_rotazione[i]);
       image(filmato[i], -50, -50, 200, 140);
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
