int X0 = 100;
int X1 = 300;

int Y0 = 80;
int Y1 = 250;
PImage img;

void setup()
{
  fullScreen(1);
  //size(400, 400);
  img = loadImage("C:\\Users\\melli\\Pictures\\Immagine.png");
}

void draw()
{
  background(0);
  int X = mouseX;
  int Y = mouseY;
  
  //rect(X0, Y0, X1-X0, Y1-Y0);
  
  if(X >= X0 && X <= X1 && Y >= Y0 && Y <= Y1)
  {
    //image(img, X0, Y0, X1-X0, Y1-Y0);
    image(img, 0, 0, width, height);
  }
}