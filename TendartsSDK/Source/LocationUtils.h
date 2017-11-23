
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationUtils : NSObject

+ (void)startUpdating;
+ (void)stopUpdating;
+ (BOOL)isDiferentCountry:(NSString *)codeCountry;
+ (NSString *)getCurrentCity;
+ (NSString *)getLocationChangedNotificationId;
+ (NSDictionary *)getLocationData;

@end
