import processing.sound.*;

SinOsc sine;

float freq=440;
float amp=0.5;

void setup() {
    sine = new SinOsc(this);
    //Start the Sine Oscillator. 
    sine.play();
    sine.freq(freq);
    sine.amp(amp);
}

void draw()
{
}