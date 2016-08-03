

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "globals.h"

#ifdef FREE_VERSION
#import "RootViewController.h"
#endif

#ifdef FREE_VERSION
@interface MainMenu_ipad : CCLayer
#else
@interface MainMenu_ipad : CCLayer
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
@property(nonatomic,retain) AdWhirlView *adView;
#endif

+(CCScene *) scene;
-(void)setData:(NSString *)message items:(NSMutableArray *)items Tag:(int)tag;
-(void)AddNagScreen;

@end
