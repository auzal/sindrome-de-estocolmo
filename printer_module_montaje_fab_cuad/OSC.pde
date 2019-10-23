void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());


  String patt = theOscMessage.addrPattern();

  if (patt.equals("/fromPrinter")) {
    String signal = theOscMessage.get(0).stringValue();

    if (signal.equals("start")) {

      subirBanderaAnimacionTeclado();
      //printing = true;
    } else  if (signal.equals("end")) {
      bajarBanderaAnimacionTeclado();
      estado = "STAND BY";
      // printing = false;
    }
  } else {
    int index_to_load = theOscMessage.get(0).intValue();
    gestor_carga.addIndex(index_to_load);
  }
}

void sendPrinterSignal(String filepath) {



  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage("/test");

  //filepath = "/Users/arieluzal/Documents/Processing 3/estocolmo_2/repo/output/ticket_qr.jpg";
  myMessage.add(filepath); /* add a string to the osc message */
  // myMessage.add("/Users/arieluzal/Documents/Processing 3/estocolmo_2/demo_send_osc/frame.jpg");
  oscP5.send(myMessage, printerAddress);


  println(filepath);
  println("ahi fue");
}

