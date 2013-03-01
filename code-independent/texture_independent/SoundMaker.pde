public class SoundMaker {
        private PApplet papplet = null;
        private SoundCipher sc = null;
        
        
        public SoundMaker(PApplet papplet){
                sc = new SoundCipher(papplet);
                sc.instrument = SoundCipher.WOODBLOCK;        //set instrument
        }
        
        public void playSound(){
                sc.playNote(random(128), 127, 0.1);
        
                //float[] pitches = {random(84, 128), random(84, 128), random(84, 128), random(84, 128)};        //play random chord
                //sc.playChord(pitches, 127, 1);
        }
}
