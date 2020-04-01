void setup()
{
  //dimensione foglio
  size(400, 400);
}

void draw()
{
  int mx = mouseX;
  //contatore pixel
  int x = 0; 

  //crea linee
  for (int i = 0; i<80; i++)
  {
    //if (mx - x <= 2 && x - mx <= 2)
    if (abs(mx - x) <= 2)
    {
      stroke(255, 0, 0);
    } 
    else
    {
      stroke(0);
    }
    line(x, 0, x, height);
    x+=5;
  }
}
