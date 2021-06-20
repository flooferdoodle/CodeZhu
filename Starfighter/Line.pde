class Line{
  PVector start;
  PVector end;
  float a;
  float b;
  float c;
  Entity e;
  Line(Entity e,PVector one, PVector two){
    this.e = e;
    if(one.x<two.x){
      start = one;
      end = two;
    }
    else{
      start = two;
      end = one;
    }
    
    a = end.y - start.y;
    b = start.x - end.x;
    c = a*start.x + b*start.y;
  }
  
  void update(){
    a = end.y - start.y;
    b = start.x - end.x;
    c = a*start.x + b*start.y;
  }
  
  boolean intersect(Line l){
    float det = a*l.b - l.a*b;
    if(det != 0){
      float x = (l.b*c - b*l.c)/det;
      float y = (a*l.c - l.a*c)/det;
      
      if(min(start.x,end.x) <= x && x <= max(start.x,end.x) &&
        min(start.y,end.y) <= y && y <= max(start.y,end.y) && 
        min(l.start.x,l.end.x) <= x && x <= max(l.start.x,l.end.x) &&
        min(l.start.y,l.end.y) <= y && y <= max(l.start.y,l.end.y)){
        /*
        push();
        stroke(255);
        strokeWeight(3);
        point(x,y);
        pop();*/
        return true;
      }
    }
    return false;
  }
  
  void draw(){
    line(start.x, start.y, end.x, end.y);
  }
}
