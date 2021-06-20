Ship ship;
Bullet b;
int score = 0;
final float bulletSize = 15;
PShape bulletShape;
int alienSpawnRate = 180;
boolean dead = false;

boolean[] keys = new boolean[5];
ArrayList<Alien> aliens;
void setup(){
  size(900,700);
  
  //initialize bullet shape
  bulletShape = createShape();
  bulletShape.beginShape();
  bulletShape.vertex(bulletSize,0);
  bulletShape.vertex(0,bulletSize/4);
  bulletShape.vertex(-bulletSize,0);
  bulletShape.vertex(0,-bulletSize/4);
  bulletShape.endShape(CLOSE);
  
  ship = new Ship(bulletShape);
  aliens = new ArrayList<Alien>();
  
  rectMode(CENTER);
  
}

//reset game
void reset(){
  dead = false;
  
  ship.reset();
  
  aliens.clear();
  
  alienSpawnRate = 180;
  
  score = 0;
  
  loop();
  
}

//move all on screen objects
void updateObjects(){
  //player movement
  moveShip();
  ship.move();
  
  //move aliens and alien shots
  updateAliens();
  
  //draw player
  ship.drawObj();
  
  //handle alien spawning
  if(count >= alienSpawnRate){
    count %= alienSpawnRate;
    if(alienSpawnRate > 50) alienSpawnRate -= 10;
    else alienSpawnRate = 50;
    spawnAlien();
  }
  count++;
}

void updateAliens(){
  LinkedList<Alien> destroyed = new LinkedList<Alien>();
  
  for(Alien a : aliens){
    //move and draw each alien
    a.move();
    a.drawObj();
    //check if any alien shots collided with ship
    for(int i = 0;i<a.shots.size();i++){
      if(ship.collision(a.shots.get(i))){
        dead = true;
        break;
      }
    }
    //check if alien was shot
    for(Bullet b : ship.shots){
      if(a.collision(b)){
        score++;
        destroyed.add(a);
        break;
      }
    }
  }
  //delete shot aliens
  for(Alien a : destroyed)
    aliens.remove(a);
}

void spawnAlien(){
  int x = 0;
  int y = 0;
  //choose random screen side to spawn
  double side = Math.random();
  if(side < 0.25){
    //top
    x = (int) (Math.random()*width);
  }
  else if (side < 0.5){
    //right
    y = (int) (Math.random()*height);
    x = width;
  }
  else if(side < 0.75){
    //bottom
    x = (int) (Math.random()*width);
    y = height;
  }
  else{
    //left
    y = (int) (Math.random()*height);
  }
  //find rotation for alien
  float rot = atan2(ship.pos.y-y,ship.pos.x-x);
  
  aliens.add(new Alien(x,y,rot,5,bulletShape));
}


int count = 0;
//draw function runs every few frames
void draw(){
  background(0);
  
  //move onscreen items
  updateObjects();
  
  //score display
  push();
  stroke(0);
  strokeWeight(100);
  fill(100,255,100);
  textSize(16);
  text("Score: " + score, 10, 20);
  pop();
  
  //death event
  if(dead){
    push();
    stroke(0);
    strokeWeight(100);
    fill(100,255,100);
    textSize(32);
    text("You lost. R to restart", width/2 - 180, 50);
    
    pop();
    noLoop();
  }
}


//user key presses
void keyPressed(){
  if(key == CODED){
    //movement
    if(keyCode == UP)
      keys[0] = true;
    if(keyCode == DOWN)
      keys[1] = true;
    if(keyCode == RIGHT)
      keys[2] = true;
    if(keyCode == LEFT)
      keys[3] = true;
  }
  //fire
  if(key == ' ')
    keys[4] = true;
  //restart
  if(key == 'r')
    reset();
}
void keyReleased(){
  //movement
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
  //fire
  if(key == ' ')
    keys[4] = false;
  
}

//send user input to ship
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
