boolean dentro = false;
void draw()
{
  int pos = mouseX;
  println(pos);
  if(pos > 50)
  {
    fill(random(255), random(255), random(255));
    rect(random(100), random(100), random(100), random(100));
  }
  dentro = (pos > 50);
}