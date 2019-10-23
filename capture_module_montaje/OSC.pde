  void sendNotification(){

/* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage("/nuevo");
  
  myMessage.add(suspect_index); /* add an int to the osc message */
 // myMessage.add(new byte[] {0x00, 0x01, 0x10, 0x20}); /* add a byte blob to the osc message */
  //myMessage.add(new int[] {1,2,3,4}); /* add an int array to the osc message */

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
}
