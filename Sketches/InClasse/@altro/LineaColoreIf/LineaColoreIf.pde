float A = -10;

void draw()
{
  A = (mouseX - width/2);
  if(A > 0)
  {
    stroke(255, 0, 0);
  }
  else
  {
    stroke(0, 0, 0);
  }
    
  line(10, 10, 90, 90);
}