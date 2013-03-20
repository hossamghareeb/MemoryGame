//
//  GamePlayScene.h
//  MemoryGame
//
//  Created by Hossam on 3/20/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GamePlayLayer.h"

@interface GamePlayScene : CCScene {
    
}


+(CCScene *)sceneWithRows:(int)row andColumns:(int)columns;

@end
