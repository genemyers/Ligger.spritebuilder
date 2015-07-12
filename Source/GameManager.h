//
//  GameManager.h
//  Ligger
//
//  Created by Gene Myers on 01/07/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameData.h"
#import "ScoreData.h"
#import "LevelTimer.h"

@class LevelTimer;
@interface GameManager : CCNode //: NSObject


@property (nonatomic) GameData* _gameData;
@property (nonatomic) ScoreData* _scores;
@property (nonatomic) LevelTimer* _timer;
@property (nonatomic) NSNumber* _level;

//-(id) initWithGamedata:(GameData*)gameData;
-(id) initWithTimer:(LevelTimer*)timer;
-(void) incrementLevelCount;
-(void) gameOver;

@end
