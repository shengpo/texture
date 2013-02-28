public class LineSprite {
        private PVector v1 = null;    //起點
        private PVector v2 = null;    //終點
        private PVector m = null;    //中點
        private float length = 0;                    //長度 (or 高度)
        private float weight = 1;                     //line的weight
        private float left_distance = 0;           //左邊or下面：距離 (or 寬度)
        private float right_distance = 0;         //右邊or上面：距離 (or 寬度)
        private int spriteColor = 0;

        private int mode = 0;
        
        //for animation
        private int step = 30;
        private float alphavalue = 255;
        private float talphavalue = 255;
        private float distance = 0;
        private int strechMode = 0;        //伸展模式
        private PVector tm = null;
        private float tlength = 0;
        private float olength = 0;

        //for sound server
        NetAddress mySoundRemoteLocation;
        String soundServerIP = "127.0.0.1";
        int soundServerOscPort = 13000;


        public LineSprite(PVector v1, PVector v2, PVector m, float length, float weight, float left_distance, float right_distance, int mode) {
                this.v1 = v1;
                this.v2 = v2;
                this.m = m;
                this.length = length;
                this.weight = weight;
                this.left_distance = left_distance;
                this.right_distance = right_distance;
                this.mode = mode;
                
                initMode();
                
                //for sound server
                mySoundRemoteLocation = new NetAddress(soundServerIP, soundServerOscPort);
        }

        
        private void initMode(){
                switch(mode){
                        case 0:        //靜止不動
                                        spriteColor = color(0);
                                        alphavalue = 255;
                                        break;
                        case 1:        //fade in/out
                                        spriteColor = color(0);
                                        talphavalue = 0;
                                        step = 120;
                                        break;
                        case 2:         //垂直線: 左右伸縮長條形
                        case 3:        //橫線: 上下伸縮長條形
                                        spriteColor = color(0);
                                        strechMode = 0;
                                        distance = 0;
                                        step = 60;
                                        glg.rectMode(CORNERS);
                                        break;
                        case 4:        //垂直線: n個左右移動的橫線
                        case 5:        //橫線: n個上下移動的橫線
                                        spriteColor = color(0);
                                        alphavalue = 120;
                                        strechMode = 0;
                                        distance = 0;
                                        step = (int)random(30, 90);
                                        break;
                        case 6:        //垂直線: n個上下移動的線段
                                        spriteColor = color(0);
                                        alphavalue = 100;
                                        olength = length;
                                        tlength = random(length*0.1, length*0.3);
                                        tm = new PVector(m.x, m.y+random(-length*0.3, length*0.3));
                                        step = (int)random(30, 120);
                                        break;
                        case 7:        //橫線: n個左右移動的線段
                                        spriteColor = color(0);
                                        alphavalue = 100;
                                        olength = length;
                                        tlength = random(length*0.1, length*0.3);
                                        tm = new PVector(m.x+random(-length*0.3, length*0.3), m.y);
                                        step = (int)random(30, 120);
                                        break;
                }
        }


        public void update() {
                spriteColor = color(0);
                switch(mode){
                        case 0:        //靜止不動
                                        //do nothing
                                        break;
                        case 1:        //fade in/out
                                        alphavalue = alphavalue + (talphavalue-alphavalue)/step;
                                        if(talphavalue==255 && abs(talphavalue-alphavalue)<1){
                                                talphavalue = 0;
                                                playSound();
                                        }else  if(talphavalue==0 && abs(talphavalue-alphavalue)<1){
                                                talphavalue = 255;
                                                playSound();
                                        }
                                        break;
                        case 2:        //垂直線: 左右伸縮長條形
                        case 3:        //橫線: 上下伸縮長條形
                                        if(strechMode == 0){
                                                distance = distance + (left_distance-distance)/step;
                                                if(abs(distance-left_distance)<0.1){
                                                        strechMode = (strechMode+1)%4;
                                                        playSound();
                                                }
                                        }else if(strechMode == 1){
                                                distance = distance + (0-distance)/step;
                                                if(abs(distance-0)<0.1){
                                                        strechMode = (strechMode+1)%4;
                                                        playSound();
                                                }
                                        }else if(strechMode == 2){
                                                distance = distance + (right_distance-distance)/step;
                                                if(abs(distance-right_distance)<0.1){
                                                        strechMode = (strechMode+1)%4;
                                                        playSound();
                                                }
                                        }else{
                                                distance = distance + (0-distance)/step;
                                                if(abs(distance-0)<0.1){
                                                        strechMode = (strechMode+1)%4;
                                                        playSound();
                                                }
                                        }
                                        break;
                        case 4:        //垂直線: n個左右移動的橫線
                        case 5:        //橫線: n個上下移動的橫線
                                        if(strechMode == 0){
                                                distance = distance + (left_distance-distance)/step;
                                                if(abs(distance-left_distance)<0.1){
                                                        strechMode = (strechMode+1)%4;
                                                        playSound();
                                                }
                                        }else if(strechMode == 1){
                                                distance = distance + (0-distance)/step;
                                                if(abs(distance-0)<0.1){
                                                        strechMode = (strechMode+1)%4;
                                                        playSound();
                                                }
                                        }else if(strechMode == 2){
                                                distance = distance + (right_distance-distance)/step;
                                                if(abs(distance-right_distance)<0.1){
                                                        strechMode = (strechMode+1)%4;
                                                        playSound();
                                                }
                                        }else{
                                                distance = distance + (0-distance)/step;
                                                if(abs(distance-0)<0.1){
                                                        strechMode = (strechMode+1)%4;
                                                        playSound();
                                                }
                                        }
                                        break;
                        case 6:        //垂直線: n個上下移動的線段
                                        m = PVector.add(m, PVector.div(PVector.sub(tm, m), step));
                                        length = length + (tlength-length)/step;
                                        
                                        if(PVector.dist(m, tm) < 0.1){
                                                tm = new PVector(m.x, random(v1.y, v2.y));
                                                playSound();
                                        }
                                        if(abs(length-tlength) < 0.1){
                                                tlength = random(olength*0.1, olength*0.3);
                                        }
                        case 7:        //橫線: n個左右移動的線段
                                        m = PVector.add(m, PVector.div(PVector.sub(tm, m), step));
                                        length = length + (tlength-length)/step;
                                        
                                        if(PVector.dist(m, tm) < 0.1){
                                                tm = new PVector(random(v1.x, v2.x), m.y);
                                                playSound();
                                        }
                                        if(abs(length-tlength) < 0.1){
                                                tlength = random(olength*0.1, olength*0.3);
                                        }
                                        break;
                }
        }


        public void show() {
                switch(mode){
                        case 0:        //靜止不動
                                        glg.strokeWeight(weight);
                                        glg.stroke(spriteColor, alphavalue);
                                        glg.line(v1.x, v1.y, v2.x, v2.y);
                                        break;
                        case 1:        //fade in/out
                                        glg.strokeWeight(weight);
                                        glg.stroke(spriteColor, alphavalue);
                                        glg.line(v1.x, v1.y, v2.x, v2.y);
                                        break;
                        case 2:         //垂直線: 左右伸縮長條形
                                        glg.strokeWeight(weight);
                                        glg.stroke(spriteColor, alphavalue);
                                        glg.fill(spriteColor, alphavalue);
                                        if(strechMode < 2){
                                                glg.rect(v1.x, v1.y, v2.x-distance, v2.y);
                                        }else{
                                                glg.rect(v1.x, v1.y, v2.x+distance, v2.y);
                                        }
                                        break;
                        case 3:        //橫線: 上下伸縮長條形
                                        glg.strokeWeight(weight);
                                        glg.stroke(spriteColor, alphavalue);
                                        glg.fill(spriteColor, alphavalue);
                                        if(strechMode < 2){
                                                glg.rect(v1.x, v1.y, v2.x, v2.y+distance);
                                        }else{
                                                glg.rect(v1.x, v1.y, v2.x, v2.y-distance);
                                        }
                                        break;
                        case 4:        //垂直線: n個左右移動的橫線
                                        glg.strokeWeight(weight);
                                        glg.stroke(spriteColor, alphavalue);
                                        if(strechMode < 2){
                                                glg.line(v1.x-distance, v1.y, v2.x-distance, v2.y);
                                        }else{
                                                glg.line(v1.x+distance, v1.y, v2.x+distance, v2.y);
                                        }
                                        break;
                        case 5:         //橫線: n個上下移動的橫線
                                        glg.strokeWeight(weight);
                                        glg.stroke(spriteColor, alphavalue);
                                        if(strechMode < 2){
                                                glg.line(v1.x, v1.y+distance, v2.x, v2.y+distance);
                                        }else{
                                                glg.line(v1.x, v1.y-distance, v2.x, v2.y-distance);
                                        }
                                        break;
                        case 6:        //垂直線: n個上下移動的線段
                                        glg.strokeWeight(weight);
                                        glg.stroke(spriteColor, alphavalue);
                                        glg.line(m.x, m.y-length/2, m.x, m.y+length/2);
                                        break;
                        case 7:        //橫線: n個左右移動的線段
                                        glg.strokeWeight(weight);
                                        glg.stroke(spriteColor, alphavalue);
                                        glg.line(m.x-length/2, m.y, m.x+length/2, m.y);
                                        break;
                }
        }
        
        private void playSound(){
                OscMessage myMessage = new OscMessage("/playSound");
                myMessage.add(1);
                oscP5.send(myMessage, mySoundRemoteLocation); 

//                OscMessage myMessage = new OscMessage("/playSound");
//                myMessage.add(clientID);
//                myMessage.add(1);
//                oscP5.send(myMessage, myRemoteLocation); 
                
                spriteColor = color(255, 0, 0);
        }
}

