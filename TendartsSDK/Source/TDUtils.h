
#import <Foundation/Foundation.h>

@interface TDUtils : NSObject

+ (float)iOSVersion;
+ (NSString *)platform;
+ (NSString *)sdkVersion;
+ (NSString *)deviceURI:(NSString *)aCode;
+ (NSString *)currentLanguage;
+ (NSDictionary *)location;
+ (BOOL)isRemoteNotificationsDisabled;

@end
