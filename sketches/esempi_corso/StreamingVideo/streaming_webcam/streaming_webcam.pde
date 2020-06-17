import processing.video.*;

import javax.imageio.*;
import java.awt.image.*; 
import java.io.*;
import java.net.*;

import processing.net.*;

int width_stream = 640;
int height_stream = 480;

Server _stream;
int PortStreaming = 9100; // Porta ricezione

Capture cam_locale;
String _boundary = "MelliStream";

void setup() {
  size(640, 480);
  _stream = new Server(this, PortStreaming);
  fill(0);
  text("Connect with 'IPCapture library' to http://" + _stream.ip() + ":" + PortStreaming, 20, height/2);

  // Initialize Camera
  //String []cameras = Capture.list();
  //printArray(cameras);
  cam_locale = new Capture(this, width_stream, height_stream);
  cam_locale.start();
  
  thread("waitnewconnection");
}

void draw() {
  if(cam_locale.available())
  {
    cam_locale.read();
    
    // Qui inserire le proprie modifiche/effetti/....
    
    broadcast(cam_locale);
  }
}


void waitnewconnection()
{
  while(true)
  {
    // Get the next available client
    Client thisClient = _stream.available();
    // If the client is not null, and says something, display what it said
    if (thisClient !=null) {
      String ip = thisClient.ip();
      println("NEW connection from " + ip);
      writeHeader(_stream, _boundary);
      while(thisClient.active())
      {
        delay(500);
      }
      println("Connection ENDS from " + ip);
    }
  }
}

void writeHeader(Server/*OutputStream*/ stream, String boundary)// throws IOException 
{
    stream.write(("HTTP/1.0 200 OK\r\n" +
            "Connection: close\r\n" +
            "Max-Age: 0\r\n" +
            "Expires: 0\r\n" +
            "Cache-Control: no-store, no-cache, must-revalidate, pre-check=0, post-check=0, max-age=0\r\n" +
            "Pragma: no-cache\r\n" + 
            "Content-Type: multipart/x-mixed-replace; " +
            "boundary=" + boundary + "\r\n" +
            "\r\n" +
            "--" + boundary + "\r\n").getBytes());
}

void writeFrame(Server/*OutputStream*/ stream, byte[] packet, String boundary)// throws IOException 
{
  try {
    //println("PC: Sending frame with " + packet.length + " bytes");
    stream.write(("Content-type: image/jpeg\r\n" +
                "Content-Length: " + packet.length + "\r\n" +
                "\r\n").getBytes());
    stream.write(packet);
    stream.write(("\r\n--" + boundary + "\r\n").getBytes());
  } 
  catch (Exception e) {
    e.printStackTrace();
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
  writeFrame(_stream, packet, _boundary);
}
