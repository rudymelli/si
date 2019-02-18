void setup()
{
  size(500, 500);
  frameRate(5);
}

void draw()
{
  background(0);
  for(int i=0; i<50; i=i+1)
  {
    fill(random(255), random(255), random(255));
    ellipse(random(width - width/5) + width/10, random(height - height/5) + height/10, 
        random(width/5), random(height/5));
  }
}