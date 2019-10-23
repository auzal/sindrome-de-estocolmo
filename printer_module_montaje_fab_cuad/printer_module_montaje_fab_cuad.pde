import processing.video.*;

import processing.serial.*;

import java.awt.*;

import oscP5.*;
import netP5.*;

import java.util.GregorianCalendar;
import java.util.Calendar;
import java.util.Date;

//-----------------------------------------------------------------------------------

void setup() {
  size(1280, 800);   /// PROJECTOR VIEWSONIC PJD5533w

  if (LOCAL) {

    DIRPATH = LOCALPATH;
  } else {

    DIRPATH = REMOTEPATH;
  }

  String [] ports =  Serial.list();

  for (int i = 0; i < ports.length; i++) {

    println("PORT " + i + " : " + ports[i]);
  }

  println("****** ************ ************* **********");

  String portName = Serial.list()[1];   // EN LA MAC, 6  // PC, 1

  // myPort = new Serial(this, portName, 19200);

  portName = Serial.list()[4];   // EN LA MAC, 3  // PC, 2

  keyPort = new Serial(this, portName, 9600);

  keyPort.bufferUntil('\n');

  f = new ArrayList();

  suspects_number = 0;

  index = 0;

  indice_cargos = 0;

  gestor_carga = new GestorCargaLive();


  font = loadFont("OCRA.vlw");
  header = loadFont("H30.vlw");
  H20 = loadFont("H20.vlw");
  O15 = loadFont("O15.vlw");
  H15 = loadFont("H15.vlw");
  ocra_21 = loadFont("OCRA-21.vlw");
  ocra_14 = loadFont("OCRA-14.vlw");
  ocra_12 = loadFont("OCRA-12.vlw");
  ocra_16 =  loadFont("OCRA-16.vlw");
  helvetica_16 = loadFont("Helvetica-16.vlw");

  textFont(font);

  qr_t = loadImage("qr_t_small.png");
  qr_c = loadImage("qr_c_small.png");


  header_img = loadImage("header.png");

  footer = loadImage("footer.png");

  qr_bound = loadImage("qr_bound.png");

  empty_ticket = loadImage("ticket-07.png");  // 05 para version sin marco

  thoreau = loadImage("fondo_thoreau.jpg");

  thoreau_glitch = loadImage("fondo_thoreau_glitch.jpg");

  loadIndex();

  loadPrintCount();

  loadAll();

  estado = "STAND BY";

  //  dither.resize(300,0);
  frameRate(30);

  /* start oscP5, listening for incoming messages at port 12001 */
  oscP5 = new OscP5(this, 12001);

  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);

  printerAddress = new NetAddress("127.0.0.1", 12345);


  c = Calendar.getInstance();
}

//-----------------------------------------------------------------------------------

