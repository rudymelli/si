import processing.video.*;

Movie movie;
Capture video;
SIPLib siplib;

int threshold = 50;
int countdown = 0;

PImage image_source = null;

// 0 = video, 1 = webcam
int source_type = 0;

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
    movie = new Movie(this, "../../../../../media/A111_01.Singolo_ds.mp4");
    movie.loop();
  }
  else
  {
    video = new Capture(this, 640, 480);
    video.start();
  }
  siplib = new SIPLib(this, 640, 480, SegmentationMode);
  
  smooth();

  frameRate (30);  
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

  // Scrivo a video le informazioni di SIPLib
  fill(128);
  textSize(18);
  siplib.drawInfo(20, 20);

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
  siplib.analyze(c, threshold, 50, 0, 40, 50);
  image_source = siplib.imgCurrent;
}

void captureEvent(Capture c) {
  c.read();
  siplib.analyze(c, threshold, 50, 0, 40, 50);
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
  }
}
