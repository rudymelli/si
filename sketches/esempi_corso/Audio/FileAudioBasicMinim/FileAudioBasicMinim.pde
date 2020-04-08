import ddf.minim.*;

Minim minim;
AudioPlayer groove;

void setup()
{
  size(512, 200, P3D);

  minim = new Minim(this);
  groove = minim.loadFile("groove.mp3", 2048);
  groove.loop();
}

void draw()
{
}