

#import "GameLayer.h"
#import "Player.h"
#import "globals.h"
#import "BackgroundLayer.h"
#import "FullLayer.h"
#import "GameOver.h"
#import "HudLayer.h"
#import "PauseMenu.h"
#import "ReviveLayer.h"
#import "AppDelegate.h"
#import "DebugSprite.h"

#define MAX_GROUNDS 8

@implementation GameLayer

@synthesize groundTextures;

+(id)scene
{
    CCScene *scene=[CCScene node];
    GameLayer *layer=[GameLayer node];
    [scene addChild:layer];
    return scene;
}

-(void)createWorld
{
    
    b2Vec2 gravity;
    gravity.Set(0.0f, -36.0f);
    
    // Do we want to let bodies sleep?
    // This will speed up the physics simulation
    bool doSleep = true;
    
    // Construct a world object, which will hold and simulate the rigid bodies.
    world = new b2World(gravity);
    world->SetAllowSleeping(doSleep);
    world->SetAutoClearForces(true);
    world->SetWarmStarting(true);
    world->SetContinuousPhysics(true);
    
}

-(void) addRamp:(CGPoint) startPosition

{
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(startPosition.x,startPosition.y);
    b2Body* groundBody = world->CreateBody(&groundBodyDef);
    b2EdgeShape groundBox;
    // bottom
    for(int i=0;i<5;i++)
    {
        double x=i;
        double nextx=(i+1);
        
        double y=4.0*x*x/32;
        double nexty =4.0* (x+1)*(x+1)/32;
        
        groundBox.Set(b2Vec2(x,y),b2Vec2(nextx,nexty));
        
        groundBody->CreateFixture(&groundBox,0);
        if(i==4)
        {
            groundBox.Set(b2Vec2(nextx,nexty), b2Vec2(nextx+3,nexty));
            groundBody->CreateFixture(&groundBox,0);
        }
    }
}

-(void)spawnObstacleWithWorld:(b2Vec2)groundPos
{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    CCSprite *obstacleSprite;
    
    obstacleSprite = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:res(@"scarecrow.png")]];
    //obstacleSprite.scale = 0.5;
    obstacleSprite.tag = OBSTACLE_TAG;
    [self addChild:obstacleSprite];
    
    int i = screenSize.width / 5;
    int random = (arc4random() % i) * pow(-1, arc4random());
    
    prevObstacle = groundPos.x * ptm_ratio;
    b2BodyDef obstacleBody;
    obstacleBody.type = b2_dynamicBody;
    obstacleBody.allowSleep=true;
    obstacleBody.position.Set((prevObstacle + random)/ptm_ratio, (screenSize.height/2+60*g_fy)/ptm_ratio);
    obstacleBody.userData = obstacleSprite;
    obstacleBody.fixedRotation=true;
    obstacleBody.angularDamping=0.0f;
    
    //playerBody.linearDamping=1.0f;
    
    b2Body *body;
    body = world->CreateBody(&obstacleBody);
    // Define another box shape for our dynamic body.
    
    b2Vec2 verts[20];
    int32 num = 6;
    verts[0].Set(-86*g_fx / ptm_ratio, -22*g_fy / ptm_ratio);
    verts[1].Set(86*g_fx / ptm_ratio, -22*g_fy / ptm_ratio);
    verts[2].Set(86*g_fx / ptm_ratio, 11.5f*g_fy / ptm_ratio);
    verts[3].Set(80*g_fx / ptm_ratio, 22*g_fy / ptm_ratio);
    verts[4].Set(-80*g_fx / ptm_ratio, 22*g_fy / ptm_ratio);
    verts[5].Set(-86*g_fx / ptm_ratio, 14.5f*g_fy / ptm_ratio);
    
    
    b2PolygonShape obstacleShape;
    obstacleShape.Set(verts, num);
    
    // Define the dynamic body fixture.
    b2FixtureDef fixtureDef;
    fixtureDef.restitution = 0.0f;
    fixtureDef.shape = &obstacleShape;
    fixtureDef.density = 1.0f;
    fixtureDef.friction = 0.0f;
    fixtureDef.filter.groupIndex=-3;
    body->CreateFixture(&fixtureDef);
}

