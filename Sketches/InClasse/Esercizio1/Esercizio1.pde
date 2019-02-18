// Funzione che implemnta la somma di 2 numeri interi
int somma(int a, int b)
{
  int totale = a + b;
  return totale; // Ritorno il valore della somma calcolata
}

// Funzione di sistema che viene eseguita da Processing solo all'avvio (Run) dello sketch
void setup()
{
  float contatore = 0.7;
  println(contatore); // Funzione che scrive nella finestra dei messaggi
  contatore  = 5;
  println(contatore);
  contatore = contatore + 5;
  println("totale=" + contatore);
  
  line(10, 10, 50, 50);
  
  int t = somma(10, 5);
  println(t);
}