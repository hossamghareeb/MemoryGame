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
    
    return [[[self alloc] initWithRows:rows andColumns:columns] autorelease];
}

-(id)initWithRows:(int)rows andColumns:(int)columns
{
    if ((self  = [super init])) {
        
        boardColumns = columns;
        boardRows = rows;
        
        self.isTouchEnabled = YES;
        
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        
        winSize = [[CCDirector sharedDirector] winSize];
        
        //preload sounds
        [self preLoadSounds];
        
        
        //load memory sheet
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"memorysheet.plist"];
        memorySheet = [CCSpriteBatchNode batchNodeWithFile:@"memorysheet.png"];
        [self addChild:memorySheet];
        
        //backbutton
        
        backButton = [CCSprite spriteWithSpriteFrameName:@"backbutton.png"];
        [backButton setAnchorPoint:ccp(1,0)];
        [backButton setPosition:ccp(winSize.width - 10, 10)];
        
        [memorySheet addChild:backButton];
        
        
        //
        maxTiles = (boardRows * boardColumns) / 2;
        boardWidth = 400;
        boardHeight = 320;
        
        paddingWidth = 10; paddingHeight = 10;
        
        
        tileSize.width = (boardWidth - ((boardColumns - 1) * paddingWidth) ) / boardColumns;
        tileSize.height = (boardHeight - ((boardRows - 1) * paddingHeight) ) / boardRows;
        
        //sqaure them
        tileSize.width = MIN(tileSize.width, tileSize.height);
        tileSize.height = tileSize.width;
        
        boardOffsetX = (boardWidth - (boardColumns * (tileSize.width + paddingWidth))) / 2;
        boardOffsetY = (boardHeight - (boardRows * (tileSize.height + paddingHeight))) / 2;
        
        NSLog(@"x:%d, y:%d", boardOffsetX, boardOffsetY);
        
        
        score = 0;
        lives = 10;
        
        //initialize arrays
        
        allTiles = [[NSMutableArray alloc] initWithCapacity:maxTiles];
        currentTiles = [[NSMutableArray alloc] initWithCapacity:maxTiles];
        selectedTiles = [[NSMutableArray alloc] initWithCapacity:2];
        
        [self createScoreAndLivesDisplay];
        
        [self loadAllTiles];
        [self drawTilesInLayer];
        
        
        
    }
    
    return self;
}

-(void)createScoreAndLivesDisplay
{
    CGPoint scorePosition = ccp(winSize.width - (winSize.width - boardOffsetX - boardWidth) / 2, 0.75 * winSize.height);
    CGPoint livesPosition = ccp(winSize.width - (winSize.width - boardOffsetX - boardWidth) / 2, 0.25 * winSize.height);
    
    CCLabelTTF *scoreTitle = [CCLabelTTF labelWithString:@"Score" fontName:@"Marker Felt" fontSize:20];
    scoreTitle.position = ccpAdd(scorePosition, ccp(0, 30));
    
    [self addChild:scoreTitle];
    
    scoreDisplaly  = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:20];
    scoreDisplaly.position  = scorePosition;
    
    [self addChild:scoreDisplaly];
    
    CCLabelTTF *livesTitle = [CCLabelTTF labelWithString:@"Lives" fontName:@"Marker Felt" fontSize:20];
    livesTitle.position = ccpAdd(livesPosition, ccp(0, 30));
    
    [self addChild:livesTitle];
    
    livesDisplay  = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", maxTiles] fontName:@"Marker Felt" fontSize:20];
    livesDisplay.position  = livesPosition;
    
    [self addChild:livesDisplay];
    
}

-(void)preLoadSounds
{
    [[SimpleAudioEngine sharedEngine] preloadEffect:SOUND_TILE_FLIP];
    [[SimpleAudioEngine sharedEngine] preloadEffect:SOUND_TILE_SCORE];
    [[SimpleAudioEngine sharedEngine] preloadEffect:SOUND_TILE_WRONG];
    [[SimpleAudioEngine sharedEngine] preloadEffect:SOUND_SCORE];
}


