// Da usare in concomitanza con la webpage:
// http://interattivi.altervista.org/si_wordpress/speech.html
import websockets.*;

WebsocketServer ws;

void setup(){
  size(200,200);
  ws= new WebsocketServer(this,8080,"/");
}

void draw(){
  background(0);
}

void webSocketServerEvent(String msg){
 println(msg);
}