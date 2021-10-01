int gridSize = 10;
VectorField field;
Particle[] particles;
int particleCount = 5000;
void setup(){
  size(600,600);
  
  field = new VectorField(gridSize);
  particles = new Particle[particleCount];
  for(int i = 0; i < particleCount; i++){
    particles[i] = new Particle();
  }
}

void draw(){
  background(0);
  
  field.shiftNoise();
  
  //apply vectorfield forces
  
  for(Particle p : particles){
    p.applyForce(field.getVector(p.pos));
    p.update();
    p.draw();
  }
  //println(particles[0].vel.mag());
  
  field.draw();
}
