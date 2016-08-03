
#import "Player.h"
#import "globals.h"
#import "GameLayer.h"
#import "GameOver.h"

@implementation Player

@synthesize playerSprite;
@synthesize walkAction;
@synthesize jumpAction;
@synthesize hurtAction;

- (id)initWithWorld:(b2World *)world
{
	
    if ((self = [super init])) 
    {  
       CGSize screenSize = [CCDirector sharedDirector].winSize;     
        
//        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
//         @"corn.plist"];

        UIImage* image;
        NSMutableArray *walkAnimFrames = [NSMutableArray array];
        for(int i = 1; i <= 4; ++i) {
//            [walkAnimFrames addObject:
//             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
//              [NSString stringWithFormat:@"cornrun_00%d.png", i]]];
            image = [[UIImage imageNamed:[NSString stringWithFormat:res(@"cornrun_00%d.png"), i]] autorelease];
            CCTexture2D *texture = [[[CCTexture2D alloc] initWithImage:image] autorelease];
            CCSpriteFrame *frame0 = [CCSpriteFrame frameWithTexture:texture 
                                                               rect:CGRectMake(0, 0, texture.contentSize.width, texture.contentSize.height)];
            [walkAnimFrames addObject:frame0];
        }
        
        
        NSMutableArray *jumpAnimFrames = [NSMutableArray array];
        for(int i = 1; i <= 1; ++i) {
            image = [[UIImage imageNamed:res(@"cornjump.png")] autorelease];
            CCTexture2D *texture = [[[CCTexture2D alloc] initWithImage:image] autorelease];
            CCSpriteFrame *frame0 = [CCSpriteFrame frameWithTexture:texture 
                                                               rect:CGRectMake(0, 0, texture.contentSize.width, texture.contentSize.height)];
            [jumpAnimFrames addObject:frame0];
        }
        
        NSMutableArray *hurtAnimFrames = [NSMutableArray array];
        image = [[UIImage imageNamed:res(@"cornhurt.png")] autorelease];
        CCTexture2D *texture = [[[CCTexture2D alloc] initWithImage:image] autorelease];
        CCSpriteFrame *frame0 = [CCSpriteFrame frameWithTexture:texture 
                                                           rect:CGRectMake(0, 0, texture.contentSize.width, texture.contentSize.height)];
        [hurtAnimFrames addObject:frame0];
        
        
        CCAnimation *jumpAnim = [CCAnimation 
                       animationWithFrames:jumpAnimFrames delay:0.2f];
        
        CCAnimation *walkAnim = [CCAnimation 
                                 animationWithFrames:walkAnimFrames delay:0.08f];
        
        CCAnimation *hurtAnim = [CCAnimation 
                                 animationWithFrames:hurtAnimFrames delay:0.1f];
        
        self.playerSprite = [CCSprite spriteWithFile:@"cornrun_001.png"];        
        self.walkAction = [CCRepeatForever actionWithAction:
                           [CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
        
        self.jumpAction = [CCAnimate actionWithAnimation:jumpAnim restoreOriginalFrame:NO];
                
        self.hurtAction = [CCAnimate actionWithAnimation:hurtAnim restoreOriginalFrame:NO ];
        
        
        [playerSprite runAction:walkAction];
        playerSprite.tag=PLAYER_TAG;
        [self addChild:playerSprite];
        
        b2BodyDef playerBody;
        playerBody.type = b2_dynamicBody;
        playerBody.allowSleep=true;
        playerBody.position.Set((2.0*g_fx)/ptm_ratio, (screenSize.height/2+60*g_fy)/ptm_ratio);
        playerBody.userData = playerSprite;
        playerBody.fixedRotation=true;
       // playerBody.inertiaScale=0.5;
        playerBody.angularDamping=0.0f;
        
        //playerBody.linearDamping=1.0f;
        
        body = world->CreateBody(&playerBody);
        body->SetTransform(b2Vec2(2.0f*g_fx,body->GetPosition().y), body->GetAngle()); 
        // Define another box shape for our dynamic body.
            
        b2Vec2 verts[20];
        int num = 5;
        verts[0].Set(-21.0f*g_fx / ptm_ratio, -5.5f*g_fy / ptm_ratio);
        verts[1].Set(-5.0f*g_fx / ptm_ratio, -21.5f*g_fy / ptm_ratio);
        verts[2].Set(19.0f*g_fx / ptm_ratio, -10.5f*g_fy / ptm_ratio);
        verts[3].Set(19.0f*g_fx / ptm_ratio, 24.5f*g_fy / ptm_ratio);
        verts[4].Set(4.0f*g_fx / ptm_ratio, 24.5f*g_fy / ptm_ratio);
        
         b2PolygonShape playerShape;
         playerShape.Set(verts, num);
         //playerShape.SetAsBox(0.8f,0.62f);//These are mid points for our 1m box
        
        //b2CircleShape playerShape;
        //playerShape.m_radius=1.0;
        
        // Define the dynamic body fixture.
        
        fixtureDef.restitution = 0.0f;
        fixtureDef.shape = &playerShape;	
        fixtureDef.density = 1.0f;
        fixtureDef.friction = 0.0f;
        fixtureDef.filter.groupIndex=-3;
        //fixtureDef.isSensor = true;
        actualBody= body->CreateFixture(&fixtureDef);  
        b2PolygonShape sensor2;
        //sensor2.SetAsBox(0.801f,0.621f, b2Vec2(0.0f,0.0f) , 0);
        sensor2.Set(verts, num);
        b2FixtureDef deathChecker;
        deathChecker.shape = &sensor2;	
        deathChecker.isSensor=true;
        deathChecker.filter.groupIndex=0;
        b2Fixture *deathCheckerFixture = body->CreateFixture(&deathChecker);
        
        deathCheckerFixture->SetUserData((void *)4);
    }
    return self;
}
//- (id)initWithWorld:(b2World *)world
//{
//	
//    if ((self = [super init])) 
//    {  
//        CGSize screenSize = [CCDirector sharedDirector].winSize;     
//        
//        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
//         @"corn.plist"];
//        
//        NSMutableArray *walkAnimFrames = [NSMutableArray array];
//        for(int i = 1; i <= 8; ++i) {
//            [walkAnimFrames addObject:
//             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
//              [NSString stringWithFormat:@"cornrun_00%d.png", i]]];
//        }
//        
//        
//        NSMutableArray *jumpAnimFrames = [NSMutableArray array];
//        for(int i = 1; i <= 2; ++i) {
//            [jumpAnimFrames addObject:
//             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
//              [NSString stringWithFormat:@"cornjump_00%d.png", i]]];
//        }
//        
//        NSMutableArray *hurtAnimFrames = [NSMutableArray array];
//        [hurtAnimFrames addObject:
//         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
//          @"cornhurt.png"]];
//        
//        
//        CCAnimation *jumpAnim = [CCAnimation 
//                                 animationWithFrames:jumpAnimFrames delay:0.2f];
//        
//        CCAnimation *walkAnim = [CCAnimation 
//                                 animationWithFrames:walkAnimFrames delay:0.08f];
//        
//        CCAnimation *hurtAnim = [CCAnimation 
//                                 animationWithFrames:hurtAnimFrames delay:0.1f];
//        
//        self.playerSprite = [CCSprite spriteWithSpriteFrameName:@"cornrun_001.png"];        
//        self.walkAction = [CCRepeatForever actionWithAction:
//                           [CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
//        
//        self.jumpAction = [CCAnimate actionWithAnimation:jumpAnim restoreOriginalFrame:NO];
//        
//        self.hurtAction = [CCAnimate actionWithAnimation:hurtAnim restoreOriginalFrame:NO ];
//        
//        
//        [playerSprite runAction:walkAction];
//        playerSprite.tag=PLAYER_TAG;
//        [self addChild:playerSprite];
//        
//        b2BodyDef playerBody;
//        playerBody.type = b2_dynamicBody;
//        playerBody.allowSleep=true;
//        playerBody.position.Set((2.0)/ptm_ratio, (screenSize.height/2+60)/ptm_ratio);
//        playerBody.userData = playerSprite;
//        playerBody.fixedRotation=true;
//        // playerBody.inertiaScale=0.5;
//        playerBody.angularDamping=0.0f;
//        
//        //playerBody.linearDamping=1.0f;
//        
//        body = world->CreateBody(&playerBody);
//        body->SetTransform(b2Vec2(2.0f,body->GetPosition().y), body->GetAngle()); 
//        // Define another box shape for our dynamic body.
//        
//        b2Vec2 verts[20];
//        int num = 5;
//        verts[0].Set(-21.0f / ptm_ratio, -5.5f / ptm_ratio);
//        verts[1].Set(-5.0f / ptm_ratio, -21.5f / ptm_ratio);
//        verts[2].Set(19.0f / ptm_ratio, -10.5f / ptm_ratio);
//        verts[3].Set(19.0f / ptm_ratio, 24.5f / ptm_ratio);
//        verts[4].Set(4.0f / ptm_ratio, 24.5f / ptm_ratio);
//        
//        b2PolygonShape playerShape;
//        playerShape.Set(verts, num);
//        //playerShape.SetAsBox(0.8f,0.62f);//These are mid points for our 1m box
//        
//        //b2CircleShape playerShape;
//        //playerShape.m_radius=1.0;
//        
//        // Define the dynamic body fixture.
//        
//        fixtureDef.restitution = 0.0f;
//        fixtureDef.shape = &playerShape;	
//        fixtureDef.density = 1.0f;
//        fixtureDef.friction = 0.0f;
//        fixtureDef.filter.groupIndex=-3;
//        //fixtureDef.isSensor = true;
//        actualBody= body->CreateFixture(&fixtureDef);  
//        b2PolygonShape sensor2;
//        //sensor2.SetAsBox(0.801f,0.621f, b2Vec2(0.0f,0.0f) , 0);
//        sensor2.Set(verts, num);
//        b2FixtureDef deathChecker;
//        deathChecker.shape = &sensor2;	
//        deathChecker.isSensor=true;
//        deathChecker.filter.groupIndex=0;
//        b2Fixture *deathCheckerFixture = body->CreateFixture(&deathChecker);
//        
//        deathCheckerFixture->SetUserData((void *)4);
//    }
//    return self;
//}

-(void)blink:(BOOL)isBlink
{
    if (isBlink)
        playerSprite.opacity = 150;
    else
        playerSprite.opacity = 255;
}
-(BOOL)footPosition
{
    float pos = (body->GetPosition().y - 0.53*g_fy);
    return pos;
}
- (void)updatePlayer
{
    if(isGrounded&&[playerSprite numberOfRunningActions]<1){
      [playerSprite stopAllActions];
      [playerSprite runAction:walkAction];
    }
    
    body->SetLinearVelocity(b2Vec2(5.0*g_fx + additionalSpeed*g_fx, body->GetLinearVelocity().y));
}

-(void)playerJumps

{   
    [playerSprite stopAllActions];
    [playerSprite runAction:jumpAction];
     
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        body->ApplyLinearImpulse(b2Vec2(0.0,140.0), body->GetWorldCenter());
    else
        body->ApplyLinearImpulse(b2Vec2(0.0,20.0), body->GetWorldCenter());
}

-(void)playerHurtJumps

{   
    [playerSprite stopAllActions];
    [playerSprite runAction:jumpAction];
    
    body->SetTransform(b2Vec2(body->GetPosition().x, body->GetPosition().y+3.0f*g_fy), body->GetAngle());
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        body->ApplyLinearImpulse(b2Vec2(0.0,140.0), body->GetWorldCenter());
    else
        body->ApplyLinearImpulse(b2Vec2(0.0,20.0), body->GetWorldCenter());
}


-(void)playerDoubleJumps
{       
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        body->ApplyLinearImpulse(b2Vec2(0.0,70.0), body->GetWorldCenter());
    else
        body->ApplyLinearImpulse(b2Vec2(0.0,10.0), body->GetWorldCenter());
}

-(void)playerHurt: (float)duration
{
    isPlayerRunning = false;
    
    [playerSprite stopAllActions];
    [playerSprite runAction:hurtAction];
    
    countTime2 = duration * 100;    
    [self schedule:@selector(countDown:)];
}

-(void) countDown: (ccTime) delta
{
    if (isPaused) {
        countTime2--;
        if(countTime2==0){
            [self unschedule:@selector(countDown:)];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GameOver scene]] ];
        }
    }
    else {
        [self unschedule:@selector(countDown:)];
    }

}

- (CGPoint )getPosition

{
    return  ccp(body->GetPosition().x*ptm_ratio,body->GetPosition().y*ptm_ratio);
}

- (void)followWithCameraFromLayer: (CCLayer *)layer
{
	[layer.camera setEyeX:body->GetPosition().x*ptm_ratio-120*g_fx eyeY:-20*g_fy eyeZ:1];
	[layer.camera setCenterX:body->GetPosition().x*ptm_ratio-120*g_fx centerY:-20*g_fy centerZ:0];
}

-(void)dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    self.playerSprite = nil;
    self.walkAction = nil;
    [self removeAllChildrenWithCleanup:YES];
    
    [super dealloc];

}
@end
