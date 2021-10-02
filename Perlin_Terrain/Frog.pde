PShape frog;

float frogRot = 0;
float frogRadius = 0;
PShape frogTessellation;
float frogRoundness = 0.4;

PVector frogPos;
float frogSpeed;
float frogRotSpeed;
float frogFadeDist = -500;
float frogSpawnDist = -1000;
void loadFrog(){
  frog = loadShape("frog.obj");
  frogTessellation = frog.getTessellation();
  float maxDist = 0;
  for(int i = 0; i < frogTessellation.getVertexCount(); i++){
    maxDist = max(maxDist, frogTessellation.getVertex(i).magSq());
  }
  frogRadius = sqrt(maxDist);
  
  roundifyFrog(frogRoundness);
  
  frogPos = new PVector(0,0,0);
  respawnFrog();
  
  frogTessellation.disableStyle();
}

void roundifyFrog(float roundness){
  //rotundify the frog
  for(int i = 0; i < frogTessellation.getVertexCount(); i++){
    PVector currVertex = frogTessellation.getVertex(i);
    
    //get distance from max radius
    float distFromOrigin = currVertex.mag();
    float distFromRadius = frogRadius - distFromOrigin;
    
    //get desired length of vector
    float desiredLength = distFromOrigin + distFromRadius*roundness;
    
    currVertex.setMag(desiredLength);
    frogTessellation.setVertex(i, currVertex);
  }
}

void drawFrog(){
  push();
  lightFalloff(1, 0, 0);
  lightSpecular(0, 0, 0);
  ambientLight(223,108,159);
  directionalLight(147, 147, 132, -1, 0, -1);  //default front light
  directionalLight(255, 200, 105, (frogPos.x<0)?-1:1, 0, 0.4);//sun side light (yellow)
  directionalLight(199, 68, 242, (frogPos.x<0)?1:-1, 0, 0.2); //space side light (purple)
  
  //spotLight(255, 200, 105, width/2, height/2, -100, 0, 0, -1, PI, 2);
  
  float alpha = 1;
  if(frogPos.z < frogFadeDist){
    alpha = 1 - (frogFadeDist-frogPos.z)/(frogFadeDist-frogSpawnDist);
  }
  fill(128, 255*alpha);
  
  translate(width/2 + frogPos.x,height/2 + frogPos.y, frogPos.z);
  frogPos.z += frogSpeed;
  
  if(frogPos.z > -frogFadeDist){
    respawnFrog();
  }
  
  //translate(width/2, height/2, 100);
  rotateX(PI/2+0.07);
  rotateZ(frogRot);
  
  shape(frogTessellation, 0, 0);
  
  //bounding sphere
  //push(); noFill(); stroke(255, 100); sphereDetail(12); sphere(frogRadius); pop();
  
  pop();
  
  frogRot = (frogRot + frogRotSpeed) % (2*PI);
}

void respawnFrog(){
  //offscreen, respawn
  frogPos.x = random(-w*scale/2.5, w*scale/2.5);
  frogPos.y = random(-height/2.2, 0);
  frogPos.z = frogSpawnDist;
  frogSpeed = random(4, 10);
  frogRotSpeed = random(0.01,0.1);
}
