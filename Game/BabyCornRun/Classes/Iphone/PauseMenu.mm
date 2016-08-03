

#import "PauseMenu.h"
#import "MainMenu.h"
#import "globals.h"
#import "FullLayer.h"
#import "GameLayer.h"
#import "AppDelegate.h"


@implementation PauseMenu

+(id)scene
{
    CCScene *scene =[CCScene node];
    PauseMenu *layer =[PauseMenu node];
    [scene addChild:layer];
    return scene;
}
-(id)init
{
    if(self=[super init])
    {
        

        self.isTouchEnabled=YES;
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;       
        
        CCSprite *background = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"pausebg.png")]];
//        background.anchorPoint = ccp(0.0, 1.0);
        background.position = ccp (240*g_fx, 160*g_fy);
        //[self addChild:background z:0];
        
        CCSprite *pauseMsg = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"gamepaused.png")]];
        pauseMsg.position = ccp (240*g_fx, 210*g_fy);
        [self addChild:pauseMsg z:0];
                
        CCMenuItem *mainmenu = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"main menu button-1.png")]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"main menu button-2.png")]]
                                                           target:self
                                                         selector:@selector(goToMenu:)];
        mainmenu.position = ccp(171*g_fx, 128*g_fy);
        
        CCMenuItem *resume = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"resume button-1.png")]]
                                                        selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"resume button-2.png")]]
                                                                target:self
                                                              selector:@selector(resumeGame:)];
        resume.position = ccp(310*g_fx, 128*g_fy);
        
        CCMenuItem *ssoundon = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"sound button-1.png")]]
                                                       selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"sound button-1.png")]]
                                                               target:self
                                                             selector:@selector(switchEffectSound:)];
        ssoundon.position = ccp(444*g_fx, 290*g_fy);
        
        effectSoundoff = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"soundoff.png")]];
//        effectSoundoff.anchorPoint = ccp(0.0, 1.0);
        effectSoundoff.position = ccp (444*g_fx, 290*g_fy);
        if (effectsoundOn)
            effectSoundoff.visible = NO;
        [self addChild:effectSoundoff z:11];
        
        CCMenuItem *bsoundon = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"music button-1.png")]]
                                                       selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"music button-1.png")]]
                                                               target:self
                                                             selector:@selector(switchBackSound:)];
        bsoundon.position = ccp(390*g_fx, 290*g_fy);
        
        backSoundoff = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"soundoff.png")]];
//        backSoundoff.anchorPoint = ccp(0.0, 1.0);
        backSoundoff.position = ccp (390*g_fx, 290*g_fy);
        if (backSoundOn)
            backSoundoff.visible = NO;
        [self addChild:backSoundoff z:11];
                        
        menu = [CCMenu menuWithItems: mainmenu, resume, ssoundon, bsoundon, nil];
        [menu setPosition:ccp(0, 0)];
        [self addChild: menu z:10];
        
        if(![MKStoreManager featureAPurchased])
        {
        
            [ALInterstitialAd showOver:[[UIApplication sharedApplication] keyWindow]];

        
        }

    }
    
    return self;
}


- (void) resumeGame: (id) sender
{

    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    isPaused=false;
    [self.parent resumeSchedulerAndActionsRecursive:self.parent];
    
    [self.parent removeChild:self cleanup:YES];
}

- (void) goToMenu: (id) sender
{
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MainMenu scene]] ];
    
    if (![MKStoreManager featureAPurchased])
    {
        [[RevMobAds session] showFullscreen];
    
        [[AppDelegate get]showChartBoostFullScreen];
    
    }

}

- (void) switchBackSound: (id) sender
{
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    if(backSoundOn)
    {   
        backSoundOn = false;
        backSoundoff.visible = YES;
        if ([[AppDelegate get].m_pSoundEngine isBackgroundMusicPlaying])
            [[AppDelegate get].m_pSoundEngine pauseBackgroundMusic];
        
    }
    else
    {
        backSoundOn = true;
        backSoundoff.visible = NO;
        [[AppDelegate get].m_pSoundEngine resumeBackgroundMusic];  
    }
}

- (void) switchEffectSound: (id) sender
{
    [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    if (effectsoundOn) {
        effectsoundOn = false;
        effectSoundoff.visible = YES;
    }
    else {
        effectsoundOn = true;
        effectSoundoff.visible = NO;
    }
}

-(void) ccTouchesEnded:(NSSet *)touch withEvent:(UIEvent *)event

{
    NSSet *allTouches= [event allTouches];
    
    for (UITouch * touch in allTouches)
    {
        
        if(touch.phase==UITouchPhaseEnded)
        {        
            CGPoint location = [touch locationInView:[touch view]];
            location = [[CCDirector sharedDirector] convertToGL:location]; 
        }
    }
}

-(void) dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}


@end
