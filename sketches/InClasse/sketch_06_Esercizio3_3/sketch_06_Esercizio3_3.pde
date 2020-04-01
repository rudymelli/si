void setup()
{
  //dimensione foglio
  size(400, 400);
}

void draw()
{
  //contatore pixel
  int x = 0; 

  //crea linee
  for (int i = 0; i<80; i++)
  {
    line(x, 0, x, 100);
    x+=5;
  }
}
