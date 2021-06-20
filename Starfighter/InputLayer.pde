class InputLayer extends Layer{
  InputNeuron[] nArr;
  
  InputLayer(int size){
    nArr = new InputNeuron[size];
    for(int i = 0;i<size;i++){
      nArr[i] = new InputNeuron();
    }
  }
  
  void update(float[] vals){
    for(int i = 0;i<size();i++){
      nArr[i].update(vals[i]);
    }
  }
  
  int size(){
    return nArr.length;
  }
  Neuron get(int i){
    return (Neuron) nArr[i];
  }
}
