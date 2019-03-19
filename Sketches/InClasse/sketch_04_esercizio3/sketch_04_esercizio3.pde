size(500, 500);
for(int x=0; x<width; x = x + 5)
{
  if(x<width/2)
    stroke(0, 0, 0);
  else
    stroke(255, 0, 0);
  line(x, 0, x, height);
}
