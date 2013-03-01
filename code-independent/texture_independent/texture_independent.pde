/***********************
 [about texture project]
 https://github.com/shengpo/texture
 
 [about texture-independent code]
 https://github.com/shengpo/texture/tree/master/code-independent

 [Author]
 Shen, Sheng-Po (http://shengpo.github.com)
 
 [License]
 CC BY-SA 3.0 
 ***********************/

import arb.soundcipher.*;


//for system
int screen_width = 1024;
int screen_height = 768;
int screen_x = 0;
int screen_y = 0;

//for garbage collector
GarbageCollector gc = null;
float gcPeriodMinute = 5;    //設定幾分鐘做一次gc

//for setting manager
SettingManager settingManager = null;


//for lines
ArrayList<XLine> vlineList = null;
ArrayList<XLine> hlineList = null;
int vlineIndex = -1;
int hlineIndex = -1;
XLine curline = null;

//for director
Director director = null;

//for setting mode
PVector down = new PVector(0, 1);
PVector up = new PVector(0, -1);
PVector left = new PVector(-1, 0);
PVector right = new PVector(1, 0);
boolean isSettingMode = false;

//for sound
SoundMaker soundMaker = null;




//set frame undecorated to emulate full screen
void init() {
        frame.dispose();  
        frame.setUndecorated(true);  
        super.init();
}


void setup() {
        //load setting
        settingManager = new SettingManager();
        settingManager.load();

        size(screen_width, screen_height, P3D);
        background(255);
        
        //director
        director = new Director();
        director.turnOnAllLineAnimationMode();        //at first, turn on the anomation!

        //for sound
        soundMaker = new SoundMaker(this);

        //for garbage collector
        gc = new GarbageCollector(gcPeriodMinute);
        gc.start();

        //set frame location to emulate full screen
        frame.setLocation(screen_x, screen_y);
}


void draw() {
        if(isSettingMode){
                background(255, 226, 180);
        }else{
                background(255);
        }
        
        //show
        director.GO();
        director.nextGO();
}


void unSelectedAllLine(){
        for(XLine xl: vlineList){
                xl.turnOnNormalMode();
        }
        for(XLine xl: hlineList){
                xl.turnOnNormalMode();
        }
}



void keyPressed(){
        if(key == 'a'){
                director.turnOnAllLineAnimationMode();
        }
        
        if(key == 'c'){
                director.selectAnimationMode(-1);        //-1 means to select random animation mode
        }
        
        if(int(key)>=48 && int(key)<=57){        //按數字0~9
                director.selectAnimationMode(int(key)-48);
        }

        if(key=='s' || key=='S'){
                unSelectedAllLine();
                
                if(isSettingMode){
                        isSettingMode = false;
                        settingManager.save();
                }else{
                        isSettingMode = true;
                }
                
                println("[setting mode]: " + isSettingMode);
        }
        
        if(isSettingMode){
                if(key == 'd'){
                        if(curline!=null && curline.getLineMode()==1){        //vertical line
                                if(vlineList.size() > 0){
                                        vlineList.remove(vlineIndex);
                                        println("[V Line deleting]: " + vlineIndex);
        
                                        if(vlineList.size() > 0){
                                                if(vlineIndex > vlineList.size()-1){
                                                        vlineIndex = 0;
                                                }
                                                curline = vlineList.get(vlineIndex);
                                                curline.turnOnSettingMode();
                                                println("[V Line setting]: " + vlineIndex);
                                        }
                                }
                        }

                        if(curline!=null && curline.getLineMode()==0){        //horizontal line
                                if(hlineList.size() > 0){
                                        hlineList.remove(hlineIndex);
                                        println("[H Line deleting]: " + hlineIndex);
        
                                        if(hlineList.size() > 0){
                                                if(hlineIndex > hlineList.size()-1){
                                                        hlineIndex = 0;
                                                }
                                                curline = hlineList.get(hlineIndex);
                                                curline.turnOnSettingMode();
                                                println("[H Line setting]: " + hlineIndex);
                                        }
                                }
                        }
                }
                
                if(key == 'v'){
                        unSelectedAllLine();
                        
                        XLine vl = new XLine(new PVector(width/2, 0), height, 1, 0, 0, 1);
                        vl.turnOnSettingMode();
                        curline = vl;
                        
                        vlineList.add(vl);
                        println("[V Line]: add");
                }
        
                if(key == 'h'){
                        unSelectedAllLine();

                        XLine hl = new XLine(new PVector(0, height/2), width, 1, 0, 0, 0);
                        hl.turnOnSettingMode();
                        curline = hl;

                        hlineList.add(hl);
                        println("[H Line]: add");
                }
        
                if(key == 'V'){
                        unSelectedAllLine();
                        
                        if(vlineIndex < 0){
                                vlineIndex = 0;
                        }else{
                                vlineIndex = vlineIndex + 1;
                                if(vlineIndex > vlineList.size()-1){
                                        vlineIndex = 0;
                                }
                        }
                        
                        if(vlineList.size() > 0){
                                curline = vlineList.get(vlineIndex);
                                curline.turnOnSettingMode();
                                println("[V Line setting]: " + vlineIndex);
                        }
                }
        
                if(key == 'H'){
                        unSelectedAllLine();
                        
                        if(hlineIndex < 0){
                                hlineIndex = 0;
                        }else{
                                hlineIndex = hlineIndex + 1;
                                if(hlineIndex > hlineList.size()-1){
                                        hlineIndex = 0;
                                }
                        }
                        
                        if(hlineList.size() > 0){
                                curline = hlineList.get(hlineIndex);
                                curline.turnOnSettingMode();
                                println("[H Line setting]: " + hlineIndex);
                        }
                }
                
                if(key == '['){        //減少
                        curline.shiftRightDistance(-1);
                }
                if(key == ']'){        //增加
                        curline.shiftRightDistance(1);
                }
                if(key == '{'){        //減少
                        curline.shiftLeftDistance(-1);
                }
                if(key == '}'){        //增加
                        curline.shiftLeftDistance(1);
                }
                
                if(key == 'w'){
                        curline.addWeight(-1);
                }
                if(key == 'W'){
                        curline.addWeight(1);
                }

                if(keyCode == UP){
                        if(curline != null){

                                PVector v = curline.getStartVertex();
                                curline.setLineFromStart(PVector.add(v, up));
                        }
                }
                if(keyCode == DOWN){
                        if(curline != null){
                                PVector v = curline.getStartVertex();
                                curline.setLineFromStart(PVector.add(v, down));
                        }
                }
                if(keyCode == LEFT){
                        if(curline != null){
                                PVector v = curline.getStartVertex();
                                curline.setLineFromStart(PVector.add(v, left));
                        }
                }
                if(keyCode == RIGHT){
                        if(curline != null){
                                PVector v = curline.getStartVertex();
                                curline.setLineFromStart(PVector.add(v, right));
                        }
                }
        }
}
