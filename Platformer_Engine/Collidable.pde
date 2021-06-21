abstract class Collidable{
  Hitbox hbx;
  
  abstract void draw();
  
  boolean collide(Collidable c){
    return this.hbx.collide(c.hbx);
  }
}
