/*
    Covid-19 Virus Spread Simulation
    Daniel de Beer
    1 April 2020
    Introduction to Interactive Media
*/

// BALL CLASS
class Ball {

  // DEATH PARAMETERSe
  float deathFactor;         // This is a randomised value between 0 and 100. If the value is below chance of death, the ball will die after infected
  boolean dead;              // A boolean to check if the ball is dead

  // POSITION PARAMETERS
  float x, y, velX, velY, V; // x and y are the position of the ball, velX and velY are its velocity, and V is its overall speed

  // INFECTION PARAMETERS
  float timeInfected;        // Will be a value between 7000 and 13000 ms
  float startTime = 0;       // The time at which infection starts
  int type;                  // 0 for healthy, 1 for infected, 2 for recovered

  // BOUNCING PARAMETERS
  float xwait;               // These are for waiting after the ball has bounced in either the x or y directions
  float ywait;               // Helps ensure the ball doesn't get stuck on the wall

  // MISC.
  boolean distancing;        // Whether the ball is "social distancing" or not when it is spawned
  float r;                   // Radius of the ball


  // CONSTRUCTOR FUNCTION
  Ball(boolean distancing, float x, float y) {      // Whether or not it is distancing, and its x and y spawn position

    startTime = millis();                // resetting start time so that it doesn't cause bugs

    xwait = 0;                           // Setting xwait and ywait to 0
    ywait = 0;  

    this.distancing = distancing;        // Whether our ball is social distancing (staying still) or not

    timeInfected = random(7000, 13000);   // The amount of time the ball will be infected for 

    deathFactor = random(0, 100);        // Will determine if this ball dies or not
    dead = false;                        // Set at the start to 'alive'

    this.type = 0;                       // Set its type to healthy

    this.r = 7;                          // radius of the ball

    this.x = x;                          // setting the starting position 
    this.y = y;

    if (this.distancing) {               // If we're distancing set velocity to zero
      this.V = 0;
    } else this.V = 2;                   // Otherwise set it to 2

    this.velX = random(-this.V, this.V); // Choose a random x velocity between -V and V

    if (random(-1, 1) > 0) // This part randomly chooses whether Y will be positive or negative
    {             
      this.velY = sqrt((this.V * this.V) - (this.velX * this.velX));                // Calculate Y so that the vector sum of Y and X equals V
    } else {
      this.velY = sqrt((this.V * this.V) - (this.velX * this.velX)) * -1;           // Negative if randomly chosen so
    }
  }

  // INTERSECTION HANDLING - Determines what to do if one ball touches another
  void intersects(Ball b)
  {
    if (this.dead || b.isDead()) return;                               // If either this ball or the other ball is dead, return - ignores any dead balls

    float d = dist(this.getX(), this.getY(), b.getX(), b.getY());      // d is the distance between the two balls - our ball and ball b

    if (d < (this.r + b.getR()))                                       // if d is smaller than the sum of the radii, they are touching
    {
      if (this.type == 0 && b.getType() == 1)                          // if I'm healthy and b is infected,
      {
        this.type = 1;                                                 // Set me to infected
        numInfected++;                                                 // Increment the number of infected balls
        numHealthy--;                                                  // Decrement the number of healthy balls
        startTime = millis();                                          // Start my infection timer
      }  
      if (this.distancing) return;                                     // If I'm social distancing, I don't move. The code above is all that applies so return

      this.velX = (this.V/(2*this.r))*(this.x - b.x);                  // Otherwise set my x velocity to the difference between my x and their x, and same for y
      this.velY = (this.V/(2*this.r))*(this.y - b.y);                  // This gives a realistic bounce of the other ball. Multiply by V/2r to maintain the speed V
    }
  }

  // DISPLAY FUNCTION - Displays the ball on the screen
  void display() {

    if (this.dead) {                                      // Dead isn't really a ball type... has a color 100
      fill(100);
      ellipse(this.x, this.y, this.r*2, this.r*2);
      return;
    }

    switch(this.type) {                                   // Depending on the ball type, draw the balls as different colors and display them on the screen 
    case 0:
      fill(healthy);
      ellipse(this.x, this.y, this.r*2, this.r*2);        // Display at the x and y position of our ball
      break;
    case 1:
      fill(infected);
      ellipse(this.x, this.y, this.r*2, this.r*2);          
      break;
    case 2:
      fill(recovered);
      ellipse(this.x, this.y, this.r*2, this.r*2);
      break;
    }
  }

