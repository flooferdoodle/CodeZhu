abstract class Layer{
  Object[] nArr;
  
  int size(){
    return nArr.length;
  }
  
  Neuron get(int i){
    return (Neuron) nArr[i];
  }
}
