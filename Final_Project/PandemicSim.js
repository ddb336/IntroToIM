/*
*		Daniel de Beer
*		NYU Abu Dhabi
*		Introduction to Interactive Media
*		17 May 2020
*
*		PandemicSim Project
*		-------------------
*   This project was built with inspiration drawn from https://www.washingtonpost.com/graphics/2020/world/corona-simulator/
*
*/

// These strings are the paragraphs used to explain the simulation and background.
// They are parsed by a block of code to add '\n' where necessary to make it fit the area it's in
var stringBU = "In the business-as-usual scenario, everyone carries on life as normal. This allows the disease to spread exponentially. The peak of the curve is very high – up to 70% of the population is infected at a given time. This puts great pressure on healthcare systems and hospitals.\n\nChange the settings to 'social distancing' to see what affect this minor lifestyle change has on the peak of the graph.";
var stringPD = "In the physical distancing scenario, 80% of people practice physical distancing (staying at home and only going out for essentials, avoiding physical contact with others). These people are much less likely to contract the disease. In this scenario, the peak of the pandemic in much lower, giving healthcare systems a much better chance to cope.\n\nPlease practice distancing while the Covid-19 pandemic lasts! You may save the lives of many people - including yourself. Share this simulation with your friends to demonstrate the power of physical distancing.";
var stringTemp;	// A temporary string to store the string to be parsed

// This is an array of "toggle buttons", a class of buttons used to choose
// between social distancing and normal mode, and between the two graph modes
var toggles = [];

// Two sliders used to choose the population size and death rate of the simulation
var slider1;
var slider2;

// These arrays store the values of the number of balls in each category during the simulation (used for the graph)
var historyH = [];			// Healthy values
var historyI = [];			// Infected
var historyR = [];			// Recovered
var historyD = [];			// Dead
var historyCounter = 0;	// A counter used to fill in the arrays at the necessary values

// Peak values to write where the peak of the graph is after the simulation finishes
var peakI;		// Position of peak infections in graph (array index)
var peakVA;		// Peak value for absolute graph
var peakVC;		// Peak value for cumulative graph

// These are the colors for the different balls
var healthyc;
var infectedc;
var recoveredc;
var deadc;
var bgColor;		// Background color

// Color palette:
var dark;
var medDark;
var medium;
var medLight;
var light;
var textc;

// Variables for keeping track of the number of balls
var numOfBalls;				// Total
var tempNOB = 100;		// Temporary (to allow changes to the # of balls)
var numInfected;	// Number of infected
var numHealthy = tempNOB - numInfected;		// Number of healthy
var numRecovered;	// Number of recovered
var numDead;			// # dead

// Miscellaneous values
var chanceOfDeath;		// Value between 0 and 100, the chance that an individual ball will die (probability of death)
var tempCOD = 2;			// Temporary chance of death to allow changes
var pD;								// A boolean value - whether we are physical distancing or not
var tempPD = false;		// Temporary boolean to allow changes to physical distancing boolean
var firstRun = true;	// Only true after the first run of setup, to allow for an opening window that says PandemicSim
var setupTimer = 0;		// The timer that allows you to reset the program only once every second

var graphMode = 1;		// The mode of the graph, 1 is cumulative and 2 is absolute

var balls = [];				// This is the array of balls in the simulation

var smallBalls = [];	// An array of "small balls", the little balls visible in the preview box for physical distancing vs business as usual

