
//---------------------------------------------------------------------------------------

void updateStates() {


  if ( state.equals("PERFIL ENCONTRADO")) {

    handleVideo();
  }

  if ( f.state.equals("WAITING")  ||  f.state.equals("HAS RECT")) {

    handleVideo();

    processFrame();
    handleFaceClass();
    handleEyes();

    if ( f.state.equals("WAITING")) {

      state = "ESPERANDO DETECCION";
      criminal_index = 0;
    } else if ( f.state.equals("HAS RECT")) {

      state = "ROSTRO DETECTADO. ESPERANDO CONFIRMACION";
    }
  } else  if ( f.state.equals("HAS FACE")) {

    attemptFeatures();
    handleFeatures();
    f.signalEnd();
    f_n = new FaceNorm(video);
    f_n.setMainRects(f.r, f.left.r, f.right.r);
    if (f.has_mouth) {

      f_n.setMouth(f.mouth.r);
    }
    if (f.has_nose) {

      f_n.setNose(f.nose.r);
    }
    f_n.normalizeFace();

    state = "ROSTRO DETECTADO. PRESENCIA CONFIRMADA";
    dot_anim_control = 0 ;
    detection_trigger = millis();
  }

  if (state.equals("ROSTRO DETECTADO. PRESENCIA CONFIRMADA")) {



    f_n.renderStylized(width/2-f_n.face_map.width/2, height/2-f_n.face_map.height/2, color(255));

    if ( millis() - detection_trigger >= TIMEOUT_DETECTION) {
      x_anim_control = width/2-f_n.face_map.width/2;
      state = "ANIMANDO";
      criminal_index = 0;
    }
  } else if (state.equals("ANIMANDO")) {

    f_n.renderDithCrop(x_anim_control, height/2-f_n.face_map.height/2, color(255));

    f_n.renderDataStylized( width/2-f_n.face_map.width/2, height/2-f_n.face_map.height/2, color(255));

    x_anim_control = 30 ;

    if (x_anim_control <= 30) {

      state = "COMPARANDO";
      criminal_index = 0;
      comparison_trigger = millis();
    }
  } else if (state.equals("COMPARANDO")) {

    f_n.renderDithCrop(x_anim_control, height/2-f_n.face_map.height/2, color(255));

    f_n.renderDataStylized( width/2-f_n.face_map.width/2, height/2-f_n.face_map.height/2, color(255));

    c.get(criminal_index).renderDataStylized( width/2-f_n.face_map.width/2, height/2-f_n.face_map.height/2, color(255));

    c.get(criminal_index).renderDithCrop(width - f_n.face_map.width -30, height/2-f_n.face_map.height/2, color(255));

        renderComparisonFrame();

    //    c.get(criminal_index).renderStylizedData();

    //  if (frameCount%20==0) {

    if (millis() - comparison_trigger >  COMPARISON_TIME) {

      comparison_trigger = millis();

      likedness[criminal_index] = compareFaces( c.get(criminal_index), f_n);  

      if (criminal_index < c.size()-1){
        criminal_index ++;
        //println("criminal_index" + criminal_index);
      }else {
        which_criminal = getMinimalValueIndex(likedness);
        results_trigger = millis();
        state = "MOSTRANDO RESULTADOS";
      }
    }
  } else if (state.equals("MOSTRANDO RESULTADOS")) {

    f_n.renderDithCrop(x_anim_control, height/2-f_n.face_map.height/2, color(255));

    f_n.renderDataStylized( width/2-f_n.face_map.width/2, height/2-f_n.face_map.height/2, color(255));

    c.get(which_criminal).renderDataStylized( width/2-f_n.face_map.width/2, height/2-f_n.face_map.height/2, color(255));

    c.get(which_criminal).renderDithCrop(width - f_n.face_map.width -30, height/2-f_n.face_map.height/2, color(255));



    if (millis() - results_trigger >  TIMEOUT_RESULTS) {

      //comparison_trigger = millis();
      state = "COMPARACIÓN FINALIZADA";
    }
  } else if (state.equals("COMPARACIÓN FINALIZADA")) {

    f_n.setCharges(c.get(which_criminal).charges);

    if (SAVEDATA)
      saveAndNotify();

    final_trigger = millis();

    state = "PERFIL ENCONTRADO";
  } else if (state.equals("PERFIL ENCONTRADO")) {


    //  pushMatrix();


    //    translate(width/2-f_n.face_map.width/2, height/2-f_n.face_map.height/2);

    //    f_n.render(0, 0, color(255));

    //    c.get(which_criminal).renderData();

    //    popMatrix();


    if (millis() - final_trigger > TIMEOUT_FINAL ) {
      f.kill();
      state="WAITING";
    }
  }
}

//---------------------------------------------------------------------------------------

void saveAndNotify() {

  f_n.saveXml();

  f_n.saveImages();

  saveIndex();

  sendNotification();
}

