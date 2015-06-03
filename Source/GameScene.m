//
//  GameScene.m
//  Ligger
//
//  Created by Gene Myers on 13/04/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameScene.h"
//#import "UITouch+CC.h"
#import "CCDirector.h"
#import "Constants.h"

@implementation GameScene
{
    __weak CCNode* _levelNode;
    __weak CCPhysicsNode* _physicsNode;
    __weak CCNode* _playerNode;
    __weak CCNode* _backgroundNode;
}

static Boolean halt = false;
//a static implemntation of Halt
+ (Boolean) halt { return halt; }
+ (void) setHalt:(Boolean)value { halt = value; }


-(void) didLoadFromCCB
{
    
    NSLog(@"GameScene created, Level: %@", _levelNode);
    
    
    // load the current level
    [self loadLevelNamed:nil];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(handleSwipeGesture:)];
    ;swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    //[self addGestureRecognizer:swipeUp];
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeDown];
    
    // enable receiving input events
    self.userInteractionEnabled = YES;
    
}

-(void) exitButtonPressed
{
    NSLog(@"exitButtonPressed");
    
    CCScene* scene = [CCBReader loadAsScene:@"MainScene"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:1.5];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}

-(void) loadLevelNamed:(NSString*)levelCCB
{
    // get the current level's player in the scene by searching for it recursively
    _playerNode = [self getChildByName:@"player1m" recursively:YES];
    NSAssert1(_playerNode, @"player node not found in level: %@", levelCCB);
    
    self.obstacle1 = [self getChildByName:@"obstacle1" recursively:YES];
    self.obstacle2 = [self getChildByName:@"obstacle2" recursively:YES];
    self.obstacle3 = [self getChildByName:@"obstacle3" recursively:YES];
    self.obstacle4 = [self getChildByName:@"obstacle4" recursively:YES];
    self.obstacle5 = [self getChildByName:@"obstacle5" recursively:YES];
    self.obstacle6 = [self getChildByName:@"obstacle6" recursively:YES];
    self.obstacle7 = [self getChildByName:@"obstacle7" recursively:YES];
    self.obstacle8 = [self getChildByName:@"obstacle8" recursively:YES];
    self.obstacle9 = [self getChildByName:@"obstacle9" recursively:YES];
    self.obstacle10 = [self getChildByName:@"obstacle10" recursively:YES];
    self.obstacles = [NSMutableArray arrayWithObjects:self.obstacle1,self.obstacle2,self.obstacle3,self.obstacle4,self.obstacle5,self.obstacle6,self.obstacle7,self.obstacle8,self.obstacle9,self.obstacle10, nil];
    
    self.bartender1 = [self getChildByName:@"bartender1" recursively:YES];
    self.bartender2 = [self getChildByName:@"bartender1" recursively:YES];
    self.bartender3 = [self getChildByName:@"bartender1" recursively:YES];
    self.bartender4 = [self getChildByName:@"bartender1" recursively:YES];
    self.bartender5 = [self getChildByName:@"bartender1" recursively:YES];
    self.bartenders = [NSMutableArray arrayWithObjects:self.bartender1, self.bartender2,self.bartender3,self.bartender4,self.bartender5, nil];
    
    [self performSelector:@selector(startObstacle:forSequence:) withObject:self.obstacle1 withObject:@"default"];
    [self performSelector:@selector(startObstacle:forSequence:) withObject:self.obstacle2 withObject:@"default"];
    [self performSelector:@selector(startObstacle:forSequence:) withObject:self.obstacle3 withObject:@"default"];
    [self performSelector:@selector(startObstacle:forSequence:) withObject:self.obstacle4 withObject:@"default"];
    [self performSelector:@selector(startObstacle:forSequence:) withObject:self.obstacle5 withObject:@"default"];
    [self performSelector:@selector(startObstacle:forSequence:) withObject:self.obstacle6 withObject:@"default"];
    [self performSelector:@selector(startObstacle:forSequence:) withObject:self.obstacle7 withObject:@"default"];
    [self performSelector:@selector(startObstacle:forSequence:) withObject:self.obstacle8 withObject:@"default"];
    [self performSelector:@selector(startObstacle:forSequence:) withObject:self.obstacle9 withObject:@"default"];
    [self performSelector:@selector(startObstacle:forSequence:) withObject:self.obstacle10 withObject:@"default"];
    

}

//-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
//{
//    _playerNode.position = [touch locationInNode:self];
//}

bool bBartenderServering = false;
int cntServing = 0;
CGPoint lastPosition;
CGPoint lastBartenderPos;
int idxBartender = 0;//the current choosen bartender
int cntBartender = 0;
int ttBartender = 0; //the total time for this bartender round

