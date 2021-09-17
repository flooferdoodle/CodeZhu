abstract class Magnet extends Terrain{
  boolean polarity;
  float strength; // the magnetic strength
  PVector domain = new PVector(0.1,0.8); //domain cut out of function ((0,1) is full domain)
  boolean active = true;
  PImage wave;
  
  Magnet(boolean polar,PVector domain,float x1, float y1,float x2,float y2, float str){
    super(x1,y1,x2,y2);
    polarity = polar;
    
    this.strength = str;
    this.domain.x = domain.x;
    this.domain.y = domain.y;
    
  }
  
  abstract void draw();
}
