public class Director {
        private int modeTotal = 8;        //動畫mode總數
        private int mode = -1;

        private int nextCounter = 0;
        private int nextCounterFinal = 5000;        
        
        
        public Director(){
        }
        
        public void GO(){
                //shoe lines
                for(XLine vl: vlineList){
                        vl.show();
                }
                for(XLine hl: hlineList){
                        hl.show();
                }
        }
        
        
        //設定變換animation的時機
        public void nextGO(){
                nextCounter = nextCounter + 1;
                if(nextCounter > nextCounterFinal){
                        selectAnimationMode(-1);
                        nextCounter = 0;
                        nextCounterFinal = (int)random(5000, 15000);
                }
        }
        
        
        public void turnOnAllLineAnimationMode(){
                for(XLine xl: vlineList){
                        xl.turnOnAnimationMode();
                }
                for(XLine xl: hlineList){
                        xl.turnOnAnimationMode();
                }

                println("[V Line] turn on animation : " + vlineList.size());
                println("[H Line] turn on animation : " + hlineList.size());
                
                //select one mode at first
                selectAnimationMode(-1);
        }
        
        
        public void selectAnimationMode(int modeIndex){
                if(modeIndex < 0){
                        mode = (int)random(modeTotal);                
                }else{
                        mode = modeIndex;
                }
                
                println("[Animation mode] : " + mode); 
                
                //針對verticval line and horizontal line
                if(mode==0 || mode==1){
                        for(XLine vl: vlineList){
                                vl.update(mode);
                        }
                        for(XLine hl: hlineList){
                                hl.update(mode);
                        }
                }
                
                //只針對verticval line (隨機地讓horizontal line恢復原狀不動)
                if(mode==2 || mode==4 || mode==6){
                        if(random(2) < 1){
                                for(XLine hl: hlineList){
                                        hl.update(0);
                                }
                        }
                        for(XLine vl: vlineList){
                                vl.update(mode);
                        }
                }
                
                //只針對horizontal line (隨機地讓vertical line恢復原狀不動)
                if(mode==3 || mode==5 || mode==7){
                        if(random(2) < 1){
                                for(XLine vl: vlineList){
                                        vl.update(0);
                                }
                        }
                        for(XLine hl: hlineList){
                                hl.update(mode);
                        }
                }
        }
}
