import processing.video.*;

Movie movie;
Capture video;
SIPLib siplib;

int threshold = 50;
int minarea = 400;
int countdown = 0;

PImage image_source = null;

PVector pt_schermo;

// Colore di tracciamento
color colTrack = -9558454;

// 0 = video, 1 = webcam
int source_type = 0;

Rectangle rect_zone = new Rectangle(50, 120, 50, 50); 

// SegmentationMode:  
//                    0=ShadowSegmentation
//                    1=SingleDifference
//                    2=BackgroundSuppression
//                    3=BackgroundSuppression manuale
//                    4=ColorSegmentation
//                    5=LightSegmentation
int SegmentationMode = 2;

void setup()
{
  String[] cameras = Capture.list();
  printArray(cameras);
  size(1280, 960);
  if(source_type == 0)
  {
    movie = new Movie(this, "../../../../../media/A111_04.DoppioVeloce_ds.mp4");
    movie.loop();
  }
  else
  {
    video = new Capture(this, 320, 240);
    video.start();
  }
  siplib = new SIPLib(this, 320, 240, SegmentationMode);
  siplib.closingPass = 2;
  
  pt_schermo = new PVector(320, 480);
  
  smooth();

  frameRate (30);  
}

float distance(PVector pt1, PVector pt2)
{
  return (sqrt(pow(pt1.x - pt2.x, 2) + pow(pt1.y - pt2.y, 2)));
}


void draw() {
  // Visualizzazione
  background(0);
  if(image_source != null)
    image(image_source, 0, 0, siplib.width, siplib.height);

  // Immagine dello sfondo memorizzato
  if(siplib.imgReference != null)
    image(siplib.imgReference, 0, siplib.height, siplib.width, siplib.height);
  
  if(siplib.imgSegment != null)
    image(siplib.imgSegment, siplib.width, 0, siplib.width, siplib.height);

  // Get mouse Color
  if(SegmentationMode >= 4)
  {
    if(mousePressed)
    {
      //colTrack = Color.HSBtoRGB((float)mouseX / width,1,1);
      colTrack = image_source.get(mouseX, mouseY);
      println("col=" + colTrack + " hue=" + hue(colTrack));
    }
    fill(colTrack);
    rect(0, siplib.height-50, 50, 50);
  }
  
  // Scrivo a video le informazioni di SIPLib
  fill(128);
  textSize(18);
  siplib.drawInfo(20, 20);

  // Posizione schermo
  fill(0, 0, 255, 128);
  ellipse(pt_schermo.x, pt_schermo.y, 35, 35);
  
  noFill();
  stroke(255, 0, 0, 255);
  rect(rect_zone.x, rect_zone.y, rect_zone.width, rect_zone.height);
  float rect_zone_motion = siplib.GetRectMotion(rect_zone);
  text(rect_zone_motion, rect_zone.x, rect_zone.y - 1);
  if(rect_zone_motion > 0.05)
  {
    fill(255, 0, 0, 100);
    rect(rect_zone.x, rect_zone.y, rect_zone.width, rect_zone.height); 
  }
  
  
  strokeWeight(5);
  // Tracking multiplo
  for(int i=0; i<siplib.blobs.size(); i++)
  {
    noFill();
    color ci = siplib.GetIndexColor(i);
    Contour contour = siplib.blobs.get(i);
    Rectangle r = contour.getBoundingBox();
    // Disegno un cerchio nel baricentro, il rettangolo minimo e la posizione dei piedi
    fill(ci, 128);
    stroke(ci, 128);
    ellipse((int)r.getCenterX(), (int)r.getCenterY(), 5, 5);
    noFill();
    rect(r.x, r.y, r.width, r.height);
    text(i, r.x, r.y - 1);
    fill(ci, 200);
    PVector ptfoot = siplib.GetFootsPoint(r);
    ellipse(ptfoot.x, ptfoot.y, 7, 7);
    
    // Linea di congiungimento
    line(pt_schermo.x, pt_schermo.y, ptfoot.x, ptfoot.y);
    float d = distance(pt_schermo, ptfoot);
    
    text(i + " - " + (int)d, r.x, r.y - 1);
    
    noFill();
    if(d < 50)
    {
      stroke(255, 0, 0, 100);
      strokeWeight(10);
      rect(r.x, r.y, r.width, r.height);   
    }
  }

  noFill();
  if(countdown > 0)
  {
    stroke(0,0,255);
    strokeWeight(10);
    rect(0,0,width,height);
    countdown--;
  }
  noStroke();
}

void movieEvent(Movie c) {
  c.read();
  siplib.analyze(c, threshold, minarea, colTrack, 40, 50);
  image_source = siplib.imgCurrent;
}

void captureEvent(Capture c) {
  c.read();
  siplib.analyze(c, threshold, minarea, colTrack, 40, 50);
  image_source = siplib.imgCurrent;
}

void keyPressed()
{
  if(key == '+')
    threshold += 10;
  if(key == '-')
    threshold -= 10;
  if(key == 'w')
    threshold += 1;
  if(key == 'q')
    threshold -= 1;
  if(threshold < 0)
    threshold = 0;
  if(threshold > 255)
    threshold = 255;
  if(key == ' ')
    siplib.storeBackground();
  countdown = 30;
}

void mousePressed()
{
  if (mouseButton == LEFT)
  {
    pt_schermo = new PVector(mouseX, mouseY);
  }
}
