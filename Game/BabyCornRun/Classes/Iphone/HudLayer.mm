

#import "HudLayer.h"
#import "CCLabelTTF.h"
#import "globals.h"
#import "GameOver.h"
#import "GameLayer.h"

@implementation HudLayer
+(id)scene
{
    CCScene *scene=[CCScene node];
    HudLayer *layer=[HudLayer node];
    [scene addChild:layer];
    return scene;
}

-(id)init
{
    if(self=[super init])
    {       
        CCTexture2D *cornlifeTex = [[CCTextureCache sharedTextureCache] addImage:res(@"cornlife.png")];
        
        for (int cnt = 0; cnt < MAX_LIFES; cnt++) {
            CCSprite *life = [CCSprite spriteWithTexture:cornlifeTex];
            life.anchorPoint=ccp(0.0,0.0);
            life.position=ccp(10.0*g_fx+22*g_fx*cnt,240.0*g_fy);
            life.tag = cnt;
            if (cnt < lifesLeft)
                life.visible = YES;
            else
                life.visible = NO;
                
            [self addChild:life]; 
        }
        
        lifeCnt = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"x%d", lifesLeft] dimensions:CGSizeMake(60*g_fx, 30*g_fy)
                                           alignment:UITextAlignmentLeft fontName:@"Palatino" fontSize:24.0f*g_fy];
        lifeCnt.anchorPoint = ccp(0.0, 0.0);
        lifeCnt.position = ccp(40.0*g_fx,237.0*g_fy);
        
        if (lifesLeft > MAX_LIFES)
        {
            lifeCnt.visible = NO;
            
            for (int cnt = 0; cnt < MAX_LIFES; cnt++) {
                CCSprite *life = (CCSprite*)[self getChildByTag:cnt];
                life.tag = cnt;
                if (cnt < 1)
                    life.visible = YES;
                else
                    life.visible = NO;
            }
        }
        lifeCnt.color = ccBLACK;
        [self addChild:lifeCnt]; 

        
        CCSprite *score = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"score.png")]];
        score.anchorPoint=ccp(0.0,0.0);
        score.position=ccp(5.0*g_fx,275.0*g_fy);
        [self addChild:score];
        
        runMeter = 0;
//        scoreCnt = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%d", runMeter] dimensions:CGSizeMake(200, 30)
//                                            alignment:UITextAlignmentLeft fontName:@"Palatino" fontSize:24.0f];
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
        scoreCnt = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d", runMeters] charMapFile:res(@"score number.png") itemWidth:rW itemHeight:rH startCharMap:'0'];
        [scoreCnt setQuadsToDraw:10];
        scoreCnt.position = ccp(135.0*g_fx,275.0*g_fy);
//        scoreCnt.color = ccBLACK;
        [self addChild:scoreCnt];
        
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        
//        pauseButton = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"pause button-1.png")]];
//
//        
//        
//        if( screenSize.width == 568 || screenSize.height == 568 )
//            pauseButton.position = ccp([[UIScreen mainScreen] bounds].size.width*1.5, 290*g_fy);
//        else
//            pauseButton.position = ccp([[UIScreen mainScreen] bounds].size.width*1.3, 290*g_fy);
//
//        
//
//        [self addChild:pauseButton];
        CCMenuItemImage* btnPause = [CCMenuItemImage itemFromNormalImage:@"pause button-1.png" selectedImage:@"pause button-2.png" target:self selector:@selector(actionPause)];
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            btnPause.position = ccp([[UIScreen mainScreen] bounds].size.width*1.1, 290*g_fy);
            
            
        }
        else{
        if( screenSize.width == 568 || screenSize.height == 568 )
            btnPause.position = ccp([[UIScreen mainScreen] bounds].size.width*1.5, 290*g_fy);
        else
            btnPause.position = ccp([[UIScreen mainScreen] bounds].size.width*1.3, 290*g_fy);
        }
        CCMenu* menu = [CCMenu menuWithItems:btnPause, nil];
        [menu setPosition:ccp(0, 0)];
        [self addChild:menu];
        
        [self schedule:@selector(updateLifes) interval:0.1f];
        [self schedule:@selector(countScore) interval:0.01f];
    }
    return self;
}

-(void)countScore 
{
    if (isPlayerRunning) {
        runMeters++;
        if (runMeters > 10000) {
            additionalSpeed = 5.0;
        }
        else if (runMeters > 5000) {
            additionalSpeed = 4.0;
        }
        else if (runMeters > 1500) {
            additionalSpeed = 3.0;
        }
        else if (runMeters > 1000) {
            additionalSpeed = 2.0;
        }
        else if (runMeters > 500) {
            additionalSpeed = 1.0;
        }
        
        [scoreCnt setString:[NSString stringWithFormat:@"%d", runMeters]];
    }

}

-(void) updateLifes
{
    for (int cnt = 0; cnt < MAX_LIFES; cnt++) {
        CCSprite *life = (CCSprite*)[self getChildByTag:cnt];
        life.tag = cnt;
        if (cnt < lifesLeft)
            life.visible = YES;
        else
            life.visible = NO;
    }
    
    if (lifesLeft > MAX_LIFES) {
        
        for (int cnt = 0; cnt < MAX_LIFES; cnt++) {
            CCSprite *life = (CCSprite*)[self getChildByTag:cnt];
            life.tag = cnt;
            if (cnt < 1)
                life.visible = YES;
            else
                life.visible = NO;
        }
        
        lifeCnt.visible = YES;
        [lifeCnt setString:[NSString stringWithFormat:@"x%d", lifesLeft]];
    }
    else {
        lifeCnt.visible = NO;
    }
}
        
-(void)dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
    
}

-(void) actionPause
{
    [[NSNotificationCenter defaultCenter] postNotificationName:PAUSE_NOTIFICATION object:nil];

    
}

@end
