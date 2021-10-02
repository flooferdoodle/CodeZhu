float[][] grid;
float scale = 70;
int w = 80;
int h = 100;


float moveSpeed = 0.06;

PGraphics sunpg;
int sunSize = 450;

PGraphics stars;

PGraphics threeD;


PImage hand;
float handScale = 0.4;

void setup(){
  size(600,600,P3D);
  threeD = createGraphics(600, 600,P3D);
  grid = new float[h][w];
  
  xOff = random(-50, 50);
  yOff = random(-50, 50);
  zOff = random(-50, 50);
  
  //perlin(grid);
  
  simplexNoise = new OpenSimplexNoise();
  simplex(grid);
  
  makeSunGlow();
  makeSun();
  
  generateStars();
  
  hand = loadImage("hand.png");
  
  loadFrog();
  
  
}

void draw(){
  float fov = PI/2.5;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height), 
              cameraZ/10.0, cameraZ*20.0);
  
  background(0);
  gradientRect(0,0,width, height-100, color(33, 9, 64), color(234, 74, 255), true);
  stroke(255);
  noFill();
  
  
  
  drawStars();
  updateSun();
  drawSun(width/2, height/2-50, sunSize);
  
  //draw terrain
  //perlin(grid);
  //yOff -= moveSpeed;
  
  //simplex(grid);
  loopPerlin(grid);
  simplex_offsetTheta = (simplex_offsetTheta - simplex_sampleDeltaTheta/simplex_sampleRadius);// % (2*PI);
  if(simplex_offsetTheta < -2*PI) noLoop();
  //println(simplex_offsetTheta);
  
  drawMesh(grid, scale);
  
  drawFrog();
  
  drawHand();
  
  //traceHeight(0,0);
}


float fadeDist = 0.2;
void drawMesh(float[][] mesh, float scale){
  push();
  translate(width/2, height/2 + 500, 0);
  rotateX(PI/2 - 0.2);
  //fill(0, 100); //semi-transparent fill
  //fill(0);
  translate(-(mesh[0].length-1)/2.0*scale, -(mesh.length-1)/2.0*scale);
  for(int r = 0; r < mesh.length - 1; r++){
    
    if(r > mesh.length*fadeDist) fill(12, 1, 56);
    else{
      //r = mesh.length/2
      float x = (mesh.length*fadeDist)-r;
      x /= (mesh.length*fadeDist);
      x = 1-x;
      float alpha = pow(x, 1);
      //println(alpha);
      fill(12, 1, 56, 255.0*alpha);
      //fill(255, 255.0*(pow(((float)r-mesh.length/2)/(mesh.length/2), 1)));
    }
    stroke(138, 36, 255, 255.0/mesh.length * r); //fade to horizon
    
    
    //PShape terrain = new PShape();
    push();
    beginShape(TRIANGLE_STRIP);
    for(int c = 0; c < mesh[r].length; c++){
      vertex(c*scale, r*scale, mesh[r][c]);
      vertex(c*scale, (r+1)*scale, mesh[r+1][c]);
    }
    endShape(CLOSE);
    pop();
    
    //threeD.shape(terrain);
  }
  pop();
}

ArrayList<PVector> points = new ArrayList<PVector>();
void traceHeight(int r, int c){
  push();
  hint(DISABLE_DEPTH_TEST);
  translate(0,heightScale/2 + 20);
  stroke(255, 100);
  line(0, 0, width, 0);
  
  strokeWeight(2);
  stroke(255);
  float x = -simplex_offsetTheta/(2*PI) * width;
  float h = grid[r][c];
  for(int i = 1; i < points.size() && points.get(i).x > points.get(i-1).x; i++){
    line(points.get(i).x, points.get(i).y, points.get(i-1).x, points.get(i-1).y);
  }
  points.add(new PVector(x, h));
  stroke(255,0,0);
  strokeWeight(10);
  point(x,h);
  hint(ENABLE_DEPTH_TEST);
  pop();
}

void keyPressed(){
  if(key == 'r'){
    xOff = random(-50, 50);
    yOff = random(-50, 50);
    zOff = random(-50, 50);
    points.clear();
    simplex_offsetTheta = 0;
    respawnFrog();
    loop();
  }
}
