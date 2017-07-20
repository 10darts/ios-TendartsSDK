//
//  Configuration.h
//  sdk
//
//  Created by Jorge Arimany on 5/7/17.
//  Copyright © 2017 10Darts. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface TDConfiguration : NSObject

/**
 Method name: saveAPIKey
 Description: Saves the API key
 Parameters:  apiKey: the API key to store
 */
+(void) saveAPIKey: (NSString*) apiKey;

+(NSString*) getAPIKey;

+(void) savePushToken: (NSString*) pushToken;
+(NSString*) getPushToken;

+(void) savePushCode: (NSString*) pushCode;
+(NSString*) getPushCode;

+(void) saveTokenAndVersion: (NSString*) tokenAndVersion;
+(NSString*) getTokenAndVersion;

+(void) saveUserCode: (NSString*) userCode;
+(NSString*) getUserCode;

+(void) saveLastGeostatsSent: (NSDate*) date;
+(NSDate*) getLastGeostatsSent;


@end
