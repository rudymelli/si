size(500, 500);
stroke(0, 0, 0);
for(int i=0; i<80; i = i+1)
{
  if(i == 40)
    stroke(255, 0, 0);
  line(i*5, 10, i*5, height-10);
}
