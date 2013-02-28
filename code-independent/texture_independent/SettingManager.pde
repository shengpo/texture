public class SettingManager {
        private String settingFilePath = "";
        
        
        public SettingManager(){
                //set setting file path
                settingFilePath = dataPath("setting.txt");
                
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

                                        if (pieces[0].equals("ScreenSize:")) {
                                                screen_width = int(pieces[1]);
                                                screen_height = int(pieces[2]);
                                        }
                                        if (pieces[0].equals("ScreenLocation:")) {
                                                screen_x = int(pieces[1]);
                                                screen_y = int(pieces[2]);
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

                //write With and Height of screen
                output.println("ScreenSize: " + screen_width + " " + screen_height);
                output.println("");

                //write location of screen
                output.println("ScreenLocation: " + screen_x + " " + screen_y);
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