-(void)spawnCorn
{
    if (arc4random() % 3)
        return;
    
    b2Body *body;
    int num;
    b2Vec2 verts[20];
    
    CCSprite *cornSprite = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat: res(@"cornlife.png")]]];
    
    num = 8;
    verts[0].Set(-11.5f*g_fx / ptm_ratio, 9.4f*g_fy / ptm_ratio);
    verts[1].Set(-9.7f*g_fx / ptm_ratio, -6.5f*g_fy / ptm_ratio);
    verts[2].Set(-0.9f*g_fx / ptm_ratio, -13.3f*g_fy / ptm_ratio);
    verts[3].Set(8.0f*g_fx / ptm_ratio, -5.8f*g_fy / ptm_ratio);
    verts[4].Set(8.7f*g_fx / ptm_ratio, 7.6f*g_fy / ptm_ratio);
    verts[5].Set(4.1f*g_fx / ptm_ratio, 17.9f*g_fy / ptm_ratio);
    verts[6].Set(0.5f*g_fx / ptm_ratio, 20.3f*g_fy / ptm_ratio);
    verts[7].Set(-10.8f*g_fx / ptm_ratio, 13.3f*g_fy / ptm_ratio);
    
    cornSprite.tag = FRUIT_TAG;
    [self addChild:cornSprite z:FRUIT_ZORDER];
    
    b2BodyDef cornBody;
    cornBody.type = b2_dynamicBody;
    cornBody.allowSleep=true;
    cornBody.position.Set((nextloc.x - 1.5*g_fx), 4.0*g_fy);
    cornBody.userData = cornSprite;
    cornBody.fixedRotation=true;
    cornBody.angularDamping=0.0f;
    cornBody.gravityScale = 0;
    
    body = world->CreateBody(&cornBody);
    // Define another box shape for our dynamic body.
    
    b2PolygonShape cornShape;
    cornShape.Set(verts, num);
    
    // Define the dynamic body fixture.
    
    b2FixtureDef fixtureDef;
    fixtureDef.restitution = 0.0f;
    fixtureDef.shape = &cornShape;
    fixtureDef.density = 1.0f;
    fixtureDef.friction = 0.0f;
    fixtureDef.filter.groupIndex=-3;
    body->CreateFixture(&fixtureDef);
}

