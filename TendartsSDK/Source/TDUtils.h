
#import <Foundation/Foundation.h>

@interface TDUtils : NSObject

+ (float)getIOSVersion;
+ (NSString *)getPlatform;
+ (NSString *)getCurrentLanguage;
+ (NSDictionary *)getLocation;

@end
