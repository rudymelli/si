import websockets.*;

WebsocketServer ws;

void setup(){
  size(200,200);
  ws= new WebsocketServer(this,8080,"/");
}

void draw(){
}

void webSocketServerEvent(String msg)
{
 println(msg);
 if(msg == "rosso")
 {
   background(255, 0, 0);
 }
 else
 {
   background(0);
 }
}