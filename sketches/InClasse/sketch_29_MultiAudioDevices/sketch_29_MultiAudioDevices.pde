import processing.sound.*;

AudioIn in1, in0;
Sound s1, s0;
Amplitude rms0, rms1;

void setup() {
  printArray(Sound.list());
  // Create a Sound object and select the second sound device (device ids start at 0) for input
  s0 = new Sound(this);
  s0.inputDevice(3);

  // Now get the first audio input channel from that sound device (ids again start at 0)
  in0 = new AudioIn(this, 0);
  in0.start();
  // create a new Amplitude analyzer
  rms0 = new Amplitude(this);
  rms0.input(in0);
  
  s1 = new Sound(this);
  s1.inputDevice(4);

  // Now get the first audio input channel from that sound device (ids again start at 0)
  in1 = new AudioIn(this, 1);
  in1.start();
  // create a new Amplitude analyzer
  rms1 = new Amplitude(this);
  rms1.input(in1);  
}

void draw()
{
  background(0);
 float vol0 = rms0.analyze();
 float vol1 = rms1.analyze();
 
 text(vol0, 10, 10);
 text(vol1, 10, 30);
}