//create all tiles at the beginning in allTiles array
-(void)loadAllTiles
{
    for (int i = 1; i <=  maxTiles; i++) {
  
        //create tile twice to get matched pairs
        MemoryTile *tile1 = [self createTileWithIndex:i];
        MemoryTile *tile2 = [self createTileWithIndex:i];
        [allTiles addObject:tile1];
        [allTiles addObject:tile2];
    }
}

-(MemoryTile *)createTileWithIndex:(int)index
{
    MemoryTile *tile = [MemoryTile node];
    tile.faceSpriteName = [NSString stringWithFormat:@"tile%d.png", index];
    tile.number = index;
    [tile hideFace];
    return tile;
}

-(void)drawTilesInLayer
{
    for (int row = 1; row <= boardRows; row++) {
        
        for (int col = 1; col <= boardColumns; col++) {
            
            //get random tile to be placed on the board
            int randomIndex = arc4random() % allTiles.count;
            
            MemoryTile *tile = [allTiles objectAtIndex:randomIndex];
            
            tile.position = [self getPositionOfTileAtRow:row
                                               andColumn:col];
            
            tile.row = row; tile.column = col;
            
            //scale to the calculated size
            //scale to x or y , tile is square
            tile.scale = tileSize.width / tile.contentSize.width;
            
            [self addChild:tile];
            
            [allTiles removeObjectAtIndex:randomIndex];
            [currentTiles addObject:tile];
            
            
            
        }
        
    }
}

-(CGPoint)getPositionOfTileAtRow:(int)row andColumn:(int)column
{
    float x = boardOffsetX + (tileSize.width + paddingWidth) * (column - 0.5);
    float y = boardOffsetY + (tileSize.height + paddingHeight) * (row - 0.5);
    
    return ccp(x, y);
}



- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView:touch.view];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    if (isGameOver ||  CGRectContainsPoint(backButton.boundingBox, location)) {
        [self goToMainMenu];
    }
    else
    {
        //we are showing 2 tiles, do nothing
        if (selectedTiles.count == 2) {
            return;
        }
        
        else
        {
            for (MemoryTile *tile in currentTiles) {
                
                //if the touch is on this tile and this tile is not showd(back mode)
                if (!tile.isFaceUp && [tile containsTouchLocation:location]) {
                    
                    //flip the tile to show its face
                    [tile flip];
                    
                    //add it to the current selected tiles
                    [selectedTiles addObject:tile];
                    
                    //check if now i have 2 appeard tiles, so check for matching
                    if (selectedTiles.count == 2) {
                        
                        //check after delay so the player can see the cards
                        [self scheduleOnce:@selector(checkForMatch) delay:1];
                        break;
                    }
                    
                }
            }
        }
    }

}

-(void)checkForMatch
{
    MemoryTile *tile1 = [selectedTiles objectAtIndex:0];
    MemoryTile *tile2 = [selectedTiles objectAtIndex:1];
    
    if (tile1.number == tile2.number) {
        
        
        [self animateTileAndRemove:tile1];
        [self animateTileAndRemove:tile2];
        [self animateScoreDisplay];
        [self updateLivesDisplaySilent];
        [self checkForGameOver];
    }
    else
    {
        //return them to their backs
        [tile1 flip];
        [tile2 flip];
        
        lives -- ;
        
        [self animateLivesDisplay];
        
        if (lives == 0) {
            isGameOver = YES;
        }
    }
    
    [selectedTiles removeAllObjects];
    
}

-(void)animateTileAndRemove:(MemoryTile *)tile
{
    
    float velocity = 600;
    CGPoint differenc = ccpSub(scoreDisplaly.position, tile.position);
    
    float duration = ccpLength(differenc) / velocity;
    
    id moveTo = [CCMoveTo actionWithDuration:duration position:scoreDisplaly.position];
    
    id scaleOut = [CCScaleTo actionWithDuration:duration scale:0.01];
    
    id remove = [CCCallFuncN actionWithTarget:self selector:@selector(removeTileFromView:)];
    
    id moveAndScale = [CCSpawn actions:moveTo,scaleOut, nil];
    
    [tile runAction:[CCSequence actions:moveAndScale, remove, nil]];
    
    [[SimpleAudioEngine sharedEngine] playEffect:SOUND_SCORE];
    
    //remove it from the current tiles array
    [currentTiles removeObject:tile];
    
    lives = currentTiles.count / 2;
    
    score ++;
    
}

