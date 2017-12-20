import processing.video.*;

Capture video;

PShader crtScanlines;
PShader verticalSync;

PImage thisImage;

PImage flipImage;

boolean doShader;
boolean doVerticalSync;
boolean doVideo;

void setup() {
  //size (1920, 1080, P3D);
  size (640, 480, P3D);
  smooth(4);
  //fullScreen(P3D);//,0);
  crtScanlines = loadShader("CRT.glsl"); 
  verticalSync = loadShader("verticalSync.glsl"); 
  
  //crtScanlines.set("resolution", 1.0,1.0 );
  crtScanlines.set("resolution", float(width), float(height) );
  
  verticalSync.set("resolution", 1.0,1.0 );
  verticalSync.set("screenres", float(width), float(height) );
  
  thisImage = loadImage("finally.jpg");
  
  
  // This the default video input, see the GettingStartedCapture 
  // example if it creates an error
  video = new Capture(this, 640, 480);
  
  // Start capturing the images from the camera
  video.start();
  
  doShader = false;
  doVerticalSync = false;
  doVideo = false;
}

 
void draw () {
  surface.setTitle(nf(frameRate, 2, 2));
  background(150);
  crtScanlines.set("time", millis() / 10.0);
  if (doVideo){
  video.read(); // Read a new video frame
    image(video, 0, 0, width, height);
  } else {
    image(thisImage,0,0,width,height);
  }
  if (doShader){
    crtScanlines.set("iChannel0", get());
    shader(crtScanlines);
    if (doVideo){
      image(video, 0, 0, width, height);
    } else {
      image(thisImage,0,0,width,height);
    }
    //we don't want to use this shader anymore
    resetShader();
    
    // the image will be flipped upside down 
    // due to openGL origin in lower right, not upper left
    // this captures screen and redraws it upside down
    flipImage = get(0,0,width,height);
    pushMatrix();
      translate(0,height);
      scale( 1,-1);
      image(flipImage,0,0,width, height);
    popMatrix();
  }
  
  if (doVerticalSync){
    verticalSync.set("time", millis() / 1000.0);
    filter(verticalSync);
    resetShader();
  }
  
  fill(0);
  rect(5,5,320,55);
  fill(255);
  
  text (" press v to toggle video and image",10,15);
  text (" press s to toggle the vertical sync shader", 10,35);
  text (" press the mouse button to toggle the CRT shader",10,55);
}

void keyPressed(){
  if (key=='v' || key =='V'){
    if (doVideo == false) {
      doVideo = true;
    } else {
      doVideo = false;
    }
  }  
  if (key=='s' || key=='S'){
    if (doVerticalSync == false) {
      doVerticalSync = true;
    } else {
      doVerticalSync = false;
    }
  }
}

void mousePressed(){
   if (doShader){
     doShader = false;
   } else {
     doShader = true;
   }
}