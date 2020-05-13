import processing.video.*;

Movie movie;
Capture video;
SIPLib siplib;

int threshold = 50;
int countdown = 0;

PImage image_source = null;

PVector pt_schermo;

// Colore di tracciamento
color colTrack = -9558454;

// 0 = video, 1 = webcam
int source_type = 0;

// SegmentationMode:  
//                    0=ShadowSegmentation
//                    1=SingleDifference
//                    2=BackgroundSuppression
//                    3=BackgroundSuppression manuale
//                    4=ColorSegmentation
//                    5=LightSegmentation
int SegmentationMode = 4;

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
    video = new Capture(this, 640, 480);
    video.start();
  }
  siplib = new SIPLib(this, 640, 480, SegmentationMode);
  
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

  if(siplib.cogs.size() > 0)
  {
    strokeWeight(5);
    // Ipotizzo una sola persona presente
    // Disegno un cerchio giallo nel baricentro, un rettangolo minimo e la posizione dei piedi
    fill(255, 204, 0, 128);
    ellipse(siplib.cog.x, siplib.cog.y, 20, 20);
    noFill();
    stroke(0, 204, 255, 128);
    rect(siplib.boundingbox.x, siplib.boundingbox.y, siplib.boundingbox.width, siplib.boundingbox.height);
    fill(50, 204, 128, 128);
    ellipse(siplib.foots.x, siplib.foots.y, 20, 20);
    
    // Linea di congiungimento
    line(pt_schermo.x, pt_schermo.y, siplib.foots.x, siplib.foots.y);
    float d = distance(pt_schermo, siplib.foots);
    fill(0, 0, 255);
    text(d, 20, 400);
    
    if(d < 50)
    {
      stroke(255, 0, 0);
      strokeWeight(10);
      noFill();
      rect(0, 0, siplib.width, siplib.height);     
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
  siplib.analyze(c, threshold, 50, colTrack, 40, 50);
  image_source = siplib.imgCurrent;
}

void captureEvent(Capture c) {
  c.read();
  siplib.analyze(c, threshold, 50, colTrack, 40, 50);
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