-(void)createTerrain
{
    int randomTerrain=arc4random()%8;
    if (isFirstTerrain)
    {
        randomTerrain=2;
        isFirstTerrain=false;
    }
    CCSprite *terrain=[CCSprite spriteWithTexture:[groundTextures objectAtIndex:randomTerrain]];
    terrain.tag = TERRAIN_TAG;
    
    [self addChild:terrain z:1];
    // Define the ground body.
    b2BodyDef groundBodyDef;
    
    b2Vec2 temporaryVec;
    // Sets the center of the groundBody according to the current width of the ground
    switch (randomTerrain) {
        case 0:
        {   temporaryVec=b2Vec2(nextloc.x+(183/2/ptm_ratio),nextloc.y);
            break;
        }
        case 1:
        {
            temporaryVec=b2Vec2(nextloc.x+(263/2/ptm_ratio),nextloc.y);
            break;
        }
        case 2:
        {
            temporaryVec=b2Vec2(nextloc.x+(552/2/ptm_ratio),nextloc.y);
            break;
        }
        case 3:
        {
            temporaryVec=b2Vec2(nextloc.x+(380/2/ptm_ratio),nextloc.y);
            break;
        }
        case 4:
        {
            temporaryVec=b2Vec2(nextloc.x+(552/2/ptm_ratio),nextloc.y);
            break;
        }
        case 5:
        {
            temporaryVec=b2Vec2(nextloc.x+(178/2/ptm_ratio),nextloc.y);
            break;
        }
        case 6:
        {
            temporaryVec=b2Vec2(nextloc.x+(394/2/ptm_ratio),nextloc.y);
            break;
        }
        case 7:
        {
            temporaryVec=b2Vec2(nextloc.x+(278/2/ptm_ratio),nextloc.y);
            break;
        }
        default:
            break;
    }
    
    groundBodyDef.position=temporaryVec;
    groundBodyDef.userData=terrain;
    
    // bottom-left corner
    // Call the body factory which allocates memory for the ground body
    // from a pool and creates the ground box shape (also from a pool).
    // The body is also added to the world.
    
    b2Body* groundBody = world->CreateBody(&groundBodyDef);
    // Define the ground box shape.
    
    b2EdgeShape groundBox;
    
    float rOffsetY = 0.1;
    // float randomness=arc4random()%4;
    switch (randomTerrain) {
        case 0:
        {
            groundBox.Set(b2Vec2(-(183/2/ptm_ratio)+rOffsetY,(43/2/ptm_ratio)-0.0), b2Vec2(+(183/2/ptm_ratio),(43/2/ptm_ratio)-0.0));
            nextloc=b2Vec2(groundBody->GetPosition().x+(183/2/ptm_ratio)+3,0);
            break;
        }
        case 1:
        {
            groundBox.Set(b2Vec2(-(263/2/ptm_ratio)+rOffsetY,(46/2/ptm_ratio)-0.0), b2Vec2(+(263/2/ptm_ratio),(46/2/ptm_ratio)-0.0));
            nextloc=b2Vec2(groundBody->GetPosition().x+(263/2/ptm_ratio)+3,0);
            break;
        }
        case 2:
        {
            groundBox.Set(b2Vec2(-(552/2/ptm_ratio)+rOffsetY,(44/2/ptm_ratio)-0.0), b2Vec2(+(552/2/ptm_ratio),(44/2/ptm_ratio)-0.0));
            nextloc=b2Vec2(groundBody->GetPosition().x+(552/2/ptm_ratio)+3,0);
            break;
        }
        case 3:
        {
            groundBox.Set(b2Vec2(-(380/2/ptm_ratio)+rOffsetY,(49/2/ptm_ratio)-0.0), b2Vec2(+(380/2/ptm_ratio),(49/2/ptm_ratio)-0.0));
            nextloc=b2Vec2(groundBody->GetPosition().x+(380/2/ptm_ratio)+3,0);
            break;
        }
        case 4:
        {
            groundBox.Set(b2Vec2(-(552/2/ptm_ratio)+rOffsetY,(68/2/ptm_ratio)-0.7), b2Vec2(+(552/2/ptm_ratio),(68/2/ptm_ratio)-0.7));
            nextloc=b2Vec2(groundBody->GetPosition().x+(552/2/ptm_ratio)+3,0);
            break;
        }
        case 5:
        {
            groundBox.Set(b2Vec2(-(178/2/ptm_ratio)+rOffsetY,(69/2/ptm_ratio)-0.7), b2Vec2(+(178/2/ptm_ratio),(69/2/ptm_ratio)-0.7));
            nextloc=b2Vec2(groundBody->GetPosition().x+(178/2/ptm_ratio)+3,0);
            break;
        }
        case 6:
        {
            groundBox.Set(b2Vec2(-(394/2/ptm_ratio)+rOffsetY,(71/2/ptm_ratio)-0.7), b2Vec2(+(394/2/ptm_ratio),(71/2/ptm_ratio)-0.7));
            nextloc=b2Vec2(groundBody->GetPosition().x+(394/2/ptm_ratio)+3,0);
            break;
        }
        case 7:
        {
            groundBox.Set(b2Vec2(-(278/2/ptm_ratio)+rOffsetY,(71/2/ptm_ratio)-0.7), b2Vec2(+(278/2/ptm_ratio),(71/2/ptm_ratio)-0.7));
            nextloc=b2Vec2(groundBody->GetPosition().x+(278/2/ptm_ratio)+3,0);
            break;
        }
        default:
            break;
    }
    
    //groundBox.Set(b2Vec2(0,0), b2Vec2(screenSize.width/ptm_ratio-randomness,0));
    groundBody->CreateFixture(&groundBox,0);
    // top
    //groundBox.Set(b2Vec2(0,screenSize.height/ptm_ratio), b2Vec2(screenSize.width/ptm_ratio,screenSize.height/ptm_ratio));
    //groundBody->CreateFixture(&groundBox,screenSize.height/ptm_ratio);
    
    visibleCnt++;
    if (/*((randomTerrain+1)%3 == 1) &&*/ visibleCnt > 0) {
        if (randomTerrain == 2 || randomTerrain == 3 || randomTerrain == 4 || randomTerrain == 6)
            [self spawnObstacleWithWorld:groundBody->GetPosition()];
    }
    
}

