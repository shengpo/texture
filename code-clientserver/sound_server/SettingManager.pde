public class SettingManager {
        private String settingFilePath = "";

        
        public SettingManager(){
                //set setting file path
                settingFilePath = dataPath("setting.txt");
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
                                }
                        }else {
                                //error occured or file is empty
                                break;
                        }
                }
        }
}
