class Ship extends Entity{
  private MoveForces move;
  private MoveForces rotMove;
  ArrayList<Bullet> shots;
  PShape bulletShape;
  int cooldown = 20;
  int lastShot = 0;
  
  Ship(){
    this(width/2,height/2,7,1,15, createShape(QUAD,bulletSize,0,0,bulletSize/4,-bulletSize,0,0,-bulletSize/4));
  }
  Ship(int x,int y, PShape s){
    this(x,y,7,1,15, s);
  }
  Ship(PShape s){
    this(width/2,height/2,7,1,15, s);
  }
  Ship(int x,int y,float speed, float accel,float size, PShape s){
    pos = new PVector(x,y);
    rot = 0;
    move = new MoveForces(accel,speed,0.3);
    rotMove = new MoveForces(0.052,0.3,0.05);
    this.size = size;
    
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
    //sPts = new ArrayList<LineEvent>();
    //ePts = new ArrayList<LineEvent>();
    
    bulletShape = s;
    
    shots = new ArrayList<Bullet>();
  }
  
  @Override
  void drawObj(){
    push();
    
    for(Bullet b : shots){
      b.drawObj();
    }
    pop();
    super.drawObj();
  }
  
  void move(){
    pos.x += move.speed*cos(rot);
    pos.y += move.speed*sin(rot);
    //looping screen
    if(pos.x-3*size>width) pos.x-=width+3*size;
    else if(pos.x+3*size<0) pos.x+=width+3*size;
    if(pos.y-3*size>height) pos.y-=height+3*size;
    else if(pos.y+3*size<0)pos.y+=height+3*size;
    move.friction();
    
    rot += rotMove.speed;
    rotMove.friction();
    updateHbx();
    
    lastShot++;
    moveBullets();
  }
  
  void moveBullets(){
    Bullet b;
    LinkedList<Bullet> removeQ = new LinkedList<Bullet>();
    for(int i = 0;i<shots.size();i++){
      b = shots.get(i);
      b.move();
      if(b.pos.x<0 || b.pos.x>width || b.pos.y<0 || b.pos.y>height)
        removeQ.add(b);
    }
    while(!removeQ.isEmpty()){
      shots.remove(removeQ.poll());
    }
  }
  
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
