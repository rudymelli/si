import processing.video.*;

import javax.imageio.*;
import java.awt.image.*; 

import java.net.*; 
import java.io.*;

// This is the port we are sending to
int clientPortTx = 9100;  // Porta trasmissione 
int PortRx = 9100; // Porta ricezione
String clientIP = "192.168.1.150"; // IP of client to send video
// This is our object that sends UDP out
DatagramSocket ds; 
DatagramSocket ds_rx; 
// Capture object
Capture cam;

byte[] buffer = new byte[65536]; 
PImage video;

void setup() {
  size(320,240);
  // Setting up the DatagramSocket, requires try/catch
  try {
    ds = new DatagramSocket();
  } catch (SocketException e) {
    e.printStackTrace();
  }
  try {
    ds = new DatagramSocket(PortRx);
  } catch (SocketException e) {
    e.printStackTrace();
  } 
  video = createImage(320,240,RGB);  
  // Initialize Camera
  String []cameras = Capture.list();
  printArray(cameras);
  cam = new Capture(this, cameras[0]);
  cam.start();
}

void captureEvent( Capture c ) {
  c.read();
  // Whenever we get a new image, send it!
  broadcast(c);
}

void draw() {
  checkForImage();
  background(0);
  image(video,0,0);
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
  println("Sending datagram with " + packet.length + " bytes");
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
    ds.receive(p);
  } catch (IOException e) {
    e.printStackTrace();
  } 
  byte[] data = p.getData();

  println("Received datagram with " + data.length + " bytes." );

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
