//
// controllo motorino passo passo 28BYJ-48
// versione 1.0 del 24.09.14
// (c) 2014 Paolo Luongo
// http://aspettandoilbus.blogspot.com
//
// Versione per Arduino UNO R3
// 

const int  IN1 = 8;   // filo motore BLUE
const int  IN2 = 9;   // filo motore ROSA
const int  IN3 = 10;  // filo motore GIALLO
const int  IN4 = 11;  // filo motore ARANCIO

const int MotoreOFF = 99; // motore spento

void Uscita( int i4,int i3,int i2,int i1)
{
  if (i1==1) digitalWrite(IN1,HIGH); else digitalWrite(IN1,LOW);
  if (i2==1) digitalWrite(IN2,HIGH); else digitalWrite(IN2,LOW);
  if (i3==1) digitalWrite(IN3,HIGH); else digitalWrite(IN3,LOW);
  if (i4==1) digitalWrite(IN4,HIGH); else digitalWrite(IN4,LOW);
}

void EseguiPasso(int stato)
{
int i1,i2,i3,i4;

  switch ( stato )
    {// vedi tabella nel pdf del motore passo passo
       case 0: Uscita(0,0,0,1); break;
       case 1: Uscita(0,0,1,1); break;
       case 2: Uscita(0,0,1,0); break; 
       case 3: Uscita(0,1,1,0); break;
       case 4: Uscita(0,1,0,0); break;
       case 5: Uscita(1,1,0,0); break;
       case 6: Uscita(1,0,0,0); break;
       case 7: Uscita(1,0,0,1); break;
       case MotoreOFF: //OFF
          Uscita(0,0,0,0); break;
    } 
   delay(1); //ritardo almeno 1 mS
}  

void RitardoAccensione()
{ //attesa prima di attivare il motore
  EseguiPasso(MotoreOFF); 
  for(int i=0; i<20; i++)
   {
     digitalWrite(13,HIGH);
     delay(250);
     digitalWrite(13,LOW);
     delay(250);
   } 
}  

void setup()
{
    pinMode(IN1, OUTPUT); 
    pinMode(IN2, OUTPUT); 
    pinMode(IN3, OUTPUT); 
    pinMode(IN4, OUTPUT);
    pinMode(13,OUTPUT); 
    RitardoAccensione();  //5 secondi di pausa prima di iniziare
}

void loop()
{
int stato;  
  
  stato=0; //inizio da uno stato arbitrario
  digitalWrite(13,HIGH);  //acceso LED13
  for(int k=0; k<4; k++) //Rotazione Oraria
    {
    for (int i=0; i<1024; i++)  //90 gradi a ciclo
      { 
        EseguiPasso(stato);
        stato+=1; // avanza nella tabella
        if ((stato)>7) stato=0; 
      } 
    EseguiPasso(MotoreOFF);  
    delay(500);  // pausa di mezzo secondo
    }  
  delay(1000); // pausa di 1 secondo
  digitalWrite(13,LOW);  //spento LED13
  for(int k=0; k<4; k++) //Rotazione AntiOraria
    {
    for (int i=0; i<1024; i++)  //90 gradi a ciclo
      { 
        EseguiPasso(stato);
        stato-=1; //torna indietro nella tabella
        if ((stato)<0) stato=7; 
      } 
    EseguiPasso(MotoreOFF);  
    delay(500);
    }
  delay(1000);  
}