-(void) update:(CCTime)delta
{
    
   if (!GameScene.halt)
   {
    // update scroll node position to player node, with offset to center player in the view
    [self scrollToTarget:_playerNode];
    
    //Move the OBSTACLES across the screen
    for (int i = 0; i < self.obstacles.count; i++)
    {
        CCNode *obstacle = self.obstacles[i];
        //save last position to reset if collision found
        lastPosition = obstacle.position; //_playerNode.position;
        
            
            obstacle.position = ccpSub(obstacle.position, ccp((i % 2)?3.0:-3.0,0));
            
            //obstacle2.position = CGPointMake(obstacle.position.x + 100, obstacle.position.y);
        
            //check for collisions first
            if ([self doesCollide:obstacle withPlayer:_playerNode])
            {
                NSLog(@"++++ COLLIDE ++++++");
                GameScene.halt = true;
                CCAnimationManager* animationManager = _playerNode.userObject;
                [animationManager setPaused:YES];
                //reset
                obstacle.position = lastPosition;
                
                [self performSelector:@selector(pauseObstacle:) withObject:self.obstacle1];
                [self performSelector:@selector(pauseObstacle:) withObject:self.obstacle2];
                [self performSelector:@selector(pauseObstacle:) withObject:self.obstacle3];
                [self performSelector:@selector(pauseObstacle:) withObject:self.obstacle4];
                [self performSelector:@selector(pauseObstacle:) withObject:self.obstacle5];
                [self performSelector:@selector(pauseObstacle:) withObject:self.obstacle6];
                [self performSelector:@selector(pauseObstacle:) withObject:self.obstacle7];
                [self performSelector:@selector(pauseObstacle:) withObject:self.obstacle8];
                [self performSelector:@selector(pauseObstacle:) withObject:self.obstacle9];
                [self performSelector:@selector(pauseObstacle:) withObject:self.obstacle10];

                
                return;
            }
        
        
            if (i%2)
            {
                //Check if they have gone off screen, if they have reposition them
                if (obstacle.position.x < -obstacle.contentSize.width )
                {
                    obstacle.position = ccp(_levelNode.contentSizeInPoints.width+obstacle.contentSize.width+45,obstacle.position.y);
                    //NSLog(@"Offscreen");
                }

            } else {
                //Check if they have gone off screen to the right, if they have reposition them
                if (obstacle.position.x > _levelNode.contentSizeInPoints.width+45 )
                {
                    obstacle.position = ccp(0-obstacle.contentSize.width+45,obstacle.position.y);
                    //NSLog(@"Offscreen");
                }
            }
        

    }

       
    //Move the bartender and time his stay
    //TODO Add magic numbers below as constants
    if (0==cntBartender )  //first pass,
    {
                
        // generate a real number between 0 and 5
        int oldIdx = idxBartender;
        
        //this loop gets a new random Character if it matches the previous Character
        while (idxBartender==oldIdx) {
            idxBartender = (int)(arc4random() % 5000) / 1000.f; //5 magic number
        }
            
        // generate a random number between 2.0 and 7.0
        float stay = ((arc4random() % 5000) / 1000.f)+3;//2 magic number
            
                
        ttBartender = stay * 30; //stay in secs mult by 30 fps
                
        int point = (72+((105*(idxBartender))+1)); //72 & 105- magic numbers
        ((CCNode*)self.bartenders[idxBartender]).position = CGPointMake( point, ((CCNode*)self.bartenders[idxBartender]).position.y);
        
        if ([self doesCollide:self.bartenders[idxBartender] withPlayer:_playerNode])
        {
            NSLog(@"BARTENDER %d SERVING", idxBartender);
            bBartenderServering = true;
        }
        
        cntBartender = 1;
                
   }
   else if (cntBartender==ttBartender)
   {
       cntBartender = 0;
   }
   else
   {
       
       if (bBartenderServering)
       {
           cntServing += 1;
           
           //one sec serving time has elapsed
           if (cntServing==150)
           {
               //do an animation here or just flip the ligger
               NSLog(@"BARTENDER Finished SERVING");
               cntBartender = 0;
               cntServing = 0;
               bBartenderServering= false;
           }
       }
       else
       {
           cntBartender += 1;
       }
   }



   }
}

