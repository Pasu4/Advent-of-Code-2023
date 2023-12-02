%{
    #include <stdio.h>

    int bankAddr = 0;
    int gameNum = 1;
    int cubeCount = 0;
%}

%%

"Game "[0-9]+ {
    printf("\tcontrol enabled switch1 0\n");                    // Tell other processor the request is completed
    printf("\twrite -1 bank1 %d\n", bankAddr);                  // Write -1 (game end) to bank
    printf("\ngame%d:\n", gameNum);                             // Label to wait for next request
    printf("\tsensor en switch1 @enabled\n");                   // Get state of switch
    printf("\tjump game%d notEqual en true\n", gameNum);        // Wait until next request
    // printf("\twrite %d bank1 0\n", gameNum);                    // Write ID of the game to bank
    
    gameNum++;
    bankAddr = 0;
}

[0-9]+ {
    // printf("\twrite %s bank1 %d\n", yytext, bankAddr++);        // Write number to bank
    cubeCount = atoi(yytext);
}

red {
    printf("\twrite %d bank1 %d\n", 12000 + cubeCount, bankAddr++);               // write 12000 (red) to bank
}
green {
    printf("\twrite %d bank1 %d\n", 13000 + cubeCount, bankAddr++);               // write 13000 (green) to bank
}
blue {
    printf("\twrite %d bank1 %d\n", 14000 + cubeCount, bankAddr++);               // write 14000 (blue) to bank
}

";" {
    // printf("\twrite -2 bank1 %d\n", bankAddr++);                // Write -2 (batch end) to bank
}

[: ,] {                                                         // Ignore other characters
}
\n {
    printf("\n\twrite -3 bank1 %d\n", bankAddr);                // Write -3 (end of file) to bank
    // printf("\tcontrol enabled switch1 0\n");                    // Tell other processor the request is completed
}

%%