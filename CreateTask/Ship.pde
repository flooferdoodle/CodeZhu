//player
class Ship extends Entity{
  private MoveForces move;
  private MoveForces rotMove;
  ArrayList<Bullet> shots;
  PShape bulletShape;
  int cooldown = 20;
  int lastShot = 0;
  
  Ship(){
    this(width/2,height/2,7,1,30, createShape(QUAD,bulletSize,0,0,bulletSize/4,-bulletSize,0,0,-bulletSize/4));
  }
  Ship(int x,int y, PShape s){
    this(x,y,7,1,30, s);
  }
  Ship(PShape s){
    this(width/2,height/2,7,1,30, s);
  }
  Ship(int x,int y,float speed, float accel,float size, PShape s){
    pos = new PVector(x,y);
    rot = 0;
    move = new MoveForces(accel,speed,0.3);
    rotMove = new MoveForces(0.052,0.3,0.05);
    this.size = size;
    
    //create player shape
    shape = createShape();
    shape.beginShape();
    shape.fill(200, 100);
    shape.noStroke();
    shape.vertex(size,0);
    shape.vertex(cos(PI*3/4)*size,sin(PI*3/4)*size);
    shape.vertex(-size/3,0);
    shape.vertex(cos(-PI*3/4)*size,sin(-PI*3/4)*size);
    shape.endShape(CLOSE);
    
    hbxSetup(color(255));
    
    bulletShape = s;
    
    shots = new ArrayList<Bullet>();
  }
  
  //reset player position
  void reset(){
    pos.x = width/2;
    pos.y = height/2;
    shots.clear();
    rot = 0;
  }
  
  @Override
  //draw player and bullets
  void drawObj(){
    push();
    
    for(Bullet b : shots){
      b.drawObj();
    }
    pop();
    super.drawObj();
  }
  
  //update position and move bullets
  void move(){
    pos.x += move.speed*cos(rot);
    pos.y += move.speed*sin(rot);
    move.friction();
    
    rot += rotMove.speed;
    rotMove.friction();
    updateHbx();
    
    lastShot++;
    moveBullets();
  }
  
  //update and move bullets
  void moveBullets(){
    LinkedList<Bullet> removeQ = new LinkedList<Bullet>();
    //loop and move each bullet
    for(Bullet b : shots){
      b.move();
      //check if bullet is offscreen
      if(b.pos.x<0 || b.pos.x>width || b.pos.y<0 || b.pos.y>height)
        removeQ.add(b);
    }
    //remove offscreen bullets
    while(!removeQ.isEmpty()){
      shots.remove(removeQ.poll());
    }
  }
  
  //take user inputs
  void input(String str){
    if(str == "U"){
      move.add();
    }
    else if(str == "D"){
      move.subtract();
    }
    else if(str == "R"){
      rotMove.add();
    }
    else if(str == "L"){
      rotMove.subtract();
    }
    else if(str == "FIRE"){
      if(lastShot >= cooldown){
        shots.add(new Bullet(this, bulletShape));
        lastShot = 0;
      }
    }
  }
  
  void setFill(color c){
    hbx.setFill(c);
  }
}
