 //includes
import oscP5.*;
import netP5.*;

  
//globales
OscP5 oscP5;
NetAddress myRemoteLocation, myRemoteLocation16;

PGraphics s, m;

float r = 125;
float g = 55;
float b = 200;
float alpha = 100;
float x = 0;
float y = -300;
float start = 0;
int inf = 0;
int counter = 0;
void setup(){
  
  prepareExitHandler();
  
  // Receive packages
  oscP5 = new OscP5(this,14000);
  
  // Send Packages
  myRemoteLocation = new NetAddress("127.0.0.1",15000);
  myRemoteLocation16 = new NetAddress("127.0.0.1",16000);
  
  //size(1000,720,P2D);
  fullScreen(P2D,2);

  
  // Create a cookie cutter.
  // White areas are kept. Black areas are not.
  smooth(8);
  
  println(width);
  println(height);
  // Create a pattern.
  s = createGraphics( width, height, P2D );
  s.smooth(8);
  s.beginDraw();
  s.translate(s.width/2, s.height/2);
  //s.rotate(100);
  s.rotate( radians(90) );
  s.background(255,255,255,0);
  s.noStroke();
  s.fill( 0,255,0);
  rect(0,0, width, height);
  //for( int i = -300; i < 300; i+=10 ){
    //s.rect( i, -300, 5, 600);
  //}
  // This line uses the cookie cutter.
  
  s.endDraw(); 
  
  m = createGraphics( width, height, P2D );
  m.smooth(8);
  m.beginDraw();
  
  m.background(0);
  m.fill(255,0,0,100);
  m.stroke(255,0,0,0);
  m.translate(m.width/2, m.height/2);
  m.ellipse(0, 0, 250, 250);
  m.mask( s.get() );
  m.endDraw();
  
  //smooth(2);
  frameRate(30);
}

void draw(){
  
  if (inf == 0 ){
  background(0,0,0,0);
  inf = 1;
  }
  fill(0,0,0,10);
  rect(0,0,width,height);
  //image( s.get(), 0, 0);
  translate(s.width/2, s.height/2);
  //rotate( radians(90) );
  //background(0,0);
  noStroke();
  fill( r,g,b,alpha);
 // println(r);
  //println(g);
  //println(b);
  //float y = -300 + 30 * floor(random(0,20));
  //y = -300 + 30 * floor(random(0,20));
  y = -height/2 + 30 * floor(random(0,height/30));
  //y = -300 + 30 * (inf-1);
  x = -15 *(start);
  
  
  //println(counter)
  switch(counter) {
  case 0: 
    rect (-width/2, y, width, 20); // Square
    //rect (-300, y, 600, 20); // Square
    break;
  case 1: 
    rect (x, y, x*(-2),20);  // Triangle
    break;
  case 2:
    rect (-300 - x, y, 600 - x*(-2),20);  // Inverted triangle
    break;
 
  }
  
  inf = inf +1;
  if (inf > height/30){
    inf = 1;
    counter = int(random(0,3));
  }
  
  
  start++;
  if (start > width/30){
    start = 0;
    counter = int(random(0,3));
  }
    
  
  //
  
  //for( int i = -300; i < 300; i+=30 ){
    //rect( -300, i, 600, 20);
  //}
  
  translate(-s.width/2, -s.height/2);
  //image( m.get(), 0, 0);
  
  
  
  //OscMessage m = new OscMessage("/colors");
  //m.add(r);
  //m.add(g);
  //m.add(b);
  //m.add(alpha);
  //oscP5.send(m,myRemoteLocation);
  
}

void mouseClicked() {
  saveFrame("digitalTropical-##.png");
}
void stop(){
 println("stop");
 oscP5.stop(); 
}

private void prepareExitHandler () {

  Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {

    public void run () {

      System.out.println("SHUTDOWN HOOK");

      println("stop");
      oscP5.stop();
   // application exit code here
    }
  }));
}


void oscEvent(OscMessage theOscMessage) {
  /* check if theOscMessage has the address pattern we are looking for. */
  theOscMessage.print();
  
  if(theOscMessage.checkAddrPattern("/graphs/bg_color")==true) {
      
    //if(theOscMessage.checkTypetag("ffff")) {
     // println("simon");
      r = theOscMessage.get(0).floatValue(); 
      //r = theOscMessage.get(0).floatValue();  
      g = theOscMessage.get(1).floatValue();  
      b = theOscMessage.get(2).floatValue(); 
      alpha = theOscMessage.get(3).floatValue();
      
      OscMessage m = new OscMessage("/colors");
      m.add(r);
      m.add(g);
      m.add(b);
      m.add(alpha/255);
      oscP5.send(m,myRemoteLocation);
      oscP5.send(m,myRemoteLocation16);

      return;
    //}  
  }
}