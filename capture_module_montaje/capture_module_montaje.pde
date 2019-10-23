import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import oscP5.*;
import netP5.*;

//---------------------------------------------------------------------------------------

void setup() {
  
  noCursor();
  
  size(1024, 768);  // EL TAMAÑO DL 
  
   if(LOCAL){
  
    DIRPATH = LOCALPATH;
  
  }else{
  
    DIRPATH = REMOTEPATH;
  
  }

  int video_width = 320;
  int video_height = 240;

  video = new Capture(this, video_width, video_height);
  opencv = new OpenCV(this, video_width, video_height);
  ojos = new OpenCV(this, video_width, video_height);
  nariz = new OpenCV(this, video_width, video_height);
  boca = new OpenCV(this, video_width, video_height);

  dithered_video = createImage(video_width *1, video_height*1, RGB);

  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  ojos.loadCascade(OpenCV.CASCADE_EYE);
  nariz.loadCascade(OpenCV.CASCADE_NOSE);  
  boca.loadCascade(OpenCV.CASCADE_MOUTH);  

  //   opencv.loadCascade("C:/Users/zero/Documents/Processing/libraries/opencv_processing/library/cascade-files/haarcascade_eye_tree_eyeglasses.xml",true);  
  video.start();

  println("cámara inicializada ----------------------");

  println("******************************************");
  
   

  loadIndex();

  f = new Face();

  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);

  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
 // myRemoteLocation = new NetAddress("192.168.1.100", 12001);
  myRemoteLocation = new NetAddress("127.0.0.1", 12001);

  c = new ArrayList();

  loadAmmountCriminals();

  loadCriminals();

  font = loadFont("OCRA.vlw");
  C20 = loadFont("C20.vlw");
  textFont(font);

  criminal_index = 0;

  likedness = new float[c.size()];

  shield = loadImage("shield.png");
  shield.filter(INVERT);

    header  = loadImage("header.png");
    img_comparando  = loadImage("comparando_datos.png");
    img_encontrado  = loadImage("perfil_encontrado.png");
    img_detectado  = loadImage("rostro_detectado.png");
    img_standby  = loadImage("texto_standby.png");


  state = "STAND BY";
  
 
  

  



}

//---------------------------------------------------------------------------------------

void draw() {
  
     frame.setLocation(HOME_X, HOME_Y);  // SOLO PARA EL MONTAJE DEL 2 DE NOV


  background(0);

  frame.setTitle(str(frameRate));

  updateStates();

  renderFeed(width/2-video.width/2, height/2-video.height/2 - 40);

  drawRawData();

  f.update();
  // renderFaceData(width/2-video.width/2, height/2-video.height/2);
 // renderState();
  renderMisc();
  
  if(RECFRAMES){
  
  saveFrame("anim2/line-######.tif");
  println("GRABANDO..." + frameCount);
  
  
  }
  
  drawBorder();
}

//-----------------------------------------------------------------------------------------------

void keyPressed() {

  if (key=='r' || key=='R') {

//    f.kill();
  } else  if (key=='d' || key=='D') {

    draw_raw =! draw_raw;
  }else  if (key=='b' || key=='B') {

    DRAWBORDER =! DRAWBORDER;
  }else  if (key=='f' || key=='F') {

    DRAWCOMPFRAME =! DRAWCOMPFRAME;
  }else  if (key=='s' || key=='S') {
    
    RECFRAMES = !RECFRAMES;

    //saveFrame("capture" + framecount + ".png");
  }
  
  
  
  positionKeys();
  
  
  
}

//-----------------------------------------------------------------------------------------------

void mousePressed() {

  if (state.equals("COMPARANDO")) {
  }
}

