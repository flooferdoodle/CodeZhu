import java.util.*;
//need to make a living class that has health for ship and alien
abstract class Entity extends Moveable{
  //all entities are circle based, they always fit within a circle with radius size
  protected PShape hbx;
  protected float size;
  //protected ArrayList<LineEvent> sPts;
  //protected ArrayList<LineEvent> ePts;
  
  public void drawObj(){
    shape(hbx);
    /*
    push();
    noFill();
    stroke(255);
    ellipse(pos.x,pos.y,2*size,2*size);
    pop();*/
  }
  
  abstract public void move();
  
  protected PVector rotatePoint(PVector point, PVector center, float angle){
    float rotatedX = cos(angle) * (point.x - center.x) - sin(angle) * (point.y-center.y) + center.x;
    float rotatedY = sin(angle) * (point.x - center.x) + cos(angle) * (point.y - center.y) + center.y;
    return new PVector(rotatedX,rotatedY);
  }
  
  
  protected void updateHbx(){
    for(int i = 0;i<shape.getVertexCount();i++){
      hbx.setVertex(i, rotatePoint(shape.getVertex(i).add(pos),pos,rot));
      //sPts.get(i).update(hbx.getVertex(i),true);
      //ePts.get(i).update(hbx.getVertex(i),false);
    }
  }
  
  //check if entity collides with another entity
  public boolean collision(Entity e){
    /*
    TreeSet<LineEvent> t = new TreeSet<LineEvent>();
    t.addAll(sPts);
    t.addAll(ePts);
    t.addAll(e.sPts);
    t.addAll(e.ePts);
    //t holds all events
    
    //stores the active points
    TreeSet<LineEvent> active = new TreeSet<LineEvent>(new Comparator(){
      public int compare(LineEvent a, LineEvent b){
        return (int) (a.y - b.y);
      }
    });
    
    LineEvent curr;
    while(!t.isEmpty()){
      curr = t.pollFirst();
      if(curr.start){
        //start event
        active.add(curr);
      }
      else{
        //end event
      }
    }
    */
    
    Line a;
    Line b;
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
