import TUIO.*;
import java.io.*;
import java.awt.*;
import java.awt.event.*;
import java.util.*;
import processing.video.*;
import ddf.minim.*;
TuioProcessing tuioClient;
import processing.net.*;

Server myServer;
int port = 1234;

Client myClient;

float scale_factor = 1;
PFont font;

TuioObject tobjTempq;
TuioObject tobj;

void setup()
{
  frameRate(1);
  size(800, 600);
  noStroke();
  fill(0);

  hint(ENABLE_NATIVE_FONTS);
  font = createFont("Arial", 18);

  myServer = new Server(this, port);

  tuioClient  = new TuioProcessing(this);
}

void draw()
{
  stroke(0);
  noFill();
  rect(100, 100, 600, 400);
  textFont(font, 18*scale_factor);

  stroke(255);
  fill(0, 200);

  Vector tuioObjectList =  tuioClient.getTuioObjects();
  // myServer.write(" "+tuioObjectList.size());
  if (tuioObjectList.size() ==0) {
    myServer.write("0 end\n");
  }

  if (tuioObjectList.size() >0) {

    for (int x = 0; x<tuioObjectList.size(); x++ ) {

      tobjTempq = (TuioObject)tuioObjectList.elementAt(x);
      float xx =  tobjTempq.getScreenX(width);    
      float yy =  tobjTempq.getScreenY(height);
      
      float angle = tobjTempq.getAngleDegrees();
      String angledeg = nf (angle, 3, 2);
      
      float rad = radians(angle);
      
      float finxx = xx+5*sin(rad);
      float finyy = yy-5*cos(rad);
            
      String xcoord = nf(finxx, 3,2);
      String ycoord = nf(finyy, 3,2);

      String number = nf (tuioObjectList.size(), 2);
            
      //float rad = radians(angle);
      
      String writetelnet = number + " " + tobjTempq.getSymbolID()+ " "+ xcoord + " " + ycoord + " " + angledeg;
      print (writetelnet);

      myServer.write(writetelnet);
      // print("   "+tobjTempq.getSymbolID()+"  "+xx+"  "+yy+ "   "+angle);
      //  myServer.write(""+tobjTempq.getSymbolID()+" "+xx+" "+yy+ " "+angle);

      // if (x== (tuioObjectList.size()-1)){
      // myServer.write("\n");
      // }

      //  myClient.write(" ("+tuioObjectList.size()+")"+"   "+tobjTempq.getSymbolID()+"  "+xx+"  "+yy+ "   \n"+angle);
    }
    myServer.write(" end\n");
    print("\n");
  }
}

