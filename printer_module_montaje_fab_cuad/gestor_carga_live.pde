class GestorCargaLive {

  boolean load_flag;

  int[] indexes_to_load;

  //------------------------------------------------------------------------------------

  GestorCargaLive() {

    reset();
  }

  //------------------------------------------------------------------------------------

  void reset() {

    load_flag = false;

    indexes_to_load = new int[0];
  }
  
  //------------------------------------------------------------------------------------
  
  void raiseFlag(){
  
    load_flag = true;
  
  }
  
  //------------------------------------------------------------------------------------
  
  void dropFlag(){
  
    load_flag = false;
  
  }
  
  //------------------------------------------------------------------------------------
  
  void addIndex(int i){
  
    load_flag = true;
    indexes_to_load = append(indexes_to_load,i);
  
  }
  
  //-------------------------------------------------------------------------------------
  
  boolean flagRaised(){
  
    return load_flag;
  
  }
}

