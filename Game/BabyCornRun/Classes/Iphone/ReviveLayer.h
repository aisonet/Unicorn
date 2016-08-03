

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

@interface ReviveLayer : CCLayer {
    
    CCSprite *life;
    CCLabelTTF *timerCnt;  
    CCLabelTTF *reviveCnt; 
}
+(id)scene;
@end
