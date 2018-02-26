// Da usare in concomitanza con la webpage:
// http://interattivi.altervista.org/si_wordpress/speech.html
// Bisogna avere chrome o Firefox come browser predefiniti, la prima volta aprire a mano il link
// e abilitare l'uso del microfono
// Rudy Melli
import websockets.*;

WebsocketServer ws;
int crono_check = 60000;
int crono_ws = -crono_check;
String SpeechDetectorLink = "https://interattivi.altervista.org/si_wordpress/speech.html";
String lastSpeech = "";

void setup()
{
  size(200,200);
  // Creo un webserver a cui la pagina speech.html invierà le parole lette
  ws= new WebsocketServer(this,8080,"/");
  // Rendo la finestra di output sempre on top
  surface.setAlwaysOnTop(true);
}

void draw()
{
  background(0);
  // Se la pagina non riceve dati da almeno crono_check msec, la riaggiorno
  if(millis() - crono_ws >= crono_check)
  {
    openSpeechDetectorLink();
  }
  int sectorefresh = (int)((crono_check - (millis() - crono_ws)) / 1000.0);
  text("Last speech: " + lastSpeech, 20, 20);
  text("Refresh link in " + sectorefresh + " sec", 20, 40);
}

void webSocketServerEvent(String msg)
{
   // Ho ricevuto qualcosa dalla pagina web
   lastSpeech = msg;
   println(msg);
   crono_ws = millis();
   String[] m1 = match(msg, "prova");
   if (m1 != null) 
   {  
     // If not null, then a match was found
     println("-----------------------");
   }

}

void openSpeechDetectorLink()
{
    // Avvio il link
    link(SpeechDetectorLink);
    crono_ws = millis();
    println("Launched link: " + SpeechDetectorLink);
}