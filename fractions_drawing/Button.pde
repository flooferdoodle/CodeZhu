class Button{
  int x, y, w, h;
  boolean add;
  Button(int x, int y, int w, int h, boolean b){
    this.x = x;
    this.y = y;
    this.w = w; 
    this.h = h;
    this.add = b;
  }
  
  boolean isClicked(){
    return (mouseX >= x && mouseX <= x+w)
         &&(mouseY >= y && mouseY <= y+h);
  }
  
  void draw(){
    stroke(0);
    strokeWeight(3);
    rect(x, y, w, h);
    
    line(x+w/5, y+h/2, x+w*4/5, y+h/2);
    if(add)
      line(x+w/2, y+h/5, x+w/2, y+h*4/5);
  }
}
