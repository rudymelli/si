import processing.video.*;

Movie film;
void setup()
{
  fullScreen(2);
  film = new Movie(this, "../../../../media/anim-1.mov");
  film.loop();
  film.speed(2);
}

void movieEvent(Movie m)
{
  m.read();
}

void draw()
{
  image(film, 0, 0, width, height);
  text(nfc(film.time(), 2), 20, 20);
}
