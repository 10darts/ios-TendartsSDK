
#import <Foundation/Foundation.h>

@interface TDUtils : NSObject

+ (float)getIOSVersion;
+ (NSString *)getPlatform;
+ (NSString *)getDeviceURI:(NSString *)aCode;
+ (NSString *)getCurrentLanguage;
+ (NSDictionary *)getLocation;

@end
