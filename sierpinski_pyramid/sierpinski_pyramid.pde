float degToRad = PI/180;
float zrot = -PI/6;
float xrot = -10*degToRad;
float yrot = 0;
float rotSpeed = 1;

float triLength = 350;
float minSize = 10;


ArrayList<pyramid> pyramidCollection = new ArrayList<pyramid>();

PGraphics sliderWindow;
void setup(){
  size(500, 400, P3D);
  noStroke();
  
  ortho();
  createFractal(new float[]{0,0,0}, triLength);
  
}

void draw(){
  background(0);
  ambientLight(200,200,200);
  spotLight(255,255,255,0,0,-100,0,0,1,PI/2,2);
  push();
  translate(width/2, height-(height/5), 0);
  rotateX(xrot);
  rotateY(yrot);
  
  for(int i = 0;i<pyramidCollection.size();i++){
    pyramidCollection.get(i).drawPyramid();
  }
  yrot+=rotSpeed*degToRad;
  yrot = yrot%(2*PI);
  pop();
}

void createFractal(float[] point, float size){
  
  pyramid currPyr = new pyramid(point, size);
  if(size<minSize){
    currPyr.calcVert();
    pyramidCollection.add(currPyr);
    return;
  }
  
  currPyr.calcOrtho();
  createFractal(currPyr.backOrtho,size/2);
  createFractal(currPyr.leftOrtho,size/2);
  createFractal(currPyr.rightOrtho,size/2);
  createFractal(currPyr.topOrtho,size/2);
}


void drawPoint(float[] coord, float size){
  strokeWeight(size);
  point(coord[0], coord[1], coord[2]);
  strokeWeight(1);
}
