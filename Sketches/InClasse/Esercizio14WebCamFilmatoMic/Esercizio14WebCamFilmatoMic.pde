import processing.sound.*;
import processing.video.*;

Movie filmato;
Capture camera;

AudioIn microfono;
Amplitude livello;

int decisore = 0;             //0=filmato, 1=camera
float volume_precedente = 0;  // Valore del volume al frame precedente

void setup()
{
  //size(640, 360);
  fullScreen();
  
  // Apertura webcam
  String[] cameralist = Capture.list();
  printArray(cameralist);
  camera = new Capture(this, cameralist[0]);
  camera.start();
  
  // Apertura microfono e misuratore di livello
  microfono = new AudioIn(this, 0);
  microfono.start();
  livello = new Amplitude(this);
  livello.input(microfono);
  
  // Apertura file video
  filmato = new Movie(this, "C:\\Users\\melli\\odrive\\Google Drive\\Rudy\\Brera\\Corso_Downloads\\media\\Micro-dance.avi");
  filmato.loop();
}

void draw()
{
  // Aggiornamento frame del filmato e della webcam
  if(filmato.available())
    filmato.read();
  if(camera.available())
    camera.read();
  
  // Lettura del valore del volume del microfono
  float volume = livello.analyze();
  println(volume);
  
  // Sogli del volume da impostare in base alla variazione rilevata dal proprio microfono
  float soglia_volume = 0.1;
  // Condizione di cambio visualizzazione tra filmato e webcam 
  if(volume_precedente < soglia_volume/2 && volume > soglia_volume)
    decisore = 1 - decisore; // decisore = (decisore + 1) % 2;
  volume_precedente = volume;
  
  // Visualizzo webcam o filmato in base al valore di decisore
  if(decisore == 0)
    image(filmato, 0, 0, width, height);
  else
    image(camera, 0, 0, width, height);
  
  // Visualizzo a video il volume del microfono per debug
  textSize(20);
  fill(255, 0, 255);
  text(volume, 30, 30);
}