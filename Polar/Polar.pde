//platformer with magnetic properties



LevelManager lvlm;

int state = 3;
//0=menu,1=level select,2=custom levels,3=ingame,4=levelbuilder,5=stagetester

void setup(){
  size(800,608);
  noStroke();
  
  //INGAME------------------------------------------------------
  textSize(12);
  p = new Player();
  lvlm = new LevelManager();
  lvlm.nextLevel(p);
  
  bckgrd[0] = loadImage("Textures/Terrain/FlatBlock.png");
  bckgrd[1] = loadImage("Textures/Terrain/MetalBrick.png");
  bckgrd[2] = loadImage("Textures/Terrain/DiamondTile.png");
  bkgArr = new PImage[ceil(width/32.0)][ceil(height/32.0)];
  for(int x = 0;x<bkgArr.length;x++){
    for(int y = 0;y<bkgArr[x].length;y++){
      //println(floor(random(0,3)));
      bkgArr[x][y] = bckgrd[floor(random(0,3))];
    }
  }
  
  
  //LEVELBUILDER------------------------------------------------------
  grid = new String[width/16][height/16];
  loadTestLvl();
  playerTexture = loadImage("Textures/Character/BlueCh.png");
  goalTexture = loadImage("Textures/Portal/Portal.png");
  terrTexture = new PImage[][] 
               {{loadImage("Textures/Terrain/FlatBlock.png")},//ground texture
                {loadImage("Textures/Magnet/NLHA.png"),loadImage("Textures/Magnet/SLHA.png")},//horizontal magnet texture
                {loadImage("Textures/Magnet/NLVA.png"),loadImage("Textures/Magnet/SLVA.png")},//vertical magnet texture
                {loadImage("Textures/Magnet/NA.png"),loadImage("Textures/Magnet/SA.png")}};//circular magnet texture
}



void draw(){
  switch (state){
    case 0:
      menu();
      break;
    case 3:
      inGame();
      break;
    case 4:
      lvlBuilder();
      break;
    case 5:
      inGame();
      if(lvlm.level>0) state = 4;
      break;
   
      
  }
}

void menu(){
  
}

//LEVELBUILDER------------------------------------------------------
PVector roundPos = new PVector(0,0);
String[][] grid;
PImage playerTexture;
PImage goalTexture;
PImage[][] terrTexture;
int material = 0;
int polarity = 0; //0=red,north,1=blue,south
int[] spawnPos = new int[]{-1,-1};
int[] goalPos = new int[]{-1,-1};
boolean drawingTerr = false;
PVector terrStart = new PVector(0,0);
void lvlBuilder(){
  background(50);
  
  drawGrid(); //draws elements onto grid
  
  //split by 16 pixel grid
  //draw grid
  push();
  stroke(255,127,80,50);
  for(int i = 0;i<width/16;i++){
    line(i*16,0,i*16,height);
  }
  for(int i = 0;i<height/16;i++){
    line(0,i*16,width,i*16);
  }
  pop();
  
  //rounded gridspace
  roundPos.x = (float) Math.floor((float) mouseX/width * (grid.length)) * 16;
  roundPos.y = (float) Math.floor((float) mouseY/height * (grid[0].length)) * 16;
  
  push();
  tint(255,100);
  if(material==0){//player
    image(playerTexture,roundPos.x,roundPos.y);
  }
  else if(material==9){//goal
    image(goalTexture,roundPos.x,roundPos.y);
  }
  else if(material==1 && !drawingTerr){//terrain
    image(terrTexture[0][0],roundPos.x,roundPos.y);
  }
  else if(material>1 && material<=4){//magnets
    image(terrTexture[material-1][polarity],roundPos.x,roundPos.y);
  }
  pop();
  
  
  if(drawingTerr){
    push();
    fill(210,105,30,100);
    rectMode(CORNERS);
    //rect(terrStart.x,terrStart.y,(roundPos.x+16) + (roundPos.x+16-terrStart.x)%32,(roundPos.y+16) + (roundPos.y+16-terrStart.y)%32);
    tint(255,100);
    for(int x = (int) terrStart.x;x<(roundPos.x+16) + (roundPos.x+16-terrStart.x)%32;x+=32){
      for(int y = (int) terrStart.y;y<(roundPos.y+16) + (roundPos.y+16-terrStart.y)%32;y+=32){
        image(terrTexture[0][0],x,y);
      }
    }
    //want to round by 32 so the block textures work
    pop();
  }
  
  
}

