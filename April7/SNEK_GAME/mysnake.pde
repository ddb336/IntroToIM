
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
