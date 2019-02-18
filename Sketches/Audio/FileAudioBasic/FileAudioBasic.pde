import processing.sound.*;

SoundFile soundfile;

void setup() {
    //Load a soundfile
    soundfile = new SoundFile(this, "vibraphon.aiff");
    // Play the file in a loop
    soundfile.loop();
}      


void draw() {
}