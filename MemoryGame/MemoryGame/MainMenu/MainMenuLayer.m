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
        
        
        CCMenuItem *play = [CCMenuItemFont itemWithString:@"Play" block:^(id sender) {
            [self startGameWithDifficulty:HARD];
        }];
        
		CCMenu *menu = [CCMenu menuWithItems: play, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
        CGSize size = [[CCDirector sharedDirector] winSize];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
		// Add the menu to the layer
		[self addChild:menu];
        
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
