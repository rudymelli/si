// From https://www.openprocessing.org/sketch/33885#

import oscP5.*;
import netP5.*;
OscP5 oscP5, oscP5_out;
NetAddress myRemoteLocation;

import ddf.minim.*;
AudioPlayer soundfile;
Minim minim;

float lhx, lhy, lhz, rhx = 0, rhy, rhz, hx, hy, hz; // coordinates
float rfx, rfy, rfz;

int num =20;
float step, sz, offSet, theta, angle;

void setup() {

  size(640, 480);
  frameRate(25);
  
  minim = new Minim(this);
  soundfile = minim.loadFile("ufficio.wav", 2048);
  soundfile.loop();
    
  oscP5 = new OscP5(this, 12345);
  oscP5_out = new OscP5(this, 22345); 
  myRemoteLocation = new NetAddress("127.0.0.1", 12346);
  frameRate(100);
  strokeWeight(5);
  step = 22;
}

void draw() {
  sendData(); //refresh
  
  float head_x = map(hz, 0, 5000, 0, width);
  if(hz == 0)
    hz = 5000;
  fill(0,255,0);
  rect(0, height/4, head_x, height/2);

  if(hz < 2000 && !soundfile.isPlaying())
    soundfile.play();
  else if(hz > 2000 && soundfile.isPlaying())
    soundfile.pause();
    
  float h_gain = map(hz, 500, 5000, -1, -40);
  soundfile.setGain(h_gain);
  
  println("Distanza testa: " + hz + " [" + head_x + "] ");
  draw_op(hz);
  
  float h_framerate = map(hz, 0, 5000, 1, 100);
  //if(frameCount % frameRate == 0)
  frameRate(h_framerate);
}


void draw_op(float z) {
  background(20);
  translate(width/2, height*.75);
  angle=0;
  for (int i=0; i<num; i++) {
    stroke(255);
    noFill();
    sz = i*step;
    float offSet = TWO_PI/num*i;
    float arcEnd = map(sin(theta+offSet),-1,1, PI, TWO_PI);
    arc(0, 0, sz, sz, PI, arcEnd);
  }
  colorMode(RGB);
  resetMatrix();
  theta += .0523;
}

void sendData() 
{
  OscMessage myMessage = new OscMessage("/righthand_trackjointpos");
  OscMessage myMessage2 = new OscMessage("/lefthand_trackjointpos");
  OscMessage myMessage3 = new OscMessage("/head_trackjointpos");
  OscMessage myMessage4 = new OscMessage("/rightfoot_trackjointpos");
  //...aggiungere richiesta altri dati
  myMessage.add(1);
  myMessage2.add(1);
  myMessage3.add(2);
  myMessage4.add(1);

  oscP5.send(myMessage, myRemoteLocation); 
  oscP5.send(myMessage2, myRemoteLocation); 
  oscP5.send(myMessage3, myRemoteLocation);
  oscP5.send(myMessage4, myRemoteLocation);
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
}
