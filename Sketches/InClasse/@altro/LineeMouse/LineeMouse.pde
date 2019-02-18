void disegnalineax(float x)
{
  line(x, 10, x, 40);
}

void draw()
{
  background(255);
  disegnalineax(mouseX);
  disegnalineax(mouseY);
}