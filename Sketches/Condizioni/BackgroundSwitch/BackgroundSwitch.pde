

void draw()
{
  int marker = mouseX / 10;// valore del marker letto dalla libreria
  println(marker);
  
  switch(marker)
  {
    case 0: background(10); break;
    case 1: background(30); break;
    case 2: background(90); break;
    case 3: background(140); break;
    case 4: background(180); break;
    case 5: background(210); break;
    default: background(0);
  }
}