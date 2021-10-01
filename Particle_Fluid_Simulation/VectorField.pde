class VectorField{
  final float noiseScale = 3;
  final float fieldStrength = 0.3;
  final float fieldChange = 0.5;
  PVector[][] vectors;
  PVector xOffset, yOffset;
  int size;
  
  VectorField(int size){
    this.size = size;
    vectors = new PVector[size][size];
    //use perlin noise to generate vector field
    xOffset = new PVector(random(0,5),random(0,5));
    yOffset = new PVector(random(0,5),random(0,5));
    for(int x = 0; x < size; x++){
      for(int y = 0; y < size; y++){
        PVector pos = (new PVector(x,y)).mult(noiseScale);
        PVector xNoisePos = PVector.add(xOffset, pos);
        PVector yNoisePos = PVector.add(yOffset, pos);
        
        vectors[x][y] = new PVector(noise(xNoisePos)-0.4, noise(yNoisePos)-0.4);
      }
    }
  }
  
  void shiftNoise(){
    xOffset.x += 0.005;
    yOffset.x += 0.005;
    
    for(int x = 0; x < size; x++){
      for(int y = 0; y < size; y++){
        PVector pos = (new PVector(x,y)).mult(noiseScale);
        PVector xNoisePos = PVector.add(xOffset, pos);
        PVector yNoisePos = PVector.add(yOffset, pos);
        
        vectors[x][y].x = noise(xNoisePos)-0.4;
        vectors[x][y].y = noise(yNoisePos)-0.4;
      }
    }
  }
  
  PVector getVector(PVector pos){
    //println(pos);
    return PVector.mult(vectors[floor(pos.x/(width+10)*size)][floor(pos.y/(height+10)*size)], fieldStrength);
  }
  
  void draw(){
    stroke(255,0,0);
    strokeWeight(3);
    
    float sWidth = width/size;
    float sHeight = height/size;
    for(int r = 0; r < size; r++){
      for(int c = 0; c < size; c++){
        float x = sWidth/2 + r*sWidth;
        float y = sHeight/2 + c*sHeight;
        PVector center = new PVector(x,y);
        PVector dest = new PVector(x+vectors[r][c].x*10,y+vectors[r][c].y*10);
        line(center.x, center.y, dest.x, dest.y);
        stroke(0,0,255);
        point(center.x, center.y);
        stroke(255,0,0);
      }
    }
  }
}

float noise(PVector p){
  return noise(p.x, p.y);
}
