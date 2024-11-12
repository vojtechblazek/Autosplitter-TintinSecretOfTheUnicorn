//The Adventures of Tintin: The Secret of the Unicorn Auto Splitter by vojtechblazek
//version 1.2.1 for both game versions  date 12. 11. 2024

state("TINTIN", "v1.00"){
    bool cutscene: "binkw32.dll", 0x2A91C; // true if the game is playing a video cutscene (bink)
    float posX: "TINTIN.exe", 0x5EE5F8; // direct
    float posY: "TINTIN.exe", 0x005FEBAC, 0x1CC, 0xEDC; // pointer
    float posZ: "TINTIN.exe", 0x5EE660; // direct
}

state("TINTIN", "v1.02"){
    bool cutscene: "binkw32.dll", 0x2A91C; // same as 1.00
    float posX: "TINTIN.exe", 0x5EE5F8; // same as 1.00
    float posY: "TINTIN.exe", 0x0164BE88, 0x7DC, 0xCE0; // since it's a pointer, Y had to be changed
    float posZ: "TINTIN.exe", 0x5EE660; // same as 1.00
}

startup{
    settings.Add("GameVer", true, "Game Version");
            settings.Add("V100", true, "v1.00", "GameVer");
            settings.Add("V102", false, "v1.02", "GameVer");
    
    settings.Add("S", true, "Splits");
            settings.Add("BOOK1", true, "After 1st Batch of chapters (Flea Market)", "S");
            settings.Add("BOOK2", true, "After 2nd Batch of chapters (Moulinsart)", "S");
            settings.Add("BOOK3", true, "After 3rd Batch of chapters (Karaboudjan)", "S");
            settings.Add("BOOK4", true, "After 4th Batch of chapters (Bagghar)", "S");
            settings.Add("BOOK5", true, "After 5th Batch of chapters (Brittany)", "S");
}

init{
    if (settings["V100"] && !settings["V102"]){ // user must specify the correct version before starting the game, it won't change after. Something to work on
        version = "v1.00";
        print("GAME VERSION: 1.00");
    }
    else if (!settings["V100"] && settings["V102"]){
        version = "v1.02";
        print("GAME VERSION: 1.02");
    }
    else if (settings["V100"] && settings["V102"]){
        version = "v1.00";
        print("GAME VERSION: BOTH BOXES CHECKED, DEFAULTING TO 1.00");
    }
    else if (!settings["V100"] && !settings["V102"]){
        version = "v1.00";
        print("GAME VERSION: BOTH BOXES UNCHECKED, DEFAULTING TO 1.00");
    }

    vars.bookFleaMarket = false; // could just be vars.splitControl
    vars.bookMoulinsart = false;
    vars.bookKaraboudjan = false;
    vars.bookBagghar = false;
    vars.bookBrittany = false;
}

update{
    //BOOK SPLITS
    //Flea Market
    if (current.posX > 7 && current.posX < 7.4 &&   
        current.posY > 5.9 && current.posY < 6.1 &&
        current.posZ > 8 && current.posZ < 8.2 &&   
        vars.bookFleaMarket == false)
    {
        vars.bookFleaMarket = true;
    }
    //Moulinsart
    if (current.posX > -25 && current.posX < -21 &&   
        current.posY > -8 && current.posY < -7 &&
        current.posZ > -110 && current.posZ < -100 &&  
        vars.bookMoulinsart == false)
    {
        vars.bookMoulinsart = true;
    }
    //Karaboudjan
    if (current.posX > -250 && current.posX < -50 &&   
        current.posY > 625 && current.posY < 825 &&
        current.posZ > -1600 && current.posZ < -1400 && 
        vars.bookKaraboudjan == false)
    {
        vars.bookKaraboudjan = true;
    }
    //Bagghar
    if (current.posX > 3300 && current.posX < 3500 &&   
        current.posY > 300 && current.posY < 500 &&
        current.posZ > -300 && current.posZ < -100 &&   
        vars.bookBagghar == false)
    {
        vars.bookBagghar = true;
    }
    //Brittany
    if (current.posX > 100 && current.posX < 200 &&  
        current.posY > 160 && current.posY < 220 &&
        current.posZ > -270 && current.posZ < -210 &&  
        vars.bookBrittany == false)
    {
        vars.bookBrittany = true;
    }
}

start{
    return current.cutscene && !old.cutscene;
}

split{
    // Ending split
    if (current.posX > 308 && current.posX < 312 &&
        current.posY > -16 && current.posY < -14 &&
        current.posZ > -11 && current.posZ < -7 &&
        current.cutscene == true)
    { 
            vars.gameFinished = 1;
            return true;
    }
    
    //BOOK SPLITS
    if (
    (old.posX > 22 && old.posX < 22.5 && // Check for book coordinates
     old.posY > 13 && old.posY < 13.1 &&
     old.posZ > 14.8 && old.posZ < 15) &&
    (current.posX < 22 || current.posX > 22.5 ||
     current.posY < 13 || current.posY > 13.1 ||
     current.posZ < 14.8 || current.posZ > 15))
    {
        // Flea Market
        if (vars.bookFleaMarket == true)
        {
            vars.bookFleaMarket = false;
            return settings["BOOK1"];
        }
        // Moulinsart
        else if (vars.bookMoulinsart == true)
        {
            vars.bookMoulinsart = false;
            return settings["BOOK2"];
        }
        // Karaboudjan
        else if (vars.bookKaraboudjan == true)
        {
            vars.bookKaraboudjan = false;
            return settings["BOOK3"];
        }
        //Bagghar
        else if (vars.bookBagghar == true)
        {
            vars.bookBagghar = false;
            return settings["BOOK4"];
        }
        //Brittany
        else if (vars.bookBrittany == true)
        {
            vars.bookBrittany = false;
            return settings["BOOK5"];
        }
    }
}