-(void)createTerrainForIPad
{
    int randomTerrain=arc4random()%8;
    if (isFirstTerrain)
    {
        randomTerrain=2;
        isFirstTerrain=false;
    }
    CCSprite *terrain=[CCSprite spriteWithTexture:[groundTextures objectAtIndex:randomTerrain]];
    terrain.tag = TERRAIN_TAG;
    
    [self addChild:terrain z:1];
    // Define the ground body.
    b2BodyDef groundBodyDef;
    
    b2Vec2 temporaryVec;
    // Sets the center of the groundBody according to the current width of the ground
    switch (randomTerrain) {
        case 0:
        {   temporaryVec=b2Vec2(nextloc.x+(540/2/ptm_ratio),nextloc.y);
            break;
        }
        case 1:
        {
            temporaryVec=b2Vec2(nextloc.x+(589/2/ptm_ratio),nextloc.y);
            break;
        }
        case 2:
        {
            temporaryVec=b2Vec2(nextloc.x+(1235/2/ptm_ratio),nextloc.y);
            break;
        }
        case 3:
        {
            temporaryVec=b2Vec2(nextloc.x+(840/2/ptm_ratio),nextloc.y);
            break;
        }
        case 4:
        {
            temporaryVec=b2Vec2(nextloc.x+(1235/2/ptm_ratio),nextloc.y);
            break;
        }
        case 5:
        {
            temporaryVec=b2Vec2(nextloc.x+(399/2/ptm_ratio),nextloc.y);
            break;
        }
        case 6:
        {
            temporaryVec=b2Vec2(nextloc.x+(399/2/ptm_ratio),nextloc.y);
            break;
        }
        case 7:
        {
            temporaryVec=b2Vec2(nextloc.x+(625/2/ptm_ratio),nextloc.y);
            break;
        }
        default:
            break;
    }
    
    groundBodyDef.position=temporaryVec;
    groundBodyDef.userData=terrain;
    
    // bottom-left corner
    // Call the body factory which allocates memory for the ground body
    // from a pool and creates the ground box shape (also from a pool).
    // The body is also added to the world.
    
    b2Body* groundBody = world->CreateBody(&groundBodyDef);
    // Define the ground box shape.
    
    b2EdgeShape groundBox;
    
    float rOffsetY = 0.2;
    // float randomness=arc4random()%4;
    switch (randomTerrain) {
        case 0:
        {
            groundBox.Set(b2Vec2(-(540/2/ptm_ratio)+rOffsetY,(155/2/ptm_ratio)-1.0), b2Vec2(+(540/2/ptm_ratio),(155/2/ptm_ratio)-1.0));
            nextloc=b2Vec2(groundBody->GetPosition().x+(540/2/ptm_ratio)+6,0);
            break;
        }
        case 1:
        {
            groundBox.Set(b2Vec2(-(589/2/ptm_ratio)+rOffsetY,(103/2/ptm_ratio)-1.0), b2Vec2(+(589/2/ptm_ratio),(103/2/ptm_ratio)-1.0));
            nextloc=b2Vec2(groundBody->GetPosition().x+(589/2/ptm_ratio)+6,0);
            break;
        }
        case 2:
        {
            groundBox.Set(b2Vec2(-(1235/2/ptm_ratio)+rOffsetY,(99/2/ptm_ratio)-1.0), b2Vec2(+(1235/2/ptm_ratio),(99/2/ptm_ratio)-1.0));
            nextloc=b2Vec2(groundBody->GetPosition().x+(1235/2/ptm_ratio)+6,0);
            break;
        }
        case 3:
        {
            groundBox.Set(b2Vec2(-(840/2/ptm_ratio)+rOffsetY,(108/2/ptm_ratio)-0.5), b2Vec2(+(840/2/ptm_ratio),(108/2/ptm_ratio)-0.5));
            nextloc=b2Vec2(groundBody->GetPosition().x+(840/2/ptm_ratio)+6,0);
            break;
        }
        case 4:
        {
            groundBox.Set(b2Vec2(-(1235/2/ptm_ratio)+rOffsetY,(152/2/ptm_ratio)-0.7), b2Vec2(+(1235/2/ptm_ratio),(152/2/ptm_ratio)-0.7));
            nextloc=b2Vec2(groundBody->GetPosition().x+(1235/2/ptm_ratio)+6,0);
            break;
        }
        case 5:
        {
            groundBox.Set(b2Vec2(-(399/2/ptm_ratio)+rOffsetY,(155/2/ptm_ratio)-0.7), b2Vec2(+(399/2/ptm_ratio),(155/2/ptm_ratio)-0.7));
            nextloc=b2Vec2(groundBody->GetPosition().x+(399/2/ptm_ratio)+6,0);
            break;
        }
        case 6:
        {
            groundBox.Set(b2Vec2(-(399/2/ptm_ratio)+rOffsetY,(155/2/ptm_ratio)-0.7), b2Vec2(+(399/2/ptm_ratio),(155/2/ptm_ratio)-0.7));
            nextloc=b2Vec2(groundBody->GetPosition().x+(399/2/ptm_ratio)+6,0);
            break;
        }
        case 7:
        {
            groundBox.Set(b2Vec2(-(625/2/ptm_ratio)+rOffsetY,(159/2/ptm_ratio)-1.0), b2Vec2(+(625/2/ptm_ratio),(159/2/ptm_ratio)-1.0));
            nextloc=b2Vec2(groundBody->GetPosition().x+(625/2/ptm_ratio)+6,0);
            break;
        }
        default:
            break;
    }
    
    //groundBox.Set(b2Vec2(0,0), b2Vec2(screenSize.width/ptm_ratio-randomness,0));
    groundBody->CreateFixture(&groundBox,0);
    // top
    //groundBox.Set(b2Vec2(0,screenSize.height/ptm_ratio), b2Vec2(screenSize.width/ptm_ratio,screenSize.height/ptm_ratio));
    //groundBody->CreateFixture(&groundBox,screenSize.height/ptm_ratio);
    
    visibleCnt++;
    if (/*((randomTerrain+1)%3 == 1) &&*/ visibleCnt > 0) {
        if (randomTerrain == 2 || randomTerrain == 3 || randomTerrain == 4 || randomTerrain == 7)
            [self spawnObstacleWithWorld:groundBody->GetPosition()];
    }
    
}

