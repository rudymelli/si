import processing.video.*;

Movie film;
void setup()
{
  size(640,480);
  film = new Movie(this, "../../../../media/anim-1.mov");
  film.play();
  film.pause();
}

void movieEvent(Movie m)
{
  m.read();
}

void draw()
{
  float index = map(mouseX, 0, width, 0, film.duration());
  film.jump(index);
  film.play();
  film.pause();
  image(film, 0, 0, width, height);
}
