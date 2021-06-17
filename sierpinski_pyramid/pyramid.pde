class pyramid{
  
  float[] xzOrtho;
  float[] xyzOrtho;
  float sideLength;
  float yHeight;
  
  float zHeight;
  float zDistFront;
  float zDistBack;
  //vertices
  float[] backVert;
  float[] leftVert;
  float[] rightVert;
  float[] topVert;
  
  //for the smaller pyramids
  float[] backOrtho;
  float[] leftOrtho;
  float[] rightOrtho;
  float[] topOrtho;
  
  pyramid(float[] xzOrtho, float sideLength){
    this.xzOrtho = xzOrtho;
    this.sideLength = sideLength;
    this.yHeight = (float) Math.sqrt(2*sideLength*sideLength/3);
    float yDistBase = (sideLength*sideLength)/ (float) (6*Math.sqrt((2*sideLength*sideLength)/3));
    this.xyzOrtho = new float[]{xzOrtho[0], xzOrtho[1]-yDistBase, xzOrtho[2]};
    
    this.zHeight = (float) Math.sqrt((sideLength*sideLength)-((sideLength*sideLength)/4));
    this.zDistFront = (sideLength*sideLength)/ (float) (4*Math.sqrt((sideLength*sideLength)-((sideLength*sideLength)/4)));
    this.zDistBack = zHeight-zDistFront;
  }
  
  void calcOrtho(){
    backOrtho = new float[]{xzOrtho[0], xzOrtho[1], xzOrtho[2]+zDistFront-(zHeight/2)-(zDistFront/2)};
    rightOrtho = new float[]{xzOrtho[0]+(sideLength/4), xzOrtho[1], xzOrtho[2]+zDistFront-(sideLength/ (float) (4*Math.sqrt(3)))};
    leftOrtho = new float[]{xzOrtho[0]-(sideLength/4), xzOrtho[1], xzOrtho[2]+zDistFront-(sideLength/ (float) (4*Math.sqrt(3)))};
    topOrtho = new float[]{xzOrtho[0],xzOrtho[1]-(yHeight/2), xzOrtho[2]};
  }
  
  void calcVert(){
    backVert = new float[]{xzOrtho[0],xzOrtho[1],xzOrtho[2]-zDistBack};
    leftVert = new float[]{xzOrtho[0]-(sideLength/2),xzOrtho[1],xzOrtho[2]+zDistFront};
    rightVert = new float[]{xzOrtho[0]+(sideLength/2),xzOrtho[1],xzOrtho[2]+zDistFront};
    topVert = new float[]{xzOrtho[0],xzOrtho[1]-yHeight,xzOrtho[2]};
  }
  
  void drawPyramid(){
    beginShape(TRIANGLES);
    //base
    vertex(backVert[0],backVert[1],backVert[2]);
    vertex(leftVert[0],leftVert[1],leftVert[2]);
    vertex(rightVert[0],rightVert[1],rightVert[2]);
    
    //front
    vertex(rightVert[0],rightVert[1],rightVert[2]);
    vertex(leftVert[0],leftVert[1],leftVert[2]);
    vertex(topVert[0],topVert[1],topVert[2]);
    
    //left
    vertex(leftVert[0],leftVert[1],leftVert[2]);
    vertex(backVert[0],backVert[1],backVert[2]);
    vertex(topVert[0],topVert[1],topVert[2]);
    
    //right
    vertex(rightVert[0],rightVert[1],rightVert[2]);
    vertex(backVert[0],backVert[1],backVert[2]);
    vertex(topVert[0],topVert[1],topVert[2]);
    
    endShape();
  }
  
  void drawVertices(){
    strokeWeight(10);
    point(backVert[0],backVert[1],backVert[2]);
    point(leftVert[0],leftVert[1],leftVert[2]);
    point(rightVert[0],rightVert[1],rightVert[2]);
    point(topVert[0],topVert[1],topVert[2]);
    strokeWeight(1);
  }
  
  void drawOrtho(){
    strokeWeight(10);
    //main centerpoint
    point(xyzOrtho[0],xyzOrtho[1],xyzOrtho[2]);
    
    strokeWeight(5);
    //smaller pyramid Orthos
    point(backOrtho[0], backOrtho[1], backOrtho[2]);
    point(leftOrtho[0], leftOrtho[1], leftOrtho[2]);
    point(rightOrtho[0], rightOrtho[1], rightOrtho[2]);
    point(topOrtho[0], topOrtho[1], topOrtho[2]);
    
    strokeWeight(1);
  }
}
