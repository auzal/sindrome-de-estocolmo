//*************************************** A. UZAL 2015 **********************************

// REQUIRES  import java.awt.*;


class FaceNormCompact {


  Rectangle face_map;
  Rectangle l_eye_map;
  Rectangle r_eye_map;
  Rectangle mouth_map;
  Rectangle nose_map;

  String id;

  PImage img_crop;
  PImage img_face;

  PImage img_dith;

  boolean has_nose;
  boolean has_mouth;
  int image_width;
  
  String [] charges;

  //---------------------------------------------------------------------------------------

  FaceNormCompact() {

    face_map = l_eye_map = r_eye_map = mouth_map = nose_map = null;
    has_nose = has_mouth = false;
    image_width  = 300;
    id = "unnamed";
    charges = new String[0];
  }

  //---------------------------------------------------------------------------------------

  void setMainRects(Rectangle f, Rectangle l, Rectangle r) {

    face_map = f;
    l_eye_map = l;
    r_eye_map = r;
  }

  //---------------------------------------------------------------------------------------

  void setMouth(Rectangle r) {

    mouth_map = r;
    has_mouth = true;
  }

  //---------------------------------------------------------------------------------------

  void setNose(Rectangle r) {

    nose_map = r;
    has_nose = true;
  }

  //---------------------------------------------------------------------------------------

  void renderDataAux() {


    // ---------------------- RESULTADO GRAFICADO ------------------------- // 

    PGraphics g = createGraphics(img_crop.width, img_crop.height);

    g.beginDraw();

    g.image(img_crop, 0, 0);

    g.noFill();

    g.strokeWeight( 2);

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

    //   path = DIRPATH + "suspects/" + suspect_index + "/faceData.jpg";
  
    //    g.save(path);

    //    ("imagen guardada ----> faceData");
  }

  //---------------------------------------------------------------------------------------

  void setId(String s) {

    id = s;
  }

  //---------------------------------------------------------------------------------------

  void setImages(PImage f, PImage c) {

    img_face = f;

    img_crop = c;

    img_dith = createImage(img_face.width, img_face.height, RGB);

    img_dith.copy(img_face, 0, 0, img_face.width, img_face.height, 0, 0, img_dith.width, img_dith.height);

    img_dith =  floydSteinberg(img_dith);
  }

  //---------------------------------------------------------------------------------------

  void render(int dx, int dy, color t) {

    pushMatrix();

    pushStyle();

    translate(dx, dy);

    tint(t);


    image(img_crop, 0, 0);

    noTint();

    noFill();

    strokeWeight( 2);

    stroke(#CE7C00);

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

    color croma = color(#FA8303,200);

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
  
  //--------------------------------------------------------------------------
  
    void renderData() {

    pushMatrix();

    pushStyle();

   // translate(dx, dy);

 //   tint(t);

   // image(img_crop, 0, 0);

 //   noTint();

    noFill();

    strokeWeight( 2);

   stroke(#CE7C00);

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
}

