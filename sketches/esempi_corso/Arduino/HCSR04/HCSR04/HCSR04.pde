import processing.serial.*;

Serial myPort;  // Create object from Serial class
String szval = "";
FloatList FromArduino = new FloatList();

void setup()
{
  String portName = Serial.list()[0];
  println("Opening port " + portName);
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n'); 
}

void draw()
{
  Boolean bread = false;
  if ( myPort.available() > 0) {  // If data is available,
    String szvalue = myPort.readStringUntil('\n');         // read it and store it in val
    if(szvalue != null && szvalue != "")
    {
      // Lettura
      FromArduino.clear();
      String cr_char = "";
      szval = szvalue;
      szval = szval.replaceAll("\n\r", cr_char);
      szval = szval.replaceAll("\r\n", cr_char);
      szval = szval.replaceAll("\n", cr_char);
      szval = szval.replaceAll("\r", cr_char);
      print("\nCOM received:'" + szval + "'");
      String[] listval = split(szval, ' ');
      if(listval.length > 0)
      {
        for (int i = 0; i < listval.length; i = i+1)
          if(listval[i].length() > 0 && listval[i] != "" && listval[i] != " ")// && listval[i] != "\"" && listval[i] != "\'" && listval[i] != "\n" && listval[i] != "\r")
          FromArduino.append((float)Double.parseDouble(listval[i]));
        bread = true;
        
        // Il tuo codice qui
        float valVicinanza = FromArduino.get(0); 
        background(0);
        text("S=" + valVicinanza, 20, 20);
        rect(0, 0, 10, valVicinanza);
        if(valVicinanza > 50)
          myPort.write(1);
        else
          myPort.write(0);
      }
    }
  }
}