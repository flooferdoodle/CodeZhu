class Bullet extends Entity{
  float speed;
  
  //static PShape bulletShape = createShape();
  
  Bullet(Entity origin, PShape shape, float speed){
    pos = new PVector(origin.pos.x,origin.pos.y);
    this.rot = origin.rot;
    this.speed = speed;
    this.shape = shape;
    
    //print(shape);
    //print(this.shape);
    //print(this.shape.getVertex(0));
    
    hbxSetup(color(0,255,217));
  }
  Bullet(Entity origin, PShape shape){
    this(origin,shape, 15);
  }
  Bullet(color c, Entity origin, PShape shape){
    this(origin,shape, 15);
    hbx.setFill(c);
  }
  
  void move(){
    pos.x += cos(rot)*speed;
    pos.y += sin(rot)*speed;
    updateHbx();
  }
  
  
}
