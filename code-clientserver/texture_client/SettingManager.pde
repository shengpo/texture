public class SettingManager {
        private String settingFilePath = "";
        private String randomSeedFilePath = "";
        
        
        public SettingManager(){
                //set setting file path
                settingFilePath = dataPath("setting.txt");
//                settingFilePath = sketchPath("data/setting.txt");
                
                //lines
                hlineList = new ArrayList<XLine>();
                vlineList = new ArrayList<XLine>();
        }
        
        
        public void load(){
                String line = null;
                BufferedReader reader = createReader(settingFilePath); 

                while (true) {
                        try {
                                line = reader.readLine();
                        }catch(IOException e) {
                                e.printStackTrace();
                                line = null;
                                break;
                        }

                        if (line != null) {
                                if (line.length() > 0) {
                                        String[] pieces = split(line, " ");

                                        if (pieces[0].equals("clientID:")) {
                                                clientID = int(pieces[1]);
                                        }
                                        if (pieces[0].equals("frameRate:")) {
                                                frame_rate = int(pieces[1]);
                                        }
                                        if (pieces[0].equals("randomSeedFilePath:")) {
                                               randomSeedFilePath = pieces[1];
                                               if(randomSeedFilePath.equals("")){
                                                        randomseed = -1;
                                               }else{
                                                         String lines[] = loadStrings(randomSeedFilePath);
                                                         if(lines == null){
                                                                  randomseed = -1;
                                                         }else{
                                                                   randomseed = int(trim(lines[0]));
                                                         }
                                               }
                                        }
                                        if (pieces[0].equals("MonitorLocation:")) {
                                                monitor_x = int(pieces[1]);
                                                monitor_y = int(pieces[2]);
                                        }
                                        if (pieces[0].equals("ScreenSize:")) {
                                                screen_width = int(pieces[1]);
                                                screen_height = int(pieces[2]);
                                        }
                                        if (pieces[0].equals("ScreenLocation:")) {
                                                screen_x = int(pieces[1]);
                                                screen_y = int(pieces[2]);
                                        }
                                        if (pieces[0].equals("MasterSize:")) {
                                                master_width = int(pieces[1]);
                                                master_height = int(pieces[2]);
                                        }
                                        if (pieces[0].equals("oscPort:")) {
                                                oscPort = int(pieces[1]);
                                        }
                                        if (pieces[0].equals("remoteIP:")) {
                                                remoteIP = pieces[1];
                                        }
                                        if (pieces[0].equals("remoteOscPort:")) {
                                                remoteOscPort = int(pieces[1]);
                                        }
                                        if (pieces[0].equals("Vline:")) {
                                                vlineList.add(new XLine(new PVector(float(pieces[1]), float(pieces[2])), float(pieces[3]), float(pieces[4]), float(pieces[5]), float(pieces[6]), 1));
                                        }
                                        if (pieces[0].equals("Hline:")) {
                                                hlineList.add(new XLine(new PVector(float(pieces[1]), float(pieces[2])), float(pieces[3]), float(pieces[4]), float(pieces[5]), float(pieces[6]), 0));
                                        }
                                }
                        }else {
                                //error occured or file is empty
                                break;
                        }
                }
        }
        
        
        public void save(){
                PrintWriter output = createWriter(settingFilePath);

                output.println("#---以下參數需手動設定, 設定完後程式會記住---");
                output.println("");

                //write client ID
                output.println("#client ID從 0 開始算");
                output.println("clientID: " + clientID);
                output.println("");

                //write frame rate
                output.println("#frame rate (best to have the same rate in both client and server)");
                output.println("frameRate: " + frame_rate);
                output.println("");

               output.println("#get random seed from server's file (file path can not have blank!)");
                output.println("randomSeedFilePath: " + randomSeedFilePath);
                output.println("");

                //write monitorl location of client
                output.println("#本client在螢幕上的位置");
                output.println("MonitorLocation: " + monitor_x + " " + monitor_y);
                output.println("");
                output.println("");
                output.println("");

                //write Width and Height of master canvas
                output.println("#master canvas of overall");
                output.println("MasterSize: " + master_width + " " + master_height);
                output.println("");

                //write With and Height of local screen, and location of screen
                output.println("#local screen of client");
                output.println("ScreenLocation: " + screen_x + " " + screen_y);
                output.println("ScreenSize: " + screen_width + " " + screen_height);
                output.println("");

                //write local osc port
                output.println("# 本client的osc port");
                output.println("oscPort: " + oscPort);
                output.println("");

                //write server IP and its' osc port
                output.println("# sever的IP及osc port");
                output.println("remoteIP: " + remoteIP);
                output.println("remoteOscPort: " + remoteOscPort);
                output.println("");

                output.println("#---以上參數需手動設定, 設定完後程式會記住---");
                output.println("");
                output.println("");

                output.println("# 若改變(ScreenSize或ScreenLocation)數值，請刪除下方所有的line Info的資訊，讓程式自動儲存新的設定");
                output.println("");

                // Write every line's infomation
                for(XLine vl: vlineList){
                        output.println("Vline: " + vl.getStartVertex().x + " " + vl.getStartVertex().y + " " + vl.getLength() + " " + vl.getWeight() + " " + vl.getLeftDistance() + " " + vl.getRightDistance());
                }
                
                for(XLine hl: hlineList){
                        output.println("Hline: " + hl.getStartVertex().x + " " + hl.getStartVertex().y + " " + hl.getLength() + " " + hl.getWeight() + " " + hl.getLeftDistance() + " " + hl.getRightDistance());
                }

                output.flush(); // Writes the remaining data to the file
                output.close(); // Finishes the file
                
                println("[Setting File] " + settingFilePath + "  is saved !!");
        }
}
