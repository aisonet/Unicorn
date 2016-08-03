

#import "ShopMenu_ipad.h"
#import "MainMenu_ipad.h"
#import "globals.h"
#import "GameOver_ipad.h"
#import "AppDelegate.h"
#import "RootViewController.h"

@implementation ShopMenu_ipad

+(id)scene:(bool)mainmenu
{
    isFromMain = mainmenu;
    CCScene *scene =[CCScene node];
    ShopMenu_ipad *layer =[ShopMenu_ipad node];
    [scene addChild:layer];
    return scene;
}

-(id)init
{
    if(self=[super init])
    {
        CGSize screenSize = [CCDirector sharedDirector].winSize;       
        
        CCSprite *background = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"pausebg-ipad.png"]];
        background.anchorPoint = ccp(0.0, 1.0);
        background.position = ccp (0, screenSize.height);
        [self addChild:background z:0];
        
        CCSprite *shopMsg = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"shop3-hd.png"]];
        shopMsg.anchorPoint = ccp(0.0, 1.0);
        shopMsg.position = ccp (366, screenSize.height-20);
        [self addChild:shopMsg z:0];
        
        CCSprite *lives = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"lives-hd.png"]];
        lives.anchorPoint = ccp(0.0, 1.0);
        
#ifdef FREE_VERSION
        lives.position = ccp (20, screenSize.height-192);
#else
        lives.position = ccp (130, screenSize.height-192);
#endif
        [self addChild:lives z:0];
        
        CCSprite *revive = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"revive-hd.png"]];
        revive.anchorPoint = ccp(0.0, 1.0);
        
#ifdef FREE_VERSION
        revive.position = ccp (328, screenSize.height-200);
#else
        revive.position = ccp (590, screenSize.height-200);
#endif
        [self addChild:revive z:0];
        
#ifdef FREE_VERSION
        CCSprite *removeads = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"removeads-hd.png"]];
        removeads.anchorPoint = ccp(0.0, 1.0);
        removeads.position = ccp (618, screenSize.height-176);
        [self addChild:removeads z:0];
#endif
                
        isProgressBuy = false;
        
        buyLives = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"buy-hd.png"]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"buy-hd.png"]]
                                                           target:self
                                                         selector:@selector(buyLives:)];
#ifdef FREE_VERSION
        buyLives.position = ccp(-314, -242);
#else
        buyLives.position = ccp(-235, -242);
#endif
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        bool buy10lives = [prefs boolForKey:@"buy10lives"];
        
        disableBuyLives = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"soundoff-hd.png"]];
        disableBuyLives.anchorPoint = ccp(0.0, 1.0);
        
#ifdef FREE_VERSION
        disableBuyLives.position = ccp (132, screenSize.height-570);
#else
        disableBuyLives.position = ccp (212, screenSize.height-570);
#endif
        [self addChild:disableBuyLives z:11];
        
        if (buy10lives) {
            buyLives.isEnabled = false;
            disableBuyLives.visible = YES;
        }
        else {
            disableBuyLives.visible = NO;
        }
        
        CCMenuItem *buy1 = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"buy1-hd.png"]]
                                                        selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"buy1-hd.png"]]
                                                                target:self
                                                              selector:@selector(buy1Life:)];
#ifdef FREE_VERSION
        buy1.position = ccp(-72, -242);
#else
        buy1.position = ccp(158, -242);
#endif
        
        
        CCMenuItem *buy3 = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"buy3-hd.png"]]
                                                       selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"buy3-hd.png"]]
                                                               target:self
                                                             selector:@selector(buy3Life:)];
#ifdef FREE_VERSION
        buy3.position = ccp(72, -234);
#else
        buy3.position = ccp(302, -234);
#endif
                
#ifdef FREE_VERSION
        removeAds = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"remove-hd.png"]]
                                                       selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"remove-hd.png"]]
                                                               target:self
                                                             selector:@selector(removeAds:)];
        removeAds.position = ccp(298, -234);
        bool isRemoveAds = [prefs boolForKey:@"removeads"];
        
        disableRemoveAds = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"soundoff-hd.png"]];
        disableRemoveAds.anchorPoint = ccp(0.0, 1.0);
        disableRemoveAds.position = ccp (740, screenSize.height-570);
        [self addChild:disableRemoveAds z:11];
        
        if (isRemoveAds) {
            removeAds.isEnabled = false;
            disableRemoveAds.visible = YES;
        }
        else {
            disableRemoveAds.visible = NO;
        }
#endif
                
        CCMenuItem *back = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"back-hd.png"]]
                                                     selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"back-hd.png"]]
                                                             target:self
                                                           selector:@selector(backToPrev:)];
        back.position = ccp(-430, 324);
        
        bool isRated = [prefs boolForKey:@"rateapp"];
        
#ifdef FREE_VERSION        
        if (!isRated) {
            rate = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"rate-hd.png"]]
                                                       selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"rate-hd.png"]]
                                                               target:self
                                                             selector:@selector(goToAppRate:)];
            rate.position = ccp(336, 325);
            
            menu = [CCMenu menuWithItems: buyLives, buy1, buy3, removeAds, back, rate, nil];

        }
        else {
            menu = [CCMenu menuWithItems: buyLives, buy1, buy3, removeAds, back, nil];
        }
#else
        if (!isRated) {
            rate = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"rate-hd.png"]]
                                           selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"rate-hd.png"]]
                                                   target:self
                                                 selector:@selector(goToAppRate:)];
            rate.position = ccp(336, 325);
            
            menu = [CCMenu menuWithItems: buyLives, buy1, buy3, back, rate, nil];
            
        }
        else {
            menu = [CCMenu menuWithItems: buyLives, buy1, buy3, back, nil];
        }
#endif
        
        [self addChild: menu];

    }
    
    return self;
}

- (void) buyLives: (id) sender
{
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    bool buy10lives = [prefs boolForKey:@"buy10lives"];
    if (!buy10lives && !isProgressBuy) {
         isProgressBuy = true;
         [[AppDelegate get] buyIAPitem:kTagStartWith10Lives];
    }
}

- (void) buy1Life: (id) sender
{
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    if (!isProgressBuy) {
        isProgressBuy = true;
        [[AppDelegate get] buyIAPitem:kTagBuy1Revive];
    }
}

- (void) buy3Life: (id) sender
{
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    if (!isProgressBuy) {
        isProgressBuy = true;
        [[AppDelegate get] buyIAPitem:kTagBuy3Revives];
    }    
}

#ifdef FREE_VERSION
- (void) removeAds: (id) sender
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

- (void) goToAppRate: (id) sender
{
#ifdef FREE_VERSION
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://bit.ly/cfreereview"]];
#else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://bit.ly/cplusreview"]];
#endif
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:true forKey:@"rateapp"];
    
    RootViewController *rootViewController = [AppDelegate get].viewController;
    [rootViewController checkAchievements:kTagRateCorn];
    
    if (rate) {
        rate.visible = NO;
    }
    revivesLeft += 3;
}

- (void) backToPrev: (id) sender
{    
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    if (isFromMain) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MainMenu_ipad scene]] ];
    }
    else {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GameOver_ipad scene]] ];
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
