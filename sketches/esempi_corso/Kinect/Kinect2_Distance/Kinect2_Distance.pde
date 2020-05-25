import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;

void setup() {
  size(640, 480, P3D);

  kinect = new KinectPV2(this);

  kinect.enableBodyTrackImg(true);
  kinect.enableDepthImg(true);
  kinect.enableDepthMaskImg(true);
  kinect.enableSkeletonDepthMap(true);
  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);

  kinect.init();
  
  frameRate(100);
}

int DisegnaDistanza(int i, int []depthRaw, float x, float y)
{
  int xi = (int)x;
  int yi = (int)y;
  int distance = 0;
  if(xi >= 0 && xi < 512 && yi >= 0 && yi < 424)
  {
    distance = depthRaw[512 * yi + xi];
    fill(0,0,255);
    text(i + ") " + distance, xi, yi);
  }
  //println(i + "(" + x + ", " + y + "):" + distance);
  return distance;
}

void draw()
{
  background(0);

  PImage imgBodyMask = kinect.getBodyTrackImage(); 
  //image(imgBodyMask, 0, 0, width, height);
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonDepthMap();

  //if(skeletonArray.size() > 0)
  //{
  //  PImage imgRgb = kinect.getDepthImage()/*.getColorImage()*/.copy();
  //  imgRgb.resize(imgBodyMask.width, imgBodyMask.height);
  //  imgBodyMask.filter(INVERT);
  //  imgRgb.mask(imgBodyMask);
  //  image(imgRgb, 0, 0, width, height);
  //}
  //else
  //  image(imgBodyMask, 0, 0, width, height);
  
  image(kinect.getColorImage(), 0, 0, width, height);
  
  int [] depthRaw = kinect.getRawDepthData();
  //individual JOINTS
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();
      //kinect.MapCameraPointToDepthSpace()
      // Passo alla funzione DisegnaDistanza la posizione della testa
      int d = DisegnaDistanza(i, depthRaw, joints[KinectPV2.JointType_Head].getX(), joints[KinectPV2.JointType_Head].getY());
    }
  }

  fill(255, 0, 0);
  text(frameRate, 50, 50);
}
