int sensore = 3; // Valore che arriva da un sensore costantemente
/* questo 
è un commento
*/
switch(sensore)
{
  case 0: background(0); break;
  case 1: background(255, 0, 0); break;
  case 5: background(0, 255, 0); break;
  default: background(255); break;
}

// Il codice switch soprastante si può replicare usando solo "if":
if(sensore == 0)
  background(0);
else if(sensore == 1)
  background(255, 0, 0);
else if(sensore == 5)
  background(0, 255, 0);
else
  background(255);