class Saw extends Collidable{
  PVector pos; //center
  int r;
  
  Saw(int x, int y, int r){
    hbx = new Hitbox(x,y,r);
    pos = new PVector(x,y);
    this.r = r;
  }
  
  void draw(){
    push();
    fill(255,0,0);
    ellipse(pos.x,pos.y,r*2,r*2);
    pop();
  }
}
