//size(500, 500);
//background(0);
//for(int i=0; i<10; ++i)
//{
//  fill(random(255), random(255), random(255));
//  ellipse(random(400) + 50, random(400) + 50, random(100), random(100));
//}

void triangles()
{
  line(10, 10, 20, 20);
  line(20, 20, 10, 20);
  line(10, 20, 10, 10);
  
  int x=0, y=0 ,colore=0;
  
  switch(colore)
  {
    case 0: fill(0); break;
    case 1: fill(50); break;
    case 2: fill(100); break;
    case 3: fill(150); break;
    default: fill(255); break;
  }
  
  if(x >= 10 && x <= 20)
    fill(0);
  else if(x >= 11 && x <= 30)
    fill(50);
  else if(x >= 21 && x <= 40)
    fill(100);
  else
    fill(255);
    
  {
  }
}

void triangle()
{
line(10, 10, 20, 20);
line(20, 20, 10, 20);
line(10, 20, 10, 10);
}

/*
fill(random(255), random(255), random(255));
ellipse(random(400) + 50, random(400) + 50, random(100), random(100));
fill(random(255), random(255), random(255));
ellipse(random(400) + 50, random(400) + 50, random(100), random(100));
fill(random(255), random(255), random(255));
ellipse(random(400) + 50, random(400) + 50, random(100), random(100));
fill(random(255), random(255), random(255));
ellipse(random(400) + 50, random(400) + 50, random(100), random(100));
fill(random(255), random(255), random(255));
ellipse(random(400) + 50, random(400) + 50, random(100), random(100));
fill(random(255), random(255), random(255));
ellipse(random(400) + 50, random(400) + 50, random(100), random(100));
fill(random(255), random(255), random(255));
ellipse(random(400) + 50, random(400) + 50, random(100), random(100));
fill(random(255), random(255), random(255));
ellipse(random(400) + 50, random(400) + 50, random(100), random(100));
fill(random(255), random(255), random(255));
ellipse(random(400) + 50, random(400) + 50, random(100), random(100));
fill(random(255), random(255), random(255));
ellipse(random(400) + 50, random(400) + 50, random(100), random(100));


fill(random(255), random(255), random(255));
ellipse(150, 150, 60, 60);
fill(random(255), random(255), random(255));
ellipse(90, 250, 20, 40);
fill(random(255), random(255), random(255));
ellipse(350, 50, 30, 30);
fill(random(255), random(255), random(255));
ellipse(60, 350, 20, 20);
fill(random(255), random(255), random(255));
ellipse(250, 250, 80, 80);
fill(random(255), random(255), random(255));
ellipse(450, 450, 10, 10);
fill(random(255), random(255), random(255));
ellipse(250, 150, 20, 20);
fill(random(255), random(255), random(255));
ellipse(150, 250, 30, 30);
fill(random(255), random(255), random(255));
ellipse(350, 350, 40, 40);
*/