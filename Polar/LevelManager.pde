class LevelManager {
  ArrayList<Terrain> terr;
  ArrayList<Magnet> magnets;
  ArrayList<Saw> saws;
  Goal goal;
  String[] levelData;
  int level = 0;
  boolean dead = false;
  boolean win = false;
  
  LevelManager(){
    terr = new ArrayList<Terrain>();
    magnets = new ArrayList<Magnet>();
    saws = new ArrayList<Saw>();
    goal = new Goal();
  }
  
  boolean nextLevel(Player p){
    level++;
    
    levelData = loadStrings("leveldata/" + level + ".txt");
    if(levelData == null) return false;
    
    terr.clear();
    magnets.clear();
    saws.clear();
    load(p);
    p.polarity = true;
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
      else if(split[0].equals("m") || split[0].equals("mag")){ //magnet
        boolean polar = split[2].equals("s");
        PVector domain = new PVector(Float.parseFloat(split[3]),Float.parseFloat(split[4]));
        float x = Float.parseFloat(split[5]);
        float y = Float.parseFloat(split[6]);
        float str = Float.parseFloat(split[7]);
        
        if(split[1].equals("c") || split[1].equals("circ")){ //circular magnet
          float r = Float.parseFloat(split[8]);
          magnets.add(new MagnetCircle(polar,domain,x,y,r,str));
        }
        else if(split[1].equals("r") || split[1].equals("rect")){ //rectangular magnet
          float size = Float.parseFloat(split[8]); 
          boolean horiz = split[9].equals("h");
          String sides = split[10];
          boolean[] active = {sides.contains("u"),sides.contains("r"),sides.contains("d"),sides.contains("l")};
          magnets.add(new MagnetRect(polar,domain,horiz,x,y,size,str,active));
        }
        
      }
      else if(split[0].equals("g") || split[0].equals("goal")){ //goal
        goal.update(Float.parseFloat(split[1]),Float.parseFloat(split[2]));
      }
      else if(split[0].equals("s") || split[0].equals("saw")){ //saw
        saws.add(new Saw(Integer.parseInt(split[1]),Integer.parseInt(split[2]),Integer.parseInt(split[3])));
      }
      else{
        println("error");
        return;
      }
    }
  }
 
  void restart(Player p){
    level = 0;
    terr.clear();
    magnets.clear();
    nextLevel(p);
  }
  void reset(Player p){
    level--;
    terr.clear();
    magnets.clear();
    nextLevel(p);
  }
   
  void draw(){
    
    for(Terrain t : terr){
      t.draw();
    }
    for(Magnet m : magnets){
      m.draw();
    }
    for(Saw s : saws){
      s.draw();
    }
    goal.draw();
  }
   
   
  void handle(Player p){
    for(Magnet m : lvlm.magnets){
    
    //first Collision
    p.collision(m);
    
    //Magnetism
    p.magnetism(m);
   
    //second collision
    p.collision(m);
    
    m.draw();

    }
    
    for(Terrain t : lvlm.terr){
      p.collision(t);
      
      t.draw();
    }
    
    if(p.collide(lvlm.goal)){
      endLevel();
    }
    lvlm.goal.draw();
    
    for(Saw s : saws){
      if(p.collide(s))
        dead = true;
      s.draw();
    }
    
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
