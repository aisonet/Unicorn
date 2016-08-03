//
//  DebugSprite.h
//  PizzaFighter
//
//  Created by admin on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

@interface DebugSprite : CCSprite {
	b2World *m_world;	
	GLESDebugDraw *m_debugDraw;
}

-(id) initWithWorld:(b2World *)world;

@end
