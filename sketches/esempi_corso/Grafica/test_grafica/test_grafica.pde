class Particle {

  PVector pos;
  float movingArea;

  PVector tail[];
  int tailPosIndex;
  int tailLength;

  float psize;

  float inc1, inc2, inc3;
  float inc1Increment = random(0.01, 0.05);
  float inc2Increment = random(0.01, 0.05);
  float inc3Increment = random(0.01, 0.05);

  Particle() {
    pos = new PVector(0, 0, 0);
    psize = random(0.1, 2.0);

    tailPosIndex = 0;
    tailLength = int(psize * 50);
    tail = new PVector[tailLength];

    inc1 = random(TWO_PI);    
    inc2 = random(TWO_PI);
    inc3 = random(TWO_PI);

    movingArea = 120 - tailLength;
  }

  void draw(float scale) {
    updatePosition(scale);
    drawTail();
  }

  void updatePosition(float scale) {
    inc1 += inc1Increment * scale;
    inc2 += inc2Increment * scale;
    inc3 += inc3Increment * scale;

    pos.x = sin(inc1) * movingArea;
    pos.y = cos(inc2) * movingArea;
    pos.z = sin(inc3) * movingArea;
    tail[tailPosIndex] = new PVector(pos.x, pos.y, pos.z);
  }

  void drawTail() {
    float xp, yp, zp;
    float xOff, yOff, zOff;
    int nullPos = 0;    
    beginShape(QUAD_STRIP);
    for (int i = 0; i < tailLength; i++) {
      int index = (i + tailPosIndex + 1) % tailLength;
      if ( i < tailLength - 1 && tail[index] != null) {
        float per = (i - nullPos) / float(tailLength - nullPos);
        xp = tail[index].x;
        yp = tail[index].y;
        zp = tail[index].z;
        int nextIndex = (i + tailPosIndex + 2) % tailLength;
        PVector v0 = PVector.sub(tail[index], tail[nextIndex]);
        PVector v1 = v0.cross(new PVector(0, 1, 0));
        v1.normalize();
        PVector v2 = v0.cross(v1);
        v2.normalize();
        v1 = v0.cross(v2);
        v1.normalize();
        xOff = v1.x * psize * per;
        yOff = v1.y * psize * per;
        zOff = v1.z * psize * per;

        fill(255, 255 * per);
        
        vertex(xp - xOff, yp - yOff, zp - zOff);
        vertex(xp + xOff, yp + yOff, zp + zOff);
      }
      else nullPos++;
    }
    endShape();

    tailPosIndex++;
    tailPosIndex %= tailLength;
  }
}



Particle[] particles;
int particlesAmount = 50;

void setup(){
  size(720, 480, P3D);
  particles = new Particle[particlesAmount];
  for(int i = 0; i < particlesAmount; i++){
    particles[i] = new Particle();
  }
  noStroke();
}

void draw(){
  background(0);
  lights(); 
  directionalLight(255, 0, 145, -1, 0, 0);
  directionalLight(220, 30, 30,  1, 0, 0);
  camera(0, 0, (height * 0.2) / tan(PI * 60.0 / 360.0), 0, 0, 0, 0, 1, 0);
    
  float scale = (float)mouseX / width; 
  for(int i = 0; i < particlesAmount; i++) particles[i].draw(scale);
}
