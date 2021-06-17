float a_rot = 0;
float b_rot = 0;
float rot = 0;
int a_speed = 4;
int b_speed = 3;
Button a_add, a_sub, b_add, b_sub;
int lcm = 1;

int getLCM(int a, int b){
  lcm = 1;
  while(true){
    if(lcm%a == 0 && lcm%b == 0){
      break;
    }
    else{
      lcm++;
    }
  }
  println(lcm);
  rot = 0;
  return lcm;
}

void setup() {
  size(800, 700);
  smooth();
  background(200);
  //frameRate(5);
  getLCM(a_speed, b_speed);
  
  //buttons
  a_add = new Button(250, 320, 40, 40, true);
  a_sub = new Button(150-40, 320, 40, 40, false);
  b_add = new Button(650, 620, 40, 40, true);
  b_sub = new Button(550-40, 620, 40, 40, false);
}

ArrayList<float[]> coords = new ArrayList<float[]>();


void draw() {
  background(200);
  
  strokeWeight(3);
  fill(255);
  ellipse(200, 200, 200, 200);
  ellipse(600, 500, 200, 200);
  strokeWeight(5);
  //point(100, 100);
  //point(600, 500);

  //drawing a rotating point
  strokeWeight(10);
  float a_x = 200+(100*cos(a_rot));
  float a_y = 200+(100*sin(a_rot));
  point(a_x, a_y);
  float b_x = 600+(100*cos(b_rot));
  float b_y = 500+(100*sin(b_rot));
  point(b_x, b_y);
  a_rot += 2*PI/360*a_speed;
  b_rot += 2*PI/360*b_speed;
  rot += 2*PI/360;
  
  //drawing lines
  strokeWeight(1);
  line(a_x, a_y, b_x, a_y);
  line(b_x, b_y, b_x, a_y);
  //find intersection
  strokeWeight(10);
  point(b_x, a_y);
  float[] currCoord = {b_x, a_y};
  if(rot <= 2*PI+0.1){
    coords.add(currCoord);
  }
  
  //drawing the final result
  strokeWeight(0.5);
  noFill();
  beginShape();
  for(int i = 0;i<coords.size();i++){
    curveVertex(coords.get(i)[0], coords.get(i)[1]);
  }
  endShape();
  
  
  //buttons
  fill(150);
  a_add.draw();
  a_sub.draw();
  b_add.draw();
  b_sub.draw();
}

void mouseClicked(){
  boolean modified = false;
  if(a_add.isClicked() && a_speed < Float.MAX_VALUE){
    a_speed += 1;
    modified = true;
  }
  else if(a_sub.isClicked() && a_speed > 1){
    a_speed -= 1;
    modified = true;
  }
  else if(b_add.isClicked() && b_speed < Float.MAX_VALUE){
    b_speed += 1;
    modified = true;
  }
  else if(b_sub.isClicked() && b_speed > 1){
    b_speed -= 1;
    modified = true;
  }
  
  if(modified){
    coords.clear();
    getLCM(a_speed, b_speed);
  }
}
