
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface FullLayer : CCLayer {
    CCSprite *loading;
}
+(id)scene;
-(void)addHudLayer;
-(void)pauseSchedulerAndActionsRecursive:(CCNode *)node;
-(void)resumeSchedulerAndActionsRecursive:(CCNode *)node;
@end
