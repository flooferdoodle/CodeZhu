class Alien extends Entity implements Comparable<Alien>{
  int score; //performance score for training
  //PVector[] vision; //coordinates to the nearest damaging entities
  Line vision; //sight for training
  int dir;//0=up,1=r,2=d,3=l
  float speed;
  ArrayList<Bullet> shots;
  PShape bulletShape;
  final color bulletColor = color(242, 70, 70);
  int cooldown = 1;
  int lastShot = 0;
  /*
  What you need to know to move/attack: pos, enemy pos, rotation, bullet/damage entity pos (vision)
  Possible attack pattern: shoots at intervals so it only tries to rotate into position
  */
  Network brain;
  
  Alien(){
    this((int)random(width),(int)random(height),5,createShape(QUAD,bulletSize,0,0,bulletSize/4,-bulletSize,0,0,-bulletSize/4));
  }
  Alien(PShape s){
    this((int)random(width),(int)random(height),5,s);
  }
  Alien(int x, int y, PShape s){
    this(x,y,5,s);
  }
  Alien(Alien mom, Alien dad){
    dir = 0;
    score = 0;
    size = 20;
    pos = new PVector(random(width),random(height));
    rot = 0;
    speed = 5;
    
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
    
    bulletShape = mom.bulletShape;
    shots = new ArrayList<Bullet>();
    
    brain = new Network(mom.brain,dad.brain);
    vision = new Line(this,new PVector(pos.x,pos.y),new PVector(0,0));
  }
  Alien(int x,int y,float speed, PShape s){
    dir = 0;
    score = 0;
    size = 20;
    pos = new PVector(x,y);
    rot = 0;
    this.speed = speed;
    
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
    
    bulletShape = s;
    shots = new ArrayList<Bullet>();
    
    //testing brain that only rotates
    //input: ship x, ship y, rotationg
    //output: a single number showing how much to rotate
    brain = new Network(new int[] {3,5,1});
    vision = new Line(this,new PVector(pos.x,pos.y),new PVector(0,0));
  }
  
  void think(Ship s){
    brain.update(new float[] {s.pos.x/width,s.pos.y/height,rot});
    float movement = brain.output()[0];
    //println(movement);
    rot = (rot + 0.5*(movement-0.5))%(2*PI);
    move();
  }
  
  void move(){
    /*
    if(dir == 0){
      pos.x += cos(rot)*speed;
      pos.y += sin(rot)*speed;
    }
    else if(dir == 1){
      rot = (rot + 0.2)%(2*PI);
    }
    else if(dir == 2){
      pos.x -= cos(rot)*speed;
      pos.y -= sin(rot)*speed;
    }
    else if(dir == 3){
      rot = (rot - 0.2)%(2*PI);
    }*/
    updateHbx();
    updateVision();
    /*
    if(lastShot >= cooldown){
        shots.add(new Bullet(bulletColor, this, bulletShape));
        lastShot = 0;
    }
    else{
      lastShot++;
    }
    for(Bullet b : shots){
      b.move();
    }*/
  }
  
  @Override
  void drawObj(){
    for(Bullet b : shots){
      b.drawObj();
    }
    super.drawObj();
    if(ship.collision(vision)) stroke(255,0,0);
    else stroke(255);
    vision.draw();
  }
  
  void shoot(){
    shots.add(new Bullet(bulletColor, this,bulletShape));
  }
  
  int compareTo(Alien a){
    return score-a.score;
  }
  
  void updateVision(){
    vision.start.x = pos.x;
    vision.start.y = pos.y;
    vision.end.x = pos.x + cos(rot)*1000;
    vision.end.y = pos.y + sin(rot)*1000;
    vision.update();
  }
}
