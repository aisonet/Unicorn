//
//  DebugSprite.m
//  PizzaFighter
//
//  Created by admin on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DebugSprite.h"
#import "globals.h"

@implementation DebugSprite

-(id) initWithWorld:(b2World *)world
{
	if ((self = [super init])) {
		m_world = world;
		m_debugDraw = new GLESDebugDraw( ptm_ratio );
		m_world->SetDebugDraw(m_debugDraw);
		
		uint32 flags = 0;
		flags += b2Draw::e_shapeBit;
		//		flags += b2DebugDraw::e_jointBit;
		//		flags += b2DebugDraw::e_aabbBit;
		//		flags += b2DebugDraw::e_pairBit;
		//		flags += b2DebugDraw::e_centerOfMassBit;
		m_debugDraw->SetFlags(flags);		
	}
	
	return self;
}

-(void) dealloc
{
	delete m_debugDraw;
	
	[super dealloc];
}

-(void) draw
{
	[super draw];
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	m_world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
}


@end
