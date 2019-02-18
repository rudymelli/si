PImage img;  // Declare variable "a" of type PImage

void setup() {
  size(640, 360);
  img = loadImage("moonwalk.jpg");  // Load the image into the program  
}

void draw() 
{
  float soglia = (float)mouseY / height;
  image(img, 0, 0);
  filter(THRESHOLD, soglia);
  fill(0,255,0);
  text(soglia, 20, 20);
}