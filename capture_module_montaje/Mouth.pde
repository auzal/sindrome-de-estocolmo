//*************************************** A. UZAL 2015 **********************************

// REQUIRES  import java.awt.*;

class Mouth {
  float x;
  float y;
  float w;
  float h;
  Rectangle r;
  String state;

  //---------------------------------------------------------------------------------------

  Mouth() {

    state = "WAITING";
  }

  //---------------------------------------------------------------------------------------

  void update() {

    if (state.equals("NEW RECT")) {
      updateValues();
      state = "HAS RECT";
    } else if (state.equals("HAS RECT")) {
      updateValues();
      state = "HAS RECT";
    }
  }



  //---------------------------------------------------------------------------------------

  void render() {

    pushStyle();

    stroke(#5493FC,feature_alpha);

    noFill();

    strokeWeight(1);

    if (!state.equals("WAITING")) {

      rect(x, y, w, h, 10);
      line(x,y+h/3,x+w,y+h/3);
    }

    popStyle();
  }

  //---------------------------------------------------------------------------------------

  boolean passRectangle(Rectangle r_) {

    Rectangle new_rect = r_;

    boolean aux = false;

    float threshold = 10;



    r = new_rect;
    aux = true;
    state = "HAS RECT";


    return  aux;
  }

  //---------------------------------------------------------------------------------------

  void kill() {

    state = "WAITING";

    r = null;
  }

  //---------------------------------------------------------------------------------------

  void updateValues() {
    x = r.x;
    y = r.y;
    w = r.width;
    h = r.height;
  }
}

