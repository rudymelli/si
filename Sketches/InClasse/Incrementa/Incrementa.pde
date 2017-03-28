int contatore = 1;

int incrementa()
{
  contatore = contatore + 1;
  return contatore;
}

float media(float a, float b)
{
  float risultato = (a + b) / 2;
  return risultato;
}


void setup()
{
  frameRate(100);
}

void draw()
{
  background(200);
  float med = media(5, 7);
  int inc = incrementa();
  println(inc + " " + med);
  text(frameRate, 10, 10);
}