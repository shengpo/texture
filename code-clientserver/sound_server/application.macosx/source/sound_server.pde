/**************************
開發環境：Processing 1.5.1

說明：


TODO:
-
***************************/


import oscP5.*;
import netP5.*;
import arb.soundcipher.*;


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


void setup(){
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

void draw(){
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


        sc.playNote(random(128), 127, 0.1);

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
