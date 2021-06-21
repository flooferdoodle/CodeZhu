class Player extends Collidable{
  final static int size = 32; //sidelength of player
  
  final static float speed = 7; //maximum speed
  final static float accel = 1; //acceleration
  
  final static float gravity = 0.6; //gravity strength
  final static float terminalVel = 20; //terminal velocity
  
  final static float jumpAcc = 10; //jump acceleration (affects to jump height)
  final static float jumpCD = 20;//cooldown for wall jump (in frames)
  
  final static float floorFriction = 0.7; //slowdown on floor
  final static float airResist = 0.5; //slowdown in air
  final static float wallFriction = 1.5; //how slow sliding down walls is
  
  
  
  
  PVector pos; //by center
  PVector vel;
  
  float lastJump = jumpCD;
  
  
  //0=none,1=bot,2=ceil,3=walls
  int onSurface = 0;
  Terrain surface; // records the last surface you were on
  
  
  Player(){
    this(new PVector(100,100));
  }
  Player(PVector pos){
    this.pos = pos;
    hbx = new Hitbox(pos.x-size/2,pos.y-size/2,pos.x+size/2,pos.y+size/2);
    vel = new PVector(0,0);
    
    
  }
  
  void move(){
    pos.x += vel.x;
    pos.y += vel.y;
    if(vel.y > 0) vel.y += gravity/5;
    
    if(onSurface==1){//on the floor
      vel.x -= ((vel.x>=0)?1:-1)*min(floorFriction,abs(vel.x));
      //print(hbx.y2>surface.hbx.y1);
      //print(hbx.y2 + " " + surface.hbx.y1);
      if(hbx.x1>surface.hbx.x2 || hbx.x2<surface.hbx.x1 || hbx.y2<surface.hbx.y1){
        //vel.y = 0; //idk if this makes better or worse
        onSurface = 0;
      }
    }
    else if(onSurface==2){//on ceil (attraction only)
      vel.x -= ((vel.x>=0)?1:-1)*min(floorFriction,abs(vel.x));
      if(gravity>abs(vel.y) || hbx.x1>surface.hbx.x2 || hbx.x2<surface.hbx.x1 || hbx.y1>surface.hbx.y2){
        vel.y = 0;
        onSurface = 0;
      }
    }
    else if(onSurface==3){//on wall
      vel.y = wallFriction - min(log(abs(0.75*vel.x)+1),wallFriction)/*-max(1-log(vel.x+0.01),0)*/;//trying to scale by force of being pushed into wall
      //println(vel.y);

      if(hbx.y1>surface.hbx.y2 || hbx.y2<surface.hbx.y1 || !(hbx.x1<surface.hbx.x2 && hbx.x2>surface.hbx.x1)){
        vel.x = 0;
        onSurface = 0;
      }
    }
    else{
      //in air
      vel.x -= ((vel.x>=0)?1:-1)*min(airResist,abs(vel.x)); //less friction
      vel.y += gravity;
    }
    
    vel.y = min(vel.y,terminalVel);
    
    updateHbx();
    
    lastJump++;
  }
  
  void updateHbx(){
    hbx.x1 = pos.x-size/2;
    hbx.y1 = pos.y-size/2;
    hbx.x2 = pos.x+size/2;
    hbx.y2 = pos.y+size/2;
  }
  
  void input(boolean[] keys){
    if(keys[0] && onSurface>0 && lastJump>=jumpCD){
      //jump
      jump();
    }
    if(keys[1]){
      //crouch?
      vel.y += gravity;
    }
    if(keys[2]){
      //right
      vel.x += accel;
      vel.x = min(vel.x, speed);
    }
    if(keys[3]){
      //left 
      vel.x -= accel;
      vel.x = max(vel.x, -speed);
    }
  }
  
  void jump(){
    lastJump = 0;
    if(onSurface == 1){//ground jump
      vel.y = -jumpAcc;
    }
    else if(onSurface==2){//ceiling jump
      vel.y = jumpAcc;
    }
    else if(onSurface==3){//wall jump
      vel.y = -jumpAcc;

      //figure out which side, then push away
      vel.x = 8*((hbx.x1-surface.hbx.x2 > surface.hbx.x1-hbx.x2)?1:-1);
    }
    //println(onSurface);
    onSurface = 0;
  }
  
  void collision(Terrain t){
    if(collide(t)){
      
      //handle the closest collision instead of all of them
      
      float[] over = {t.hbx.x1-hbx.x2/*right*/,t.hbx.x2-hbx.x1/*left*/,t.hbx.y2-hbx.y1/*top*/,t.hbx.y1-hbx.y2/*bot*/};
      PVector overlay = new PVector(absmin(over[0],over[1]),absmin(over[2],over[3]));
      //println(overlay);
      if(abs(overlay.x) < abs(overlay.y)){
        pos.x += overlay.x;
        vel.x = 0;
        
        //wall sliding
        if(t.hbx.y2-t.hbx.y1>40){//make sure the wall is large enough to slide
          onSurface = 3;
          surface = t;
        }
      }
      else{
        if(!(overlay.y < 0 && vel.y < 0)){ //you are not jumping while it has bottom collision (prevents weird glitch)
          
          if(overlay.y < 0){ //pushing up (bottom collision)
            onSurface = 1;
            surface = t;
          }
          
          
          pos.y += overlay.y;
          vel.y = 0;
        }
      }
      updateHbx();
    }
  }
 
  void draw(){
    push();
    rectMode(CENTER);
    rect(pos.x,pos.y,size,size);
    pop();
    //hbx.draw();
  }
}
