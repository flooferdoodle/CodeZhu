abstract class Collidable{
  Hitbox hbx;
  PImage[] img;
  
  abstract void draw();
  
  boolean collide(Collidable c){
    return this.hbx.collide(c.hbx);
  }
}
