void processImage(PImage img_, FaceNormCompact f_) {

  PGraphics   img;

  PImage img_dith;

  /// ********************* NOTA: EL ANCHO MAXIMO EN PIXELS ES DE 384 ******************************  /// 

  int ticket_width = 384;

  int ticket_height = 656; 

  int photo_width = 188;

  img_dith = createImage(photo_width, photo_width, RGB);

  img_dith.copy(img_, 0, 0, img_.width, img_.height, 0, 0, img_dith.width, img_dith.height);

  img_dith =  floydSteinberg(img_dith);

  img = createGraphics(ticket_width, ticket_height);

  img.beginDraw();

  img.background(255);

  img.image(empty_ticket, 0, 0);

  img.noSmooth();

  img.fill(255);

  img.strokeWeight(2);

  img.stroke(0);

  img.image(img_dith, 97, 60 );

  float qr_control = random(100);

  println("CONTROL DE QR = " + qr_control);

  if (qr_control < 15) {

    img.image(qr_c, 262, 503 );
  } else

    img.image(qr_t, 262, 503 );

  img.fill(255);

  img.textFont(ocra_21);

  float id_aux = float(f_.id);

  img.text( "SUJETO NRO." + nf(id_aux, 10, 0), 55, 28);

  img.textFont(ocra_14);

  img.fill(0);

  f_.addPrint();

  /*

   String aux_text = "Este perfil ha sido impreso ";
   
   if (f_.print_count > 1)
   
   aux_text += f_.print_count + " veces";
   
   else
   
   aux_text += f_.print_count + " vez";
   
   
   aux_text += "\nÍndice de peligrosidad :" + ( f_.print_count*1.0  / f.size() ) * 47.45822;
   
   //println(f.size());
   
   //println(( f.get(index).print_count  / f.size() ) * 47.45822);
   
   img.text(aux_text, 19, 720);
   
   */

  img.textFont(ocra_16);

  img.pushStyle();

  img.textAlign(LEFT, CENTER);

  img.pushMatrix();
  img.translate(19, 310);  


  img.fill(0);

  int y = 0 ;


  for (int z = 0; z < f_.charges.length; z++) {


    String[] aux = partirString(f_.charges[z], 29);

    for (int j = 0; j < aux.length; j++) {

      img.text(aux[j], 0, 15+ y);

      y+= 26;
    }

    img.stroke(0);
    img.strokeWeight(2);
    img.line(0, y+4, 345, y+4);
  }

  img.popMatrix();

  img.popStyle();


  PImage aux_img = createImage(img.width, img.height, RGB);

  aux_img.copy(img, 0, 0, img.width, img.height, 0, 0, img.width, img.height);

  // img.save("/ouput/imagen_aux.jpg"); 

  img.pushMatrix();

  img.rotate(PI);

  img.image(aux_img, -img.width, - img.height);

  img.popMatrix();

  img.endDraw();


  String filename = "";

  if (LOCAL)

    filename = "../../repo/output/ticket" + int(id_aux) + ".jpg";
    
  else
  
   filename = "/Volumes/Users/Public/Documents/repo/output/ticket" + int(id_aux) + ".jpg";

  img.save(filename);

  generateBytes(img);

  println("IMAGEN PREPARADA!");
}


void generateBytes(PImage img) {

  PrintWriter output;
  int         pixelNum, byteNum, bytesOnLine = 99, 
  x, y, b, rowBytes, totalBytes, lastBit, sum;

  //img.resize(300,0);

  /* // Morph filename into output filename and base name for data
   x = filename.lastIndexOf('.');
   if (x > 0) filename = filename.substring(0, x);  // Strip current extension
   x = filename.lastIndexOf('/');
   if (x > 0) basename = filename.substring(x + 1); // Strip path
   else      basename = filename;
   filename += ".h"; // Append '.h' to output filename
   println("Writing output to " + filename);*/

  // Calculate output size
  rowBytes   = (img.width + 7) / 8;

  renglon = new int[img.height][rowBytes];

  // println(rowBytes);
  totalBytes = rowBytes * img.height;
  // Convert image to B&W, make pixels readable
  img.filter(THRESHOLD);
  img.loadPixels();

  // Open header file for output (NOTE: WILL CLOBBER EXISTING .H FILE, if any)
  /* output = createWriter(filename); 
   
   // Write image dimensions and beginning of array
   output.println("#ifndef _" + basename + "_h_");
   output.println("#define _" + basename + "_h_");
   output.println();
   output.println("#define " + basename + "_width  " + img.width);
   output.println("#define " + basename + "_height " + img.height);
   output.println();
   output.print("static const uint8_t PROGMEM " + basename + "_data[] = {");*/

  // Generate body of array
  for (pixelNum=byteNum=y=0; y<img.height; y++) { // Each row...
    for (x=0; x<rowBytes; x++) { // Each 8-pixel block within row...
      lastBit = (x < rowBytes - 1) ? 1 : (1 << (rowBytes * 8 - img.width));
      sum     = 0; // Clear accumulated 8 bits
      for (b=128; b>=lastBit; b >>= 1) { // Each pixel within block...
        if ((img.pixels[pixelNum++] & 1) == 0) sum |= b; // If black pixel, set bit
      }
      if (++bytesOnLine >= 10) { // Wrap nicely
        //    output.print("\n ");
        bytesOnLine = 0;
      }
      //   output.print( sum); // Write accumulated bits
      renglon[y][x] = sum;
      //if (++byteNum < totalBytes) output.print(',');
    }
  }

  // End array, close file, exit program
  /*   output.println();
   output.println("};");
   output.println();
   output.println("#endif // _" + basename + "_h_");
   output.flush();
   output.close();*/
}

//-----------------------------------------------------------------------------------

void prepararImpresion() {

  if (estado.equals("STAND BY"))
    estado = "PREPARANDO IMPRESION";
}

//-----------------------------------------------------------------------------------

void enviar() {
  /*
  // String prueba = "He and his wife, the old lady who had received me,looked ";
   char prueba = 'T';
   println("enviado");
   myPort.write(prueba); 
   delay(1000);
   myPort.write("A VER AHORA");
   myPort.write('\n');
   //myPort.write('\n'); */
}

//--------------------------------------------------------------------------------

void sendString(String s) {

  /*  // String prueba = "He and his wife, the old lady who had received me,looked ";
   char prueba = 'T';
   println("enviado");
   myPort.write(prueba); 
   delay(1000);
   myPort.write(s);
   myPort.write('\n');
   //myPort.write('\n'); */
}

//---------------------------------------------------------------------------------

void subirBanderaImagen() {

  //  char prueba = 'I';
  //  println("enviado");
  //  myPort.write(prueba); 
  // delay(0);
}

//---------------------------------------------------------------------------------

void bajarBanderaImagen() {

  /* char prueba = 'F';
   println("enviado");
   myPort.write(prueba); 
   delay(1000);*/
}

//---------------------------------------------------------------------------------

void enviarSeparador() {

  /*  char prueba = 'S';
   println("enviado separador");
   myPort.write(prueba); 
   delay(1000); */
}

//---------------------------------------------------------------------------------

void enviarLineaCorte() {

  /*  char prueba = 'C';
   println("enviado linea corte");
   myPort.write(prueba); 
   delay(1000); */
}


