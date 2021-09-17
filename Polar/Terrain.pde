class Terrain extends Collidable{
  PImage[][] imgArr;
  
  Terrain(float x1, float y1, float x2, float y2){
    hbx = new Hitbox(x1,y1,x2,y2);
    img = new PImage[3];
    img[0] = loadImage("Textures/Terrain/FlatBlock.png");
    img[1] = loadImage("Textures/Terrain/MetalBrick.png");
    img[2] = loadImage("Textures/Terrain/DiamondTile.png");
    
    imgArr = new PImage[(int) (hbx.x2-x1)/32][(int) (hbx.y2-hbx.y1)/32];
    //println(imgArr.length + " " + imgArr[0].length);
    for(int x = 0;x<imgArr.length;x++){
      for(int y = 0;y<imgArr[x].length;y++){
        //println(floor(random(0,3)));
        imgArr[x][y] = img[floor(random(0,3))];
      }
    }
  }
  
  void draw(){
    /*
    push();
    rectMode(CORNERS);
    noStroke();
    fill(139,69,19);
    
    rect(hbx.x1,hbx.y1,hbx.x2,hbx.y2);
    
    pop();*/
    
    for(int x = 0;x<imgArr.length;x++){
      for(int y = 0;y<imgArr[x].length;y++){
        image(imgArr[x][y],x*32+hbx.x1,y*32+hbx.y1,32,32);
      }
    }
  }
}
