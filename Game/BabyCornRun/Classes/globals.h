#import "cocos2d.h"
#import <Foundation/Foundation.h>

#ifndef babycornrun_globals_h
#define babycornrun_globals_h

#define SHImageString(str)	({ UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ?	([NSString stringWithFormat:@"%@.png", (str)]) : ([NSString stringWithFormat:@"%@-ipad.png", (str)]); })

#define OBSTACLE_TAG 45
#define ENEMY_TAG 25
#define FRUIT_TAG 35
#define TERRAIN_TAG 55
#define PLAYER_TAG 0

#define ENEMY_ZORDER 100
#define FRUIT_ZORDER 50

#define BLINK_INTERVAL 5
#define MAX_LIFES 4

//#define FREE_VERSION 1

enum {
	kTagHalfMarathon = 1,
	kTagPopMarathon = 2,
	kTagAvoidHarvest = 3,
    kTagAmaizing = 4,
    kTagKernelYesSir = 5,
    kTagNumber1Crop = 6,
    kTagPostCorn = 7,
    kTagTweetCorn = 8,
    kTagRateCorn = 9,
};

enum {
    kTagStartWith10Lives = 1,
    kTagBuy1Revive = 2,
    kTagBuy3Revives = 3,
    kTagRemoveAds = 4,
};

extern CGFloat g_fx;
extern CGFloat g_fy;

extern CGSize g_mySize;

extern int  numFootContacts;
extern bool isGrounded;
extern bool pressedUp;
extern bool pressedDown;
extern int prevObstacle;
extern int isInvisible;
extern int additionalSpeed;
extern int runMeters;
extern int countTime2;
extern bool isPlayerRunning;

extern int lifesLeft;
extern bool isDead;
extern int bestScore;
extern bool isPaused;
extern int revivesLeft;
extern int blinkTimer;
extern bool backSoundOn;
extern bool effectsoundOn;
extern bool shownHowToPlay;
extern bool isFirstMain;;
extern bool isFromMain;

extern bool isProgressBuy;
extern int ptm_ratio;

static inline NSString *res(NSString * data)
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		return [data stringByReplacingOccurrencesOfString:@"." withString:@"-ipad."];
	}
	else
	{
        if( CC_CONTENT_SCALE_FACTOR() == 2 )
            return [data stringByReplacingOccurrencesOfString:@"." withString:@"-hd."];
        else
            return data;
	}
}

#endif
