import gab.opencv.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.core.MatOfPoint2f;
import org.opencv.core.Point;
import org.opencv.core.Size;

import org.opencv.core.Mat;
import org.opencv.core.CvType;


ArrayList<PVector> points_mouse = new ArrayList<PVector>();

OpenCV opencv;
PImage src;
PImage card;
int cardWidth = 250;
int cardHeight = 350;

Contour contour;

void setup() {
  src = loadImage("cards.png");
  size(950, 749);
  opencv = new OpenCV(this, src);

  opencv.blur(1);
  opencv.threshold(120);

  contour = opencv.findContours(false, true).get(0).getPolygonApproximation();

  card = createImage(cardWidth, cardHeight, ARGB);  
  opencv.toPImage(warpPerspective(contour.getPoints(), cardWidth, cardHeight), card);
}

Mat getPerspectiveTransformation(ArrayList<PVector> inputPoints, int w, int h) {
  Point[] canonicalPoints = new Point[4];
  canonicalPoints[0] = new Point(w, 0);
  canonicalPoints[1] = new Point(0, 0);
  canonicalPoints[2] = new Point(0, h);
  canonicalPoints[3] = new Point(w, h);

  MatOfPoint2f canonicalMarker = new MatOfPoint2f();
  canonicalMarker.fromArray(canonicalPoints);

  Point[] points = new Point[4];
  for (int i = 0; i < 4; i++) {
    points[i] = new Point(inputPoints.get(i).x, inputPoints.get(i).y);
  }
  MatOfPoint2f marker = new MatOfPoint2f(points);
  return Imgproc.getPerspectiveTransform(marker, canonicalMarker);
}

Mat warpPerspective(ArrayList<PVector> inputPoints, int w, int h) {
  Mat transform = getPerspectiveTransformation(inputPoints, w, h);
  Mat unWarpedMarker = new Mat(w, h, CvType.CV_8UC1);    
  Imgproc.warpPerspective(opencv.getColor(), unWarpedMarker, transform, new Size(w, h));
  return unWarpedMarker;
}

void mousePressed()
{
  if(mousePressed)
  {
    points_mouse.add(new PVector(mouseX, mouseY));
    while(points_mouse.size() > 4)
      points_mouse.remove(0);
    if(points_mouse.size() == 4)
      opencv.toPImage(warpPerspective(points_mouse, cardWidth, cardHeight), card);
  }
}

void draw() {
  image(src, 0, 0);
  noFill(); 
  stroke(0, 255, 0); 
  strokeWeight(4);
  contour.draw();
  fill(255, 0);
  ArrayList<PVector> points = contour.getPoints();
  for (int i = 0; i < points.size(); i++) {
    text(i, points.get(i).x, points.get(i).y);
  }
  
  stroke(0,0,255);
  if(points_mouse.size() > 1)
  {
    int npt = points_mouse.size();
    for (int i = 0; i < npt; i++) {
      line(points_mouse.get(i).x, points_mouse.get(i).y, 
        points_mouse.get((i+1)%npt).x, points_mouse.get((i+1)%npt).y);
      text(i, points_mouse.get(i).x + 10, points_mouse.get(i).y);
    }
  }

  pushMatrix();
  translate(src.width, 0);
  image(card, 0, 0);
  popMatrix();
}