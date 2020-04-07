/*
  SNEK GAME
  Daniel de Beer
  Intro to I.M.
  April 7 2020
*/


// THE SNAKE CLASS - Handles pretty much everything
class Snake {
  
  // VARIABLES: -----------------
  
  ArrayList<snakePoint> points = new ArrayList<snakePoint>();  // Making a new array of snake points

  Position[] myPositions = new Position[400];     // Initializing 400 positions, each for a spot in the grid

  Position tempPosition = null;    // Temporary position, used to set a position to unoccupied

  snakePoint Head = null, Tail = null;
  
  Mouse myMouse;    // The 'mouse' (ball) that the snake has to eat

  float speed;      // Speed of the snake
  
  float waitTimer;  // A timer so that the snake can wait after it's eaten a ball (makes snake longer) 

  boolean wait;     // Whether the snake is waiting or not

  float headWait;   // This timer is set after the snake sets a position in the grid as occupied.
                    // It waits until we are out of range of that position before we can check whether we are hitting a new occupied position
  float tailWait;   // Waiting for the tail to move past a position before setting it as unoccupied

  // -----------------------------

  // SNAKE CONSTRUCTOR CLASS 
  Snake()
  {
    this.points.add(new snakePoint((myWidth/2)+(myWidth/40), (myWidth/2)+(myWidth/40), LEFT));              // Adding the starting point
    this.points.add(new snakePoint(points.get(0).getX() - 2*(myWidth/20), points.get(0).getY(), LEFT));     // Adding the endpoint of the snake
    this.speed = snakeSpeed;    // Setting snake speed
    this.wait = false;          // Initializing wait to false
    myMouse = new Mouse();      // Making a new mouse
    this.waitTimer = millis();  // Wait timer starts at 0 or millis()
    this.headWait = millis();   // Same with other two timers
    this.tailWait = millis();

    int x = 0;                  // Temporary variables to spawn the positions
    int y = 0;

    for (int i = 0; i < myPositions.length; i++)    // Go through all 400 positions
    {
      myPositions[i] = new Position(x, y);          // Set as x and y
      x++;
      if (x == 20)  // Reset x when it reaches 20, and increment y
      {
        x = 0;
        y++;
      }
    }
  }

  // DISPLAY FUNCTION
  void display()  
  {
    strokeWeight(18); // Set the weight to 18 to draw the point and lines
    stroke(120);      // Color set to gray
    point(myMouse.getX(), myMouse.getY());   // Make a point where the mouse is
    
    stroke(0);        // Color set to black
    for (int i = 0; i < this.points.size()-1; i++)   // Go through all the points in the snake and draw a line between each consecutive point
    {
      line(this.points.get(i).getX(), this.points.get(i).getY(), this.points.get(i+1).getX(), this.points.get(i+1).getY());
    }
    strokeWeight(1);  // Set the weight back to 1
    
    if (debug) {
      for (Position p : myPositions)      // If we're debugging, draw circles at all the positions in the grid
      {
        if (p.occupied)                   // Red if occupied, green if not occupied
        {
          fill(red);
          ellipse(p.getX(), p.getY(), 5, 5);
        } else {
          fill(blue);
          ellipse(p.getX(), p.getY(), 5, 5);
        }
      }
    }
  }

