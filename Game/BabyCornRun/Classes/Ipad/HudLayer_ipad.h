
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HudLayer_ipad : CCLayer {
    CCSprite *pauseButton;
    int runMeter;
    CCLabelTTF *scoreCnt;
    CCLabelTTF *lifeCnt;
}

+(id)scene;
-(void)updateLifes;
-(void)countScore;

@end
