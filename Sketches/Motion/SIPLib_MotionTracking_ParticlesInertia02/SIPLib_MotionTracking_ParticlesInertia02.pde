import processing.video.*;

Capture video;
SIPLib siplib;

int TrackX = 0, TrackY = 0;
int threshold = 60;
int countdown = 0;

// From Inertia 02 by Larry Larryson https://www.openprocessing.org/sketch/678253
Particle[] particles;
int n = 30;

void setup()
{
  String[] cameras = Capture.list();
  printArray(cameras);
  size(640, 480);
  video = new Capture(this, 640, 480);//640/2, 480/2);
  siplib = new SIPLib(this, 640, 480);

  video.start();
  
  //size (600, 200);
  smooth();

  background (0);
  frameRate (30);
  
  particles = new Particle[n];
  for (int i = 0; i < n; i++) {
    PVector p = new PVector(random(0, width), random(0, height));
    particles[i] = new Particle(p);
  }
}


void draw() {
  // Visualizzazione
  background(0);
  //image(video, 0, 0, 320, 240);
  
  // Ipotizzo una sola persona presente
  TrackX = width - (int)siplib.cog.x;
  TrackY = (int)siplib.cog.y;
  if(siplib.cogs.size() > 0)
    image(siplib.imgSegment, 320, 0, 320, 240);

  fill(128);
  textSize(18);
  siplib.drawInfo(20, 20);
  
  // Draw a large, yellow circle at the brightest pixel
  fill(255, 204, 0, 128);
  ellipse(TrackX, TrackY, 50, 50);

  noFill();
  if(countdown > 0)
  {
    stroke(0,0,255);
    strokeWeight(10);
    rect(0,0,width,height);
    countdown--;
  }
  noStroke();
  
  for (int i = 0; i < n; i++) {
    particles[i].addForce(particles[i].attractTo(TrackX, TrackY));
    particles[i].run();
  }  
}

void captureEvent(Capture c) {
  c.read();
  siplib.singleDifference(c, threshold, 50);
  //siplib.backgroundSuppression(c, threshold, 50, true, 40, 50);
  //siplib.shadowSegmentation(c, threshold, 50);
  //siplib.lightSegmentation(c, threshold, 50);
  //siplib.colorSegmentationPixel(c,threshold,,);
}

void keyPressed ()
{
  if(key == '+')
    threshold += 10;
  if(key == '-')
    threshold -= 10;
  if(key == 'w')
    threshold += 1;
  if(key == 'q')
    threshold -= 1;
  if(threshold < 0)
    threshold = 0;
  if(threshold > 255)
    threshold = 255;
  if(key == ' ')
    siplib.storeBackground();
  countdown = 30;
}

void mousePressed ()
{
  if (mouseButton == LEFT)
  {
  }
}

class Particle {
  PVector acc, vel, pos;
  float mass, incr, ang;
  color c;

  Particle(PVector p) {
    pos = p.get();
    acc =  new PVector();
    vel = new PVector();
    mass = random(.2, 2);
    ang = 0;
    incr = random(-.001, .001);
    c = color(random(255), random(255), 0);
  }

  void run() {
    update();
    render();
  }

  void update() {
    vel.add(acc);
    vel.limit(4);
    pos.add(vel);
    acc.mult(0);
  }

  void render() {
    rectMode(CENTER);
    fill(c, 200);
    stroke(255);
    strokeWeight(1);

    ang += incr;
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(degrees(ang));
    rect(0, 0, mass*25, mass*25);
    popMatrix();
  }

  void addForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acc.add(f);
  }
  // From Daniel Schiffman's NOC_2_7_attraction_many sketch.
  PVector attractTo(float x, float y) {
    PVector mousePos = new PVector(x, y);
    PVector dir = PVector.sub(mousePos, pos);
    float dist = dir.mag();
    dist = constrain(dist, 15, 25) / 2;
    dir.normalize();
    // combine gravity and attractor_mass as 1 number
    float f = (30*mass)/(dist*dist);
    dir.mult(f);
    return dir;
  }
}
