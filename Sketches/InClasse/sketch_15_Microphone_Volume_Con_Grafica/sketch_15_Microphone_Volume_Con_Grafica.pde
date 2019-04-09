/*
Modified version by Rudy Melli
of the example inside original Sound library processing.org

Be Careful with your speaker volume, you might produce a painful 
feedback. We recommend to wear headphones for this example.

*/

import processing.sound.*;
import java.util.Iterator;

final float GRAVITY = -0.1;
final boolean MOTION_BLUR = true;

ParticleSystem system = new ParticleSystem();

AudioIn mic_in;
Amplitude rms;

FloatList inventory = new FloatList();

int scale=1;

boolean VoiceClick = false;
PVector ptstart, ptstop;
int ptcount;

void setup() {
    fullScreen ();
    
    //Create an Audio input and grab the 1st channel
    mic_in = new AudioIn(this, 0);
    // start the Audio Input
    mic_in.start();
    // create a new Amplitude analyzer
    rms = new Amplitude(this);
    // Patch the input to an volume analyzer
    rms.input(mic_in);
    mic_in.amp(1);
}      

void draw() {
    // rms.analyze() return a value between 0 and 1. To adjust
    // the scaling and mapping of an ellipse we scale from 0 to 0.5
    float vol = rms.analyze();    
    int inventory_len = 20;
    inventory.append(vol);
    if(inventory.size() > inventory_len)
      inventory.remove(0);
    float vol_medio = inventory.sum() / inventory.size();
    
    if(vol_medio > 0.1 && VoiceClick == false)
    {
      VoiceClick = true;
      ptstart = new PVector(random(width), random(height));
      ptstop = new PVector(random(width), random(height));
      ptcount = 0;
    }
    else if(vol_medio < 0.1 && VoiceClick == true)
      VoiceClick = false;

    if(VoiceClick == true)
      voiceDragged();
    
    drawBackground();
  
    system.update();
}

void voiceDragged()
{
  int step = 10;
  float x = ptstart.x + (ptstop.x - ptstart.x) / step * ptcount;
  float y = ptstart.y + (ptstop.y - ptstart.y) / step * ptcount;
  system.particles.add(new Particle(new PVector(x, y)));
  ptcount = ptcount + 1;
}

void mouseDragged()
{ 
  system.particles.add(new Particle(new PVector(mouseX, mouseY)));
  system.particles.add(new Particle(new PVector(mouseX, mouseY)));
  system.particles.add(new Particle(new PVector(mouseX, mouseY)));
}

void drawBackground()
{
  if (MOTION_BLUR) {
    // Background with motion blur
    noStroke();
    fill(200, 200);
    rect(0, 0, width, height);
  } else {
    // Normal background
    background(0);
  }
}

class ParticleSystem
{
  ArrayList<Particle> particles = new ArrayList<Particle>();
  
  void update()
  {
    Iterator<Particle> i = particles.iterator();

    while (i.hasNext()) {
      Particle p = i.next();
      
      // Remove any particles outside of the screen
      if (p.pos.x > width || p.pos.x < 0) {
        i.remove();
        continue;
      } else if (p.pos.y > height || p.pos.y < 0) {
        i.remove();
        continue;
      }
      
      // Apply gravity
      p.applyForce(PVector.random2D());
      
      // Move particle position
      p.move();
      
      // Remove dead particles
      if (p.isDead()) {
        i.remove();  
      } else {
        p.display();
      }
      
    }
  }
}

class Particle
{
  final static float BOUNCE = -0.5;
  final static float MAX_SPEED = 0.1;
  
  PVector vel = new PVector(random(-MAX_SPEED, MAX_SPEED), random(-MAX_SPEED, MAX_SPEED));
  PVector acc = new PVector(0, 0);
  PVector pos;
  
  float mass = random(2, 2.5);
  float size = random(0.1, 2.0);
  float r, g, b;
  int lifespan = 255;
  
  Particle(PVector p)
  {
    pos = new PVector (p.x, p.y);
    acc = new PVector (random(0.1, 1.5), 0);
    r = random (1000, 255);
    g = random (0, 50);
    b = 0;
  }
  
  public void move()
  {
    vel.add(acc); // Apply acceleration
    pos.add(vel); // Apply our speed vector
    acc.mult(0);
    
    size += 0.01; //0.015
    lifespan--;
  }
  
  public void applyForce(PVector force) 
  {
    PVector f = PVector.div(force, mass);
    acc.add(f);
  }
  
  public void display()
  {
    // Colour based on x and y velocity
    fill(constrain(abs(this.vel.y) * 100, 0, 255), constrain(abs(this.vel.x) * 100, 0, 255), b, lifespan);
    
    ellipse(pos.x, pos.y, size * 4, size * 4);
  }
  
  public boolean isDead()
  {
    if (lifespan < 0) {
      return true;
    } else {
      return false;
    }
  }
}
