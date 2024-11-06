//The Adventures of Tintin: The Secret of the Unicorn Auto Splitter by vojtechblazek
//version 1.0.0. for game v1.00  date 6. 11. 2024

state("TINTIN"){
    bool cutscene: "TINTIN.exe", 0x010CF7E4, 0x4A4, 0x20, 0x60; // true if the game is playing a cutscene (skippable kind)
    bool dircutscene: "TINTIN.exe", 0x5EE674; //direct value

    float posX: "TINTIN.exe", 0x5EE5F8; // direct
    float posY: "TINTIN.exe", 0x005FEBAC, 0x1CC, 0xEDC; // pointer
    float posZ: "TINTIN.exe", 0x5EE660; // direct
}

startup{
    vars.gameFinished = 0;
}

start{
    return current.dircutscene && !old.dircutscene;
}

split {
    // Checks for position change
    if (current.posX != old.posX || current.posY != old.posY || current.posZ != old.posZ) {
        //Final Split - checks if a cutscene is present and if the character is in a specific spot (+- 1 or 2 units to make it more robust)
        if (current.posX > 308 && current.posX < 312 &&
            current.posY > -16 && current.posY < -14 &&
            current.posZ > -11 && current.posZ < -7 &&
            current.cutscene == true &&
            vars.gameFinished == 0){ 
                vars.gameFinished = 1;
                return true;
        }
    }
}
