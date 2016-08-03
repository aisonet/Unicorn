
#import "BackgroundLayer_ipad.h"

@implementation BackgroundLayer_ipad
+(id)scene
{
    CCScene *scene =[CCScene node];
    BackgroundLayer_ipad *layer =[BackgroundLayer_ipad node];
    [scene addChild:layer];
    return scene;
}

-(id)init
{
    
    if(self=[super init])
        
    {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
                
        cloud1 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"cloud2-hd.png"]];
        cloud1.tag = kTagCloud1;
        cloud1.anchorPoint = ccp(0.0, 1.0);
        cloud1.position = ccp(280, screenSize.height-40);
        [self addChild:cloud1 z:11];
        
        cloud2 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"cloud1-hd.png"]];
        cloud2.tag = kTagCloud2;
        cloud2.anchorPoint = ccp(0.0, 1.0);
        cloud2.position = ccp(400, screenSize.height-80);
        [self addChild:cloud2 z:11];
        
        cloud3 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"cloud2-hd.png"]];
        cloud3.tag = kTagCloud3;
        cloud3.anchorPoint = ccp(0.0, 1.0);
        cloud3.position = ccp(540, screenSize.height-60);
        [self addChild:cloud3 z:11];
        
        cloud4 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"cloud1-hd.png"]];
        cloud4.tag = kTagCloud4;
        cloud4.anchorPoint = ccp(0.0, 1.0);
        cloud4.position = ccp(360, screenSize.height-160);
        [self addChild:cloud4 z:11];
        
        cloud5 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"cloud2-hd.png"]];
        cloud5.tag = kTagCloud5;
        cloud5.anchorPoint = ccp(0.0, 1.0);
        cloud5.position = ccp(420, screenSize.height-120);
        [self addChild:cloud5 z:11];
            
    }
    
    return self;
}

-(void)updateCloudPosition :(CCSprite*)cloud :(CGPoint) lastPosition :(CGPoint) currentPosition
{
    //NSLog(@"pos = %f width = %f sum = %f", cloud.position.x, cloud.contentSize.width, cloud.position.x+cloud.contentSize.width);
    if (cloud.position.x+cloud.contentSize.width+240 < currentPosition.x) 
    {   
        cloud.position = ccpAdd(cloud.position, ccp(1200+cloud.contentSize.width, 0));
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
