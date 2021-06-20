abstract class Neuron{
  float[] w;
  float b;
  float val;
  float z;
  Layer input;
  
  Neuron(){
    b = (float) Math.random()*2-1;
    val = 0;
    z = 0;
  }
  
  Neuron(Layer l){
    this();
    input = l;
    w = new float[input.size()];
    for(int i = 0;i<w.length;i++){
      w[i] = (float) Math.random()*2-1;
    }
  }
  
  float sigmoid(float x){
    //println(x + ":" + (1/(1+exp(-x))));
    return (1/(1+exp(-x)));
  }
  float derivSig(float x){
    return sigmoid(x)*(1-sigmoid(x));
  }
  //abstract void update();
}
