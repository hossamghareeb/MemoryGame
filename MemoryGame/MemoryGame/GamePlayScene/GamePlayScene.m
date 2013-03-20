//
//  GamePlayScene.m
//  MemoryGame
//
//  Created by Hossam on 3/20/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GamePlayScene.h"


@implementation GamePlayScene



+(CCScene *)sceneWithRows:(int)rows andColumns:(int)columns
{
    CCScene *scene = [CCScene node];
    
    GamePlayLayer *layer = [GamePlayLayer layerWithRows:rows andColumns:columns];
    
    [scene addChild:layer];
    
    return scene;
}

@end