  // THE UPDATE FUNCTION - * All the magic happens here *
  void update()
  {
    if (this.points.size() == 1) gameOver = true;        // The snake shrinks a bit if it doesn't eat, if it reaches only one point, the game is over
    
    Head = this.points.get(this.points.size()-1);        // 'Tail' and 'Head' are simply placeholders to improve legibility
    Tail = this.points.get(0);                           // They refer to the front and back points of the snake in the snake array
    
    switch(Head.getDir())      // Depending on head's direction, we change the x or y value of the head point in the snake
    {
    case RIGHT:
      Head.setX(Head.getX()+this.speed);
      break;
    case LEFT:
      Head.setX(Head.getX()-this.speed);
      break;
    case UP:
      Head.setY(Head.getY()-this.speed);
      break;
    case DOWN:
      Head.setY(Head.getY()+this.speed);
      break;
    }

    if (!wait)    // If we're not waiting (the wait variable tells us if we've just eaten a mouse, in which case the tail stops moving for 1000ms and the snake gets longer)
    {
      switch(Tail.getDir())      // Then change the x and y values of the snake's tail depending on its stored direction
      {
      case RIGHT:
        Tail.setX(Tail.getX()+this.speed);
        break;
      case LEFT:
        Tail.setX(Tail.getX()-this.speed);
        break;
      case UP:
        Tail.setY(Tail.getY()-this.speed);
        break;
      case DOWN:
        Tail.setY(Tail.getY()+this.speed);
        break;
      }
    }
    
    // TURNING THE SNAKE
    //  dirkey must not equal 0; Head must be within the zone to turn; direction must be different from head direction
    if (dirKey != 0 && Head.withinZone() && dirKey != Head.getDir() && dirKey != Head.getDir()-2 && dirKey != Head.getDir()+2) // Also, LEFT and RIGHT are ints that are two apart, same with UP and DOWN
    {                                                                                                                          // Makes sure that if you're going left already you cant turn right, and same with up and down
      Head.setDir(dirKey);  // Set Head's direction to dirKey
      Head.setX(floor(Head.getX()/25)*25+12.5);  // Centralize head before it turns
      Head.setY(floor(Head.getY()/25)*25+12.5);  
      this.points.add(this.points.size()-1, new snakePoint(floor(this.points.get(this.points.size()-1).getX()/25)*25+12.5, floor(this.points.get(this.points.size()-1).getY()/25)*25+12.5, dirKey));
      this.points.get(this.points.size()-2).setDir(dirKey); // These two lines add a temporary midpoint for the snake, at a turning point, so that you can get a 90˚ turn in the snake
      dirKey = 0; // Reset direction key to 0
    }
    
    // reset head position
    Head = this.points.get(this.points.size()-1); // In case Head has changed

    // When the tail catches up with the next mid point (index 1)
    if (abs(Tail.getX()-this.points.get(1).getX()) <= 1 && abs(Tail.getY()-this.points.get(1).getY()) <= 1)
    {
      this.points.remove(0);  // remove the tail
    }
    
    Tail = this.points.get(0); // Set the new tail

    // HEAD CATCHES A MOUSE
    if (abs(Head.getX() - this.myMouse.getX()) <= 1 && abs(Head.getY() - this.myMouse.getY()) <= 1) // If the head and the mouse are within 1 of each other
    {
      this.wait = true;                // Waiting is true
      this.waitTimer = millis();       // Set the wait timer
      this.updateMouse();              // Set the mouse to a new position
      score++;                         // Increment score
    }

    if (millis() - this.waitTimer >= 1000) this.wait = false;    // If we're past the wait timer, wait is false
    
    // SETTING POSITIONS TO OCCUPIED OR UNOCCUPIED; HANDLING SNAKE EATING ITSELF
    for (Position p : myPositions)  // go through all positions
    {
      if (abs(Head.getX() - p.getX()) <= 11 && abs(Head.getY() - p.getY()) <= 11)  // If head is within range of a point
      {
        if (p.isOccupied() && millis()-headWait >= 30)        // If that point is already occupied and we're past the head timer 
        {
          gameOver = true;                                    // It's game over, we've hit the snake's body
        }
        p.setOccupied(true);                                  // Otherwise set the position as occupied and set a timer, so that we don't detect this position as occupied and think we're eating snake
        headWait = millis();
      }
      if (abs(Tail.getX() - p.getX()) <= 11 && abs(Tail.getY() - p.getY()) <= 11)   // If the tail is in the range of a position
      {
        this.tailWait = millis();          // Start the tail timer
        this.tempPosition = p;             // set the temp position to p, we'll set it as unoccupied once the timer is kalas
      }
    }

    if (millis() - this.tailWait >= 10 && tempPosition != null)    // If the timer is done and temp position is not null
    {
      tempPosition.setOccupied(false);                             // set it as unoccupied, and then set temp position to null
      tempPosition = null;
    }

    if (Head.getX() < 8 || Head.getX() > width-8 || Head.getY() < 8 || Head.getY() > height-8) gameOver = true; // If we've hit the sides with the snake head, it's game over for us
  }

