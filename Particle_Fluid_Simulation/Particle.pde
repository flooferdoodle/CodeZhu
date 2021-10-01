final float maxVelocity = 3;
class Particle{
  PVector pos;
  PVector vel;
  PVector accel;
  
  Particle(){
    pos = new PVector(random(0,width), random(0,height));
    vel = new PVector();
    accel = new PVector();
  }
  
  void applyForce(PVector force){
    accel.add(force);
  }
  
  void update(){
    
    //update velocity
    vel.add(accel);
    vel.limit(maxVelocity);
    //some sort of resistive force
    //vel.mult(0.9);
    
    
    pos.add(vel);
    //loop on screen
    //println(pos);
    while(pos.x >= width){ pos.add(-width, 0); }
    while(pos.x < 0){ pos.add(width, 0); } 
    while(pos.y >= height){ pos.add(0, -height); }
    while(pos.y < 0){ pos.add(0, height); }
    //println("after" + pos);
    
    //reset accelaration
    accel.set(0,0);
  }
  
  void draw(){
    stroke(255);
    strokeWeight(2);
    point(pos.x, pos.y);
  }
}
