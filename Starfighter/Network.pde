class Network{
  Layer[] layerArr;
  
  Network(int[] size){
    layerArr = new Layer[size.length];
    layerArr[0] = new InputLayer(size[0]);
    for(int i = 1;i<size.length;i++){
      layerArr[i] = new MidLayer(size[i],layerArr[i-1]);
    }
  }
  
  Network(Network mom, Network dad){
    layerArr = new Layer[mom.layerArr.length];
    layerArr[0] = new InputLayer(((InputLayer) mom.layerArr[0]).size());
    for(int i = 1;i<layerArr.length;i++){
      layerArr[i] = new MidLayer((MidLayer) mom.layerArr[i],(MidLayer) dad.layerArr[i],layerArr[i-1]);
    }
  }
  
  
  //might change structure to have input array that takes in vision's entities and intersections
  void update(float[] vals){
    ((InputLayer) layerArr[0]).update(vals);
    for(int i = 1;i<layerArr.length;i++){
      ((MidLayer)layerArr[i]).update();
    }
  }
  
  public float[] output(){
    return ((MidLayer) layerArr[layerArr.length-1]).getVals();
  }
}
