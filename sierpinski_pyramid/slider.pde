class slider{
  
  float slider_width;
  float slider_height;
  float posx, posy;
  float linex, liney;
  float lineLength;
  boolean over = false;
  boolean locked = false;
  float xoff;
  float fundo;
  float left,right,top,bot;
  
  slider(float rectW, float rectH, float posx, float posy, float lineLength){
    this.slider_width = rectW;
    this.slider_height = rectH;
    this.posx = posx;
    this.posy = posy;
    this.linex = posx;
    this.liney = posy;
    this.lineLength = lineLength;
  }
  
  void make(){
    rectMode(CENTER);
    //line (linex, liney, linex+lineLength, liney);
  }
  
  void updatePos(){
    fundo = posx;
    line (linex, liney, linex+lineLength, liney);
    
    left = posx-(slider_width/2);
    right = posx+(slider_width/2);
    top = posy+(slider_height/2);
    bot = posy-(slider_height/2);
    
    if (mouseX>left && mouseX<right && mouseY>bot && mouseY<top) {
      fill(200);
      over = true;
    }
    else {
      fill(255);
      over = false;
    }
  
    
    if (posx < width/2-100) {
    //println ("ERRO");
      posx = width/2-100;
    }
    
    if (posx > width/2+100) {
    //println ("ERRO");
      posx = width/2+100;
    }
  
  
    rect(posx, posy, slider_width, slider_height);
  }
  
}
