class MoveForces{
  float accel;
  float speed;
  float lim;
  float frict;
  
  MoveForces(float a, float s, float fr){
    accel = a;
    lim = s;
    frict = fr;
    speed = 0;
  }
  
  void add(){
    speed += accel;
    speed = Math.min(speed, lim);
  }
  
  void subtract(){
    speed -= accel;
    speed = Math.max(speed, -lim);
  }
  
  void friction(){
    speed -= ((speed>=0)?1:-1)*min(frict,abs(speed));
  }
}
