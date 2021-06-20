class MidLayer extends Layer{
  MidNeuron[] nArr;
  
  MidLayer(int size, Layer prev){
    nArr = new MidNeuron[size];
    for(int i = 0;i<size;i++){
      nArr[i] = new MidNeuron(prev);
    }
  }
  
  MidLayer(MidLayer mom, MidLayer dad,Layer prev){
    nArr = new MidNeuron[mom.size()];
    for(int i = 0;i<nArr.length;i++){
      nArr[i] = new MidNeuron(prev);
      for(int j = 0;j<nArr[i].w.length;j++){
        //crossover between parents + mutation
        nArr[i].w[j] = ((new Random().nextBoolean()) ? mom.nArr[i].w[j] : dad.nArr[i].w[j]) + ((float) Math.random()*0.1);
      }
    }
  }
  
  void update(){
    for(int i = 0;i<nArr.length;i++){
      nArr[i].update();
    }
  }
  
  float[] getVals(){
    float[] output = new float[nArr.length];
    for(int i = 0;i<output.length;i++){
      output[i] = nArr[i].val;
    }
    return output;
  }
  
  int size(){
    return nArr.length;
  }
  Neuron get(int i){
    return (Neuron) nArr[i];
  }
}
