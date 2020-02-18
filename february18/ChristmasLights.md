# Christmas Lights

## Description:

The story is this: Santa Claus is irritated with his elves. They keep changing the christmas light settings. So he decides to put a password in so that only he has access to the controlls to change the settings.

The setup has four buttons, each numbered from 1 to 4, plus a reset button. You type in the passcode and press the reset button, and then if the code is right you can adjust the settings for the Christmas lights. This adjustments happens with two potentiomenters using digitalRead, one which controls the speed of blinking and the one which controls the brightness of the LEDs. I used a string to store the "real" password and one to store whatever is inputted. When the buttons with numbers are pressed their number is added to this input string. This is compared with the real password when the reset button is pressed, and then if it's correct you're in. Otherwise you have to try again. The size of password only limited to the maximum string size.

The only problems I faced were with the button setup, as I forgot to add the 10kOhms potentiometer. This made the signal wacky, but it was a quick fix. One potential extension is to add the ability to change the password for the system.

### Circuit Diagram:

![](circuit.jpg)

### Some Images:

![](image1.JPG)

![](image2.JPG)

