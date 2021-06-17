int centX;
int centY;
ArrayList<shapeCirc> tri = new ArrayList<shapeCirc>();
ArrayList<shapeCirc> mini = new ArrayList<shapeCirc>();
int r = 150;

float rotSpeed = 1.7;
float degToRad = PI/180;
int triSize = 75;
int numOfTri = 60;
int shapeSides = 3;
int degChange = 360/numOfTri;
int rot = 3;
float deg = 0;

//slider stuff

slider numShapes;
slider shapeType;
slider circlePoints;
int[] circleFactors = {15,18,20,24,30,36,40,45,60,72,90,120};
int[] shapeSizes = {2,3,4,5,6,7};
int[] rotChange = {1,2,3,4,5};

void setup() {
  size(600, 600);
  noFill();
  centX = width/2;
  centY = height/2-50;
  background(0);
  stroke(255, 255, 255);

  
  for (int i = 0; i<numOfTri; i++) {
    float currX = r*cos(i*degChange*degToRad)+centX;
    float currY = r*sin(i*degChange*degToRad)+centY;
    //positions.add(new float[]{currX, currY});
    tri.add(new shapeCirc(new float[]{currX, currY}, triSize, shapeSides));
    float miniX = r/3*cos(i*degChange*degToRad)+centX;
    float miniY = r/3*sin(i*degChange*degToRad)+centY;
    mini.add(new shapeCirc(new float[]{miniX, miniY}, triSize/2, shapeSides));
  }
  
  //slider stuff
  numShapes = new slider(50, 10, width/2-100, height-30, 200);
  numShapes.posx = numShapes.linex+(numShapes.lineLength/circleFactors.length*9);
  numShapes.make();
  
  shapeType = new slider(50, 10, width/2-100, height-60, 200);
  shapeType.posx = shapeType.linex+(shapeType.lineLength/shapeSizes.length*1);
  shapeType.make();
  
  circlePoints = new slider(50, 10, width/2-100, height-90, 200);
  circlePoints.posx = circlePoints.linex+(circlePoints.lineLength/rotChange.length*1);
  circlePoints.make();
}

void draw() {
  background(0);
  //line(0, centY, width, centY);
  /*ellipse(centX, centY, r*2, r*2);
  ellipse(centX, centY, (r+triSize)*2, (r+triSize)*2);*/
  noFill();

  for(int i = 0;i<tri.size();i++){
    //fill(255/tri.size()*i);
    tri.get(i).make((i*degChange*rot*degToRad)+(deg*degToRad));
    mini.get(i).make((i*degChange*rot*degToRad)+(deg*degToRad));
  }
  deg+= rotSpeed;
  
  //slider stuff
  numShapes.updatePos();
  numOfTri = circleFactors[Math.round(((numShapes.posx-numShapes.linex)/numShapes.lineLength)*(circleFactors.length-1))];
  
  numShapes.make();

  shapeType.updatePos();
  shapeType.make();
  shapeSides = shapeSizes[Math.round(((shapeType.posx-shapeType.linex)/shapeType.lineLength)*(shapeSizes.length-1))];
  
  circlePoints.updatePos();
  circlePoints.make();
  rot = rotChange[Math.round(((circlePoints.posx-circlePoints.linex)/circlePoints.lineLength)*(rotChange.length-1))];

  //println(tri.size());
}

//slider stuff
void mousePressed() {
  if (numShapes.over) {
    numShapes.locked = true;
    numShapes.xoff = mouseX-numShapes.posx;
  }
  if (shapeType.over) {
    shapeType.locked = true;
    shapeType.xoff = mouseX-shapeType.posx;
  }
  if (circlePoints.over) {
    circlePoints.locked = true;
    circlePoints.xoff = mouseX-circlePoints.posx;
  }
}
void mouseDragged() {
  if (numShapes.locked) {
    numShapes.posx = mouseX-numShapes.xoff;
  }
  if (shapeType.locked) {
    shapeType.posx = mouseX-shapeType.xoff;
  }
  if (circlePoints.locked) {
    circlePoints.posx = mouseX-circlePoints.xoff;
  }
}
void mouseReleased() {
  numShapes.locked = false;
  shapeType.locked = false;
  circlePoints.locked = false;
  tri.clear();
  mini.clear();
  degChange = 360/numOfTri;
  for (int i = 0; i<numOfTri; i++) {
    float currX = r*cos(i*degChange*degToRad)+centX;
    float currY = r*sin(i*degChange*degToRad)+centY;
    //positions.add(new float[]{currX, currY});
    tri.add(new shapeCirc(new float[]{currX, currY}, triSize, shapeSides));
    
    float miniX = r/3*cos(i*degChange*degToRad)+centX;
    float miniY = r/3*sin(i*degChange*degToRad)+centY;
    mini.add(new shapeCirc(new float[]{miniX, miniY}, triSize/2, shapeSides));
  }
  //println(numOfTri);
}
