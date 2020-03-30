
// Uses a parametric equation to draw a flower-like shape

float t = 0;

void setup()
{
  background(0);
  size(500,500);
}

void draw()
{
  
if (t % (width+50) == 0) {background(20);}  // A little after the shape is done being drawn, reset the background
  
  stroke(t/4, t, 2*t);          // This changes the color based on the value of t
  strokeWeight(5);              // Increasing the weight of the dots
  
  pushMatrix();                 // This block of code draws the first two lines 
  translate(0, height/4);       // Starting at a quarter of the way down the canvas
  point(x(t), y(t));            // Put a point at the first t value
  point(width - x(t), y(t) + height/2);  // Put another point on the other side of the canvas, at the corresponding position
  popMatrix();
  
  pushMatrix();                 // The next two blocks are based on the first, drawing the same thing but starting at a different position on the page
  rotate(radians(90));
  translate(0, -(3*width)/4);
  point(x(t), y(t));
  popMatrix();
  
  pushMatrix();
  rotate(radians(-90));
  translate(-width, width/4);
  point(x(t), y(t));
  popMatrix();
  
  t = (t + 1) % (width+50);    // Increment t, and if its out of the canvas by more than 50, reset t
}


float x(float t)        // Just returns t (not really necessary)
{
  return t;
}

float y(float t)        // The sine function is in here
{
  return sin(t/2) * 100;
}
