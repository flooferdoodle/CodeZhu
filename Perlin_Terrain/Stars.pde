PGraphics sun, backglow;

void makeSunGlow(){
  backglow = createGraphics(width/2,height/2,P2D);
  //glow
  backglow.format = ARGB;
  backglow.beginDraw();
  backglow.translate(backglow.width/2, backglow.height/2);
  circleGlow(backglow, 0, 0, backglow.width*.9, color(236,33,120));
  backglow.endDraw();
}

float sunCutDrift = 0;
void makeSun(){
  sun = createGraphics(width/2,height/2,P2D);
  
  //sun
  sun.format = ARGB;
  sun.beginDraw();
  sun.noStroke();
  
  sun.fill(255, 200, 105);
  sun.circle(sun.width/2, sun.height/2,sun.width*.75);
  
  float scale = 0.05 * sqrt((sunCutDrift)/0.7);
  for(float y = 0.25+sunCutDrift; y + scale < 1; y += 0.07){
    eraseRect(sun, 0, sun.height*y, sun.width, sun.height*(y + scale));
    scale = 0.05 * sqrt((y-0.25+0.07)/0.7);
  }
  sunCutDrift = (sunCutDrift+0.001) % 0.07;
  sun.filter(BLUR,2);
  
  sun.endDraw();
  
}

void updateSun(){
  sun.beginDraw();
  sun.background(color(255,255,255,0));
  sun.noStroke();
  
  sun.fill(255, 200, 105);
  sun.circle(sun.width/2, sun.height/2,sun.width*.75);
  
  float scale = 0.05 * ((sunCutDrift)/0.7);
  for(float y = 0.25+sunCutDrift; y + scale < 1; y += 0.07){
    eraseRect(sun, 0, sun.height*y, sun.width, sun.height*(y + scale));
    scale = 0.05 * ((y-0.25+0.07)/0.7);
  }
  sunCutDrift = (sunCutDrift+0.003) % 0.07;
  sun.filter(BLUR,2); 
  
  sun.endDraw();
}

float glowTheta = 0;
float glowGrow = 0.03;
void drawSun(float x, float y, float diameter){
  hint(DISABLE_DEPTH_TEST);
  
  push();
  translate(x,y);
  float glowD = diameter * (1+glowGrow*(1+sin(glowTheta)));
  image(backglow,-glowD/2,-glowD/2,glowD,glowD);
  image(sun,-diameter/2,-diameter/2,diameter,diameter);
  pop();
  glowTheta = (glowTheta+0.05)%(2*PI);
  
  hint(ENABLE_DEPTH_TEST);
}

void generateStars(){
  stars = createGraphics(width,height,P2D);
  stars.format = ARGB;
  stars.beginDraw();
  for(int i = 0; i < 80; i++){
    float r = random(1,5);
    int x = (int) random(0, width*1.5);
    int y = (int) random(0, height*1.5);
    circleGlow(stars, x, y, r, color(255));
  }
  stars.endDraw();
}
void drawStars(){
  hint(DISABLE_DEPTH_TEST);
  
  push();
  image(stars,0,0);
  pop();
  
  hint(ENABLE_DEPTH_TEST);
}
