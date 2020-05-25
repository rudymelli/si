// Rudy Melli - Sistemi Interattivi, 2018
// Collegare GND, OUT al pin 9 e VCC 5V, il 4 pin non è utilizzato
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(9, INPUT); //Sensor output
}
void loop(){
  delay(50);
  if(digitalRead(9))
    Serial.println("Obstacle NOT detected");
  else
    Serial.println("Obstacle detected");
}