  // MOVE FUNCTION - Changes the x and y position of the ball
  void move() {

    if (this.distancing) return;          // If the ball is social distancing this doesn't apply, just return

    this.x += this.velX;                  // Increment x position by the speed (per frame) of the ball
    this.y += this.velY;                  // Increment y position by the speed (per frame) of the ball

    if (this.x-this.r <= 200 && this.velX < 0)      // If the x position (including the radius) is less than/equal to the boundary, and it's still moving in that direction
    {
      this.velX *= -1;                              // Reverse the velocity of the ball
    }
  
    if (this.x+this.r >= width && this.velX > 0)    // Same concept as above with right x boundary
    {
      this.velX *= -1;
    }

    if (this.y-this.r <= height/8 && this.velY < 0)  // Same with Y and top boundary
    {
      this.velY *= -1;
    }


    if (this.y+this.r >= height && this.velY > 0)    // Same with bottom boundary
    {
      this.velY *= -1;
    }
  }
  
  // UPDATE FUNCTION - Updates the ball as dead or recovered after infection time
  void update()                                      
  {
    if (this.type == 1 && (millis() - startTime >= timeInfected))  // If the ball type is infected and the difference between current time and the time of infection is greater than the time it should be infected for
    {
      numInfected--;                                               // Decrease number of infected balls 
      this.type = 2;                                               // Set its type to recovered
      if (this.deathFactor <= chanceOfDeath) {                     // If its random death factor (between 0-100) is less than the %chance of death
        this.dead = true;                                          // Set this ball to dead
        numDead++;                                                 // Increment number of dead
        return;                                                    // Return (ignore the rest)
      }
      numRecovered++;                                              // Increment the number of recovered balls
    }
  }

  // THE GETTERS AND SETTERS
  float getX()
  {
    return this.x;
  }

  float getY()
  {
    return this.y;
  }

  int getType()
  {
    return this.type;
  } 

  float getR()
  {
    return this.r;
  }

  boolean isDead()
  {
    return dead;
  }

  void setType(int type)
  {
    this.type = type;
  }
}

/* ---------------------------GLOBAL VARIABLES--------------------------- */
// DIMENSIONS:
final int widthOfCanvas = 900;             // The different dimensions of the canvas
final int heightOfCanvas = 800;
final int widthOfInfoSection = 200;        // The section with information about the simulation
final int widthOfGraph = 700;              // The graph section

// FONTS:
PFont bold, normal;                  // The two fonts in use, bold and normal

// MISCELLANEOUS:
String buffer;                       // A buffer string, used to combine numbers and text
boolean socialDistancing = false;    // Whether we are social distancing on this run of the simulation or not
float tempX = 0, tempY = 0;          // These two variables are temporary, they help initialize the balls
boolean collided = false;            // This variable becomes true if one of the balls is spawned on top of another
int numOfBalls;
int chanceOfDeath;
int tempChanceOfDeath = 2;

// STARTING CONDITIONS:
int numInfected;                 // Number of different types at the start
int numHealthy;                  
int numRecovered;
int numDead;

// VARIABLES FOR CHANGING DEFAULT
int tempInfected = 1;
int tempNumOfBalls = 100;

// COLORS:
color infected = color(230, 112, 103);
color healthy = color(101, 219, 215);
color recovered = color(192, 102, 227);

// FOR THE GRAPH:                
int[] historyI = new int[widthOfGraph];        // These keep the "history" of values of infected, healthy, dead and recovered 
int[] historyH = new int[widthOfGraph];        // at a given point in time of the simulation.
int[] historyR = new int[widthOfGraph];        // This allows the graph to remember what the simulation looked like at the start
int[] historyD = new int[widthOfGraph];        // and thus plot the entire thing, including the current state.
int[] historyC = new int[widthOfGraph];        // Number of new cases 

int maxInfected;                               // The maximum number infected at once during the simulation (to find the peak)
int maxInfectedCounter;                        // The time in the graph at which the max occurred
int counter;                                   // This counter keeps track of where we are in the graph

// ARRAY OF TYPE BALL
Ball[] balls;

/* ---------------------------------------------------------------------- */

void settings()
{
  size(widthOfCanvas, heightOfCanvas);
}

