
#import "GameOver.h"
#import "cocos2d.h"
#import "FullLayer.h"
#import "globals.h"
#import "MainMenu.h"
#import "ShopMenu.h"
#import "AppDelegate.h"
#import "RootViewController.h"


#ifdef FREE_VERSION
#endif

@implementation GameOver

#ifdef FREE_VERSION
@synthesize adView;
#endif

+(CCScene *) scene
{	CCScene *scene = [CCScene node];
	CCLayer *layer = [GameOver node];
	[scene addChild: layer];
	return scene;
}

@synthesize bestscoreLabel;
@synthesize scoreLabel;

-(id) init
{

	if( (self=[super init])) {
        
        
        
        int count=[[NSUserDefaults standardUserDefaults] integerForKey:@"GameOverCounter"];
        ++count;
        
        [[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"GameOverCounter"];
        
        if(count==3){
            
            [ALInterstitialAd showOver:[[UIApplication sharedApplication] keyWindow]];

            [[AppDelegate get]showChartBoostFullScreen];
            
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"GameOverCounter"];
            
            
        }

        

        self.isTouchEnabled = YES;
        
        screenSize = [CCDirector sharedDirector].winSize;
                
        CCSprite *background;
        if([[UIScreen mainScreen] bounds].size.height==568)
            background = [CCSprite spriteWithFile:res(@"bg1-iphone5.png")];
        else
            background = [CCSprite spriteWithFile:res(@"bg1.png")];
        background.anchorPoint = ccp(0.0, 1.0);
        background.position = ccp (0, screenSize.height);
        [self addChild:background z:0];
        
//        CCSprite *bottom = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat: @"ground_007.png"]]];
//        bottom.anchorPoint = ccp(0.0, 1.0);
//        bottom.position = ccp (-40, 91);
//        [self addChild:bottom z:0];
        
        isProgressBuy = false;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
#ifdef FREE_VERSION
        removeads = [prefs boolForKey:@"removeads"];
        
        if (!removeads) {
            adsbox = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"box.png"]];
            adsbox.anchorPoint = ccp(0.0, 1.0);
            adsbox.position = ccp (351, screenSize.height+4);
            [self addChild:adsbox z:0];
            
            noads = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"support.png"]];
            noads.anchorPoint = ccp(0.0, 1.0);
            noads.position = ccp (354, screenSize.height+4);
            [self addChild:noads z:0];
            
            adsbox.visible = NO;
            noads.visible = NO;
        }
#endif
        
        CCSprite *bestScoreLbl = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat: res(@"bestscore.png")]]];
        bestScoreLbl.anchorPoint = ccp(0.0, 1.0);
        bestScoreLbl.position = ccp (10*g_fx, screenSize.height-10*g_fy);
        [self addChild:bestScoreLbl z:0];
        
        CCSprite *score = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat: res(@"score.png")]]];
//        score.anchorPoint = ccp(0.0, 1.0);
        score.position = ccp (160*g_fx, 202*g_fy);
        [self addChild:score z:0];
                
        float rW, rH;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            rW = 64;
            rH = 83;
        }
        else
        {
            rW = 27;
            rH = 35;
        }
        scoreLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d", runMeters] charMapFile:res(@"score number.png") itemWidth:rW itemHeight:rH startCharMap:'0'];
        scoreLabel.position = ccp( 225*g_fx, 183*g_fy);
        [self addChild:scoreLabel];
        
        if (runMeters > bestScore) {
            bestScore = runMeters;
            CCSprite *highscore = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat: res(@"hiscore.png")]]];
            highscore.anchorPoint = ccp(0.0, 1.0);
            highscore.position = ccp (316*g_fx, screenSize.height-60*g_fy);
            [self addChild:highscore z:0];
            
            RootViewController *rootViewController = [AppDelegate get].viewController;
            [rootViewController submitScore:bestScore];
            
            int type = 0;
            if (bestScore > 2000000)
                type = kTagNumber1Crop;
            else if (bestScore > 999999)
                type = kTagKernelYesSir;
            else if (bestScore > 666666)
                type = kTagAmaizing;
            else if (bestScore > 333333)
                type = kTagAvoidHarvest;
            else if (bestScore > 55555)
                type = kTagPopMarathon;
            else if (bestScore > 25555)
                type = kTagHalfMarathon;
            
            if (type > 0) {
                [rootViewController checkAchievements:type];
            }
        }
        
        [prefs setInteger:bestScore forKey:@"bestscore"];
        
