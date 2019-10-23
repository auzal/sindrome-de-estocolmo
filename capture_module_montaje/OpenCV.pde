void processFrame() {

  // scale(scl);
  opencv.loadImage(video);
  faces = opencv.detect();
  ojos.loadImage(video);
  eyes = ojos.detect();
}

//---------------------------------------------------------------------------------------

void attemptFeatures() {

  // scale(scl);
  nariz.loadImage(video);
  noses = nariz.detect();
  boca.loadImage(video);
  mouths = boca.detect();
}

//---------------------------------------------------------------------------------------

void drawEyeArray() {

  noFill();
  stroke(255, 0, 255);
  strokeWeight(3);
  if (eyes!=null) {
    for (int i = 0; i < eyes.length; i++) {
      rect(eyes[i].x, eyes[i].y, eyes[i].width, eyes[i].height);
    }
  }
}

//---------------------------------------------------------------------------------------

void drawFaceArray() {

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  if (faces!=null) {
    for (int i = 0; i < faces.length; i++) {
      rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    }
  }
}

//---------------------------------------------------------------------------------------

void drawNoseArray() {

  noFill();
  stroke(255, 255, 0);
  strokeWeight(3);
  if (noses!=null) {
    for (int i = 0; i < noses.length; i++) {
      rect(noses[i].x, noses[i].y, noses[i].width, noses[i].height);
    }
  }
}

//---------------------------------------------------------------------------------------

void drawMouthArray() {

  noFill();
  stroke(255, 0, 0);
  strokeWeight(3);
  if (mouths!=null) {
    for (int i = 0; i < mouths.length; i++) {
      rect(mouths[i].x, mouths[i].y, mouths[i].width, mouths[i].height);
    }
  }
}

//-----------------------------------------------------------------------------------------

void drawRawData() {

  if (draw_raw) {
    drawFaceArray();
    drawEyeArray();
    drawNoseArray();
    drawMouthArray();
  }
}

