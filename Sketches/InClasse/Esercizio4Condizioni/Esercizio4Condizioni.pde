
void setup()
{
  size(200, 150);
}

void draw()
{
    int xp = width / 2;
    int yp = height / 2;
    
    int side = width / 5;
    
    int x1 = xp - side / 2;
    int y1 = yp - side / 2;
    int x2 = xp + side / 2;
    int y2 = yp + side / 2;
    
    int xm = mouseX;
    int ym = mouseY;
    
    if(xm >= x1 && xm <= x2 && ym >= y1 && ym <= y2)
    {
      background(0, 255, 0);
      fill(0, 255, 0);
    }
    else
    {
      background(255);
      fill(255);
    }
    
    stroke(255, 0, 0);
    rect(x1, y1, side, side);
    
    // Esercizio banale di controllo
    int x = 10;
    if(x >= 10 && x <= 20)
    {
      println("X tra 10 e 20");
    }
     
    if((x >= 10 && x <= 20) || (x >= 40 && x <= 50))
    {
      println("X tra 10 e 20 o tra 40 e 50");
    }
    
    // Impossibile
    if((x >= 10 && x <= 20) && (x >= 40 && x <= 50))
    {
      println("Impossibile");
    }
}