import processing.serial.*;

Serial myPort; // Variabile che gestisce la seriale
String val; // Dati ricevuti dalla porta seriale
void setup()
{
  // Inserire la porta che sta usando arduino
  String portName = Serial.list()[0];
  // Impostare il medesimo baudrate di Arduino
  myPort = new Serial(this, portName, 9600);
}
void draw()
{
  //print("-");
  if ( myPort.available() > 0)
  { 
    // Se ci sono dei dati disponibili
    // li leggo e memorizzo in ‘val’
    val = myPort.readStringUntil('\n');
    println(val); //printo il valore nella console
  }
}