function setup()
{
	// Setting the color palette
	dark = color(6, 21, 43);
	textc = color(213);
	medDark = color(9, 34, 71);
	medium = color(12, 44, 94);
	medLight = color(22, 93, 199);
	light = color(86, 143, 227);

	if(!tempPD) 				// If we're not physical distancing
	{
		stringTemp = stringBU;			// Use the business as usual description
	}
	else
	{
		stringTemp = stringPD;			// Else use the physical distancing one
	}

	createCanvas(1383, 716);			// Making the size of the canvas (this size works well with most computer screens)
	textSize(12);									// Size of the text

	// This block of code parses the string and turns it into a paragraph to be displayed in the sim
	var tempIndex = 0;	// the start of the substring that becomes a new line
	for(var x = 1; x < stringTemp.length-1; x++)			// Go through every character in the string
	{
		if(stringTemp.substring(x,x+1) =="\n") 					// If you hit a new line, reset the substring
		{
			tempIndex = x-1;
			x+=2;
		}
		if(textWidth(stringTemp.substring(tempIndex, x)) > (width/5)+10) {		// If your substring width is larger than the specified width (width/5)/10
			for(var y = x; y > 0; y--)	// Go back through the string to the most recent space (" ")
			{
				if(stringTemp[y] == " ")
				{
					x = y+1;				// set x equal to that value
					break;
				}
			}
			stringTemp = stringTemp.substring(0, x)+"\n"+stringTemp.substring(x);		// insert a /n inside the string
			tempIndex = x+3;	// Increment x and temporary index
			x+=3;
		}
	}

	// Here we set the values to their default or temporary values, specified by the user. In the first run they are set to defaults.
	numOfBalls = tempNOB;
	numInfected = 1;
	numHealthy = numOfBalls - numInfected;
	numRecovered = 0;
	numDead = 0;
	chanceOfDeath = tempCOD;
	pD = tempPD;

	// Resetting the values for the graph
	peakI = 0;
	peakVA = 0;
	peakVC = 0;
	historyCounter = 0;

	// Setting the values in the graph array to 0
	for(var i = 0; i < (width/2)-5; i++)
	{
		historyH[i] = 0;
		historyI[i] = 0;
		historyR[i] = 0;
		historyD[i] = 0;
	}

	// Setting the colors of the balls
	healthyc = color(59, 247, 106);
  infectedc = color(252, 78, 116);
	recoveredc = color(191, 78, 252);
	deadc = color(191);

	// This block of code makes the balls for the simulation
	if(!pD)
	{
	for(i = 0; i < numOfBalls-1; i++)
	{
		balls[i] = new Ball(random(width/2,width),random(height),0,false);		// If we're not physical distancing just make them
	}
	}
	else
	{
		for(i = 0; i < floor(numOfBalls/5); i++)			// Otherwise,	make 1/5th of them active
		{
			balls[i] = new Ball(random(width/2,width),random(height),0,false);
		}
		// And make the rest stationary
		// This part also makes sure they don't spawn on top of each other
		for (i = floor(numOfBalls/5); i < numOfBalls; i++)        // Compared with other balls when they are initialized
    {
      var tempX = random(width/2+15, width-15);             // Choose random x and y variables
      var tempY = random(15, height-15);

      var collided = checkCollided(i, tempX, tempY);

      while (collided) {                          				// While the x and y are invalid (colliding with other x's and y's)
        tempX = random(width/2+15, width-15);             // Choose a new x and y
        tempY = random(15, height-15);
        collided = checkCollided(i, tempX, tempY);
      }

      balls[i] = new Ball(tempX, tempY, 0, true);    // Make a new ball with the x and y values
    }
	}
	balls[numOfBalls-1] = new Ball(random(width/2,width),random(height),1,false);			// Set the last ball to be infected (will always be an active ball)
	balls[numOfBalls-1].timeInfected += 3;

	// Making the toggle buttons and their positions
	toggles[0] = new toggle((width/8)+5+width/4,(height/12)*7+height/2-height/6,false);
	toggles[1] = new toggle((width/8)+5,(height/24)*12.2-2+height/12+8+4-15, pD);

	// Making the "small balls" inside their box (this one is for the business as usual box)
	for(i = 0; i < 25; i++)
	{
		smallBalls[i] = new smallBall(random(width/64-2,width/64-2+width/16+4),random((height/24)*12.2-2,(height/24)*12.2-2+height/12+8+4),width/64-2,(height/24)*12.2-2,width/16+4,height/12+8+4,false);
	}

	// Making the small balls inside the physical distancing box (more on these in their class below the draw function)
	for(i = 25; i < 40; i++)
	{
		smallBalls[i] = new smallBall(random(width/4-width/64-width/16+2,width/4-width/64-width/16+width/16+4-2),random((height/24)*12.2-2+2,(height/24)*12.2-2+height/12+8+4-2),width/4-width/64-width/16-2,(height/24)*12.2-2,width/16+4,height/12+8+4,true);
	}
	for(i = 40; i < 50; i++)
	{
		smallBalls[i] = new smallBall(random(width/4-width/64-width/16,width/4-width/64-width/16+width/16+4),random((height/24)*12.2-2,(height/24)*12.2-2+height/12+8+4),width/4-width/64-width/16-2,(height/24)*12.2-2,width/16+4,height/12+8+4,false);
	}
}