void loadTestLvl(){
  String[] strArr = loadStrings("leveldata/0.txt");
  for(String str : strArr){
    String[] split = str.split("\\s+");
    
    if(split.length == 2){ //player spawn pos
        grid[Integer.parseInt(split[0])/16][Integer.parseInt(split[1])/16] = str;
        spawnPos[0] = Integer.parseInt(split[0])/16;
        spawnPos[1] = Integer.parseInt(split[1])/16;
    }
    
    else if(split[0].equals("t")){ //terrain
      grid[Integer.parseInt(split[1])/16][Integer.parseInt(split[2])/16] = str;
    }
    else if(split[0].equals("g")){ //goal
      grid[Integer.parseInt(split[1])/16][Integer.parseInt(split[2])/16] = str;
      goalPos[0] = Integer.parseInt(split[1])/16;
      goalPos[1] = Integer.parseInt(split[2])/16;
    }
      
    else if(split[0].equals("m")){ //magnet
      grid[Integer.parseInt(split[5])/16][Integer.parseInt(split[6])/16] = str;
    }
  }
}

void drawGrid(){
  for(int x = 0;x<grid.length;x++){
    for(int y = 0;y<grid[x].length;y++){
      
      if(grid[x][y] == null) continue;
      
      String[] split = grid[x][y].split("\\s+");
      if(split.length == 2){ //player spawn pos
        image(playerTexture,x*16,y*16);
      }
      else if(split[0].equals("t")){ //terrain
        for(int i = Integer.parseInt(split[1]);i<Integer.parseInt(split[3]);i+=32){
          for(int j = Integer.parseInt(split[2]);j<Integer.parseInt(split[4]);j+=32){
            image(terrTexture[0][0],i,j);
          }
        }
      }
      else if(split[0].equals("g")) //goal
        image(goalTexture,Integer.parseInt(split[1]),Integer.parseInt(split[2]));
      
      
      else if(split[0].equals("m")){ //magnet
        boolean polar = split[2].equals("s");
        float xpos = Float.parseFloat(split[5]);
        float ypos = Float.parseFloat(split[6]);
        
        if(split[1].equals("c")){ //circular magnet
          float r = Float.parseFloat(split[8]);
          push();
          fill(255,0,0,50);
          ellipse(xpos+24,ypos+24,r*2,r*2);
          pop();
          image(terrTexture[3][(polar)?1:0],xpos,ypos);
        }
        else if(split[1].equals("r")){ //rectangular magnet
          float size = Float.parseFloat(split[8]); 
          boolean horiz = split[9].equals("h");
          String sides = split[10];
          boolean[] active = {sides.contains("u"),sides.contains("r"),sides.contains("d"),sides.contains("l")};
          if(horiz){
            image(terrTexture[1][(polar)?1:0],xpos,ypos);
          }
          else{
            image(terrTexture[2][(polar)?1:0],xpos,ypos);
          }
          push();
          fill(255,0,0,50);
          rectMode(CORNERS);
          if(active[0]){//up
            rect(xpos,ypos-size,xpos+((horiz)?64:16),ypos);
          }
          if(active[1]){//right
            rect(xpos+((horiz)?64:16),ypos,xpos+((horiz)?64:16)+size,ypos+((horiz)?16:64));
          }
          if(active[2]){//down
            rect(xpos,ypos+((horiz)?16:64),xpos+((horiz)?64:16),ypos+((horiz)?16:64)+size);
          }
          if(active[3]){//left
            rect(xpos-size,ypos,xpos,ypos+((horiz)?16:64));
          }
          pop();
        }
        
      }
    }
  }
}

