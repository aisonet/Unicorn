

#import "MainMenu_ipad.h"
#import "FullLayer_ipad.h"
#import "ShopMenu_ipad.h"
#import "MainBackLayer_ipad.h"

#import "AppDelegate.h"
#import "HowToPlayLayer_ipad.h"

#import "RootViewController.h"

#ifdef FREE_VERSION
#endif

@implementation MainMenu_ipad

#ifdef FREE_VERSION
@synthesize adView;
#endif

+(id) scene
{
    CCScene *scene = [CCScene node];
    
    MainMenu_ipad *layer = [MainMenu_ipad node];
    
    [scene addChild: layer];
    
    return scene;
}

-(id) init
{
    
    if( (self=[super init] )) {
        
        self.isTouchEnabled = YES;
        
        if ([AppDelegate get].NagScreen) 
        {
            [self AddNagScreen];
            [AppDelegate get].NagScreen=FALSE;
        }
        
        screenSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *background = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"bg1-ipad.png"]];
        background.anchorPoint = ccp(0.0, 1.0);
        background.position = ccp (0, screenSize.height);
        [self addChild:background z:0];
                        
        CCSprite *logo = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"logo1-hd.png"]];
        logo.anchorPoint = ccp(0.0, 1.0);
        logo.position = ccp (0, screenSize.height);
        [self addChild:logo z:0];
        
        isProgressBuy= false;

#ifdef FREE_VERSION
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        removeads = [prefs boolForKey:@"removeads"];
        
        if (!removeads) {
            adsbox = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"box-hd.png"]];
            adsbox.anchorPoint = ccp(0.0, 1.0);
            adsbox.position = ccp (765, screenSize.height+6);
            [self addChild:adsbox z:0];
            
            noads = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"support-hd.png"]];
            noads.anchorPoint = ccp(0.0, 1.0);
            noads.position = ccp (770, screenSize.height+6);
            [self addChild:noads z:0];
            
            adsbox.visible = NO;
            noads.visible = NO;
        }
#endif


        //placeholder music
        if (backSoundOn)
            [[AppDelegate get].m_pSoundEngine playBackgroundMusic:@"gameplay.mp3"];
        
        
        CCMenuItem *play = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"play-hd.png"]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"play-hd.png"]]
                                                           target:self
                                                         selector:@selector(startGame:)];
        play.position = ccp(100, 90);
        
        CCMenuItem *moreGames = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"more-hd.png"]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"more-hd.png"]]
                                                           target:self
                                                         selector:@selector(openMoreApps:)];
        moreGames.position = ccp(390, -50);
        
        CCMenuItem *news = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"news-hd.png"]]
                                                        selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"news-hd.png"]]
                                                                target:self
                                                              selector:@selector(openNews:)];
        news.position = ccp(230, 60);
        
        CCMenuItem *shop = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"shop1-hd.png"]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"shop1-hd.png"]]
                                                           target:self
                                                         selector:@selector(openShop:)];
        shop.position = ccp(230, -60);
        
        CCMenuItem *achievements = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"achievements-hd.png"]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"achievements-hd.png"]]
                                                           target:self
                                                         selector:@selector(openAchievements:)];
        achievements.position = ccp(110, -170);
        
        CCMenuItem *gamecenter = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"gicon-hd.png"]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"gicon-hd.png"]]
                                                           target:self
                                                         selector:@selector(openGameCenter:)];
        gamecenter.position = ccp(210, -170);
        
        CCMenuItem *bsoundon = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"bsoundon-hd.png"]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"bsoundon-hd.png"]]
                                                           target:self
                                                         selector:@selector(switchBackSound:)];
        bsoundon.position = ccp(310, -170);
        
        backSoundoff = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"soundoff-hd.png"]];
        backSoundoff.anchorPoint = ccp(0.0, 1.0);
        backSoundoff.position = ccp (753.5, screenSize.height-504);
        if (backSoundOn)
            backSoundoff.visible = NO;
        [self addChild:backSoundoff z:11];
        
        CCMenuItem *ssoundon = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"ssoundon-hd.png"]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"ssoundon-hd.png"]]
                                                           target:self
                                                         selector:@selector(switchEffectSound:)];
        ssoundon.position = ccp(420, -170);
        
        effectSoundoff = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"soundoff-hd.png"]];
        effectSoundoff.anchorPoint = ccp(0.0, 1.0);
        effectSoundoff.position = ccp (873.5, screenSize.height-504);
        if (effectsoundOn)
            effectSoundoff.visible = NO;
        [self addChild:effectSoundoff z:11];
        
        menu = [CCMenu menuWithItems: play, moreGames, news, shop, achievements, gamecenter, bsoundon, ssoundon, nil];
        [self addChild: menu z:10];
        
        MainBackLayer_ipad *mainbacklayer=[[MainBackLayer_ipad alloc] init];
        [self addChild:mainbacklayer z:5];
        [mainbacklayer release];  
        
        [[AppDelegate get].viewController authenticate];
        
