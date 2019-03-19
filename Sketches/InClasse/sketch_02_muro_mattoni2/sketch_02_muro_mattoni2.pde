int larg = 30;
int alt = 15;
int x = 0;
int y = height - alt - 1;
for(int j=0; j<5; j = j + 1)
{
  for(int i=0; i<10; i = i + 1)
  {
    rect(x, y, larg, alt);
    x = x + larg;
  }
  y = y - alt;
  if(j % 2 == 0)
    x = -larg / 2;
  else
    x = 0;
}
