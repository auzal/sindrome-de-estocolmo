//*************************************** A. UZAL 2015 **********************************

// REQUIRES  import java.awt.*;


class FaceNorm {

  Rectangle face;
  Rectangle l_eye;
  Rectangle r_eye;
  Rectangle mouth;
  Rectangle nose;
  Rectangle face_map;
  Rectangle l_eye_map;
  Rectangle r_eye_map;
  Rectangle mouth_map;
  Rectangle nose_map;

  String id;

  PImage img;
  PImage img_crop;
  PImage img_face;
  boolean has_nose;
  boolean has_mouth;
  int image_width;

  PGraphics g;

  String [] charges;

  //---------------------------------------------------------------------------------------

  FaceNorm(PImage img_) {

    img = img_;
    face = l_eye = r_eye = mouth = nose = null;
    has_nose = has_mouth = false;
    image_width  = 300;
    id = "unnamed";
    charges = new String[0];
  }

  //---------------------------------------------------------------------------------------

  void setMainRects(Rectangle f, Rectangle l, Rectangle r) {

    face = f;
    l_eye = l;
    r_eye = r;
  }

  //---------------------------------------------------------------------------------------

  void setMouth(Rectangle r) {

    mouth = r;
    has_mouth = true;
  }

  //---------------------------------------------------------------------------------------

  void setNose(Rectangle r) {

    nose = r;
    has_nose = true;
  }

  //---------------------------------------------------------------------------------------

  void normalizeFace() {

    //--------------------- IMAGES--------------------------------

    float width_factor = 0.4;

    float height_factor = 0.4;

    img_crop = createImage(face.width, face.height, RGB);

    img_crop.copy(img, face.x, face.y, face.width, face.height, 0, 0, img_crop.width, img_crop.height);

    int x_copy = int(face.x - (face.width * width_factor)/2 );

    x_copy = constrain(x_copy, 0, face.x);

    int y_copy = int(face.y - (face.height * height_factor)/2 );

    y_copy = constrain(y_copy, 0, face.y);

    int width_copy = int(face.width + (face.width *  width_factor));

    width_copy = constrain(width_copy, 0, img.width - x_copy);

    int height_copy = int(face.height + (face.height *  height_factor));

    height_copy = constrain(height_copy, 0, img.height - y_copy);

    int side_copy = min(width_copy, height_copy);

    img_face = createImage(side_copy, side_copy, RGB);

    img_face.copy(img, x_copy, y_copy, side_copy, side_copy, 0, 0, img_face.width, img_face.height);

    img_face.resize(image_width, 0);

    img_crop.resize(image_width, 0);

    suspect_index  ++;

    //--------------------- RECTANGLES--------------------------------


    float factor = img_crop.width*1.0/face.width;

    face_map  = mapRectangle(face.x, face.y, face, factor);

    l_eye_map  = mapRectangle(face.x, face.y, l_eye, factor);

    r_eye_map  = mapRectangle(face.x, face.y, r_eye, factor);

    if (has_nose) {

      if (nose!=null)

        nose_map  = mapRectangle(face.x, face.y, nose, factor);
        
      else
        has_nose = false;
    }

    if (has_mouth) {

      if (mouth!=null)

        mouth_map  = mapRectangle(face.x, face.y, mouth, factor);
        
     else
       has_mouth = false;
    }

    generateRefImage();
  }

  //---------------------------------------------------------------------------------------


  Rectangle mapRectangle(float or_x, float or_y, Rectangle or, float factor ) {

    int x_new_rect = int((or.x - or_x) * factor);

    int y_new_rect = int((or.y - or_y) * factor);

    int new_rect_width = int(or.width * factor);

    int new_rect_height = int(or.height * factor);

    Rectangle aux = new Rectangle(x_new_rect, y_new_rect, new_rect_width, new_rect_height);

    return aux;
  }

  //---------------------------------------------------------------------------------------

  /*
    
   void NormalizeRectangle( Rectangle or, float width_bound ) {
   
   
   
   float x_new_rect = map(or.x, 0, width_bound, 0, 1);
   
   float y_new_rect = map(or.y, 0, width_bound, 0, 1);
   
   float new_rect_width = map(or.width, 0, width_bound, 0, 1);
   
   float new_rect_height = map(or.height, 0, width_bound, 0, 1);
   
   Rectangle aux = new Rectangle(x_new_rect, y_new_rect, new_rect_width, new_rect_height);
   
   return aux;
   } */

