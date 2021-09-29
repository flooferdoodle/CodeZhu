class World{
  final PVector background = new PVector(217.0/255, 240.0/255, 255.0/255);
  Sphere s;
  Sphere s1, s2, s3;
  Sphere light;
  Box b;
  World(){
    //s = new Sphere(1, new PVector(-1,0,-2));
    s = new Sphere(1);
    s1 = new Sphere(1, new PVector(-2,0,0));
    s2 = new Sphere(1, new PVector(2,0,0));
    s3 = new Sphere(1, new PVector(0,3,0));
    b = new Box(new PVector(0.9,0.9,0.9));
    light = new Sphere(1, lightPos);
    //noiseDetail(5,0.4);
  }
  
  //k = smoothness, default to 0.05
  float smoothIntersect(float distA, float distB, float k ) {
    float h = constrain(0.5 - 0.5*(distA-distB)/k, 0., 1.);
    return mix(distA, distB, h ) + k*h*(1.-h); 
  }
  float smoothUnion(float distA, float distB, float k ) {
    float h = constrain(0.5 + 0.5*(distA-distB)/k, 0., 1.);
    return mix(distA, distB, h) - k*h*(1.-h); 
  }
  float smoothDifference(float distA, float distB, float k) {
    float h = constrain(0.5 - 0.5*(distB+distA)/k, 0., 1.);
    return mix(distA, -distB, h ) + k*h*(1.-h); 
  }
  
  float intersect(float distA, float distB){ return max(distA, distB);}
  float union(float distA, float distB){ return min(distA, distB);}
  float difference(float distA, float distB){ return max(distA, -distB);}
  
  private float mix(float x, float y, float a){
    return x*(1-a) + y*a;
  }
  
  float time = 0;
  void updateTime(){ time += 0.1;}
  float mapOfWorld(PVector p){
    
    //float displacement = sin((5 * p.x + time)%(2*PI)) * sin((5 * p.y + time)%(2*PI)) * sin((5 * p.z + time)%(2*PI)) * .25;
    float displacement = noise(0.4*p.x + 0.4*time, 0.4*p.y + 0.4*time, 0.4*p.z + 0.4*time)*1.5;
    /*float sphere_0 = s.sDist(p);
    float box_0 = b.sDist(p);
    //displacement = 0;
    //return sphere_0 + displacement;
    //return box_0 + displacement;
    //return difference(sphere_0, box_0);
    return smoothUnion(sphere_0, box_0, 0.1);*/
    
    float sphere_1 = s1.sDist(p);
    float sphere_2 = s2.sDist(p);
    float sphere_3 = s3.sDist(p);
    
    float lightDist = light.sDist(p);
    //return smoothUnion(sphere_3,smoothUnion(sphere_1, sphere_2, 0.7), 3);
    return union(lightDist, smoothUnion(sphere_1-displacement, sphere_2-displacement, 1));
  }
  
  PVector lightPos = new PVector(0, -5, -3);
  float ambientLight = 50.0/255;
  float specularIntensity = 0.0008;
  PVector raymarch(PVector origin, PVector direction){
    float totalDist = 0;
    //can use the num of steps travelled to find "edges"
    final int NUM_OF_STEPS = 45; //when close to edges, lots of very small steps -> assuming in bckgrnd
    final float MIN_HIT_DIST = 0.01;
    final float MAX_TRACE_DIST = 1000; //farthest render dist
    
    int i = 0;
    for(; i < NUM_OF_STEPS; ++i){
      //get current position along ray direction
      PVector currPos = PVector.add(origin, PVector.mult(direction,totalDist));
      
      float distToClosest = mapOfWorld(currPos);
      
      //debug 
      //return color(map(distToClosest, -
      
      if(distToClosest < MIN_HIT_DIST){
        //there was a hit, color position
        PVector normal = calcNormal(currPos);
        //multicolored shading
        /*map(normal, -1, 1, 0, 255);
        return color(normal.x,normal.y,normal.z);*/
        
        //pure red shading
        //return color(255,0,0);
        
        //diffuse shading
        
        float diffuse = diffuseIntensity(currPos, lightPos, normal);
        float specular = specular(origin, currPos, lightPos, normal) * specularIntensity;
        
        PVector lighting = new PVector(ambientLight + diffuse+specular, specular, ambientLight + specular);
        
        //PVector edgeGlow = PVector.mult(background,(float(i)/NUM_OF_STEPS));
        //return PVector.add(lighting, edgeGlow);
        
        return lighting;
      }
      
      if(totalDist > MAX_TRACE_DIST){//no hit
        break;
      }
      
      
      totalDist += distToClosest;
    }
    
    //if(totalDist > MAX_TRACE_DIST) return background;
    
    //adding glow to "edges"
    //return PVector.mult(background,max(1,(float(i)/NUM_OF_STEPS)));
    return background;
  }
  
  float diffuseIntensity(PVector pos, PVector lightPos, PVector normal){
    PVector dirToLight = PVector.sub(pos, lightPos);
    dirToLight.normalize();
    return max(0, PVector.dot(normal, dirToLight));
  }
  float specularPower = 2;
  float specular(PVector camPos, PVector pos, PVector lightPos, PVector normal){
    PVector dirToLight = PVector.sub(lightPos, pos);
    PVector R = PVector.mult(normal, PVector.dot(normal, dirToLight)*2).sub(dirToLight);
    PVector dirToCam = PVector.sub(camPos, pos);
    return pow(PVector.dot(R, dirToCam), specularPower);
  }
  
  PVector calcNormal(PVector pos){
    final float smallStep = 0.02; //seems to affect smoothness of output
    
    PVector xStep = new PVector(smallStep, 0, 0);
    PVector yStep = new PVector(0, smallStep, 0);
    PVector zStep = new PVector(0, 0, smallStep);
    
    float gradientX = mapOfWorld(PVector.add(pos, xStep)) - mapOfWorld(PVector.sub(pos, xStep));
    float gradientY = mapOfWorld(PVector.add(pos, yStep)) - mapOfWorld(PVector.sub(pos, yStep));
    float gradientZ = mapOfWorld(PVector.add(pos, zStep)) - mapOfWorld(PVector.sub(pos, zStep));
    
    PVector normal = new PVector(gradientX, gradientY, gradientZ);
    normal.normalize(); //between -1 and 1
    return normal;
  }
}

void map(PVector v, float x1, float x2, float y1, float y2){
  v.x = map(v.x, x1, x2, y1, y2);
  v.y = map(v.y, x1, x2, y1, y2);
  v.z = map(v.z, x1, x2, y1, y2);
}
