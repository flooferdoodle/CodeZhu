PVector camPos;
PVector camDir;
PImage render;
World w;
float camTheta; //stores xz plane angle of camera
float camTrackRadius = 5; //radius of camera rotation
float startAngle = 3*PI/2;
void setup(){
  size(400,400);
  w = new World();
  camTheta = startAngle;
  camPos = new PVector(camTrackRadius*cos(camTheta),0,camTrackRadius*sin(camTheta));
  camDir = new PVector(-1,1,1);
  render = createImage(200,200,RGB);
}

void draw(){
  w.updateTime();
  //artifically getting sampled points on the viewing plane
  for(int x = 0; x < render.width; ++x){
    for(int y = 0; y < render.height; ++y){
      PVector dir = new PVector((float)x/render.width * 2 - 1, (float)y/render.width * 2 - 1,1);
      PVector tempRot = new PVector(dir.x, dir.z);
      tempRot.rotate(camTheta - startAngle);
      dir.x = tempRot.x; dir.z = tempRot.y;
      //PVector dir = PVector.sub(dest, camPos);
      //println(dir);
      
      //flipping y to go bottom up instead
      render.set(x, render.height-y, Color(w.raymarch(camPos, dir)));
    }
  }
  image(render,0,-2,width,height);
  //filter(BLUR, 2);
}

public color Color(PVector p){
  //if(p.magSq() <= 3) //within [0,1]
    return color(p.x*255, p.y*255, p.z*255);
  //return color(p.x, p.y, p.z);
}



boolean mouseDown = false;
PVector mouseDownPos;
float origAngle;
void mousePressed(){
  if(!mouseDown){
    mouseDown = true;
    mouseDownPos = new PVector(mouseX, mouseY);
    origAngle = camTheta;
  }
}
void mouseReleased(){
  mouseDown = false;
}
void mouseDragged(){
  if(mouseDown){
    camTheta = origAngle + 0.01*(mouseX - mouseDownPos.x);
    refreshCam();
  }
}

void keyPressed(){
  if(key == 'i') {camTrackRadius--; refreshCam();}
  if(key == 'o') {camTrackRadius++; refreshCam();}
}
void refreshCam(){
  camPos.x = camTrackRadius*cos(camTheta);
  camPos.z = camTrackRadius*sin(camTheta);
}
