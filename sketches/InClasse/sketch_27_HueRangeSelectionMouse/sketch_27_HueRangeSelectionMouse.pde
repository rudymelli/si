import gab.opencv.*;

PImage img;
OpenCV opencv;
Histogram histogram;

int lowerb = 50;
int upperb = 100;

color colorSelected = color(100, 255, 255);
int colorTh = 100;
int colorInterval = 10;

void setup() {
  img = loadImage("colored_balls.jpg");
  opencv = new OpenCV(this, img);
  size(1024, 768);
  opencv.useColor(HSB);
}

void draw() {
  colorInterval = (int)map(mouseY, 0, height, 1, 50);
  //colorTh = (int)map(mouseX, 0, width, colorInterval, 255 - colorInterval);
  lowerb = colorTh - colorInterval;
  upperb = colorTh + colorInterval;
  
  opencv.loadImage(img);
  
  image(img, 0, 0);  
  
  opencv.setGray(opencv.getH().clone());
  opencv.inRange(lowerb, upperb);
  histogram = opencv.findHistogram(opencv.getH(), 255);

  image(opencv.getOutput(), 3*width/4, 3*height/4, width/4,height/4);

  noStroke(); fill(0);
  histogram.draw(10, height - 230, 400, 200);
  noFill(); stroke(0);
  line(10, height-30, 410, height-30);

  text("Hue", 10, height - (textAscent() + textDescent()));
  
  float lb = map(lowerb, 0, 255, 0, 400);
  float ub = map(upperb, 0, 255, 0, 400);

  stroke(255, 0, 0); fill(255, 0, 0);
  strokeWeight(2);
  line(lb + 10, height-30, ub +10, height-30);
  ellipse(lb+10, height-30, 3, 3 );
  text(lowerb, lb-10, height-15);
  ellipse(ub+10, height-30, 3, 3 );
  text(upperb, ub+10, height-15);
  
  noStroke();
  text(colorTh, 50, 10);
  text(colorInterval, 50, 30);
  fill(colorSelected);
  rect(0, 0, 40, 40);
}

void mousePressed()
{
  colorSelected = get(mouseX, mouseY);
  colorTh = (int)hue(colorSelected);
}