-(Boolean) doesCollide:(CCNode*)obstacle withPlayer:(CCNode*) player
{
    Boolean rtn = false;
    CGPoint obstacleWorld = [obstacle convertToWorldSpace:obstacle.position];
    CGPoint playerWorld = [player convertToWorldSpace: player.position];
    if (obstacleWorld.y >= playerWorld.y - player.boundingBox.size.height && obstacleWorld.y - obstacle.boundingBox.size.height <= playerWorld.y)
    {
        //and the horizontal axis collides
        if (obstacleWorld.x + obstacle.boundingBox.size.width >= playerWorld.x && obstacleWorld.x <= + playerWorld.x + player.boundingBox.size.height)
        {
            rtn = true;//doesCollide
        }
    }
  
    return rtn;
}

-(void) scrollToTarget:(CCNode*)target
{
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    CGPoint viewCenter = CGPointMake(viewSize.width / 2.0, viewSize.height / 2.0);
    CGPoint viewPos = ccpSub(target.positionInPoints, viewCenter);
    CGSize levelSize = _levelNode.contentSizeInPoints;
    viewPos.x = MAX(0.0, MIN(viewPos.x, levelSize.width - viewSize.width));
    viewPos.y = MAX(0.0, MIN(viewPos.y, levelSize.height - viewSize.height));
    _levelNode.positionInPoints = ccpNeg(viewPos);
}

- (void)startObstacle:(CCNode*)node forSequence:(NSString*)sequenceName
{
    // the animation manager of each node is stored in the 'animationManager' property
    CCAnimationManager* animationManager = node.animationManager;
    // timelines can be referenced and run by name
    [animationManager runAnimationsForSequenceNamed:sequenceName];
}

- (void)pauseObstacle:(CCNode*)node
{
    // the animation manager of each node is stored in the 'animationManager' property
    CCAnimationManager* animationManager = node.animationManager;
    [animationManager setPaused:YES];
}


- (void)startHustleRight
{
    // the animation manager of each node is stored in the 'animationManager' property
    CCAnimationManager* animationManager = _playerNode.animationManager;
    // timelines can be referenced and run by name
    [animationManager runAnimationsForSequenceNamed:@"HustleRight"];
}

- (void)startHustleLeft
{
    // the animation manager of each node is stored in the 'animationManager' property
    CCAnimationManager* animationManager = _playerNode.animationManager;
    // timelines can be referenced and run by name
    [animationManager runAnimationsForSequenceNamed:@"HustleLeft"];
}

- (void)startHustleUp
{
    // the animation manager of each node is stored in the 'animationManager' property
    CCAnimationManager* animationManager = _playerNode.animationManager;
    // timelines can be referenced and run by name
    [animationManager runAnimationsForSequenceNamed:@"HustleUp"];
}

- (void)startHustleDown
{
    // the animation manager of each node is stored in the 'animationManager' property
    CCAnimationManager* animationManager = _playerNode.animationManager;
    // timelines can be referenced and run by name
    [animationManager runAnimationsForSequenceNamed:@"HustleDown"];
}


-(void)handleSwipeGesture:(UISwipeGestureRecognizer *) sender
{
    if (GameScene.halt) return;
    
    switch( sender.direction ) {
        case UISwipeGestureRecognizerDirectionUp:
            NSLog(@"SwipeUp");
            if ((_playerNode.position.y) < kBOARDTOPBOUND) //keeps with top boundry
                //ccp is a macro for CGPointMake(x, y)
                _playerNode.position = CGPointMake(_playerNode.position.x,_playerNode.position.y+kVERTICALMOVE);
            // call method to start animation
            [self performSelector:@selector(startHustleUp) withObject:nil];
            break;
        case UISwipeGestureRecognizerDirectionDown:
            NSLog(@"SwipeDown");
            if ((_playerNode.position.y) > kBOARDBOTTOMBOUND) //keeps with bottom boundry
                _playerNode.position = CGPointMake(_playerNode.position.x,_playerNode.position.y-kVERTICALMOVE);
            // call method to start animation
            [self performSelector:@selector(startHustleDown) withObject:nil];
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            NSLog(@"SwipeLeft");
            if ((_playerNode.position.x) > kBOARDLEFTBOUND) //keeps with left boundry
                _playerNode.position = CGPointMake(_playerNode.position.x-kHORIZONTALMOVE,_playerNode.position.y);
            // call method to start animation
            [self performSelector:@selector(startHustleLeft) withObject:nil];
            break;
        case UISwipeGestureRecognizerDirectionRight:
            NSLog(@"SwipeRight");
            if ((_playerNode.position.x) < kBOARDRIGHTBOUND) //keeps with right boundry
                _playerNode.position = CGPointMake(_playerNode.position.x+kHORIZONTALMOVE,_playerNode.position.y);
            // call method to start animation
            [self performSelector:@selector(startHustleRight) withObject:nil];
            break;
    }
    
}

@end
