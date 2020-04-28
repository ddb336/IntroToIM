
// Rotating rectangle class

class myRect {

  float x, y, xs, ys;    // x and y are the position of the rectance, xs and ys are the x and y size 
  float r, rv, ra;       // r is the rotation, rv is rotation velocity and ra is rotation acceleration
  int d;                 // the direction the rectangle rotates
  color c;               // color of the rectangle

  myRect(float _x, float _y, float _xs, float _ys, color _c)        // constructor class
  {
    this.x = _x;              // Sets all the variables
    this.y = _y;
    this.xs = _xs;
    this.ys = _ys;
    this.r = random(-2*PI, 2*PI);    // sets rotation to a value between -2pi and 2pi
    this.rv = 0;                     
    this.ra = 0;
    this.c = _c;
    if(random(1) > 0.5) d = -1;       // d is -1 or 1 (direction)
    else d = 1;
  }
  
  void update()
  {
    rv += ra;     // add acceleration to velocity
    r += rv;      // add velocity to rotation
    ra = 0;       // reset acceleration
    rv *= 0.96;   // multiply by drag
    pushMatrix();
    translate(x,y);      // Move to the location of the square
    rotate(r);           // rotate by r
    fill(c);             // draw the rectangle 
    rect(-xs/2,-ys/2,xs,ys);
    popMatrix();
    if (dist(mouseX, mouseY, this.x, this.y) < 50 && mouseY != pmouseY && mouseX != pmouseX) // If you're within the range of the mouse, move the rectangle
    {
      ra += .05 * d;
    }
  }
  
}

ArrayList<myRect> rects = new ArrayList<myRect>();     // List of rectangles

PImage image;        // Importing image
String imageDir = "/Users/danieldebeer/Desktop/ball.jpg";    // Image directory

void setup()
{
  size(1200, 800);      
  image = loadImage(imageDir);        // Loading image
  image(image, 0, 0, width, height);  // Drawing image

  loadPixels();

  noStroke();
  for (int i = 0; i < (width*height) - 100; i+=floor(random(50, 100)))    // go through the pixels at a random jump
  {
    rects.add(new myRect(i%width, i/width, random(20,25), random(20,25), pixels[i]));    // add a rectangle at that location with that color
  }
}

void draw()
{
  for(myRect r : rects)
  {
    r.update();        // Update all the rectangles
  }
}
