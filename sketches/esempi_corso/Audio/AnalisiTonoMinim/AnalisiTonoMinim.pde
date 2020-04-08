// Inspired by Minim's example AnalyzeSound
import ddf.minim.analysis.*;
import ddf.minim.*;

// Declare the processing minim variables 
Minim       minim;
FFT fft;
AudioInput device;

// Declare a scaling factor
int scale=5;

// Define how many FFT bands we want
int bands = 512;

// declare a drawing variable for calculating rect width
float r_width = 10;

// Create a smoothing vector
float[] sum;

// Create a smoothing factor
float smooth_factor = 0.2;

FloatList freq = new FloatList();

public void setup() {
  size(640, 360);
  background(255);
  
  minim = new Minim(this);
  device = minim.getLineIn();
  // create an FFT object that has a time-domain buffer 
  // the same size as jingle's sample buffer
  // note that this needs to be a power of two 
  // and that it means the size of the spectrum will be half as large.
  fft = new FFT( device.bufferSize(), device.sampleRate() );
  
  fft.forward( device.mix );
  bands = fft.specSize();
  sum = new float[bands];
  r_width = width / bands;
}      

public void draw() {
  // Set background color, noStroke and fill color
  background(125,255,125);
  fill(255,0,150);
  noStroke();

  // perform a forward FFT on the samples in jingle's mix buffer,
  // which contains the mix of both the left and right channels of the file
  fft.forward( device.mix );
  bands = fft.specSize();
  float maxf = 0, maxf_val = 0;
  int imax = 0;
  for (int i = 0; i < bands; i++) 
  {
    float f = fft.getBand(i);        // Intesità della banda di frequenza
    float fr = fft.indexToFreq(i);   // Frequenza della banda
    // Cerco la banda di frequenza di maggiore intensità 
    if(f > maxf)
    {
      maxf = f;
      imax = i;
      maxf_val = fr;
    } //<>//
    // smooth the FFT data by smoothing factor
    //sum[i] += (f - sum[i]) * smooth_factor;
    
    // draw the rects with a scale factor
    rect( i, height, i, height - f * 16 );
  }
  float f_hz = (maxf_val);// * 27343.75 - 900000000;
  freq.append(f_hz);
  if(freq.size() > 30)
    freq.remove(0);
  float f_smooth = freq.sum() / freq.size();
  
  fill(0);
  text("f=" + maxf_val, 20, 20);
  text("f_smooth=" + f_smooth, 20, 40);
}