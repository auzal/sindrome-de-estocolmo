void loadCriminals() {
  for (int i = 0; i < ammount_criminals ; i++ ) {

    String path = DIRPATH + "criminals/" + (i+1) + "/" ;

    FaceNormCompact aux = loadFace(path);

    if (aux!=null) {
      
      

      c.add(aux);
      println(c.get(i).charges);
    }
  }

  println(c.size() + " criminales cargados con exito/");
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
    
   // println(charges_xml);

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

void  loadAmmountCriminals() {

  XML xml;
  String path = DIRPATH + "criminals/index.xml";
  println("PATH ="  + path);
  xml = loadXML(path);

  XML[] children = xml.getChildren("index");

  int aux = 0;

  for (int i = 0; i < children.length; i++) {
    aux = children[i].getInt("val");
  }

  ammount_criminals = aux;

  println("XML cargado -> ../../repo/criminals/index.xml");
  println("valor de indice actualizado : " + ammount_criminals);
}
