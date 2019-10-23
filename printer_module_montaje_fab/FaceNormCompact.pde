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
  PImage thumb;

  boolean has_nose;
  boolean has_mouth;
  int image_width;

  String [] charges;

  int print_count;


  //---------------------------------------------------------------------------------------

  FaceNormCompact() {

    face_map = l_eye_map = r_eye_map = mouth_map = nose_map = null;
    has_nose = has_mouth = false;
    image_width  = 300;
    id = "unnamed";
    charges = new String[0];
    print_count = 0;
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

    //   path = "../../repo/suspects/" + suspect_index + "/faceData.jpg";

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

  //  img_dith = createImage(img_face.width, img_face.height, RGB);

  //  img_dith.copy(img_face, 0, 0, img_face.width, img_face.height, 0, 0, img_dith.width, img_dith.height);

   // img_dith =  floydSteinberg(img_dith);

    thumb = createImage( THUMB_SIZE, THUMB_SIZE, RGB );

    thumb.copy(img_face, 0, 0, img_face.width, img_face.height, 0, 0, thumb.width, thumb.height);

    thumb =  floydSteinberg(thumb);
  }

  //---------------------------------------------------------------------------------------

  void render(int dx, int dy) {

    pushMatrix();

    translate(dx, dy);

    image(img_crop, 0, 0);

    noFill();

    strokeWeight(2);

    stroke(stroke_c);

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

    popMatrix();
  }


  //--------------------------------------------------------------------------------------

  void addPrint() {

    print_count ++ ;
  }
}

