void setup()
{
  size(500, 500);
}
void draw()
{
  if(mouseX < width/2)
    background(0, 255*(1-(float)mouseX/width*2), 0);
  else
    background(0);
}
