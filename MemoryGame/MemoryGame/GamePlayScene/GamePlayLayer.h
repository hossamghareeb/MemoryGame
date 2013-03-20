//
//  GamePlayLayer.h
//  MemoryGame
//
//  Created by Hossam on 3/20/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MemoryTile.h"
#import "MainMenuScene.h"

@interface GamePlayLayer : CCLayer <CCTargetedTouchDelegate>{
    
    //board info
    int boardRows;
    int boardColumns;
    float boardWidth;
    float boardHeight;
    int boardOffsetX;
    int boardOffsetY;
    int paddingWidth;
    int paddingHeight;
    
    //arrays of tiles
    NSMutableArray *allTiles;  //all the tiles
    NSMutableArray *currentTiles;  //current tiles that not have been matched yet
    NSMutableArray *selectedTiles;  //the selected to be matched
    
    int maxTiles;
    
    CGSize winSize;
    CGSize tileSize;
    
    CCSpriteBatchNode *memorySheet;
    
    CCSprite *backButton;
    
    int lives;
    CCLabelTTF *livesDisplay;
    
    int score;
    CCLabelTTF *scoreDisplaly;
    
    BOOL isGameOver;
    
}


+(id)layerWithRows:(int)rows andColumns:(int)columns;
-(id)initWithRows:(int)rows andColumns:(int)columns;
@end
