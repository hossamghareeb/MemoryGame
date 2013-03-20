//
//  MemoryTile.m
//  MemoryGame
//
//  Created by Hossam on 3/20/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MemoryTile.h"


@implementation MemoryTile


-(void)showFace
{
    [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:self.faceSpriteName]];
    self.isFaceUp = YES;
    
}

-(void)hideFace
{
    [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:TILE_BACK_FRAME_NAME]];
    self.isFaceUp = NO;
}

-(void)changeFace
{
    if (self.isFaceUp) {
        [self hideFace];
    }
    else
    {
        [self showFace];
    }
}

-(void)flip
{
    float duration = 0.5f;
    id rotateToEdge = [CCOrbitCamera actionWithDuration:duration / 2
                                                 radius:1
                                            deltaRadius:0
                                                 angleZ:0
                                            deltaAngleZ:90
                                                 angleX:0
                                            deltaAngleX:0];
    id rotateFlat = [CCOrbitCamera actionWithDuration:duration / 2
                                               radius:1
                                          deltaRadius:0
                                               angleZ:270
                                          deltaAngleZ:90
                                               angleX:0
                                          deltaAngleX:0];
    
    [self runAction:[CCSequence actions:rotateToEdge,
                     [CCCallFunc actionWithTarget:self
                                         selector:@selector(changeFace)],
                     rotateFlat,
                     nil]];
    
    
    
    [[SimpleAudioEngine sharedEngine] playEffect:SOUND_TILE_FLIP];
}

-(BOOL)containsTouchLocation:(CGPoint)touchLocaion
{
    //check if this tile is touched by the given touch location
    return CGRectContainsPoint(self.boundingBox, touchLocaion);
}

- (void)dealloc
{
    [self.faceSpriteName release];
    [super dealloc];
}
@end
