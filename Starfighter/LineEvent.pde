class LineEvent implements Comparable<LineEvent>{
  float x;
  float y;
  Line l;
  boolean start;
  
  LineEvent(Line l, PVector p, boolean t){
    this.x = p.x;
    this.y = p.y;
    this.l = l;
    start = t;
  }
  
  void update(PVector pv, boolean t){
    this.x = pv.x;
    this.y = pv.y;
    start = t;
  }
  
  int compareTo(LineEvent l){
    return (int) (this.x - l.x);
  }
}
