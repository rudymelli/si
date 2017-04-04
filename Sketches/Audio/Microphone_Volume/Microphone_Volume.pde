/*
Modified version by Rudy Melli
of the example inside original Sound library processing.org

Be Careful with your speaker volume, you might produce a painful 
feedback. We recommend to wear headphones for this example.

*/

import processing.sound.*;

AudioIn input;
Amplitude rms;

FloatList inventory = new FloatList();

int scale=1;

void setup() {
    size(640,360);
    background(255);
        
    //Create an Audio input and grab the 1st channel
    input = new AudioIn(this, 0);
    
    // start the Audio Input
    input.start();
    
    // create a new Amplitude analyzer
    rms = new Amplitude(this);
    
    // Patch the input to an volume analyzer
    rms.input(input);
}      


void draw() {
    background(200);
    
    // adjust the volume of the audio input
    input.amp(map(mouseY, height, 0, 0.0, 1.0));
    
    // rms.analyze() return a value between 0 and 1. To adjust
    // the scaling and mapping of an ellipse we scale from 0 to 0.5
    float vol = rms.analyze();
    
    int inventory_len = 20;
    inventory.append(vol);
    if(inventory.size() > inventory_len)
      inventory.remove(0);
    
    //scale=int(map(vol, 0, 0.5, 1, 350));
    noStroke();
    
    fill(0,200,50);
    // We draw an ellispe coupled to the audio analysis
    //ellipse(width/2, height/2, 1*scale, 1*scale);
    
    rect(20, height * (1 - vol), 40, height * vol);
    text(vol, 20, 20);

    float vol_medio = inventory.sum() / inventory.size();
    rect(100, height * (1 - vol_medio), 40, height * vol_medio);
    text(vol_medio, 100, 20);    
}