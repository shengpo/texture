public class SettingManager {
        private String settingFilePath = "";
        private String randomSeedFilePath = "";

        private int randomseed = 10;        //server會設定一個大於0的seed供client使用
        
        
        public SettingManager(){
                 //radnom seed's file path
                randomSeedFilePath = dataPath("randomseed.txt");
//                randomSeedFilePath = sketchPath("data/randomseed.txt");
                
                //set setting file path
                settingFilePath = dataPath("setting.txt");
//                settingFilePath = sketchPath("data/setting.txt");
                
                //create random seed
                createRandomSeed();
                
                //for clients
                clientList = new ArrayList<ClientInfo>();
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

                                        if (pieces[0].equals("frameRate:")) {
                                                frame_rate = int(pieces[1]);
                                        }
                                        if (pieces[0].equals("MonitorLocation:")) {
                                                monitor_x = int(pieces[1]);
                                                monitor_y = int(pieces[2]);
                                        }
                                        if (pieces[0].equals("ScreenSize:")) {
                                                screen_width = int(pieces[1]);
                                                screen_height = int(pieces[2]);
                                        }
                                        if (pieces[0].equals("oscPort:")) {
                                                oscPort = int(pieces[1]);
                                        }
                                        if (pieces[0].equals("ClientInfo:")) {
                                                clientList.add(new  ClientInfo(pieces[1], int(pieces[2]), pieces[3], int(pieces[4])));
                                        }
                                }
                        }else {
                                //error occured or file is empty
                                break;
                        }
                }
        }
        
        
        private void createRandomSeed(){
                PrintWriter output = createWriter(randomSeedFilePath);
  
                output.println((int)random(100));  //create a random seed

                output.flush(); // Writes the remaining data to the file
                output.close(); // Finishes the file
                
                println("[Random Seed File] " + randomSeedFilePath + "  is saved !!");
        }
}
