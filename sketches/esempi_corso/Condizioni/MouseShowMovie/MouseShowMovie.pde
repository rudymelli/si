import processing.video.*;

Movie movie;
Capture cam;

void setup() {
    size(640,360);
    background(255);
    
    movie =  new Movie(this, "E:\\@tti\\processing\\libraries\\video\\examples\\Movie\\Loop\\data\\transit.mov");
    movie.loop();
    
    cam = new Capture(this, 640, 480);
    cam.start();
}      

void movieEvent(Movie m)
{
  m.read();
}


void draw() {
    if(cam.available())
      cam.read();
    background(200);
    
    PImage img;
    if(mouseY > height/2)
      img = movie;
    else
      img = cam;
    
    if(mouseX > width/2)
      image(img, 0, 0, width, height);
      
    text("mouseX=" + mouseX, 20, 20);
    text("mouseY=" + mouseY, 20, 40);
}