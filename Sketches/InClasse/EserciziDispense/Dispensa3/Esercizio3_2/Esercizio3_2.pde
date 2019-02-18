size(1000, 600);
int posizione = -1; // Creazione della variabile
if(posizione >= 0)  // Verifico se la variabile è >= 0
{
  stroke(255, 0, 0);// Imposto il colore della linea a rosso
}
else
{
  stroke(0);        // Imposto il colore della linea a nero
}
//line(10, 10, 80, 10);//Disegno la linea

// Esercizio 3.2
for(int x=0; x<80; x=x+1)
{
  if(x < 40)
    stroke(0, 0, 0);
  else
    stroke(255, 0, 0);
  line(x * 5, 0, x * 5, height);
}