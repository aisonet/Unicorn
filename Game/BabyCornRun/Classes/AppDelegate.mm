
#import "cocos2d.h"

#import "AppDelegate.h"
#import "GameConfig.h"
#import "LoadingLayer.h"
#import "LoadingLayer_ipad.h"
#import "RootViewController.h"
#import "globals.h"
#import <RevMobAds/RevMobAds.h>
#import <RevMobAds/RevMobAdvertiser.h>
#import "MKStoreManager.h"
#import "Appirater.h"
#import <Parse/Parse.h>
#import "Flurry.h"
#import "ALSdk.h"

#define REVMOB_ID  @"52cae47216d5e3c4b5000013"

#define CHARTBOOST_APPID @"52cae48af8975c3011fbedeb"
#define CHARTBOOST_APPSIGNATURE @"8ca01558bd48be77205bcde110f49fd0fface0a2"

#define FB_APP_ID @"374810365923894"
#define FB_APP_SECRET @"d840eec816ab02e5daa70fbe8fef3860"

@implementation AppDelegate

@synthesize window;
@synthesize m_pSoundEngine, m_nbgvol, m_neffvol, NagScreen;
@synthesize viewController;
@synthesize cb;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	
		CC_ENABLE_DEFAULT_GL_STATES();
		CCDirector *director = [CCDirector sharedDirector];
		CGSize size = [director winSize];
		CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
		sprite.position = ccp(size.width/2, size.height/2);
		sprite.rotation = -90;
		[sprite visit];
		[[director openGLView] swapBuffers];
		CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}


-(void)initiAdBanner
{
    return;
    
}

#pragma mark - Animation

-(void)hideBanner:(UIView*)banner
{
    return;
    if (banner &&
        ![banner isHidden])
    {    }
}

-(void)showBanner:(UIView*)banner
{
    return;
    
}


#pragma mark -



