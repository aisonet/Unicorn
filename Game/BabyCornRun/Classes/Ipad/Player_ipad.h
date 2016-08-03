

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

@interface Player_ipad : CCLayer {
    
    CCSprite *playerSprite;
    CCAction *walkAction,*jumpAction,*hurtAction;
    b2FixtureDef fixtureDef;
    b2Body *body ;    
    b2Fixture *actualBody;
}
- (id)initWithWorld:(b2World *)world;
- (void)followWithCameraFromLayer: (CCLayer *)layer;
- (void)updatePlayer;
-(void)playerJumps;
-(void)playerDoubleJumps;
-(void)playerHurt: (float)duration;
-(void)playerHurtJumps;
-(CGPoint)getPosition;
-(BOOL)footPosition;
-(void)blink:(BOOL)isBlink;
@property (nonatomic, retain) CCSprite *playerSprite;
@property (nonatomic, retain) CCAction *walkAction;
@property (nonatomic, retain) CCAction *jumpAction;
@property (nonatomic, retain) CCAction *hurtAction;


@end
