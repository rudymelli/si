/*
Thomas Sanchez Lengeling.
 http://codigogenerativo.com/

 KinectPV2, Kinect for Windows v2 library for processing

 Skeleton color map example.
 Skeleton (x,y) positions are mapped to match the color Frame
 */

import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;


void setup() {
  size(640, 480, P3D);

  kinect = new KinectPV2(this);

  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);

  kinect.init();
  
  frameRate(100);
}

float dhand = 0;
float prev_x = 0;
boolean spazzolata = false;
void ControllaMano(float xmano, float ymano)
{
  if(frameCount % 100 == 0)
  {
    spazzolata = false;
    if(ymano > 0)
    {
      dhand = xmano - prev_x;
      if((xmano - prev_x) >= 250)
      {
        println("Spazzolata");
        spazzolata = true;
      }
    }
    prev_x = xmano;
  }
  
  if(spazzolata)
  {
    background(255, 0, 0);
  }

  //println("Distanza (m)=" + hz / 1000 + " DHand=" + dhand + " y=" + ymano);
}


void draw()
{
  background(0);

  image(kinect.getColorImage(), 0, 0, width, height);

  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d();

  //individual JOINTS
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();
      
      if(i == 0)
      {
        ControllaMano(joints[KinectPV2.JointType_HandRight].getX(), joints[KinectPV2.JointType_HandRight].getY());
      }
    }
  }

  fill(255, 0, 0);
  text(frameRate, 50, 50);
}

/*
Different hand state
 KinectPV2.HandState_Open
 KinectPV2.HandState_Closed
 KinectPV2.HandState_Lasso
 KinectPV2.HandState_NotTracked
 */
void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    fill(0, 255, 0);
    break;
  case KinectPV2.HandState_Closed:
    fill(255, 0, 0);
    break;
  case KinectPV2.HandState_Lasso:
    fill(0, 0, 255);
    break;
  case KinectPV2.HandState_NotTracked:
    fill(255, 255, 255);
    break;
  }
}