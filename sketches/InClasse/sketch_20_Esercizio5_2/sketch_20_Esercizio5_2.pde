import processing.sound.*;
import processing.video.*;

AudioIn mic_in;
Amplitude rms;
Movie movie;
FloatList inventory = new FloatList();
boolean movie_is_playing = false;
int tempo_speech = 0;

void setup() {
    size(640,360);
    background(255);
    
    // Load and play the video in a loop
    movie = new Movie(this, "../../../../media/Micro-dance.avi");    
        
    //Create an Audio input and grab the 1st channel
    mic_in = new AudioIn(this, 0);
    
    // start the Audio Input
    mic_in.start();
    
    // create a new Amplitude analyzer
    rms = new Amplitude(this);
    
    // Patch the input to an volume analyzer
    rms.input(mic_in);
    mic_in.amp(1.0);
}      

void movieEvent(Movie m) {
  m.read();
}

void draw() {
    // rms.analyze() return a value between 0 and 1. To adjust
    // the scaling and mapping of an ellipse we scale from 0 to 0.5
    float vol = rms.analyze();
    
    int inventory_len = 20;
    inventory.append(vol);
    if(inventory.size() > inventory_len)
      inventory.remove(0);
    float vol_medio = inventory.sum() / inventory.size();

    float soglia_volume = 0.005;
    if(vol_medio > soglia_volume)
    {
      tempo_speech = millis();
      if(!movie_is_playing)
      {
        movie.loop();
        movie_is_playing = true;
      }
    }
    else if(vol_medio < soglia_volume && movie_is_playing && (millis() - tempo_speech) > 5000)
    {
      movie.pause();
      movie_is_playing = false;
    }
    
    image(movie, 0, 0, width, height);
    text("tempo=" + millis() + " vol=" + vol_medio + " " + movie_is_playing, 10, 10);
}
