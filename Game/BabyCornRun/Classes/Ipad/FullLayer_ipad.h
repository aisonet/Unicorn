

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface FullLayer_ipad : CCLayer {
    CCLabelTTF *loading;
}
+(id)scene;
-(void)addHudLayer_ipad;
-(void)pauseSchedulerAndActionsRecursive:(CCNode *)node;
-(void)resumeSchedulerAndActionsRecursive:(CCNode *)node;
@end