function draw()
{
	// If we're on the first run and we're past the opening screen (first 5000 milliseconds) and we haven't made these sliders before
	if(firstRun && millis() > 5000 && slider1 == null && slider2 == null)
	{
	slider1 = createSlider(20,200,numOfBalls,1);				// We can make the two sliders
	slider2 = createSlider(0,100,chanceOfDeath,1);
	}

	// If we're past the first 5000 milliseconds, we can set their position and value as well
	if(millis() > 5000)
	{
		slider1.position(width/12-10, (height/8)*7-height/6+height/64);
		slider1.style('width', width/8+'px');
		slider2.position(width/12-10, (height/16)*15-height/6+height/64);
		slider2.style('width', width/8+'px');
	}

	// Set the background to black
	background(0);

	// Here we draw the box for the balls and the box for the counters
	fill(medium);
	rect(width/2,0,width/2,height);
	rect(0,200,width/2,140);

	// Here we draw the graph background and information section background
	fill(medDark);
	rect(0,0,width/2,200);
	rect(0,340,width/2,height-200);

	// These rectangles are for the graph type selection and the business as usual/social distancing selection
	stroke(dark);
	fill(medium);
	rect(width/4-width/64-width/16-2+width/4,(height/24)*12.2-2+height/2-height/6,width/16+4,height/12+8+4);
	rect(width/64-2+width/4,(height/24)*12.2-2+height/2-height/6,width/16+4,height/12+8+4);
	rect(width/64-2,(height/24)*12.2-2,width/16+4,height/12+8+4);
	rect(width/4-width/64-width/16-2,(height/24)*12.2-2,width/16+4,height/12+8+4);

	// This block of code is the reset button for the simulation
	fill(83, 153, 78);			// Lightish green
	stroke(60, 112, 55);		// Slightly darker green
	// If the mouse is over the button
	if(mouseX > width/16+35 && mouseX < width/16+35+width/4-width/8-70 && mouseY > 11*height/12-3*height/8+height/3+height/64 && mouseY < 11*height/12-3*height/8+height/16+height/3+height/64)
	{
		// Change the color to a darker green
		fill(71, 130, 66);
		stroke(47, 87, 43);
		// If the button is clicked
		if(mouseIsPressed)
		{
			fill(56, 102, 52);	// Change to a darker color still
			stroke(39, 71, 36);
			if(millis()-setupTimer >= 1000)		// Only allow a reset of the program every one second
		{
				setupTimer = millis();
				setup();
			}
		}
	}
	// Then draw the box of the button
	rect(width/16+35,11*height/12-3*height/8+height/3+height/64,width/4-width/8-70,height/16);
	// Then write the text "reset" in the box you drew
	textSize(32);
	stroke(0);
	strokeWeight(5);
	textAlign("center");
	text("reset",width/16+width/8-width/16,11*height/12-3*height/8+height/32+height/64-height/256+height/3+height/64);
	noStroke();
	//-----------------------------------

	// This is the label text for the graphs and the settings
	textSize(12);
	textAlign("center");
	textStyle("bold");
	fill(190);
	text("absolute",width/4-width/64-width/16+width/32+width/4,(height/24)*12.2+height/12+8+4+24+height/2-height/6);
	text("cumulative",width/64+width/32+width/4,(height/24)*12.2+height/12+8+4+24+height/2-height/6);
	text("business as usual",width/64+width/32,(height/4)*3+height/16-height/6-height/128);
	text("physical distancing",width/4-width/64-width/16+width/32,(height/4)*3+height/16-height/6-height/128);
	noStroke();
	//-----------------------------------

	// In this block of code, we tell the balls what to do during each frame
	// Go through the full array of balls
	for(i = 0; i < numOfBalls; i++)
	{
		if(!balls[i].dead) continue;		// If the balls are not dead, continue
		balls[i].display();							// Otherwise display (displaying all the dead balls, so that they are behind the living ones)
	}
	// Go through again
	for(var i = 0; i < numOfBalls; i++)
	{
		if(balls[i].dead) continue;			// Ignore the dead balls
		balls[i].display();							// If it's alive, display it now
		if(millis() > 3000) balls[i].update();	// Only move them after 3 seconds after the start of the sim, so that the sim only starts after the opening logo
		balls[i].intersects();					// Check if a ball intersects with another and handle that intersection
	}
	//-----------------------------------

	// These two blocks of code deal with saving the data for the graph
	// If we're physical distancing, save every 4 frames (usually the sim takes longer for P.D. scenarios)
	if(frameCount%4 == 0 && historyCounter < (width/2)-5 && pD)		// Only save when the counter is less than the width of the graph frame
	{
		historyH[historyCounter] = numHealthy;			// Saving all the values in the array
		historyI[historyCounter] = numInfected;
		historyR[historyCounter] = numRecovered;
		historyD[historyCounter] = numDead;
		if(historyI[historyCounter] >= historyI[peakI])		// Saving the peak value of infections (only if current value is larger than peak)
		{
			peakI = historyCounter;
			peakVC = numInfected + numDead;
			peakVA = numInfected;
		}
		if(millis() > 3000) historyCounter++;				// Only increment the counter after the opening logo (3s)
	}

	if(frameCount%3 == 0 && historyCounter < (width/2)-5 && !pD)	// every third frame for no physical distancing
	{
		historyH[historyCounter] = numHealthy;
		historyI[historyCounter] = numInfected;
		historyR[historyCounter] = numRecovered;
		historyD[historyCounter] = numDead;
		if(historyI[historyCounter] >= historyI[peakI])			// same applies for everything else
		{
			peakI = historyCounter;
			peakVC = numInfected + numDead;
			peakVA = numInfected;
		}
		if(millis() > 3000) historyCounter++;
	}
	//-----------------------------------

	// This massive for loop deals with drawing the graph
	// There are two graph modes, 0 = absolute and 1 = cumulative
	for (i = 1; i < historyH.length; i++)  // Go through all the arrays from 0 to length
  {
    if (historyH[i]==0 && historyI[i]==0 && historyR[i]==0 && historyD[i]==0) continue;   // if all the arrays are at 0 (default) then ignore

    if (historyR[i]!=0)  // Otherwise, draw the graph point for recovered first
    {
      stroke(recoveredc);	// Change stroke to recovered color (purple)
			if(graphMode == 0)	// If absolute
			{
			strokeWeight(2);
			line(i, map(historyR[i-1],0,numOfBalls,195,1), i+1, map(historyR[i],0,numOfBalls,195,1)); // Draw a line between the previous point and this one, mapped to the height of the graph section
			}
			if(graphMode == 1)	// If cumulative
			{
				strokeWeight(1);
				line(i+1, 0, i+1, map(historyR[i],0,numOfBalls,0,195));	// Draw a line from the top of the screen to this value, mapped to match the graph section
			}
    }

    if (historyH[i]!=0)    // The same works for the other three, this is the healthy cases section
    {
      stroke(healthyc);
			if(graphMode == 0)
			{
			strokeWeight(2);
			line(i, map(historyH[i-1],0,numOfBalls,195,1), i+1, map(historyH[i],0,numOfBalls,195,1));
			}
			if(graphMode == 1)
			{
				strokeWeight(1);
				line(i+1, map(historyR[i],0,numOfBalls,0,195), i+1, map(historyR[i]+historyH[i],0,numOfBalls,0,195));		// For cumulative, you have to draw the line from where recoveries ended to where you map the healthy cases
			}
		}

    if (historyI[i]!=0)
    {
      stroke(infectedc);
			if(graphMode == 0)
			{
			strokeWeight(2);
			line(i, map(historyI[i-1],0,numOfBalls,195,1), i+1, map(historyI[i],0,numOfBalls,195,1));
			}
			if(graphMode == 1)
			{
				strokeWeight(1);
				line(i+1, map(historyR[i]+historyH[i],0,numOfBalls,0,195), i+1, map(historyR[i]+historyH[i]+historyI[i],0,numOfBalls,0,195));
			}
		}

    if (historyD[i]!=0)
    {
			stroke(deadc);
			if(graphMode == 0)
			{
			strokeWeight(2);
			line(i, map(historyD[i-1],0,numOfBalls,195,1), i+1, map(historyD[i],0,numOfBalls,195,1));
			}
			if(graphMode == 1)
			{
				strokeWeight(1);
				line(i+1, map(historyR[i]+historyH[i]+historyI[i],0,numOfBalls,0,195), i+1, map(historyR[i]+historyH[i]+historyI[i]+historyD[i],0,numOfBalls,0,195));
			}
    }
  }
	//----------------------------------- End of graph drawing section

	// This section writes the peak text
	if((numHealthy == 0 || numInfected == 0 || historyCounter>=(width/2)-5)) // Only happens when the outbreak is over or the graph meets its end
	{
		noStroke();
		textAlign("right");
		fill(0);
		if(graphMode==1) text("peak infected",peakI-5,map(peakVC,0,numOfBalls,195,1));	// text at the peak position
		else {
			fill(213);
			text("peak infected",peakI-5,map(peakVA,0,numOfBalls,195,1));
		}
		textAlign("left");
		fill(0);
		if (graphMode == 1) text(historyI[peakI],peakI+5,map(peakVC,0,numOfBalls,195,1));
		else {
			fill(213);
			text(historyI[peakI],peakI+5,map(peakVA,0,numOfBalls,195,1));
		}
		stroke(0);
		strokeWeight(1);
		line(peakI,0,peakI,195);
	}
	//-----------------------------------

	// Drawing the lines outlining the different sections of the simulator
	stroke(dark);
	strokeWeight(10);
	line(width/2,0,width/2,height);
	line(0,200,width/2,200);
	line(0,340,width/2,340);
	strokeWeight(5);
	line(width/4,340,width/4,height);

	// This block writes the current count of healthy, infected, dead and recovered
	strokeWeight(1);
	textSize(80);
	textStyle(BOLD);
	textAlign(CENTER);
	fill(healthyc);
	text(numHealthy, width/16, 280);
	fill(infectedc);
	text(numInfected, 3*width/16, 280);
	fill(recoveredc);
	text(numRecovered, 5*width/16, 280);
	fill(deadc);
	text(numDead, 7*width/16, 280);
	textSize(20);
	fill(healthyc);
	text("healthy", width/16, 320);
	fill(infectedc);
	text("infected", 3*width/16, 320);
	fill(recoveredc);
	text("recovered", 5*width/16, 320);
	fill(deadc);
	text("deceased", 7*width/16, 320);

	// this loop displays the toggles
	for(i = 0; i < toggles.length; i++)
	{
		toggles[i].display();
	}

	// These are the label texts for the toggle switches
	fill(190);
	textSize(10);
	textAlign("center");
	text("mode",(width/8),(height/24)*12.2-2+height/16-15);
	text("graph",(width/8)+width/4,(height/12)*7+height/2-height/5-3);

	// If the graph mode toggle (number 0) changes, change the graph mode
	if(toggles[0].on) graphMode = 0;
	else graphMode = 1;

	// This section draws the little "previews" of the cumulative and line graphs
	// They are actually real-time indicators, but they also serve as a visual representative of what that particular graph mode looks like

	if(numRecovered != 0){
	// This one draws the cumulative indicator
	fill(recoveredc);
	rect(width/64+width/4,(height/24)*12.2+height/2-height/6,width/16,map(numRecovered,0,numOfBalls,0,height/12+8));
	// This part the line indicator
	strokeWeight(2);
	stroke(recoveredc);
	line(width/4-width/64-width/16+width/4,map(numRecovered,0,numOfBalls,(height/24)*12.2+height/12+8+height/2-height/6,(height/24)*12.2+height/2-height/6),width/4-width/64+width/4,map(numRecovered,0,numOfBalls,(height/24)*12.2+height/12+8+height/2-height/6,(height/24)*12.2+height/2-height/6));
	noStroke();
	}

	// Same goes for the rest
	if(numHealthy != 0){
	fill(healthyc);
	rect(width/64+width/4,(height/24)*12.2+height/2-height/6+map(numRecovered,0,numOfBalls,0,height/12+8),width/16,map(numHealthy,0,numOfBalls,0,height/12+8));
	strokeWeight(2);
	stroke(healthyc);
	line(width/4-width/64-width/16+width/4,map(numHealthy,0,numOfBalls,(height/24)*12.2+height/2-height/6+height/12+8,(height/24)*12.2+height/2-height/6),width/4-width/64+width/4,map(numHealthy,0,numOfBalls,(height/24)*12.2+height/2-height/6+height/12+8,(height/24)*12.2+height/2-height/6));
	noStroke();}

	if(numInfected != 0){
	fill(infectedc);
	rect(width/64+width/4,(height/24)*12.2+height/2-height/6+map(numRecovered,0,numOfBalls,0,height/12+8)+map(numHealthy,0,numOfBalls,0,height/12+8),width/16,map(numInfected,0,numOfBalls,0,height/12+8));
	strokeWeight(2);
	stroke(infectedc);
	line(width/4-width/64-width/16+width/4,map(numInfected,0,numOfBalls,(height/24)*12.2+height/2-height/6+height/12+8,(height/24)*12.2+height/2-height/6),width/4-width/64+width/4,map(numInfected,0,numOfBalls,(height/24)*12.2+height/12+8+height/2-height/6,(height/24)*12.2+height/2-height/6));
	noStroke();}

	if(numDead != 0){
	fill(deadc);
	rect(width/64+width/4,(height/24)*12.2+height/2-height/6+map(numRecovered,0,numOfBalls,0,height/12+8)+map(numHealthy,0,numOfBalls,0,height/12+8)+map(numInfected,0,numOfBalls,0,height/12+8),width/16,map(numDead,0,numOfBalls,0,height/12+8));
	strokeWeight(2);
	stroke(deadc);
	line(width/4-width/64-width/16+width/4,map(numDead,0,numOfBalls,(height/24)*12.2+height/12+8+height/2-height/6,(height/24)*12.2+height/2-height/6),width/4-width/64+width/4,map(numDead,0,numOfBalls,(height/24)*12.2+height/12+8+height/2-height/6,(height/24)*12.2+height/2-height/6));
	noStroke();}
	//-----------------------------------

	for(i = 0; i < 50; i++)
	{
		smallBalls[i].update();		// Here we just update the "smallballs" array, the little balls that are inside the "preview" element for physical distancing and business as usual
	}

	// This part deals with the sliders
	fill(light);	// Make the text color 'light'
	textSize(20);
	if(slider1 != null && slider2 != null)
	{
	// Values text for the two sliders
	text(slider1.value(), width/64+width/8+width/32+width/16-15, (height/8)*7+15-height/6+height/64);
	text(slider2.value(), width/64+width/8+width/32+width/16-15, (height/16)*15+15-height/6+height/64);
	}
	fill(190);
	textSize(14);
	textAlign("right");
	// Then we have the label text for the two sliders
	text("population", width/12-25,(height/8)*7+15-height/6+height/64);
	text("% death rate", width/12-25,(height/16)*15+15-height/6+height/64);

	// Here we have the title text and the paragraph for the extra information
	textAlign("center");
	textSize(20);
	textStyle(BOLD);
	if(pD) text("physical distancing",3*width/8,height/2+height/32);
	else text("business as usual",3*width/8,height/2+height/32);
	textStyle(NORMAL);
	textSize(12);
	textAlign("left");
	text(stringTemp, width/4+width/64, height/2+height/32+height/32+height/64);

	// If the sliders have been made already
	if(slider1 != null && slider2 != null)
	{
	tempNOB = slider1.value();		// We save their values and the value of the second toggle switch for if the simulation is reset
	tempCOD = slider2.value();
	tempPD = toggles[1].on;
	}

	// If we're on the first run of the simulation
	if(firstRun)
	{
		if(millis() < 3000) fill(0);		// For the first three seconds, we want completely black background
		else(fill(0,map(5000-millis(),0,2000,0,255)));	// After that we want to fade out the black background, so we give the fill an alpha (transparency) value of a mapping of 5000 minus the current millis()
		rect(0,0,width,height);			// Draw a rectangle covering the whole screen
		textAlign("center");
		textSize(150);
		if(millis() < 3000) fill(190);
		else(fill(190,map(5000-millis(),0,2000,0,255)));
		textStyle(BOLD);
		text("PandemicSim", width/2, height/2+height/16);		// Then write the logo (also fade this out)
	}

	if(millis() > 6000) firstRun = false;		// First run is false after 6000 ms

}

