//***********************************************************************

void serialEvent(Serial myPort) { 

  if (myPort == keyPort) {

    String inString = myPort.readStringUntil('\n');

    if (inString != null) {
      // trim off any whitespace:
      inString = trim(inString);

      if (!inString.equals("Trellis Demo")) {

        if (estado.equals("STAND BY")) {


          char input = inString.charAt(0);

          int which = input - 97;

          if (which < f.size()) {

            index = which;

           // subirBanderaAnimacionTeclado();

            prepararImpresion();



            println("EVENTO DE TECLADO");
          }
        }
      }

      // split the string on the commas and convert the 
      // resulting substrings into an integer array:
      //   float[] valores = float(split(inString, ","));
      // if the array has at least three elements, you know
      // you got the whole thing.  Put the numbers in the
      // color variables:

      /*  if (valores.length >=4) {
       for(int i = 0 ; i < entradas.length ; i ++){
       entradas[i].posy = valores[i];
       entradas[i].actualizar();
       entradas[i].graficar();
       }
       } */
    }
  }
}

//---------------------------------------------------------------------------------


void subirBanderaAnimacionTeclado() {

  char prueba = 'A';
  //println("subiendo bandera");
  keyPort.write(prueba); 
  delay(30);
}

//---------------------------------------------------------------------------------


void bajarBanderaAnimacionTeclado() {

  char prueba = 'S';
 // println("bajando bandera");
  keyPort.write(prueba); 
  delay(30);
}

