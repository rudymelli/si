import processing.serial.*;
Serial myPort;  // Create object from Serial class

void setup()
{
  String portName = Serial.list()[0];
  println("Opening port " + portName);
  myPort = new Serial(this, portName, 9600);
  frameRate(1000); // IMPORTANTE per evitare di accumulare ritardo nella lettura del dato
}

void draw()
{
   if ( myPort.available() > 0)
   {
     try{
       String szvalue = myPort.readStringUntil('\n');
       String cr_char = "";
       szvalue = szvalue.replaceAll("\n\r", cr_char);
       szvalue = szvalue.replaceAll("\r\n", cr_char);
       szvalue = szvalue.replaceAll("\n", cr_char);
       szvalue = szvalue.replaceAll("\r", cr_char);
       if(szvalue != "" && szvalue != " ")
       {
         int ival = Integer.parseInt(szvalue);
         println(ival);
         if(ival > 500)
           background(0, 255, 0);
         else
           background(0);  
         
         text(ival, 20, 20);
         text(frameRate, 20, 50);
       }
     }
     catch(Exception e)
     {
     }
   }
}
