

#import "ShopMenu.h"
#import "MainMenu.h"
#import "globals.h"
#import "GameOver.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "MKStoreManager.h"
#import <RevMobAds/RevMobAds.h>

@implementation ShopMenu

+(id)scene:(bool)mainmenu
{
    isFromMain = mainmenu;
    CCScene *scene =[CCScene node];
    ShopMenu *layer =[ShopMenu node];
    [scene addChild:layer];
    return scene;
}

-(id)init
{
    if(self=[super init])
    {

        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *background;
        if([[UIScreen mainScreen] bounds].size.height==568)
            background= [CCSprite spriteWithFile:res(@"bg1-iphone5.png")];
        else
            background= [CCSprite spriteWithFile:res(@"bg1.png")];
        background.anchorPoint = ccp(0.0, 1.0);
        background.position = ccp (0, screenSize.height);
        [self addChild:background z:0];
        
        CCSprite *shopMsg = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"shop3.png")]];
        shopMsg.anchorPoint = ccp(0.0, 1.0);
        shopMsg.position = ccp (183*g_fx, screenSize.height-10*g_fy);
        [self addChild:shopMsg z:0];
        
        CCSprite *lives = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"dragon live.png")]];
        
#ifdef FREE_VERSION
        lives.position = ccp (10*g_fx, screenSize.height-96*g_fy);
#else
        lives.position = ccp (153*g_fx, 175*g_fy);
#endif
        
        [self addChild:lives z:0];
        
        CCSprite* txtlives = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"start with 10 lives.png")]];
        txtlives.position = ccp (153*g_fx, 127*g_fy);
        [self addChild:txtlives z:0];
        
        CCSprite *revive = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"revive.png")]];
        revive.anchorPoint = ccp(0.0, 1.0);
        
        revive.position = ccp (screenSize.width*0.6, screenSize.height-120*g_fy);
        [self addChild:revive z:0];
 
#ifdef FREE_VERSION
        CCSprite *removeads = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"removeads.png")]];
        removeads.anchorPoint = ccp(0.0, 1.0);
        removeads.position = ccp (309*g_fx, screenSize.height-88*g_fy);
        [self addChild:removeads z:0];
#endif
        
        isProgressBuy = false;
        
        buyLives = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"buy button-1.png")]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"buy button-2.png")]]
                                                           target:self
                                                         selector:@selector(buyLives:)];
#ifdef FREE_VERSION
        buyLives.position = ccp(-157*g_fx, -121*g_fy);
#else
        buyLives.position = ccp(-105*g_fx, -90*g_fy);
#endif
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//        bool buy10lives = [prefs boolForKey:@"buy10lives"];
        bool buy10lives = [MKStoreManager featureBPurchased];
        
        disableBuyLives = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"soundoff.png")]];
        disableBuyLives.anchorPoint = ccp(0.0, 1.0);
        
#ifdef FREE_VERSION
        disableBuyLives.position = ccp (53.5*g_fx, screenSize.height-256*g_fy);
#else
        disableBuyLives.position = ccp (113.5*g_fx, screenSize.height-256*g_fy);
#endif
        [self addChild:disableBuyLives z:11];
        
        if (buy10lives) {
            buyLives.isEnabled = false;
            disableBuyLives.visible = YES;
        }
        else {
            disableBuyLives.visible = NO;
        }
        
        CCMenuItem *buy1 = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"buy1-1.png")]]
                                                        selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"buy1-2.png")]]
                                                                target:self
                                                              selector:@selector(buy1Life:)];
#ifdef FREE_VERSION
        buy1.position = ccp(-36*g_fx, -121*g_fy);
#else
        buy1.position = ccp(88*g_fx, -90*g_fy);
#endif
        
        CCMenuItem *buy3 = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"buy3-1.png")]]
                                                       selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"buy3-2.png")]]
                                                               target:self
                                                             selector:@selector(buy3Life:)];
        
#ifdef FREE_VERSION
        buy3.position = ccp(36*g_fx, -117*g_fy);
#else
        buy3.position = ccp(160*g_fx, -90*g_fy);
