
#import "PushUtils.h"
#import <sys/utsname.h>
#import "TDConstants.h"
#import "TDUtils.h"
#import "TDConfiguration.h"
#import "TDDeviceHandler.h"

@implementation PushUtils

+ (void)savePushToken:(NSString *)token inSharedGroup:(NSString *)group {
	[TDConfiguration savePushToken: token];
    
    [self updateAPIDeviceToken: token inSharedGroup: group];
}

+ (void) updateAPIDeviceToken:(NSString *)token inSharedGroup:(NSString *)group{
    NSString *language = [TDUtils getCurrentLanguage];
    NSString *bundle = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *version = [NSString stringWithFormat:@"%@", bundle];
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *model = [NSString stringWithCString: systemInfo.machine
                                          encoding: NSUTF8StringEncoding];
    
    NSString *platform = [TDUtils getPlatform];
    NSDictionary *location = [TDUtils getLocation];
    
    [TDDeviceHandler deviceToken: token
                        language: language
                         version: version
                           model: model
                        platform: platform
                        location: location
                           group: group];
}

@end
