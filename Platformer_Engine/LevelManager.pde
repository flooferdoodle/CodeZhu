import java.io.*;
class LevelManager {
  ArrayList<Terrain> terr;
  Goal goal;
  String[] levelData;
  int level = 2;
  boolean dead = false;
  boolean win = false;
  
  LevelManager(){
    getLevelCount();
    terr = new ArrayList<Terrain>();
    goal = new Goal();
  }
  
  private void getLevelCount(){
    String[] loadedStrings = loadStrings("leveldata/currLevel.txt");
    if(loadedStrings == null){
      println("Could not saved level count.");
      level = 0;
      return;
    }
    level = Integer.parseInt(loadedStrings[0]);
  }
  
  boolean nextLevel(Player p){
    saveLevel();
    level++;
    
    levelData = loadStrings("leveldata/" + level + ".txt");
    if(levelData == null) return false;
    
    terr.clear();
    load(p);
    return true;
  }
  
  void load(Player p){
    for(String s : levelData){
      String[] split = s.split("\\s+");
      if(split.length == 2){ //player spawn pos
        p.pos.x = Float.parseFloat(split[0]);
        p.pos.y = Float.parseFloat(split[1]);
        p.vel.x = 0;
        p.vel.y = 0;
      }
      else if(split[0].equals("t") || split[0].equals("terr")){ //terrain
        terr.add(new Terrain(Float.parseFloat(split[1]),Float.parseFloat(split[2]),Float.parseFloat(split[3]),Float.parseFloat(split[4])));
      }
        
      
      else if(split[0].equals("g") || split[0].equals("goal")){ //goal
        goal.update(Float.parseFloat(split[1]),Float.parseFloat(split[2]));
      }
      else{
        println("error");
        return;
      }
    }
  }
  private void saveLevel(){
    saveStrings("leveldata/currLevel.txt", new String[]{""+level});
    
  }
 
  void restart(Player p){
    level = 0;
    saveLevel();
    terr.clear();
    nextLevel(p);
  }
  void reset(Player p){
    level--;
    terr.clear();
    nextLevel(p);
  }
   
  void draw(){
    
    for(Terrain t : terr){
      t.draw();
    }
    goal.draw();
  }
   
   
  void handle(Player p){
    
    for(Terrain t : lvlm.terr){
      p.collision(t);
      
      t.draw();
    }
    
    if(p.collide(lvlm.goal)){
      endLevel();
    }
    lvlm.goal.draw();
    
    
    //keep within screen bounds
    if(p.hbx.x1<0) p.pos.x -= p.hbx.x1;
    else if(p.hbx.x2>width) p.pos.x -= p.hbx.x2-width;
    if(p.hbx.y1>height){
      death();
    }
    p.updateHbx();
    
    
    p.draw();
  }
}