-(void) spawnEnemies{
    
    if (arc4random() % 3)
        return;
    
    b2Body *body;
    CCSprite *enemySprite;
    
    CCAction *flyAction;
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    //    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
    //     @"crow.plist"];
    
    UIImage* image;
    NSMutableArray *flyAnimFrames = [NSMutableArray array];
    for(int i = 1; i <= 4; ++i) {
        //        [flyAnimFrames addObject:
        //         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
        //          [NSString stringWithFormat:@"crow_00%d.png", i]]];
        
        image = [[UIImage imageNamed:[NSString stringWithFormat:res(@"crow_00%d.png"), i]] autorelease];
    	CCTexture2D *texture = [[[CCTexture2D alloc] initWithImage:image] autorelease];
    	
    	// manually add frames to the frame cache
    	CCSpriteFrame *frame0 = [CCSpriteFrame frameWithTexture:texture
                                                           rect:CGRectMake(0, 0, texture.contentSize.width, texture.contentSize.height)];
    	[flyAnimFrames addObject:frame0];
        
    }
    
    CCAnimation *flyAnim = [CCAnimation
                            animationWithFrames:flyAnimFrames delay:0.08f];
    enemySprite = [CCSprite spriteWithFile:res(@"crow_001.png")];
    flyAction = [CCRepeatForever actionWithAction:
                 [CCAnimate actionWithAnimation:flyAnim restoreOriginalFrame:NO]];
    
    [enemySprite runAction:flyAction];
    
    enemySprite.tag=25;
    [self addChild:enemySprite z:100];
    
    int i = screenSize.width / 2;
    int random = (arc4random() % i) + 0;
    
    prevObstacle = [player1 getPosition].x + screenSize.width * 1.5;
    b2BodyDef enemyBody;
    enemyBody.type = b2_dynamicBody;
    enemyBody.allowSleep=true;
    enemyBody.position.Set((prevObstacle + random)/ptm_ratio, (screenSize.height/2 + (arc4random() % (int)(screenSize.height/4)) * pow(-1, arc4random()))/ptm_ratio);
    enemyBody.userData = enemySprite;
    enemyBody.fixedRotation=true;
    enemyBody.angularDamping=0.0f;
    enemyBody.gravityScale = 0;
    
    body = world->CreateBody(&enemyBody);
    //        body->SetTransform(b2Vec2(2.0f,body->GetPosition().y), body->GetAngle());
    // Define another box shape for our dynamic body.
    
    int num;
    b2Vec2 verts[20];
    num = 5;
    verts[0].Set(-23.5f*g_fx / ptm_ratio, -3.0f*g_fy / ptm_ratio);
    verts[1].Set(-0.5f*g_fx / ptm_ratio, -16.0f*g_fy / ptm_ratio);
    verts[2].Set(22.5f*g_fx / ptm_ratio, -3.0f*g_fy / ptm_ratio);
    verts[3].Set(17.5f*g_fx / ptm_ratio, 18.0f*g_fy / ptm_ratio);
    verts[4].Set(-8.5f*g_fx / ptm_ratio, 19.0f*g_fy / ptm_ratio);
    
    b2PolygonShape enemyShape;
    enemyShape.Set(verts, num);
    //        enemyShape.SetAsBox(/*0.8f,0.92f*/ 0.4,0.25);//These are mid points for our 1m box
    
    //b2CircleShape playerShape;
    //playerShape.m_radius=1.0;
    
    // Define the dynamic body fixture.
    
    b2FixtureDef fixtureDef;
    fixtureDef.restitution = 0.0f;
    fixtureDef.shape = &enemyShape;
    fixtureDef.density = 1.0f;
    fixtureDef.friction = 0.0f;
    fixtureDef.filter.groupIndex=-3;
    body->CreateFixture(&fixtureDef);
    
    body->SetLinearVelocity(b2Vec2(-2.5*g_fx,body->GetLinearVelocity().y));
    
    //    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    //    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
}

