int side=300;
size(300, 300);
background(0);

for(int pippo=0; pippo < 100; pippo = pippo + 1)
{
  fill(random(255), random(255), random(255));
  ellipse(pippo * 3, pippo * 3, pippo, pippo);
}