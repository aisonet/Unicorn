

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "globals.h"

#ifdef FREE_VERSION
#import "RootViewController.h"
#endif

#ifdef FREE_VERSION
@interface GameOver_ipad : CCLayer
#else
@interface GameOver_ipad : CCLayer
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

@property (nonatomic, retain) CCLabelTTF *bestscoreLabel;
@property (nonatomic, retain) CCLabelTTF *scoreLabel;

@end
