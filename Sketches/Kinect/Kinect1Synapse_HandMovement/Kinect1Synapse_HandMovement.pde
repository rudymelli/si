// From https://www.openprocessing.org/sketch/33885#

import oscP5.*;
import netP5.*;

OscP5 oscP5, oscP5_out;
NetAddress myRemoteLocation;

float lhx, lhy, lhz, rhx = 0, rhy, rhz, hx, hy, hz; // coordinates
float prev_x = 0;

void setup() {

  size(640, 480);
  frameRate(25);
  oscP5 = new OscP5(this, 12345);
  oscP5_out = new OscP5(this, 22345);
  
  myRemoteLocation = new NetAddress("10.0.4.61", 12346);
  frameRate(100);
}

float dhand = 0;
boolean spazzolata = false;

void draw() {
  background(0); 
  sendData(); //refresh
  
  if(frameCount % 100 == 0)
  {
    spazzolata = false;
    if(rhy > 0)
    {
      dhand = rhx - prev_x;
      if((rhx - prev_x) >= 250)
      {
        println("Spazzolata");
        spazzolata = true;
      }
    }
    prev_x = rhx;
  }
  
  if(spazzolata)
  {
    background(255, 0, 0);
  }

  println("Distanza (m)=" + hz / 1000 + " DHand=" + dhand + " y=" + rhy);
  text(frameRate, 20, 20);
}

void sendData() 
{
  OscMessage myMessage = new OscMessage("/righthand_trackjointpos");
  OscMessage myMessage2 = new OscMessage("/lefthand_trackjointpos");
  OscMessage myMessage3 = new OscMessage("/head_trackjointpos");

  myMessage.add(1);
  myMessage2.add(1);
  myMessage3.add(2);

  oscP5.send(myMessage, myRemoteLocation); 
  oscP5.send(myMessage2, myRemoteLocation); 
  oscP5.send(myMessage3, myRemoteLocation);
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
}