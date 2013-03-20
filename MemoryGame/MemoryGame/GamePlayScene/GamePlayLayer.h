//
//  GamePlayLayer.h
//  MemoryGame
//
//  Created by Hossam on 3/20/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GamePlayLayer : CCLayer {
    
    
}

@property(nonatomic, assign) int numOfRows;
@property(nonatomic, assign) int numOfColumns;

+(id)layerWithRows:(int)rows andColumns:(int)columns;

@end
