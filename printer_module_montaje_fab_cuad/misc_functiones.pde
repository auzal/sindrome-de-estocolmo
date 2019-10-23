void handleManualSelect() {

  if (millis() > select_trigger + manual_select_timeout) {

    manual_select = false;
  }
}


void dispararThoreau() {

  if (estado.equals("STAND BY")) {
    String filepath ="";
    if(LOCAL)
       filepath = "/Users/arieluzal/Documents/Processing 3/estocolmo_2/repo/output/ticket_thoreau.jpg";
    else
      filepath = "/Volumes/Users/Public/Documents/repo/output/ticket_thoreau.jpg";
    sendPrinterSignal(filepath);
    thoreau_trigger = millis();
    THOREAU_FREQ = int(random(THOREAU_FREQ_MIN,THOREAU_FREQ_MAX));
    println("TIEMPO HASTA SIEGUIENTE THOREAU : " + THOREAU_FREQ);
    estado = "THOREAU";
  }
}

