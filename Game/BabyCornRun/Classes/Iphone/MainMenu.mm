

#import "MainMenu.h"
#import "FullLayer.h"
#import "ShopMenu.h"
#import "MainBackLayer.h"
#import "AppDelegate.h"
#import "HowToPlayLayer.h"

#import "RootViewController.h"
#import "MKStoreManager.h"
#import "AppDelegate.h"

#ifdef FREE_VERSION
#endif

@implementation MainMenu

#ifdef FREE_VERSION
@synthesize adView;
#endif

+(id) scene
{
    CCScene *scene = [CCScene node];
    
    MainMenu *layer = [MainMenu node];
    
    [scene addChild: layer];
    
    return scene;
}

-(id) init
{
    
    if( (self=[super init] )) {
        
        

        self.isTouchEnabled = YES;
        
//        if ([AppDelegate get].NagScreen) 
//        {
//            [self AddNagScreen];
//            [AppDelegate get].NagScreen=FALSE;
//        }
        
        screenSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *background;
        if([[UIScreen mainScreen] bounds].size.height==568)
            background= [CCSprite spriteWithFile:res(@"bg1-iphone5.png")];
        else
            background= [CCSprite spriteWithFile:res(@"bg1.png")];
        
        background.anchorPoint = ccp(0.0, 1.0);
        background.position = ccp (0, screenSize.height);
        [self addChild:background z:0];
                
        CCSprite *logo = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"title.png")]];
        logo.anchorPoint = ccp(0.0, 1.0);
        logo.position = ccp (48*g_fx, 290*g_fy);
        //[self addChild:logo z:0];
        
        isProgressBuy = false;
        
#ifdef FREE_VERSION
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
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

        //placeholder music
        if (backSoundOn)
            [[AppDelegate get].m_pSoundEngine playBackgroundMusic:@"gameplay.mp3"];
        
        
        CCMenuItem *play = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"play button-1.png")]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"play button-2.png")]]
                                                           target:self
                                                         selector:@selector(startGame:)];
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            play.position = ccp([[UIScreen mainScreen] bounds].size.width*1.1, 180*g_fy);

        
        }
        else{
        
           if( screenSize.width == 568 || screenSize.height == 568 )
             play.position = ccp([[UIScreen mainScreen] bounds].size.width*1.5, 180*g_fy);
           else
             play.position = ccp([[UIScreen mainScreen] bounds].size.width*1.3, 180*g_fy);
        }
 
        
        CCMenuItem *moreGames = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"more game button-1.png")]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"more game button-2.png")]]
                                                           target:self
                                                         selector:@selector(openMoreApps:)];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            moreGames.position = ccp([[UIScreen mainScreen] bounds].size.width*1.1, 130*g_fy);
            
            
        }
        else{
            if( screenSize.width == 568 || screenSize.height == 568 )
                moreGames.position = ccp([[UIScreen mainScreen] bounds].size.width*1.5, 130*g_fy);
            else
                moreGames.position = ccp([[UIScreen mainScreen] bounds].size.width*1.3, 130*g_fy);
        }
        
        CCMenuItem *btnRemoveAds = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"remove ads button-1.png")]]
                                                        selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"remove ads button-2.png")]]
                                                                target:self
                                                              selector:@selector(actionRemoveAds)];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            btnRemoveAds.position = ccp([[UIScreen mainScreen] bounds].size.width*1.1, 30*g_fy);
            
            
        }
        else{
        
        if( screenSize.width == 568 || screenSize.height == 568 )
            btnRemoveAds.position = ccp([[UIScreen mainScreen] bounds].size.width*1.5, 30*g_fy);
        else
            btnRemoveAds.position = ccp([[UIScreen mainScreen] bounds].size.width*1.3, 30*g_fy);
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

        
        
        CCMenuItem *gamecenter = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"game centre button-1.png")]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"game centre button-2.png")]]
                                                           target:self
                                                         selector:@selector(openGameCenter:)];
        
        gamecenter.position = ccp(30*g_fx, 50*g_fy);
        
        CCMenuItemImage* btnRestore = [CCMenuItemImage itemFromNormalImage:res(@"Refresh button-1.png") selectedImage:res(@"Refresh button-2.png") target:self selector:@selector(actionRestore)];
        [btnRestore setPosition:ccp(80*g_fx, 50*g_fy)];        
        
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
        
        menu = [CCMenu menuWithItems: play, moreGames, btnRemoveAds, shop, gamecenter, bsoundon, ssoundon, btnRestore, nil];
        [menu setPosition:ccp(0,0)];
        [self addChild: menu z:10];
        
//        MainBackLayer *mainbacklayer=[[MainBackLayer alloc] init];
//        [self addChild:mainbacklayer z:5];
//        [mainbacklayer release];  
        
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
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[HowToPlayLayer scene]] ];
    }
    else {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[FullLayer scene]] ];
    }
}

- (void) openMoreApps: (id) sender
{
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    [[AppDelegate get] dispMoreGames];
//    InfoviewController   *movetoview=[[InfoviewController alloc]initWithNibName:@"InfoviewController" bundle:nil];
//    [[[CCDirector sharedDirector]openGLView]addSubview:movetoview.view];
}

- (void) openNews: (id) sender
{
    
}

- (void) openShop: (id) sender
{    
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[ShopMenu scene:true]] ];
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
    //If adView exists, remove everything
        [super onExit];
}

-(void)AddNagScreen
{
    }

-(void)ProcessStart
{
      
}
-(void)ProcessComplete
{
    
}

- (void)tapBtn:(id)sender
{
    NSDictionary *Dict;
    Dict=[nagArray objectAtIndex:0];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [Dict objectForKey:@"NAGurl"] ]];
}
- (void)cancelBtnClicked:(id)sender
{
    [NagView removeFromSuperview];
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
    self.adView.delegate = nil;
    self.adView = nil;
#endif
    
    [NagView removeFromSuperview];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}

-(void) actionRemoveAds
{
    [[MKStoreManager sharedManager] buyFeatureA];
}

-(void) actionRestore
{
    [[MKStoreManager sharedManager] restoreFunc];
}

@end