void lvlToDat(){
  PrintWriter p = createWriter("leveldata/0.txt");
  boolean spawn = false;
  boolean goal = false;
  
  for(int i = 0;i<grid.length;i++){
    for(int j = 0;j<grid[i].length;j++){
      if(grid[i][j]!=null){
        p.println(grid[i][j]);
        if(grid[i][j].split("\\s+").length==2) spawn = true;
        else if(grid[i][j].split("\\s+")[0].equals("g")) goal = true;
      }
    }
  }
  
  if(!spawn){
    p.println("0 0");
  }
  if(!goal){
    p.println("g 200 400");
  }
  p.close();
}

//INGAME------------------------------------------------------
Player p;
boolean[] keys = new boolean[4];
boolean loading = false;
boolean loaded = false;
int fadeTime = 50;
int fadeColor = 0;

PImage[] bckgrd = new PImage[3];
PImage[][] bkgArr;

void inGame(){
  for(int x = 0;x<bkgArr.length;x++){
    for(int y = 0;y<bkgArr[x].length;y++){
      image(bkgArr[x][y],x*32,y*32,32,32);
    }
  }
  push();
  fill(0,200);
  rect(0,0,width,height);
  pop();
  
  if(loading){
    fade();
    if(fadeColor>=255){
      if(lvlm.nextLevel(p)){
        loading = false;
        loaded = true;
      }
      else{
        lvlm.win = true;
        loading = false;
      }
    }
    return;
  }
  else if(lvlm.dead || lvlm.win){
    fade();
    push();
    fill(255,fadeColor);
    textSize(12);
    if(lvlm.dead) text("You died",width/2-20,height/2 - 20);
    else text("You win!",width/2-20,height/2 - 20);
    text("Space to restart",width/2-20,height/2);
    pop();
    return;
  }
  
  
  
  p.input(keys);
  
  p.move();
  
  lvlm.handle(p);
  
  

  //debugStats();
  
  if(loaded){
    push();
    fill(0,fadeColor);
    rect(0,0,width,height);
    pop();
    fadeColor -= 255/(fadeTime/2);
    if(fadeColor <= 0){
      fadeColor = 0;
      loaded = false;
    }
  }
}

void debugStats(){
  push();
  fill(0);
  stroke(0);
  textSize(12);
  text("x: " + p.pos.x,10,20);
  text("y: " + p.pos.y,10,35);
  text("xvel: " + p.vel.x,10,50);
  text("yvel: " + p.vel.y,10,65);
  
  if(p.onSurface!=0){
    fill(0,255,0);
    stroke(0,255,0);
  }
  else{
    fill(255,0,0);
    stroke(255,0,0);
  }
  text("onsurface",10,80);
  pop();
}

void death(){
  lvlm.dead = true;
}

void endLevel(){
  loading = true;
}

void fade(){
  p.draw();
  lvlm.draw();
  
  push();
  fill(0,fadeColor);
  rect(0,0,width,height);
  pop();
  fadeColor += 255/fadeTime;
  if(fadeColor >= 255){
    fadeColor = 255;
  }
}

