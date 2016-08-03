

#import "LoadingLayer_ipad.h"
#import "MainMenu_ipad.h"
#import "FullLayer_ipad.h"
#import "globals.h"

@implementation LoadingLayer_ipad

@synthesize textures;

+ (id)scene
{
	CCScene *scene = [CCScene node];
    LoadingLayer_ipad *layer = [LoadingLayer_ipad node];
    
    [scene addChild:layer];
    
    return scene;
}

- (id)init
{
    if ((self = [super init]))
    {   
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        bestScore=[prefs integerForKey:@"bestscore"];
        
        CCSprite *background = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"bg1-ipad.png"]];
        background.position = ccp(512, 384);
        
        [self addChild:background z:0];
    }
    
    return self;
}

- (void)onEnter
{
    [super onEnter];
    
	self.textures = [NSMutableArray arrayWithCapacity:0];
    
    [textures addObject:@"stage4-hd.png"];            

	numberOfLoadedTextures = 0;
	[[CCTextureCache sharedTextureCache] addImageAsync:[textures objectAtIndex:numberOfLoadedTextures] target:self selector:@selector(imageDidLoad:)];
}

- (void) imageDidLoad:(CCTexture2D*)tex 
{
	NSString *plistFile = [[(NSString*)[textures objectAtIndex:numberOfLoadedTextures] stringByDeletingPathExtension] stringByAppendingString:@".plist"];
    
	//if([[NSFileManager defaultManager] fileExistsAtPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:plistFile]]) 
    //{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:plistFile];
    NSLog(@"loading %@", plistFile);
	//}
    
	numberOfLoadedTextures++;
    
	if(numberOfLoadedTextures == [textures count]) 
    {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:3 scene:[MainMenu_ipad scene] withColor:ccBLACK]];
	} 
    
    else 
    {
		[[CCTextureCache sharedTextureCache] addImageAsync:[textures objectAtIndex:numberOfLoadedTextures] target:self selector:@selector(imageDidLoad:)];
	}
}

- (void) dealloc 
{    
    [textures release];
    
    [super dealloc];
}

@end
