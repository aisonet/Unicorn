
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HudLayer : CCLayer {
    //CCSprite *pauseButton;
    int runMeter;
    CCLabelAtlas *scoreCnt;
    CCLabelTTF *lifeCnt;
}

+(id)scene;
-(void)updateLifes;
-(void)countScore;

@end
