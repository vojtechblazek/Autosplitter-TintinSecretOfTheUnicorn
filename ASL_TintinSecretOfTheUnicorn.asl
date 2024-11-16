//The Adventures of Tintin: The Secret of the Unicorn Auto Splitter by vojtechblazek
//version 1.3.0 for both game versions  date 16. 11. 2024    Changes: Merged game versions 1.00 & 1.02; Added In-Chapter splits for Moulinsart & Karaboudjan

state("TINTIN"){
    bool cutscene: "binkw32.dll", 0x2A91C; // direct, true if the game is playing a video cutscene (bink)
    float posX: "TINTIN.exe", 0x5EE5F8; // direct
    float posY: "TINTIN.exe", 0x005FEBAC, 0x1CC, 0xEDC; // pointer
    float posZ: "TINTIN.exe", 0x5EE660; // direct
}

startup{   
    settings.Add("S", true, "Batch Splits");
            settings.Add("BOOK1", true, "After 1st Batch of chapters (Flea Market)", "S");
            settings.Add("BOOK2", true, "After 2nd Batch of chapters (Moulinsart)", "S");
            settings.Add("BOOK3", true, "After 3rd Batch of chapters (Karaboudjan)", "S");
            settings.Add("BOOK4", true, "After 4th Batch of chapters (Bagghar)", "S");
            settings.Add("BOOK5", true, "After 5th Batch of chapters (Brittany)", "S");
    
    settings.Add("ES", true, "In-Chapter Splits");
            settings.Add("MS1", true, "Moulinsart: Exiting crypts, entering the building", "ES");
            
            settings.Add("KB1", true, "Karaboudjan: After meeting Haddock", "ES");
            settings.Add("KB2", true, "Karaboudjan: After Haddock destroys the ship", "ES");
}

init{
    vars.bookFleaMarket = false; // could just be vars.splitControl
    vars.bookMoulinsart = false;
    vars.bookKaraboudjan = false;
    vars.bookBagghar = false;
    vars.bookBrittany = false;
    vars.finalSplit = false;
    vars.gameFinished = false;

    vars.splitMS1 = false;
    vars.splitKB1 = false;
    vars.splitKB2 = false;
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
    //Final Split
    if (current.posX > 308 && current.posX < 312 &&
        current.posY > -16 && current.posY < -14 &&
        current.posZ > -11 && current.posZ < -7 &&
        vars.finalSplit == false &&
        vars.gameFinished == false)
    { 
        vars.finalSplit = true;
    }

    //IN-CHAPTER SPLITS
    if ((current.posX > 233 && current.posX < 243 && // MS1
        current.posY > 32 && current.posY < 35 &&
        current.posZ > 1.8 && current.posZ < 2.2) &&
        vars.splitMS1 == false)
    {
        vars.splitMS1 = true;
    }

    if ((current.posX > 31 && current.posX < 34 && // KB1
        current.posY > -7 && current.posY < -4 &&
        current.posZ > -38 && current.posZ < -33) &&
        vars.splitKB1 == false)
    {
        vars.splitKB1 = true;
    }

    if ((current.posX > -6 && current.posX < 10 && // KB2
        current.posY > 0 && current.posY < 10 &&
        current.posZ > 85 && current.posZ < 95) &&
        vars.splitKB2 == false)
    {
        vars.splitKB2 = true;
    }
}

start{
    return current.cutscene && !old.cutscene;
}

split{
    // Ending split
    if (vars.finalSplit == true && current.cutscene == true)
    {
        vars.finalSplit = false;
        vars.gameFinished = true;
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

    //  IN-CHAPTER SPLITS
    //MS1 (Entering the building)
    if (
    (current.posX > 10 && current.posX < 12 && // MS1
     current.posY > -1 && current.posY < 1 &&
     current.posZ > 5 && current.posZ < 7) &&
     vars.splitMS1 == true)
    {
        vars.splitMS1 = false;
        return settings["MS1"];
    }

    if (
    (current.posX > 2 && current.posX < 3 && // KB1
     current.posY > 0 && current.posY < 1 &&
     current.posZ > 3 && current.posZ < 5) &&
     vars.splitKB1 == true)
    {
        vars.splitKB1 = false;
        return settings["KB1"];
    }

    if (
    (current.posX > -59 && current.posX < -55 && // KB2
     current.posY > -1 && current.posY < 1 &&
     current.posZ > 7 && current.posZ < 8) &&
     vars.splitKB2 == true)
    {
        vars.splitKB2 = false;
        return settings["KB2"];
    }
    
}

onReset{
    vars.bookFleaMarket = false;
    vars.bookMoulinsart = false;
    vars.bookKaraboudjan = false;
    vars.bookBagghar = false;
    vars.bookBrittany = false;
    vars.finalSplit = false;
    vars.gameFinished = false;
    vars.splitMS1 = false;
    vars.splitKB1 = false;
    vars.splitKB2 = false;
}
