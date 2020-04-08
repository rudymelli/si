int X0 = 100;
int X1 = 300;

int Y0 = 80;
int Y1 = 250;

int X2 = 250;
int X3 = 400;

int Y2 = 20;
int Y3 = 120;

PImage img, img2;

void setup()
{
  fullScreen(1);
  //size(400, 400);
  img = loadImage("C:\\Users\\melli\\Pictures\\Immagine.png");
  img2 = loadImage("C:\\Users\\melli\\Pictures\\Immagine1.png");
}

void draw()
{
  int X = mouseX;
  int Y = mouseY;
  
  //rect(X0, Y0, X1-X0, Y1-Y0);
  
  if(X >= X0 && X <= X1 && Y >= Y0 && Y <= Y1)
  {
    //image(img, X0, Y0, X1-X0, Y1-Y0);
    image(img, 0, 0, width, height);
  }
  else if(X >= X2 && X <= X3 && Y >= Y2 && Y <= Y3)
  {
    //image(img, X0, Y0, X1-X0, Y1-Y0);
    image(img2, 0, 0, width, height);
  }
  else
  {
    background(0);
  }
}