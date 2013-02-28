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

