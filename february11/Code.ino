/*
 Daniel de Beer
 Piano Teacher Code 
 9 February 2020
 
 Code from:
 
 1) Library originally added 18 Apr 2008
    by David A. Mellis
    library modified 5 Jul 2009
    by Limor Fried (http://www.ladyada.net)
    example added 9 Jul 2009
    by Tom Igoe
    modified 22 Nov 2010
    by Tom Igoe
    modified 7 Nov 2016
    by Arturo Guadalupi

 2) SparkFun Inventor’s Kit
    Circuit 2B-DigitalTrumpet
    
*/

// include the library code:
#include <LiquidCrystal.h>

// initialize the library by associating any needed LCD interface pin
// with the arduino pin number it is connected to
const int rs = 13, en = 12, d4 = 11, d5 = 10, d6 = 9, d7 = 8;
LiquidCrystal lcd(rs, en, d4, d5, d6, d7);

//set the pins for the button and buzzer
int firstKeyPin = 3;
int secondKeyPin = 4;
int thirdKeyPin = 5;
int pin4 = 6;
int pin5 = 7;

int buzzerPin = 2; // This sets the pin for the buzzer being used

bool A1on = false, A2on = false, A3on = false, A4on = false, A5on = false;  // Boullion variables to see if the LED lights are on or not

void setup() {
  // set up the LCD's number of columns and rows:
  lcd.begin(16, 2);
  // Print a message to the LCD.
  lcd.print("Welcome! :D");
  lcd.setCursor(0, 1);
  lcd.print("Note: ");

  //set the button pins as inputs
  pinMode(firstKeyPin, INPUT_PULLUP);
  pinMode(secondKeyPin, INPUT_PULLUP);
  pinMode(thirdKeyPin, INPUT_PULLUP);
  pinMode(pin4, INPUT_PULLUP);
  pinMode(pin5, INPUT_PULLUP);

  //set the LED pins as outputs 
  pinMode(A5, OUTPUT);
  digitalWrite(A5, LOW);
  pinMode(A4, OUTPUT);
  digitalWrite(A4, LOW);
  pinMode(A3, OUTPUT);
  digitalWrite(A3, LOW);
  pinMode(A2, OUTPUT);
  digitalWrite(A2, LOW);
  pinMode(A1, OUTPUT);
  digitalWrite(A1, LOW);

  //set the buzzer pin as an output
  pinMode(buzzerPin, OUTPUT);
}

void loop() {
  
  if(digitalRead(firstKeyPin) == LOW){        //if the first key is pressed
    lcd.setCursor(6, 1);
    lcd.print("G"); 
    A5on = true;
    tone(buzzerPin, 392);                     //play the frequency for c
  }
  else if(digitalRead(secondKeyPin) == LOW){  //if the second key is pressed
    lcd.setCursor(6, 1);
    lcd.print("F");
    A4on = true;
    tone(buzzerPin, 349);                     //play the frequency for e
  }
  else if(digitalRead(thirdKeyPin) == LOW){   //if the third key is pressed
    lcd.setCursor(6, 1);
    lcd.print("E");
    A3on = true;
    tone(buzzerPin, 330);                     //play the frequency for g
  }
  else if(digitalRead(pin4) == LOW){  //if the second key is pressed
    lcd.setCursor(6, 1);
    lcd.print("D");
    A2on = true;
    tone(buzzerPin, 294);                     //play the frequency for e
  }
  else if(digitalRead(pin5) == LOW){          //if the third key is pressed
    lcd.setCursor(6, 1);
    lcd.print("C");
    A1on = true;
    tone(buzzerPin, 262);                     //play the frequency for g
  }
  else{
    lcd.setCursor(6, 1);
    lcd.print(" ");
    A1on = false;
    A2on = false;
    A3on = false;
    A4on = false;
    A5on = false;
    noTone(buzzerPin);                        //if no key is pressed turn the buzzer off
  }

  // if the button was pressed, switch the LED to high
  if(A1on)
  {
    digitalWrite(A1, HIGH);
  }else digitalWrite(A1, LOW); // Otherwise switch it off
  if(A2on)
  {
    digitalWrite(A2, HIGH);
  }else digitalWrite(A2, LOW);
  if(A3on)
  {
    digitalWrite(A3, HIGH);
  }else digitalWrite(A3, LOW);
  if(A4on)
  {
    digitalWrite(A4, HIGH);
  }
  else digitalWrite(A4, LOW);
  if(A5on)
  {
    digitalWrite(A5, HIGH);
  }else digitalWrite(A5, LOW);
}
