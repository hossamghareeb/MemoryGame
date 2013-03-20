//
//  MemoryTile.h
//  MemoryGame
//
//  Created by Hossam on 3/20/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "SimpleAudioEngine.h"

@interface MemoryTile : CCSprite {
    
}

@property(nonatomic, assign) int row;
@property(nonatomic, assign) int column;
@property(nonatomic, assign) int number; //unique for the same tiles, used for matching
@property (nonatomic, retain) NSString *faceSpriteName;
@property(nonatomic, assign) BOOL isFaceUp;


-(void)showFace;
-(void)hideFace;
-(void)flip;
-(BOOL)containsTouchLocation:(CGPoint)touchLocaion;

@end