void setup()
{
  // Resetting the number every time setup() is called
  numOfBalls = tempNumOfBalls;
  numInfected = tempInfected;
  numHealthy = tempNumOfBalls - tempInfected;
  numRecovered = 0;
  numDead = 0;
  chanceOfDeath = tempChanceOfDeath;
  
  // Initializing counters and arrays 
  balls = new Ball[numOfBalls];
  counter = 0;
  maxInfected = 0;
  maxInfectedCounter = 0;
  
  // Creating the fonts used in the simulations
  bold = createFont("Helvetica-Bold", 12);            
  normal = createFont("Helvetica", 12);
  textFont(normal);                             // set the font to normal at the start

  // Initializing the canvas
  background(255);

  // INITIALIZING ALL THE BALLS:
  
  // For a business as usual scenario:
  if (!socialDistancing) 
  {
    initializeBalls(0,balls.length,0); // First parameter is start index, second parameter is end, and third is ball type
  } 
  
  // For a social distancing scenario
  else   
  {
    // Set 20 of the balls as active
    initializeBalls(0,(numOfBalls/5),0);
    
    // ENSURING REALISTIC SPAWN OF BALLS           //  This loop initializes balls and makes sure that they are not colliding
    for (int i = (numOfBalls/5); i < balls.length; i++)        //  with other balls when they are initialized
    {
      tempX = random(205, width-5);             // Choose random x and y variables
      tempY = random(height/8+10, height-5);
      
      collided = checkCollided(i, tempX, tempY);
      
      while (collided) {                          // While the x and y are invalid (colliding with other x's and y's
        tempX = random(205, width-5);             // Choose a new x and y
        tempY = random(height/8+10, height-5);
        collided = checkCollided(i, tempX, tempY);
      }

      balls[i] = new Ball(true, tempX, tempY);    // Make a new ball with the x and y values
      balls[i].setType(0);                        // Set its type to 0
    }
  }

  for (int i = 0; i < numInfected; i++) {balls[i].setType(1);}          // Set some of the balls to infected 

  // Initialize all the history arrays for the graph to zero
  setToZero(historyI);
  setToZero(historyH);
  setToZero(historyR);
  setToZero(historyD);
  setToZero(historyC);
}

