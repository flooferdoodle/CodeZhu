class Goal extends Collidable{
  static final int size = 64;
  
  Goal(){
    hbx = new Hitbox(0,0,size,size);
  }
  Goal(float x, float y){//by top left
    hbx = new Hitbox(x,y,x+size,y+size);
  }
  
  void update(float x, float y){
    hbx.x1 = x;
    hbx.y1 = y;
    hbx.x2 = x+size;
    hbx.y2 = y+size;
  }
  
  void draw(){
    
    push();
    noStroke();
    fill(158, 240, 255);
    rectMode(CORNERS);
    rect(hbx.x1,hbx.y1,hbx.x2,hbx.y2);
    pop();
  }
}
