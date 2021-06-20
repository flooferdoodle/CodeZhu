class MidNeuron extends Neuron{
  
  MidNeuron(Layer l){
    super(l);
  }
  
  void update(){
    z = 0;
    for(int i = 0;i<input.size();i++){
      z += input.get(i).val*w[i];
    }
    z += b;
    val = sigmoid(z);
  }
}
