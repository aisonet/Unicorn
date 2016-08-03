

#import "FullLayer_ipad.h"
#import "HudLayer_ipad.h"
#import "GameLayer_ipad.h"
#import "globals.h"

@implementation FullLayer_ipad
+(id)scene
{
    CCScene *scene=[CCScene node];
    FullLayer_ipad *layer=[FullLayer_ipad node];
    [scene addChild:layer];
    return scene;
}

-(id)init
{
    if(self=[super init])
    {
        isGrounded = false;
        runMeters = 0;
        isPlayerRunning = true;
        additionalSpeed = 0;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        bool buy10lives = [prefs boolForKey:@"buy10lives"];
        
        if (buy10lives) {
            lifesLeft = 10;
        }
        else {
#ifdef FREE_VERSION
            lifesLeft = 3;
#else
            lifesLeft = 6;
#endif
        }
        
        //revivesLeft = 10;
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        CCSprite *background = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat: @"bg1-ipad.png"]]];
        background.anchorPoint = ccp(0.0, 1.0);
        background.position = ccp (0, screenSize.height);
        [self addChild:background z:0];
        
        loading = [[CCLabelTTF alloc] initWithString:@"Loading..." dimensions:CGSizeMake(300, 80)
                                                       alignment:UITextAlignmentLeft fontName:@"Palatino" fontSize:64.0f];
        loading.position = ccp(500.0,350.0);
        loading.color = ccBLACK;
        [self addChild:loading z:0];
                
        GameLayer_ipad *gamelayer = [[GameLayer_ipad alloc] init];
        [self addChild:gamelayer z:0];
        [GameLayer_ipad release];
        
    }
    return self;
}

- (void)addHudLayer_ipad {
    loading.visible = NO;
    HudLayer_ipad *hudlayer=[[HudLayer_ipad alloc] init];
    [self addChild:hudlayer z: 1];
    [HudLayer_ipad release];
}

- (void)pauseSchedulerAndActionsRecursive:(CCNode *)node {
    printf("tryingtopausein full");   
    [node pauseSchedulerAndActions];
    for (CCNode *child in [node children]) {
        [self pauseSchedulerAndActionsRecursive:child];
    }
}

- (void)resumeSchedulerAndActionsRecursive:(CCNode *)node {
    [node resumeSchedulerAndActions];
    for (CCNode *child in [node children]) {
        [self resumeSchedulerAndActionsRecursive:child];
    }
}  

-(void)dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
    
}
@end