//INPUTS------------------------------------------------------
void keyPressed(){
  switch (state){
    case 5:
    case 3:
      if(key == CODED){
        if(keyCode == UP)
          keys[0] = true;
        if(keyCode == DOWN)
          keys[1] = true;
        if(keyCode == RIGHT)
          keys[2] = true;
        if(keyCode == LEFT)
          keys[3] = true;
      }
      if(key == ' '){
        if(lvlm.dead){
          lvlm.dead = false;
          lvlm.reset(p);
          loaded = true;
        }
        else if(lvlm.win){
          lvlm.win = false;
          lvlm.restart(p);
          loaded = true;
        }
        else{
          p.polarity = !p.polarity;
        }
      }
      if(key == 'q' && state == 5) state = 4;
      break;
    
    case 4: //levelbuilder
      if(key == '0')
        material = 0;
      if(key == '9')
        material = 9;
      if(key == '1')
        material = 1;
      if(key == '2')
        material = 2;
      if(key == '3')
        material = 3;
      if(key == '4')
        material = 4;
      if(key == ' '){
        if(polarity==1) polarity = 0;
        else polarity++;
      }
      if(key == 'p'){
        state = 5;
        lvlToDat();
        lvlm.level = -1;
        lvlm.nextLevel(p);
      }
      if(key == 'e')
        material = -1;
      
      break;
      
    
  }
}
void keyReleased(){
  switch (state){
    case 5:
    case 3:
      if(key == CODED){
        if(keyCode == UP)
          keys[0] = false;
        if(keyCode == DOWN)
          keys[1] = false;
        if(keyCode == RIGHT)
          keys[2] = false;
        if(keyCode == LEFT)
          keys[3] = false;
      }
      break;
  }
}

void mouseClicked(){
  switch (state){
    case 3:
      //p.pos.x = mouseX;
      //p.pos.y = mouseY;
      break;
  }
}
void mousePressed(){
  switch (state){
    case 4://level builder
      if(material==1){//drawing terrain
        drawingTerr = true;
        terrStart.x = roundPos.x;
        terrStart.y = roundPos.y;
      }
      
      break;
  }
}
void mouseReleased(){
  switch (state){
    case 4: //levelbuilder
      if(material==1 && drawingTerr){//drawing terrain
        drawingTerr = false;
        if(roundPos.x < terrStart.x || roundPos.y < terrStart.y) return;
        grid[(int) terrStart.x/16][(int) terrStart.y/16] = "t " + (int) terrStart.x + " " + (int) terrStart.y + " " + ((int) ((roundPos.x+16) + (roundPos.x+16-terrStart.x)%32)) + " " + ((int) ((roundPos.y+16) + (roundPos.y+16-terrStart.y)%32));
      }
      else if(material==0){//spawn
        if(spawnPos[0]>-1){
          grid[spawnPos[0]][spawnPos[1]] = null;
        }

        spawnPos[0] = (int) roundPos.x/16;
        spawnPos[1] = (int) roundPos.y/16;
        
        grid[spawnPos[0]][spawnPos[1]] = (int) roundPos.x + " " + (int) roundPos.y;
      }
      else if(material==9){ //goal
        if(goalPos[0]>-1){
          grid[goalPos[0]][goalPos[1]] = null;
        }

        goalPos[0] = (int) roundPos.x/16;
        goalPos[1] = (int) roundPos.y/16;
        
        grid[goalPos[0]][goalPos[1]] = "g " + (int) roundPos.x + " " + (int) roundPos.y;
      }
      else if(material==2 || material==3){ //rect magnet
        grid[(int) roundPos.x/16][(int) roundPos.y/16] = "m r " + ((polarity==0)?"n":"s") + " 0.2 0.8 "
              + (int) roundPos.x + " " + (int) roundPos.y + " 10 100 " + 
              ((material==2)?"h":"v") + " " + ((material==2)?"u":"r");
      }
      else if(material==4){//circular magnet
        grid[(int) roundPos.x/16][(int) roundPos.y/16] = "m c " + ((polarity==0)?"n":"s") + " 0.2 0.8 "
              + (int) roundPos.x + " " + (int) roundPos.y + " 10 100";
      }
      else if(material==-1){//eraser
        grid[(int) roundPos.x/16][(int) roundPos.y/16] = null;
      }

      break;
    
  }
}

float absmin(float a, float b){
  return (abs(a)<=abs(b))?a:b;
}
