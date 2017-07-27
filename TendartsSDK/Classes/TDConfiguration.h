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
+(void) saveAPIKey: (NSString*_Nonnull) apiKey;

+(NSString*_Nullable) getAPIKey;

+(void) savePushToken: (NSString*_Nonnull) pushToken;
+(NSString*_Nullable) getPushToken;

+(void) savePushCode: (NSString*_Nonnull) pushCode withApiKey: (NSString* _Nonnull) apiKey;
+(NSString*_Nullable) getPushCodeWithApiKey: (NSString* _Nonnull) apiKey;
+(NSString*_Nullable) getPushCode;

+(void) saveTokenAndVersion: (NSString*_Nonnull) tokenAndVersion;
+(NSString*_Nullable) getTokenAndVersion;

+(void) saveUserCode: (NSString*_Nonnull) userCode;
+(NSString*_Nullable) getUserCode;

+(void) saveLastGeostatsSent: (NSDate*_Nonnull) date;
+(NSDate*_Nullable) getLastGeostatsSent;


@end
