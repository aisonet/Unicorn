

#import "ReviveLayer_ipad.h"
#import "globals.h"
#import "FullLayer_ipad.h"
#import "GameLayer_ipad.h"
#import "AppDelegate.h"

@implementation ReviveLayer_ipad

+(id)scene
{
    CCScene *scene =[CCScene node];
    ReviveLayer_ipad *layer =[ReviveLayer_ipad node];
    [scene addChild:layer];
    return scene;
}
-(id)init
{
    if(self=[super init])
    {
        self.isTouchEnabled=YES;
        
        life = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"heart-hd.png"]];
        life.anchorPoint=ccp(0.0,0.0);
        life.position=ccp(910.0,0.0);
        [self addChild:life]; 
        
        timerCnt = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%d", 2] dimensions:CGSizeMake(100, 60)
                                           alignment:UITextAlignmentLeft fontName:@"Palatino" fontSize:38.0f];
        timerCnt.visible = NO;
        timerCnt.position = ccp(1007.0,110.0);
        timerCnt.color = ccBLACK;
        [self addChild:timerCnt];
        
        reviveCnt = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"x%d", revivesLeft] dimensions:CGSizeMake(100, 60)
                                             alignment:UITextAlignmentLeft fontName:@"Palatino" fontSize:32.0f];
        reviveCnt.position = ccp(1018.0,20.0);
        reviveCnt.color = ccBLACK;
        [self addChild:reviveCnt];
        
        revivesLeft--;
        
        [self schedule:@selector(countRevive) interval:0.01f];
        
    }
    
    return self;
}

-(void)countRevive 
{
    if (!isPlayerRunning) {
        timerCnt.visible = YES;
        [timerCnt setString:[NSString stringWithFormat:@"%d", (countTime2+50)/100]];
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
            CGRect revive = CGRectMake(910, 0, 122, 110);
            
            if (CGRectContainsPoint(revive, location) && isPaused)
            {
                if (effectsoundOn)
                    [[AppDelegate get].m_pSoundEngine playEffect:@"revive.mp3"];
                
                isPaused=false;
                isPlayerRunning = true;
                [self.parent resumeSchedulerAndActionsRecursive:self.parent];
                [self.parent removeChild:self cleanup:YES];
            }
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
