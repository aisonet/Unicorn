

#import "LoadingLayer.h"
#import "MainMenu.h"
#import "FullLayer.h"
#import "globals.h"
#import "MKStoreManager.h"
#import "AppDelegate.h"

@implementation LoadingLayer

@synthesize textures;

+ (id)scene
{
	CCScene *scene = [CCScene node];
    LoadingLayer *layer = [LoadingLayer node];
    
    [scene addChild:layer];
    
    return scene;
}

- (id)init
{
    if ((self = [super init]))
    {
        

        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        bestScore=[prefs integerForKey:@"bestscore"];
        
        
        //[[UIScreen mainScreen] bounds].size
        
        CCSprite *background;
        if([[UIScreen mainScreen] bounds].size.height==568)
            background= [CCSprite spriteWithFile:res(@"bg1-iphone5.png")];
        else
            background= [CCSprite spriteWithFile:res(@"bg1.png")];
        
        background.anchorPoint=ccp(0,0);
        
        [self addChild:background z:0];
    }
    
    return self;
}

- (void)onEnter
{
    [super onEnter];
    
	self.textures = [NSMutableArray arrayWithCapacity:0];
    
    [textures addObject:res(@"stage4.png")];            

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
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:3 scene:[MainMenu scene] withColor:ccBLACK]];
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
