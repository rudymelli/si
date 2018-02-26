import processing.serial.*;
Serial myPort;  // Create object from Serial class

void setup()
{
  String portName = Serial.list()[0];
  println("Opening port " + portName);
  myPort = new Serial(this, portName, 9600);
}

void draw()
{
   if ( myPort.available() > 0)
   {
     String szvalue = myPort.readString();
     println(szvalue);
   }
}