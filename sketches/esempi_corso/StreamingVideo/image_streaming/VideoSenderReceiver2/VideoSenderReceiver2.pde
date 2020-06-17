import processing.video.*;

import javax.imageio.*;
import java.awt.image.*; 

import java.net.*; 
import java.io.*;

// This is the port we are sending to
int clientPortTx = 9100;  // Porta trasmissione 
int PortRx = 9101; // Porta ricezione
// Come trovare il proprio ip interno alla rete: https://lifehacker.com/how-to-find-your-local-and-external-ip-address-5833108
String clientIP = "127.0.0.1"; // IP of client to send video
// This is our object that sends UDP out
DatagramSocket ds; 
//DatagramSocket ds_rx; 
// Capture object
Capture cam;

byte[] buffer = new byte[65536]; 
PImage video;

void setup() {
  size(320,240);
  // Setting up the DatagramSocket, requires try/catch
  //try {
  //  ds = new DatagramSocket();
  //} catch (SocketException e) {
  //  e.printStackTrace();
  //}
  try {
    ds = new DatagramSocket(PortRx);
    ds.setSoTimeout(1000);
  } catch (SocketException e) {
    e.printStackTrace();
  } 
  video = createImage(320,240,RGB);  
  // Initialize Camera
  String []cameras = Capture.list();
  printArray(cameras);
  cam = new Capture(this, cameras[28]);
  cam.start();
}

void draw() {
  if(cam.available())
  {
    cam.read();
    
    // Qui inserire le proprie modifiche/effetti/....
    
    // Whenever we get a new image, send it!
    broadcast(cam);
  }
  checkForImage();
  background(0);
  image(video,0,0);
  image(cam, 0, 0, 100, 80);
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
  ByteArrayOutputStream baStream  = new ByteArrayOutputStream();
  BufferedOutputStream bos    = new BufferedOutputStream(baStream);

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
  println("PC2: Sending datagram with " + packet.length + " bytes");
  try {
    ds.send(new DatagramPacket(packet,packet.length, InetAddress.getByName(clientIP),clientPortTx));
  } 
  catch (Exception e) {
    e.printStackTrace();
  }
}

void checkForImage() {
  DatagramPacket p = new DatagramPacket(buffer, buffer.length); 
  try {
    //ds.setSoTimeout(1000);
    ds.receive(p);
  } catch (IOException e) {
    e.printStackTrace();
  } 
  byte[] data = p.getData();

  println("PC2: Received datagram with " + data.length + " bytes." );

  // Read incoming data into a ByteArrayInputStream
  ByteArrayInputStream bais = new ByteArrayInputStream( data );

  // We need to unpack JPG and put it in the PImage video
  video.loadPixels();
  try {
    // Make a BufferedImage out of the incoming bytes
    BufferedImage img = ImageIO.read(bais);
    // Put the pixels into the video PImage
    img.getRGB(0, 0, video.width, video.height, video.pixels, 0, video.width);
  } catch (Exception e) {
    e.printStackTrace();
  }
  // Update the PImage pixels
  video.updatePixels();
}
