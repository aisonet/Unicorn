

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "ContactListener.h"

@class Player_ipad,BackgroundLayer_ipad;

@interface GameLayer_ipad : CCLayer {
    bool isFirstTerrain;
    BackgroundLayer_ipad *background;
    b2World * world;    
    Player_ipad *player1;
    GLESDebugDraw *m_debugDraw;   
    ContactListener * _contactListener;
    b2Vec2  nextloc;
    float terrainX;
    int visibleCnt;
    bool isPlayerJump;
    NSMutableArray *groundTextures;
    bool isLoadedData;
    int invisibleCnt;
    CGPoint lastposition;
    CGPoint currentposition;
}

@property (nonatomic, retain) NSMutableArray *groundTextures;

+(id)scene;
-(void)createWorld;
-(void)createTerrain;
-(void) addRamp:(CGPoint) startPosition;


@end