  // UPDATE MOUSE - Gives the mouse a new position that doesn't clash with the snake's occupied positions
  void updateMouse()    
  {
    int newX = 0;              // Two temporary x and y's 
    int newY = 0;
    boolean collides = true;   // First set collides to true

    while (collides)           // While collides is true
    {
      newY = floor(random(0, 19));    // Make a new random y and x
      newX = floor(random(0, 19));
      for (Position p : myPositions)  // Go through all the 400 positions
      {
        if (newX == (p.getX()-12.5)/25 && newY == (p.getY()-12.5)/25 && p.isOccupied())  // If the x and y are equal to the x and y of the position, and it's occupied, 
        {
          collides = true;            // Set collides to true and break the for loop - we'll remain in the while loop
          break;
        } else collides = false;      // Otherwise collides is false, we good. If this is the last one, then we'll leave the while loop
      }
    }

    myMouse.setX(newX*25+12.5);       // Set the new x and y positions of the mouse
    myMouse.setY(newY*25+12.5);
  }



  /*------------------------SUB-CLASSES------------------------*/
  
  // MOUSE CLASS - The ball that the snake eats
  class Mouse {
  
    float posX, posY;                            // The x and y position of the mouse

    Mouse() {                                    // It initializes to a random position in the grid
      this.posX = floor(random(0, 19))*25+12.5;
      this.posY = floor(random(0, 19))*25+12.5;
    }

    // GETTERS AND SETTERS FOR MOUSE
    float getX()
    {
      return posX;
    }

    float getY()
    {
      return posY;
    }

    void setX(float newX)
    {
      this.posX = newX;
    }

    void setY(float newY)
    {
      this.posY = newY;
    }
  }

  // SNAKEPOINT CLASS - A point in the body of the snake, so that lines can be drawn
  class snakePoint {
  
    float posX;        // Has an x and y position and a direction which is either LEFT, RIGHT, UP or DOWN
    float posY;      
    int direction;

    snakePoint(float posX, float posY, int direction)    // Initializing the point
    {
      this.posX = posX;
      this.posY = posY;
      this.direction = direction;            
    }

    // SNAKEPOINT GETTERS AND SETTERS
    float getX()
    {
      return this.posX;
    }

    float getY()
    {
      return this.posY;
    }

    int getDir()
    {
      return this.direction;
    }

    void setX(float x)
    {
      this.posX = x;
    }

    void setY(float y)
    {
      this.posY = y;
    }

    void setDir(int d)
    {
      this.direction = d;
    }

    // This function checks whether we are within the middle part of a position, so that the snake can now turn
    boolean withinZone()
    {     
      for (int i = 0; i < 20; i++)  // Cycle through all the 20 x coordinates of the positions in the grid
      {
        for (int j = 0; j < 20; j++)   // And all the y coordinates
        {
          if (this.getX() > i*(width/20)+(width/40)-1.5 && this.getX() < i*(width/20)+(width/40)+1.5)
            if (this.getY() > j*(height/20)+(height/40)-1.5 && this.getY() < j*(height/20)+(height/40)+1.5)
            {
              return true;  // If we're within the zone, return true
            }
        }
      }
      return false; // Otherwise return false
    }
  }

