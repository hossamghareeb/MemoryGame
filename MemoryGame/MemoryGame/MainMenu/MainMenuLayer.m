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
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        
        CCLabelTTF *title = [CCLabelTTF labelWithString:@"Memory Game" fontName:@"Marker Felt" fontSize:60];
        title.position = ccp(size.width / 2, size.height / 2 + 100);
        
        title.color = ccMAGENTA;
        
        [self addChild:title];
    
        
        CCMenuItem *play1 = [CCMenuItemFont itemWithString:@"Play Easy" block:^(id sender) {
            [self startGameWithDifficulty:EASY];
        }];
        CCMenuItem *play2 = [CCMenuItemFont itemWithString:@"Play Medium" block:^(id sender) {
            [self startGameWithDifficulty:MEDIUM];
        }];
        CCMenuItem *play3 = [CCMenuItemFont itemWithString:@"Play Hard" block:^(id sender) {
            [self startGameWithDifficulty:HARD];
        }];
        
        
		CCMenu *menu = [CCMenu menuWithItems: play1, play2, play3, nil];
		
		[menu alignItemsVerticallyWithPadding:20];
        
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