-(void)animateScoreDisplay
{
    id delay = [CCDelayTime actionWithDuration:1]; //wait untill matched tiles are animated
    id scaleUp = [CCScaleTo actionWithDuration:0.2 scale:2];
    id update = [CCCallFunc actionWithTarget:self selector:@selector(updateScoreDisplay)];
    id delayAgain = [CCDelayTime actionWithDuration:0.2];
    id scaleDown = [CCScaleTo actionWithDuration:0.2 scale:1];
    
    id beGreen = [CCCallBlock actionWithBlock:^{
        
                    scoreDisplaly.color = ccGREEN;
            }];
    
    id beWhite = [CCCallBlock actionWithBlock:^{
        scoreDisplaly.color = ccWHITE;
    }];
    
    [scoreDisplaly runAction:[CCSequence actions:delay,
                              scaleUp,
                              update,
                              [CCSpawn actions:delayAgain, beGreen, nil],
                              scaleDown, beWhite,nil]];
    
}

-(void)updateScoreDisplay
{
    [scoreDisplaly setString:[NSString stringWithFormat:@"%d", score]];
    [[SimpleAudioEngine sharedEngine] playEffect:SOUND_SCORE];
}

-(void)animateLivesDisplay
{
    id delay = [CCDelayTime actionWithDuration:1]; //wait untill matched tiles are animated
    id scaleUp = [CCScaleTo actionWithDuration:0.2 scale:2];
    id update = [CCCallFunc actionWithTarget:self selector:@selector(updateLivesDisplay)];
    id delayAgain = [CCDelayTime actionWithDuration:0.2];
    id scaleDown = [CCScaleTo actionWithDuration:0.2 scale:1];
    
    id beRed = [CCCallBlock actionWithBlock:^{
        
        livesDisplay.color = ccRED;
    }];
    
    id beWhite = [CCCallBlock actionWithBlock:^{
        livesDisplay.color = ccWHITE;
    }];
    
    [livesDisplay runAction:[CCSequence actions:delay,
                              scaleUp,
                              update,
                              [CCSpawn actions:delayAgain, beRed, nil],
                              scaleDown, beWhite,nil]];
    
}

-(void)updateLivesDisplay
{
    [livesDisplay setString:[NSString stringWithFormat:@"%d", lives]];
    [[SimpleAudioEngine sharedEngine] playEffect:SOUND_TILE_WRONG];
    [self checkForGameOver];
}

-(void)updateLivesDisplaySilent
{
    [livesDisplay setString:[NSString stringWithFormat:@"%d", lives]];
}


-(void)checkForGameOver
{
    NSString *gameOverMsg;
    if (currentTiles.count == 0) {
        //you win
        gameOverMsg = @"You Win!";
    }
    else
        
    {
        if (lives <= 0) {
            gameOverMsg = @"You lose :(";
        }
        else
        {
            return;
        }
    }
    
    CCLabelTTF *gameOverLabel = [CCLabelTTF labelWithString:gameOverMsg fontName:@"Marker Felt" fontSize:70];
    gameOverLabel.position = ccp(winSize.width / 2, winSize.height / 2);
    
    [self addChild:gameOverLabel z:100];
    
    
}



-(void)removeTileFromView:(MemoryTile *)tile
{
    [tile removeFromParentAndCleanup:YES];
    
}

-(void)goToMainMenu
{
    [[CCDirector sharedDirector] replaceScene:[MainMenuScene scene]];
}


- (void)dealloc
{
    [allTiles release];
    [currentTiles release];
    [selectedTiles release];
    [super dealloc];
}

@end
