void loadAll() {
  
  f = new ArrayList();
    
  select_index = 0;

  int begin = suspects_number - 16;

  if (begin < 1)

    begin = 1;
    
    

  for (int i = begin; i <= suspects_number; i++ ) {

    String path = DIRPATH + "suspects/" + (i) + "/" ;
    
    println("INTENTANDO CARGAR" + path);

    FaceNormCompact aux = loadFace(path);

    if (aux!=null) {

      if (f.size()<16)
      
        aux.setId(str(i));

        f.add(aux);
        
        processImage(aux.img_face, aux);
        
    }
  }

  println(f.size() + " caras cargadas con exito/");
}

//---------------------------------------------------------------------------------------


FaceNormCompact loadFace(String path) {

  XML xml;

  xml = loadXML(path + "face.xml");

  FaceNormCompact aux = null;


  if (xml !=null) {

    println("XML cargado ----> " + path + "face.xml");

    XML[] face = xml.getChildren();

    XML[] children = face[1].getChildren();

    XML[] charges_xml = face[3].getChildren();

    //  println(children);

    Rectangle f = null;

    Rectangle l_e = null;

    Rectangle r_e = null;

    Rectangle m = null;

    Rectangle n = null;

    aux = new FaceNormCompact();

    for (int i = 0; i < children.length; i++) {

      if (children[i].getName().equals("face_map")) {

        f = new Rectangle(children[i].getInt("x"), children[i].getInt("y"), children[i].getInt("w"), children[i].getInt("h"));
      } else  if (children[i].getName().equals("l_eye_map")) {

        l_e = new Rectangle(children[i].getInt("x"), children[i].getInt("y"), children[i].getInt("w"), children[i].getInt("h"));
      } else  if (children[i].getName().equals("r_eye_map")) {

        r_e = new Rectangle(children[i].getInt("x"), children[i].getInt("y"), children[i].getInt("w"), children[i].getInt("h"));
      } else  if (children[i].getName().equals("mouth_map")) {

        m = new Rectangle(children[i].getInt("x"), children[i].getInt("y"), children[i].getInt("w"), children[i].getInt("h"));
      } else  if (children[i].getName().equals("nose_map")) {

        n = new Rectangle(children[i].getInt("x"), children[i].getInt("y"), children[i].getInt("w"), children[i].getInt("h"));
      }
    }

    aux.setMainRects(f, l_e, r_e);

    if (m!=null) {

      aux.setMouth(m);
    }

    if (n!=null) {

      aux.setNose(n);
    }

    for (int i = 0; i < charges_xml.length; i++) {

      if (charges_xml[i].getName().equals("charge")) {
        String c =  charges_xml[i].getContent();
        aux.charges = append(aux.charges, c);
      }
    }

    // println("XML cargado -> ../../repo//index.xml");
    //  println("valor de indice actualizado : " + suspects_number);

    PImage f_i = loadImage(path + "faceBound.jpg");

    PImage c_i = loadImage(path + "faceCrop.jpg");

    aux.setImages( f_i, c_i);
  }

  return aux;
}

//---------------------------------------------------------------------------------------

void loadIndex() {

  XML xml;
  
  String path = DIRPATH + "suspects/index.xml";
  xml = loadXML(path);


  if (xml !=null) {

    XML[] children = xml.getChildren("index");

    int aux = 0;

    for (int i = 0; i < children.length; i++) {
      aux = children[i].getInt("val");
    }

    suspects_number = aux;

    println("XML cargado -> ../../repo//index.xml");
    println("valor de indice actualizado : " + suspects_number);
  }else 
    suspects_number = 0;
}

//-------------------------------------------------------------------------------------------

void loadNew(int index) {

  String path = DIRPATH + "suspects/" + (index) + "/" ;

  FaceNormCompact aux = loadFace(path);
  
          aux.setId(str(index));
          
        processImage(aux.img_face, aux);



  if (aux!=null) {

    if (f.size() < 16)

      f.add(aux);

    else {

      f.remove(f.get(0));

      f.add(aux);
    }




    /*   if (f.size() < 16)
     
     f.add(aux);
     
     
     for (int i = f.size ()-1; i > 1; i--) {
     
     println("aca");
     
     FaceNormCompact nuevo = f.get(i);
     
     nuevo =  f.get(i-1);
     
     // f.get(i) = f.get(i-1);
     }
     
     FaceNormCompact nuevo  = aux;*/
  }
}

//-------------------------------------------------------------------------------------------------

void loadPrintCount() {

  XML xml;
  
  String path = DIRPATH + "printcount.xml";
  xml = loadXML(path);


  if (xml !=null) {

    XML[] children = xml.getChildren("count");

    int aux = 0;

    for (int i = 0; i < children.length; i++) {
      aux = children[i].getInt("val");
    }

    global_prints = aux;

    println("XML cargado -> printcount.xml");
    println("printcount actualizado : " + global_prints);
  }else 
    global_prints = 0;
}

//----------------------------------------------------------------------------------------------------

void savePrintCount() {

  String[] out = new String[] {
    "<xml>"
  };

  String line = "<count val=\""+global_prints+"\" ></count>";
  out = append(out, line);
  line = "</xml>";
  out = append(out, line);

  String path = DIRPATH + "printcount.xml";

  saveStrings(path, out);

  println("printcount guardado/ valor ------>" + global_prints);
}


