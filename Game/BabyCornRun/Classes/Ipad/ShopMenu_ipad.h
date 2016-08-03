

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ShopMenu_ipad : CCLayer {
    
    CCMenu *menu;    
    CCMenuItem *rate;
    CCMenuItem *buyLives;

#ifdef FREE_VERSION
    CCMenuItem *removeAds;
    CCSprite *disableRemoveAds;  
#endif
    
    CCSprite *disableBuyLives;
      
}
+(id)scene:(bool)mainmenu;
@end
