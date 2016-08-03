

#import <Foundation/Foundation.h>
#import "cocos2d.h"

enum {
    kTagCloud1 = 0,
    kTagCloud2 = 1,
    kTagCloud3 = 2,
    kTagCloud4 = 3,
    kTagCloud5 = 4,    
};

@interface BackgroundLayer_ipad : CCLayer {
    
    CCSprite *cloud1;
    CCSprite *cloud2;
    CCSprite *cloud3;
    CCSprite *cloud4;
    CCSprite *cloud5;
}
+(id)scene;
-(void)updateWithPlayerPosition :(CGPoint) lastPosition :(CGPoint) currentPosition;
@end

