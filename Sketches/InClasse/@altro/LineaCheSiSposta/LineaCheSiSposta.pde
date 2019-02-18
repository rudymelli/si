int x = 10;

void setup()
{
  size(600, 100);
  frameRate(5);
}

void draw()
{
  background(200);  
  line(x, 10, x, 30);
  x=x+10;
}