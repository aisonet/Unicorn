

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "ContactListener.h"

@class Player,BackgroundLayer;

@interface GameLayer : CCLayer {
    bool isFirstTerrain;
    BackgroundLayer *background;
    b2World * world;    
    Player *player1;
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
    CGRect pause;
    
    int nnn;
}

@property (nonatomic, retain) NSMutableArray *groundTextures;

+(id)scene;
-(void)createWorld;
-(void)createTerrain;
-(void) addRamp:(CGPoint) startPosition;

-(void) actionPause;
@end
