
int xPos = 0;    // Variable to store where in the grid we are while drawing (0-9)
int yPos = 0;

int myMouseX = 0;  // Variables for storing where the mouse is in the grid (0-9)
int myMouseY = 0;

void setup()
{
  size(700, 700); // Size of our canvas
}

void draw()
{
  xPos = myMouseX; // We'll start drawing shapes from the mouse position in the grid
  yPos = myMouseY;
  
  background(20);  // Set the background to dark grey
  
  checkMouse();    // Check where in the grid the mouse is
  
  pushMatrix();
  translate(myMouseX*70, myMouseY*70);    // This places a square on the grod position where the mouse is
  fill(200);
  rect(0,0,70,70);
  popMatrix();
  
  
  stroke(100);
  
  for (int i = 0; i < width; i += height/10)  // Drawing the grid
  {
    line(i, 0, i, height);
  }

  for (int j = 0; j < height; j += height/10)  // These basically draw vertical and horizontal spaced out lines
  {
    line(0, j, width, j);
  }
  
  stroke(150);  // Drawing the shapes
  
  while (yPos < 10) {                          // This is a big while loop that makes "random" shapes in each of the boxes in the grid

    for (int i = 1; i < 4; i++)                // These loops go between 1 and 3
    {
      for (int j = 1; j < 4; j++)              // The numbers one to 3 correspond to points within the square
      {
        for (int k = 1; k < 4; k++)              
        {
          for (int l = 1; l < 4; l++)
          {
            pushMatrix();
            translate(xPos*70, yPos*70);       // We translate to the particular box in the grid we're looking at, and then draw four lines
            myLine(i, j, k, l);
            myLine(l, i, j, k);
            myLine(k, l, i, j);
            myLine(j, k, l, i);
            popMatrix();
          }
        }
        xPos = (xPos+1)%10;                    // Increment the x position, and wrap if it goes over 10
        if (xPos==0) yPos++;                    // Increment y if x = 0
      }  
    }
  }
}

void myLine(int A, int B, int C, int D)        // Draws a line between two points within the square
{
  line(A*(height/40), B*(height/40), C*(height/40), D*(height/40));
}

void checkMouse()                              // checks where the mouse is in the grid and sets the mouse variable to that
{
  myMouseX = mouseX / 70;
  myMouseY = mouseY / 70;
}
