//VR Glove Code
//Limit switch activations and pin declarations

//defining digital pins
const int thumb = 3;
const int index = 4;
const int middle = 5;
const int ring = 6;
const int pinky = 7;


void setup() {
  Serial.begin(115200);
  pinMode(thumb, INPUT_PULLUP);
  pinMode(index, INPUT_PULLUP);
  pinMode(middle, INPUT_PULLUP);
  pinMode(ring, INPUT_PULLUP);
  pinMode(pinky, INPUT_PULLUP);

 Serial.println("VR engaged.");
}

void loop() {
  if (digitalRead(thumb) == LOW)
    Serial.println("Thumb Pressed");

  if (digitalRead(index) == LOW)
    Serial.println("Index Pressed");

  if (digitalRead(middle) == LOW)
    Serial.println("Middle Pressed");

  if (digitalRead(ring) == LOW)
    Serial.println("Ring Pressed");

  if (digitalRead(pinky) == LOW)
    Serial.println("Pinky Pressed");

}