// The ball class is what runs the show basically
// Everything that this ball is defined to do mimics the outbreak of a pandemic
class Ball {

	constructor(_x,_y,_type,_distancing){			// You initialize it with its x and y starting position, type (healthy, infected etc.) and whether it is physical distancing or not
		this.x = _x;
		this.y = _y;
		this.V = 2;				// Vector velocity of the ball
		this.r = 15;			// Diameter of the ball (r is a misnomer)
		// Setting the rest of the values
		this.type = _type;
		this.dead = false;
		this.distancing = _distancing;
		// Random value between 1 and 100, determines if this ball will die when infected or not
		this.deathFactor = random(100);
		// A timer for the time a ball will be infected for
		this.startTime = millis();
		// The amount of time the ball will remain infected if infected (between 7 and 13 seconds)
		this.timeInfected = random(7000, 13000);
		// Setting an x velocity as random
		this.velX = random(-this.V, this.V);
		// Making the y veolicty based on that x velocity so that they vector sum to 2, the total
		if (random(-1, 1) > 0) // This part randomly chooses whether Y will be positive or negative
    {
      this.velY = sqrt((this.V * this.V) - (this.velX * this.velX));                // Calculate Y so that the vector sum of Y and X equals V
    } else {
      this.velY = sqrt((this.V * this.V) - (this.velX * this.velX)) * -1;           // Negative if randomly chosen so
    }
	}