void draw()
{
  background(190);

  textSize(20);
  makeNumText(color(0, 156, 152), 46, numHealthy, "Healthy:");  // The text of how many are infected, healthy, dead and recovered
  makeNumText(infected, 69, numInfected, "Infected:");          // Parameters: makeNumText(color textColor, int textHeight, int number, String text)
  makeNumText(recovered, 20, numRecovered, "Recovered:");
  makeNumText(color(100), 92, numDead, "Dead:");

  moreInfoText(socialDistancing);      // Here's the information text, when social distancing is true different text is shown
  
  // DRAWING THE BOXES FOR CHANGING DEATH RATE, NUMBER OF BALLS AND NUM INFECTED
  fill(230);
  rect(10, 569, 140, 23);
  rect(10, 604, 140, 23);
  rect(10, 639, 140, 23);
  drawUpDown(160,569);
  drawUpDown(160,604);
  drawUpDown(160,639);
  
  // Text in these boxes:
  stroke(0);
  fill(0);
  textSize(14);
  textFont(bold);
  text("Death Rate: ", 15, 586);
  textAlign(RIGHT);
  textFont(normal);
  buffer = tempChanceOfDeath + "%";
  text(buffer, 145, 586);
  textAlign(LEFT);
  textFont(bold);
  text("# of Balls: ", 15, 621);
  textAlign(RIGHT);
  textFont(normal);
  text(tempNumOfBalls, 145, 621);
  textAlign(LEFT);
  textFont(bold);
  text("# Infected: ", 15, 656);
  textAlign(RIGHT);
  textFont(normal);
  text(tempInfected, 145, 656);
  textAlign(LEFT);
  
  // DRAWING THE CHECK BOXES ETC.
  line(0, 150, 200, 150);              // Lines between the boxes
  line(0, 200, 200, 200);
  fill(230);
  rect(10, 160, 140, 30);              // Boxes for the text
  rect(10, 110, 140, 30);
  rect(165, 165, 20, 20);              // Check Boxes
  rect(165, 115, 20, 20);

  // Text inside the boxes next to the check boxes
  textSize(13);
  fill(0);
  text("Business As Usual", 20, 130);
  text("Social Distancing", 20, 180);

  // The check marks within the boxes
  strokeWeight(3);
  if (socialDistancing)
  {
    checkMark(172); 
  } else {
    checkMark(122);
  }
  strokeWeight(1);

  // MAKING THE BOUNDARY LINES AROUND THE AREA
  stroke(0);
  line(0, height/8+1, width, height/8+1);
  line(200, 0, 200, height);
  
  // SAVING THE VALUES FOR THE GRAPH
  historyH[counter] = numHealthy;        // Counter increments every third frame if not social distancing,
  historyI[counter] = numInfected;       // and every fourth frame if social distancing
  historyR[counter] = numRecovered;
  historyD[counter] = numDead;
  historyC[counter] = numInfected + numDead + numRecovered;
  
  // Saving the maximum infected to get the peak of the curve
  if (numInfected > maxInfected)         
  {
    maxInfected = numInfected;
    maxInfectedCounter = counter;
  }

  // "Printing" the graph of the outbreak using lines
  printGraph();
  
  // Printing the change graph after end of simulation
  changeGraph();
  
  
  // Displaying dead balls
  for (Ball b: balls)
  {
    if(b.isDead()) b.display();
  }
  
  // Displaying, moving and updating all the "not dead" balls (so they're above the dead ones)
  stroke(0);
  for (Ball b : balls)
  {
    if (!b.isDead()) {
      b.move();
      b.update();
      b.display();
    }
  }

  // COLLISION HANDLING
  for (Ball b : balls)            // Two for loops - each ball needs to check with each other ball if they are intersecting
  {  
    for (Ball c : balls)
    {
      if (b == c) continue;       // No need to check if they are the same ball
      b.intersects(c);
    }
  }
  
  // INCREMENTING GRAPH COUNTER
  if(!socialDistancing){
  if (counter < historyH.length-1 && frameCount%3==0) counter++;  // Increment every third frame for business as usua;
  }                                                               // Only go to one less than the size of the graph arrays
  else{  
    if(counter < historyH.length-1 && frameCount%4==0) counter++; // Every fourth frame for social distancing (often takes longer)
  }
  
  peakHandling(); // Does some stuff once the sim is over to show where the peak of the outbreak was
  
}

void mouseClicked() // Checks whether the checkboxes were clicked on
{
  // SOCIAL DISTANCING AND BUSINESS AS USUAL
  if (mouseX > 165 && mouseX < 185 && mouseY > 115 && mouseY < 135)    // Checkbox for business as usual
  {
    socialDistancing = false;
    setup();
  }
  if (mouseX > 165 && mouseX < 185 && mouseY > 165 && mouseY < 185)    // Checkbox for social distancing
  {
    socialDistancing = true;
    setup();                  // Resets the simulation
  }
  
  // UP DOWN ARROWS FOR DEATH RATE, INFECTED AND NUMBER OF BALLS
  if (mouseX > 160 && mouseX < 190 && mouseY > 569 && mouseY < 580 && tempChanceOfDeath < 90)
  {
    if(tempChanceOfDeath < 10) tempChanceOfDeath+=2;
    else tempChanceOfDeath+=10;
  }
  if (mouseX > 160 && mouseX < 190 && mouseY > 581 && mouseY < 592 && tempChanceOfDeath > 0)
  {
    if(tempChanceOfDeath <= 10) tempChanceOfDeath-=2;
    else tempChanceOfDeath-=10;
  }
  
  if (mouseX > 160 && mouseX < 190 && mouseY > 604 && mouseY < 615 && tempNumOfBalls < 150)
  {
    tempNumOfBalls += 10;
  }
  if (mouseX > 160 && mouseX < 190 && mouseY > 616 && mouseY < 627 && tempNumOfBalls > 50)
  {
    tempNumOfBalls -= 10;
  }
  
  if (mouseX > 160 && mouseX < 190 && mouseY > 639 && mouseY < 650 && tempInfected < 10)
  {
    tempInfected += 1;
  }
  if (mouseX > 160 && mouseX < 190 && mouseY > 651 && mouseY < 662 && tempInfected > 1)
  {
    tempInfected -= 1;
  }
  
}

