

#import "HowToPlayLayer.h"
#import "globals.h"
#import "FullLayer.h"
#import "AppDelegate.h"
#import "MKStoreManager.h"

@implementation HowToPlayLayer

+(id)scene
{
    CCScene *scene =[CCScene node];
    HowToPlayLayer *layer =[HowToPlayLayer node];
    [scene addChild:layer];
    return scene;
}

-(id)init
{
    if(self=[super init])
    {
        self.isTouchEnabled=YES;
        
        

        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *background;
        if([[UIScreen mainScreen] bounds].size.height==568)
            background= [CCSprite spriteWithFile:res(@"bg1-iphone5.png")];
        else
            background= [CCSprite spriteWithFile:res(@"bg1.png")];
        background.anchorPoint = ccp(0.0, 1.0);
        background.position = ccp (0, screenSize.height);
        [self addChild:background z:0];
        
        CCSprite *howto = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"howto.png")]];
        howto.anchorPoint = ccp(0.5, 0.5);
        howto.position = ccp (220*g_fx, 160*g_fy);
        [self addChild:howto z:0];
        
        
        CCMenuItem *close = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"delete button-1.png")]]
                                                       selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"delete button-2.png")]]
                                                               target:self
                                                             selector:@selector(goToPlay:)];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            close.position = ccp(195*g_fx, 200);
        else
            close.position = ccp(175*g_fx, 100);
                
        menu = [CCMenu menuWithItems: close, nil];
        [self addChild: menu z:10];
        
    }
    
    return self;
}


- (void) goToPlay: (id) sender
{    
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
        
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[FullLayer scene]] ];
}

-(void) dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}


@end
