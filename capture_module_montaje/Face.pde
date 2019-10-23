//*************************************** A. UZAL 2015 **********************************

// REQUIRES  import java.awt.*;


class Face {
  float x;
  float y;
  float w;
  float h;
  Rectangle r;
  String state;
  Eye left;
  Eye right;
  Nose nose;
  Mouth mouth;

  boolean has_nose;
  boolean has_mouth;

  boolean shoot;

  int frames_detected;

  //---------------------------------------------------------------------------------------

  Face() {

    state = "WAITING";
    left = new Eye();
    right = new Eye();
    nose = new Nose();
    mouth = new Mouth();

    has_mouth = false;
    has_nose = false;

    shoot = false;
    frames_detected = 0;
  }

  //---------------------------------------------------------------------------------------

  void update() {



    if (state.equals("HAS RECT")) {
      shoot = false;
      if (left.state.equals("HAS RECT") && right.state.equals("HAS RECT") ) {

        shoot = true;
      }
    } else {

      shoot = false;
    }

    if (shoot) {

      if (frames_detected < verification_frames)
        frames_detected++;

      else
        state = "HAS FACE";
    }

    // println(shoot);

    if (state.equals("NEW RECT")) {
      updateValues();
      state = "HAS RECT";
    } else if (state.equals("HAS RECT")) {
      updateValues();
      state = "HAS RECT";
    }

    left.update();
    right.update();
    nose.update();
    mouth.update();

    //   println(state);
  }

  //---------------------------------------------------------------------------------------

  void render() {

    pushStyle();

    stroke(#03FCC0, feature_alpha);

    noFill();

    strokeWeight(1);

    if (!state.equals("WAITING")) {

      rect(x, y, w, h, 10);
      line(x, y+h/2, x+w, y+h/2);
      line(x+w/2, y, x+w/2, y+h);

      stroke(#03FCC0, feature_alpha/4);

      for (int i = 1; i < 8; i ++ ) {


        float val = (h/8) * i;
        line(x, y+val, x+w, y+val);
      }
    }

    popStyle();

    left.render();
    right.render();
    mouth.render();
    nose.render();
  }

  //---------------------------------------------------------------------------------------

  boolean passRectangle(Rectangle r_) {

    Rectangle new_rect = r_;

    boolean aux = false;

    float threshold = 10;

   // float min_width = 80;

    if (new_rect.width >= MIN_FACE_WIDTH) {

      if (r == null) {

        r = new_rect;
        aux = true;
        state = "NEW RECT";
      } else if ( dist(r.x, r.y, new_rect.x, new_rect.y) < threshold) {

        r = new_rect;
        aux = true;
        state = "HAS RECT";
      } else {
        state = "WAITING";
        r = null;
        frames_detected = 0;
        kill();
      }
    }

    return  aux;
  }

  //---------------------------------------------------------------------------------------

  void kill() {

    state = "WAITING";
    frames_detected = 0;
    r = null;
    left.kill();
    right.kill();
    nose.kill();
    mouth.kill();
  }

  //---------------------------------------------------------------------------------------

  void signalEnd() {

    state = "FINISHED";
  }


  //---------------------------------------------------------------------------------------

  void setEyes(Rectangle [] e) {

    if (e != null && e.length >1 && state.equals("HAS RECT")) {

      Rectangle re = null;
      Rectangle le = null;

      for (int i = 0; i < e.length; i++) {
        if (r.contains(e[i])  && e[i].width < r.width/2) {  // si esta dentro de la cara y si es menor a la mitad de la cara
          if (e[i].y < (r.y + (r.height/2)) && e[i].y > (r.y + ((r.height/8)*1))  ) {  // si empiza antes de la mitad vertical de la cara y despues del primer octavo

            if (e[i].x < r.x + (r.width/2)) { // si empieza mas alla de la mitad horizontal de la cara
              if (e[i].x + e[i].width < r.x + ((r.width/8) * 5))  // si no termina mas alla del 5to octavo
                le = e[i];
            } else
              // aca no deberia haber problema
            re = e[i];
          }
        }
      }

      if (re != null && le != null) {

        left.passRectangle(le);
        right.passRectangle(re);
      } else {
        kill();
      }
    }
  }

  //----------------------------------------------------------------------------------------

  void setNose(Rectangle [] n) {

    if (n != null && n.length >0 ) {

      Rectangle n_ = null;


      for (int i = 0; i < n.length; i++) {
        if (r.contains(n[i])  && n[i].width < r.width/2) {  // si esta dentro de la cara, y si es de lado menor que la mitad de la cara
          if ( n[i].y + n[i].height > (r.y + (r.height/2))  && n[i].y < r.y + ((r.height/8) * 5) && n[i].y + n[i].height  < r.y + ((r.height/8) * 7 )) { // si termina despues de la mitad de la cara y si empieza antes del 5to octavo y termina antes del 7mo octavo      
            if (n[i].x < (r.x + (r.width/2)) && n[i].x + n[i].width > (r.x + (r.width/2))) { // idem

              n_ = n[i];
            }
          }
        }
      }

      if (n_ != null) {


        nose.passRectangle(n_);
        has_nose = true;
      }
    }
  }

  //----------------------------------------------------------------------------------------

  void setMouth(Rectangle [] n) {

    if (n != null && n.length >0 ) {

      Rectangle m = null;


      for (int i = 0; i < n.length; i++) {
        if ( n[i].width < r.width/2) {  //y si es de lado menor que la mitad de la cara
          if (n[i].y > (r.y+ ((r.height/8)*5))  && n[i].y < (r.y + ((r.height/16)*14))) {   // si esta de la mitad + 1 octavo de la cara para abajo (y ademas empieza antes del 13avo 16avo (UFFFFFFFFFFFFFFFFFFFF))
            if (n[i].x < (r.x + (r.width/2)) && n[i].x + n[i].width > (r.x + (r.width/2))) { // si esta mas o menos en el centro de la cara (en sentido horizontal)

              m = n[i];
            }
          }
        }
      }

      if (m != null) {

        mouth.passRectangle(m);
        has_mouth = true;
      }
    }
  }


  //---------------------------------------------------------------------------------------

  void updateValues() {
    x = r.x;
    y = r.y;
    w = r.width;
    h = r.height;
  }
}