//        bestscoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", bestScore] dimensions:CGSizeMake(100, 50) alignment:UITextAlignmentLeft fontName:@"Marker Felt" fontSize:28];
//        bestscoreLabel.color = ccBLACK;
//        bestscoreLabel.position = ccp( 170, screenSize.height-40);
//        [self addChild:bestscoreLabel];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            rW = 35;
            rH = 45;
        }
        else
        {
            rW = 15;
            rH = 19;
        }
        bestscoreLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d", bestScore] charMapFile:res(@"bestscore number.png") itemWidth:rW itemHeight:rH startCharMap:'0'];
        bestscoreLabel.anchorPoint = ccp(0, 0.5);
        bestscoreLabel.position = ccp( 135*g_fx, 300*g_fy);
        [self addChild:bestscoreLabel];
        
        CCMenuItem *playAgain = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"play again button-1.png")]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"play again button-2.png")]]
                                                           target:self
                                                         selector:@selector(startGame:)];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            playAgain.position = ccp([[UIScreen mainScreen] bounds].size.width*1.1, 180*g_fy);
            
            
        }
        else{
            if( screenSize.width == 568 || screenSize.height == 568 )
                playAgain.position = ccp([[UIScreen mainScreen] bounds].size.width*1.5, 180*g_fy);
            else
                playAgain.position = ccp([[UIScreen mainScreen] bounds].size.width*1.3, 180*g_fy);
        }
        
        CCMenuItem *mainmenu = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"main menu button-1.png")]]
                                                       selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"main menu button-2.png")]]
                                                               target:self
                                                             selector:@selector(goToMenu:)];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            mainmenu.position = ccp([[UIScreen mainScreen] bounds].size.width*1.1, 130*g_fy);
            
            
        }
        else{
        if( screenSize.width == 568 || screenSize.height == 568 )
            mainmenu.position = ccp([[UIScreen mainScreen] bounds].size.width*1.5, 130*g_fy);
        else
            mainmenu.position = ccp([[UIScreen mainScreen] bounds].size.width*1.3, 130*g_fy);
        }
        
        CCMenuItem *shop = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"shop button-1.png")]]
                                                       selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"shop button-2.png")]]
                                                               target:self
                                                             selector:@selector(openShop:)];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            shop.position = ccp([[UIScreen mainScreen] bounds].size.width*1.1, 80*g_fy);
            
            
        }
        else{
        if( screenSize.width == 568 || screenSize.height == 568 )
            shop.position = ccp([[UIScreen mainScreen] bounds].size.width*1.5, 80*g_fy);
        else
            shop.position = ccp([[UIScreen mainScreen] bounds].size.width*1.3, 80*g_fy);
        }
        
        id scaleUp = [CCScaleTo actionWithDuration:1.0f scale:1.3f];
        id scaleDown = [CCScaleTo actionWithDuration:1.0f scale:1.0f];
        
        CCSequence *scaleSequence = [CCSequence actionOne:scaleUp two:scaleDown ];
        CCRepeatForever *repeat = [CCRepeatForever actionWithAction:scaleSequence];
        [shop runAction:repeat];
        
        CCMenuItem *facebook = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"facebook button-1.png")]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"facebook button-2.png")]]
                                                           target:self
                                                         selector:@selector(goToFacebook:)];
        facebook.position = ccp(30*g_fx, 150*g_fy);
        
        CCMenuItem *twitter = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"twitter button-1.png")]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"twitter button-2.png")]]
                                                           target:self
                                                         selector:@selector(goToTwitter:)];
        twitter.position = ccp(30*g_fx, 100*g_fy);
        
        CCMenuItem *gamecenter = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"game centre button-1.png")]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"game centre button-2.png")]]
                                                           target:self
                                                         selector:@selector(openGameCenter:)];
        gamecenter.position = ccp(30*g_fx, 50*g_fy);
        
        menu = [CCMenu menuWithItems: playAgain, mainmenu, shop, gamecenter, nil];
        [menu setPosition:ccp(0,0)];
        [self addChild: menu z:5];
        
        
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
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[FullLayer scene]] ];
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



- (void) openShop: (id) sender
{    
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[ShopMenu scene:false]] ];
}

- (void) goToFacebook: (id) sender
{
    
}

- (void) goToTwitter: (id) sender
{
    
}

- (void) openGameCenter: (id) sender
{    
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    RootViewController *rootViewController = [AppDelegate get].viewController;
    [rootViewController showLeaderboard];
}

#ifdef FREE_VERSION

- (UIViewController *)viewControllerForPresentingModalView {
    //Remember that UIViewController we created in the Game.h file? AdMob will use it.
    //If you want to use "return self;" instead, AdMob will cancel the Ad requests.
    return viewController;
}


-(void)onEnter {
    
    //Let's allocate the viewController (it's the same RootViewController as declared
    //in our AppDelegate; will be used for the Ads)
    
    viewController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] viewController];
    
    //viewController = [AppDelegate get].viewController;
    
       
    [super onEnter];
}

-(void)onExit {
    //There's something weird about AdWhirl because setting the adView delegate
    //to "nil" doesn't stops the Ad requests and also it doesn't remove the adView
    //from superView; do the following to remove AdWhirl from your scene.
    //
    //If adView exists, remove everything
        [super onExit];
}
#endif

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
            CGRect remove = CGRectMake(350, screenSize.height-44, 132, 44);
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
    
#endif
    
    [self removeAllChildrenWithCleanup:YES];
	[super dealloc];
}

@end
