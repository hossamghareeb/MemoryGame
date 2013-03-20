//
//  GamePlayLayer.m
//  MemoryGame
//
//  Created by Hossam on 3/20/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GamePlayLayer.h"


@implementation GamePlayLayer


+(id)layerWithRows:(int)rows andColumns:(int)columns
{
    
    if ((self  = [super init])) {
        
        self.numOfColumns = columns;
        self.numOfRows = rows;
        
        
    }
    
    return self;
}

@end
