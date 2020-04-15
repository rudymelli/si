import processing.sound.*;

AudioIn mic_in;
Amplitude rms;

FloatList inventory = new FloatList();

void setup() {
    size(640,360);
    background(0);
        
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

void draw() {
    background(0);
    // rms.analyze() return a value between 0 and 1. To adjust
    // the scaling and mapping of an ellipse we scale from 0 to 0.5
    float vol = rms.analyze();
    
    int inventory_len = 20;
    inventory.append(vol);
    if(inventory.size() > inventory_len)
      inventory.remove(0);
    float vol_medio = inventory.sum() / inventory.size();
    
    int lunghezza_linea = (int)map(vol_medio, 0, 1, 0, width);
    fill(0, 200, 100);
    rect(0, 0, lunghezza_linea, height);
    fill(255);
    text("vol=" + vol_medio, 10, 10);
}
