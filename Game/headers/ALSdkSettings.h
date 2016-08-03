//
//  ALSdkSettings.h
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * This class contains settings for AppLovin SDK.
 *
 * @version 1.0
 */
@interface ALSdkSettings : NSObject 

/**
 * Toggle verbose logging of AppLovin SDK. 
 * 
 * If enabled AppLovin messages will appear in standard application log accessible via logcat. 
 * All log messages will have "AppLovinSdk" tag.
 * 
 * Verbose logging is <i>disabled</i> by default.
 * 
 * @param isVerboseLoggingEnabled True if log messages should be output. 
 */
@property (assign, nonatomic) BOOL isVerboseLogging;


/**
 * Defines sizes of ads that should be automatically preloaded.
 * <p>
 * Auto preloading is enabled for <i>BANNER,INTER</i> by default.
 *
 * @param autoPreloadAdSizes Comma-separated list of sizes to preload. For example: "BANNER,INTER"
 */
@property (retain, nonatomic) NSString * autoPreloadAdSizes;

@end
