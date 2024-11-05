//The Adventures of Tintin: The Secret of the Unicorn Auto Splitter by vojtechblazek
//version 1.1.0 date 5. 11. 2024
// Changes: Replaced the values for Y and Z coordinates, since the previous did not transfer correctly between devices. Temporarily removed the book split due to misfiring issues.

state("TINTIN"){
    bool cutscene: "TINTIN.exe", 0x01181C34, 0xFE0; // true if the game is playing a cutscene (skippable kind)
    float posX: "TINTIN.exe", 0x005FE9E4, 0x0, 0x4C; // tracks the position of the played character during gameplay
    float posY: "TINTIN.exe", 0x0164BE88, 0x7DC, 0xCE0; // height
    float posZ: "TINTIN.exe", 0x0164BE88, 0x7B0, 0x3C; // depth
}

startup{
        settings.Add("INFO", true, "INFO: Settings currently do nothing.");
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

        //Final Split - checks if a cutscene is present and if the character is in a specific spot (+- 1 or 2 units to make it more robust)
        if (current.posX > 308 && current.posX < 312 &&
            current.posY > -16 && current.posY < -14 &&
            current.posZ > -14.5 && current.posZ < -10.5 &&
            current.cutscene == true) {
            
            return true;
        }

    }
}
