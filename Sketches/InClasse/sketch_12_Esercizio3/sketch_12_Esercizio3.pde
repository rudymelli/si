import processing.video.*;
Movie vid;
float vid_speed = 1;
void setup()
{
  vid=new Movie(this, "folla.mp4");
  vid.loop();
  vid.speed(vid_speed);
  vid.volume(1);
  fullScreen();
}
void draw()
{
  if(vid.available() == true)
  {
    vid.read();
    image(vid, 0, 0, width, height);
    textSize(24);
    text(vid_speed, 10, 10);
  }
}
void keyPressed()
{
  if(key == '+' && vid_speed < 10)
  {
    vid_speed = vid_speed * 1.2;
    vid.speed(vid_speed);
  }
  else if(key == '-' && vid_speed > 0.1)
  {
    vid_speed = vid_speed / 1.2;
    vid.speed(vid_speed);
  }
}
