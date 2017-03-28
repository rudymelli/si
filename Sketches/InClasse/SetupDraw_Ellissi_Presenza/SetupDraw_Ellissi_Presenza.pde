int side=300;
int pippo=0;

void setup()
{
  size(300, 300);
  background(0);
  frameRate(100);
}

int ValoreSensore()
{
  int v = 0;
  if(mousePressed)
    v = 1;
  return v;
}

void draw()
{
  int presenza = ValoreSensore();    
  if(presenza == 1 && pippo < 100)
  {
    fill(random(255), random(255), random(255));
    ellipse(pippo * 3, pippo * 3, pippo, pippo);
    pippo = pippo + 1;
  }
  
  
}