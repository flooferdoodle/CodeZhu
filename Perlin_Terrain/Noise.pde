OpenSimplexNoise simplexNoise;

float noiseScale = 0.06;
float xOff, yOff, zOff;

float heightScale = 600;

float simplex_sampleDeltaTheta = PI / 64;

float simplex_offsetTheta = 0;
float simplex_sampleRadius = 2; //changes length of circle/loop
void simplex(float[][] mesh){
  for(int y = 0; y < mesh.length; y++){
    for(int x = 0; x < mesh[y].length; x++){
      //simplex noise is in bounds [-1,1], but will almost never hit the extremes
      
      //looping using circular sampling from simplex noise
      float s_x = xOff + x*noiseScale*(0.6);
      float s_y = yOff + (sin(y*noiseScale/simplex_sampleRadius + simplex_offsetTheta)+1) * simplex_sampleRadius;
      float s_z = zOff + (cos(y*noiseScale/simplex_sampleRadius + simplex_offsetTheta)+1) * simplex_sampleRadius;
      float noise = (float) simplexNoise.eval(s_x,s_y,s_z);
      
      mesh[y][x] = heightScale/2 * noise;
      mesh[y][x] += heightScale/4 * simplexNoise.eval(s_x*3 + 20.7, s_y*3 + 31.4, s_z*3 + 14.3) * (1+noise);
      //mesh[y][x] += heightScale/6 * simplexNoise.eval(s_x*4, s_y*4, s_z*4);
      
      
      //mesh[y][x] += simplexNoise.eval(s_x*3 + 100, (s_y+s_z)*3 + 100)*50; //* (1+noise);//(1+sqrt((1+noise)/2));
    }
  }
}

float terrainFlatness = 4.3;
void loopPerlin(float[][] mesh){
  for(int y = 0; y < mesh.length; y++){
    for(int x = 0; x < mesh[y].length; x++){
      float s_x = xOff + x*noiseScale*(1);
      float s_y = yOff + (sin(y*noiseScale/simplex_sampleRadius + simplex_offsetTheta)+1) * simplex_sampleRadius;
      float s_z = zOff + (cos(y*noiseScale/simplex_sampleRadius + simplex_offsetTheta)+1) * simplex_sampleRadius;
      
      noiseDetail(3, 0.8);
      float noise = noise(s_x, s_y, s_z);
      noise = pow(noise, terrainFlatness); //scaling
      //noise = sigmoid(noise);
      
      mesh[y][x] = heightScale * noise - heightScale/2;
      
    }
  }
}

void perlin(float[][] mesh){
  for(int y = 0; y < mesh.length; y++){
    for(int x = 0; x < mesh[y].length; x++){
      mesh[y][x] = heightScale * noise(xOff + x*noiseScale, yOff + y*noiseScale);
      mesh[y][x] -= heightScale/2;
      
    }
  }
}

float sigmoid(float x){
  return 1/(1+exp(-x));
}
