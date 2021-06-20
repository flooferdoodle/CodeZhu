import java.util.*;

//class for all circle based entities
abstract class Entity extends Moveable{
  protected PShape hbx;
  protected float size;
  
  public void drawObj(){
    shape(hbx);
  }
  
  abstract public void move();
  
  //helper function for math
  protected PVector rotatePoint(PVector point, PVector center, float angle){
    float rotatedX = cos(angle) * (point.x - center.x) - sin(angle) * (point.y-center.y) + center.x;
    float rotatedY = sin(angle) * (point.x - center.x) + cos(angle) * (point.y - center.y) + center.y;
    return new PVector(rotatedX,rotatedY);
  }
  
  //update hitbox position
  protected void updateHbx(){
    for(int i = 0;i<shape.getVertexCount();i++){
      hbx.setVertex(i, rotatePoint(shape.getVertex(i).add(pos),pos,rot));
    }
  }
  
  //check if entity collides with another entity
  public boolean collision(Entity e){
    
    Line a;
    Line b;
    //check if any lines intersect between entity outlines
    for(int i = 0;i<hbx.getVertexCount();i++){
      for(int j = 0;j<e.hbx.getVertexCount();j++){
        a = new Line(this,hbx.getVertex(i),hbx.getVertex((i+1)%hbx.getVertexCount()));
        b = new Line(this,e.hbx.getVertex(j),e.hbx.getVertex((j+1)%e.hbx.getVertexCount()));
        if(a.intersect(b)) return true;
      }
    }
    
    return false;
  }
  
  //check if entity intersects a line
  public boolean collision(Line l){
    Line a;
    for(int i = 0;i<hbx.getVertexCount();i++){
        a = new Line(this,hbx.getVertex(i),hbx.getVertex((i+1)%hbx.getVertexCount()));
        if(a.intersect(l)) return true;
    }
    return false;
  }
  
  //create hitbox
  protected void hbxSetup(color c){
    hbx = createShape();
    hbx.beginShape();
    hbx.noStroke();
    hbx.fill(c);
    for(int i = 0;i<shape.getVertexCount();i++){
      hbx.vertex(0,0);
    }
    hbx.endShape(CLOSE);
    
    updateHbx();
  }
}