  //---------------------------------------------------------------------------------------

  void setId(String s) {

    id = s;
  }

  //---------------------------------------------------------------------------------------

  void setCharges(String[] s) {

    charges = s;
  }

  //---------------------------------------------------------------------------------------

  void generateRefImage() {

    g = createGraphics(img_crop.width, img_crop.height);

    g.beginDraw();

    g.image(img_crop, 0, 0);

    g.noFill();

    g.strokeWeight(2);

    g.stroke(255, 0, 0);

    g.rect(face_map.x, face_map.y, face_map.width, face_map.height);

    g.rect(l_eye_map.x, l_eye_map.y, l_eye_map.width, l_eye_map.height);

    g.rect(r_eye_map.x, r_eye_map.y, r_eye_map.width, r_eye_map.height);

    if (has_nose) {

      if (nose_map!=null)
        g.rect(nose_map.x, nose_map.y, nose_map.width, nose_map.height);
    }

    if (has_mouth) {

      if (mouth_map!=null)

        g.rect(mouth_map.x, mouth_map.y, mouth_map.width, mouth_map.height);
    }

    g.endDraw();
  }

  //---------------------------------------------------------------------------------------

  void saveXml() {



    String[] out = new String[] {
      "<xml>"
    };


    String line = "<face id=\""+id+"\" >";
    out = append(out, line);

    line = generateXMLRect(face_map, "face_map");
    out = append(out, line);
    line = generateXMLRect(l_eye_map, "l_eye_map");
    out = append(out, line);
    line = generateXMLRect(r_eye_map, "r_eye_map");
    out = append(out, line);

    if (has_mouth && mouth_map != null) {

      line = generateXMLRect(mouth_map, "mouth_map");
      out = append(out, line);
    }

    if (has_nose && nose_map != null) {

      line = generateXMLRect(nose_map, "nose_map");
      out = append(out, line);
    }


    line = "</face>";
    out = append(out, line);

    line = "<charges>";
    out = append(out, line);

    for (int i = 0; i < charges.length; i++ ) {

      line = "<charge>" + charges[i] + "</charge>";
      out = append(out, line);
    }

    line = "</charges>";
    out = append(out, line);


    line = "</xml>";
    out = append(out, line);

    String path = DIRPATH + "suspects/" + suspect_index + "/face.xml";

    saveStrings(path, out);

    println("facialdata guardada -----> face.xml");
  }

  //---------------------------------------------------------------------------------------

