//
//  MainMenuLayer.m
//  MemoryGame
//
//  Created by Hossam on 3/20/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MainMenuLayer.h"


@implementation MainMenuLayer


-(id)init
{
    if ((self = [super init])) {
        
        
        
    }
    return self;
}


-(void)startGameWithDifficulty:(DIFFICULTY)difficulty
{
    int rows, columns;
    if (difficulty == EASY) {
        rows = 2;
        columns = 2;
    }
    if (difficulty == MEDIUM) {
        rows = 3;
        columns = 4;
    }
    if (difficulty == HARD) {
        rows = 4;
        columns = 5;
    }
    
    [[CCDirector sharedDirector] replaceScene:[GamePlayScene sceneWithRows:rows andColumns:columns]];
    
}

@end
