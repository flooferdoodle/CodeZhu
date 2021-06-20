Ship ship;
Bullet b;
final float bulletSize = 15;
PShape bulletShape;
int teleportShip = 0;
int makeChild = 0;
boolean training = false;
boolean drawing = true;

boolean[] keys = new boolean[5];
ArrayList<Alien> aliens;
void setup(){
  size(900,700);
  
  //bulletShape = createShape(QUAD,bulletSize,0,0,bulletSize/5,-bulletSize,0,0,-bulletSize/5);
  bulletShape = createShape();
  bulletShape.beginShape();
  bulletShape.vertex(bulletSize,0);
  bulletShape.vertex(0,bulletSize/4);
  bulletShape.vertex(-bulletSize,0);
  bulletShape.vertex(0,-bulletSize/4);
  bulletShape.endShape(CLOSE);
  
  
  ship = new Ship(bulletShape);
  aliens = new ArrayList<Alien>();
  for(int i = 0;i<50;i++){
    aliens.add(new Alien(bulletShape));
  }
  rectMode(CENTER);
  
}

void draw(){
  background(0);
  
  if(training){
    if(teleportShip>500){
      ship.pos.x = random(width);
      ship.pos.y = random(height);
      ship.updateHbx();
      teleportShip -= 500;
    }
    else{
      teleportShip++;
    }
    
    //vision of aliens
    for(Alien a : aliens){
      a.think(ship);
      if(drawing)a.drawObj();
      
      a.updateVision();
      
      push();
      stroke(255);
      //score based on hits
      /*
      if(ship.collision(a.vision)){
        stroke(255,0,0);
        a.score++;
      }*/
      
      //score based on angles
      float angle = (float) Math.atan2((ship.pos.y-a.pos.y),(ship.pos.x-a.pos.x));
      if(angle<0) angle += 2*PI;
      if(a.rot<0) a.rot += 2*PI;
      a.score += Math.abs(angle-a.rot);
      /*
      push();
      fill(0,0,255,50);
      arc(a.pos.x,a.pos.y,2*dist(a.pos.x,a.pos.y,ship.pos.x,ship.pos.y),2*dist(a.pos.x,a.pos.y,ship.pos.x,ship.pos.y),0,angle);
      pop();*/
      
      
      if(drawing) line(a.vision.start.x,a.vision.start.y,a.vision.end.x,a.vision.end.y);
      pop();
    }
    
    
    if(makeChild > 1000){
      Collections.sort(aliens);
      aliens.remove(0);
      aliens.add(new Alien(aliens.get(aliens.size()-1),aliens.get(aliens.size()-2)));
      makeChild -= 1000;
    }
    else
      makeChild++;
  }
  else{
    moveShip();
    ship.move();
    
    for(Alien a : aliens){
      a.think(ship);
      a.drawObj();
      for(int i = 0;i<a.shots.size();i++){
        if(ship.collision(a.shots.get(i))){
          //print("hit");
          a.score++;
          break;
        }
      }  
    }
  }
  if(drawing)ship.drawObj();
  
  
  
  
  
  

}

void keyPressed(){
  if(key == CODED){
    if(keyCode == UP)
      keys[0] = true;
    if(keyCode == DOWN)
      keys[1] = true;
    if(keyCode == RIGHT)
      keys[2] = true;
    if(keyCode == LEFT)
      keys[3] = true;
  }
  if(key == ' ')
    keys[4] = true;
  if(key == 'd')
    drawing = !drawing;
}
void keyReleased(){
  if(key == CODED){
    if(keyCode == UP)
      keys[0] = false;
    if(keyCode == DOWN)
      keys[1] = false;
    if(keyCode == RIGHT)
      keys[2] = false;
    if(keyCode == LEFT)
      keys[3] = false;
  }
  if(key == ' ')
    keys[4] = false;
  
}

void moveShip(){
  if(keys[0])
    ship.input("U");
  if(keys[1])
    ship.input("D");
  if(keys[2])
    ship.input("R");
  if(keys[3])
    ship.input("L");
  if(keys[4])
    ship.input("FIRE");
}
