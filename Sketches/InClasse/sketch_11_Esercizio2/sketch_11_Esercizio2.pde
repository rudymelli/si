import processing.video.*;
Movie vid;
void setup()
{
  vid=new Movie(this, "fiori&acqua.mp4");
  vid.loop();
  vid.speed(2);
  vid.volume(1);
  fullScreen();
}
void draw()
{
  if(vid.available() == true)
  {
    vid.read();
    image(vid, 0, 0, width, height);
  }
}
