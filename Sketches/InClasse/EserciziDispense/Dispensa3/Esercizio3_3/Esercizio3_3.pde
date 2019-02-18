void setup()
{
  size(500, 500);
  background(0, 255, 0);
}

void draw()
{
  if(mouseX > width/2)
  {
    background(0);
  }
  else
  {
    background(0, 255, 0);
  }
}