  // POSITION CLASS - Represents the 400 positions in the 20x20 grid
  // PURPOSE: To detect if the snake is eating itself; To prevent the mouse from spawning on the snake's body
  class Position
  {
    float xPos, yPos;                      // A position has its x and y coordinates and whether or not it is occupied
    boolean occupied;          

    Position(float x, float y)    // Creating the positions in the grid
    {
      this.xPos = x*25 + 12.5;
      this.yPos = y*25 + 12.5;
      this.occupied = false;
    }

    // GETTERS AND SETTERS FOR POSITION
    void setOccupied(boolean set)  
    {
      this.occupied = set;
    }
    
    boolean isOccupied()
    {
      return this.occupied;
    }

    float getX()
    {
      return this.xPos;
    }

    float getY()
    {
      return this.yPos;
    }
  }
}

/*-----------GLOBAL VARIABLES-----------*/

final int myWidth = 500;      // Width of screen
final int myHeight = 500;     // Height of screen
float snakeSpeed = 1.5;       // Speed of the snake
int dirKey;                   // A temporary key to store which direction the 
// keyboard is telling the snake to move in
boolean gameOver;             // True if the snake has hit the wall or itself
Snake mySnake;                // Makes an instance of the snake class
PFont normal, bold;           // The fonts used in this game
int score;                    // User score
int highScore = 0;            // High score
boolean firstTime = true;     // True on the first time the game is run (for the 3-2-1 countdown)
boolean debug = false;         // True if debugging the game (shows extra info on screen)

color bigNum = color(230), small = color(150), red = color(222, 31, 31), blue = color(63, 204, 82);

/*--------------------------------------*/

// SETTINGS - Used to dynamically set width and height
void settings()
{
  size(myWidth, myHeight);
}

// SETUP - Setting variables and initializing snake
void setup()
{
  // Setting variables
  score = 0;
  dirKey = 0;
  gameOver = false;
  normal = createFont("Chalkboard", 12);
  bold = createFont("Chalkboard-Bold", 12);

  // Making a new snake for each run of the game
  mySnake = new Snake();
}

void draw()
{
  background(255);
  stroke(0);

  if (firstTime) // On the first time, only do a 3-2-1 countdown
  {
    fill(bigNum);                      // Big number color
    textFont(bold);                    // Font bold
    textSize(400);                     // Size 400
    textAlign(CENTER);                 // Aligned in center of screen
    text(floor((5000-millis())/1000), 250, 375); // This produces a 3-2-1 countdown 
    fill(0);
    if (5000-millis()<=0) firstTime = false;  // If countdown is done, firstTime is set to false
    return;
  }
  
  // This block prints the big number on the screen, the score, behind the snake and ball
  fill(bigNum);
  textFont(bold);
  textSize(400);              
  textAlign(CENTER);
  text(score, 250, 375);
  fill(0);

  // If the game is over, print game over text and wait for the mouse to be clicked
  if (gameOver) 
  {
    fill(small);
    textFont(normal);
    textSize(20);
    stroke(small);
    text("GAME OVER", width/2, 3*(height/4) + 50);                  // Some info text
    text("(click to continue)", width/2, (height/4) - 80);
  
    if (score > highScore)                                          // If score is above highscore
    {          
      text("High Score!", width/2, 3*(height/4) + 90);              // then say it is a high score
    } else text("High Score: " + highScore, width/2, 3*(height/4) + 90);  // otherwise say what the highscore is
  } 
  else 
  {
    mySnake.display();  // Display the snake
    mySnake.update();   // Update snake position etc.
  }
}

// Checks whether you're clicking up, down, left or right 
void keyPressed()
{
  if (key == CODED) {
    if (keyCode == UP || keyCode == DOWN || keyCode == LEFT || keyCode == RIGHT) {
      dirKey = keyCode;
    }
  }
}

void mouseClicked()
{
  if (gameOver)
  {
    if (score > highScore)
    {
      highScore = score;
    }
    setup();
  }
}
