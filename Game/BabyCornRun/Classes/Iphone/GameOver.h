

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "globals.h"
#import <RevMobAds/RevMobAds.h>
#import "MKStoreManager.h"



#ifdef FREE_VERSION
#import "RootViewController.h"
#endif

#ifdef FREE_VERSION
@interface GameOver : CCLayer 
#else
@interface GameOver : CCLayer
#endif
{
    CCMenu *menu;
    
    CGSize screenSize;
    
#ifdef FREE_VERSION
    RootViewController *viewController;
    
    CCSprite *adsbox;
    CCSprite *noads;
    bool removeads;
    
#endif
    
}

#ifdef FREE_VERSION
#endif

+(CCScene *) scene;

@property (nonatomic, retain) CCLabelAtlas *bestscoreLabel;
@property (nonatomic, retain) CCLabelAtlas *scoreLabel;

@end
