// This sketch shows how to use the FFT class to analyze a stream  
// of sound. Change the variable bands to get more or less 
// spectral bands to work with. Smooth_factor determines how
// much the signal will be smoothed on a scale form 0-1.

import processing.sound.*;

// Declare the processing sound variables 
FFT fft;
AudioIn device;

// Declare a scaling factor
int scale=5;

// Define how many FFT bands we want
int bands = 512;

// declare a drawing variable for calculating rect width
float r_width;

// Create a smoothing vector
float[] sum = new float[bands];

// Create a smoothing factor
float smooth_factor = 0.2;

FloatList freq = new FloatList();

public void setup() {
  size(640, 360);
  background(255);
  
  // If the Buffersize is larger than the FFT Size, the FFT will fail
  // so we set Buffersize equal to bands
  device = new AudioIn(this, 0);
  device.start();
  // Calculate the width of the rects depending on how many bands we have
  r_width = width/float(bands);
  
  // Create and patch the FFT analyzer
  fft = new FFT(this, bands);
  fft.input(device);
}      

public void draw() {
  // Set background color, noStroke and fill color
  background(125,255,125);
  fill(255,0,150);
  noStroke();

  fft.analyze();
  float maxf = 0;
  int imax = 0;
  for (int i = 0; i < bands; i++) 
  {
    float f = fft.spectrum[i];
    if(f > maxf)
    {
      maxf = f;
      imax = i;
    }
    // smooth the FFT data by smoothing factor
    sum[i] += (f - sum[i]) * smooth_factor;
    
    // draw the rects with a scale factor
    rect( i*r_width, height, r_width, -sum[i]*height*scale );
  }
  float f_hz = (imax * 10000.0 / bands * 2.22222);// * 27343.75 - 900000000;
  freq.append(f_hz);
  if(freq.size() > 30)
    freq.remove(0);
  float f_smooth = freq.sum() / freq.size();
  
  text("f=" + maxf, 20, 20);
  text("f_smooth=" + f_smooth, 20, 40);
}