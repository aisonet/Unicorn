

#import "HudLayer_ipad.h"
#import "CCLabelTTF.h"
#import "globals.h"
#import "GameOver_ipad.h"

@implementation HudLayer_ipad
+(id)scene
{
    CCScene *scene=[CCScene node];
    HudLayer_ipad *layer=[HudLayer_ipad node];
    [scene addChild:layer];
    return scene;
}

-(id)init
{
    if(self=[super init])
    {       
        CCTexture2D *cornlifeTex = [[CCTextureCache sharedTextureCache] addImage:@"cornlife-hd.png"];
        
        for (int cnt = 0; cnt < MAX_LIFES; cnt++) {
            CCSprite *life = [CCSprite spriteWithTexture:cornlifeTex];
            life.anchorPoint=ccp(0.0,0.0);
            life.position=ccp(20.0+44*cnt,588.0);
            life.tag = cnt;
            if (cnt < lifesLeft)
                life.visible = YES;
            else
                life.visible = NO;
                
            [self addChild:life]; 
        }
        
        lifeCnt = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"x%d", lifesLeft] dimensions:CGSizeMake(120, 60)
                                           alignment:UITextAlignmentLeft fontName:@"Palatino" fontSize:48.0f];
        lifeCnt.anchorPoint = ccp(0.0, 0.0);
        lifeCnt.position = ccp(80.0,600.0);
        
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

        
        CCSprite *score = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"score-hd.png"]];
        score.anchorPoint=ccp(0.0,0.0);
        score.position=ccp(10,678.0);
        [self addChild:score];
        
        runMeter = 0;
        scoreCnt = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%d", runMeter] dimensions:CGSizeMake(400, 60)
                                            alignment:UITextAlignmentLeft fontName:@"Palatino" fontSize:48.0f];
        scoreCnt.position = ccp(340.0,698.0);
        scoreCnt.color = ccBLACK;
        [self addChild:scoreCnt];
                                
        pauseButton = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"pause-hd.png"]];
        pauseButton.anchorPoint=ccp(0.0,0.0);
        pauseButton.position=ccp(860.0,648.0);
        [self addChild:pauseButton];
        
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

@end
