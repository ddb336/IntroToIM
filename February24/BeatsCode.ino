/* 
 'Zen Beats Co.'
 
 By Daniel de Beer 
 
 Content taken from:

 - BARRAGAN <http://barraganstudio.com>
   This example code is in the public domain.

 - Scott Fitzgerald (8 Nov 2013)
   http://www.arduino.cc/en/Tutorial/Sweep
*/





#include <Servo.h>

void checkBuzzer();

Servo myservo;  // This is the main beat Servo - three beats and then a rest

Servo mypuller; // This Servo pulls the lid of the box to alter the sound of the beat.
                // produced.

Servo mybeat2;  // This secondary beat hits the top of the box


int pos = 0;      // variable to store the servo position for the main beat

int potpin = A0;  // analog pin used to connect the potentiometer
int val;          // variable to read the value from the analog pin

int beat = 0;  	  // Stores the value of which part of the beat we are on (1-4)

bool offbeat = true;	// Every second 4 beat count we open/close the lid of the box. 
			// This boolean is true every second beat


void setup() {

  pinMode(4, INPUT);	// Setting all the button pins to input
  pinMode(5, INPUT);
  pinMode(6, INPUT);
  
  mypuller.attach(8);	// This attach the puller servo and moves it to angle 100
  mypuller.write(100);
  
  mybeat2.attach(7);	// Attaching the secondary beat servo
  mybeat2.write(110);    

  myservo.attach(9);  	// Attaching the main beat servo
}

void loop() {

  checkBuzzer();
  
  if (offbeat){                     // Every second full measure, the puller servo opens the lid
      mypuller.write(30);           
    }else {mypuller.write(100);}    


  beat++;
  
  if (beat >= 4) {
    
    offbeat = !offbeat;             // Swapping beats every fourth beat count
    
    mybeat2.write(105);             // On the fourth beat, we want th 
    
    for(int i=0; i <= 5; i++){     // Delays 15x the value, but also while checking the buzzer
    checkBuzzer();
    delay(val);
    }
    
    checkBuzzer();
    
    mybeat2.write(110);             // Move secondary servo back
    myservo.write(30);              // Move primary beat servo to position "up"
    
    beat = 1;                       // Reset the main beat counter

    for(int i=0; i <= 25; i++){     // Delays 15x the value, but also while checking the buzzer 
    checkBuzzer();
    delay(val);
    }
    
    loop();
  }
  
  
  val = analogRead(potpin);
  val = map(val, 0, 1023, 15, 30);      // We want the delay to be between 15ms and 30ms
  
  for (pos = 2; pos <= 30; pos += 1) { // goes from 2 degrees to 30 degrees
    // in steps of 1 degree
    myservo.write(pos);              // tell servo to go to position in variable 'pos'
    checkBuzzer();
    delay(val);                       // waits 15ms for the servo to reach the position
    checkBuzzer();
  }
    if (beat!=3){
    myservo.write(2);              // tell servo to go to angle 2
    checkBuzzer();
    delay(val);                    // waits (val)ms for the servo to reach the position
    checkBuzzer();
    }                               
  
}

void checkBuzzer()         // Every time a delay happens, we want to check the buzzer as often as possible
{
  if(digitalRead(6) == HIGH){		// If button is pressed
  tone(12, 523);}			// Play tone

  else if(digitalRead(5) == HIGH){
  tone(12, 587);}

  else if(digitalRead(4) == HIGH){
  tone(12, 659);}

  else {noTone(12);}			// Otherwise switch off
}
