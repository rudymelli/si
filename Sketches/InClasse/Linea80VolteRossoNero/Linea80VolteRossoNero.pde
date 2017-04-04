void setup()
{
  size(400, 100);
}

void draw()
{
  for(int x=0; x<80; x = x + 1)
  {
    if(x < 40)
    {
      stroke(255, 0, 0);
    }
    else
    {
      stroke(0, 0, 0);
    }    
    
    line(x * 5, 10, x * 5, 90);
  }
}