

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

@interface PauseMenu_ipad : CCLayer {
    
    CCMenu *menu; 
    CCSprite *backSoundoff;
    CCSprite *effectSoundoff;
}
+(id)scene;
@end