-(id)init
{
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(actionPause:) name: PAUSE_NOTIFICATION object: nil];

    
    blinkTimer = 0;
    if(self=[super init])
        
    {
        
        
        
        self.isTouchEnabled=YES;
        isFirstTerrain=YES;
        isGrounded = false;
        isPlayerJump = false;
        
        //positions for paralax
        currentposition=ccp(0,0);
        lastposition=ccp(0,0);
        
        nextloc=b2Vec2(0.f,0.f);
        
        isPaused = false;
        numFootContacts=0;
        
        visibleCnt = -10;
        
        [self createWorld];
        
        //        background = [[BackgroundLayer alloc] init];
        //        background.visible =YES;
        //		[self addChild:background z:0];
        
        //player1->isCharging=false;
        
        //        m_debugDraw = new GLESDebugDraw( ptm_ratio );
        //
        //		uint32 flags = 0;
        //		flags += b2Draw::e_shapeBit;
        //        flags += b2Draw::e_centerOfMassBit;
        //
        //		m_debugDraw->SetFlags(flags);
        //        world->SetDebugDraw(m_debugDraw);
        
        _contactListener = new ContactListener();
        world->SetContactListener(_contactListener);
        
        isInvisible = NO;
        isLoadedData = false;
        [self schedule:@selector(loadData) interval:0.5];
        
        //		DebugSprite *spDebug = [[DebugSprite alloc] initWithWorld:world];
        //		[spDebug setPosition:ccp(0, 0)];
        //		[self addChild:spDebug z:10];
    }
    return self;
}

- (void) loadData {
    
    if (!isLoadedData) {
        isLoadedData = true;
        
        background = [[BackgroundLayer alloc] init];
        background.visible =YES;
		[self addChild:background z:0];
        
        self.groundTextures = [NSMutableArray arrayWithCapacity:MAX_GROUNDS];
        
        for (int cnt = 0; cnt < MAX_GROUNDS; cnt++) {
            CCTexture2D *groundTex = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:res(@"stage%d.png"),cnt+1]];
            [self.groundTextures addObject:groundTex];
        }
        
        [self.parent addHudLayer];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [self createTerrainForIPad];
        else
            [self createTerrain];
        
        player1 = [[Player alloc] initWithWorld:world];
        [self addChild:player1 z:100];
        
        [self schedule:@selector(tick:)];
        [self schedule:@selector(spawnCorn) interval:15];
        [self schedule:@selector(spawnEnemies) interval:4];
        
        [self unschedule:@selector(loadData)];
    }
}

-(void)gameOverForRevive
{
    isPaused=true;
    [self.parent pauseSchedulerAndActionsRecursive:self.parent];
    ReviveLayer *reviveLayer= [[ReviveLayer alloc] init];
    [self.parent addChild:reviveLayer z:102];
    [reviveLayer release];
    
    [player1 playerHurt:2.0];
}

-(void) draw
{
    [super draw];
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY,
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
}

