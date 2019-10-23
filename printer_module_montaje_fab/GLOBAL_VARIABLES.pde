//Serial myPort; 

Serial keyPort;

ArrayList <FaceNormCompact> f;

int suspects_number;

int index;

int select_index = 0;

boolean manual_select  = false;

int select_trigger = 0;

int manual_select_timeout = 2000;

String estado;

PFont font;

PFont header;

PFont H20;

PFont O15;

PFont H15;

PFont ocra_21;

PFont ocra_14;

PFont ocra_16;

PFont helvetica_16;

int [][] renglon;

int indice;

int indice_cargos;

OscP5 oscP5;
NetAddress myRemoteLocation;

NetAddress printerAddress;
  

boolean load_flag;

int index_to_load;

GestorCargaLive gestor_carga;

PImage qr_t;

PImage qr_c;

PImage empty_ticket;

PImage header_img;

PImage footer;

PImage qr_bound;

int global_prints = 0;

String []dias = {"Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sabado"};

String []meses = {"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"};

Calendar c;

int printer_timer_trigger;

int printer_wait = 25000;



