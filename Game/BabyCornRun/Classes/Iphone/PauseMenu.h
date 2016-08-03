

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import <RevMobAds/RevMobAds.h>
#import "MKStoreManager.h"

@interface PauseMenu : CCLayer {
    
    CCMenu *menu; 
    CCSprite *backSoundoff;
    CCSprite *effectSoundoff;
}
+(id)scene;
@end
