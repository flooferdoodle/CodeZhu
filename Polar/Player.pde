class Player extends Collidable{
  PImage img[];
  PImage eyes;
  
  PVector pos; //by center
  int size; // sidelength
  PVector vel;
  float speed = 7;
  float terminalVel = 20;
  float accel = 1;
  float jumpAcc = 7;
  float jumpCD = 20;//cooldown for wall jump (in frames)
  float lastJump = jumpCD;
  
  float floorFriction = 0.7;
  float airResist = 0.5;
  float wallFriction = 1.5;
  //0=none,1=bot,2=ceil,3=walls
  int onSurface = 0;
  Terrain surface; // records the last surface you were on
  float gravity = 0.6;
  
  boolean polarity;
  
  Player(){
    this(32,new PVector(100,100));
  }
  Player(int size, PVector pos){
    this.size = size;
    this.pos = pos;
    hbx = new Hitbox(pos.x-size/2,pos.y-size/2,pos.x+size/2,pos.y+size/2);
    vel = new PVector(0,0);
    
    polarity = true;
    
    img = new PImage[2];
    img[0] = loadImage("Textures/Character/BlueCh.png");
    img[1] = loadImage("Textures/Character/RedCh.png");
    eyes = loadImage("Textures/Character/eyes.png");
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
        if(t.hbx.y2-t.hbx.y1>40 && (!(t instanceof Magnet) || ((Magnet) t).polarity!=p.polarity)){//make sure the wall is large enough to slide
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
          else if(overlay.y > 0 && (t instanceof Magnet && ((Magnet) t).polarity != polarity)){ //pushing down (top collision)
            //only for magnets
            //println("ceil");
            //println(vel.y + " + " +gravity);
            onSurface = 2;
            surface = t;
          }
          
          
          pos.y += overlay.y;
          vel.y = 0;
        }
      }
      updateHbx();
    }
  }
  
  
  
  void magnetism(Magnet m){
    if(m instanceof MagnetCircle){
      MagnetCircle mc = (MagnetCircle) m;
      float distance = dist(pos.x,pos.y,mc.center.x,mc.center.y);
      if(distance<mc.radius){ 
        //if you collide with magnet circle
        PVector force = new PVector(0,0);
        force.x = (mc.center.x-pos.x)/mc.radius;
        force.y = (mc.center.y-pos.y)/mc.radius;
        
        //scale based on distance
        distance /= mc.radius;
        distance = 1-distance;
        distance = map(distance,0,1,m.domain.x,m.domain.y);
        force.x *= m.strength*(pow(distance,3));
        force.y *= m.strength*(pow(distance,3));
        
        //if on surface, don't push into the surface of magnet
        if(onSurface == 1 && force.y<gravity){
          force.y = 0;
        }
        
        if(polarity == m.polarity){
          //repel (negative force)
          vel.x -= force.x;
          vel.y -= force.y;
        }
        else{
          //attract
          vel.x += force.x;
          vel.y += force.y;
        }
      }
    }
    else if(m instanceof MagnetRect){
      MagnetRect mr = (MagnetRect) m;
      for(int i = 0;i<mr.forces.length;i++){
        Hitbox h = mr.forces[i]; //4 sides of rectangle -> 4 fields to collide with
        if(h==null)continue;
        if(hbx.collide(h)){
          
          PVector force = new PVector(0,0);
          if(i == 0){ // top
            //scale force to distance of the hitbox
            force.y = (map(abs((h.y1-hbx.y2)/(h.y2-h.y1)),0,1,m.domain.x,m.domain.y));
            
          }
          else if(i==1 && h.x2>hbx.x1){ //right
            force.x = -(map(abs((h.x2-hbx.x1)/(h.x2-h.x1)),0,1,m.domain.x,m.domain.y));
          }
          else if(i==2 && h.y2>hbx.y1){ //bot
            force.y = -(map(abs((h.y2-hbx.y1)/(h.y2-h.y1)),0,1,m.domain.x,m.domain.y));
          }
          else if(i==3 && hbx.x2>h.x1){//left
            force.x = (map(abs((hbx.x2-h.x1)/(h.x2-h.x1)),0,1,m.domain.x,m.domain.y));
          }
          
          //print(force);
          //force.x = m.strength*(2/(-4.5*force.x+6)-(1.0/3));
          //force.y = m.strength*(2/(-4.5*force.y+6)-(1.0/3));
          
          //println(force.x);
          force.x = m.strength*(pow(force.x,3));
          force.y = m.strength*(pow(force.y,3));
          
          if(polarity == m.polarity){
            //repel (negative force)
            vel.x -= force.x;
            vel.y -= force.y;
            
          }
          else{
            //attract
            vel.x += force.x;
            vel.y += force.y;
            
          }
          
          return; //you can't ever be in two magnet hitboxes at once (of the same magnet)
        }
      }
    }
  }
 
  void draw(){
    push();
    //rectMode(CENTER);
    //rect(pos.x,pos.y,size,size);
    if(polarity) image(img[0],pos.x-size/2,pos.y-size/2,size,size);
    else image(img[1],pos.x-size/2,pos.y-size/2,size,size);
    image(eyes,pos.x-size/2 + map(max(min(p.vel.x,6.3),-6.3),-6.3,6.3,-3,3),pos.y-size/2 + map(max(min(p.vel.y,10),-10),-10,10,-5,5),size,size);
    pop();
    //hbx.draw();
  }
}