- (void)ccTouchesBegan:(NSSet *)touch withEvent:(UIEvent *)event
{
    if(isPaused) return;
    
    NSSet *allTouches= [event allTouches];
    
    for (UITouch * touch in allTouches)
    {
        
        if(touch.phase==UITouchPhaseBegan)
        {
            CGPoint location = [touch locationInView:[touch view]];
            location = [[CCDirector sharedDirector] convertToGL:location];
            
            CGSize screenSize = [CCDirector sharedDirector].winSize;

            
            if( screenSize.width == 568 || screenSize.height == 568 )
                pause = CGRectMake([[UIScreen mainScreen] bounds].size.width*1.45, 290*g_fy, 45*g_fx, 42*g_fy);

            else
            
             pause = CGRectMake([[UIScreen mainScreen] bounds].size.width*1.25, 290*g_fy, 45*g_fx, 42*g_fy);
            //NSLog(@"%@", NSStringFromCGPoint(location));

            if(CGRectContainsPoint(pause, location))
            {
                //printf("trying to pause");
                
//                if (effectsoundOn)
//                    [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
//                
//                isPaused=true;
//                [self.parent pauseSchedulerAndActionsRecursive:self.parent];
//                PauseMenu *pauseMenu= [[PauseMenu alloc] init];
//                [self.parent addChild:pauseMenu z:102];
//                [pauseMenu release];
            }
            else if (isGrounded) {
                
                if (effectsoundOn)
                    [[AppDelegate get].m_pSoundEngine playEffect:@"jump.mp3"];
                
                [player1 playerJumps ];
                isPlayerJump = true;
            }
            
        }
    }
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    static NSTimeInterval lastTapTime;
    static CGPoint lastTouch;
    NSTimeInterval tapTime;
    
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:[touch view]];
    
    if (lastTapTime)
    {
		tapTime = [NSDate timeIntervalSinceReferenceDate] - lastTapTime;
        
        NSLog(@"tap time = %f", tapTime);
        
        if(tapTime <= 0.5 && isPlayerJump)
        {
            //User double-tapped
            isPlayerJump = false;
            [player1 playerDoubleJumps ];
        }
    }
    
    lastTouch = touchLocation;
    lastTapTime = [NSDate timeIntervalSinceReferenceDate];
    
}

-(void) mort: (ccTime) delta
{
    invisibleCnt--;
    isInvisible = YES;
    if(invisibleCnt == 0)
    {
        isInvisible = NO;
        [self unschedule:@selector(mort:)];
    }
    
}

