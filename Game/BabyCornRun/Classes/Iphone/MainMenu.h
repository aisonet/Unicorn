

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "globals.h"
#import "StoreKit/StoreKit.h"

#ifdef FREE_VERSION
#import "RootViewController.h"
#endif

#ifdef FREE_VERSION
@interface MainMenu : CCLayer
#else
@interface MainMenu : CCLayer<SKPaymentTransactionObserver>
#endif
{

    CCMenu *menu;
    CCSprite *backSoundoff;
    CCSprite *effectSoundoff;
    
    UIView *NagView;
    NSMutableArray *nagArray;
    
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
-(void)setData:(NSString *)message items:(NSMutableArray *)items Tag:(int)tag;
-(void)AddNagScreen;

@end