	// Displaying the balls
	display(){
		// Gray if dead and then return
		if(this.dead){
			noStroke();
			fill(deadc);
			ellipse(this.x, this.y, this.r);
			stroke(0);
			return;
		}
		// Switch based on the type of ball, changing its fill
		switch(this.type){
			case 0:
				fill(healthyc);
				break;
			case 1:
				fill(infectedc);
				break;
			case 2:
				fill(recoveredc);
		}
		noStroke();
		ellipse(this.x, this.y, this.r);	// Drawing the ball at its x and y
		stroke(0);
	}

	update(){		// the update function handles changing the balls position and its type

		if(!this.distancing)		// if we're distancing don't move
		{
		this.x += this.velX;
		this.y += this.velY;
		}

		if (this.x-(this.r/2) <= width/2+5 && this.velX < 0)      // If the x position (including the radius) is less than/equal to the boundary, and it's still moving in that direction
    {
      this.velX *= -1;                              // Reverse the velocity of the ball
    }

    if (this.x+(this.r/2) >= width && this.velX > 0)    // Same concept as above with right x boundary
    {
      this.velX *= -1;
    }

    if (this.y-(this.r/2) <= 0 && this.velY < 0)  // Same with Y and top boundary
    {
      this.velY *= -1;
    }

    if (this.y+(this.r/2) >= height && this.velY > 0)    // Same with bottom boundary
    {
      this.velY *= -1;
		}

		if (this.type == 1 && ((millis() - this.startTime) > this.timeInfected))  // If the ball type is infected and the difference between current time and the time of infection is greater than the time it should be infected for
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

	// The intersects function handles what happens when balls touch
	intersects(){
		// You have to first check if this ball is touching another
		for(var i = 0; i < numOfBalls; i++)
		{
			if(balls[i].dead) continue;		// Ignore if that ball is dead
			if(this == balls[i]) continue;	// Continue if this ball is equal to the one in the array you're currently at
			// These two lines are a small improvement to run time
			// Basically if a ball gets through these two it means they are touching us
			if(abs(balls[i].x - this.x) > this.r) continue;
			if(abs(balls[i].y - this.y) > this.r) continue;
			// If they're infected and we're not or we're infected and they're not
			if((this.type == 0 && balls[i].type == 1) || (this.type == 1 && balls[i].type == 0))
			{
				if(this.type == 0) this.startTime = millis();		// If we were healthy set our start time to millis()
				if(balls[i].type == 0) balls[i].startTime = millis();		// If they were healthy set their start time to millis()
				balls[i].type = 1;		// Make sure we're both now infected
				this.type = 1;
				numInfected++;				// Increment the number of infected
				numHealthy--;					// Decrement the number of healthy
			}
			this.velX = (this.V/(2*this.r))*(this.x - balls[i].x);                  // Otherwise set my x velocity to the difference between my x and their x, and same for y
      this.velY = (this.V/(2*this.r))*(this.y - balls[i].y);
		}
	}
}

// The toggle class is basically a blue toggle button
class toggle {

