// Daniel Shiffman
// Tracking the average location beyond a given depth threshold
// Thanks to Dan O'Sullivan

// https://github.com/shiffman/OpenKinect-for-Processing
// http://shiffman.net/p5/kinect/

class KinectTracker {

  // Depth threshold
  static final int thresholdStart = 400;
  static final int thresholdEnd = 425;
  
  //Key Pixels
  int recordBottomPixel = -1;
  int recordTopPixel = -1;
  int recordLeftPixel = -1;
  int recordRightPixel = -1;
 
  // Depth data
  int[] depth;

  // What we'll show the user
  PImage display;
  
  //kinect class
  
  //KinectTracker(PApplet pa) {
    
  //  //enable kinect
  //  kinect = new kinect(pa);
  //  kinect.initDepth();
  //  kinect.initDevice();
  //  // Make a blank image
  //  display = createImage(kinect.depthWidth, kinect.depthHeight, RGB);
  //}
  
    //Kinect class
   KinectTracker() {
    // This is an awkard use of a global variable here
    // But doing it this way for simplicity
    kinect.initDepth();
    kinect.enableMirror(true);
    // Make a blank image
    display = createImage(kinect.width, kinect.height, RGB);
  }
  
  void track() {
    // Get the raw depth as array of integers
   depth = kinect.getRawDepth();
   recordBottomPixel = -1;
   recordTopPixel = -1;
   recordLeftPixel = -1;
   recordRightPixel = -1;

    // Being overly cautious here
    if (depth == null) return;
    int count = 0;
    for (int x = 0; x < kinect.width; x++) {
      for (int y = 0; y < kinect.height; y++) {
        // Mirroring the image
        int offset = kinect.width - x - 1 + y * kinect.width;
        // Grabbing the raw depth
        int rawDepth = depth[offset];

        // Testing against threshold
        if (rawDepth > thresholdStart && rawDepth < thresholdEnd) {
          count++;
          if (recordRightPixel < 0 || x > recordRightPixel) {
            recordRightPixel = x;
          }
          else if (recordLeftPixel < 0 || x < recordLeftPixel) {
            recordLeftPixel = x;
          }
          if (recordTopPixel < 0 || y > recordTopPixel) {
            recordTopPixel = y;
          } else if (recordBottomPixel < 0 || y < recordBottomPixel) {
            recordBottomPixel = y;
          } 
        }
      }
    }
    // As long as we found something
    if (count != 0) {
      //do x
    }
  }


  void display(color setColor) {
    PImage img = kinect.getDepthImage();

    // Being overly cautious here
    if (depth == null || img == null) return;

    // Going to rewrite the depth image to show which pixels are in threshold
    // A lot of this is redundant, but this is just for demonstration purposes
    display.loadPixels();
    for (int x = 0; x < kinect.width; x++) {
      for (int y = 0; y < kinect.height; y++) {
        // mirroring image
        int offset = (kinect.width - x - 1) + y * kinect.width;
        // Raw depth
        int rawDepth = depth[offset];
        int pix = x + y*display.width;
        if (rawDepth > thresholdStart && rawDepth < thresholdEnd) {
        //if (rawDepth > 0 && rawDepth < threshold) {
          // A red color instead
          display.pixels[pix] = color(setColor);
        } else {
          display.pixels[pix] = img.pixels[offset];
        }
      }
    }
    display.updatePixels();

    // Draw the image
    image(display, 0, 0);
  }
  
  
  int getDeskPixel() {
    return recordTopPixel;
  }
  
  int getTopPixel() {
    return recordBottomPixel;
  }
  
  int getLeftPixel() {
    return recordLeftPixel;
  }
  int getRightPixel() {
    return recordRightPixel;
  }
}
