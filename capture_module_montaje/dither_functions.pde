PImage atkinson(PImage img) {

  pushStyle();

  noStroke();
  noSmooth();

  PImage src = img;
  PGraphics  res = createGraphics(src.width, src.height, JAVA2D);

  res.beginDraw();

  res.background(0);

  // Define step
  int s = 2;

  // Scan image
  for (int x = 0; x < src.width; x+=s) {
    for (int y = 0; y < src.height; y+=s) {
      // Calculate pixel
      color oldpixel = src.get(x, y);
      color newpixel = findClosestColor(oldpixel);
      float quant_error = brightness(oldpixel) - brightness(newpixel);
      src.set(x, y, newpixel);

      // Atkinson algorithm http://verlagmartinkoch.at/software/dither/index.html
      src.set(x+s, y, color(brightness(src.get(x+s, y)) + 1.0/8 * quant_error) );
      src.set(x-s, y+s, color(brightness(src.get(x-s, y+s)) + 1.0/8 * quant_error) );
      src.set(x, y+s, color(brightness(src.get(x, y+s)) + 1.0/8 * quant_error) );
      src.set(x+s, y+s, color(brightness(src.get(x+s, y+s)) + 1.0/8 * quant_error));
      src.set(x+2*s, y, color(brightness(src.get(x+2*s, y)) + 1.0/8 * quant_error));
      src.set(x, y+2*s, color(brightness(src.get(x, y+2*s)) + 1.0/8 * quant_error));

      // Draw
      color c = color(newpixel);   

      res.set(x, y, c);
    }
  }

  res.endDraw();
  popStyle();
  return res;
}

// Threshold function
color findClosestColor(color in) {  
  color out;
  if (brightness(in) < 128) {
    out = color(0);
  } else {
    out = color(255);
  }


  return out;
}


///----------------------------------------------------------------------------

PImage floydSteinberg(PImage img) {

  PImage src = img;
  PGraphics  res = createGraphics(src.width, src.height, JAVA2D);

  pushStyle();


  res.beginDraw();

  res.background(0);

  noStroke();
  noSmooth(); 


  int s = 1;
  for (int x = 0; x < src.width; x+=s) {
    for (int y = 0; y < src.height; y+=s) {
      color oldpixel = src.get(x, y);
      color newpixel = findClosestColor(oldpixel);
      float quant_error = brightness(oldpixel) - brightness(newpixel);
      src.set(x, y, newpixel);

      src.set(x+s, y, color(brightness(src.get(x+s, y)) + 7.0/16 * quant_error) );
      src.set(x-s, y+s, color(brightness(src.get(x-s, y+s)) + 3.0/16 * quant_error) );
      src.set(x, y+s, color(brightness(src.get(x, y+s)) + 5.0/16 * quant_error) );
      src.set(x+s, y+s, color(brightness(src.get(x+s, y+s)) + 1.0/16 * quant_error));


      color c = color(newpixel);   

      res.set(x, y, c);
    }
  }

  res.endDraw();
  popStyle();

  return res;
}

///----------------------------------------------------------------------------

PImage halftone(PImage img) {

  int myColorBackground = color(0, 0, 0);

  PGraphics  res = createGraphics(img.width, img.height, JAVA2D);

  pushStyle();


  res.beginDraw();

  res.background(0);

  res.noStroke();
  res.noSmooth(); 


  float dotSize = 4;

  float scl = 1;

  int steps = 6;

  res.background( 255 );

  res.fill( 0, 0, 0 );

  for (int y=0; y<img.height; y+=steps) {
    for (int x=0; x<img.width; x+=steps) {
      float val = ( red( img.get(x, y) ) + green( img.get(x, y) ) + blue( img.get(x, y) ) ) / 3;
      float s = map(val, 0, 255, 1, 3 * scl );
      s = (3 * scl) - s;
      res.ellipse(x*scl, y*scl, s * dotSize, s * dotSize );
    }
  }


  res.endDraw();
  popStyle();

  return res;
}


///----------------------------------------------------------------------------------


PImage ordered(PImage img) {
  PImage src = img;
  PGraphics  res = createGraphics(src.width, src.height, JAVA2D);

  pushStyle();


  res.beginDraw();

  res.background(0);

  // Bayer matrix
  int[][] matrix = {   
    {
      1, 9, 3, 11
    }
    , 
    {
      13, 5, 15, 7
    }
    , 
    {
      4, 12, 2, 10
    }
    , 
    {
      16, 8, 14, 6
    }
  };

  float mratio = 1.0 / 17;
  float mfactor = 255.0 / 5;

  noStroke();
  noSmooth();



  // Init canvas

  // Define step
  int s = 1;

  // Scan image
  for (int x = 0; x < src.width; x+=s) {
    for (int y = 0; y < src.height; y+=s) {
      // Calculate pixel
      color oldpixel = src.get(x, y);
      color value = color( brightness(oldpixel) + (mratio*matrix[x%4][y%4] * mfactor));
      color newpixel = findClosestColor(value);

      src.set(x, y, newpixel);


      color c = color(newpixel);   

      res.set(x, y, c);
    }
  }

  res.endDraw();
  popStyle();

  return res;
}

///----------------------------------------------------------------------------------------------

PImage randomDither(PImage img) {

  PImage src = img;
  PGraphics  res = createGraphics(src.width, src.height, JAVA2D);

  pushStyle();


  res.beginDraw();

  res.background(0);

  noStroke();
  noSmooth(); 


  int s = 1;
  for (int x = 0; x < src.width; x+=s) {
    for (int y = 0; y < src.height; y+=s) {
      color oldpixel = src.get(x, y);
      color newpixel = findClosestColor( color(brightness(oldpixel) + random(-64, 64)) );      
      src.set(x, y, newpixel);



      color c = color(newpixel);   

      res.set(x, y, c);
    }
  }

  res.endDraw();
  popStyle();


  return res;
}





