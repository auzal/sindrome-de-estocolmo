void renderThumbs() {

  float x = 0;

  float y = 0 ;

  pushMatrix();

  translate(314, 62);


  for ( int i = 0; i < f.size (); i ++ ) {

    if (i % 4 == 0 && i!=0) {

      y+= THUMB_SIZE + PADDING - 3 + 20;

      x = 0;
    }

    pushMatrix();

    translate(x, y);

    renderBoundingBox();



    image(f.get(i).thumb, PADDING/2, PADDING/2+2 );

    noFill();

    stroke(255);

    rect( PADDING/2, PADDING/2+2, THUMB_SIZE, THUMB_SIZE);

    renderId(i);

    // renderCharges(i);

    renderChargesMarquee(i);

    // renderNumberBox(i);

    if (i == select_index  && manual_select) {

      renderHighlight();
    }

    popMatrix();

    x += THUMB_SIZE + PADDING - 3 + 20 ;
  }

  popMatrix();
}

// -------------------------------------------------------------------------------- 

void renderId(int i) {

  pushStyle();

  textFont(ocra_12);

  fill(255);

  noStroke();

  String name = "SUJETO " + nf(float(f.get(i).id), 4, 0);

  float sw = textWidth(name);

  rect(0, 0, sw+10, 20);

  textAlign(LEFT, CENTER);

  fill(0);

  text(name, 5, 10);

  popStyle();
}



// -------------------------------------------------------------------------------- 

void renderCharges(int i) {

  pushStyle();

  textFont(H15);

  textAlign(LEFT, CENTER);

  pushMatrix();

  translate(THUMB_SIZE + 40, PADDING/2 + 13);

  text("BUSCADO POR:", 0, 0);
  stroke(255);
  line(0, 8, 140, 8);

  int y = 0;

  for (int z = 0; z < f.get (i).charges.length; z++) {


    String[] aux = partirString(f.get (i).charges[z], 24);

    for (int j = 0; j < aux.length; j++) {

      text(aux[j], 0, 15+ y);

      y+= 15;
    }

    stroke(255);
    line(0, y+8, 140, y+8);
  }

  String aux_text = "Impreso ";

  if (f.get(i).print_count != 1)

    aux_text += f.get(i).print_count + " veces";

  else

    aux_text += f.get(i).print_count + " vez";

  text(aux_text, 0, 104);

  popMatrix();

  popStyle();
}

//-----------------------------------------------------------------------------------------------------------

void renderChargesMarquee(int i) {
  pushStyle();

  textFont(H15);

  int num_chars = 23;

  textAlign(LEFT, CENTER);

  pushMatrix();

  translate(5, THUMB_SIZE + 42);

  String charges_single = " BUSCADO POR: ";

  fill(255);
  stroke(255);
  
  line(-5,-8,145,-8);

  int y = 0;

  for (int z = 0; z < f.get (i).charges.length; z++) {

    charges_single += f.get (i).charges[z];

    charges_single += " | ";
  }

  int init = frameCount/4 % charges_single.length()-1; 

  init = constrain(init, 0, 1000);

  String show = "";

  //   println("init" + init);

  if (init + num_chars  < charges_single.length()-1)

    show = charges_single.substring(init, init + num_chars);

  else {

    show = charges_single.substring(init, charges_single.length()-1) + charges_single.substring(0, num_chars - (charges_single.length()-1 - init)) ;
  }

  text(show, 0, 0);

  /*

   String aux_text = "Impreso ";
   
   if (f.get(i).print_count != 1)
   
   aux_text += f.get(i).print_count + " veces";
   
   else
   
   aux_text += f.get(i).print_count + " vez";
   
   text(aux_text, 0, 104); */

  popMatrix();

  popStyle();
}

// -------------------------------------------------------------------------------- 

void renderNumberBox(int i) {

  pushStyle();

  noStroke();

  fill(255);

  String id = str(i+1);

  float sw = textWidth(id);
  rect(PADDING/2, PADDING/2, sw+10, 18);
  fill(0);
  text(id, (PADDING/2) + 5, (PADDING/2) + 15);

  popStyle();
}

// -------------------------------------------------------------------------------- 

void renderHighlight() {

  pushStyle();

  int alfa = int(map(millis()-select_trigger, 0, manual_select_timeout, 220, 0));

  //fill(stroke_c, alfa);
  fill(215, 136, 24, alfa);
  strokeWeight(3);
  noStroke();
  //  noFill();
  //rect(PADDING/2, PADDING/2, THUMB_SIZE, THUMB_SIZE);
  beginShape();

  vertex(0, 0);

  vertex(130, 0);

  vertex(150, 20);

  vertex(150, 150);

  vertex(0, 150);

  endShape(CLOSE);
  strokeWeight(1);
  popStyle();
}

// -------------------------------------------------------------------------------- 

void renderBoundingBox() {

  pushStyle();

  noFill();

  stroke(255);

  beginShape();

  vertex(0, 0);

  vertex(130, 0);

  vertex(150, 20);

  vertex(150, 150);

  vertex(0, 150);

  endShape(CLOSE);

  //rect(0, 0, 285, 150);  // bounding box

  popStyle();
}

