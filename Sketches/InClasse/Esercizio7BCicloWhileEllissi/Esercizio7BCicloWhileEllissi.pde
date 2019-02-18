void setup()
{
  size(500, 500);
  frameRate(1);
}

void draw()
{
  background(0);
  float x = 0, y = 0;
  while(x < width/2)
  {
    fill(random(255), random(255), random(255));
    x = random(width - width/5) + width/10;
    y = random(height - height/5) + height/10;
    ellipse(x, y, random(width/5), random(height/5));
  }
}