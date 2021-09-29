PVector abs(PVector p){
  return new PVector(abs(p.x), abs(p.y), abs(p.z));
}
PVector max(PVector a, PVector b){
  return new PVector(max(a.x, b.x), max(a.y, b.y), max(a.z, b.z));
}
abstract class Object{
  PVector pos;
  PVector ambientColor;
  float specularPower, specularIntensity;
  
  
  //signed distance function: takes in a queried position
  abstract float sDist(PVector p);
  
  PVector lighting(){
    return null;
  }
}

class Sphere extends Object{
  float r; //radius
  Sphere(float r) { this(r, new PVector(), new PVector(1, 0, 0.7), 2, 0.0008); }
  Sphere(float r, PVector p) { this(r, p, new PVector(1, 0, 0.7), 2, 0.0008); }
  Sphere(float r, PVector p, PVector c, float sP, float sI){
    this.r = r; pos = p; ambientColor = c; specularPower = sP; specularIntensity = sI;
  }
  
  float sDist(PVector p){
    PVector newPos = PVector.sub(p,pos);
    return newPos.mag() - r;
  }
}

class Box extends Object{
  PVector dim; //box dimensions
  Box(PVector d){ dim = d; pos = new PVector();}
  Box(PVector d, PVector p){ dim = d; pos = p;}
  
  float sDist(PVector p){
    PVector newPos = p.sub(pos);
    PVector q = abs(newPos).sub(dim);
    return max(q, new PVector()).mag() + min(max(q.x,max(q.y,q.z)),0.0);
  }
}