//----------------------------------------------------------------------------------------

void renderMisc() {

  pushStyle();

  /*

   textFont(header, 28);
   
   noStroke();
   
   fill(255);
   
   int rectwidth =650;
   
   rect( width/2 - rectwidth/2, 10, rectwidth, 35);
   
   fill(0);
   
   textAlign(CENTER, CENTER);
   
   text("¿HA VISTO A ALGUNA DE ESTAS PERSONAS?", width/2, 27);
   
   textFont(H20);
   
   fill(255);
   
   rectwidth = 870;
   
   rect( width/2 - rectwidth/2, 740, rectwidth, 50);
   
   fill(0);
   
   textAlign(CENTER, CENTER);
   
   text("ESTAS PERSONAS CONSTITUYEN UN RIESGO PARA NUESTRA SEGURIDAD NACIONAL.", width/2, 750);
   
   //  textFont(header, 24);
   
   text("SI SABE ALGO, HABLE.", width/2, 775);
   
   */

  imageMode(CENTER);

  image(header_img, width/2, 30);

  image(footer, width/2, height-41);

  image(qr_bound, 1155, height-41);

  image(qr_t, width-68, height-40, 60, 60 );

  noFill();

  stroke(255);

  strokeWeight(1.5);

  rect(30, 726, 200, 66);

  strokeWeight(1);

  line(40, 750, 220, 750);

  line(40, 770, 220, 770);

  fill(255);

  textFont(H15);

  textAlign(LEFT, CENTER);

  int dayOfWeek = c.get(Calendar.DAY_OF_WEEK);

  //  println("Day of week is: " + dias[dayOfWeek-1]);

  text(dias[dayOfWeek-1] + ". " + day() + " de " + meses[month()-1] + ", " + year(), 40, height - 60);


  String minutos = str(minute());

  if (float(minutos) < 10) 

    minutos = "0" + minutos ;

  text(hour() + ":" + minutos + " - Sistema en línea", 40, height - 40);

  if (global_prints == 1)

    text(global_prints + " perfil impreso", 40, height-20);

  else

    text(global_prints + " perfiles impresos", 40, height-20);

  popStyle();
}


//--------------------------------------------------------------------------------------------------

String[] partirString(String s, int largo_max) {

  String[] nuevo = new String[0]; 



  if (s.length() <= largo_max)
    nuevo = append(nuevo, s);
  else {

    while (s.length () > largo_max)

      for (int i = largo_max; i > 0; i--) {

        if (s.charAt(i) == ' ') {
          String aux = s.substring(0, i);
          s = s.substring(i+1);
          nuevo = append(nuevo, aux);
          break;
        }
      }

    if (s.length()<=largo_max)
      nuevo = append(nuevo, s);
  }

  return nuevo;
}

//-----------------------------------------------------------------------------------------------------------

void renderPrintScreen() {

  pushStyle();

  fill(0, 170);

  noStroke();

  rect(0, 0, width, height);

  renderActiveThumb();

  fill(0, 40);

  noStroke();

  rect(0, 0, width, height);

  fill(0);

  strokeWeight(2);
  stroke(255);

  pushMatrix();

  int ancho = 480;

  translate(width/2-ancho/2, height/2-100);

  rect(0, 0, ancho, 150);

  noStroke();

  fill(255);

  rect(0, 0, ancho, 40);

  fill(0);

  textAlign(CENTER, CENTER);

  String s = "IMPRIMIENDO INFORMACIÓN DEL SUJETO " + nf(float(f.get(index).id), 4, 0);

  text(s, ancho/2, 20);

  if (estado.contains("IMAGEN")) {

    strokeWeight(4);
    stroke(255);
    fill(255);
    rect(30, 80, 420, 30);
    float  aux = map(millis() - printer_timer_trigger, 0, printer_wait, 0, 420);
    noStroke();
    fill(0);
    rect(30, 80, aux, 30);


    if (RENDER_PERCENTAGE) {

      fill(255);

      rect(ancho/2-20, 85, 40, 18);

      int porcentaje = int(map(millis() - printer_timer_trigger, 0, printer_wait, 0, 100));

      s = porcentaje + "%";

      fill(0);

      text(s, ancho/2, 95);
    }
  } 

  popMatrix();

  popStyle();
}

//-----------------------------------------------------------------------------------------------------------

void renderActiveThumb() {

  float x = 0;

  float y = 0 ;

  pushMatrix();

  translate(314, 62);


  for ( int i = 0; i < f.size (); i ++ ) {

    if (i % 4 == 0 && i!=0) {

      y+= THUMB_SIZE + PADDING - 3 + 20;

      x = 0;
    }

    pushMatrix();

    translate(x, y);

    if (i == select_index) {

      renderBoundingBox();

      image(f.get(i).thumb, PADDING/2, PADDING/2+2 );

      noFill();

      stroke(255);

      rect( PADDING/2, PADDING/2+2, THUMB_SIZE, THUMB_SIZE);

      renderId(i);

      renderChargesMarquee(i);

      if (i == select_index  && manual_select) {

        renderHighlight();
      }
    }
    popMatrix();

    x += THUMB_SIZE + PADDING - 3 + 20 ;
  }

  popMatrix();
}

