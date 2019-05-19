int count = 0;
void setup()
{
  //inizializza comunicaz. Seriale con un baudrate di 9600
  Serial.begin(9600);
}
void loop()
{
  //Invio una stringa sulla porta seriale
  Serial.println(count);
  count = count + 1;
  //aspetto 100 ms per impedire troppi invii
  delay(100);
}
