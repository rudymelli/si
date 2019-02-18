import processing.video.*;
Movie film;
boolean OnPlaying = false;

void setup()
{
  size(400, 300);
  film = new Movie(this, "C:\\Users\\melli\\Desktop\\Micro-dance.avi");
  film.loop();
  OnPlaying = true;
  film.speed(2.0);
}

void draw()
{
  if(film.available())
  {
    film.read();
  }
  
  if(OnPlaying && frameCount % 25 == 0)
  {
    film.speed(4.0 * mouseX / width);
  }

  if(OnPlaying && mouseY > height/2)
  {
    film.pause();
    OnPlaying = false;
  }
  else if(!OnPlaying && mouseY <= height/2)
  {
    film.loop();
    OnPlaying = true;
  }
    
  image(film, 0, 0, width, height);
  image(film, 100, 100, width/2, height/2);
}