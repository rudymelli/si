boolean dentro = false;
void draw()
{
  int pos = mouseX;
  println(pos);
  // dentro == false <-equivalente a-> !dentro
  if(pos > 50 && !dentro)
  {
    fill(random(255), random(255), random(255));
    rect(random(100), random(100), random(100), random(100));
  }
  dentro = (pos > 50);
}