	constructor (_x,_y,_on)			// Its x and y position, plus a boolean to say if its on or not
	{
		this.x = _x-20;
		this.y = _y;
		this.on = _on;
	}

	display()					// Drawing the button
	{
		noStroke();
		fill(medLight);
		ellipse(this.x,this.y,30);
		ellipse(this.x+30,this.y,30);
		rect(this.x,this.y-15,30,30);
		fill(light);
		if(this.on){
			ellipse(this.x+30,this.y,25);
		}else{
			ellipse(this.x,this.y,25);
		}
	}

	click()						// A function to change the toggle
	{
		if(mouseX > this.x-15 && mouseX < this.x+45 && mouseY < this.y+15 && mouseY > this.y-15){
		this.on = !this.on;
		}
	}
}

// The built in mouseClicked function for handling mouse clicks
function mouseClicked()
{
	for(var i = 0; i < toggles.length; i++)
	{
		toggles[i].click();		// Run through the toggles to see if they've been clicked
	}

	// These first two are the previews for the graph modes
	if(mouseX > width/4-width/64-width/16-2+width/4 && mouseX < width/4-width/64-width/16-2+width/16+4+width/4){
		 if(mouseY > (height/24)*12.2-2+height/2-height/6 && mouseY < (height/24)*12.2-2+height/12+8+4+height/2-height/6)
		 {
			 toggles[0].on = true;
		 }
	 }

	if(mouseX > width/64-2+width/4 && mouseX < width/64-2+width/16+4+width/4)
	{
		if(mouseY > (height/24)*12.2-2+height/2-height/6 && mouseY < (height/24)*12.2-2+height/12+8+4+height/2-height/6)
		{
			toggles[0].on = false;
		}
	}

	// These two are the previews for the simulation mode (pd or not pd)
	if(mouseX > width/64-2 && mouseX < width/16+4+width/64-2)
	{
		if(mouseY > (height/24)*12.2-2 && mouseY < (height/24)*12.2-2+height/12+8+4)
		{
			toggles[1].on = false;
		}
	}

	if(mouseX > width/4-width/64-width/16-2 && mouseX < width/4-width/64-width/16-2+width/16+4)
	{
		if(mouseY > (height/24)*12.2-2 && mouseY < (height/24)*12.2-2+height/12+8+4)
		{
			toggles[1].on = true;
		}
	}
}

// Just checking whether a ball is spawned on top of another, useful for the physical distancing mode
function checkCollided(index, ourX, ourY)
{
	for (var j = 0; j < index; j++)               // Check with all previous balls that they are not colliding with your x and y
      {
        if (dist(ourX, ourY, balls[j].x, balls[j].y) <= 2*balls[j].r) {  // If the distance between the points
          return true;                                                                  // is greater than the sum of the radii
        }
      }
  return false;
}

// The small balls used in the distancing/business-as-usual previews
// All they basically do is bounce against the walls and move
class smallBall{

	constructor(_x,_y,_x1,_y1,_xw,_yw,_pd)		// The constructor takes the x and y values of the balls, the dimensions of the box they're in, and whether they are "pd" (standing still) or not
	{
		this.x = _x;
		this.y = _y;
		this.xv = random(-1,1);
		this.yv = random(-1,1);
		this.x1 = _x1+2;
		this.y1 = _y1+4;
		this.xw = _xw-2;
		this.yw = _yw-6;
		this.pd = _pd;
	}

	update()			// Updating them basically moves them and makes them bounce off the walls
	{
		strokeWeight(3);
		if(this.pd) stroke(110, 175, 250);
		else stroke(infectedc);
		point(this.x,this.y);
		noStroke();
		if(!this.pd)
		{
		this.x+=this.xv;
		this.y+=this.yv;
		}
		if(this.x <= this.x1 && this.xv < 0)
		{
			this.xv *= -1;
		}
		if(this.x >= this.x1+this.xw && this.xv > 0)
		{
			this.xv *= -1;
		}
		if(this.y <= this.y1 && this.yv < 0)
		{
			this.yv *= -1;
		}
		if(this.y >= this.y1+this.yw && this.yv > 0)
		{
			this.yv *= -1;
		}
	}

}
