

#import "MainBackLayer_ipad.h"
#import "Player_ipad.h"
#import "globals.h"
#import "GLES-Render.h"
#import "ContactListener.h"

@implementation MainBackLayer_ipad

+(id) scene
{
    CCScene *scene = [CCScene node];
    
    MainBackLayer_ipad *layer = [MainBackLayer_ipad node];
    
    [scene addChild: layer];
    
    return scene;
}

-(id) init
{
    
    if( (self=[super init] )) {
        
        terrainY = 0.48;
        jumpPos = 1100;
        nextloc=b2Vec2(0.f,0.f);
        additionalSpeed = 0;
        
        [self createWorld];
   
        //m_debugDraw = new GLESDebugDraw( ptm_ratio );
	
        uint32 flags = 0;
        flags += b2Draw::e_shapeBit;
        flags += b2Draw::e_centerOfMassBit;
   
        //m_debugDraw->SetFlags(flags);
       //world->SetDebugDraw(m_debugDraw);
      
        _contactListener = new ContactListener();
        world->SetContactListener(_contactListener);
        
        if (isFirstMain){
            isFirstMain = false;
            groundTex = [[CCTextureCache sharedTextureCache] textureForKey:@"stage4-hd.png"];
        }
        else {
            groundTex = [[CCTextureCache sharedTextureCache] addImage:@"stage4-hd.png"];
        }
        
        [self createTerrain]; 
        player1 = [[Player_ipad alloc] initWithWorld:world];
        
        CGPoint position =[player1 getPosition];        
        [self addChild:player1 z:100];
        
        [self schedule:@selector(tick:)];
    }
    return self;
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

-(void)createTerrain
{  
    CCSprite *terrain=[CCSprite spriteWithTexture:groundTex];
    
    [self addChild:terrain z:1];
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    // Define the ground body.
    b2BodyDef groundBodyDef;
    
    b2Vec2 temporaryVec = b2Vec2(nextloc.x+8.98,nextloc.y); 
    
    groundBodyDef.position=temporaryVec;
    groundBodyDef.userData=terrain;
    
    // bottom-left corner
    // Call the body factory which allocates memory for the ground body
    // from a pool and creates the ground box shape (also from a pool).
    // The body is also added to the world.
    
    b2Body* groundBody = world->CreateBody(&groundBodyDef);
    // Define the ground box shape.
    
    b2EdgeShape groundBox;
    groundBox.Set(b2Vec2(-8.98,0.48), b2Vec2(+8.98,0.48));
    nextloc=b2Vec2(groundBody->GetPosition().x+8.98+3,0);
    
    groundBody->CreateFixture(&groundBox,0);
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
    NSSet *allTouches= [event allTouches];
    
    for (UITouch * touch in allTouches)
    {
        
    }
}

-(void)tick:(ccTime) dt
{    
    
    if ([player1 footPosition] > terrainY + 0.1)
        isGrounded=false;
    else isGrounded=true;
    
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
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    //printf("Player Position %f  Terrain Position %f \n",[player1 getPosition].x,nextloc.x * ptm_ratio);
    if ([player1 getPosition].x>jumpPos) {
        jumpPos += 1342;
        [player1 playerJumps ];
    }
    
    if([player1 getPosition].x>nextloc.x * ptm_ratio - screenSize.width)
    {  
        //printf("Creating terrain @Player Position %f  when terrain is %f \n",[player1 getPosition].x,nextloc.x * ptm_ratio - screenSize.width);
        [self createTerrain];
    }    
    
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{   
		if (b->GetUserData()!=NULL)
        {   
            
            CCSprite *myActor = (CCSprite*)b->GetUserData();
            myActor.position = CGPointMake( b->GetPosition().x * ptm_ratio, b->GetPosition().y * ptm_ratio);
            myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        }
    }    
}

- (void) dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}

@end
