
//Exactly like the previous one, except it draws lines that point at the cursor position

int x = 0;
int y = 0;

int mX = 0;
int mY = 0;

void setup()
{
  size(700, 700);
}

void draw()
{
  x = 0;
  y = 0;


  background(20);


  checkMouse();

  pushMatrix();
  translate(mX*(height/10), mY*(height/10));
  stroke(255);
  rect(0, 0, (height/10), (height/10));
  popMatrix();


  stroke(100);
  for (int i = 0; i < width; i += height/10)
  {
    line(i, 0, i, height);
  }

  for (int j = 0; j < height; j += height/10)
  {
    line(0, j, width, j);
  }

  stroke(255);

  while (y < 10) {                // Only different part is here 

    pushMatrix();                 // Draw the line in the particular box
    translate(x*(height/10), y*(height/10));                        
    line((height/100)*x, (height/100)*y, (height/100)*mX, (height/100)*mY);      // Basically translates the line between the cursor and this particular box into a mini-line
                                                                                  // Within the box itself. Gives the impression that all lines are pointing at the cursor
    popMatrix();

    x = (x+1)%10;
    if (x==0) y++;
  }
}

void checkMouse()
{
  mX = mouseX / (height/10);
  mY = mouseY / (height/10);
}
