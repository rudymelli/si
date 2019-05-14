// Inertia 02 by Larry Larryson
// https://www.openprocessing.org/sketch/678253
// Particles are languidly attracted towards the cursor,
// but are rarely able to stop when/if they reach it.  
// particle system, vector

Particle[] particles;
int n = 30;

void setup() {
  size(700, 600);
  background(0);

  particles = new Particle[n];
  for (int i = 0; i < n; i++) {
    PVector p = new PVector(random(0, width), random(0, height));
    particles[i] = new Particle(p);
  }
}

void draw() {
  background(0);
  for (int i = 0; i < n; i++) {
    particles[i].addForce(particles[i].attractTo(mouseX, mouseY));
    particles[i].run();
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
    dist = constrain(dist, 15, 25);
    dir.normalize();
    // combine gravity and attractor_mass as 1 number
    float f = (30*mass)/(dist*dist);
    dir.mult(f);
    return dir;
  }
}
