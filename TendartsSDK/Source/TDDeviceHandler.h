//
//  TDDeviceHandler.h
//  Tendarts
//
//  Created by Ruben Blanco on 16/11/17.
//  Copyright © 2017 10darts. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TDSDKExtension.h"

@interface TDDeviceHandler : NSObject

+ (void) deviceToken:(NSString *)aToken
            language:(NSString *)aLanguage
             version:(NSString *)aVersion
               model:(NSString *)aModel
            platform:(NSString *)aPlatform
            location:(NSDictionary *)aLocation
               group:(NSString *)aGroup;

+ (void) location:(NSDictionary *)aLocation
         accuracy:(NSString *)aAccuracy
         pushCode:(NSString *)aPushCode ;

@end
