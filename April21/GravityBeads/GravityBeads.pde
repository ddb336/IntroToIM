
/* GRAVITY BEADS
*  Daniel de Beer
*  20th April 2020
*  Intro to IM
*/

// Bead class, defines the balls on the screen
class bead{
  
  PVector pos, vel, acc, center;      // These vectors give position, velocity, acceleration and center position that the ball gravitates towards
  
  color myc = color(random(255));     // Setting the color
  
  bead(float x, float y, float xCenter, float yCenter)  // You pass in the position and center values to make a new ball
  {
    this.pos = new PVector(x, y);                      // Setting position
    
    this.center = new PVector(xCenter, yCenter);       // Setting center
    
    this.acc = new PVector(0, 0);                       // Setting initial acceleration 
    
    this.vel = new PVector(0, 0);                      // Initial velocity is 0
  }
  
  // Update function: updates acceleration, velocity, and position
  void update()
  {
    this.acc = this.acc.set(this.pos.x-this.center.x, this.pos.y-this.center.y).mult(-0.1); // The vector that points towards "center"
    
    // Here we add the vector pointing away from the mouse, through our ellipse. Multiplied by -1 for direction and 1000 for effect
    // We divide by the square of the distance between them because this is the gravitational equation, so that acceleration increases as mouse gets closer to the ellips
    this.acc = this.acc.add(new PVector(mouseX-this.pos.x, mouseY-this.pos.y).div(sq(dist(mouseX, mouseY, this.pos.x, this.pos.y))).mult(-1000));
    
    //Adding acceleration to velocity, and multiplying by .92 for drag
    this.vel = this.vel.add(this.acc.div(2)).mult(0.92);
    
    // Adding velocity to position
    this.pos = this.pos.add(this.vel);
  }
  
  void drawMe()
  {
    fill(this.myc);    
    ellipse(this.pos.x, this.pos.y, 10, 10); // Draw the ellipse at its position
  }
}

bead[] beads = new bead[300];    // Make an array of beads

void setup()
{
  size(1200,800);    // Size of canvas
  
  for(int i = 0; i < 50; i++)          // the first 50 are the inner circle (radius 100 from center)
  {                                    // Set the start position to random
    beads[i] = new bead(random(width),random(height),width/2+(100*cos(map(i,0,50,0,2*PI))),height/2+(100*sin(map(i,0,50,0,2*PI))));
  }
    
  for(int i = 50; i < 150; i++)        // second 100 are the middle circle (radius 200 from center)
  {                                    // To get the circle, multiply r (200, the radius of the circle) by cos and sin of a mapping i to a value between 0 and 2pi
    beads[i] = new bead(random(width),random(height),width/2+(200*cos(map(i,50,150,0,2*PI))),height/2+(200*sin(map(i,50,150,0,2*PI))));
  }
      
  for(int i = 150; i < 300; i++)       // last 150 are the outer circle (radius 300 from center)
  {                                        
    beads[i] = new bead(random(width),random(height),width/2+(300*cos(map(i,150,300,0,2*PI))),height/2+(300*sin(map(i,150,300,0,2*PI))));
  }
}

void draw()
{
  background(0);        // Black background
  for (bead b : beads)  // go through all the beads
  {
    b.update();         // update and draw them
    b.drawMe();
  } 
}
