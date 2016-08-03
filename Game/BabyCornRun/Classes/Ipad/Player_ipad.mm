

#import "Player_ipad.h"
#import "globals.h"
#import "GameLayer_ipad.h"
#import "GameOver_ipad.h"

@implementation Player_ipad

@synthesize playerSprite;
@synthesize walkAction;
@synthesize jumpAction;
@synthesize hurtAction;

- (id)initWithWorld:(b2World *)world
{
	
    if ((self = [super init])) 
    {  
       CGSize screenSize = [CCDirector sharedDirector].winSize;     
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
         @"corn-hd.plist"];

        NSMutableArray *walkAnimFrames = [NSMutableArray array];
        for(int i = 1; i <= 8; ++i) {
            [walkAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"cornrun_00%d.png", i]]];
        }
        
        
        NSMutableArray *jumpAnimFrames = [NSMutableArray array];
        for(int i = 1; i <= 2; ++i) {
            [jumpAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"cornjump_00%d.png", i]]];
        }
        
        NSMutableArray *hurtAnimFrames = [NSMutableArray array];
        [hurtAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          @"cornhurt.png"]];
        
        
        CCAnimation *jumpAnim = [CCAnimation 
                       animationWithFrames:jumpAnimFrames delay:0.2f];
        
        CCAnimation *walkAnim = [CCAnimation 
                                 animationWithFrames:walkAnimFrames delay:0.08f];
        
        CCAnimation *hurtAnim = [CCAnimation 
                                 animationWithFrames:hurtAnimFrames delay:0.1f];
        
        self.playerSprite = [CCSprite spriteWithSpriteFrameName:@"cornrun_001.png"];        
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
        playerBody.position.Set((2.0)/ptm_ratio, (screenSize.height/2+60)/ptm_ratio);
        playerBody.userData = playerSprite;
        playerBody.fixedRotation=true;
       // playerBody.inertiaScale=0.5;
        playerBody.angularDamping=0.0f;
        
        //playerBody.linearDamping=1.0f;
        
        body = world->CreateBody(&playerBody);
        body->SetTransform(b2Vec2(2.0f,body->GetPosition().y), body->GetAngle()); 
        // Define another box shape for our dynamic body.
            
        b2Vec2 verts[20];
        int num = 5;
        verts[0].Set(-33.5f / ptm_ratio, -17.0f / ptm_ratio);
        verts[1].Set(-6.5f / ptm_ratio, -43.0f / ptm_ratio);
        verts[2].Set(34.5f / ptm_ratio, -11.0f / ptm_ratio);
        verts[3].Set(31.5f / ptm_ratio, 41.0f / ptm_ratio);
        verts[4].Set(6.5f / ptm_ratio, 45.0f / ptm_ratio);
        
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

-(void)blink:(BOOL)isBlink
{
    if (isBlink)
        playerSprite.opacity = 150;
    else
        playerSprite.opacity = 255;
}
-(BOOL)footPosition
{
    float pos = (body->GetPosition().y - 0.53);
    return pos;
}
- (void)updatePlayer
{
    if(isGrounded&&[playerSprite numberOfRunningActions]<1){
      [playerSprite stopAllActions];
      [playerSprite runAction:walkAction];
    }
    
    body->SetLinearVelocity(b2Vec2(6.0 + additionalSpeed, body->GetLinearVelocity().y));
}

-(void)playerJumps

{   
    [playerSprite stopAllActions];
    [playerSprite runAction:jumpAction];
     
    body->ApplyLinearImpulse(b2Vec2(0.0,15.0), body->GetWorldCenter());
}

-(void)playerHurtJumps

{   
    [playerSprite stopAllActions];
    [playerSprite runAction:jumpAction];
    
    body->SetTransform(b2Vec2(body->GetPosition().x, body->GetPosition().y+3.0f), body->GetAngle());
    body->ApplyLinearImpulse(b2Vec2(0.0,15.0), body->GetWorldCenter());
}


-(void)playerDoubleJumps
{       
    body->ApplyLinearImpulse(b2Vec2(0.0,5.0), body->GetWorldCenter());
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
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GameOver_ipad scene]] ];
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
	[layer.camera setEyeX:body->GetPosition().x*ptm_ratio-120 eyeY:-20 eyeZ:1];
	[layer.camera setCenterX:body->GetPosition().x*ptm_ratio-120 centerY:-20 centerZ:0];
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
