


#import <UIKit/UIKit.h>
#import "SimpleAudioEngine.h"
//#import "RevMobAds.h"
#import <RevMobAds/RevMobAdsDelegate.h>
#import "Chartboost.h"
#import <RevMobAds/RevMobAds.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate,RevMobAdsDelegate, ChartboostDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    
    SimpleAudioEngine *m_pSoundEngine;
    
    //IAP
    UIAlertView			*loadingView;

    NSString           *selectedIdentifier;
    BOOL NagScreen;
    
    Chartboost *cb;
    
    NSArray*    _permissions;

    // Declare one as an instance variable

}

@property (nonatomic, retain)RevMobAdLink *link;


@property(readwrite)BOOL NagScreen;

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, assign) int m_nbgvol;
@property (nonatomic, assign) int m_neffvol;
@property (readwrite, retain) SimpleAudioEngine *m_pSoundEngine;
@property (nonatomic, retain) RootViewController *viewController;

@property (nonatomic, retain) Chartboost *cb;

+(AppDelegate*) get;

-(void)showMoreGames;


#pragma mark REBMOV

-(void)dispMoreGames;

#pragma mark Facebook
- (void)    FacebookLogin;
- (void)    FacebookLogOut;
- (void)    UploadPhotoToFacebook;
-(void)showChartBoostFullScreen;
-(void)showRevmobFullScreen;

-(void) hideADS:(BOOL) flag;

@end
