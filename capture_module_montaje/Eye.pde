//*************************************** A. UZAL 2015 **********************************

// REQUIRES  import java.awt.*;

class Eye {
  float x;
  float y;
  float w;
  float h;
  Rectangle r;
  String state;

  //---------------------------------------------------------------------------------------

  Eye() {

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

    stroke(#F543B4,feature_alpha);

    noFill();

    strokeWeight(1);

    if (!state.equals("WAITING")) {

      rect(x, y, w, h, 10);
      
       stroke(#F543B4,feature_alpha/3);
      
      ellipse(x+w/2,y+h/2,w*0.3,w*0.3);
      line(x+w/2-w*0.3,y+h/2,x+w/2+w*0.3,y+h/2);
    }

    popStyle();
  }

  //---------------------------------------------------------------------------------------

  boolean passRectangle(Rectangle r_) {

    Rectangle new_rect = r_;

    boolean aux = false;

    float threshold = 10;

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
    }

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

