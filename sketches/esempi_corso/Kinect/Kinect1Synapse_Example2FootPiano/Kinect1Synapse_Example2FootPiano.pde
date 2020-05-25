// From https://www.openprocessing.org/sketch/33885#

import oscP5.*;
import netP5.*;

import themidibus.*; //Import the library
MidiBus myBus; // The MidiBus

OscP5 oscP5, oscP5_out;
NetAddress myRemoteLocation;

float lhx, lhy, lhz, rhx = 0, rhy, rhz, hx, hy, hz; // coordinates
float rfx, rfy, rfz, rfy_prec = 0;
float lfx, lfy, lfz, lfy_prec = 0;

int num =20;
float step, sz, offSet, theta, angle;

void setup() {

  size(640, 480);
  frameRate(25);
  
  oscP5 = new OscP5(this, 12345);
  oscP5_out = new OscP5(this, 22345);
  
  myRemoteLocation = new NetAddress("127.0.0.1", 12346);
  frameRate(100);
  strokeWeight(5);
  step = 22;
  
  MidiBus.list();
  myBus = new MidiBus(this, -1, "Microsoft MIDI Mapper"); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.  
}

int nota_prec = 0;
boolean bPressed = false;
void draw() {
  sendData(); //refresh
  
  //float head_x = map(hz, 0, 5000, 0, width);    
  // X -900 / 350  Y -800/-550 Z 2500/3500
  
  float nota_sx = map(lfx, -900, 350, 0, 127);
  float nota_dx = map(rfx, -900, 350, 0, 127);
  
  boolean bPiedeSx = (lfz > 2000 && lfz < 3000 && lfy_prec > -790 && lfy < -800);
  boolean bPiedeDx = (rfz > 2000 && rfz < 3000 && ((rfy_prec > -790 && rfy < -800) || nota_prec != (int)nota_dx));
  
  if((bPiedeSx || bPiedeDx) && !bPressed)
  {
    float nota = nota_sx;
    if(bPiedeDx)
    {
        nota = nota_dx;
        nota_prec = (int)nota_dx;
    }

    println("-----NOTA-----");
    int channel = 0;
    int pitch = (int)nota;
    int velocity = 127;
  
    myBus.sendNoteOn(channel, pitch, velocity); // Send a Midi noteOn
    //delay(200);
    //myBus.sendNoteOff(channel, pitch, velocity); // Send a Midi nodeOff
    bPressed = true;
  }
  println("Piede sinistro: " + lfx + " " + lfy + " " + lfz + " (" + lfy_prec);
  println("Piede destro: " + rfx + " " + rfy + " " + rfz + " (" + rfy_prec);
  if(frameCount % 30 == 0)
  {
    lfy_prec = lfy;
    rfy_prec = rfy;
    bPressed = false;
  }
}

void sendData() 
{
  OscMessage myMessage = new OscMessage("/righthand_trackjointpos");
  OscMessage myMessage2 = new OscMessage("/lefthand_trackjointpos");
  OscMessage myMessage3 = new OscMessage("/head_trackjointpos");
  OscMessage myMessage4 = new OscMessage("/rightfoot_trackjointpos");
  OscMessage myMessage5 = new OscMessage("/leftfoot_trackjointpos");
  //...aggiungere richiesta altri dati
  myMessage.add(1);
  myMessage2.add(1);
  myMessage3.add(2);
  myMessage4.add(2);
  myMessage5.add(2);

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
  
  if (v.equals("/rightfoot_pos_world")) 
  {
    rfx = theOscMessage.get(0).floatValue();  
    rfy = theOscMessage.get(1).floatValue();
    rfz = theOscMessage.get(2).floatValue();
  }
  if (v.equals("/leftfoot_pos_world")) 
  {
    lfx = theOscMessage.get(0).floatValue();  
    lfy = theOscMessage.get(1).floatValue();
    lfz = theOscMessage.get(2).floatValue();
  }
}