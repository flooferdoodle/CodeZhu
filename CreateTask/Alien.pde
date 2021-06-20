class Alien extends Entity{
  float speed;
  ArrayList<Bullet> shots;
  PShape bulletShape;
  final color bulletColor = color(242, 70, 70);
  int cooldown = 30;
  int lastShot = cooldown;
  
  Alien(int x,int y,float rot,float speed, PShape bs){
    size = 50;
    pos = new PVector(x,y);
    this.rot = rot;
    this.speed = speed;
    
    //set alien shape
    shape = createShape();
    shape.beginShape();
    shape.fill(200, 100);
    shape.noStroke();
    shape.vertex(size,0);
    shape.vertex(size/5,size/4);
    shape.vertex(size*cos(PI*3/5),size*sin(PI*3/5));
    shape.vertex(-size/5,size/5);
    shape.vertex(-size*3/4,0);
    shape.vertex(-size/5,-size/5);
    shape.vertex(size*cos(-PI*3/5),size*sin(-PI*3/5));
    shape.vertex(size/5,-size/4);
    shape.endShape(CLOSE);
    
    hbxSetup(color(123, 82, 171));
    
    bulletShape = bs;
    shots = new ArrayList<Bullet>();
    
  }
  
  void move(){
    //move in angle direction
    pos.x += cos(rot)*speed;
    pos.y += sin(rot)*speed;
    
    //move hitbox to new position
    updateHbx();
    
    //check if need to shoot
    if(lastShot >= cooldown){
        shots.add(new Bullet(bulletColor, this, bulletShape));
        lastShot = 0;
    }
    else{
      lastShot++;
    }
    
    //update and move bullets
    moveBullets();
  }
  
  void moveBullets(){
    LinkedList<Bullet> removeQ = new LinkedList<Bullet>();
    //loop and move each bullet
    for(Bullet b : shots){
      b.move();
      //remove bullet if offscreen
      if(b.pos.x<0 || b.pos.x>width || b.pos.y<0 || b.pos.y>height)
        removeQ.add(b);
    }
    //remove offscreen bullets
    while(!removeQ.isEmpty()){
      shots.remove(removeQ.poll());
    }
  }
  
  @Override
  //draw bullets and ship
  void drawObj(){
    for(Bullet b : shots){
      b.drawObj();
    }
    super.drawObj();
  }
  
  //add bullet to active shots
  void shoot(){
    shots.add(new Bullet(bulletColor, this, bulletShape));
  }
  
  
}
