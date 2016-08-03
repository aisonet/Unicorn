
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LoadingLayer : CCLayer {
    NSMutableArray *textures;
    int numberOfLoadedTextures;

}

@property (nonatomic, retain) NSMutableArray *textures;

+ (id)scene;

@end
