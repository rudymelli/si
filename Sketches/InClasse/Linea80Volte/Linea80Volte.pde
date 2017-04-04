void setup()
{
  size(400, 100);
}

void draw()
{
  for(int x=0; x<80; x = x + 1)
  {
    line(x * 5, 10, x * 5, 90);
  }
}