

#import "PauseMenu_ipad.h"
#import "MainMenu_ipad.h"
#import "globals.h"
#import "FullLayer_ipad.h"
#import "GameLayer_ipad.h"
#import "AppDelegate.h"


@implementation PauseMenu_ipad

+(id)scene
{
    CCScene *scene =[CCScene node];
    PauseMenu_ipad *layer =[PauseMenu_ipad node];
    [scene addChild:layer];
    return scene;
}
-(id)init
{
    if(self=[super init])
    {
        self.isTouchEnabled=YES;
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;       
        
        CCSprite *background = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"pausebg-ipad.png"]];
        background.anchorPoint = ccp(0.0, 1.0);
        background.position = ccp (0, screenSize.height);
        [self addChild:background z:0];
        
        CCSprite *pauseMsg = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"gamepaused-hd.png"]];
        pauseMsg.anchorPoint = ccp(0.0, 1.0);
        pauseMsg.position = ccp (312, screenSize.height-40);
        [self addChild:pauseMsg z:0];
                
        CCMenuItem *mainmenu = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"mainmenu2-hd.png"]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"mainmenu2-hd.png"]]
                                                           target:self
                                                         selector:@selector(goToMenu:)];
        mainmenu.position = ccp(-150, -40);
        
        CCMenuItem *resume = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"resume-hd.png"]]
                                                        selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"resume-hd.png"]]
                                                                target:self
                                                              selector:@selector(resumeGame:)];
        resume.position = ccp(150, -40);
        
        CCMenuItem *ssoundon = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"ssoundon-hd.png"]]
                                                       selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"ssoundon-hd.png"]]
                                                               target:self
                                                             selector:@selector(switchEffectSound:)];
        ssoundon.position = ccp(-80, -190);
        
        effectSoundoff = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"soundoff-hd.png"]];
        effectSoundoff.anchorPoint = ccp(0.0, 1.0);
        effectSoundoff.position = ccp (373.5, screenSize.height-524);
        if (effectsoundOn)
            effectSoundoff.visible = NO;
        [self addChild:effectSoundoff z:11];
        
        CCMenuItem *bsoundon = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"bsoundon-hd.png"]]
                                                       selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"bsoundon-hd.png"]]
                                                               target:self
                                                             selector:@selector(switchBackSound:)];
        bsoundon.position = ccp(80, -190);
        
        backSoundoff = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"soundoff-hd.png"]];
        backSoundoff.anchorPoint = ccp(0.0, 1.0);
        backSoundoff.position = ccp (533.5, screenSize.height-524);
        if (backSoundOn)
            backSoundoff.visible = NO;
        [self addChild:backSoundoff z:11];
                        
        menu = [CCMenu menuWithItems: mainmenu, resume, ssoundon, bsoundon, nil];
        [self addChild: menu z:10];

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
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MainMenu_ipad scene]] ];
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
