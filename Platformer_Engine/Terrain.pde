class Terrain extends Collidable{
  
  Terrain(float x1, float y1, float x2, float y2){
    hbx = new Hitbox(x1,y1,x2,y2);
    
  }
  
  void draw(){
    
    push();
    rectMode(CORNERS);
    noStroke();
    fill(139,69,19);
    
    rect(hbx.x1,hbx.y1,hbx.x2,hbx.y2);
    
    pop();
    
  }
}
