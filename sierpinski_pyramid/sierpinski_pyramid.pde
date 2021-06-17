float degToRad = PI/180;
float zrot = -PI/6;
float xrot = -10*degToRad;
float yrot = 0;
float rotSpeed = 1;

float triLength = 350;
float minSize = 10;

slider layers;

//pyramid testPyr;
ArrayList<pyramid> pyramidCollection = new ArrayList<pyramid>();

PGraphics sliderWindow;
void setup(){
  size(700, 500, P3D);
  sliderWindow = createGraphics(width, 100, P2D);
  //noFill();
  //stroke(255);
  noStroke();
  
  ortho();
  /*
  testPyr = new pyramid(new float[]{0,0,0}, triLength);
  testPyr.calcOrtho();
  testPyr.calcVert();*/
  createFractal(new float[]{0,0,0}, triLength);
  
  layers = new slider(50, 10, 0, 75, 200);
  layers.posx = layers.linex;
  layers.make();
}


void draw(){
  background(0);
  //lights();
  ambientLight(200,200,200);
  //directionalLight(126, 126, 126, 0, 0, -1);
  spotLight(255,255,255,0,0,-100,0,0,1,PI/2,2);
  translate(width/2, height-(height/3), 0);
  rotateX(xrot);
  rotateY(yrot);
  
  //noFill();
  
  //testPyr.drawVertices();
  //testPyr.drawPyramid();
  //testPyr.drawOrtho();
  for(int i = 0;i<pyramidCollection.size();i++){
    pyramidCollection.get(i).drawPyramid();
  }
  yrot+=rotSpeed*degToRad;
  yrot = yrot%(2*PI);
  /*
  sliderWindow.beginDraw();
  background(50,50,50);
  stroke(1);
  hint(DISABLE_DEPTH_TEST);
  layers.updatePos();
  minSize = 340*((layers.posx-layers.linex)/layers.linex)+10;
  layers.make();
  hint(ENABLE_DEPTH_TEST);
  noStroke();
  sliderWindow.endDraw();
  //sliderWindow.rotateY(-yrot);
  image(sliderWindow, 0, 100);*/
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


void mousePressed(){
  if(layers.over){
    layers.locked = true;
    layers.xoff = mouseX-layers.posx;
  }
}

void mouseDragged(){
  if(layers.locked){
    layers.posx = mouseX-layers.xoff;
  }
}

void mouseReleased(){
  layers.locked = false;
  pyramidCollection.clear();
  createFractal(new float[]{0,0,0}, triLength);
}
