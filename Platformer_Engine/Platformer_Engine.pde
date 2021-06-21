LevelManager lvlm;

Player p;
boolean[] keys = new boolean[4];
boolean loading = false;
boolean loaded = false;
int fadeTime = 50;
int fadeColor = 0;


void setup(){
  size(800, 608);
  noStroke();
  lvlm = new LevelManager();
  //INGAME------------------------------------------------------
  textSize(12);
  p = new Player();
  lvlm = new LevelManager();
  lvlm.nextLevel(p);
  
}

void draw(){
  background(192, 198, 207);
  inGame();
  //text(mouseX + " " + mouseY, 10, 10);
}

void inGame(){
  push();
  fill(0,200);
  rect(0,0,width,height);
  pop();
  
  if(loading){
    fade();
    if(fadeColor>=255){
      if(lvlm.nextLevel(p)){
        loading = false;
        loaded = true;
      }
      else{
        lvlm.win = true;
        loading = false;
      }
    }
    return;
  }
  else if(lvlm.dead || lvlm.win){
    fade();
    push();
    fill(255,fadeColor);
    textSize(12);
    if(lvlm.dead) text("You died",width/2-20,height/2 - 20);
    else text("You win!",width/2-20,height/2 - 20);
    text("Space to restart",width/2-20,height/2);
    pop();
    return;
  }
  
  
  
  p.input(keys);
  
  p.move();
  
  lvlm.handle(p);
  
  
  
  if(loaded){
    push();
    fill(0,fadeColor);
    rect(0,0,width,height);
    pop();
    fadeColor -= 255/(fadeTime/2);
    if(fadeColor <= 0){
      fadeColor = 0;
      loaded = false;
    }
  }
}
void death(){
  lvlm.dead = true;
}

void endLevel(){
  loading = true;
}

void fade(){
  p.draw();
  lvlm.draw();
  
  push();
  fill(0,fadeColor);
  rect(0,0,width,height);
  pop();
  fadeColor += 255/fadeTime;
  if(fadeColor >= 255){
    fadeColor = 255;
  }
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
  if(key == ' '){
    if(lvlm.dead){
      lvlm.dead = false;
      lvlm.reset(p);
      loaded = true;
    }
    else if(lvlm.win){
      lvlm.win = false;
      lvlm.restart(p);
      loaded = true;
    }
  }
  if(key == 'r'){
    lvlm.dead = false;
    lvlm.reset(p);
    loaded = true;
  }
    
    
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
}

float absmin(float a, float b){
  return (abs(a)<=abs(b))?a:b;
}
void mouseClicked(){
  p.pos.x = mouseX;
  p.pos.y = mouseY;
}