- (void) applicationDidFinishLaunching:(UIApplication*)application
{
    
    [ALSdk initializeSdk];

    
    [RevMobAds startSessionWithAppID:REVMOB_ID];
    [RevMobAds session].userGender = RevMobUserGenderFemale;
    [RevMobAds session].userAgeRangeMax = 14;
    [RevMobAds session].userAgeRangeMin = 2;
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"GameOverCounter"];

    
    [Appirater setAppId:@"869718364"];
    [Appirater setDaysUntilPrompt:5];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setTimeBeforeReminding:10];
    
    
    cb = [Chartboost sharedChartboost];
    
    cb.appId = CHARTBOOST_APPID;
    cb.appSignature = CHARTBOOST_APPSIGNATURE;
    
    [cb startSession];
    
    if (![MKStoreManager featureAPurchased])
    {
        [ALInterstitialAd showOver:[[UIApplication sharedApplication] keyWindow]];

        
    }
    
    //[Parse setApplicationId:@"N7V2vhHQ6vlno283KtxgYgSQBnEBiKMltCFwROo9" clientKey:@"1aQwqq5Q4clOEvWIWjHYIlrhFDNT7QyI8LfLgVHh"];

	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
    if ([UIScreen mainScreen].scale==2.0f && (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
    {
        NSLog(@"On ipad and Scale is 2.0");
    }
    else
    {
        if( ! [director enableRetinaDisplay:YES] )
        	CCLOG(@"Retina Display Not supported");
    }
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
	//[director setDisplayFPS:YES];	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
    [application registerForRemoteNotificationTypes: UIRemoteNotificationTypeAlert];
    
    
    
	// make the View Controller a child of the main window
//	[window addSubview: viewController.view];
	[self.window setRootViewController:viewController];
    
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
	// Removes the startup flicker
	[self removeStartupFlicker];
    
    revivesLeft = 0;
    shownHowToPlay = false;  
    m_neffvol = m_nbgvol = 50;
    backSoundOn = true;
    effectsoundOn = true;
    isFirstMain = true;
    NagScreen=TRUE;
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//        ptm_ratio = 64;
//    else
        ptm_ratio = 32;
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
	{
		g_fx = 1.0f;
		g_fy = 1.0f;
	}
	else
	{
		g_fx = 1024.0/480.0;
		g_fy = 768.0/320.0;
	}
	
	g_mySize = [director winSize];    
	
	//sound
	m_pSoundEngine = [SimpleAudioEngine sharedEngine];
	[[CDAudioManager sharedManager] setResignBehavior:kAMRBStopPlay autoHandle:YES];
	
	
    [[CCDirector sharedDirector] runWithScene: [LoadingLayer scene]];
    
    
    [MKStoreManager sharedManager];
    
    
    if([MKStoreManager featureAPurchased] == NO) {
        [self showChartBoostFullScreen];
        //applovin
        [self showRevmobFullScreen];
        
        [ALInterstitialAd showOver:[[UIApplication sharedApplication] keyWindow]];

    }

        

    //[Flurry startSession:@"3RKT82Q3RNMRKG9NPKGX"];

}

-(void)showMoreGames{
    
    self.link = [[RevMobAds session] adLink];
    [self.link openLink];
    
    
}

#pragma  mark -

-(void)checkPushMessageForUrl:(NSString*)message{
    
    //    NSArray *comp = [message componentsSeparatedByString:@"www"];
    //    if ([comp count] > 1) {
    //        NSString *url = [NSString stringWithFormat:@"http://www%@", [comp objectAtIndex:1]];
    //        NSLog(@"opening URL: %@", url);
    //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    //    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
	}
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
//    [PFPush storeDeviceToken:deviceToken];
//    [PFPush subscribeToChannelInBackground:@"" target:self selector:@selector(subscribeFinished:error:)];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //[PFPush handlePush:userInfo];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    
    // Check for previous failures
    //    if ([challenge previousFailureCount] > 0) {
    //        // We've already tried - a touch is incorrect with our credentials
    //        NSLog(@"Urban Airship credentials invalid");
    //        return;
    //    }
    
    // Send our Urban Airship credentials
    
    //developement
    //#ifdef FREE_VERSION
    //    NSURLCredential *airshipCredentials = [NSURLCredential credentialWithUser:@"0Krjx31tQAGfgs2PzFCVhQ"/*App Key*/
    //                                                                     password:@"C-QA7G7QR9GAJ_dcU6Fm3Q"/*App Secret*/
    //                                                                  persistence:NSURLCredentialPersistenceNone];
    //#else
    //    NSURLCredential *airshipCredentials = [NSURLCredential credentialWithUser:@"ZLz3g5J_TXyH5vahXW-95A"/*App Key*/
    //                                                                     password:@"Zr328s7ERC-oK8efYQehsQ"/*App Secret*/
    //                                                                  persistence:NSURLCredentialPersistenceNone];
    //#endif
    
    //production
    //#ifdef FREE_VERSION
    //    NSURLCredential *airshipCredentials = [NSURLCredential credentialWithUser:@"Lpmn2n4jSgCvlG_vI5lDDw"/*App Key*/
    //                                                                     password:@"uClBCWCxR9i0VOEHlY261w"/*App Secret*/
    //                                                                  persistence:NSURLCredentialPersistenceNone];
    //#else
    //    NSURLCredential *airshipCredentials = [NSURLCredential credentialWithUser:@"kYFz3KfsRR2SH-SO_By_KQ"/*App Key*/
    //                                                                     password:@"crvzAd77SBq8eiyqcCndgg"/*App Secret*/
    //                                                                  persistence:NSURLCredentialPersistenceNone];
    //#endif
    //
    //
    //    [[challenge sender] useCredential:airshipCredentials forAuthenticationChallenge:challenge];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    // NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    // NSLog(@"%@", returnString); 
}

#pragma  mark -

- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
//    NSString *revMobId = @"522587a20218125835000005";
//    [RevMobAds showFullscreenAdWithAppID:revMobId withViewController:self.viewController];
    
    
    
    
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
    [Appirater appEnteredForeground:YES];

	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

+(AppDelegate*) get {
	return (AppDelegate*) [[UIApplication sharedApplication] delegate];
}

- (void)dealloc {
    
    [SimpleAudioEngine end];
	[m_pSoundEngine release];
    
	[[CCDirector sharedDirector] end];
	[window release];
	[super dealloc];
}

#pragma mark REvMOb

-(void)showChartBoostFullScreen{

    [[Chartboost sharedChartboost]showInterstitial];
    
}
-(void)showRevmobFullScreen{
    
    [[RevMobAds session] showFullscreen];
    
}
-(void)dispMoreGames
{
    [[Chartboost sharedChartboost]showInterstitial];

    //[cb showMoreApps];
       // [RevMobAds openAdLink];
}

#pragma mark FaceBook

- (void)    FacebookLogin
{
    
}

- (void)    FacebookLogOut
{
}

- (void)    UploadPhotoToFacebook
{    
    
}

#pragma mark FaceBookDelegate Method

-(void)fbDidLogin
{
    
}

-(void)fbDidLogout
{
    
	
}

-(void)fbDidNotLogin:(BOOL)cancelled
{
    	
	
}


@end