  void render(int dx, int dy, color t) {

    pushMatrix();

    pushStyle();

    translate(dx, dy);

    tint(t);

    PImage dith = createImage(img_crop.width, img_crop.height, RGB);

    dith.copy(img_crop, 0, 0, img_crop.width, img_crop.height, 0, 0, img_crop.width, img_crop.height);

    dith = floydSteinberg(dith);

    image(dith, 0, 0);

    // image(img_crop, 0, 0);

    noTint();

    noFill();

    strokeWeight(2);

    stroke(#02B9AF);

    rect(face_map.x, face_map.y, face_map.width, face_map.height);

    rect(l_eye_map.x, l_eye_map.y, l_eye_map.width, l_eye_map.height);

    rect(r_eye_map.x, r_eye_map.y, r_eye_map.width, r_eye_map.height);

    if (has_nose) {

      if (nose_map!=null)
        rect(nose_map.x, nose_map.y, nose_map.width, nose_map.height);
    }

    if (has_mouth) {

      if (mouth_map!=null)

        rect(mouth_map.x, mouth_map.y, mouth_map.width, mouth_map.height);
    }

    popStyle();

    popMatrix();
  }


  //---------------------------------------------------------------------------------------

  void renderStylized(int dx, int dy, color t) {

    pushStyle();

/*    stroke(255);
    fill(0);
    rect(-330, -70, 300, 300);
    fill(255);
    text("has nose: " + has_nose, -325, -55);
    text("nose_map: " + nose_map, -325, -40);
    text("has mouth: " + has_mouth, -325, -25);
    text("mouth_map: " + mouth_map, -325, -10);*/
   


    pushMatrix();




    translate(dx, dy);

    //   tint(t);

    PImage dith = createImage(img_crop.width, img_crop.height, RGB);

    dith.copy(img_crop, 0, 0, img_crop.width, img_crop.height, 0, 0, img_crop.width, img_crop.height);

    dith = floydSteinberg(dith);
    
    stroke(255);
    strokeWeight(4);
    rect(0,0,dith.width,dith.height);

    image(dith, 0, 0);


    // image(img_crop, 0, 0);

    noTint();

    noFill();

    color croma = color(#02B9AF);

    int feature_stroke = 2;

    int node_diam = 10;

    strokeWeight( feature_stroke);

    stroke(croma);

    // +++++++++++++++++++++++++++++++++ PARA TODOS ++++++++++++++++++++++++++++++++++++++++++

    line(l_eye_map.x, l_eye_map.y + l_eye_map.height/2, l_eye_map.x + l_eye_map.width/2, l_eye_map.y);

    line(l_eye_map.x  + l_eye_map.width/2, l_eye_map.y, l_eye_map.x + l_eye_map.width, l_eye_map.y +  l_eye_map.height/2);

    line(l_eye_map.x, l_eye_map.y + l_eye_map.height/2, l_eye_map.x + l_eye_map.width, l_eye_map.y + l_eye_map.height/2);


    line(r_eye_map.x, r_eye_map.y + r_eye_map.height/2, r_eye_map.x + r_eye_map.width/2, r_eye_map.y);

    line(r_eye_map.x  + r_eye_map.width/2, r_eye_map.y, r_eye_map.x + r_eye_map.width, r_eye_map.y +  r_eye_map.height/2);

    line(r_eye_map.x, r_eye_map.y + r_eye_map.height/2, r_eye_map.x + r_eye_map.width, r_eye_map.y + r_eye_map.height/2);


    line(l_eye_map.x  + l_eye_map.width, l_eye_map.y + l_eye_map.height/2, r_eye_map.x, r_eye_map.y + r_eye_map.height/2);

    line(l_eye_map.x  + l_eye_map.width/2, l_eye_map.y, r_eye_map.x  + r_eye_map.width/2, r_eye_map.y   );


    noStroke();
    fill(croma);

    ellipse(l_eye_map.x, l_eye_map.y + l_eye_map.height/2, node_diam, node_diam);
    ellipse(l_eye_map.x + l_eye_map.width/2, l_eye_map.y, node_diam, node_diam);
    ellipse(l_eye_map.x + l_eye_map.width, l_eye_map.y +  l_eye_map.height/2, node_diam, node_diam);
    ellipse(r_eye_map.x, r_eye_map.y + r_eye_map.height/2, node_diam, node_diam);
    ellipse(r_eye_map.x + r_eye_map.width/2, r_eye_map.y, node_diam, node_diam);
    ellipse(r_eye_map.x + r_eye_map.width, r_eye_map.y +  r_eye_map.height/2, node_diam, node_diam);

    noFill();




    if (has_nose && nose_map!=null && has_mouth && mouth_map!=null) {  // SI ESTA COMPLETO

      stroke(croma);

      line(l_eye_map.x + l_eye_map.width, l_eye_map.y + l_eye_map.height/2, nose_map.x + nose_map.width/2, nose_map.y + nose_map.height);

      line(l_eye_map.x, l_eye_map.y + l_eye_map.height/2, nose_map.x + nose_map.width/2, nose_map.y + nose_map.height);

      line(l_eye_map.x, l_eye_map.y + l_eye_map.height/2, mouth_map.x, mouth_map.y + mouth_map.height/2);

      line( mouth_map.x, mouth_map.y + mouth_map.height/2, mouth_map.x + mouth_map.width/2, mouth_map.y + mouth_map.height);

      line( nose_map.x, nose_map.y + nose_map.height*.8, nose_map.x + nose_map.width/2, nose_map.y + nose_map.height);

      line( nose_map.x, nose_map.y + nose_map.height*.8, mouth_map.x + mouth_map.width/2, mouth_map.y + mouth_map.height);



      line(r_eye_map.x, r_eye_map.y + r_eye_map.height/2, nose_map.x + nose_map.width/2, nose_map.y + nose_map.height);

      line(r_eye_map.x + r_eye_map.width, r_eye_map.y + r_eye_map.height/2, nose_map.x + nose_map.width/2, nose_map.y + nose_map.height);

      line(r_eye_map.x + r_eye_map.width, r_eye_map.y + r_eye_map.height/2, mouth_map.x + mouth_map.width, mouth_map.y + mouth_map.height/2);

      line( mouth_map.x + mouth_map.width, mouth_map.y + mouth_map.height/2, mouth_map.x + mouth_map.width/2, mouth_map.y + mouth_map.height);

      line( nose_map.x + nose_map.width, nose_map.y + nose_map.height*.8, nose_map.x + nose_map.width/2, nose_map.y + nose_map.height);

      line( nose_map.x + nose_map.width, nose_map.y + nose_map.height*.8, mouth_map.x + mouth_map.width/2, mouth_map.y + mouth_map.height);

      noStroke();
      fill(croma);

      ellipse(mouth_map.x, mouth_map.y + mouth_map.height/2, node_diam, node_diam);
      ellipse(mouth_map.x + mouth_map.width, mouth_map.y + mouth_map.height/2, node_diam, node_diam);
      ellipse(mouth_map.x + mouth_map.width/2, mouth_map.y + mouth_map.height, node_diam, node_diam);
      ellipse( nose_map.x + nose_map.width/2, nose_map.y + nose_map.height, node_diam, node_diam);
      ellipse( nose_map.x, nose_map.y + nose_map.height*.8, node_diam, node_diam);
      ellipse( nose_map.x + nose_map.width, nose_map.y + nose_map.height*.8, node_diam, node_diam);


      noFill();
    } 
    if (has_nose && nose_map!=null && has_mouth == false ) {  // SI SOLO NARIZ 


      stroke(croma);

      line(l_eye_map.x + l_eye_map.width, l_eye_map.y + l_eye_map.height/2, nose_map.x + nose_map.width/2, nose_map.y + nose_map.height);

      line(l_eye_map.x, l_eye_map.y + l_eye_map.height/2, nose_map.x + nose_map.width/2, nose_map.y + nose_map.height);

      line( nose_map.x, nose_map.y + nose_map.height*.8, nose_map.x + nose_map.width/2, nose_map.y + nose_map.height);




      line(r_eye_map.x, r_eye_map.y + r_eye_map.height/2, nose_map.x + nose_map.width/2, nose_map.y + nose_map.height);

      line(r_eye_map.x + r_eye_map.width, r_eye_map.y + r_eye_map.height/2, nose_map.x + nose_map.width/2, nose_map.y + nose_map.height);

      line( nose_map.x + nose_map.width, nose_map.y + nose_map.height*.8, nose_map.x + nose_map.width/2, nose_map.y + nose_map.height);


      noStroke();
      fill(croma);

      ellipse( nose_map.x + nose_map.width/2, nose_map.y + nose_map.height, node_diam, node_diam);
      ellipse( nose_map.x, nose_map.y + nose_map.height*.8, node_diam, node_diam);
      ellipse( nose_map.x + nose_map.width, nose_map.y + nose_map.height*.8, node_diam, node_diam);


      noFill();
    } 
    if (has_mouth && mouth_map!=null && has_nose == false ) {  // SI SOLO BOCA

      println("nose"   + has_nose);
      println("mouth" +has_mouth);

      stroke(croma);



      line(l_eye_map.x, l_eye_map.y + l_eye_map.height/2, mouth_map.x, mouth_map.y + mouth_map.height/2);

      line( mouth_map.x, mouth_map.y + mouth_map.height/2, mouth_map.x + mouth_map.width/2, mouth_map.y + mouth_map.height);

      line( mouth_map.x, mouth_map.y + mouth_map.height/2, mouth_map.x + mouth_map.width/2, mouth_map.y);

      line(l_eye_map.x, l_eye_map.y + l_eye_map.height/2, l_eye_map.x + l_eye_map.width/2, l_eye_map.y + l_eye_map.height);

      line(l_eye_map.x + l_eye_map.width, l_eye_map.y + l_eye_map.height/2, l_eye_map.x + l_eye_map.width/2, l_eye_map.y + l_eye_map.height);



      line(r_eye_map.x + r_eye_map.width, r_eye_map.y + r_eye_map.height/2, mouth_map.x + mouth_map.width, mouth_map.y + mouth_map.height/2);

      line( mouth_map.x + mouth_map.width, mouth_map.y + mouth_map.height/2, mouth_map.x + mouth_map.width/2, mouth_map.y + mouth_map.height);

      line( mouth_map.x + mouth_map.width, mouth_map.y + mouth_map.height/2, mouth_map.x + mouth_map.width/2, mouth_map.y );

      line(r_eye_map.x, r_eye_map.y + r_eye_map.height/2, r_eye_map.x + r_eye_map.width/2, r_eye_map.y + r_eye_map.height);

      line(r_eye_map.x + r_eye_map.width, r_eye_map.y + r_eye_map.height/2, r_eye_map.x + r_eye_map.width/2, r_eye_map.y + r_eye_map.height);



      noStroke();
      fill(croma);

      ellipse(mouth_map.x, mouth_map.y + mouth_map.height/2, node_diam, node_diam);
      ellipse(mouth_map.x + mouth_map.width, mouth_map.y + mouth_map.height/2, node_diam, node_diam);
      ellipse(mouth_map.x + mouth_map.width/2, mouth_map.y + mouth_map.height, node_diam, node_diam);
      ellipse( mouth_map.x + mouth_map.width/2, mouth_map.y, node_diam, node_diam);
      ellipse( r_eye_map.x + r_eye_map.width/2, r_eye_map.y + r_eye_map.height, node_diam, node_diam);
      ellipse( l_eye_map.x + l_eye_map.width/2, l_eye_map.y + l_eye_map.height, node_diam, node_diam);


      noFill();
    }
    if ((has_mouth == false) && (has_nose == false) ) {  // SI SOLO OJOS

      stroke(croma);


      line(l_eye_map.x, l_eye_map.y + l_eye_map.height/2, l_eye_map.x + l_eye_map.width/2, l_eye_map.y + l_eye_map.height);

      line(l_eye_map.x + l_eye_map.width, l_eye_map.y + l_eye_map.height/2, l_eye_map.x + l_eye_map.width/2, l_eye_map.y + l_eye_map.height);


      line(r_eye_map.x, r_eye_map.y + r_eye_map.height/2, r_eye_map.x + r_eye_map.width/2, r_eye_map.y + r_eye_map.height);

      line(r_eye_map.x + r_eye_map.width, r_eye_map.y + r_eye_map.height/2, r_eye_map.x + r_eye_map.width/2, r_eye_map.y + r_eye_map.height);


      noStroke();
      fill(croma);


      ellipse( r_eye_map.x + r_eye_map.width/2, r_eye_map.y + r_eye_map.height, node_diam, node_diam);
      ellipse( l_eye_map.x + l_eye_map.width/2, l_eye_map.y + l_eye_map.height, node_diam, node_diam);


      noFill();
    }

    stroke(0, 200);

/*    rect(face_map.x, face_map.y, face_map.width, face_map.height);

    rect(l_eye_map.x, l_eye_map.y, l_eye_map.width, l_eye_map.height);

    rect(r_eye_map.x, r_eye_map.y, r_eye_map.width, r_eye_map.height);

    if (has_nose) {

      if (nose_map!=null)
        rect(nose_map.x, nose_map.y, nose_map.width, nose_map.height);
    }

    if (has_mouth) {

      if (mouth_map!=null)

        rect(mouth_map.x, mouth_map.y, mouth_map.width, mouth_map.height);
    }*/

    popStyle();

    popMatrix();
  }


  //---------------------------------------------------------------------------------------
  
    void renderDataStylized(int dx, int dy, color t) {

    pushStyle();

/*    stroke(255);
    fill(0);
    rect(-330, -70, 300, 300);
    fill(255);
    text("has nose: " + has_nose, -325, -55);
    text("nose_map: " + nose_map, -325, -40);
    text("has mouth: " + has_mouth, -325, -25);
    text("mouth_map: " + mouth_map, -325, -10);*/
   


    pushMatrix();




    translate(dx, dy);

    //   tint(t);

  
    
    stroke(255);
    strokeWeight(4);
   // rect(0,0,face_map.width,face_map.height);

 //   image(dith, 0, 0);


    // image(img_crop, 0, 0);

    noTint();

    noFill();

    color croma = color(#02B9AF);

    int feature_stroke = 2;

    int node_diam = 10;

    strokeWeight( feature_stroke);

    stroke(croma);

    // +++++++++++++++++++++++++++++++++ PARA TODOS ++++++++++++++++++++++++++++++++++++++++++

    line(l_eye_map.x, l_eye_map.y + l_eye_map.height/2, l_eye_map.x + l_eye_map.width/2, l_eye_map.y);

    line(l_eye_map.x  + l_eye_map.width/2, l_eye_map.y, l_eye_map.x + l_eye_map.width, l_eye_map.y +  l_eye_map.height/2);

    line(l_eye_map.x, l_eye_map.y + l_eye_map.height/2, l_eye_map.x + l_eye_map.width, l_eye_map.y + l_eye_map.height/2);


    line(r_eye_map.x, r_eye_map.y + r_eye_map.height/2, r_eye_map.x + r_eye_map.width/2, r_eye_map.y);

    line(r_eye_map.x  + r_eye_map.width/2, r_eye_map.y, r_eye_map.x + r_eye_map.width, r_eye_map.y +  r_eye_map.height/2);

    line(r_eye_map.x, r_eye_map.y + r_eye_map.height/2, r_eye_map.x + r_eye_map.width, r_eye_map.y + r_eye_map.height/2);


    line(l_eye_map.x  + l_eye_map.width, l_eye_map.y + l_eye_map.height/2, r_eye_map.x, r_eye_map.y + r_eye_map.height/2);

    line(l_eye_map.x  + l_eye_map.width/2, l_eye_map.y, r_eye_map.x  + r_eye_map.width/2, r_eye_map.y   );


    noStroke();
    fill(croma);

    ellipse(l_eye_map.x, l_eye_map.y + l_eye_map.height/2, node_diam, node_diam);
    ellipse(l_eye_map.x + l_eye_map.width/2, l_eye_map.y, node_diam, node_diam);
    ellipse(l_eye_map.x + l_eye_map.width, l_eye_map.y +  l_eye_map.height/2, node_diam, node_diam);
    ellipse(r_eye_map.x, r_eye_map.y + r_eye_map.height/2, node_diam, node_diam);
    ellipse(r_eye_map.x + r_eye_map.width/2, r_eye_map.y, node_diam, node_diam);
    ellipse(r_eye_map.x + r_eye_map.width, r_eye_map.y +  r_eye_map.height/2, node_diam, node_diam);

    noFill();




    if (has_nose && nose_map!=null && has_mouth && mouth_map!=null) {  // SI ESTA COMPLETO

      stroke(croma);

      line(l_eye_map.x + l_eye_map.width, l_eye_map.y + l_eye_map.height/2, nose_map.x + nose_map.width/2, nose_map.y + nose_map.height);

      line(l_eye_map.x, l_eye_map.y + l_eye_map.height/2, nose_map.x + nose_map.width/2, nose_map.y + nose_map.height);

      line(l_eye_map.x, l_eye_map.y + l_eye_map.height/2, mouth_map.x, mouth_map.y + mouth_map.height/2);

      line( mouth_map.x, mouth_map.y + mouth_map.height/2, mouth_map.x + mouth_map.width/2, mouth_map.y + mouth_map.height);

      line( nose_map.x, nose_map.y + nose_map.height*.8, nose_map.x + nose_map.width/2, nose_map.y + nose_map.height);

      line( nose_map.x, nose_map.y + nose_map.height*.8, mouth_map.x + mouth_map.width/2, mouth_map.y + mouth_map.height);



      line(r_eye_map.x, r_eye_map.y + r_eye_map.height/2, nose_map.x + nose_map.width/2, nose_map.y + nose_map.height);

      line(r_eye_map.x + r_eye_map.width, r_eye_map.y + r_eye_map.height/2, nose_map.x + nose_map.width/2, nose_map.y + nose_map.height);

      line(r_eye_map.x + r_eye_map.width, r_eye_map.y + r_eye_map.height/2, mouth_map.x + mouth_map.width, mouth_map.y + mouth_map.height/2);

      line( mouth_map.x + mouth_map.width, mouth_map.y + mouth_map.height/2, mouth_map.x + mouth_map.width/2, mouth_map.y + mouth_map.height);

      line( nose_map.x + nose_map.width, nose_map.y + nose_map.height*.8, nose_map.x + nose_map.width/2, nose_map.y + nose_map.height);

      line( nose_map.x + nose_map.width, nose_map.y + nose_map.height*.8, mouth_map.x + mouth_map.width/2, mouth_map.y + mouth_map.height);

      noStroke();
      fill(croma);

      ellipse(mouth_map.x, mouth_map.y + mouth_map.height/2, node_diam, node_diam);
      ellipse(mouth_map.x + mouth_map.width, mouth_map.y + mouth_map.height/2, node_diam, node_diam);
      ellipse(mouth_map.x + mouth_map.width/2, mouth_map.y + mouth_map.height, node_diam, node_diam);
      ellipse( nose_map.x + nose_map.width/2, nose_map.y + nose_map.height, node_diam, node_diam);
      ellipse( nose_map.x, nose_map.y + nose_map.height*.8, node_diam, node_diam);
      ellipse( nose_map.x + nose_map.width, nose_map.y + nose_map.height*.8, node_diam, node_diam);


      noFill();
    } 
    if (has_nose && nose_map!=null && has_mouth == false ) {  // SI SOLO NARIZ 


      stroke(croma);

      line(l_eye_map.x + l_eye_map.width, l_eye_map.y + l_eye_map.height/2, nose_map.x + nose_map.width/2, nose_map.y + nose_map.height);

      line(l_eye_map.x, l_eye_map.y + l_eye_map.height/2, nose_map.x + nose_map.width/2, nose_map.y + nose_map.height);

      line( nose_map.x, nose_map.y + nose_map.height*.8, nose_map.x + nose_map.width/2, nose_map.y + nose_map.height);




      line(r_eye_map.x, r_eye_map.y + r_eye_map.height/2, nose_map.x + nose_map.width/2, nose_map.y + nose_map.height);

      line(r_eye_map.x + r_eye_map.width, r_eye_map.y + r_eye_map.height/2, nose_map.x + nose_map.width/2, nose_map.y + nose_map.height);

      line( nose_map.x + nose_map.width, nose_map.y + nose_map.height*.8, nose_map.x + nose_map.width/2, nose_map.y + nose_map.height);


      noStroke();
      fill(croma);

      ellipse( nose_map.x + nose_map.width/2, nose_map.y + nose_map.height, node_diam, node_diam);
      ellipse( nose_map.x, nose_map.y + nose_map.height*.8, node_diam, node_diam);
      ellipse( nose_map.x + nose_map.width, nose_map.y + nose_map.height*.8, node_diam, node_diam);


      noFill();
    } 
    if (has_mouth && mouth_map!=null && has_nose == false ) {  // SI SOLO BOCA

      println("nose"   + has_nose);
      println("mouth" +has_mouth);

      stroke(croma);



      line(l_eye_map.x, l_eye_map.y + l_eye_map.height/2, mouth_map.x, mouth_map.y + mouth_map.height/2);

      line( mouth_map.x, mouth_map.y + mouth_map.height/2, mouth_map.x + mouth_map.width/2, mouth_map.y + mouth_map.height);

      line( mouth_map.x, mouth_map.y + mouth_map.height/2, mouth_map.x + mouth_map.width/2, mouth_map.y);

      line(l_eye_map.x, l_eye_map.y + l_eye_map.height/2, l_eye_map.x + l_eye_map.width/2, l_eye_map.y + l_eye_map.height);

      line(l_eye_map.x + l_eye_map.width, l_eye_map.y + l_eye_map.height/2, l_eye_map.x + l_eye_map.width/2, l_eye_map.y + l_eye_map.height);



      line(r_eye_map.x + r_eye_map.width, r_eye_map.y + r_eye_map.height/2, mouth_map.x + mouth_map.width, mouth_map.y + mouth_map.height/2);

      line( mouth_map.x + mouth_map.width, mouth_map.y + mouth_map.height/2, mouth_map.x + mouth_map.width/2, mouth_map.y + mouth_map.height);

      line( mouth_map.x + mouth_map.width, mouth_map.y + mouth_map.height/2, mouth_map.x + mouth_map.width/2, mouth_map.y );

      line(r_eye_map.x, r_eye_map.y + r_eye_map.height/2, r_eye_map.x + r_eye_map.width/2, r_eye_map.y + r_eye_map.height);

      line(r_eye_map.x + r_eye_map.width, r_eye_map.y + r_eye_map.height/2, r_eye_map.x + r_eye_map.width/2, r_eye_map.y + r_eye_map.height);



      noStroke();
      fill(croma);

      ellipse(mouth_map.x, mouth_map.y + mouth_map.height/2, node_diam, node_diam);
      ellipse(mouth_map.x + mouth_map.width, mouth_map.y + mouth_map.height/2, node_diam, node_diam);
      ellipse(mouth_map.x + mouth_map.width/2, mouth_map.y + mouth_map.height, node_diam, node_diam);
      ellipse( mouth_map.x + mouth_map.width/2, mouth_map.y, node_diam, node_diam);
      ellipse( r_eye_map.x + r_eye_map.width/2, r_eye_map.y + r_eye_map.height, node_diam, node_diam);
      ellipse( l_eye_map.x + l_eye_map.width/2, l_eye_map.y + l_eye_map.height, node_diam, node_diam);


      noFill();
    }
    if ((has_mouth == false) && (has_nose == false) ) {  // SI SOLO OJOS

      stroke(croma);


      line(l_eye_map.x, l_eye_map.y + l_eye_map.height/2, l_eye_map.x + l_eye_map.width/2, l_eye_map.y + l_eye_map.height);

      line(l_eye_map.x + l_eye_map.width, l_eye_map.y + l_eye_map.height/2, l_eye_map.x + l_eye_map.width/2, l_eye_map.y + l_eye_map.height);


      line(r_eye_map.x, r_eye_map.y + r_eye_map.height/2, r_eye_map.x + r_eye_map.width/2, r_eye_map.y + r_eye_map.height);

      line(r_eye_map.x + r_eye_map.width, r_eye_map.y + r_eye_map.height/2, r_eye_map.x + r_eye_map.width/2, r_eye_map.y + r_eye_map.height);


      noStroke();
      fill(croma);


      ellipse( r_eye_map.x + r_eye_map.width/2, r_eye_map.y + r_eye_map.height, node_diam, node_diam);
      ellipse( l_eye_map.x + l_eye_map.width/2, l_eye_map.y + l_eye_map.height, node_diam, node_diam);


      noFill();
    }

    stroke(0, 200);


    popStyle();

    popMatrix();
  }
  
  //---------------------------------------------------------------------------------------
  
    void renderDithCrop(int dx, int dy, color t) {

    pushStyle();

    pushMatrix();

    translate(dx, dy);

    //   tint(t);

    PImage dith = createImage(img_crop.width, img_crop.height, RGB);

    dith.copy(img_crop, 0, 0, img_crop.width, img_crop.height, 0, 0, img_crop.width, img_crop.height);

    dith = floydSteinberg(dith);
    
    stroke(255);
    strokeWeight(4);
    rect(0,0,dith.width,dith.height);

    image(dith, 0, 0);


    popStyle();

    popMatrix();
  }



  //---------------------------------------------------------------------------------------

  void saveImages() {

    String path = DIRPATH + "suspects/" + suspect_index + "/faceBound.jpg";

    img_face.save(path);

    println("imagen guardada --> faceBound");

    path = DIRPATH + "suspects/" + suspect_index + "/faceCrop.jpg";

    img_crop.save(path);

    println("imagen guardada ---> faceCrop");

    path = DIRPATH + "suspects/" + suspect_index + "/faceData.jpg";

    g.beginDraw();

    g.save(path);

    g.endDraw();

    println("imagen guardada ----> faceData");
  }




  //---------------------------------------------------------------------------------------

  String generateXMLRect(Rectangle r, String id) {


    String line = "<" + id + " x=\"" + r.x + "\""  + " y=\"" + r.y + "\"" + " w=\"" + r.width + "\""+ " h=\"" + r.height + "\"" +  "> </" + id +">";

    return line;
  }
}

