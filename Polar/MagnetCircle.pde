class MagnetCircle extends Magnet{
  float radius;
  PVector center;
  
  /*
  MagnetCircle(boolean polar,PVector domain,float x1, float y1,float x2,float y2, float r, float str){
    super(polar,domain,x1,y1,x2,y2,str);
    center = new PVector((x2+x1)/2,(y2+y1)/2);
    
    radius = r;
    
    img = new PImage[4];
    img[0] = loadImage("Textures/Magnet/SA.png");
    img[1] = loadImage("Textures/Magnet/SD.png");
    img[2] = loadImage("Textures/Magnet/NA.png");
    img[3] = loadImage("Textures/Magnet/ND.png");
  }*/
  MagnetCircle(boolean polar,PVector domain,float x, float y, float r, float str){
    super(polar,domain,x,y,x+48,y+48,str);
    center = new PVector(x+24,y+24);
    
    radius = r;
    
    img = new PImage[4];
    img[0] = loadImage("Textures/Magnet/SA.png");
    img[1] = loadImage("Textures/Magnet/SD.png");
    img[2] = loadImage("Textures/Magnet/NA.png");
    img[3] = loadImage("Textures/Magnet/ND.png");
  }
  
  
  
  void draw(){
    /*
    push();
    rectMode(CORNERS);
    noStroke();
    if(polarity) fill(0,0,255);
    else fill(255,0,0);
    rect(hbx.x1,hbx.y1,hbx.x2,hbx.y2);
    pop();
    
    push();
    noStroke();
    fill(255,0,0,50);
    ellipse(center.x,center.y,radius*2,radius*2);
    pop();
    */
    push();
    if(polarity){//south blue
      image(img[0+((active)?0:1)],hbx.x1,hbx.y1,hbx.x2-hbx.x1,hbx.y2-hbx.y1);
    }
    else{//north red
      image(img[2+((active)?0:1)],hbx.x1,hbx.y1,hbx.x2-hbx.x1,hbx.y2-hbx.y1);
    }
    
    fill(255,0,0,50);
    ellipse(center.x,center.y,radius*2,radius*2);
    
    pop();
  }
}
