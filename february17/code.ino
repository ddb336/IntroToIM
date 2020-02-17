
String passWord, real = "13234";

int red = 4, yellow = 5, green = 6, blue = 7;
int buzzerPin = 12;

bool loggedIn = false;



void setup() {
  // put your setup code here, to run once:
  for (int i = 4; i < 8; i++) {
    pinMode(i, INPUT);
  } // All the pint 3-7 are input
  pinMode(2, INPUT); //Reset button

  pinMode(3, OUTPUT);
  pinMode(9, OUTPUT);
  pinMode(10, OUTPUT);
  pinMode(11, OUTPUT);
 
  pinMode(buzzerPin, OUTPUT);
  digitalWrite(8, LOW);
  Serial.begin(9600);
}


void loop() {

  if (loggedIn == false) {
    digitalWrite(3, LOW);
    if (digitalRead(2) == HIGH)
  {
    if (passWord == real) {
      loggedIn = true;
      tone(buzzerPin, 392); // Play login sound
      delay(300);
      noTone(buzzerPin);  
      delay(200);
      tone(buzzerPin, 392);
      delay(300);
      noTone(buzzerPin);  
      delay(200);
      tone(buzzerPin, 392);
      delay(300);
      noTone(buzzerPin);  
      }
    else{
      passWord = ""; 
      tone(buzzerPin, 262);
      delay(1000);
      noTone(buzzerPin);
    }
  }

    if (digitalRead(red) == HIGH)
    {
      passWord += "4";
      delay(500);
    }
    if (digitalRead(yellow) == HIGH)
    {
      passWord += "3";
      delay(500);
    }
    if (digitalRead(green) == HIGH)
    {
      passWord += "2";
      delay(500);
    }
    if (digitalRead(blue) == HIGH)
    {
      passWord += "1";
      delay(500);
    }

  }

  else {

      if (digitalRead(2) == HIGH)
      {
        loggedIn = false;
        passWord = "";
        delay(500);
        loop();
      }

  analogWrite(3, constrain(map(analogRead(A4), 0, 1023, 0, 60), 0, 60));
  analogWrite(9, constrain(map(analogRead(A4), 0, 1023, 0, 60), 0, 60));
  analogWrite(10, constrain(map(analogRead(A4), 0, 1023, 0, 60), 0, 60));
  analogWrite(11, constrain(map(analogRead(A4), 0, 1023, 0, 60), 0, 60));
  delay(constrain(map(analogRead(A3), 0, 1023, 0, 255), 0, 255) * 2);
  digitalWrite(3, LOW);
  digitalWrite(9, LOW);
  digitalWrite(10, LOW);
  digitalWrite(11, LOW);
  delay(constrain(map(analogRead(A3), 0, 1023, 0, 255), 0, 255) * 2);
  
  Serial.println(analogRead(A4));
      
  }
  
}
