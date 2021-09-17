class Button{
  PVector pos;
  int w;
  int h;
   
  Button(int x, int y, int w, int h){
    pos = new PVector(x,y);
    this.w = w;
    this.h = h;
  }
  
  boolean click(int x, int y){
    if(x>pos.x && x<pos.x+w &&
       y>pos.y && y<pos.y+h){
      return true;
    }
    return false;
  }
}
