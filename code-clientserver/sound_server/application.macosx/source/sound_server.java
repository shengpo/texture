import processing.core.*; 
import processing.xml.*; 

import oscP5.*; 
import netP5.*; 
import arb.soundcipher.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class sound_server extends PApplet {

/**************************
\u958b\u767c\u74b0\u5883\uff1aProcessing 1.5.1

\u8aaa\u660e\uff1a


TODO:
-
***************************/







//for system
int monitor_x = 0;
int monitor_y = 0;
int screen_width = 300;
int screen_height = 150;
int frame_rate = 30;


//for garbage collector
GarbageCollector gc;

//for setting manager
SettingManager settingManager = null;

//for osc communicatoin with client
OscP5 oscP5;
int oscPort = 13000;

//for sound
SoundCipher sc = null;




////set frame undecorated to emulate full screen
//void init() {
//        frame.dispose();  
//        frame.setUndecorated(true);  
//        super.init();
//}


public void setup(){
        //osc
        oscP5 = new OscP5(this, oscPort);
        oscP5.plug(this, "playSound", "/playSound");

        //load setting
        settingManager = new SettingManager();
        settingManager.load();

//        size(screen_width, screen_height, OPENGL);
        size(screen_width, screen_height);
        frameRate(frame_rate);
        
        //for sound
        sc = new SoundCipher(this);
        sc.instrument = sc.WOODBLOCK;        //set instrument
//        sc.instrument = sc.BARITONE_SAX;
//        sc.instrument = 34;

        //for gc
        gc = new GarbageCollector(1000);
        

//        //set frame location to emulate full screen
//        frame.setLocation(monitor_x, monitor_y);
}

public void draw(){
        background(38*2, 41, 44);
                
        //do garbage collection
        gc.runGC();
}

int counter = 0;
public void playSound(int state){
//        counter = counter + state;
//        if(counter >= 3){
//                sc.playNote(random(128), 127, 0.1);
//                counter = 0;
//        }


        sc.playNote(random(128), 127, 0.1f);

//        float[] pitches = {random(84, 128), random(84, 128), random(84, 128), random(84, 128)};        //play random chord
//        sc.playChord(pitches, 127, 1);
}


////for test
//int instr = 75;
//void keyPressed(){
//  if(key == ' '){
//          println("instrument = " + instr);
//          sc.instrument = instr;  
//          
//          instr = instr + 1;
//          if(instr > 127){
//            instr = 0;
//          }
//  }
//}
public class GarbageCollector {
        private int counter = 0;
        private int counterFinal = 1000;        //do the garbage collection when the counterFinal value is reached
        
        
        public GarbageCollector(int counterFinal){
                this.counterFinal = counterFinal;
        }

        public void runGC(){
                counter = counter + 1;        //gc counter
                if(counter > counterFinal){
                        counter = 0;
                        System.gc();
                        System.out.println("--> run the java garbage collection");
                }
        }
}

public class SettingManager {
        private String settingFilePath = "";

        
        public SettingManager(){
                //set setting file path
                settingFilePath = dataPath("setting.txt");
        }
        
        
        public void load(){
                String line = null;
                BufferedReader reader = createReader(settingFilePath); 

                while (true) {
                        try {
                                line = reader.readLine();
                        }catch(IOException e) {
                                e.printStackTrace();
                                line = null;
                                break;
                        }

                        if (line != null) {
                                if (line.length() > 0) {
                                        String[] pieces = split(line, " ");

                                        if (pieces[0].equals("frameRate:")) {
                                                frame_rate = PApplet.parseInt(pieces[1]);
                                        }
                                        if (pieces[0].equals("MonitorLocation:")) {
                                                monitor_x = PApplet.parseInt(pieces[1]);
                                                monitor_y = PApplet.parseInt(pieces[2]);
                                        }
                                        if (pieces[0].equals("ScreenSize:")) {
                                                screen_width = PApplet.parseInt(pieces[1]);
                                                screen_height = PApplet.parseInt(pieces[2]);
                                        }
                                        if (pieces[0].equals("oscPort:")) {
                                                oscPort = PApplet.parseInt(pieces[1]);
                                        }
                                }
                        }else {
                                //error occured or file is empty
                                break;
                        }
                }
        }
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "sound_server" });
  }
}
