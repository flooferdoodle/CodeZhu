void gradientRect(int x, int y, float w, float h, color c1, color c2, boolean horizontal){
  if(horizontal){
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      //line(x, i, x+w, i);
      hPixelLine(x, x+w, i, c);
    }
  }
  else{
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      //line(i, y, i, y+h);
      vPixelLine(y, y+h, i, c);
    }
  }
}

void hPixelLine(float x1, float x2, float y, color c){
  loadPixels();
  for(int x = (int) x1; x <= x2; x++){
    pixels[(int) y*width + x] = c;
  }
  updatePixels();
}

void vPixelLine(float y1, float y2, float x, color c){
  loadPixels();
  for(int y = (int) y1; y <= y2; y++){
    pixels[y*width + (int) x] = c;
  }
  updatePixels();
}

void eraseRect(PGraphics pg, float x1, float y1, float x2, float y2){
  //make a transparent rectangle
  pg.loadPixels();
  for(int x = (int) x1; x < x2; x++){
    for(int y = (int) y1; y < y2; y++){
      pg.pixels[y*pg.width + x] = color(255, 255, 255,0);
    }
  }
  pg.updatePixels();
}

void circleGlow(PGraphics pg, float x, float y, float r, color c){
  pg.push();
  pg.noFill(); pg.strokeWeight(5);
  for(int radius = 1; radius < r; radius++){
    float alpha = 1-pow(radius/r, 1);
    color curr = color(red(c), green(c), blue(c), 255*alpha);
    pg.stroke(curr);
    pg.circle(x, y, radius);
  }
  pg.pop();
}

float handTheta = 0;
void drawHand(){
  //temporarily disable 3d for drawing hand
  hint(DISABLE_DEPTH_TEST); //NOTE: this clears 3d buffer
  image(hand, width/2-275*handScale, height/2-10*handScale + 30*sin(handTheta), 550*handScale, 660*handScale);
  hint(ENABLE_DEPTH_TEST);
  
  handTheta = simplex_offsetTheta*2;//(handTheta + 0.03) % (2*PI);
}
