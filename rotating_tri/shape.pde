class shapeCirc{
  
  float[] center;
  int radius;
  int numOfSides;
  float radChange;
  
  shapeCirc(float[] pos, int radius, int sides){
    this.center = pos;
    this.radius = radius;
    this.numOfSides = sides;
    this.radChange = 360/sides*PI/180;
  }
  
  void make(float angle){

    float[] origPos = {center[0]+radius*(cos(angle)), center[1]+radius*(sin(angle))};
    beginShape();
    for(int i = 0;i<numOfSides;i++){
      vertex(center[0]+radius*(cos(angle+(i*radChange))), center[1]+radius*(sin(angle+(i*radChange))));
    }
    vertex(origPos[0],origPos[1]);
    endShape();
    
    /*fill(0, 0, 255, 25);
    ellipse(center[0], center[1], radius, radius);
    noFill();*/
    
    /*
    triangle(center[0]+radius*(cos(angle)), center[1]+radius*(sin(angle)),
            center[0]+radius*(cos(angle+(2*PI/3))), center[1]+radius*(sin(angle+(2*PI/3))),
            center[0]+radius*(cos(angle+(4*PI/3))), center[1]+radius*(sin(angle+(4*PI/3))));
     */
  }
  
  
  
}
