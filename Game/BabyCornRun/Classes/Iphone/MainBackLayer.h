

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

@class Player;
#import "GLES-Render.h"
#import "ContactListener.h"

@interface MainBackLayer : CCLayer {
    
    b2World * world;    
    Player *player1;
    GLESDebugDraw *m_debugDraw;   
    CCTexture2D *groundTex;
    ContactListener * _contactListener;
    b2Vec2  nextloc;
    float terrainY;
    int jumpPos;
    bool isLoadedData;
}

+(CCScene *) scene;
-(void)createWorld;
-(void)createTerrain;

@end