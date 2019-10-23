//---------------------------------------------------------------------------------------

void renderFeed(int x, int y) {

  pushMatrix();

  translate(x, y);

  if (state.equals("WAITING") || state.equals ("ESPERANDO DETECCION")  ||  state.equals ("ROSTRO DETECTADO. ESPERANDO CONFIRMACION")  ||  state.equals ("PERFIL ENCONTRADO") ) {

    //  translate(-2050, 0);


    noFill();
    stroke(255);
    strokeWeight(4);
    rect(0, 0, video.width, video.height);
    image(dithered_video, 0, 0 );
  }

  popMatrix();
}

//---------------------------------------------------------------------------------------

void renderFaceData(int x, int y) {

  pushMatrix();
  translate(x, y);

  if (state.equals("COMPARANDO") || state.equals("PERFIL ENCONTRADO") || state.equals("COMPARACIÓN FINALIZADA")) {
    translate(-2050, 0);
  }

  f.render();
  popMatrix();
}

//---------------------------------------------------------------------------------------

void renderState() {
  pushStyle();
  fill(255);
  noStroke();
  float sw = textWidth(state);
  rect(10, 10, sw+10, 18);
  fill(0);
  text(state, 15, 25);
  popStyle();
}

//---------------------------------------------------------------------------------------

void renderMisc() {
  pushStyle();
  pushMatrix();

  //  translate(width/2-400, 20);
  fill(255);
  noStroke();
  // rect(170, 0, 460, 45);

  fill(0);

  textAlign(CENTER, CENTER);

  //  text("ORGANISMO NACIONAL DE SEGURIDAD", 400, 20 );

  //image(shield, 175, 2);

  //  image(shield, 800-175 - shield.width, 2);

  imageMode(CENTER);

  image(header, width/2, 50);

  /*
  String text="";
   
   if (state.equals("ESPERANDO DETECCION")) {
   
   text = "AGUARDANDO PRESENCIA";
   } else if (state.equals("ROSTRO DETECTADO. ESPERANDO CONFIRMACION")) {
   
   text = "ROSTRO DETECTADO. ESPERANDO CONFIRMACION";
   } else if (state.equals("COMPARANDO")) {
   
   text = "COMPARANDO CON BASE DE DATOS DE CRIMINALES";
   } else if (state.equals("PERFIL ENCONTRADO")) {
   
   text = "PERFIL COICIDENTE ENCONTRADO";
   }
   
   
   
   
   
   float sw = textWidth(text);
   fill(255);
   rect(400-sw/2-10, 110, sw+20, 30);
   // rect(170, 0, 460, 45);
   
   // rect(0, 100, 800, 30);
   
   fill(0);
   text(text, 400, 122);*/

  if (state.equals("ROSTRO DETECTADO. PRESENCIA CONFIRMADA")) {

    image(img_detectado, width/2, 160 );

    if (frameCount%10 == 0 ) {

      dot_anim_control ++;
    }

    int how_many_dots = (dot_anim_control%4);



    //   println(how_many_dots + "puntos");

    for (int i = 0; i < how_many_dots; i++ ) {

      fill(255);
      noStroke();

      ellipse(width/2+210 + (i * 10), 189, 4, 4);
    }
  } else   if (state.equals("ANIMANDO")) { 


    fill(0);
    stroke(255);
    strokeWeight(2);


    image(img_comparando, width/2, 160);

    rect(282, 174, 459, 29);
  } else   if (state.equals("COMPARANDO") || state.equals("MOSTRANDO RESULTADOS")) { 


    fill(0);
    stroke(255);
    strokeWeight(2);


    image(img_comparando, width/2, 160);

    rect(282, 174, 459, 29);

    fill(255);

    int bar_width = int(map(criminal_index, 0, c.size()-1, 0, 459));

    noStroke();

    rect(282, 174, bar_width, 29);

    //    c.get(criminal_index)
  }


  popStyle();
  popMatrix();
  renderInstructions();




  if (state.equals("PERFIL ENCONTRADO")) {

    pushStyle();

    fill(0, 230);

    noStroke();

    rect(0, 0, width, height);

    imageMode(CENTER);

    image(img_encontrado, width/2, height/2);

    popStyle();
  }
}

//----------------------------------------------------------------------------------------

void renderInstructions() {
  pushStyle();
  imageMode(CENTER);
  image(img_standby, width/2, height-120);

  popStyle();
}

//------------------------------------------------------------------------------------------

void renderComparisonFrame() {

  if (DRAWCOMPFRAME) {

    pushStyle();

    noFill();
    stroke(255);
    strokeWeight(2);

    rect( width/2- f_n.face_map.width/2, height/2-f_n.face_map.height/2, f_n.face_map.width, f_n.face_map.height);

    popStyle();
  }
}

//--------------------------------------------------------------------------

void drawBorder() {

  if (DRAWBORDER) {

    pushStyle();

    noFill();

    stroke(255);

    strokeWeight(2);

    rect(0, 0, width, height);

    popStyle();
  }
}

