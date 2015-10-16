long int t = 0; 
void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600); // msp430g2231 must use 4800
  // make the on-board pushbutton's pin an input pullup:
  
}

// the loop routine runs over and over again forever:
void loop() {
  // read the input pin:
  t++;
  // print out the state of the button:
  Serial.println(buttonState);
  if( t == 1000 )  t = 0;
  delay(100);        // delay in between reads for stability
}



