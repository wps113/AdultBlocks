import ddf.minim.*;
import org.openkinect.processing.*;

// The kinect stuff is happening in another class
KinectTracker tracker;
Kinect kinect;

/* CONSTANTS */
//BLOCK SHAPE STATE CONSTANTS
int NO_BRICKS = 0;
int ONE_BRICK = 1;
int TWO_BRICKS_VERTICAL = 2;
int TWO_BRICKS_HORIZONTAL = 3;
int THREE_BRICKS_VERTICAL = 4;
int THREE_BRICKS_HORIZONTAL = 5;
int THREE_BRICKS_L = 6;

int CUBE_SIZE = 40;

//Colors
color BLACK = color(0);
color ONE_COLOR = color(96, 252, 255); //torquise
color TWO_V_COLOR = color(48,186,34); //Medium Vibrant Green
color TWO_H_COLOR  = color(42,68,153);  // Lovely Purple Blue
color THREE_V_COLOR = color(28,224,7); //Bright Green
color THREE_H_COLOR = color(28,68,200); //Vibrant Blue
color THREE_L_COLOR = color(208, 0, 0); //Firey Red


/* Global Vars */

int status;
Minim minim;
  
AudioPlayer[] songs = new AudioPlayer[7];

void setup() {
  size(512, 424);
  kinect = new Kinect(this);
  tracker = new KinectTracker();
  minim = new Minim(this);
  songs[NO_BRICKS] = minim.loadFile("abc.wav");
  songs[ONE_BRICK] = minim.loadFile("one.wav");
  songs[TWO_BRICKS_VERTICAL] = minim.loadFile("takes2(2v).wav");
  songs[TWO_BRICKS_HORIZONTAL] = minim.loadFile("2ofus(2h).wav");
  songs[THREE_BRICKS_VERTICAL] = minim.loadFile("3Am(3V).wav");
  songs[THREE_BRICKS_HORIZONTAL] = minim.loadFile("3days(3h).wav");
  songs[THREE_BRICKS_L]= minim.loadFile("l.wav");
}


void draw() {
  fill(255);
  // Run the tracking analysis
  tracker.track();
  // Show the image

  status = checkForStatus();
  if (status == NO_BRICKS) {
    tracker.display(BLACK);
    swapSongs(NO_BRICKS);
  } 
  else if (status == ONE_BRICK) {
    tracker.display(ONE_COLOR);
    swapSongs(ONE_BRICK);
  } else if (status == TWO_BRICKS_VERTICAL) {
    tracker.display(TWO_V_COLOR);
    swapSongs(TWO_BRICKS_VERTICAL);
  } else if (status == TWO_BRICKS_HORIZONTAL) {
    tracker.display(TWO_H_COLOR);
    swapSongs(TWO_BRICKS_HORIZONTAL);
  } else if (status == THREE_BRICKS_VERTICAL) {
    tracker.display(THREE_V_COLOR);
    swapSongs(THREE_BRICKS_VERTICAL);
  } else if (status == THREE_BRICKS_HORIZONTAL) {
    tracker.display(THREE_H_COLOR);
    swapSongs(THREE_BRICKS_HORIZONTAL);
  } else if (status == THREE_BRICKS_L) {
    tracker.display(THREE_L_COLOR);
    swapSongs(THREE_BRICKS_L);
  }
}

int checkForStatus() {
  tracker.track();
  int deskHeight = tracker.getDeskPixel();
  int topPixel = tracker.getTopPixel();
  int left = tracker.getLeftPixel();
  int right = tracker.getRightPixel();
  
  int blockHeight = deskHeight - topPixel;
  int blockWidth = right - left;
  
  println("width: " + blockWidth + ", " + "hieght: " + blockHeight);
  if (blockHeight >= CUBE_SIZE && (blockHeight < (CUBE_SIZE *2))) { //One Cube High
    if (blockWidth >= CUBE_SIZE) { //one cube or more
      if (blockWidth >= CUBE_SIZE * 2) { // two or more cubes
        if (blockWidth >= CUBE_SIZE * 3) {
          return THREE_BRICKS_HORIZONTAL;
        } 
        else {
          return TWO_BRICKS_HORIZONTAL;
        }
      } 
      else {
          return ONE_BRICK ;
      }
    } 
    else {
      return NO_BRICKS;
    }
  } 
  else if (blockHeight >= (2* CUBE_SIZE) && (blockHeight < (CUBE_SIZE * 3))) {//TWO CUBES high
     if (blockWidth > CUBE_SIZE * 1.5) { //More than one cube in horizontal plane
       return THREE_BRICKS_L;
     } else {
       return TWO_BRICKS_VERTICAL;
     }
  } 
  else if (blockHeight >= 3 * CUBE_SIZE) {
     return THREE_BRICKS_VERTICAL;
  }
  else return NO_BRICKS;
}

void swapSongs(int songNum) {
  if (!songs[songNum].isPlaying()) { //only have to do this if desired song is not playing
    for (int i = 0; i < songs.length; i++) {
      songs[i].pause(); //pause all songs
    }
    songs[songNum].loop(); //play desired song
  }
}
