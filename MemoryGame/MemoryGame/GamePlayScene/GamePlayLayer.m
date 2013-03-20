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
    
    livesDisplay  = [CCLabelTTF labelWithString:@"10" fontName:@"Marker Felt" fontSize:20];
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
        score ++;
        lives++;
        [self removeTileFromView:tile1];
        [self removeTileFromView:tile2];
       
    }
    else
    {
        //return them to their backs
        [tile1 flip];
        [tile2 flip];
        
        lives -- ;
        if (lives == 0) {
            isGameOver = YES;
        }
    }
    
    [selectedTiles removeAllObjects];
    
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
