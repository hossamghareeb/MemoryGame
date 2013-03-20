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
 
    return [[[GamePlayScene alloc] initWithRows:rows andColumns:columns] autorelease];
}

-(id)initWithRows:(int)rows andColumns:(int)columns
{
    if ((self = [super init])) {
        
        GamePlayLayer *layer = [GamePlayLayer layerWithRows:rows andColumns:columns];
        
        [self addChild:layer];

    }
    
    return self;
}

@end
