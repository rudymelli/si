import processing.video.*;

import javax.imageio.*;
import java.awt.image.*; 

import java.net.*; 
import java.io.*;

import java.util.concurrent.*;

// This is the port we are sending to
int clientPortTx = 9101;  // Porta trasmissione 
int PortRx = 9100; // Porta ricezione
// Come trovare il proprio ip interno alla rete: https://lifehacker.com/how-to-find-your-local-and-external-ip-address-5833108
String clientIP = "192.168.1.200"; // IP of client to send video
// This is our object that sends UDP out
DatagramSocket ds_tx; 
DatagramSocket ds_rx; 
// Capture object
Capture cam_locale;

byte[] buffer = new byte[1920*1080*3*2]; 
PImage video_rx, cam_remota;
int frameShown = 0;
int frameReceived = 0;

int width_stream = 640;
int height_stream = 480;

void setup() {
  size(640, 480);
  // Setting up the DatagramSocket, requires try/catch
  try {
    ds_tx = new DatagramSocket();
  } catch (SocketException e) {
    e.printStackTrace();
  }
  try {
    ds_rx = new DatagramSocket(PortRx);
    ds_rx.setSoTimeout(1000);
    ds_rx.setReceiveBufferSize(buffer.length);
  } catch (SocketException e) {
    e.printStackTrace();
  } 
  video_rx = createImage(width_stream, height_stream, RGB);  
  cam_remota = createImage(width_stream, height_stream, RGB);  
  // Initialize Camera
  //String []cameras = Capture.list();
  //printArray(cameras);
  cam_locale = new Capture(this, width_stream, height_stream);
  cam_locale.start();
  
  thread("runCheckImages");
}

void runCheckImages()
{
  while(true)
  {
    if(checkForImage())
      cam_remota = video_rx.copy();
    delay(40);
  }
}

void draw() {
  if(cam_locale.available())
  {
    cam_locale.read();
    
    // Qui inserire le proprie modifiche/effetti/....
    
    // Whenever we get a new image, send it!
    broadcast(cam_locale);
  }
  if(frameShown < frameReceived)
  {
    background(0);
    image(cam_remota, 0, 0, width, height);
    // Commentare la riga dopo per non visualizzare la webcam locale
    image(cam_locale, 0, 0, 100, 80);
  }
}


// Function to broadcast a PImage over UDP
// Special thanks to: http://ubaa.net/shared/processing/udp/
// (This example doesn't use the library, but you can!)
void broadcast(PImage img) {
  // We need a buffered image to do the JPG encoding
  BufferedImage bimg = new BufferedImage( img.width,img.height, BufferedImage.TYPE_INT_RGB );

  // Transfer pixels from localFrame to the BufferedImage
  img.loadPixels();
  bimg.setRGB( 0, 0, img.width, img.height, img.pixels, 0, img.width);

  // Need these output streams to get image as bytes for UDP communication
  ByteArrayOutputStream baStream	= new ByteArrayOutputStream();
  BufferedOutputStream bos		= new BufferedOutputStream(baStream);

  // Turn the BufferedImage into a JPG and put it in the BufferedOutputStream
  // Requires try/catch
  try {
    ImageIO.write(bimg, "jpg", bos);
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
  // Get the byte array, which we will send out via UDP!
  byte[] packet = baStream.toByteArray();

  // Send JPEG data as a datagram
  println("PC1: Sending datagram with " + packet.length + " bytes");
  try {
    ds_tx.send(new DatagramPacket(packet,packet.length, InetAddress.getByName(clientIP),clientPortTx));
  } 
  catch (Exception e) {
    e.printStackTrace();
  }
}

boolean checkForImage() {
  DatagramPacket p = new DatagramPacket(buffer, buffer.length); 
  try {
    ds_rx.receive(p);
    byte[] data = p.getData();
  
    println("PC1: Received datagram with " + data.length + " bytes." );
  
    // Read incoming data into a ByteArrayInputStream
    ByteArrayInputStream bais = new ByteArrayInputStream( data );
  
    // We need to unpack JPG and put it in the PImage video
    video_rx.loadPixels();
    try {
      // Make a BufferedImage out of the incoming bytes
      BufferedImage img = ImageIO.read(bais);
      // Put the pixels into the video PImage
      img.getRGB(0, 0, video_rx.width, video_rx.height, video_rx.pixels, 0, video_rx.width);
    } catch (Exception e) {
      e.printStackTrace();
    }
    // Update the PImage pixels
    video_rx.updatePixels(); 
    frameReceived++;
    return true;
  } catch (IOException e) {
    e.printStackTrace();
    return false;
  } 
}
