//The Adventures of Tintin: The Secret of the Unicorn Auto Splitter by vojtechblazek
//version 1.0.0 date 4. 11. 2024

state("TINTIN"){
    bool cutscene: "TINTIN.exe", 0x01181C34, 0xFE0; // true if the game is playing a cutscene (skippable kind)
    float posX: "TINTIN.exe", 0x005FE9E4, 0x0, 0x4C; // tracks the position of the played character during gameplay
    float posY: "TINTIN.exe", 0x0143B88C, 0x6A0; // height
    float posZ: "TINTIN.exe", 0x0143B88C, 0x698; // depth
}

startup{
        settings.Add("STARTS", true, "Start");
            settings.Add("NEWFILE", true, "New File Start", "STARTS");
            settings.Add("TESTSTART", false, "Split template for later use", "STARTS");  
        
        settings.Add("SPLITS", true, "Splits");
            settings.Add("BOOKSPLIT", true, "Split after every batch", "SPLITS");
            settings.Add("TESTSPLIT", false, "Split template for later use", "SPLITS"); 
}

start{
    return current.cutscene && !old.cutscene;
}

split {
    // Checks for position change
    if (current.posX != old.posX || current.posY != old.posY || current.posZ != old.posZ) {

        //Book Split (splits after the summary book at the end of each chapter)
        if ((old.posX > -0.0002 && old.posX < 0.0002 &&
            old.posY > 13.04981 && old.posY < 13.05021 &&
            old.posZ > 14.91225 && old.posZ < 14.91265) &&
    
            (current.posX < -0.0002 || current.posX > 0.0002 ||
            current.posY < 13.04981 || current.posY > 13.05021 ||
            current.posZ < 14.91225 || current.posZ > 14.91265)){
            
            return settings["BOOKSPLIT"];
        }

        //Final Split - checks if a cutscene is present and if the character is in a specific spot (+- 1 or 2 units to make it more robust)
        if (current.posX > 308 && current.posX < 312 &&
            current.posY > -16 && current.posY < -14 &&
            current.posZ > -14.5 && current.posZ < -10.5 &&
            current.cutscene == true) {
            
            return true;
        }

    }
}
