
#import <UIKit/UIKit.h>

#import "TDUtils.h"
#import "LocationUtils.h"

NSString* const TD_VERSION = @"1.2.1";

@implementation TDUtils

+ (float)iOSVersion {
    return [[[UIDevice currentDevice] systemVersion] floatValue] ;
}

+ (NSString *)sdkVersion {
    return TD_VERSION;
}

+ (NSString *)platform {
#if DEBUG
    return @"ios_sandbox";
#endif
    return @"ios";
}

+ (NSString *)deviceURI:(NSString *)aCode {
    return [NSString stringWithFormat:@"/api/v1/devices/%@/", aCode];
}

+ (NSString *)currentLanguage {
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    return [language substringToIndex:2];
}

+ (NSDictionary *)location {
    return [LocationUtils getLocationData];
}

+ (BOOL)isRemoteNotificationsDisabled {
    #if !(IN_APP_EXTENSION)
    return ![[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    #endif
    return false;
}


@end
