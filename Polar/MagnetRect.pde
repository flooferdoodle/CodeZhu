class MagnetRect extends Magnet{
  Hitbox[] forces;
  /*
  MagnetRect(boolean polar,PVector domain,float x1, float y1, float x2, float y2, float size, float str,boolean[] active){
    super(polar,domain,x1,y1,x2,y2,str);
    
    //1=up,2=right,3=down,4=left
    forces = new Hitbox[4];
    int off = 2; //trying to prevent overlap on magnet hitboxes
    if(active[0]) forces[0] = new Hitbox(x1+off,y1-size,x2-off,y1);//top
    if(active[1]) forces[1] = new Hitbox(x2,y1+off,x2+size,y2-off);//right
    if(active[2]) forces[2] = new Hitbox(x1+off,y2,x2-off,y2+size);//bot
    if(active[3]) forces[3] = new Hitbox(x1-size,y1+off,x1,y2-off);//left

    img = new PImage[4];
    if(x2-x1>y2-y1){ //horizontal
      img[0] = loadImage("Textures/Magnet/SLHA.png");
      img[1] = loadImage("Textures/Magnet/SLHD.png");
      img[2] = loadImage("Textures/Magnet/NLHA.png");
      img[3] = loadImage("Textures/Magnet/NLHD.png");
    }
    else{//vertical
      img[0] = loadImage("Textures/Magnet/SLVA.png");
      img[1] = loadImage("Textures/Magnet/SLVD.png");
      img[2] = loadImage("Textures/Magnet/NLVA.png");
      img[3] = loadImage("Textures/Magnet/NLVD.png");
    }
  }*/
  MagnetRect(boolean polar,PVector domain,boolean horiz,float x, float y,float size, float str, boolean[] active){
    //true is horizontal, false is vertical
    super(polar,domain,x,y,x+((horiz)?64:16),y+((horiz)?16:64),str);
    //println(x+((horiz)?64:16));
    //print(hbx.x1 + " " + hbx.y1 + " " + hbx.x2 + " " + hbx.y2);
    
    //1=up,2=right,3=down,4=left
    forces = new Hitbox[4];
    int off = 2; //trying to prevent overlap on magnet hitboxes
    if(active[0]) forces[0] = new Hitbox(hbx.x1+off,hbx.y1-size,hbx.x2-off,hbx.y1);//top
    if(active[1]) forces[1] = new Hitbox(hbx.x2,hbx.y1+off,hbx.x2+size,hbx.y2-off);//right
    if(active[2]) forces[2] = new Hitbox(hbx.x1+off,hbx.y2,hbx.x2-off,hbx.y2+size);//bot
    if(active[3]) forces[3] = new Hitbox(hbx.x1-size,hbx.y1+off,hbx.x1,hbx.y2-off);//left

    img = new PImage[4];
    if(horiz){ //horizontal
      img[0] = loadImage("Textures/Magnet/SLHA.png");
      img[1] = loadImage("Textures/Magnet/SLHD.png");
      img[2] = loadImage("Textures/Magnet/NLHA.png");
      img[3] = loadImage("Textures/Magnet/NLHD.png");
    }
    else{//vertical
      img[0] = loadImage("Textures/Magnet/SLVA.png");
      img[1] = loadImage("Textures/Magnet/SLVD.png");
      img[2] = loadImage("Textures/Magnet/NLVA.png");
      img[3] = loadImage("Textures/Magnet/NLVD.png");
    }
    
   
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
    for(Hitbox h : forces){
      if(h == null) continue;
      h.draw();
    }
    */
    push();
    if(polarity){//south blue
      image(img[0+((active)?0:1)],hbx.x1,hbx.y1,hbx.x2-hbx.x1,hbx.y2-hbx.y1);
    }
    else{//north red
      image(img[2+((active)?0:1)],hbx.x1,hbx.y1,hbx.x2-hbx.x1,hbx.y2-hbx.y1);
    }
    
    for(Hitbox h : forces){
      if(h == null) continue;
      h.draw();
    }
    
    pop();
  }
}