#ifdef FREE_VERSION
        removeads = [prefs boolForKey:@"removeads"];
        
        if (!removeads) {
            [self schedule:@selector(checkRemoveAds:) interval:1.0];
        }
#endif
        
    }
    
    return self;
}

#ifdef FREE_VERSION
-(void) checkRemoveAds: (ccTime) delta
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    removeads = [prefs boolForKey:@"removeads"];
    
    if (removeads) {
                
        adsbox.visible = NO;
        noads.visible = NO;
        [self unschedule:@selector(checkRemoveAds:)];
    }
}
#endif

- (void) startGame: (id) sender
{    
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];

    if (!shownHowToPlay) {
        shownHowToPlay = true;
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[HowToPlayLayer_ipad scene]] ];
    }
    else {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[FullLayer_ipad scene]] ];
    }
}

- (void) openMoreApps: (id) sender
{
    
}

- (void) openNews: (id) sender
{
    
}

- (void) openShop: (id) sender
{    
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[ShopMenu_ipad scene:true]] ];
}


- (void) openAchievements: (id) sender
{    
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    RootViewController *rootViewController = [AppDelegate get].viewController;
    
    [rootViewController showAchievements];
}

- (void) openGameCenter: (id) sender
{    
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    RootViewController *rootViewController = [AppDelegate get].viewController;
    [rootViewController showLeaderboard];
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


-(void)onEnter {
        

    
        
    [super onEnter];
}

-(void)onExit {
    //There's something weird about AdWhirl because setting the adView delegate
    //to "nil" doesn't stops the Ad requests and also it doesn't remove the adView
    //from superView; do the following to remove AdWhirl from your scene.
    //
        [super onExit];
}

-(void)AddNagScreen
{
    
}

-(void)ProcessStart
{
      
}
-(void)ProcessComplete
{}

- (void)tapBtn:(id)sender
{
    
}
- (void)cancelBtnClicked:(id)sender
{
}

-(void)setData:(NSString *)message items:(NSMutableArray *)items Tag:(int)tag
{   
    if (tag==100) 
    {
        nagArray=items;
        [self performSelectorOnMainThread:@selector(ProcessComplete) withObject:nil waitUntilDone:NO];
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
            
#ifdef FREE_VERSION
            CGRect remove = CGRectMake(765, screenSize.height-88, 265, 88);
            if (CGRectContainsPoint(remove, location))
            {
                if (effectsoundOn)
                    [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
                
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                bool isRemoved = [prefs boolForKey:@"removeads"];
                
                if (!isRemoved && !isProgressBuy) {
                    isProgressBuy = true;
                    [[AppDelegate get] buyIAPitem:kTagRemoveAds];
                }

            }
#endif
        }
    }
}

- (void) dealloc
{
#ifdef FREE_VERSION
    //Remove the adView controller
    self.adView.delegate = nil;
    self.adView = nil;
#endif
    
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}

@end