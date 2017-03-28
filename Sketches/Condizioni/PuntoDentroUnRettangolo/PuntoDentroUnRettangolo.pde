int X0 = 100;
int X1 = 300;

int Y0 = 80;
int Y1 = 250;

void setup()
{
  size(400, 400);
}

void draw()
{
  background(255);
  int X = mouseX;
  int Y = mouseY;
  
  rect(X0, Y0, X1-X0, Y1-Y0);
  
  if(X >= X0 && X <= X1 && Y >= Y0 && Y <= Y1)
  {
    line(X0, Y0, X1, Y1);
  }
}