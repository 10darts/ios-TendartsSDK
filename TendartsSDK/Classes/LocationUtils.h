//
//  LocationUtils.h
//  sdk
//
//  Created by Jorge Arimany on 19/6/17.
//  Copyright © 2017 10Darts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationUtils : NSObject



+(void) startUpdating;
+(void) stopUpdating;



+ (BOOL)isDiferentCountry:(NSString *)codeCountry;
+ (NSString *)getCurrentCity;
+ (NSString *)getLocationChangedNotificationId;
+ (NSDictionary *)getLocationData;
@end
