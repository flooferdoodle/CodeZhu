class Hitbox{
  float x1, x2, y1, y2;
  PVector center;
  boolean rect;
  Hitbox(float x1, float y1, float x2, float y2){ //rect
    rect = true;
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    
    center = new PVector((x1+x2)/2.0,(y1+y2)/2.0);

  }
  Hitbox(float x, float y, float r){ //circ
    rect = false;
    center = new PVector(x,y);
    
    this.x1 = x-r;
    this.x2 = x+r;
    this.y1 = y-r;
    this.y2 = y+r;
  }
  
  boolean collide(Hitbox h){
    if(h.rect){
      if (x1 < h.x2 && x2 > h.x1 &&
      y1 < h.y2 && y2 > h.y1){
        return true;
      }
    }
    else{
      float r = (h.x2-h.x1)/2;
      if (dist(x1,y1,h.center.x,h.center.y)<r ||
          dist(x1,y2,h.center.x,h.center.y)<r ||
          dist(x2,y1,h.center.x,h.center.y)<r ||
          dist(x2,y2,h.center.x,h.center.y)<r){
        return true;
      }
    }
    return false;
  }
  
  void draw(){
    push();
    noStroke();
    fill(255,0,0,50);
    rectMode(CORNERS);
    rect(x1,y1,x2,y2);
    pop();
  }
}