void drawPeakArrow()  // Draws an arrow pointing to the peak of the outbreak
{
  strokeWeight(3);
  line(200+maxInfectedCounter-30, 100-map(maxInfected,0,numOfBalls,0,100), 200+maxInfectedCounter-5, 100-map(maxInfected,0,numOfBalls,0,100));
  line(200+maxInfectedCounter-10, 100-map(maxInfected,0,numOfBalls,0,100)-5, 200+maxInfectedCounter-5, 100-map(maxInfected,0,numOfBalls,0,100));      
  line(200+maxInfectedCounter-10, 100-map(maxInfected,0,numOfBalls,0,100)+5, 200+maxInfectedCounter-5, 100-map(maxInfected,0,numOfBalls,0,100));
  strokeWeight(1);
}

void setToZero(int[] array)
{
  for (int i = 0; i < array.length; i++)
  {
    array[i] = 0;
  }
}

void initializeBalls(int startIndex, int endIndex, int type)
{
  for (int i = startIndex; i < endIndex; i++)               // Go through the whole array of balls
    {
      tempX = random(widthOfInfoSection+5, width-5);     // Find a random x coordinate within the area specified
      tempY = random(height/8+10, height-5);             // Find a random x coordinate within the area specified
      balls[i] = new Ball(false, tempX, tempY);          // Initialize a ball with the given coordinates and social distancing as false
      balls[i].setType(type);                            // Set the ball's type to healthy
    }
}

boolean checkCollided(int index, float ourX, float ourY)
{
  for (int j = 0; j < index; j++)               // Check with all previous balls that they are not colliding with your x and y
      {
        if (dist(ourX, ourY, balls[j].getX(), balls[j].getY()) <= 2*balls[j].getR()) {  // If the distance between the points 
          return true;                                                                  // is greater than the sum of the radii
        }
      }
     return false; 
}

void makeNumText(color textColor, int textHeight, int number, String text)
{
  fill(textColor);
  ellipse(12, textHeight-8, 14, 14);
  textAlign(RIGHT);
  text(number, 190, textHeight);
  textAlign(LEFT);
  text(text, 27, textHeight);
}

void moreInfoText(boolean whichOne)
{
  if (whichOne) {
    fill(0);
    textSize(12);
    text("In the ", 10, 220);
    textFont(bold);
    text("          social distancing", 10, 220);
    textFont(normal);
    text("scenario, 80% of the persons", 10, 235);
    text("(circles) are stationary, while", 10, 250);
    text("20% are mobile. ", 10, 265);

    text("All other factors remain the", 10, 295);
    text("same. Notice, however, that the", 10, 310);
    text("mobile circles are much more ", 10, 325);
    text("likely to be infected. Also, the rate", 10, 340);
    text("of transmission is much slower.", 10, 355);
    line(0, 365, 200, 365);
  } 
  else {
    fill(0);
    textSize(12);
    text("In the ", 10, 220);
    textFont(bold);
    text("          business-as-usual", 10, 220);
    textFont(normal);
    text("scenario, all 100 persons", 10, 235);
    text("(circles) are allowed to move ", 10, 250);
    text("in any direction. ", 10, 265);
    text("The infection spreads", 10, 295);
    text("exponentially, with the ", 10, 310);
    text("probability of death at ", 10, 325);
    textFont(bold);
    text("                                   2%.", 10, 325);
    textFont(normal);
    line(0, 335, 200, 335);
  }
  line(0,560,200,560);
  line(0,height-130,200,height-130);
}

void checkMark(int yPos)  // Makes a check mark at x = 175, y = yPos
{
  line(170, yPos, 175, yPos+5);
  line(175, yPos+5, 186, yPos-12);
}

void printGraph()    // This function essentially draws lines up to the position that the outbreak is at
{
  for (int i = 0; i < historyH.length; i++)  // Go through all the arrays from 0 to length
  {
    if (historyH[i]==0 && historyI[i]==0 && historyR[i]==0 && historyD[i]==0) continue;   // if all the arrays are at 0 (default) then ignore

    if (historyR[i]!=0)  
    {
      stroke(recovered);
      line((width/4.5)+i+1, 0, (width/4.5)+i+1, map(historyR[i],0,numOfBalls,0,height/8));   // Drawing recovered from top of page to the amount of recovered
    }

    if (historyH[i]!=0)        
    {
      stroke(healthy);                        
      line((width/4.5)+i+1, map(historyR[i],0,numOfBalls,0,height/8), (width/4.5)+i+1, map(historyR[i]+historyH[i],0,numOfBalls,0,height/8));    // Healthy goes from recovered to healthy's position
    }  

    if (historyI[i]!=0)
    {
      stroke(infected);
      line((width/4.5)+i+1, map(historyR[i]+historyH[i],0,numOfBalls,0,height/8), (width/4.5)+i+1, map(historyR[i]+historyH[i]+historyI[i],0,numOfBalls,0,height/8));  // Infected goes from healthy plus infected to the sum of all 3
    }

    if (historyD[i]!=0)
    {
      stroke(100);
      line((width/4.5)+i+1, map(historyR[i]+historyH[i]+historyI[i],0,numOfBalls,0,height/8), (width/4.5)+i+1, map(historyR[i]+historyH[i]+historyI[i]+historyD[i],0,numOfBalls,0,height/8)); // Dead does the same, the sum of all 4
    }
  }
}

