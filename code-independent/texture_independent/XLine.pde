//XLine可以是直線(vertical line)或是橫線(horizontal line)
public class XLine {
        //橫線的參考點(pivot點)預設為最左邊的點 (向右畫線)
        //直線的參考點(pivot點)預設為最上面的點 (向下畫線)
        
        private PVector v1 = null;    //起點
        private PVector v2 = null;    //終點
        private PVector m = null;    //中點
        private float length = 0;    //line的長度
        private float weight = 1;    //線的厚度

        private int lineMode = 0;    //0:橫線, 1:直線    

        private boolean isAnimationMode = false;
        private boolean isSettingMode = false;

        
        //for line sprite
        private float left_distance = 0;          //距離左邊(下面)的XLine的距離
        private float right_distance = 0;        //距離右邊(上面)的XLine的距離
        private ArrayList<LineSprite> spriteList = null;




        public XLine(PVector startVertex, float length, float weight, float left_distance, float right_distance, int lineMode) {
//                this.v1 = startVertex;
                this.length = length;
                this.weight = weight;
                this.left_distance = left_distance;
                this.right_distance = right_distance;
                this.lineMode = lineMode;

                setLineFromStart(startVertex);
//                setLine("v1");        //以v1作為pivot點來設定XLine
                
                spriteList = new ArrayList<LineSprite>();
        }


        public void update(int mode) {
                //normal mode
                if(!isSettingMode && !isAnimationMode){
                        //...
                }

                //setting mode
                if(isSettingMode && !isAnimationMode){
                        //...
                }

                //animation mode
                if(!isSettingMode && isAnimationMode){
                        //clear pre-sprites
                        spriteList.clear();
                        
                        switch(mode){
                                case 0:        //靜止不動
                                                spriteList.add(new LineSprite(v1, v2, m, length, weight, left_distance, right_distance, mode));
                                                break;
                                case 1:        //fade in/out
                                                spriteList.add(new LineSprite(v1, v2, m, length, weight, left_distance, right_distance, mode));
                                                break;
                                case 2:        //垂直線: 左右伸縮長條形
                                                spriteList.add(new LineSprite(v1, v2, m, length, weight, left_distance, right_distance, mode));
                                                break;
                                case 3:        //橫線: 上下伸縮長條形
                                                spriteList.add(new LineSprite(v1, v2, m, length, weight, left_distance, right_distance, mode));
                                                break;
                                case 4:        //垂直線: n個左右移動的橫線
                                                int a = (int)random(4);
                                                for(int i=0; i<a; i++){
                                                        spriteList.add(new LineSprite(v1, v2, m, length, weight, left_distance, right_distance, mode));
                                                }
                                                break;
                                case 5:        //橫線: n個上下移動的橫線
                                                int b = (int)random(4);
                                                for(int i=0; i<b; i++){
                                                        spriteList.add(new LineSprite(v1, v2, m, length, weight, left_distance, right_distance, mode));
                                                }
                                                break;
                                case 6:        //垂直線: n個上下移動的線段
                                                int aa = (int)random(3);
                                                for(int i=0; i<aa; i++){
                                                        spriteList.add(new LineSprite(v1, v2, m, length, weight, left_distance, right_distance, mode));
                                                }
                                                break;
                                case 7:        //橫線: n個左右移動的線段
                                                int bb = (int)random(3);
                                                for(int i=0; i<bb; i++){
                                                        spriteList.add(new LineSprite(v1, v2, m, length, weight, left_distance, right_distance, mode));
                                                }
                                                break;
                        }
                }
        }

