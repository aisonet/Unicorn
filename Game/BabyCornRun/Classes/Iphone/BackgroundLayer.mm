
#import "BackgroundLayer.h"
#import "globals.h"

@implementation BackgroundLayer
+(id)scene
{
    CCScene *scene =[CCScene node];
    BackgroundLayer *layer =[BackgroundLayer node];
    [scene addChild:layer];
    return scene;
}

-(id)init
{
    
    if(self=[super init])
        
    {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
                
        cloud1 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"flower1.png")]];
        cloud1.tag = kTagCloud1;
        cloud1.anchorPoint = ccp(0.0, 1.0);
        cloud1.position = ccp(140*g_fx, screenSize.height-40*g_fy);
        [self addChild:cloud1 z:11];
        
        cloud2 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"flower1.png")]];
        cloud2.tag = kTagCloud2;
        cloud2.anchorPoint = ccp(0.0, 1.0);
        cloud2.position = ccp(200*g_fx, screenSize.height-70*g_fy);
        [self addChild:cloud2 z:11];
        
        cloud3 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"flower2.png")]];
        cloud3.tag = kTagCloud3;
        cloud3.anchorPoint = ccp(0.0, 1.0);
        cloud3.position = ccp(270*g_fx, screenSize.height-100*g_fy);
        [self addChild:cloud3 z:11];
        
        cloud4 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"flower2.png")]];
        cloud4.tag = kTagCloud4;
        cloud4.anchorPoint = ccp(0.0, 1.0);
        cloud4.position = ccp(180*g_fx, screenSize.height-120*g_fy);
        [self addChild:cloud4 z:11];
        
        cloud5 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"flower3.png")]];
        cloud5.tag = kTagCloud5;
        cloud5.anchorPoint = ccp(0.0, 1.0);
        cloud5.position = ccp(210*g_fx, screenSize.height-150*g_fy);
        [self addChild:cloud5 z:11];
            
    }
    
    return self;
}

-(void)updateCloudPosition :(CCSprite*)cloud :(CGPoint) lastPosition :(CGPoint) currentPosition
{
    //NSLog(@"pos = %f width = %f sum = %f", cloud.position.x, cloud.contentSize.width, cloud.position.x+cloud.contentSize.width);
    if (cloud.position.x+cloud.contentSize.width+120*g_fx < currentPosition.x) 
    {   
        cloud.position = ccpAdd(cloud.position, ccp(480*g_fx+cloud.contentSize.width, 0));
    }
    else{
        
        float rate = 1.0;
        switch (cloud.tag) {
            case kTagCloud1:
                rate = 0.85;
                break;
            case kTagCloud2:
                rate = 0.87;
                break;
            case kTagCloud3:
                rate = 0.90;
                break;
            case kTagCloud4:
                rate = 0.92;
                break;
            case kTagCloud5:
                rate = 0.88;
                break;                
            default:
                break;
        }
        
        cloud.position=ccpAdd(cloud.position, ccp((currentPosition.x-lastPosition.x)*rate,0));        
    }
}

-(void)updateWithPlayerPosition :(CGPoint) lastPosition :(CGPoint) currentPosition
{     
    [self updateCloudPosition:cloud1 :lastPosition :currentPosition];
    [self updateCloudPosition:cloud2 :lastPosition :currentPosition];
    [self updateCloudPosition:cloud3 :lastPosition :currentPosition];
    [self updateCloudPosition:cloud4 :lastPosition :currentPosition];
    [self updateCloudPosition:cloud5 :lastPosition :currentPosition];
}

-(void) dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}
@end
