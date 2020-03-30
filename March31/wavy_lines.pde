
// Uses parametric equations to make an artistic flowing shape

float t = 0;

void setup()                  // Setting the background and the size of the canvas
{
  background(20);
  size(800,800);
}

void draw()
{
  background(20);  
  strokeWeight(5);
  
  translate(width/2, height/2);    // We start the shape at the middle of the canvas
  
  for(int i = 0; i < 20; i+=1)     // This draws 20 lines, each at a different position in the parametric curves
  {
    stroke(abs(sin(t/50)*100), abs(cos(t/50)*100), 150);  // Changing the color of the lines based on a sine and cosine curve
    line(x1(t + i), y1(t + i), x2(t + i), y2(t + i));     // Drawing the 20 lines using the parametric x and y equations
  }
  t++;
}


// Parametric equation 1
float x1(float t)              // each returns a floating point value
{
  return sin(t/15) * 250;
}

float y1(float t)
{
  return sin(t/10) * 380;
}

// Parametric equation 2
float x2(float t)
{
  return cos(t/30) * 300;
}

float y2(float t)
{
  return cos(t/10) * 110;
}
