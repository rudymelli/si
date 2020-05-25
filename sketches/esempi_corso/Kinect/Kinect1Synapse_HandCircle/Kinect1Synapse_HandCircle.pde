import oscP5.*;
import netP5.*;

OscP5 oscP5, oscP5_out;
NetAddress myRemoteLocation;

float lhx, lhy, lhz, rhx = 0, rhy, rhz, hx, hy, hz; // coordinates
float rfx, rfy, rfz;
float rhx_px, rhy_px, rhz_px;

void setup() {

  size(640, 480);
  frameRate(25);
  oscP5 = new OscP5(this, 12345);
  oscP5_out = new OscP5(this, 22345);
  
  myRemoteLocation = new NetAddress("127.0.0.1", 12346);
  frameRate(100);
}

void draw() {
  background(0); 
  sendData(); //refresh
  
  fill(255, 0, 0);
  ellipse(rhx_px, rhy_px, 30, 30);
    
  println("Mano destra: " + rhx + ";" + rhy);
  
  text(frameRate, 20, 20);
}

void sendData() 
{
  OscMessage myMessage = new OscMessage("/righthand_trackjointpos");
  OscMessage myMessage2 = new OscMessage("/lefthand_trackjointpos");
  OscMessage myMessage3 = new OscMessage("/head_trackjointpos");
  OscMessage myMessage4 = new OscMessage("/rightfoot_trackjointpos");
  OscMessage myMessage5 = new OscMessage("/righthand_trackjointpos");
  
  //...aggiungere richiesta altri dati
  myMessage.add(1);  // Coordinate relative al torso
  myMessage2.add(1); // Coordinate relative al torso
  myMessage3.add(2); // Coordinate assolute in mm
  myMessage4.add(1); // Coordinate relative al torso
  myMessage5.add(3); // Coordinate in pixel

  oscP5.send(myMessage, myRemoteLocation); 
  oscP5.send(myMessage2, myRemoteLocation); 
  oscP5.send(myMessage3, myRemoteLocation);
  oscP5.send(myMessage4, myRemoteLocation);
  oscP5.send(myMessage5, myRemoteLocation);
}


/* incoming osc message. */
void oscEvent(OscMessage theOscMessage) 
{
  oscP5_out.send(theOscMessage, myRemoteLocation); 
  
  String v=theOscMessage.addrPattern();

  if (v.equals("/righthand_pos_body")) 
  {
    rhx = theOscMessage.get(0).floatValue();  
    rhy = theOscMessage.get(1).floatValue();
    rhz = theOscMessage.get(2).floatValue();
  }

  if (v.equals("/lefthand_pos_body")) 
  {
    lhx = theOscMessage.get(0).floatValue();  
    lhy = theOscMessage.get(1).floatValue();
    lhz = theOscMessage.get(2).floatValue();
  }

  if (v.equals("/head_pos_world")) 
  {
    hx = theOscMessage.get(0).floatValue();  
    hy = theOscMessage.get(1).floatValue();
    hz = theOscMessage.get(2).floatValue();
  }
  
  if (v.equals("/rightfoot_pos_body")) 
  {
    rfx = theOscMessage.get(0).floatValue();  
    rfy = theOscMessage.get(1).floatValue();
    rfz = theOscMessage.get(2).floatValue();
  }
  
  if (v.equals("/righthand_pos_screen")) 
  {
    rhx_px = theOscMessage.get(0).floatValue();  
    rhy_px = theOscMessage.get(1).floatValue();
    rhz_px = theOscMessage.get(2).floatValue();
  }
  
}