/**************************
開發環境：Processing 2.0b3

說明：
-  本程式為作品texture的server端，需搭配client使用
        . server: texture_server
        . client: texture_client

- 本server程式負責協調各個client之間的畫面同步
        . client-server彼此之間透過osc溝通
        . server開啟後，會等待各個client的要求 (要求准許繪製下個frame)
        . 當每個client都送出要求至server後，server會發出准許的命令給每個client，然後每個client才能繪製下個frame
        . client每繪製完一個frame後，便送出准許繪製下個frame的要求給server
        . 以上步驟為循環步驟

- 本server程式執行起來後，會先產生一個random seed，供每個client使用，以便每個client取random時都能取得相同的亂數
        . random seed存放在server的data資料夾下，檔名為 randomseed.txt

- 本server程式同時也是texture作品的主要啟動程式
        . 啟動後會先進行基本設定
        . 然後根據設定，分別將每個client端執行起來 (only for windows & osx)
          . linux目前需使用另寫的shell script來分別執行

- auto-moving mouse's location to prevent show up!


TODO:
- 
***************************/


import oscP5.*;
import netP5.*;
import java.awt.*;


//for system
int monitor_x = 0;
int monitor_y = 0;
int screen_width = 300;
int screen_height = 150;
int frame_rate = 30;

//FOR CONTROL MOUSE
Robot robot = null;

//for garbage collector
GarbageCollector gc;

//for setting manager
SettingManager settingManager = null;

//for osc communicatoin with client
OscP5 oscP5;
int oscPort = 12000;
ArrayList<ClientInfo> clientList = null;
boolean isRunUpAllClient = false;
int runupIndex = 0;
int runupCounter = 0;
int runupCounterFinal = 90;

//for sound server
NetAddress mySoundRemoteLocation;
String soundServerIP = "127.0.0.1";
int soundServerOscPort = 13000;



////set frame undecorated to emulate full screen
//void init() {
//        frame.dispose();  
//        frame.setUndecorated(true);  
//        super.init();
//}


void setup(){
        //osc
        oscP5 = new OscP5(this, oscPort);
        oscP5.plug(this, "askNext", "/askNext");
//        oscP5.plug(this, "playSound", "/playSound");
        
//        //for sound server
//        mySoundRemoteLocation = new NetAddress(soundServerIP, soundServerOscPort);

        //load setting
        settingManager = new SettingManager();
        settingManager.load();

//        size(screen_width, screen_height, OPENGL);
        size(screen_width, screen_height);
        frameRate(frame_rate);
        
        //for gc
        gc = new GarbageCollector(1000);

        //for mouse control
        try{
          robot = new Robot();
          robot.mouseMove(2400, 300);
          println("mouse move!");
        }catch(AWTException e){
          e.printStackTrace();
        }

//        //set frame location to emulate full screen
//        frame.setLocation(monitor_x, monitor_y);

        //open sound server
        open("/Users/action/Desktop/sound_server/sound_server.app");
}


void draw(){
        background(38, 41, 44);
        
        //run up all clients
        if(!isRunUpAllClient){
                runupCounter = runupCounter + 1;
                runUpAllClients();
        }else{
                //check if going next
                int count = 0;
                for(ClientInfo client: clientList){
                        count = count + client.status;
                }
        
                //do next
                if(count >= clientList.size()){
                        for(ClientInfo client: clientList){
                                client.goNextFrame();
                        }
                }
        }
        

        //do garbage collection
        gc.runGC();
}


public void askNext(int clientID, int state){
        for(ClientInfo client: clientList){
                if(client.ID == clientID){
                        client.status = state;
                }
        }
}

//public void playSound(int clientID, int state){
//        OscMessage myMessage = new OscMessage("/playSound");
//        myMessage.add(1);
//        oscP5.send(myMessage, mySoundRemoteLocation); 
//}


//run up every client's app/exe
void runUpAllClients(){
        if(runupCounter > runupCounterFinal){
                if(clientList.size()>0){
                        clientList.get(runupIndex).runUp();
                        runupIndex = runupIndex + 1;
                        runupCounter = 0;
                        
                        if(runupIndex >= clientList.size()){
                                delay(10000);
                                isRunUpAllClient = true;
                        }
                }else{
                        println("no clients is created !!");
                        runupCounter = 0;
                }
        }
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
