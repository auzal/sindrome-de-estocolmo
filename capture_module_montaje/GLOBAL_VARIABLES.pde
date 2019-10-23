
Capture video;
OpenCV opencv;
OpenCV ojos;
OpenCV nariz;
OpenCV boca;

Rectangle[] faces;
Rectangle[] eyes;
Rectangle[] noses;
Rectangle[] mouths;

boolean draw_raw;

int suspect_index;

Face f;

FaceNorm f_n;

ArrayList <FaceNormCompact> c;

int ammount_criminals;

OscP5 oscP5;
NetAddress myRemoteLocation;

String state;

PFont font;
PFont C20;

int criminal_index;

float [] likedness;

int which_criminal;

PImage dithered_video;

PImage shield;

int final_trigger;

int detection_trigger;

int comparison_trigger;

int results_trigger;

int dot_anim_control = 0;
int x_anim_control = 0;

PImage header;
PImage img_comparando;
PImage img_encontrado;
PImage img_detectado;
PImage img_standby;


