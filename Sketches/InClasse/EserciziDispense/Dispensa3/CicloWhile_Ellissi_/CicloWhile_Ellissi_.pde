int side=300;
size(300, 300);
background(0);

int pippo=0;
while(pippo < 100)
{
  fill(random(255), random(255), random(255));
  ellipse(pippo * 3, pippo * 3, pippo, pippo);
  pippo = pippo + 1;
}