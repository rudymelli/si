int contatore;

void setup()
{
  println("Setup");
  contatore = 5;
}

void draw()
{
  contatore = contatore + 1;
  println("draw " + contatore);
}