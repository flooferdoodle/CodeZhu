int[][] grid;//1 = snake, 2 = apple, 0 = empty
int head[] = {2,0};
int[][] snakeCoords = {{2,0}};
int dir[] = {1,0};//x,y movement
int[] apple = new int[2];
boolean dead = false;

int count = 0;
int speed = 6;

int gridSize = 40;


void setup(){
  size(800,600);
  
  //setup grid to 20x20 squares
  grid = new int[(width)/gridSize][(height)/gridSize];
  for(int i = 0;i<snakeCoords.length;i++){
    grid[snakeCoords[i][0]][snakeCoords[i][1]] = 1;
  }
  
  //get a random apple spot
  do{
    apple[0] = (int) random(grid.length);
    apple[1] = (int) random(grid[0].length);
  }while(grid[apple[0]][apple[1]] != 0);
  
  grid[apple[0]][apple[1]] = 2;
}

void reset(){
  //restart whole game
  head[0] = 2;
  head[1] = 0;
  snakeCoords = new int[][]{{2,0}};
  dir[0] = 1;
  dir[1] = 0;
  dead = false;
  
  grid = new int[grid.length][grid[0].length];
  for(int i = 0;i<snakeCoords.length;i++){
    grid[snakeCoords[i][0]][snakeCoords[i][1]] = 1;
  }
  
  generateApplePos();
  
  loop();
}


void draw(){
  background(0);
  
  count++;
  if(count>speed){
    count %= speed;
    update();
  }
  
  
  
  drawGrid();
  
  drawPath();
  
  
  if(dead){
    push();
    stroke(0);
    strokeWeight(100);
    fill(100,255,100);
    textSize(32);
    text("You lost. Space to restart", 100, 100);
    
    pop();
    noLoop();
  }
}

void update(){
  //keyboard inputs here to prevent inputting multiple times between updates
  if(keyCode == RIGHT && dir[0] == 0){
    dir[0] = 1;
    dir[1] = 0;
  }
  else if(keyCode == DOWN && dir[1] == 0){
    dir[0] = 0;
    dir[1] = 1;
  }
  if(keyCode == LEFT && dir[0] == 0){
    dir[0] = -1;
    dir[1] = 0;
  }
  else if(keyCode == UP && dir[1] == 0){
    dir[0] = 0;
    dir[1] = -1;
  }
  
  moveSnake();
}

void moveSnake(){
  
  //add direction of head
  head[0] += dir[0];
  head[1] += dir[1];
  
  //check if head is in bounds or if it hit itself
  if(head[0] >= grid.length || head[1] >= grid[0].length ||
     head[0] < 0 || head[1] < 0 ||
     grid[head[0]][head[1]] == 1){
     dead = true;
     return;
  }
  
  //check if head ate apple
  else if(grid[head[0]][head[1]] == 2){
    grid[apple[0]][apple[1]] = 0;
    
    generateApplePos();
    
    //lengthen snake
    int[][] newSnake = new int[snakeCoords.length+1][2];
    newSnake[0][0] = head[0];
    newSnake[0][1] = head[1];
    for(int i = 0; i < snakeCoords.length; i++){
      newSnake[i+1] = snakeCoords[i];
    }
    
    snakeCoords = newSnake;
    grid[snakeCoords[0][0]][snakeCoords[0][1]] = 1;
    return;
  }

  //shift snake by looping each unit and moving them to the next unit
  updateSnakeBody();
  
}

void updateSnakeBody(){
  int[] prev = {snakeCoords[0][0],snakeCoords[0][1]};
  
  grid[snakeCoords[0][0]][snakeCoords[0][1]] = 0;
  snakeCoords[0][0] = head[0];
  snakeCoords[0][1] = head[1];
  grid[head[0]][head[1]] = 1;
  
  for(int i = 1;i<snakeCoords.length;i++){
    grid[snakeCoords[i][0]][snakeCoords[i][1]] = 0;
    
    int[] temp = {prev[0],prev[1]};
    prev[0] = snakeCoords[i][0];
    prev[1] = snakeCoords[i][1];
    
    snakeCoords[i][0] = temp[0];
    snakeCoords[i][1] = temp[1];
    
    grid[snakeCoords[i][0]][snakeCoords[i][1]] = 1;
  }
}

void generateApplePos(){
  do{
    apple[0] = (int) random(grid.length);
    apple[1] = (int) random(grid[0].length);
  }while(grid[apple[0]][apple[1]] != 0);
  grid[apple[0]][apple[1]] = 2;
}

void drawPath(){
  push();
  //noStroke();
  stroke(0);
  
  //draw each square
  for(int r=0;r<grid.length;r++){
    for(int c=0;c<grid[r].length;c++){
      if(grid[r][c]==1){
        //snake color
        fill(255);
        
      }
      else if(grid[r][c]==2){
        //apple color
        fill(255,0,0);
      }
      
      if(grid[r][c] != 0){
        //if not empty, draw
        rect(r*gridSize,c*gridSize,gridSize,gridSize);
      }
    }
  }
  
  pop();
}

void drawGrid(){
  push();
  stroke(255,255,255,50);
  strokeWeight(1);
  noFill();
  
  //draw lines for grid
  for(int r = 0;r<grid[0].length;r++){
    line(0,r*gridSize,width,r*gridSize);
  }
  for(int c = 0;c<grid.length;c++){
    line(c*gridSize,0,c*gridSize,height);
  }
  
  pop();
}

void keyPressed(){
  //restart
  if(dead && key == ' '){
    reset();
  }
}
