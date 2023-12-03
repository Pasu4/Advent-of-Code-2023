%{
    #include <stdio.h>

    const char* concreteColors[10] = {
        "white",
        "orange",
        "magenta",
        "light_blue",
        "yellow",
        "lime",
        "pink",
        "gray",
        "light_gray",
        "cyan"
    };

    int currentX = 0;
    int currentZ = 0;
%}

%%

[0-9]+ {
    int len = strlen(yytext);
    for(int i = 0; i < len; i++) {
        // Place concrete at the height indicated by the digit's place
        printf("setblock ~%d ~%d ~%d %s_concrete\n", currentX, i, currentZ, concreteColors[yytext[i] - '0']);
        currentX++;
    }
    // Place red concrete in the floor to indicate a digit above
    printf("fill ~%d ~-1 ~%d ~%d ~-1 ~%d red_concrete\n", currentX - 1, currentZ, currentX - strlen(yytext), currentZ);
}

\n {
    // Indicate end of line
    printf("setblock ~%d ~-1 ~%d green_concrete\n", currentX, currentZ);
    currentX = 0;
    currentZ++;
}

"*" {
    printf("# Gear\n");
    // printf("setblock ~%d ~-1 ~%d redstone_block\n", currentX, currentZ);
    printf("summon armor_stand ~%d ~ ~%d {Tags:[\"symbol\", \"gear\"],NoAI:true,CustomName:'\"%s\"',CustomNameVisible:true}\n", currentX, currentZ, yytext);
    currentX++;
}

"." {
    currentX++;
}

\r { // Ignore CR
}

. {
    printf("# Symbol: %s\n", yytext);
    // printf("setblock ~%d ~-1 ~%d redstone_block\n", currentX, currentZ);
    printf("summon armor_stand ~%d ~ ~%d {Tags:[\"symbol\"],NoAI:true,CustomName:'\"%s\"',CustomNameVisible:true}\n", currentX, currentZ, yytext);
    currentX++;
}

%%