#endif
                
#ifdef FREE_VERSION
        removeAds = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"remove.png"]]
                                                       selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"remove.png"]]
                                                               target:self
                                                             selector:@selector(removeAds:)];
        removeAds.position = ccp(149*g_fx, -117*g_fy);
        bool isRemoveAds = [prefs boolForKey:@"removeads"];
        
        disableRemoveAds = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"soundoff.png"]];
        disableRemoveAds.anchorPoint = ccp(0.0, 1.0);
        disableRemoveAds.position = ccp (359.5*g_fx, screenSize.height-252*g_fy);
        [self addChild:disableRemoveAds z:11];
        
        if (isRemoveAds) {
            removeAds.isEnabled = false;
            disableRemoveAds.visible = YES;
        }
        else {
            disableRemoveAds.visible = NO;
        }
#endif
        
        CCMenuItem *back = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"back.png")]]
                                                     selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"back_clicked.png")]]
                                                             target:self
                                                           selector:@selector(backToPrev:)];
        back.position = ccp(-200*g_fx, 127*g_fy);
        
        bool isRated = [prefs boolForKey:@"rateapp"];
        
#ifdef FREE_VERSION
        if (!isRated) {
            rate = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"rate.png"]]
                                                       selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"rate.png"]]
                                                               target:self
                                                             selector:@selector(goToAppRate:)];
            rate.position = ccp(148*g_fx, 130*g_fy);
            
            menu = [CCMenu menuWithItems: buyLives, buy1, buy3, removeAds, back, rate, nil];

        }
        else {
            menu = [CCMenu menuWithItems: buyLives, buy1, buy3, removeAds, back, nil];
        }
#else
//    if (!isRated) {
//            rate = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"rate.png"]]
//                                           selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"rate.png"]]
//                                                   target:self
//                                                 selector:@selector(goToAppRate:)];
//            rate.position = ccp(148, 130);
//            
//            menu = [CCMenu menuWithItems: buyLives, buy1, buy3, back, nil];
//            
//        }
//        else {
            menu = [CCMenu menuWithItems: buyLives, buy1, buy3, back, nil];
//        }
#endif
        
        [self addChild: menu];

    }
    
    return self;
}

//- (void) buyLives: (id) sender
//{
//    if (effectsoundOn)
//        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
//    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    bool buy10lives = [prefs boolForKey:@"buy10lives"];
//    if (!buy10lives && !isProgressBuy) {
//         isProgressBuy = true;
//         [[AppDelegate get] buyIAPitem:kTagStartWith10Lives];
//    }
//}
//
//- (void) buy1Life: (id) sender
//{
//    if (effectsoundOn)
//        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
//    
//    if (!isProgressBuy) {
//        isProgressBuy = true;
//        [[AppDelegate get] buyIAPitem:kTagBuy1Revive];
//    }
//}
//
//- (void) buy3Life: (id) sender
//{
//    if (effectsoundOn)
//        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
//    
//    if (!isProgressBuy) {
//        isProgressBuy = true;
//        [[AppDelegate get] buyIAPitem:kTagBuy3Revives];
//    }    
//}
- (void) buyLives: (id) sender
{
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    bool buy10lives = [prefs boolForKey:@"buy10lives"];
    bool buy10lives = [MKStoreManager featureBPurchased];
    if (!buy10lives ) {
        isProgressBuy = true;
        [[MKStoreManager sharedManager] buyFeatureB];
    }
}

- (void) buy1Life: (id) sender
{
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    //if (!isProgressBuy)
    {
        isProgressBuy = true;
        [[MKStoreManager sharedManager] buyFeatureC];
    }
}

- (void) buy3Life: (id) sender
{
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    if (!isProgressBuy) {
        isProgressBuy = true;
        [[MKStoreManager sharedManager] buyFeatureD];
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
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MainMenu scene]] ];
    }
    else {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GameOver scene]] ];
    }
    
    if (![MKStoreManager featureAPurchased])
    {
        [[AppDelegate get]showChartBoostFullScreen];
        [[RevMobAds session] showFullscreen];
    
    
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
