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
int col_background = 0;

PImage img_mela;
PImage img_anguria;
PImage img_schermo;

void setup()
{
  size(640, 480);
  // Creo un webserver a cui la pagina speech.html invierà le parole lette
  ws= new WebsocketServer(this,8080,"/");
  // Rendo la finestra di output sempre on top
  surface.setAlwaysOnTop(true);
  
  img_mela = loadImage("https://www.gruppomacro.com/data/blog/fb_resolution/m/mela-varieta-e-proprieta.jpg");
  img_anguria = loadImage("http://www.meteoweb.eu/wp-content/uploads/2015/06/ANGURIA-1.jpg");
  img_schermo = img_mela;
}

void draw()
{
  image(img_schermo, 0, 0, width, height);
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
   println(msg + " (" + msg.length());
   crono_ws = millis();
   String[] m1 = match(msg, "mela");
   if (m1 != null) 
   {  
     // If not null, then a match was found
     println("-----------------------");
     img_schermo = img_mela;
   }
   m1 = match(msg, "anguria");
   if (m1 != null) 
   {  
     // If not null, then a match was found
     println("111111111111111111111111");
     img_schermo = img_anguria;
   }
}

void openSpeechDetectorLink()
{
    // Avvio il link
    link(SpeechDetectorLink);
    crono_ws = millis();
    println("Launched link: " + SpeechDetectorLink);
}
