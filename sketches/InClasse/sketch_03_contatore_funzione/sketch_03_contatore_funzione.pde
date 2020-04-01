int contatore;

void setup()
{
  // Apertura video, immagini, webcam, ....
  contatore = 0;
}

// Funzione personalizzata "incrementa"
int incrementa(int valore)
{
  return (valore + 1);
}

void draw()
{
  // processamento dati
  // Logica di funzionamento
  
  // Errore di utilizzo, non fa niente così!
  incrementa(contatore);
  print("-> contatore=" + contatore);
  
  contatore = incrementa(contatore);
  println(" contatore=" + contatore);
}