void draw() {

  noCursor();
  
  println(f.size());

  // frame.setLocation(HOME_X, HOME_Y);  // SOLO PARA EL MONTAJE DEL 2 DE NOV

  frame.setTitle(str(millis()));

  background(0);

  renderThumbs();

  renderMisc();

  graficarEstado();

  if (millis() - thoreau_trigger > THOREAU_FREQ ) {

    dispararThoreau();
  }




  if (estado.equals("STAND BY")) {

    if (gestor_carga.flagRaised()) {

      for (int i = 0; i < gestor_carga.indexes_to_load.length; i++) {

        println("ATTEMPTING TO LOAD " + gestor_carga.indexes_to_load[i]);

        loadNew(gestor_carga.indexes_to_load[i]);
      }

      gestor_carga.reset();
    }
  } else if (estado.equals("PREPARANDO IMPRESION")) {
    select_trigger = millis();
    manual_select = true;
    select_index = index;
    // processImage(f.get(index).img_face);
    //  enviarSeparador();
    subirBanderaImagen();
    //printer_timer_trigger = millis();
    estado = "ESPERANDO IMAGEN";
  } else if (estado.equals("ESPERANDO IMAGEN")) {

    //  if(millis() - printer_timer_trigger > printer_wait){

    estado = "DISPARANDO IMPRESION";

    // printer_timer_trigger = millis();
    //   println("pasaron " + (millis() - printer_timer_trigger) );

    // }
  } else if (estado.equals("DISPARANDO IMPRESION")) {
    indice = 0;
    float id_aux = float(f.get(index).id);
    
    String filepath ="";
    if(LOCAL)
       filepath = "/Users/arieluzal/Documents/Processing 3/estocolmo_2/repo/output/ticket" +   int(id_aux) + ".jpg";
    else
      filepath = "/Volumes/Users/Public/Documents/repo/output/ticket" +   int(id_aux) + ".jpg";
     
    sendPrinterSignal(filepath);
    estado = "IMPRIMIENDO IMAGEN";
    printer_timer_trigger = millis();
    global_prints ++;
    savePrintCount();
  } else if (estado.equals("IMPRIMIENDO IMAGEN")) {




    if (millis() - printer_timer_trigger > printer_wait) {

      estado = "STAND BY";
    } 

    /*{
     printer_timer_trigger = millis();
     // if (frameCount%4==0) {  // cada 4 frames parece ser el limite de velocidad, en la mac, 3
     if (indice<renglon.length) {
     for (int j = 0; j < renglon[indice].length; j++) {
     
     myPort.write(renglon[indice][j]);
     }
     //  println("IMPRIMIENDO..." +  indice);
     indice++;
     } else {*/
    // bajarBanderaImagen();
    //  println(indice);

    indice_cargos = 0;
    //  enviarSeparador();

    // enviarSeparador();
    // enviarLineaCorte();
    // enviarSeparador();
    // enviarSeparador();
    // enviarSeparador();

    // estado = "STAND BY";
    //  bajarBanderaAnimacionTeclado();
  }


  handleManualSelect();

  /*
  
   pushStyle();
   
   if(gestor_carga.flagRaised())
   
   fill(255);
   
   else 
   
   noFill();
   
   stroke(255);
   
   ellipse(width-20,20,10,10);
   
   popStyle();
   */
}

//-----------------------------------------------------------------------------------

void mousePressed() {

  // prepararImpresion();
  //enviar();
}

//------------------------------------------------------------------------------------

void keyPressed() {


  if (key == 'A' || key == 'a') {

    select_trigger = millis();
    manual_select = true;

    if (select_index > 0 ) {

      select_index --;
    } else
      select_index = f.size()-1;
  } else if (key == 'D' || key == 'd') {

    select_trigger = millis();
    manual_select = true;

    if (select_index <  f.size()-1 ) {

      select_index ++;
    } else
      select_index = 0;
  } else if (key == 'k' || key == 'K') {

    select_trigger = millis();
    manual_select = true;

    if (f.size()>0) {

      f.remove(select_index);
    }

    select_index = 0;
  } else if (key == 'R' || key == 'r') {

    select_index = 0;
    loadAll();
  } else if (key == 'P') {

    global_prints = 0;
    savePrintCount();
  } else if (key == 'h' || key == 'H') {

    // RENDER_PERCENTAGE = !RENDER_PERCENTAGE;
  } else if (key == 't' || key == 'T') {

    dispararThoreau();
  }
}


//-----------------------------------------------------------------------------------

void graficarEstado() {
  pushStyle();
  /*  fill(255);
   noStroke();
   float sw = textWidth(estado);
   rect(10, 10, sw+10, 18);
   fill(0);
   text(estado, 15, 25);*/

  if (estado.contains("IMPRIMIENDO") || estado.contains("IMPRESION") || estado.contains("DISPARANDO")) {

    renderPrintScreen();
  }

  if (estado.equals("THOREAU")) {

    if (random(10) < 1)
      image(thoreau_glitch, 0, 0);
    else
      image(thoreau, 0, 0);
  }

  popStyle();
}

