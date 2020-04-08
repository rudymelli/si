import ddf.minim.analysis.*;
import ddf.minim.*;

// Declare the processing minim variables 
Minim       minim;
AudioInput device;

FloatList inventory = new FloatList();

int scale=1;

void setup() {
    size(640,360);
    background(255);
        
    minim = new Minim(this);
    device = minim.getLineIn();
}      


void draw() {
    background(200);
    
    // adjust the volume of the audio input
    device.setVolume(map(mouseY, height, 0, 0.0, 1.0));
    
    float vol = device.mix.level();
    
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