//
//  Constants.h
//  Ligger
//
//  Created by Gene Myers on 19/04/2015.
//  Copyright (c) 2015 Fezzee Limited. All rights reserved.
//

#import "CCNode.h"
#import <Foundation/Foundation.h>

//#ifndef Ligger_Constants_h
//#define Ligger_Constants_h


//TODO: This needs a comment
#define CASE(str)                       if ([__s__ isEqualToString:(str)])
#define SWITCH(s)                       for (NSString *__s__ = (s); ; )
#define DEFAULT

#define isiPhoneWide  ([[UIScreen mainScreen] bounds].size.width == 568)?TRUE:FALSE
#define isiPhone  (UI_USER_INTERFACE_IDIOM() == 0)?TRUE:FALSE

#define ALLOWED_CHARECTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"


typedef enum PlayerMoveState {PlayerUp, PlayerDown, PlayerLeft, PlayerRight} PlayerMoveState;
typedef enum PlayerState {NoBeers, TwoBeers, OneBeer} PlayerState;
typedef enum LevelState {GameSetup, PlayGame, CompleteLevel, LevelUp} LevelState;
typedef enum ObstacleDirection {MoveLeft,MoveRight} ObstacleDirection;
typedef enum Ligger {GeordieGunter,SparklePony} Ligger;
typedef enum Navigation {Swipe,Touch} Navigation;

extern const bool EASYPASS;
extern const bool TESTUTILS;
extern const bool VERBOSE_CONSOLE;
extern const int kPROMOTORS;
extern const int kTOTALTIMER;

extern const int kBOARDTOPBOUND;
extern const int kBOARDBOTTOMBOUND;
extern const int kBOARDLEFTBOUND;
extern const int kBOARDRIGHTBOUND;

extern const int kHORIZONTALMOVE;
extern const int kVERTICALMOVE;

extern const int kMAXUSERNAMELENGTH;

//const int kMedianStripRow = 432;

extern const int kStartOffset;
extern const int kStopOffset;

//extern const float kSPEED;

FOUNDATION_EXPORT NSString *const WEBSERVURL;
FOUNDATION_EXPORT NSString *const SHAREDSECRET;

//#endif