        public void show() {
                //normal mode
                if(!isSettingMode && !isAnimationMode){
                        strokeWeight(weight);
                        stroke(0, 128);
                        line(v1.x, v1.y, v2.x, v2.y);
                }

                //setting mode
                if(isSettingMode && !isAnimationMode){
                        strokeWeight(weight);
                        stroke(0, 0, 255);
                        line(v1.x, v1.y, v2.x, v2.y);
                        
                        //start vertex
                        strokeWeight(1);
                        noFill();
                        stroke(255, 0, 0);
                        ellipse(v1.x, v1.y, 2, 2);
                        ellipse(v1.x, v1.y, 10, 10);
                        
                        //middle vertex
                        stroke(255, 0, 255);
                        ellipse(m.x, m.y, 2, 2);
                        ellipse(m.x, m.y, 10, 10);

                        //end vertext
                        stroke(0, 255, 0);
                        ellipse(v2.x, v2.y, 2, 2);
                        ellipse(v2.x, v2.y, 10, 10);
                        
                        //show distance to left/down and right/up
                        switch(lineMode) {
                                case 0:    //for horizontal line
                                                stroke(0, 255, 255);
                                                line(m.x, m.y, m.x, m.y+left_distance);
                                                stroke(255, 0, 255);
                                                line(m.x, m.y, m.x, m.y-right_distance);
                                                break;
                                case 1:    //for vertical line
                                                stroke(0, 255, 255);
                                                line(m.x, m.y, m.x-left_distance, m.y);
                                                stroke(255, 0, 255);
                                                line(m.x, m.y, m.x+right_distance, m.y);
                                                break;
                        }
                }

                //animation mode
                if(!isSettingMode && isAnimationMode){
                        for(LineSprite sprite: spriteList){
                                sprite.update();
                                sprite.show();
                        }
                }
        }


        private void setLine(String pivot) {
                switch(lineMode) {
                        case 0:    //for horizontal line
                                        if(pivot.equals("v1")){
                                                v2 = PVector.add(v1, new PVector(length, 0));
                                                m = PVector.add(v1, new PVector(length/2f, 0));
                                        }
                                        if(pivot.equals("v2")){
                                                v1 = PVector.add(v2, new PVector(-length, 0));
                                                m = PVector.add(v2, new PVector(-length/2f, 0));
                                        }
                                        if(pivot.equals("m")){
                                                v1 = PVector.add(m, new PVector(-length/2f, 0));
                                                v2 = PVector.add(m, new PVector(length/2f, 0));
                                        }
                                        break;
                        case 1:    //for vertical line
                                        if(pivot.equals("v1")){
                                                v2 = PVector.add(v1, new PVector(0, length));
                                                m = PVector.add(v1, new PVector(0, length/2f));
                                        }
                                        if(pivot.equals("v2")){
                                                v1 = PVector.add(v2, new PVector(0, -length));
                                                m = PVector.add(v2, new PVector(0, -length/2f));
                                        }
                                        if(pivot.equals("m")){
                                                v1 = PVector.add(m, new PVector(0, -length/2f));
                                                v2 = PVector.add(m, new PVector(0, length/2f));
                                        }
                                        break;
                }
        }


        public void setLineFromStart(PVector v) {
                v1 = v;
                setLine("v1");
        }
        public void setLineFromEnd(PVector v) {
                v2 = v;
                setLine("v2");
        }
        public void setLineFromMiddle(PVector v) {
                m = v;
                setLine("m");
        }


        public PVector getStartVertex() {
                return v1;
        }
        public PVector getEndVertex() {
                return v2;
        }
        public PVector getMiddleVertex() {
                return m;
        }


        public void addLength(String pivot, float dLength) {
                length = length + dLength;
                if (length < 0) {
                        length = 0;
                }

                setLine(pivot);
        }    
        public void setLength(String pivot, float newLength) {
                length = newLength;
                if (length < 0) {
                        length = 0;
                }

                setLine(pivot);
        }
        public float getLength() {
                return length;
        }
        
        
        public void addWeight(float delta){
                weight = weight + delta;
                
                if(weight < 1){
                        weight = 1;
                }
        }
        public float getWeight(){
                return weight;
        }
        
        
        
        public void shiftLeftDistance(float delta){
                left_distance = left_distance + delta;       
                if(left_distance < 0){
                        left_distance = 0;
                }
        }
        public float getLeftDistance(){
                return left_distance;
        }
        public void shiftRightDistance(float delta){
                right_distance = right_distance + delta;       
                if(right_distance < 0){
                        right_distance = 0;
                }
        }
        public float getRightDistance(){
                return right_distance;
        }
        
        
        public int getLineMode(){
                return lineMode;
        }


        public void turnOnSettingMode() {
                isAnimationMode = false;
                isSettingMode = true;
        }

        public void turnOnAnimationMode() {
                isAnimationMode = true;
                isSettingMode = false;
        }

        public void turnOnNormalMode() {
                isAnimationMode = false;
                isSettingMode = false;
        }
}

