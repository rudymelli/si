int contatore;

void setup()
{
  // Apertura video, immagini, webcam, ....
  contatore = 0;
  //frameRate(1000);
}

int incrementa(int valore)
{
  return (valore + 1);
}

void draw()
{
  // processamento dati
  // Logica di funzionamento
  contatore  = contatore + 1;
  println("contatore=" + contatore);
  //delay(1000);
}
