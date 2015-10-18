int sensorValue;
float resistor = 10.03*1000;
float voltage = 0; 
float current = 0;
void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600); // msp430g2231 must use 4800
  // make the on-board pushbutton's pin an input pullup:
  
}

// the loop routine runs over and over again forever:
void loop() {
  // read the input pin:
  sensorValue = analogRead(A3);
  // print out the state of the button:
  voltage = sensorValue * (3.0 / 1023.0);
  
  Serial.println(voltage);
}