-(void)tick:(ccTime) dt
{
    
    if (isPlayerRunning && [player1 getPosition].y < 0) {
        [player1 playerHurtJumps];
    }
    
    blinkTimer ++;
    if (blinkTimer >= BLINK_INTERVAL * 2)
        blinkTimer = 0;
    if (isInvisible)
    {
        if (blinkTimer < BLINK_INTERVAL)
            [player1 blink:YES];
        else
            [player1 blink:NO];
    }
    else
        [player1 blink:NO];
    
    static double UPDATE_INTERVAL = 1.0f/60.0f;
    static double MAX_CYCLES_PER_FRAME = 5;
    static double timeAccumulator = 0;
    
    timeAccumulator += dt;
    if (timeAccumulator > (MAX_CYCLES_PER_FRAME * UPDATE_INTERVAL)) {
        timeAccumulator = UPDATE_INTERVAL;
    }
    
    int32 velocityIterations = 5;
    int32 positionIterations = 2;
    while (timeAccumulator >= UPDATE_INTERVAL) {
        timeAccumulator -= UPDATE_INTERVAL;
        world->Step(UPDATE_INTERVAL,
                    velocityIterations, positionIterations);
        world->ClearForces();
    }
    
    [player1 followWithCameraFromLayer:self];
    [player1 updatePlayer];
    
    std::vector<b2Body *>toDestroy;
    std::vector<MyContact>::iterator pos;
    for(pos = _contactListener->_contacts.begin();
        pos != _contactListener->_contacts.end(); ++pos) {
        MyContact contact = *pos;
        b2Body *bodyA = contact.fixtureA->GetBody();
        b2Body *bodyB = contact.fixtureB->GetBody();
        if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL) {
            CCSprite *spriteA = (CCSprite *) bodyA->GetUserData();
            CCSprite *spriteB = (CCSprite *) bodyB->GetUserData();
            
            
            if ((spriteA.tag == PLAYER_TAG && spriteB.tag == OBSTACLE_TAG)|| (spriteA.tag==PLAYER_TAG && spriteB.tag==ENEMY_TAG)) {
                if (std::find(toDestroy.begin(), toDestroy.end(), bodyA)
                    == toDestroy.end()) {
                    toDestroy.push_back(bodyB);
                }
            }
            else if ((spriteA.tag == OBSTACLE_TAG && spriteB.tag == PLAYER_TAG)||(spriteA.tag==ENEMY_TAG && spriteB.tag==PLAYER_TAG)) {
                if (std::find(toDestroy.begin(), toDestroy.end(), bodyB)
                    == toDestroy.end()) {
                    toDestroy.push_back(bodyA);
                    
                }
            }
            
            if (spriteA.tag == PLAYER_TAG && spriteB.tag == FRUIT_TAG) {
                if (std::find(toDestroy.begin(), toDestroy.end(), bodyB)
                    == toDestroy.end()) {
                    toDestroy.push_back(bodyB);
                    
                }
            }
            if (spriteB.tag == PLAYER_TAG && spriteA.tag == FRUIT_TAG) {
                if (std::find(toDestroy.begin(), toDestroy.end(), bodyA)
                    == toDestroy.end()) {
                    toDestroy.push_back(bodyA);
                    
                }
            }
            
            if (spriteA.tag == PLAYER_TAG && spriteB.tag == TERRAIN_TAG) {
                if (std::find(toDestroy.begin(), toDestroy.end(), bodyB)
                    == toDestroy.end()) {
                    toDestroy.push_back(bodyB);
                    
                }
            }
            if (spriteB.tag == PLAYER_TAG && spriteA.tag == TERRAIN_TAG) {
                if (std::find(toDestroy.begin(), toDestroy.end(), bodyA)
                    == toDestroy.end()) {
                    toDestroy.push_back(bodyA);
                    
                }
            }
        }
    }
    
    bool isTerrain = false;
    std::vector<b2Body *>::iterator pos2;
    for(pos2 = toDestroy.begin(); pos2 != toDestroy.end(); ++pos2) {
        b2Body *body = *pos2;
        if (body->GetUserData() != NULL) {
            CCSprite *sprite = (CCSprite *) body->GetUserData();
            if ((sprite.tag==ENEMY_TAG || sprite.tag == OBSTACLE_TAG) && !isInvisible)
            {
                invisibleCnt=4;
                isInvisible = YES;
                [player1 updatePlayer];
                
                if (effectsoundOn)
                    [[AppDelegate get].m_pSoundEngine playEffect:@"hit.mp3"];
                
                [self schedule:@selector(mort:) interval:0.25];
                if(isDead == false)
                {
                    if (lifesLeft > 0) {
                        lifesLeft --;
                    }
                }
                if(lifesLeft <= 0) {
                    NSLog(@"gameover");
                    
                    if (revivesLeft > 0) {
                        [self gameOverForRevive];
                    }
                    else {
                        isPaused = true;
                        [self unscheduleAllSelectors];
                        [player1 playerHurt:0.5];
                    }
                }
            }
            else if(sprite.tag==FRUIT_TAG){
                lifesLeft ++;
                [self removeChild:sprite cleanup:YES];
                
                world->DestroyBody(body);
            }
            else if(sprite.tag==TERRAIN_TAG) {
                isTerrain = true;
            }
        }
    }
    
    if (isTerrain) {
        isGrounded = true;
    }
    else {
        isGrounded = false;
    }
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    if([player1 getPosition].x>nextloc.x * ptm_ratio - screenSize.width)
    {
        //printf("Creating terrain @Player Position %f  when terrain is %f \n",[player1 getPosition].x,nextloc.x * ptm_ratio - screenSize.width);
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [self createTerrainForIPad];
        else
            [self createTerrain];
    }
    
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData()!=NULL)
        {
            
            CCSprite *myActor = (CCSprite*)b->GetUserData();
            myActor.position = CGPointMake( b->GetPosition().x * ptm_ratio, b->GetPosition().y * ptm_ratio);
            myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
            
            if( myActor.tag==PLAYER_TAG && b->GetPosition().y<0)
            {
                if (effectsoundOn)
                    [[AppDelegate get].m_pSoundEngine playEffect:@"dead.mp3"];
                
                NSLog(@"gameover");
                if (revivesLeft > 0) {
                    [self gameOverForRevive];
                }
                else {
                    isPaused = true;
                    [self unscheduleAllSelectors];
                    [player1 playerHurt:0.5];
                }
            }
        }
        
        currentposition=ccp([player1 getPosition].x,[player1 getPosition].y);
        [background updateWithPlayerPosition:lastposition :currentposition];
        lastposition=currentposition;
    }
}

-(void)actionPause :(id)sender{

    
                    if (effectsoundOn)
                        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
                    isPaused=true;
                    [self.parent pauseSchedulerAndActionsRecursive:self.parent];
                    PauseMenu *pauseMenu= [[PauseMenu alloc] init];
                    [self.parent addChild:pauseMenu z:102];
                    [pauseMenu release];
    
    


}

- (void) pauseGame: (id) sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.2 scene:[GameOver scene]] ];
}

-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver: self];

    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    [groundTextures release];
    delete world;
    delete _contactListener;
    [background release];
    //[player1 release];
    [self removeAllChildrenWithCleanup:YES];
    
    [super dealloc];
    
}
@end
