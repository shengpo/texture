/**************************
 開發環境：Processing 2.0b3
 
 
 執行說明：
-  此為獨立執行版本!
 - 開啟程式後，會自動進入動畫模式
 - 進入設定模式時
        . 被選擇的線為藍色, 沒被選到的為黑線
        . 紅點為線的pivot點 (作為參考點)
        . 橫線的參考點(pivot點)預設為最左邊的點 (向右畫線)
        . 直線的參考點(pivot點)預設為最上面的點 (向下畫線)
 - 設定完後，按小寫a，從新啟動動畫       
 - 目前共有 8種 animation模式, 按0~7數字鍵可以直接跳至該模式
 
 
 設定說明：
 - 按小寫a                將所有的line都啟動animation mode
 - 按小寫c                更換animation 
 
 - 按s或S                  開/關設定模式
 - 按小寫v                在螢幕中央產生垂直線 (高度等同畫面高度)
 - 按小寫h                在螢幕中央產生橫線 (長度等同畫面寬度)
 - 按大寫V                依序選擇要設定的垂直線
 - 按大寫H                依序選擇要設定的橫線
 - 按上下左右鍵        移動目前正在設定的線(直線或橫線)
                                . 目前皆以最左邊的點or做上面的點作為起始點
 - 按 { 或 }                減少or增加目前所選定的線距離下面or左邊的線的距離 
 - 按 [ 或 ]                減少or增加目前所選定的線距離上面or右邊的線的距離 
 - 按小寫w               減少線的粗細(weight)
 - 按大寫W               增加線的粗細(weight)
 - 按小寫d                刪除正在編輯的線

 **************************/

//for system
int screen_width = 1024;
int screen_height = 768;
int screen_x = 0;
int screen_y = 0;

//for garbage collector
GarbageCollector gc;

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

//for setting
PVector down = new PVector(0, 1);
PVector up = new PVector(0, -1);
PVector left = new PVector(-1, 0);
PVector right = new PVector(1, 0);
boolean isSettingMode = false;



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

        size(screen_width, screen_height, OPENGL);
        background(255);
        
        //director
        director = new Director();
        director.turnOnAllLineAnimationMode();        //at first, turn on the anomation!

        //for gc
        gc = new GarbageCollector(1000);

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

        //do garbage collection
        gc.runGC();
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
                director.selectAnimationMode(-1);
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
                                curline.setStartVertex(PVector.add(v, up));
                        }
                }
                if(keyCode == DOWN){
                        if(curline != null){
                                PVector v = curline.getStartVertex();
                                curline.setStartVertex(PVector.add(v, down));
                        }
                }
                if(keyCode == LEFT){
                        if(curline != null){
                                PVector v = curline.getStartVertex();
                                curline.setStartVertex(PVector.add(v, left));
                        }
                }
                if(keyCode == RIGHT){
                        if(curline != null){
                                PVector v = curline.getStartVertex();
                                curline.setStartVertex(PVector.add(v, right));
                        }
                }
        }
}
