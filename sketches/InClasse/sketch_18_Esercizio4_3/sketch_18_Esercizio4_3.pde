import processing.video.*;

Movie film;
float speed = 1.0;
void setup()
{
  fullScreen(2);
  film = new Movie(this, "../../../../media/anim-1.mov");
  film.loop();
}

void movieEvent(Movie m)
{
  m.read();
}

void draw()
{
  image(film, 0, 0, width, height);
  text(nfc(speed, 2), 20, 20);
}

void keyPressed()
{
  if (key == '+' && speed < 10)
    speed = speed + 0.2;
  else if (key == '-' && speed > 0.2)
    speed = speed - 0.2;
  film.speed(speed);
}
