
int xFace = 250;
int yFace = 300;

float []ysmallRandoms = new float[200];
float []ybigRandoms = new float[200];
float []xsmallRandoms = new float[200];
float []xbigRandoms = new float[200];


void setup()
{
  size(500, 700);
  randomSeed(minute());
  for (int i = 0; i < 200; i++)
  {
    ysmallRandoms[i] = random(0, 10);
  }
  for (int i = 0; i < 200; i++)
  {
    ybigRandoms[i] = random(0, 50);
  }
  for (int i = 0; i < 200; i++)
  {
    xsmallRandoms[i] = random(0, 10);
  }
  for (int i = 0; i < 200; i++)
  {
    xbigRandoms[i] = random(0, 50);
  }
}

void draw()
{
  background(255);

  //SHIRT
  fill(26, 122, 196);
  triangle(0, 700, 500, 700, 250, 350);

  //FACE
  fill(255, 241, 204);
  ellipse(xFace, yFace, 370, 500);

  //HAIR
  for (int i = 30; i < 200; i+=1)
  {
    line(90+i+xsmallRandoms[i-30], 50+ysmallRandoms[i-30], 120+i+xbigRandoms[i-30], 90+ybigRandoms[i-30]);
  }

  //EYES
  fill(255);
  ellipse(320, 220, 75, 50);
  ellipse(180, 220, 75, 50);
  
  //EYE MOVEMENT
  fill(89, 51, 8);
  ellipse(320 + 12.5*((mouseX - 320)/(sqrt(sq(mouseX - 320) + sq(mouseY - 220)))), 220 + 12.5*((mouseY - 220)/(sqrt(sq(mouseX - 320) + sq(mouseY - 220)))), 20, 20);
  ellipse(180 + 12.5*((mouseX - 180)/(sqrt(sq(mouseX - 180) + sq(mouseY - 220)))), 220 + 12.5*((mouseY - 220)/(sqrt(sq(mouseX - 180) + sq(mouseY - 220)))), 20, 20);

  // NOSE
  fill(0);
  line(230+20, 240, 200+20, 320);
  line(200+20, 320, 230+20, 320);


  //MOUTH
  fill(255);
  arc(250, 400, 200, 130, 0+(QUARTER_PI/2), PI-(QUARTER_PI/2), CHORD);
  
  //EARS
  fill(255, 241, 204);
  quad(72, 228, 45, 198, 51, 307, 64, 285);
  
  quad(500-72, 228, 500-45, 198, 500-51, 307, 500-64, 285);
  
}
