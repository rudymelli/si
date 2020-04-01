void setup()
{
  size(200, 200);
}

void draw()
{
  int x = mouseX;
  
  if(x > 100)
  {
    background(255, 0, 0);
  }
  else if(x < 50)
  {
    background(0, 255, 0);
  }
  else
  {
    background(0, 0, 255);
  }
}
