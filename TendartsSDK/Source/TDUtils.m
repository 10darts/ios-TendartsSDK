
#import <UIKit/UIKit.h>

#import "TDUtils.h"
#import "LocationUtils.h"

@implementation TDUtils

+ (float)getIOSVersion {
    return [[[UIDevice currentDevice] systemVersion] floatValue] ;
}

+ (NSString *)getPlatform {
#if DEBUG
    return @"ios_sandbox";
#endif
    return @"ios";
}

+ (NSString *)getDeviceURI:(NSString *)aCode {
    return [NSString stringWithFormat:@"/api/v1/devices/%@/", aCode];
}

+ (NSString *)getCurrentLanguage {
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    return [language substringToIndex:2];
}

+ (NSDictionary *)getLocation {
    return [LocationUtils getLocationData];
}

@end