void peakHandling()    
// This function does stuff when the infections reach 0 or the graph reaches it's end
// It's purpose is to show where the peak happened and add text depending on whether we're social distancing or B.A.U.
{
  if ((counter == historyH.length-1 || numInfected == 0) && !socialDistancing ) { // If the sim is over and we're not social distancing
    
    // Making the position of the peak
    peakText();
    drawPeakArrow();

    // TEXT SPECIFIC TO THE TYPE OF SIMULATION
    textSize(12);
    text("At the peak of the outbreak,", 10, 355);
    buffer = floor((float(maxInfected)/float(numOfBalls))*100) + "%";
    textFont(bold);
    text(buffer, 10, 370);
    textFont(normal);
    text("        of the population is", 10, 370);
    text("infected with the virus,", 10, 385);
    text("putting an immense burden on ", 10, 400);
    text("hospitals and healthcare", 10, 415);
    text("systems.", 10, 430);
    text("In a real-life scenario, this", 10, 460);
    text("means crowded hospitals and", 10, 475);
    text("insufficient supplies to support", 10, 490);
    text("the infected - possibly a higher", 10, 505);
    text("death rate.", 10, 520);
  }
  if ((counter == historyH.length-1 || numInfected == 0) && socialDistancing) // If the sim is over and we are S.D.
  {
    peakText();
    drawPeakArrow();
    
    textSize(12);
    text("In this scenario, the maximum", 10, 385);
    text("proportion of people infected at", 10, 400);
    text("a given time was only ", 10, 415);
    buffer = floor((float(maxInfected)/float(numOfBalls))*100) + "%";
    textFont(bold);
    text("                                    "+buffer+".", 10, 415);
    textFont(normal);
    text("This is substantially lower than", 10, 445);
    text("in a business-as-usual scenario.", 10, 460);
    text("Hospitals are much better equiped", 10, 490);
    text("to treat the lower number of ", 10, 505);
    text("patients, which in a real-life ", 10, 520);
    text("scenario means better chances of ", 10, 535);
    text("survival.", 10, 550);
  } 
}

void peakText()
{
    stroke(0);
    line(200+maxInfectedCounter, 0, 200+maxInfectedCounter, 100);
    fill(0);
    textSize(20);
    buffer = "Peak: " + floor((float(maxInfected)/float(numOfBalls))*100) + "%";
    if(socialDistancing){
    text(buffer, 100+maxInfectedCounter, 100-map(maxInfected, 0, numOfBalls, 0, 100)-10);
    }
    else{
          text(buffer, 100+maxInfectedCounter, 100-map(maxInfected, 0, numOfBalls, 0, 100)+30);
    }
}

void changeGraph()
{
  if(counter == historyH.length-1)
  {
    stroke(0);
    fill(100);
    rect(0,height-100,200,100);
    stroke(255, 255, 18);
    for(int i = 0; i < historyC.length; i++)
    {
      line(map(i,0,700,0,200),height,map(i,0,700,0,200),height-map(historyC[i],0,numOfBalls,0,100));
    }
    stroke(0);
    fill(0);
    line(0,height-100,200,height-100);
    textSize(20);
    text("Cumulative Cases:",15,height-107);
  }
}

void drawUpDown(float x, float y)
{
  pushMatrix();
  translate(x,y);
  stroke(190);
  fill(230);
  rect(0, 0, 30, 11);
  rect(0, 12, 30, 11);
  fill(150);
  triangle(2,9,28,9,15,2);
  triangle(2,14,28,14,15,21);
  popMatrix();
}
