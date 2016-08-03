

#import "HowToPlayLayer_ipad.h"
#import "globals.h"
#import "FullLayer_ipad.h"
#import "AppDelegate.h"

@implementation HowToPlayLayer_ipad

+(id)scene
{
    CCScene *scene =[CCScene node];
    HowToPlayLayer_ipad *layer =[HowToPlayLayer_ipad node];
    [scene addChild:layer];
    return scene;
}

-(id)init
{
    if(self=[super init])
    {
        self.isTouchEnabled=YES;
        
        CGSize screenSize = [CCDirector sharedDirector].winSize; 
        
        CCSprite *background = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"bg1-ipad.png"]];
        background.anchorPoint = ccp(0.0, 1.0);
        background.position = ccp (0, screenSize.height);
        [self addChild:background z:0];
        
        CCSprite *howto = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"howto-hd.png"]];
        howto.anchorPoint = ccp(0.5, 0.5);
        howto.position = ccp (512, 384);
        [self addChild:howto z:0];
        
        
        CCMenuItem *close = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"close-hd.png"]]
                                                       selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"close-hd.png"]]
                                                               target:self
                                                             selector:@selector(goToPlay:)];
        close.position = ccp(330, 210);
                
        menu = [CCMenu menuWithItems: close, nil];
        [self addChild: menu z:10];
        
    }
    
    return self;
}


- (void) goToPlay: (id) sender
{    
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
        
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[FullLayer_ipad scene]] ];
}

-(void) dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}


@end
