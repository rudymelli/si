/**
 * This is a simple sound file player. Use the mouse position to control playback
 * speed, amplitude and stereo panning.
 */

import processing.sound.*;

SoundFile soundfile;

void setup() {
  size(640, 360);
  background(255);

  // Load a soundfile
  soundfile = new SoundFile(this, "nixon.aiff");
  // Play the file in a loop
  soundfile.loop();
}      


void draw() {
  // Map mouseX from 0.25 to 4.0 for playback rate. 1 equals original playback speed,
  // 2 is twice the speed and will sound an octave higher, 0.5 is half the speed and
  // will make the file sound one ocative lower.
  float playbackSpeed = map(mouseY, 0, height, 0.25, 4.0);
  soundfile.rate(playbackSpeed);
}
