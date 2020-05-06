PImage img;

void setup()
{
  size(1280, 480);
  img = loadImage("../../../media/traffic.jpg");
}

void draw()
{
  float th = map(mouseY, 0, height, 0, 1);
  PImage img_th = img.copy();
  img_th.filter(THRESHOLD, th);
  image(img, 0, 0, width/2, height);
  image(img_th, width/2, 0, width/2, height);
  fill(255, 0, 0);
  text(th * 255, 10, 10);
  text(th, 10, 30);
}
