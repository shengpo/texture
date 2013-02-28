public class ClientInfo {
        private String clientAppExePath = "";
  
        public int ID = -1;
        private String remoteIP = "127.0.0.1";        //client IP
        private int remoteOscPort = 12001;           //client's osc port
        private NetAddress myRemoteLocation;
        
        
        public int status = 0;        //if client send out ask request, this status will be 1 or will be 0
        public int playsound = 0;       
        
        public ClientInfo(String clientAppExePath, int ID, String IP, int oscport){
                this.clientAppExePath = clientAppExePath;
                this.ID = ID;
                remoteIP = IP;
                remoteOscPort = oscport;
                myRemoteLocation = new NetAddress(remoteIP, remoteOscPort);
        }
        
        public void goNextFrame(){
                OscMessage myMessage = new OscMessage("/nextFrame");
                myMessage.add(1);
                oscP5.send(myMessage, myRemoteLocation); 
                
                //reset status
                status = 0;
        }
        
        public void runUp(){
                  open(clientAppExePath);
        }
}
