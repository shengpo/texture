public class LineSprite {
        private PVector v1 = null;    //起點
        private PVector v2 = null;    //終點
        private PVector m = null;    //中點
        private float length = 0;                    //長度 (or 高度)
        private float weight = 1;                     //line的weight
        private float left_distance = 0;           //左邊or下面：距離 (or 寬度)
        private float right_distance = 0;         //右邊or上面：距離 (or 寬度)
        private int spriteColor = 0;

        //animation mode
        private int mode = 0;
        
        //for animation
        private int step = 30;
        private float alphavalue = 255;
        private float talphavalue = 255;
        private float distance = 0;
        private int stretchMode = 0;        //伸展模式
        private PVector tm = null;
        private float tlength = 0;
        private float olength = 0;


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
                                        stretchMode = 0;
                                        distance = 0;
                                        step = 60;
                                        rectMode(CORNERS);
                                        break;
                        case 4:        //垂直線: n個左右移動的直線
                        case 5:        //橫線: n個上下移動的橫線
                                        spriteColor = color(0);
                                        alphavalue = 120;
                                        stretchMode = 0;
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
                switch(mode){
                        case 0:        //靜止不動
                                        //do nothing
                                        break;
                        case 1:        //fade in/out
                                        alphavalue = alphavalue + (talphavalue-alphavalue)/step;
                                        if(talphavalue==255 && abs(talphavalue-alphavalue)<1){
                                                talphavalue = 0;
                                        }else  if(talphavalue==0 && abs(talphavalue-alphavalue)<1){
                                                talphavalue = 255;
                                        }
                                        break;
                        case 2:        //垂直線: 左右伸縮長條形
                        case 3:        //橫線: 上下伸縮長條形
                                        if(stretchMode == 0){
                                                distance = distance + (left_distance-distance)/step;
                                                if(abs(distance-left_distance)<0.1){
                                                        stretchMode = (stretchMode+1)%4;
                                                }
                                        }else if(stretchMode == 1){
                                                distance = distance + (0-distance)/step;
                                                if(abs(distance-0)<0.1){
                                                        stretchMode = (stretchMode+1)%4;
                                                }
                                        }else if(stretchMode == 2){
                                                distance = distance + (right_distance-distance)/step;
                                                if(abs(distance-right_distance)<0.1){
                                                        stretchMode = (stretchMode+1)%4;
                                                }
                                        }else{
                                                distance = distance + (0-distance)/step;
                                                if(abs(distance-0)<0.1){
                                                        stretchMode = (stretchMode+1)%4;
                                                }
                                        }
                                        break;
                        case 4:        //垂直線: n個左右移動的橫線
                        case 5:        //橫線: n個上下移動的橫線
                                        if(stretchMode == 0){
                                                distance = distance + (left_distance-distance)/step;
                                                if(abs(distance-left_distance)<0.1){
                                                        stretchMode = (stretchMode+1)%4;
                                                }
                                        }else if(stretchMode == 1){
                                                distance = distance + (0-distance)/step;
                                                if(abs(distance-0)<0.1){
                                                        stretchMode = (stretchMode+1)%4;
                                                }
                                        }else if(stretchMode == 2){
                                                distance = distance + (right_distance-distance)/step;
                                                if(abs(distance-right_distance)<0.1){
                                                        stretchMode = (stretchMode+1)%4;
                                                }
                                        }else{
                                                distance = distance + (0-distance)/step;
                                                if(abs(distance-0)<0.1){
                                                        stretchMode = (stretchMode+1)%4;
                                                }
                                        }
                                        break;
                        case 6:        //垂直線: n個上下移動的線段
                                        m = PVector.add(m, PVector.div(PVector.sub(tm, m), step));
                                        length = length + (tlength-length)/step;
                                        
                                        if(PVector.dist(m, tm) < 0.1){
                                                tm = new PVector(m.x, random(v1.y, v2.y));
                                        }
                                        if(abs(length-tlength) < 0.1){
                                                tlength = random(olength*0.1, olength*0.3);
                                        }
                        case 7:        //橫線: n個左右移動的線段
                                        m = PVector.add(m, PVector.div(PVector.sub(tm, m), step));
                                        length = length + (tlength-length)/step;
                                        
                                        if(PVector.dist(m, tm) < 0.1){
                                                tm = new PVector(random(v1.x, v2.x), m.y);
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
                                        strokeWeight(weight);
                                        stroke(spriteColor, alphavalue);
                                        line(v1.x, v1.y, v2.x, v2.y);
                                        break;
                        case 1:        //fade in/out
                                        strokeWeight(weight);
                                        stroke(spriteColor, alphavalue);
                                        line(v1.x, v1.y, v2.x, v2.y);
                                        break;
                        case 2:         //垂直線: 左右伸縮長條形
                                        strokeWeight(weight);
                                        stroke(spriteColor, alphavalue);
                                        fill(spriteColor, alphavalue);
                                        if(stretchMode < 2){
                                                rect(v1.x, v1.y, v2.x-distance, v2.y);
                                        }else{
                                                rect(v1.x, v1.y, v2.x+distance, v2.y);
                                        }
                                        break;
                        case 3:        //橫線: 上下伸縮長條形
                                        strokeWeight(weight);
                                        stroke(spriteColor, alphavalue);
                                        fill(spriteColor, alphavalue);
                                        if(stretchMode < 2){
                                                rect(v1.x, v1.y, v2.x, v2.y+distance);
                                        }else{
                                                rect(v1.x, v1.y, v2.x, v2.y-distance);
                                        }
                                        break;
                        case 4:        //垂直線: n個左右移動的橫線
                                        strokeWeight(weight);
                                        stroke(spriteColor, alphavalue);
                                        if(stretchMode < 2){
                                                line(v1.x-distance, v1.y, v2.x-distance, v2.y);
                                        }else{
                                                line(v1.x+distance, v1.y, v2.x+distance, v2.y);
                                        }
                                        break;
                        case 5:         //橫線: n個上下移動的橫線
                                        strokeWeight(weight);
                                        stroke(spriteColor, alphavalue);
                                        if(stretchMode < 2){
                                                line(v1.x, v1.y+distance, v2.x, v2.y+distance);
                                        }else{
                                                line(v1.x, v1.y-distance, v2.x, v2.y-distance);
                                        }
                                        break;
                        case 6:        //垂直線: n個上下移動的線段
                                        strokeWeight(weight);
                                        stroke(spriteColor, alphavalue);
                                        line(m.x, m.y-length/2, m.x, m.y+length/2);
                                        break;
                        case 7:        //橫線: n個左右移動的線段
                                        strokeWeight(weight);
                                        stroke(spriteColor, alphavalue);
                                        line(m.x-length/2, m.y, m.x+length/2, m.y);
                                        break;
                }
        }
}

