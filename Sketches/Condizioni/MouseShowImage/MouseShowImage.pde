float threshold=0.5;
PImage img;

void setup() {
    size(640,360);
    background(255);
    
    img = loadImage("traffic.jpg");
    threshold = width / 2;
}      


void draw() {
    background(200);
    if(mouseX > threshold)
      image(img, 0, 0, width, height);
      
    text("threshold=" + threshold, 20, 20);
    text("mouseX=" + mouseX, 20, 40);
}