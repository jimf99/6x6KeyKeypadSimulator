/*
 Project: A 6x6 matrix QWERTY keyboard for microcontrollers (Simulator)
 Software Date Started: 2017-Feb-07
 Software Date Updated: 2017-Feb-07
 Software Prototyped By: Jim F - Calgary Alberta Canada
 Hardware Board Designed By: Smitty Halibut / Twitter: @smittyhalibut
 === EXCELLENT RESOURCES FOR THIS KEYPAD ===
 Attributes & Special Thanks to ...
 OSHPark.com & Smitty Halibut (April 18, 2016)
 https://oshpark.com/profiles/SmittyHalibut/page/2
 -----------------------------------
 KB-66 v1.0b by  SmittyHalibut.
 -----------------------------------
 2 layer board of 2.81x1.56 inches (71.27x39.52 mm). 
 Shared on April 18th, 2016 03:38.
 A 6x6 matrix Qwerty keyboard for microcontrollers.
 Now with backspace!
 
 *///=== END COMMENTS =============================================

//=== BEGIN PROGRAM ===============================================
int mx1=0; // MouseX
int my1=0; //MouseY
int shft=0; //Shift Status

// Sending and Receiving UDP Characters
import processing.net.*;

// Declare a client for receiving
Client client;

// Declare a server for sending
Server server;

int ch=0;  // int ch = integer value of a keypad keypressed

PImage keypad; //front.png

void setup() {
  size(562, 312);

  // Image Source: OSHPark
  keypad = loadImage("front.png");
  image(keypad, 0, 0, 281*2, 156*2);

  // Create the Server
  server = new Server(this, 5204);

  // Create the Client
  client = new Client(this, "127.0.0.1", 5204);

  frameRate(60);
}

void draw() {
  listen();  // === When a mouse is clicked, simulate a keypad keypress
  if (ch>0) {
    background(255); // Clear the display area
    delay(100);
    image(keypad, 0, 0, 281*2, 156*2); // Display the keypad image
    server.write(char(ch)); // Send the keypad character 
    ch=0; // Clear the character code received
  }
}

//===============================================

void mousePressed() {
  //=== Check Mouse Coordinates, return a simulated keypress when mouse clicked

  // Draw a green ellipse
  color value=color(0, 255, 0);
  int sc=22;
  fill(value);
  int mx=mouseX-(sc/2);
  int my=mouseY-(sc/2);
  ellipse(mx+(sc/2), my+(sc/2), sc, sc);

  String keys1="~~~~~~~~~~~~";
  String keys2="~~~~~~~~~~~~";
  ch='~';
  mx1=((mouseX-98)/40)+1;
  my1=((mouseY-100)/60)+1;
  if (my1>=3 && my1<=3) {
    keys1="~ZXCVBNM,.?~~";
    keys2="~_"+'\\'+"|[]*+#@!~~";
  }
  if (my1>=2 && my1<=2) {
    keys1="~ASDFGHJKL~~";
    keys2="--/:;()$'"+'"'+"~~";
  }
  if (my1>=1 && my1<=1) {
    keys1="~QWERTYUIOP~";
    keys2="~1234567890~";
  }
  if (my1==3 && mx1>7 && shft==1) {
    shft=2;
  }
  if (mx1>=0 && mx1<=11) {
    if (shft==2) {
      keys1=keys2;
      shft=0;
    }
    ch=keys1.charAt(mx1);
  }

  // === Check Shift and Function Buttons

  // Escape
  if (my1==1 && mx1==0) {
    ch=128;
  }
  
  // BackSpace
  if (my1==2 && mx1==0) {
    ch=129;
  }
  
  // Shift
  if (my1==3 && mx1==0) {
    ch=130;
  }
  
  // UP
  if (my1==1 && mx1==11) {
    ch=131;
  }
  
  // ENTER
  if (my1==2 && mx1==11) {
    ch=132;
  }
  
  // DOWN
  if (my1==3 && mx1==11) {
    ch=133;
  }
  
  // SPACE
  if (my1==4 && mx1==5) {
    ch=134;
  }
}

// === Used for Communication ===
void listen() {
  String msg="";
  if (client.available()>0) {
    int ch1=client.read();
    if (ch1>127) {
      ch1=(ch1-128)+'a';
    }
    msg=nf(mx1, 2)+" "+nf(my1, 2);
    msg=msg+" ";
    if (ch1=='a') {
      msg=msg+"ESC ";
      shft=0;
    }
    if (ch1=='b') {
      msg=msg+"BKSP ";
      shft=0;
    }
    if (ch1=='c') {
      shft=shft+1;
      if (shft>2) {
        shft=0;
      }
      msg=msg+"SHIFT "+nf(shft, 0);
    }
    if (ch1=='d') {
      msg=msg+"UP ";
      shft=0;
    }
    if (ch1=='e') {
      msg=msg+"ENTER ";
      shft=0;
    }
    if (ch1=='f') {
      msg=msg+"DOWN ";
      shft=0;
    }
    if (ch1=='g') {
      msg=msg+"SPACE ";
      shft=0;
    }
    if (ch1>='A' && ch1<='Z') {
      if (shft==0) {
        ch1=ch1+32;
      }
      shft=0;
    }
    println(char(ch1) + " " +msg);
  }
}