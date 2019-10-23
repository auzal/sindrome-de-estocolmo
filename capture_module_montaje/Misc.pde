void handleVideo() {

  if (video.available() == true) {
    video.read();
    video.filter(GRAY);
    dithered_video.copy(video, 0, 0, video.width, video.height, 0, 0, dithered_video.width, dithered_video.height);
    dithered_video = floydSteinberg(dithered_video);
  }
}

//---------------------------------------------------------------------------------------

void handleFaceClass() {
  if (faces.length == 0 || faces == null) {

    f.kill();
  } else if (faces!=null) {

    for (int i = 0; i < faces.length; i++) {

      if (f.passRectangle(faces[i]))
        break;
    }
  }
}

//---------------------------------------------------------------------------------------

void handleEyes() {

  if (f!=null) {
    f.setEyes(eyes);
  }
}

//---------------------------------------------------------------------------------------

void handleFeatures() {

  if (f!=null) {
    f.setNose(noses);
    f.setMouth(mouths);
  }
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

    suspect_index = aux;

    println("XML cargado -> ../../repo//index.xml");
    println("valor de indice actualizado : " + suspect_index);
  }
}

//---------------------------------------------------------------------------------------

void saveIndex() {

  String[] out = new String[] {
    "<xml>"
  };

  String line = "<index val=\""+suspect_index+"\" ></index>";
  out = append(out, line);
  line = "</xml>";
  out = append(out, line);

  String path = DIRPATH + "suspects/index.xml";

  saveStrings(path, out);

  println("indexXML guardado/ valor ------>" + suspect_index);
}

//---------------------------------------------------------------------------------------

float compareFaces(FaceNormCompact cr, FaceNorm fa ) {

  float val = 0 ;

  float [] vals = new float[0];

  val = dist(cr.l_eye_map.x, cr.l_eye_map.y, fa.l_eye_map.x, fa.l_eye_map.y);

  vals = append(vals, val);

  val = dist(cr.l_eye_map.width, cr.l_eye_map.height, fa.l_eye_map.width, fa.l_eye_map.height);

  vals = append(vals, val);

  val = dist(cr.r_eye_map.x, cr.r_eye_map.y, fa.r_eye_map.x, fa.r_eye_map.y);

  vals = append(vals, val);

  val = dist(cr.r_eye_map.width, cr.r_eye_map.height, fa.r_eye_map.width, fa.r_eye_map.height);

  vals = append(vals, val);

  if (cr.has_nose && cr.nose_map != null && fa.has_nose && fa.nose_map != null) {

    val = dist(cr.nose_map.x, cr.nose_map.y, fa.nose_map.x, fa.nose_map.y);

    vals = append(vals, val);

    val = dist(cr.nose_map.width, cr.nose_map.height, fa.nose_map.width, fa.nose_map.height);

    vals = append(vals, val);
  }

  if (cr.has_mouth && cr.mouth_map != null && fa.has_mouth && fa.mouth_map != null) {

    val = dist(cr.mouth_map.x, cr.mouth_map.y, fa.mouth_map.x, fa.mouth_map.y);

    vals = append(vals, val);

    val = dist(cr.mouth_map.width, cr.mouth_map.height, fa.mouth_map.width, fa.mouth_map.height);

    vals = append(vals, val);
  }

  val = averageArray(vals);

  return val;
}

//---------------------------------------------------------------------------------------

float averageArray(float[] a) {

  float val = 0;

  for (int i = 0; i < a.length; i++) {

    val += a[i];
  }

  val = val/a.length;

  return val;
}

//--------------------------------------------------------------------------------------

int getMinimalValueIndex(float[] a) {

  int which = 0;



  for (int i = 1; i < a.length; i++) {

    if (a[which] > a[i] ) {

      which = i;
    }
  }

  println(which);

  return which;
}

//--------------------------------------------------------------------------------------


void positionKeys() {

  if (key == CODED) {

    if (keyCode == LEFT) {

      HOME_X -- ;
    }else if (keyCode == RIGHT) {

      HOME_X ++ ;
    }else if (keyCode == UP) {

      HOME_Y -- ;
    }else if (keyCode == DOWN) {

      HOME_Y ++ ;
    }
  }
}

